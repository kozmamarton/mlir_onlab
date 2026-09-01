#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <iomanip>
#include <iostream>
#include <limits>
#include <stdexcept>
#include <string>
#include <vector>

#include <cuda_runtime.h>

namespace {

constexpr int kRows = 4096;
constexpr int kColumns = 4096;
constexpr int kLevels = 20;
constexpr int kSamples = 10;
constexpr dim3 kThreadsPerBlock{32, 8};

void check_cuda(cudaError_t status, const char* operation)
{
	if (status != cudaSuccess) {
		throw std::runtime_error(std::string(operation) + ": " + cudaGetErrorString(status));
	}
}

std::size_t checked_product(std::size_t left, std::size_t right, const char* name)
{
	if (left > std::numeric_limits<std::size_t>::max() / right) {
		throw std::overflow_error(std::string(name) + " exceeds size_t");
	}
	return left * right;
}

void print_first_10(const std::string& label, const std::vector<float>& values)
{
	const std::size_t count = std::min<std::size_t>(10, values.size());
	std::cout << label << " [0.." << (count == 0 ? 0 : count - 1) << "]: ";
	for (std::size_t index = 0; index < count; ++index) {
		std::cout << std::fixed << std::setprecision(6) << values[index];
		if (index + 1 != count) {
			std::cout << ", ";
		}
	}
	std::cout << '\n';
}

__device__ std::size_t index_2d(int i, int j, int im)
{
	return static_cast<std::size_t>(i) + static_cast<std::size_t>(j) * im;
}

__device__ std::size_t index_3d(int i, int j, int k, int im, int jm)
{
	return index_2d(i, j, im) + static_cast<std::size_t>(k) * im * jm;
}

__global__ void reduce_u_kernel(float* tps, const float* u, const float* dz, int im, int jm,
								int kbm1)
{
	const int i = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
	const int j = static_cast<int>(blockIdx.y * blockDim.y + threadIdx.y);
	if (i >= im || j >= jm) {
		return;
	}

	float sum = 0.0f;
	for (int k = 0; k < kbm1; ++k) {
		sum += u[index_3d(i, j, k, im, jm)] * dz[k];
	}
	tps[index_2d(i, j, im)] = sum;
}

__global__ void update_u_kernel(float* u, const float* tps, const float* utb, const float* utf,
								const float* dt, int im, int jm, int kbm1)
{
	const int i = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
	const int j = static_cast<int>(blockIdx.y * blockDim.y + threadIdx.y);
	const int k = static_cast<int>(blockIdx.z * blockDim.z + threadIdx.z);
	if (i == 0 || i >= im || j >= jm || k >= kbm1) {
		return;
	}

	const std::size_t surface_index = index_2d(i, j, im);
	const float correction = (utb[surface_index] + utf[surface_index]) /
		(dt[surface_index] + dt[index_2d(i - 1, j, im)]);
	const std::size_t volume_index = index_3d(i, j, k, im, jm);
	u[volume_index] = u[volume_index] - tps[surface_index] + correction;
}

__global__ void clear_tps_kernel(float* tps, int im, int jm)
{
	const int i = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
	const int j = static_cast<int>(blockIdx.y * blockDim.y + threadIdx.y);
	if (i < im && j < jm) {
		tps[index_2d(i, j, im)] = 0.0f;
	}
}

__global__ void reduce_v_kernel(float* tps, const float* v, const float* dz, int im, int jm,
								int kbm1)
{
	const int i = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
	const int j = static_cast<int>(blockIdx.y * blockDim.y + threadIdx.y);
	if (i >= im || j >= jm) {
		return;
	}

	float sum = 0.0f;
	for (int k = 0; k < kbm1; ++k) {
		sum += v[index_3d(i, j, k, im, jm)] * dz[k];
	}
	tps[index_2d(i, j, im)] = sum;
}

__global__ void update_v_kernel(float* v, const float* tps, const float* vtb, const float* vtf,
								const float* dt, int im, int jm, int kbm1)
{
	const int i = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
	const int j = static_cast<int>(blockIdx.y * blockDim.y + threadIdx.y);
	const int k = static_cast<int>(blockIdx.z * blockDim.z + threadIdx.z);
	if (i >= im || j == 0 || j >= jm || k >= kbm1) {
		return;
	}

	const std::size_t surface_index = index_2d(i, j, im);
	const float correction = (vtb[surface_index] + vtf[surface_index]) /
		(dt[surface_index] + dt[index_2d(i, j - 1, im)]);
	const std::size_t volume_index = index_3d(i, j, k, im, jm);
	v[volume_index] = v[volume_index] - tps[surface_index] + correction;
}

} // namespace

extern "C" void ext_adjust_u_v_cuda(float* tps, float* u, float* v, const float* dz,
								  const float* utb, const float* utf, const float* vtb,
								  const float* vtf, const float* dt, int im, int jm, int kbm1,
								  cudaStream_t stream)
{
	if (im <= 0 || jm <= 0 || kbm1 <= 0) {
		throw std::invalid_argument("im, jm, and kbm1 must be positive");
	}

	const dim3 grid_2d{static_cast<unsigned int>((im + kThreadsPerBlock.x - 1) / kThreadsPerBlock.x),
					  static_cast<unsigned int>((jm + kThreadsPerBlock.y - 1) / kThreadsPerBlock.y)};
	const dim3 threads_3d{16, 4, 4};
	const dim3 grid_3d{static_cast<unsigned int>((im + threads_3d.x - 1) / threads_3d.x),
					  static_cast<unsigned int>((jm + threads_3d.y - 1) / threads_3d.y),
					  static_cast<unsigned int>((kbm1 + threads_3d.z - 1) / threads_3d.z)};

	reduce_u_kernel<<<grid_2d, kThreadsPerBlock, 0, stream>>>(tps, u, dz, im, jm, kbm1);
	check_cuda(cudaGetLastError(), "reduce_u_kernel launch");
	update_u_kernel<<<grid_3d, threads_3d, 0, stream>>>(u, tps, utb, utf, dt, im, jm, kbm1);
	check_cuda(cudaGetLastError(), "update_u_kernel launch");
	clear_tps_kernel<<<grid_2d, kThreadsPerBlock, 0, stream>>>(tps, im, jm);
	check_cuda(cudaGetLastError(), "clear_tps_kernel launch");
	reduce_v_kernel<<<grid_2d, kThreadsPerBlock, 0, stream>>>(tps, v, dz, im, jm, kbm1);
	check_cuda(cudaGetLastError(), "reduce_v_kernel launch");
	update_v_kernel<<<grid_3d, threads_3d, 0, stream>>>(v, tps, vtb, vtf, dt, im, jm, kbm1);
	check_cuda(cudaGetLastError(), "update_v_kernel launch");
}

int main()
{
	try {
		const std::size_t surface_count = checked_product(kRows, kColumns, "surface element count");
		const std::size_t volume_count = checked_product(surface_count, kLevels, "volume element count");
		std::vector<float> host_tps(surface_count, 0.0f);
		std::vector<float> host_u(volume_count);
		std::vector<float> host_v(volume_count);
		std::vector<float> host_dz(kLevels);
		std::vector<float> host_utb(surface_count);
		std::vector<float> host_utf(surface_count);
		std::vector<float> host_vtb(surface_count);
		std::vector<float> host_vtf(surface_count);
		std::vector<float> host_dt(surface_count);

		for (std::size_t index = 0; index < surface_count; ++index) {
			const float x = static_cast<float>(index % kRows);
			const float y = static_cast<float>(index / kRows);
			host_utb[index] = 0.1f * x;
			host_utf[index] = 0.1f * x + 0.01f;
			host_vtb[index] = -0.2f * y;
			host_vtf[index] = -0.2f * y + 0.01f;
			host_dt[index] = std::sin(0.01f * static_cast<float>(index)) + 2.0f;
		}
		for (std::size_t index = 0; index < volume_count; ++index) {
			host_u[index] = std::sin(0.001f * static_cast<float>(index));
			host_v[index] = std::cos(0.001f * static_cast<float>(index));
		}
		for (int k = 0; k < kLevels; ++k) {
			host_dz[k] = 10.0f + static_cast<float>(k);
		}

		float *device_tps = nullptr, *device_u = nullptr, *device_v = nullptr, *device_dz = nullptr;
		float *device_utb = nullptr, *device_utf = nullptr, *device_vtb = nullptr, *device_vtf = nullptr;
		float* device_dt = nullptr;
		cudaStream_t stream = nullptr;
		const std::size_t surface_bytes = surface_count * sizeof(float);
		const std::size_t volume_bytes = volume_count * sizeof(float);

		check_cuda(cudaStreamCreate(&stream), "cudaStreamCreate");
		check_cuda(cudaMalloc(&device_tps, surface_bytes), "cudaMalloc(tps)");
		check_cuda(cudaMalloc(&device_u, volume_bytes), "cudaMalloc(u)");
		check_cuda(cudaMalloc(&device_v, volume_bytes), "cudaMalloc(v)");
		check_cuda(cudaMalloc(&device_dz, kLevels * sizeof(float)), "cudaMalloc(dz)");
		check_cuda(cudaMalloc(&device_utb, surface_bytes), "cudaMalloc(utb)");
		check_cuda(cudaMalloc(&device_utf, surface_bytes), "cudaMalloc(utf)");
		check_cuda(cudaMalloc(&device_vtb, surface_bytes), "cudaMalloc(vtb)");
		check_cuda(cudaMalloc(&device_vtf, surface_bytes), "cudaMalloc(vtf)");
		check_cuda(cudaMalloc(&device_dt, surface_bytes), "cudaMalloc(dt)");

		check_cuda(cudaMemcpyAsync(device_dz, host_dz.data(), kLevels * sizeof(float), cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(dz)");
		check_cuda(cudaMemcpyAsync(device_utb, host_utb.data(), surface_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(utb)");
		check_cuda(cudaMemcpyAsync(device_utf, host_utf.data(), surface_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(utf)");
		check_cuda(cudaMemcpyAsync(device_vtb, host_vtb.data(), surface_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(vtb)");
		check_cuda(cudaMemcpyAsync(device_vtf, host_vtf.data(), surface_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(vtf)");
		check_cuda(cudaMemcpyAsync(device_dt, host_dt.data(), surface_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(dt)");
		check_cuda(cudaStreamSynchronize(stream), "cudaStreamSynchronize(after constants)");

		std::cout << "\nInput snapshots (first 10 values each) (of " << surface_count << " total):\n";
		print_first_10("tps(before)", host_tps);
		print_first_10("u(before)", host_u);
		print_first_10("v(before)", host_v);

		std::int64_t elapsed_us_total = 0;
		for (int sample = 0; sample < kSamples; ++sample) {
			check_cuda(cudaMemcpyAsync(device_tps, host_tps.data(), surface_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(tps)");
			check_cuda(cudaMemcpyAsync(device_u, host_u.data(), volume_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(u)");
			check_cuda(cudaMemcpyAsync(device_v, host_v.data(), volume_bytes, cudaMemcpyHostToDevice, stream), "cudaMemcpyAsync(v)");
			check_cuda(cudaStreamSynchronize(stream), "cudaStreamSynchronize(after input copies)");

			const auto start = std::chrono::high_resolution_clock::now();
			ext_adjust_u_v_cuda(device_tps, device_u, device_v, device_dz, device_utb, device_utf,
								 device_vtb, device_vtf, device_dt, kRows, kColumns, kLevels, stream);
			check_cuda(cudaStreamSynchronize(stream), "cudaStreamSynchronize(after kernels)");
			const auto end = std::chrono::high_resolution_clock::now();
			elapsed_us_total += std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
		}

		check_cuda(cudaMemcpyAsync(host_tps.data(), device_tps, surface_bytes, cudaMemcpyDeviceToHost, stream), "cudaMemcpyAsync(tps from device)");
		check_cuda(cudaMemcpyAsync(host_u.data(), device_u, volume_bytes, cudaMemcpyDeviceToHost, stream), "cudaMemcpyAsync(u from device)");
		check_cuda(cudaMemcpyAsync(host_v.data(), device_v, volume_bytes, cudaMemcpyDeviceToHost, stream), "cudaMemcpyAsync(v from device)");
		check_cuda(cudaStreamSynchronize(stream), "cudaStreamSynchronize(after output copies)");

		const double elapsed_ms = static_cast<double>(elapsed_us_total) * 1.0e-3;
		const double average_elapsed_us = static_cast<double>(elapsed_us_total) / kSamples;
		std::cout << "\nNumber of kernel calls initiated: " << kSamples
				  << "\nGPU kernel call time: total: " << elapsed_us_total << " us (" << elapsed_ms
				  << " ms) average: " << average_elapsed_us << " us ("
				  << average_elapsed_us * 1.0e-3 << " ms)\n\n";
		std::cout << "Output snapshots (same buffers after kernel call, first 10 values each):\n";
		print_first_10("tps(after)", host_tps);
		print_first_10("u(after)", host_u);
		print_first_10("v(after)", host_v);

		check_cuda(cudaFree(device_tps), "cudaFree(tps)");
		check_cuda(cudaFree(device_u), "cudaFree(u)");
		check_cuda(cudaFree(device_v), "cudaFree(v)");
		check_cuda(cudaFree(device_dz), "cudaFree(dz)");
		check_cuda(cudaFree(device_utb), "cudaFree(utb)");
		check_cuda(cudaFree(device_utf), "cudaFree(utf)");
		check_cuda(cudaFree(device_vtb), "cudaFree(vtb)");
		check_cuda(cudaFree(device_vtf), "cudaFree(vtf)");
		check_cuda(cudaFree(device_dt), "cudaFree(dt)");
		check_cuda(cudaStreamDestroy(stream), "cudaStreamDestroy");
		return EXIT_SUCCESS;
	} catch (const std::exception& error) {
		std::cerr << "Error: " << error.what() << '\n';
		return EXIT_FAILURE;
	}
}

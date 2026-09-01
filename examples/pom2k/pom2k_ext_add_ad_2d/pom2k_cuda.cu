#include <cuda_runtime.h>

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

namespace {

constexpr int kDefaultIm = 16978;
constexpr int kDefaultJm = 16978;
constexpr int kDefaultSamples = 100;
constexpr dim3 kThreadsPerBlock{32, 4};

void check_cuda(cudaError_t status, const char* operation)
{
	if (status != cudaSuccess) {
		throw std::runtime_error(std::string(operation) + ": " + cudaGetErrorString(status));
	}
}

std::size_t checked_element_count(int im, int jm)
{
	if (im <= 0 || jm <= 0) {
		throw std::invalid_argument("im and jm must be positive");
	}

	const std::size_t im_count = static_cast<std::size_t>(im);
	const std::size_t jm_count = static_cast<std::size_t>(jm);
	if (im_count > std::numeric_limits<std::size_t>::max() / jm_count) {
		throw std::overflow_error("matrix element count overflows size_t");
	}
	return im_count * jm_count;
}

int parse_positive_int(const char* text, const char* name)
{
	char* end = nullptr;
	const long value = std::strtol(text, &end, 10);
	if (*text == '\0' || *end != '\0' || value <= 0 || value > std::numeric_limits<int>::max()) {
		throw std::invalid_argument(std::string(name) + " must be a positive integer");
	}
	return static_cast<int>(value);
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

__global__ void ext_add_ad_2d_kernel(float* adx2d, float* ady2d, const float* advua,
									 const float* advva, int im, int jm)
{
	const int i = static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x);
	const int j = static_cast<int>(blockIdx.y * blockDim.y + threadIdx.y);
	if (i < im && j < jm) {
		const std::size_t index = static_cast<std::size_t>(i) + static_cast<std::size_t>(j) * im;
		adx2d[index] -= advua[index];
		ady2d[index] -= advva[index];
	}
}

void ext_add_ad_2d(float* adx2d, float* ady2d, const float* advua, const float* advva,
				   int im, int jm)
{
	const std::size_t grid_x =
		(static_cast<std::size_t>(im) + kThreadsPerBlock.x - 1) / kThreadsPerBlock.x;
	const std::size_t grid_y =
		(static_cast<std::size_t>(jm) + kThreadsPerBlock.y - 1) / kThreadsPerBlock.y;
	if (grid_x > std::numeric_limits<unsigned int>::max() ||
		grid_y > std::numeric_limits<unsigned int>::max()) {
		throw std::overflow_error("CUDA grid dimension exceeds the supported range");
	}

	const dim3 grid{static_cast<unsigned int>(grid_x), static_cast<unsigned int>(grid_y)};
	ext_add_ad_2d_kernel<<<grid, kThreadsPerBlock>>>(adx2d, ady2d, advua, advva, im, jm);
	check_cuda(cudaGetLastError(), "ext_add_ad_2d_kernel launch");
}

} // namespace

int main(int argc, char* argv[])
{
	try {
		const int im = argc > 1 ? parse_positive_int(argv[1], "im") : kDefaultIm;
		const int jm = argc > 2 ? parse_positive_int(argv[2], "jm") : kDefaultJm;
		const int samples = argc > 3 ? parse_positive_int(argv[3], "samples") : kDefaultSamples;
		if (argc > 4) {
			throw std::invalid_argument("usage: pom2k_cuda [im] [jm] [samples]");
		}

		const std::size_t element_count = checked_element_count(im, jm);
		std::vector<float> host_adx2d(element_count);
		std::vector<float> host_ady2d(element_count);
		std::vector<float> host_advua(element_count);
		std::vector<float> host_advva(element_count);

		for (std::size_t index = 0; index < element_count; ++index) {
			const float x = static_cast<float>(index % static_cast<std::size_t>(im));
			const float y = static_cast<float>(index / static_cast<std::size_t>(im));
			host_adx2d[index] = 0.1f * x;
			host_ady2d[index] = -0.2f * y;
			host_advua[index] = std::sin(0.01f * static_cast<float>(index));
			host_advva[index] = std::cos(0.01f * static_cast<float>(index));
		}

		float* device_adx2d = nullptr;
		float* device_ady2d = nullptr;
		float* device_advua = nullptr;
		float* device_advva = nullptr;
		const std::size_t bytes = element_count * sizeof(float);

		check_cuda(cudaMalloc(&device_adx2d, bytes), "cudaMalloc(adx2d)");
		check_cuda(cudaMalloc(&device_ady2d, bytes), "cudaMalloc(ady2d)");
		check_cuda(cudaMalloc(&device_advua, bytes), "cudaMalloc(advua)");
		check_cuda(cudaMalloc(&device_advva, bytes), "cudaMalloc(advva)");
		check_cuda(cudaMemcpy(device_adx2d, host_adx2d.data(), bytes, cudaMemcpyHostToDevice),
				   "cudaMemcpy(adx2d to device)");
		check_cuda(cudaMemcpy(device_ady2d, host_ady2d.data(), bytes, cudaMemcpyHostToDevice),
				   "cudaMemcpy(ady2d to device)");
		check_cuda(cudaMemcpy(device_advua, host_advua.data(), bytes, cudaMemcpyHostToDevice),
				   "cudaMemcpy(advua to device)");
		check_cuda(cudaMemcpy(device_advva, host_advva.data(), bytes, cudaMemcpyHostToDevice),
				   "cudaMemcpy(advva to device)");

		std::cout << "\nInput snapshots (first 10 values each) (of " << element_count
				  << " total):\n";
		print_first_10("adx2d(before)", host_adx2d);
		print_first_10("ady2d(before)", host_ady2d);

		std::int64_t elapsed_us_total = 0;
		for (int sample = 0; sample < samples; ++sample) {
			const auto start = std::chrono::high_resolution_clock::now();
			ext_add_ad_2d(device_adx2d, device_ady2d, device_advua, device_advva, im, jm);
			check_cuda(cudaDeviceSynchronize(), "ext_add_ad_2d_kernel execution");
			const auto end = std::chrono::high_resolution_clock::now();
			elapsed_us_total +=
				std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
		}

		check_cuda(cudaMemcpy(host_adx2d.data(), device_adx2d, bytes, cudaMemcpyDeviceToHost),
				   "cudaMemcpy(adx2d from device)");
		check_cuda(cudaMemcpy(host_ady2d.data(), device_ady2d, bytes, cudaMemcpyDeviceToHost),
				   "cudaMemcpy(ady2d from device)");

		float maximum_error = 0.0f;
		for (std::size_t index = 0; index < element_count; ++index) {
			const float x = static_cast<float>(index % static_cast<std::size_t>(im));
			const float y = static_cast<float>(index / static_cast<std::size_t>(im));
			const float expected_adx2d = 0.1f * x - samples * host_advua[index];
			const float expected_ady2d = -0.2f * y - samples * host_advva[index];
			maximum_error = std::max(maximum_error, std::abs(host_adx2d[index] - expected_adx2d));
			maximum_error = std::max(maximum_error, std::abs(host_ady2d[index] - expected_ady2d));
		}

		const double elapsed_ms = static_cast<double>(elapsed_us_total) * 1.0e-3;
		const double average_elapsed_us = static_cast<double>(elapsed_us_total) / samples;
		const double average_elapsed_ms = average_elapsed_us * 1.0e-3;
		std::cout << "\nNumber of kernel launches: " << samples
				  << "\nGPU kernel call time: total: " << elapsed_us_total << " us (" << elapsed_ms
				  << " ms) average: " << average_elapsed_us << " us (" << average_elapsed_ms
				  << " ms)\n"
				  << "Maximum absolute error: " << maximum_error << "\n\n";
		std::cout << "Output snapshots (same buffers after kernel launches, first 10 values each):\n";
		print_first_10("adx2d(after)", host_adx2d);
		print_first_10("ady2d(after)", host_ady2d);

		check_cuda(cudaFree(device_adx2d), "cudaFree(adx2d)");
		check_cuda(cudaFree(device_ady2d), "cudaFree(ady2d)");
		check_cuda(cudaFree(device_advua), "cudaFree(advua)");
		check_cuda(cudaFree(device_advva), "cudaFree(advva)");

		return maximum_error <= 1.0e-4f ? EXIT_SUCCESS : EXIT_FAILURE;
	} catch (const std::exception& error) {
		std::cerr << "Error: " << error.what() << '\n';
		return EXIT_FAILURE;
	}
}





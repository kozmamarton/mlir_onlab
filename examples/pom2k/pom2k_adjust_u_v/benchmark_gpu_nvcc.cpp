#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <string>
#include <cuda_runtime.h>

// The MLIR-generated .ll registers global constructors at priority 123 that call
// cuModuleLoadData to load the GPU kernel binaries. Those constructors run before
// main(), so CUDA has no primary context yet and the loads silently return null.
// This constructor runs first (priority 101 < 123) and forces the CUDA runtime to
// create a primary context so the subsequent module loads succeed.
__attribute__((constructor(101)))
static void mlir_cuda_module_ctor_guard() {
    cudaFree(nullptr);
}

extern "C" {
// The lowered function reads these globals to determine launch grid sizes.
int kbm1[1];
int im[1];
int jm[1];

void ext_adjust_u_v_(
    void* tps_alloc,  void* tps_aligned,  int64_t tps_offset,  int64_t tps_size,  int64_t tps_stride,
    void* u_alloc,    void* u_aligned,    int64_t u_offset,    int64_t u_size,    int64_t u_stride,
    void* v_alloc,    void* v_aligned,    int64_t v_offset,    int64_t v_size,    int64_t v_stride,
    void* dz_alloc,   void* dz_aligned,   int64_t dz_offset,   int64_t dz_size,   int64_t dz_stride,
    void* utb_alloc,  void* utb_aligned,  int64_t utb_offset,  int64_t utb_size,  int64_t utb_stride,
    void* utf_alloc,  void* utf_aligned,  int64_t utf_offset,  int64_t utf_size,  int64_t utf_stride,
    void* vtb_alloc,  void* vtb_aligned,  int64_t vtb_offset,  int64_t vtb_size,  int64_t vtb_stride,
    void* vtf_alloc,  void* vtf_aligned,  int64_t vtf_offset,  int64_t vtf_size,  int64_t vtf_stride,
    void* dt_alloc,   void* dt_aligned,   int64_t dt_offset,   int64_t dt_size,   int64_t dt_stride);
}

struct ExtAdjustUVCallArgs {
    // tps  – 2-D surface: jm × im elements
    void* tps_alloc;
    void* tps_aligned;
    int64_t tps_offset;
    int64_t tps_size;
    int64_t tps_stride;

    // u – 3-D volume: kbm1 × jm × im elements
    void* u_alloc;
    void* u_aligned;
    int64_t u_offset;
    int64_t u_size;
    int64_t u_stride;

    // v – 3-D volume: kbm1 × jm × im elements
    void* v_alloc;
    void* v_aligned;
    int64_t v_offset;
    int64_t v_size;
    int64_t v_stride;

    // dz – 1-D level thicknesses: kbm1 elements
    void* dz_alloc;
    void* dz_aligned;
    int64_t dz_offset;
    int64_t dz_size;
    int64_t dz_stride;

    // utb – 2-D barotropic u (backward): jm × im elements
    void* utb_alloc;
    void* utb_aligned;
    int64_t utb_offset;
    int64_t utb_size;
    int64_t utb_stride;

    // utf – 2-D barotropic u (forward): jm × im elements
    void* utf_alloc;
    void* utf_aligned;
    int64_t utf_offset;
    int64_t utf_size;
    int64_t utf_stride;

    // vtb – 2-D barotropic v (backward): jm × im elements
    void* vtb_alloc;
    void* vtb_aligned;
    int64_t vtb_offset;
    int64_t vtb_size;
    int64_t vtb_stride;

    // vtf – 2-D barotropic v (forward): jm × im elements
    void* vtf_alloc;
    void* vtf_aligned;
    int64_t vtf_offset;
    int64_t vtf_size;
    int64_t vtf_stride;

    // dt – 2-D time-step field: jm × im elements
    void* dt_alloc;
    void* dt_aligned;
    int64_t dt_offset;
    int64_t dt_size;
    int64_t dt_stride;
};

static void print_first_10(const std::string& label, const float* values,
                    std::size_t size) {
    const std::size_t count = std::min<std::size_t>(10, size);
    std::cout << label << " [0.." << (count == 0 ? 0 : count - 1) << "]: ";
    for (std::size_t index = 0; index < count; ++index) {
        std::cout << std::fixed << std::setprecision(6) << values[index];
        if (index + 1 != count) {
            std::cout << ", ";
        }
    }
    std::cout << "\n";
}


static void check_cuda(cudaError_t status, const char *what)
{
    if (status != cudaSuccess)
    {
        throw std::runtime_error(std::string(what) + ": " + cudaGetErrorString(status));
    }
}



constexpr int rows   = 4096*1;
constexpr int cols   = 4096*1;
constexpr int levels = 20;
constexpr int64_t numOfSamples = 1;

int main() {
    im[0]   = rows;
    jm[0]   = cols;
    kbm1[0] = levels;

    const std::size_t sz2d = static_cast<std::size_t>(im[0]) *
                             static_cast<std::size_t>(jm[0]);
    const std::size_t sz3d = static_cast<std::size_t>(kbm1[0]) * sz2d;
    const std::size_t sz1d = static_cast<std::size_t>(kbm1[0]);

    // Allocate host memory for initialization and output
    float* h_tps = new float[sz2d];
    float* h_u = new float[sz3d];
    float* h_v = new float[sz3d];
    float* dz = nullptr;
    float* h_utb = new float[sz2d];
    float* h_utf = new float[sz2d];
    float* h_vtb = new float[sz2d];
    float* h_vtf = new float[sz2d];
    float* h_dt = new float[sz2d];

    // Allocate device memory
    float* d_tps = nullptr;
    float* d_u = nullptr;
    float* d_v = nullptr;
    float* d_utb = nullptr;
    float* d_utf = nullptr;
    float* d_vtb = nullptr;
    float* d_vtf = nullptr;
    float* d_dt = nullptr;

    check_cuda(cudaMalloc(&d_tps, sz2d * sizeof(float)), "cudaMalloc(d_tps)");
    check_cuda(cudaMalloc(&d_u, sz3d * sizeof(float)), "cudaMalloc(d_u)");
    check_cuda(cudaMalloc(&d_v, sz3d * sizeof(float)), "cudaMalloc(d_v)");
    // dz is read on host in the generated wrapper and also consumed by GPU kernels.
    // Keep it in unified memory so both sides can access the same pointer.
    check_cuda(cudaMallocManaged(&dz, sz1d * sizeof(float)), "cudaMallocManaged(dz)");
    check_cuda(cudaMalloc(&d_utb, sz2d * sizeof(float)), "cudaMalloc(d_utb)");
    check_cuda(cudaMalloc(&d_utf, sz2d * sizeof(float)), "cudaMalloc(d_utf)");
    check_cuda(cudaMalloc(&d_vtb, sz2d * sizeof(float)), "cudaMalloc(d_vtb)");
    check_cuda(cudaMalloc(&d_vtf, sz2d * sizeof(float)), "cudaMalloc(d_vtf)");
    check_cuda(cudaMalloc(&d_dt, sz2d * sizeof(float)), "cudaMalloc(d_dt)");

    // Initialise host 2-D surface arrays
    for (std::size_t index = 0; index < sz2d; ++index) {
        const float x = static_cast<float>(index % static_cast<std::size_t>(im[0]));
        const float y = static_cast<float>(index / static_cast<std::size_t>(im[0]));
        h_tps[index] = 0.0f;
        h_utb[index] = 0.1f * x;
        h_utf[index] = 0.1f * x + 0.01f;
        h_vtb[index] = -0.2f * y;
        h_vtf[index] = -0.2f * y + 0.01f;
        h_dt[index]  = std::sin(0.01f * static_cast<float>(index)) + 2.0f;
    }

    // Initialise host 3-D volume arrays
    for (std::size_t index = 0; index < sz3d; ++index) {
        h_u[index] = std::sin(0.001f * static_cast<float>(index));
        h_v[index] = std::cos(0.001f * static_cast<float>(index));
    }

    // Initialise 1-D level thicknesses
    for (std::size_t k = 0; k < sz1d; ++k) {
        dz[k] = 10.0f + static_cast<float>(k);
    }

    // Copy constant arrays to device (only needed once)
    check_cuda(cudaMemcpy(d_utb, h_utb, sz2d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(utb to device)");
    check_cuda(cudaMemcpy(d_utf, h_utf, sz2d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(utf to device)");
    check_cuda(cudaMemcpy(d_vtb, h_vtb, sz2d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(vtb to device)");
    check_cuda(cudaMemcpy(d_vtf, h_vtf, sz2d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(vtf to device)");
    check_cuda(cudaMemcpy(d_dt, h_dt, sz2d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(dt to device)");

    std::cout << '\n';
    std::cout << "Input snapshots (first 10 values each) (of " << rows * cols << " total):\n";
    print_first_10("tps(before)", h_tps, sz2d);
    print_first_10("u(before)",   h_u,   sz3d);
    print_first_10("v(before)",   h_v,   sz3d);

    ExtAdjustUVCallArgs args{
        d_tps, d_tps, 0, static_cast<int64_t>(sz2d), 1,
        d_u,   d_u,   0, static_cast<int64_t>(sz3d), 1,
        d_v,   d_v,   0, static_cast<int64_t>(sz3d), 1,
        dz,   dz,   0, static_cast<int64_t>(sz1d), 1,
        d_utb, d_utb, 0, static_cast<int64_t>(sz2d), 1,
        d_utf, d_utf, 0, static_cast<int64_t>(sz2d), 1,
        d_vtb, d_vtb, 0, static_cast<int64_t>(sz2d), 1,
        d_vtf, d_vtf, 0, static_cast<int64_t>(sz2d), 1,
        d_dt,  d_dt,  0, static_cast<int64_t>(sz2d), 1,
    };

    int64_t elapsedUsTotal = 0;

    for (int64_t i = 0; i < numOfSamples; ++i) {
        // Reset host working arrays to initial values
        for (std::size_t index = 0; index < sz2d; ++index) {
            h_tps[index] = 0.0f;
        }
        for (std::size_t index = 0; index < sz3d; ++index) {
            h_u[index] = std::sin(0.001f * static_cast<float>(index));
            h_v[index] = std::cos(0.001f * static_cast<float>(index));
        }

        // Copy working arrays to device
        check_cuda(cudaMemcpy(d_tps, h_tps, sz2d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(tps to device)");
        check_cuda(cudaMemcpy(d_u, h_u, sz3d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(u to device)");
        check_cuda(cudaMemcpy(d_v, h_v, sz3d * sizeof(float), cudaMemcpyHostToDevice), "cudaMemcpy(v to device)");

        const auto start = std::chrono::high_resolution_clock::now();
        ext_adjust_u_v_(
            args.tps_alloc, args.tps_aligned, args.tps_offset, args.tps_size, args.tps_stride,
            args.u_alloc,   args.u_aligned,   args.u_offset,   args.u_size,   args.u_stride,
            args.v_alloc,   args.v_aligned,   args.v_offset,   args.v_size,   args.v_stride,
            args.dz_alloc,  args.dz_aligned,  args.dz_offset,  args.dz_size,  args.dz_stride,
            args.utb_alloc, args.utb_aligned, args.utb_offset, args.utb_size, args.utb_stride,
            args.utf_alloc, args.utf_aligned, args.utf_offset, args.utf_size, args.utf_stride,
            args.vtb_alloc, args.vtb_aligned, args.vtb_offset, args.vtb_size, args.vtb_stride,
            args.vtf_alloc, args.vtf_aligned, args.vtf_offset, args.vtf_size, args.vtf_stride,
            args.dt_alloc,  args.dt_aligned,  args.dt_offset,  args.dt_size,  args.dt_stride);
        check_cuda(cudaDeviceSynchronize(), "cudaDeviceSynchronize(after kernel)");
        const auto end = std::chrono::high_resolution_clock::now();
        elapsedUsTotal += std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();

        // Copy results back to host
        check_cuda(cudaMemcpy(h_tps, d_tps, sz2d * sizeof(float), cudaMemcpyDeviceToHost), "cudaMemcpy(tps from device)");
        check_cuda(cudaMemcpy(h_u, d_u, sz3d * sizeof(float), cudaMemcpyDeviceToHost), "cudaMemcpy(u from device)");
        check_cuda(cudaMemcpy(h_v, d_v, sz3d * sizeof(float), cudaMemcpyDeviceToHost), "cudaMemcpy(v from device)");
    }

    const auto elapsedMs        = static_cast<double>(elapsedUsTotal) * 1e-3;
    const auto averageElapsedUs = elapsedUsTotal / numOfSamples;
    const auto averageElapsedMs = static_cast<double>(averageElapsedUs) * 1e-3;
    std::cout << '\n'
              << "Number of kernel calls initiated: " << numOfSamples
              << "\ngpu kernel call time (device memory, H2D+kernel+D2H):"
              << " total: " << elapsedUsTotal << " us (" << elapsedMs << " ms)"
              << " average: " << averageElapsedUs << " us (" << averageElapsedMs << " ms)\n\n";

    std::cout << "Output snapshots (same buffers after kernel call, first 10 values each):\n";
    print_first_10("tps(after)", h_tps, sz2d);
    print_first_10("u(after)",   h_u,   sz3d);
    print_first_10("v(after)",   h_v,   sz3d);

    // Cleanup device memory
    check_cuda(cudaFree(d_tps), "cudaFree(d_tps)");
    check_cuda(cudaFree(d_u), "cudaFree(d_u)");
    check_cuda(cudaFree(d_v), "cudaFree(d_v)");
    check_cuda(cudaFree(d_utb), "cudaFree(d_utb)");
    check_cuda(cudaFree(d_utf), "cudaFree(d_utf)");
    check_cuda(cudaFree(d_vtb), "cudaFree(d_vtb)");
    check_cuda(cudaFree(d_vtf), "cudaFree(d_vtf)");
    check_cuda(cudaFree(d_dt), "cudaFree(d_dt)");

    // Cleanup host memory
    delete[] h_tps;
    delete[] h_u;
    delete[] h_v;
    check_cuda(cudaFree(dz), "cudaFree(dz)");
    delete[] h_utb;
    delete[] h_utf;
    delete[] h_vtb;
    delete[] h_vtf;
    delete[] h_dt;

    return 0;
}

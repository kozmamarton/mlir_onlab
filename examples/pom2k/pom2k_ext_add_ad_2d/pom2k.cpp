
#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cuda_runtime.h>
#include <iomanip>
#include <iostream>
#include <stdexcept>
#include <string>

extern "C"
{
    // The lowered function reads these globals to determine launch grid sizes.
    int im[1];
    int jm[1];

    void ext_add_ad_2d_(void *arg0, void *arg1, int64_t arg2, int64_t arg3, int64_t arg4,
                        void *arg5, void *arg6, int64_t arg7, int64_t arg8, int64_t arg9,
                        void *arg10, void *arg11, int64_t arg12, int64_t arg13, int64_t arg14,
                        void *arg15, void *arg16, int64_t arg17, int64_t arg18, int64_t arg19);
}

struct ExtAddAd2DCallArgs
{
    void *adx2d_alloc;
    void *adx2d_aligned;
    int64_t adx2d_offset;
    int64_t adx2d_size;
    int64_t adx2d_stride;

    void *ady2d_alloc;
    void *ady2d_aligned;
    int64_t ady2d_offset;
    int64_t ady2d_size;
    int64_t ady2d_stride;

    void *advua_alloc;
    void *advua_aligned;
    int64_t advua_offset;
    int64_t advua_size;
    int64_t advua_stride;

    void *advva_alloc;
    void *advva_aligned;
    int64_t advva_offset;
    int64_t advva_size;
    int64_t advva_stride;
};

static void check_cuda(cudaError_t status, const char *what)
{
    if (status != cudaSuccess)
    {
        throw std::runtime_error(std::string(what) + ": " + cudaGetErrorString(status));
    }
}

static void print_first_10(const std::string &label, const float *data, std::size_t size)
{
    const std::size_t count = std::min<std::size_t>(10, size);
    std::cout << label << " [0.." << (count == 0 ? 0 : count - 1) << "]: ";
    for (std::size_t i = 0; i < count; ++i)
    {
        std::cout << std::fixed << std::setprecision(6) << data[i];
        if (i + 1 != count)
        {
            std::cout << ", ";
        }
    }
    std::cout << "\n";
}

int main()
{
    constexpr int rows = 16978;
    constexpr int cols = 16978;
    constexpr int64_t numOfSamples = 100;
    const std::size_t n = static_cast<std::size_t>(rows) * static_cast<std::size_t>(cols);

    im[0] = rows;
    jm[0] = cols;

    float *adx2d = nullptr;
    float *ady2d = nullptr;
    float *advua = nullptr;
    float *advva = nullptr;

    check_cuda(cudaMallocManaged(&adx2d, n * sizeof(float)), "cudaMallocManaged(adx2d)");
    check_cuda(cudaMallocManaged(&ady2d, n * sizeof(float)), "cudaMallocManaged(ady2d)");
    check_cuda(cudaMallocManaged(&advua, n * sizeof(float)), "cudaMallocManaged(advua)");
    check_cuda(cudaMallocManaged(&advva, n * sizeof(float)), "cudaMallocManaged(advva)");
    for (std::size_t idx = 0; idx < n; ++idx)
    {
        const float x = static_cast<float>(idx % cols);
        const float y = static_cast<float>(idx / cols);
        adx2d[idx] = 0.1f * x;
        ady2d[idx] = -0.2f * y;
        advua[idx] = std::sin(0.01f * static_cast<float>(idx));
        advva[idx] = std::cos(0.01f * static_cast<float>(idx));
    }

    check_cuda(cudaDeviceSynchronize(), "cudaDeviceSynchronize(after initialization)");

    ExtAddAd2DCallArgs args{
        adx2d,
        adx2d,
        0,
        static_cast<int64_t>(n),
        1,
        ady2d,
        ady2d,
        0,
        static_cast<int64_t>(n),
        1,
        advua,
        advua,
        0,
        static_cast<int64_t>(n),
        1,
        advva,
        advva,
        0,
        static_cast<int64_t>(n),
        1,
    };

    std::cout << '\n';
    std::cout << "pom2k benchmark: testing gpu kernel runtime\n";
    std::cout << "Input snapshots (first 10 values each) (of " << rows * cols << " total):\n";
    print_first_10("adx2d(before)", adx2d, n);
    print_first_10("ady2d(before)", ady2d, n);
    // print_first_10("advua(before)", advua, n);
    // print_first_10("advva(before)", advva, n);

    int64_t elapsedUsTotal = 0;
    for (auto i = 0; i < numOfSamples; i++)
    {
        const auto start = std::chrono::high_resolution_clock::now();
        ext_add_ad_2d_(args.adx2d_alloc, args.adx2d_aligned, args.adx2d_offset, args.adx2d_size,
                   args.adx2d_stride, args.ady2d_alloc, args.ady2d_aligned,
                   args.ady2d_offset, args.ady2d_size, args.ady2d_stride,
                   args.advua_alloc, args.advua_aligned, args.advua_offset,
                   args.advua_size, args.advua_stride, args.advva_alloc,
                   args.advva_aligned, args.advva_offset, args.advva_size,
                   args.advva_stride);
        check_cuda(cudaDeviceSynchronize(), "cudaDeviceSynchronize(after kernel call)");
        const auto end = std::chrono::high_resolution_clock::now();
        elapsedUsTotal += std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
    }

    const auto elapsedMs = static_cast<double>(elapsedUsTotal) * 1e-3;
    const auto averageElapsedUs = elapsedUsTotal / numOfSamples;
    const auto averageElapsedMs = static_cast<double>(averageElapsedUs) * 1e-3;
    std::cout << '\n'
              << "Number of function calls initiated: " << numOfSamples
              << "\ngpu kernel call time: "
              << " total: " << elapsedUsTotal << " us (" << elapsedMs << " ms)"
              << " average: " << averageElapsedUs << "us (" << averageElapsedMs << " ms)\n\n";

    std::cout << "Output snapshots (same buffers after kernel call, first 10 values each):\n";
    print_first_10("adx2d(after)", adx2d, n);
    print_first_10("ady2d(after)", ady2d, n);
    // print_first_10("advua(after)", advua, n);
    // print_first_10("advva(after)", advva, n);

    check_cuda(cudaFree(adx2d), "cudaFree(adx2d)");
    check_cuda(cudaFree(ady2d), "cudaFree(ady2d)");
    check_cuda(cudaFree(advua), "cudaFree(advua)");
    check_cuda(cudaFree(advva), "cudaFree(advva)");

    return 0;
}

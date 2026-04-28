#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <iomanip>
#include <iostream>
#include <memory>
#include <string>

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

void print_first_10(const std::string& label, const float* values,
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

constexpr int rows   = 1024;
constexpr int cols   = 1024;
constexpr int levels = 20;
constexpr int64_t numOfSamples = 10;

int main() {
    im[0]   = rows;
    jm[0]   = cols;
    kbm1[0] = levels;

    const std::size_t sz2d = static_cast<std::size_t>(im[0]) *
                             static_cast<std::size_t>(jm[0]);
    const std::size_t sz3d = static_cast<std::size_t>(kbm1[0]) * sz2d;
    const std::size_t sz1d = static_cast<std::size_t>(kbm1[0]);

    float* tps = new float[sz2d];
    float* u   = new float[sz3d];
    float* v   = new float[sz3d];
    float* dz  = new float[sz1d];
    float* utb = new float[sz2d];
    float* utf = new float[sz2d];
    float* vtb = new float[sz2d];
    float* vtf = new float[sz2d];
    float* dt  = new float[sz2d];

    // Initialise 2-D surface arrays
    for (std::size_t index = 0; index < sz2d; ++index) {
        const float x = static_cast<float>(index % static_cast<std::size_t>(im[0]));
        const float y = static_cast<float>(index / static_cast<std::size_t>(im[0]));
        tps[index] = 0.0f;
        utb[index] = 0.1f * x;
        utf[index] = 0.1f * x + 0.01f;
        vtb[index] = -0.2f * y;
        vtf[index] = -0.2f * y + 0.01f;
        dt[index]  = std::sin(0.01f * static_cast<float>(index));
    }

    // Initialise 3-D volume arrays
    for (std::size_t index = 0; index < sz3d; ++index) {
        u[index] = std::sin(0.001f * static_cast<float>(index));
        v[index] = std::cos(0.001f * static_cast<float>(index));
    }

    // Initialise 1-D level thicknesses
    for (std::size_t k = 0; k < sz1d; ++k) {
        dz[k] = 10.0f + static_cast<float>(k);
    }

    std::cout << '\n';
    std::cout << "Input snapshots (first 10 values each) (of " << rows * cols << " total):\n";
    print_first_10("tps(before)", tps, sz2d);
    print_first_10("u(before)",   u,   sz3d);
    print_first_10("v(before)",   v,   sz3d);

    auto args = std::make_unique<ExtAdjustUVCallArgs>(ExtAdjustUVCallArgs{
        tps, tps, 0, static_cast<int64_t>(sz2d), 1,
        u,   u,   0, static_cast<int64_t>(sz3d), 1,
        v,   v,   0, static_cast<int64_t>(sz3d), 1,
        dz,  dz,  0, static_cast<int64_t>(sz1d), 1,
        utb, utb, 0, static_cast<int64_t>(sz2d), 1,
        utf, utf, 0, static_cast<int64_t>(sz2d), 1,
        vtb, vtb, 0, static_cast<int64_t>(sz2d), 1,
        vtf, vtf, 0, static_cast<int64_t>(sz2d), 1,
        dt,  dt,  0, static_cast<int64_t>(sz2d), 1,
    });

    int64_t elapsedUsTotal = 0;

    for (int64_t i = 0; i < numOfSamples; ++i) {
        const auto start = std::chrono::high_resolution_clock::now();
        ext_adjust_u_v_(
            args->tps_alloc, args->tps_aligned, args->tps_offset, args->tps_size, args->tps_stride,
            args->u_alloc,   args->u_aligned,   args->u_offset,   args->u_size,   args->u_stride,
            args->v_alloc,   args->v_aligned,   args->v_offset,   args->v_size,   args->v_stride,
            args->dz_alloc,  args->dz_aligned,  args->dz_offset,  args->dz_size,  args->dz_stride,
            args->utb_alloc, args->utb_aligned, args->utb_offset, args->utb_size, args->utb_stride,
            args->utf_alloc, args->utf_aligned, args->utf_offset, args->utf_size, args->utf_stride,
            args->vtb_alloc, args->vtb_aligned, args->vtb_offset, args->vtb_size, args->vtb_stride,
            args->vtf_alloc, args->vtf_aligned, args->vtf_offset, args->vtf_size, args->vtf_stride,
            args->dt_alloc,  args->dt_aligned,  args->dt_offset,  args->dt_size,  args->dt_stride);
        const auto end = std::chrono::high_resolution_clock::now();
        elapsedUsTotal += std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
    }

    const auto elapsedMs        = static_cast<double>(elapsedUsTotal) * 1e-3;
    const auto averageElapsedUs = elapsedUsTotal / numOfSamples;
    const auto averageElapsedMs = static_cast<double>(averageElapsedUs) * 1e-3;
    std::cout << '\n'
              << "Number of function calls initiated: " << numOfSamples
              << "\ncpu call time - multithreaded:"
              << " total: " << elapsedUsTotal << " us (" << elapsedMs << " ms)"
              << " average: " << averageElapsedUs << " us (" << averageElapsedMs << " ms)\n\n";

    std::cout << "Output snapshots (same buffers after call, first 10 values each):\n";
    print_first_10("tps(after)", tps, sz2d);
    print_first_10("u(after)",   u,   sz3d);
    print_first_10("v(after)",   v,   sz3d);

    delete[] tps;
    delete[] u;
    delete[] v;
    delete[] dz;
    delete[] utb;
    delete[] utf;
    delete[] vtb;
    delete[] vtf;
    delete[] dt;

    return 0;
}

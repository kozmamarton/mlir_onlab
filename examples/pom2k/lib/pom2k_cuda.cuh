// Shared helpers for the native CUDA references (<kernel dir>/cuda_ref.cu) of
// the gpu_a100 differential benchmarks.
//
// The references are 1:1 translations of src/pom2k_generated_affine_loops/
// pom2k_fun.c: every parallel loop nest becomes one kernel with one thread per
// iteration, and every sequential loop (k sweeps, scalar code) keeps the
// iteration order of the C source. Kernel parameters carry the same names as
// the C globals they replace, so loop bodies are copied verbatim from the C
// source and ACC2/ACC3 index exactly like pom2k_c_header.h.
//
// The scalar globals are the harness's 1-element arrays, matching the MLIR
// memref<1x...> globals. Only the ones the kernel's MLIR references are
// defined, so a reference that reads any other global fails to link.
#ifndef POM2K_CUDA_CUH
#define POM2K_CUDA_CUH

#include <cuda_runtime.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>

typedef float real_t;

#define ACC2DFULL(i, j, sx, sy) ((i) + (j)*sx)
#define ACC2(i, j) ACC2DFULL(i, j, im, jm)
#define ACC3DFULL(i, j, k, sx, sy, sz) ((i) + (j)*sx + (k)*sx*sy)
#define ACC3(i, j, k) ACC3DFULL(i, j, k, im, jm, kb)

extern "C" {
extern int im[1], jm[1], kb[1], imm1[1], jmm1[1], kbm1[1], imm2[1], jmm2[1],
    kbm2[1], mode[1], ntp[1];
extern real_t alpha[1], dte[1], dte2[1], dti2[1], grav[1], hmax[1], horcon[1],
    rhoref[1], tprni[1], umol[1];
}

#define POM2K_CUDA_CHECK(call)                                              \
  do {                                                                      \
    cudaError_t err_ = (call);                                              \
    if (err_ != cudaSuccess) {                                              \
      std::fprintf(stderr, "%s:%d: %s failed: %s\n", __FILE__, __LINE__,    \
                   #call, cudaGetErrorString(err_));                        \
      std::exit(5);                                                         \
    }                                                                       \
  } while (0)

// Half-open iteration space [i0, i1) x [j0, j1) x [k0, k1), i fastest.
struct Range {
  int i0, i1, j0, j1, k0, k1;
};

inline Range range2(int i0, int i1, int j0, int j1) {
  return Range{i0, i1, j0, j1, 0, 1};
}
inline Range range3(int i0, int i1, int j0, int j1, int k0, int k1) {
  return Range{i0, i1, j0, j1, k0, k1};
}

// Declares i, j, k of the calling thread and returns from threads outside r.
#define POM2K_INDEX(r, i, j, k)                                             \
  const int i = (r).i0 + static_cast<int>(blockIdx.x * blockDim.x + threadIdx.x); \
  const int j = (r).j0 + static_cast<int>(blockIdx.y * blockDim.y + threadIdx.y); \
  const int k = (r).k0 + static_cast<int>(blockIdx.z * blockDim.z + threadIdx.z); \
  if (i >= (r).i1 || j >= (r).j1 || k >= (r).k1)                           \
  return

// Launches `kernel(r, args...)` with one thread per point of r; empty ranges
// launch nothing (like the C loops, which then run zero iterations).
template <typename... KernelArgs, typename... Args>
void launch(void (*kernel)(Range, KernelArgs...), Range r, Args... args) {
  const int ni = r.i1 - r.i0, nj = r.j1 - r.j0, nk = r.k1 - r.k0;
  if (ni <= 0 || nj <= 0 || nk <= 0)
    return;
  const dim3 block(32, nk > 1 ? 4 : 8, nk > 1 ? 2 : 1);
  const dim3 grid((ni + block.x - 1) / block.x, (nj + block.y - 1) / block.y,
                  (nk + block.z - 1) / block.z);
  kernel<<<grid, block>>>(r, args...);
  POM2K_CUDA_CHECK(cudaGetLastError());
}

// Code without a parallel loop runs in a single device thread.
template <typename... KernelArgs, typename... Args>
void launchSerial(void (*kernel)(KernelArgs...), Args... args) {
  kernel<<<1, 1>>>(args...);
  POM2K_CUDA_CHECK(cudaGetLastError());
}

inline void finish() { POM2K_CUDA_CHECK(cudaDeviceSynchronize()); }

#endif  // POM2K_CUDA_CUH

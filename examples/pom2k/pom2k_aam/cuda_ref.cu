// Native CUDA reference of ext_aam_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void aam_0(Range r, real_t *aam, const real_t *dx, const real_t *dy,
                      const real_t *u, const real_t *v, int im, int jm,
                      real_t horcon) {
  POM2K_INDEX(r, i, j, k);
  aam[ACC3(i, j, k)] =
      horcon * dx[ACC2(i, j)] * dy[ACC2(i, j)] *
      sqrtf(((u[ACC3(i + 1, j, k)] - u[ACC3(i, j, k)]) / dx[ACC2(i, j)]) *
                ((u[ACC3(i + 1, j, k)] - u[ACC3(i, j, k)]) / dx[ACC2(i, j)]) +
            ((v[ACC3(i, j + 1, k)] - v[ACC3(i, j, k)]) / dy[ACC2(i, j)]) *
                ((v[ACC3(i, j + 1, k)] - v[ACC3(i, j, k)]) / dy[ACC2(i, j)]) +
            0.5f *
                (0.25f *
                     (u[ACC3(i, j + 1, k)] + u[ACC3(i + 1, j + 1, k)] -
                      u[ACC3(i, j - 1, k)] - u[ACC3(i + 1, j - 1, k)]) /
                     dy[ACC2(i, j)] +
                 0.25f *
                     (v[ACC3(i + 1, j, k)] + v[ACC3(i + 1, j + 1, k)] -
                      v[ACC3(i - 1, j, k)] - v[ACC3(i - 1, j + 1, k)]) /
                     dx[ACC2(i, j)]) *
                (0.25f *
                     (u[ACC3(i, j + 1, k)] + u[ACC3(i + 1, j + 1, k)] -
                      u[ACC3(i, j - 1, k)] - u[ACC3(i + 1, j - 1, k)]) /
                     dy[ACC2(i, j)] +
                 0.25f *
                     (v[ACC3(i + 1, j, k)] + v[ACC3(i + 1, j + 1, k)] -
                      v[ACC3(i - 1, j, k)] - v[ACC3(i - 1, j + 1, k)]) /
                     dx[ACC2(i, j)]));
}

}  // namespace

void ext_aam__cuda(real_t *aam, real_t *dx, real_t *dy, real_t *u, real_t *v) {
  launch(aam_0, range3(1, imm1[0], 1, jmm1[0], 0, kbm1[0]), aam, dx, dy, u, v,
         im[0], jm[0], horcon[0]);
  finish();
}

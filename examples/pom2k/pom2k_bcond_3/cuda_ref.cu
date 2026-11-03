// Native CUDA reference of ext_bcond_3_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

// East and west boundaries, one thread per (j, k).
__global__ void bcond_3_0(Range r, const real_t *h, real_t *uf, const real_t *u, real_t *vf,
                          int im, int jm, int imm1, int imm2, real_t hmax) {
  POM2K_INDEX(r, j, k, unused_k);
  // EAST
  real_t ga;
  ga = sqrtf(h[ACC2(imm1, j)] / hmax);
  uf[ACC3(imm1, j, k)] =
      ga * (0.25f * u[ACC3(imm2, j - 1, k)] + 0.5f * u[ACC3(imm2, j, k)] +
            0.25f * u[ACC3(imm2, j + 1, k)]) +
      (1.0f - ga) * (0.25f * u[ACC3(imm1, j - 1, k)] + 0.5f * u[ACC3(imm1, j, k)] +
                     0.25f * u[ACC3(imm1, j + 1, k)]);
  vf[ACC3(imm1, j, k)] = 0.0f;

  // WEST
  ga = sqrtf(h[ACC2(0, j)] / hmax);
  uf[ACC3(1, j, k)] =
      ga * (0.25f * u[ACC3(2, j - 1, k)] + 0.5f * u[ACC3(2, j, k)] +
            0.25f * u[ACC3(2, j + 1, k)]) +
      (1.0f - ga) * (0.25f * u[ACC3(1, j - 1, k)] + 0.5f * u[ACC3(1, j, k)] +
                     0.25f * u[ACC3(1, j + 1, k)]);
  uf[ACC3(0, j, k)] = uf[ACC3(1, j, k)];
  vf[ACC3(0, j, k)] = 0.0f;
}

// North and south boundaries, one thread per (i, k).
__global__ void bcond_3_1(Range r, const real_t *h, real_t *uf, real_t *vf, const real_t *v,
                          int im, int jm, int jmm1, int jmm2, real_t hmax) {
  POM2K_INDEX(r, i, k, unused_k);
  // NORTH
  real_t ga;
  ga = sqrtf(h[ACC2(i, jmm1)] / hmax);
  vf[ACC3(i, jmm1, k)] =
      ga * (0.25f * v[ACC3(i - 1, jmm2, k)] + 0.5f * v[ACC3(i, jmm2, k)] +
            0.25f * v[ACC3(i + 1, jmm2, k)]) +
      (1.0f - ga) * (0.25f * v[ACC3(i - 1, jmm1, k)] + 0.5f * v[ACC3(i, jmm1, k)] +
                     0.25f * v[ACC3(i + 1, jmm1, k)]);
  uf[ACC3(i, jmm1, k)] = 0.0f;
  // SOUTH
  ga = sqrtf(h[ACC2(i, 0)] / hmax);
  vf[ACC3(i, 1, k)] =
      ga * (0.25f * v[ACC3(i - 1, 2, k)] + 0.5f * v[ACC3(i, 2, k)] +
            0.25f * v[ACC3(i + 1, 2, k)]) +
      (1.0f - ga) * (0.25f * v[ACC3(i - 1, 1, k)] + 0.5f * v[ACC3(i, 1, k)] +
                     0.25f * v[ACC3(i + 1, 1, k)]);
  vf[ACC3(i, 0, k)] = vf[ACC3(i, 1, k)];
  uf[ACC3(i, 0, k)] = 0.0f;
}

__global__ void bcond_3_2(Range r, real_t *uf, real_t *vf, const real_t *dum, const real_t *dvm,
                          int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  uf[ACC3(i, j, k)] = uf[ACC3(i, j, k)] * dum[ACC2(i, j)];
  vf[ACC3(i, j, k)] = vf[ACC3(i, j, k)] * dvm[ACC2(i, j)];
}

}  // namespace

void ext_bcond_3__cuda(real_t *h, real_t *uf, real_t *u, real_t *vf, real_t *v, real_t *dum,
                       real_t *dvm) {
  launch(bcond_3_0, range2(1, jmm1[0], 0, kbm1[0]), h, uf, u, vf, im[0], jm[0], imm1[0],
         imm2[0], hmax[0]);
  launch(bcond_3_1, range2(1, imm1[0], 0, kbm1[0]), h, uf, vf, v, im[0], jm[0], jmm1[0],
         jmm2[0], hmax[0]);
  launch(bcond_3_2, range3(0, im[0], 0, jm[0], 0, kbm1[0]), uf, vf, dum, dvm, im[0], jm[0]);
  finish();
}

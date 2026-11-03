// Native CUDA reference of ext_vert_avgs_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void vert_avgs_0(Range r, real_t *adx2d, real_t *ady2d, real_t *drx2d, real_t *dry2d,
                            real_t *aam2d, int im) {
  POM2K_INDEX(r, i, j, k);
  adx2d[ACC2(i, j)] = 0.0f;
  ady2d[ACC2(i, j)] = 0.0f;
  drx2d[ACC2(i, j)] = 0.0f;
  dry2d[ACC2(i, j)] = 0.0f;
  aam2d[ACC2(i, j)] = 0.0f;
}

// The 2-D integrals accumulate over k, so every (i, j) column sums its k
// levels in the order of the C source.
__global__ void vert_avgs_1(Range r, real_t *adx2d, real_t *ady2d, real_t *drx2d,
                            real_t *dry2d, real_t *aam2d, const real_t *advx,
                            const real_t *advy, const real_t *drhox, const real_t *drhoy,
                            const real_t *aam, const real_t *dz, int im, int jm, int kbm1) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 0; k < kbm1; k++) {
    adx2d[ACC2(i, j)] += advx[ACC3(i, j, k)] * dz[k];
    ady2d[ACC2(i, j)] += advy[ACC3(i, j, k)] * dz[k];
    drx2d[ACC2(i, j)] += drhox[ACC3(i, j, k)] * dz[k];
    dry2d[ACC2(i, j)] += drhoy[ACC3(i, j, k)] * dz[k];
    aam2d[ACC2(i, j)] += aam[ACC3(i, j, k)] * dz[k];
  }
}

}  // namespace

void ext_vert_avgs__cuda(real_t *adx2d, real_t *ady2d, real_t *drx2d, real_t *dry2d,
                         real_t *aam2d, real_t *advx, real_t *advy, real_t *drhox,
                         real_t *drhoy, real_t *aam, real_t *dz) {
  const Range r = range2(0, im[0], 0, jm[0]);
  launch(vert_avgs_0, r, adx2d, ady2d, drx2d, dry2d, aam2d, im[0]);
  launch(vert_avgs_1, r, adx2d, ady2d, drx2d, dry2d, aam2d, advx, advy, drhox, drhoy, aam, dz,
         im[0], jm[0], kbm1[0]);
  finish();
}

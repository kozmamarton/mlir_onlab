// Native HIP reference of ext_vert_avgs_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Vertical integrals: one thread per (i, j) column sums its k levels in the
// order of the C source. The C code zeroes the 2D fields and then adds into
// them; the sums are kept in registers starting from 0 instead (the same
// additions in the same order) and stored once.
POM2K_KERNEL void vert_avgs_0(Range r, real_t *__restrict__ adx2d, real_t *__restrict__ ady2d,
                              real_t *__restrict__ drx2d, real_t *__restrict__ dry2d,
                              real_t *__restrict__ aam2d, const real_t *__restrict__ advx,
                              const real_t *__restrict__ advy,
                              const real_t *__restrict__ drhox,
                              const real_t *__restrict__ drhoy,
                              const real_t *__restrict__ aam, const real_t *__restrict__ dz,
                              int im, int jm, int kbm1) {
  POM2K_INDEX(r, i, j, unused_k);
  real_t sadx = 0.0f, sady = 0.0f, sdrx = 0.0f, sdry = 0.0f, saam = 0.0f;
  for (int k = 0; k < kbm1; k++) {
    sadx += advx[ACC3(i, j, k)] * dz[k];
    sady += advy[ACC3(i, j, k)] * dz[k];
    sdrx += drhox[ACC3(i, j, k)] * dz[k];
    sdry += drhoy[ACC3(i, j, k)] * dz[k];
    saam += aam[ACC3(i, j, k)] * dz[k];
  }
  adx2d[ACC2(i, j)] = sadx;
  ady2d[ACC2(i, j)] = sady;
  drx2d[ACC2(i, j)] = sdrx;
  dry2d[ACC2(i, j)] = sdry;
  aam2d[ACC2(i, j)] = saam;
}

}  // namespace

void ext_vert_avgs__hip(real_t *adx2d, real_t *ady2d, real_t *drx2d, real_t *dry2d,
                        real_t *aam2d, real_t *advx, real_t *advy, real_t *drhox,
                        real_t *drhoy, real_t *aam, real_t *dz) {
  launch(vert_avgs_0, range2(0, im[0], 0, jm[0]), adx2d, ady2d, drx2d, dry2d, aam2d, advx, advy,
         drhox, drhoy, aam, dz, im[0], jm[0], kbm1[0]);
  finish();
}

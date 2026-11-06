// Native HIP reference of ext_adjust_u_v_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// tps = vertical integral of x: one thread per (i, j) column sums its k levels
// in the order of the C source. The C code zeroes tps and then adds into it;
// the sum is kept in a register starting from 0 instead (the same additions in
// the same order) and stored once.
POM2K_KERNEL void adjust_u_v_sum(Range r, real_t *__restrict__ tps,
                                 const real_t *__restrict__ x, const real_t *__restrict__ dz,
                                 int im, int jm, int kbm1) {
  POM2K_INDEX(r, i, j, unused_k);
  real_t sum = 0.0f;
  for (int k = 0; k < kbm1; k++)
    sum = sum + x[ACC3(i, j, k)] * dz[k];
  tps[ACC2(i, j)] = sum;
}

// Replaces the vertical mean of u by the one of the external mode.
POM2K_KERNEL void adjust_u_v_u(Range r, const real_t *__restrict__ tps, real_t *__restrict__ u,
                               const real_t *__restrict__ utb, const real_t *__restrict__ utf,
                               const real_t *__restrict__ dt, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  u[ACC3(i, j, k)] = (u[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                     (utb[ACC2(i, j)] + utf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]);
}

// The same for v.
POM2K_KERNEL void adjust_u_v_v(Range r, const real_t *__restrict__ tps, real_t *__restrict__ v,
                               const real_t *__restrict__ vtb, const real_t *__restrict__ vtf,
                               const real_t *__restrict__ dt, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  v[ACC3(i, j, k)] = (v[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                     (vtb[ACC2(i, j)] + vtf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]);
}

}  // namespace

void ext_adjust_u_v__hip(real_t *tps, real_t *u, real_t *v, real_t *dz, real_t *utb,
                         real_t *utf, real_t *vtb, real_t *vtf, real_t *dt) {
  const Range plane = range2(0, im[0], 0, jm[0]);
  launch(adjust_u_v_sum, plane, tps, u, dz, im[0], jm[0], kbm1[0]);
  launch(adjust_u_v_u, range3(1, im[0], 0, jm[0], 0, kbm1[0]), tps, u, utb, utf, dt, im[0],
         jm[0]);
  launch(adjust_u_v_sum, plane, tps, v, dz, im[0], jm[0], kbm1[0]);
  launch(adjust_u_v_v, range3(0, im[0], 1, jm[0], 0, kbm1[0]), tps, v, vtb, vtf, dt, im[0],
         jm[0]);
  finish();
}

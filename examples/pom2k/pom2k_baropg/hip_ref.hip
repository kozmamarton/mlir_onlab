// Native HIP reference of ext_baropg_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// rho -= rmean (sign = -1) before the gradients, rho += rmean (sign = +1)
// after them, as in the C source (the round trip is not bitwise neutral).
POM2K_KERNEL void baropg_rmean(Range r, real_t *__restrict__ rho,
                               const real_t *__restrict__ rmean, int im, int jm, real_t sign) {
  POM2K_INDEX(r, i, j, k);
  if (sign < 0.0f)
    rho[ACC3(i, j, k)] = rho[ACC3(i, j, k)] - rmean[ACC3(i, j, k)];
  else
    rho[ACC3(i, j, k)] = rho[ACC3(i, j, k)] + rmean[ACC3(i, j, k)];
}

// Baroclinic pressure gradient (x and y components) of one (i, j) column.
// The C source integrates each component downwards in a loop-carried k
// recurrence, then scales every level by the face area and finally by ramp,
// all in separate loops. Here one thread walks its column once: the
// recurrence runs on the unscaled values (raw*, kept in registers together
// with the densities of the previous level) and every level is scaled and
// ramped as it is stored, with the C source's operation order.
POM2K_KERNEL void baropg_column(Range r, const real_t *__restrict__ rho,
                                real_t *__restrict__ drhox, real_t *__restrict__ drhoy,
                                const real_t *__restrict__ zz, const real_t *__restrict__ dt,
                                const real_t *__restrict__ dum, const real_t *__restrict__ dvm,
                                const real_t *__restrict__ dx, const real_t *__restrict__ dy,
                                const real_t *__restrict__ ramp, int im, int jm, int kbm1,
                                real_t grav) {
  POM2K_INDEX(r, i, j, unused_k);
  // Depth sums/differences across the x face (i - 1, i) and the y face (j - 1, j).
  const real_t dtx = dt[ACC2(i, j)] + dt[ACC2(i - 1, j)];
  const real_t ddtx = dt[ACC2(i, j)] - dt[ACC2(i - 1, j)];
  const real_t dty = dt[ACC2(i, j)] + dt[ACC2(i, j - 1)];
  const real_t ddty = dt[ACC2(i, j)] - dt[ACC2(i, j - 1)];
  const real_t dumij = dum[ACC2(i, j)], dvmij = dvm[ACC2(i, j)];
  const real_t dyx = dy[ACC2(i, j)] + dy[ACC2(i - 1, j)];
  const real_t dxy = dx[ACC2(i, j)] + dx[ACC2(i, j - 1)];
  const real_t rmp = *ramp;

  // Surface level.
  real_t rc = rho[ACC3(i, j, 0)], rw = rho[ACC3(i - 1, j, 0)], rs = rho[ACC3(i, j - 1, 0)];
  real_t rawx = 0.5f * grav * (-zz[0]) * dtx * (rc - rw);
  real_t rawy = 0.5f * grav * (-zz[0]) * dty * (rc - rs);
  drhox[ACC3(i, j, 0)] = rmp * (0.25f * dtx * rawx * dumij * dyx);
  drhoy[ACC3(i, j, 0)] = rmp * (0.25f * dty * rawy * dvmij * dxy);

  // Deeper levels: recurrence over k.
  for (int k = 1; k < kbm1; k++) {
    const real_t rcK = rho[ACC3(i, j, k)], rwK = rho[ACC3(i - 1, j, k)],
                 rsK = rho[ACC3(i, j - 1, k)];
    rawx = rawx + grav * 0.25f * (zz[k - 1] - zz[k]) * dtx * (rcK - rwK + rc - rw) +
           grav * 0.25f * (zz[k - 1] + zz[k]) * ddtx * (rcK + rwK - rc - rw);
    rawy = rawy + grav * 0.25f * (zz[k - 1] - zz[k]) * dty * (rcK - rsK + rc - rs) +
           grav * 0.25f * (zz[k - 1] + zz[k]) * ddty * (rcK + rsK - rc - rs);
    drhox[ACC3(i, j, k)] = rmp * (0.25f * dtx * rawx * dumij * dyx);
    drhoy[ACC3(i, j, k)] = rmp * (0.25f * dty * rawy * dvmij * dxy);
    rc = rcK;
    rw = rwK;
    rs = rsK;
  }

  // The bottom level is only ramped.
  drhox[ACC3(i, j, kbm1)] = rmp * drhox[ACC3(i, j, kbm1)];
  drhoy[ACC3(i, j, kbm1)] = rmp * drhoy[ACC3(i, j, kbm1)];
}

}  // namespace

void ext_baropg__hip(real_t *rho, real_t *rmean, real_t *drhox, real_t *drhoy, real_t *zz,
                     real_t *dt, real_t *dum, real_t *dvm, real_t *dx, real_t *dy,
                     real_t *ramp) {
  const int I = im[0], J = jm[0];
  const Range all = range3(0, I, 0, J, 0, kb[0]);
  launch(baropg_rmean, all, rho, rmean, I, J, -1.0f);
  launch(baropg_column, range2(1, imm1[0], 1, jmm1[0]), rho, drhox, drhoy, zz, dt, dum, dvm, dx,
         dy, ramp, I, J, kbm1[0], grav[0]);
  launch(baropg_rmean, all, rho, rmean, I, J, 1.0f);
  finish();
}

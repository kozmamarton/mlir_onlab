// Native HIP reference of ext_advv_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Init variable
POM2K_KERNEL void advv_0(Range r, real_t *__restrict__ vf, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  vf[ACC3(i, j, k)] = 0.0f;
}

// Do vertical advection:
POM2K_KERNEL void advv_1(Range r, const real_t *__restrict__ v, real_t *__restrict__ vf,
                         const real_t *__restrict__ w, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  vf[ACC3(i, j, k)] = 0.25f * (w[ACC3(i, j, k)] + w[ACC3(i, j - 1, k)]) *
                      (v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
}

// Combine horizontal and vertical advection with coriolis, surface slope and
// baroclinic terms, then step forward in time. Level k reads vf(k + 1) before
// level k + 1 overwrites it, so every (i, j) column walks k upwards as in the C
// source; the old vf(k + 1) is carried to the next level in a register. The
// time step only reads vf at its own point, so it is applied right away (the C
// source does it in a separate loop over the same points).
POM2K_KERNEL void advv_2(Range r, real_t *__restrict__ vf, const real_t *__restrict__ vb,
                         const real_t *__restrict__ u, const real_t *__restrict__ advy,
                         const real_t *__restrict__ arv, const real_t *__restrict__ dx,
                         const real_t *__restrict__ dz, const real_t *__restrict__ cor,
                         const real_t *__restrict__ dt, const real_t *__restrict__ egf,
                         const real_t *__restrict__ egb, const real_t *__restrict__ e_atmos,
                         const real_t *__restrict__ drhoy, const real_t *__restrict__ h,
                         const real_t *__restrict__ etf, const real_t *__restrict__ etb, int im,
                         int jm, int kbm1, real_t grav, real_t dti2) {
  POM2K_INDEX(r, i, j, unused_k);
  // Surface slope term (independent of k).
  const real_t slope =
      grav * 0.125f * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
      (egf[ACC2(i, j)] - egf[ACC2(i, j - 1)] + egb[ACC2(i, j)] - egb[ACC2(i, j - 1)] +
       (e_atmos[ACC2(i, j)] - e_atmos[ACC2(i, j - 1)]) * 2.0f) *
      (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]);
  const real_t depthB = (h[ACC2(i, j)] + etb[ACC2(i, j)] + h[ACC2(i, j - 1)] + etb[ACC2(i, j - 1)]) *
                        arv[ACC2(i, j)];
  const real_t depthF = (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i, j - 1)] + etf[ACC2(i, j - 1)]) *
                        arv[ACC2(i, j)];
  real_t vfK = vf[ACC3(i, j, 0)];
  for (int k = 0; k < kbm1; k++) {
    const real_t vfK1 = vf[ACC3(i, j, k + 1)];
    const real_t tend =
        advy[ACC3(i, j, k)] + (vfK - vfK1) * arv[ACC2(i, j)] / dz[k] +
        arv[ACC2(i, j)] * 0.25f *
            (cor[ACC2(i, j)] * dt[ACC2(i, j)] * (u[ACC3(i + 1, j, k)] + u[ACC3(i, j, k)]) +
             cor[ACC2(i, j - 1)] * dt[ACC2(i, j - 1)] *
                 (u[ACC3(i + 1, j - 1, k)] + u[ACC3(i, j - 1, k)])) +
        slope + drhoy[ACC3(i, j, k)];
    // Step forward in time:
    vf[ACC3(i, j, k)] = (depthB * vb[ACC3(i, j, k)] - 2.0f * dti2 * tend) / depthF;
    vfK = vfK1;
  }
}

}  // namespace

void ext_advv__hip(real_t *v, real_t *vf, real_t *vb, real_t *u, real_t *w, real_t *advy,
                   real_t *arv, real_t *dx, real_t *dz, real_t *cor, real_t *dt, real_t *egf,
                   real_t *egb, real_t *e_atmos, real_t *drhoy, real_t *h, real_t *etf,
                   real_t *etb) {
  const int I = im[0], J = jm[0];
  launch(advv_0, range3(0, I, 0, J, 0, kb[0]), vf, I, J);
  launch(advv_1, range3(0, I, 1, J, 1, kbm1[0]), v, vf, w, I, J);
  launch(advv_2, range2(1, imm1[0], 1, jmm1[0]), vf, vb, u, advy, arv, dx, dz, cor, dt, egf,
         egb, e_atmos, drhoy, h, etf, etb, I, J, kbm1[0], grav[0], dti2[0]);
  finish();
}

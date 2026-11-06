// Native HIP reference of ext_advu_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Init variable
POM2K_KERNEL void advu_0(Range r, real_t *__restrict__ uf, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  uf[ACC3(i, j, k)] = 0.0f;
}

// Do vertical advection:
POM2K_KERNEL void advu_1(Range r, const real_t *__restrict__ u, real_t *__restrict__ uf,
                         const real_t *__restrict__ w, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  uf[ACC3(i, j, k)] = 0.25f * (w[ACC3(i, j, k)] + w[ACC3(i - 1, j, k)]) *
                      (u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
}

// Combine horizontal and vertical advection with coriolis, surface slope and
// baroclinic terms, then step forward in time. Level k reads uf(k + 1) before
// level k + 1 overwrites it, so every (i, j) column walks k upwards as in the C
// source; the old uf(k + 1) is carried to the next level in a register. The
// time step only reads uf at its own point, so it is applied right away (the C
// source does it in a separate loop over the same points).
POM2K_KERNEL void advu_2(Range r, real_t *__restrict__ uf, const real_t *__restrict__ ub,
                         const real_t *__restrict__ v, const real_t *__restrict__ advx,
                         const real_t *__restrict__ aru, const real_t *__restrict__ dy,
                         const real_t *__restrict__ dz, const real_t *__restrict__ cor,
                         const real_t *__restrict__ dt, const real_t *__restrict__ egf,
                         const real_t *__restrict__ egb, const real_t *__restrict__ e_atmos,
                         const real_t *__restrict__ drhox, const real_t *__restrict__ h,
                         const real_t *__restrict__ etf, const real_t *__restrict__ etb, int im,
                         int jm, int kbm1, real_t grav, real_t dti2) {
  POM2K_INDEX(r, i, j, unused_k);
  // Surface slope term (independent of k).
  const real_t slope =
      grav * 0.125f * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
      (egf[ACC2(i, j)] - egf[ACC2(i - 1, j)] + egb[ACC2(i, j)] - egb[ACC2(i - 1, j)] +
       (e_atmos[ACC2(i, j)] - e_atmos[ACC2(i - 1, j)]) * 2.0f) *
      (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]);
  const real_t depthB = (h[ACC2(i, j)] + etb[ACC2(i, j)] + h[ACC2(i - 1, j)] + etb[ACC2(i - 1, j)]) *
                        aru[ACC2(i, j)];
  const real_t depthF = (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) *
                        aru[ACC2(i, j)];
  real_t ufK = uf[ACC3(i, j, 0)];
  for (int k = 0; k < kbm1; k++) {
    const real_t ufK1 = uf[ACC3(i, j, k + 1)];
    const real_t tend =
        advx[ACC3(i, j, k)] + (ufK - ufK1) * aru[ACC2(i, j)] / dz[k] -
        aru[ACC2(i, j)] * 0.25f *
            (cor[ACC2(i, j)] * dt[ACC2(i, j)] * (v[ACC3(i, j + 1, k)] + v[ACC3(i, j, k)]) +
             cor[ACC2(i - 1, j)] * dt[ACC2(i - 1, j)] *
                 (v[ACC3(i - 1, j + 1, k)] + v[ACC3(i - 1, j, k)])) +
        slope + drhox[ACC3(i, j, k)];
    // Step forward in time:
    uf[ACC3(i, j, k)] = (depthB * ub[ACC3(i, j, k)] - 2.0f * dti2 * tend) / depthF;
    ufK = ufK1;
  }
}

}  // namespace

void ext_advu__hip(real_t *u, real_t *uf, real_t *ub, real_t *v, real_t *w, real_t *advx,
                   real_t *aru, real_t *dy, real_t *dz, real_t *cor, real_t *dt, real_t *egf,
                   real_t *egb, real_t *e_atmos, real_t *drhox, real_t *h, real_t *etf,
                   real_t *etb) {
  const int I = im[0], J = jm[0];
  launch(advu_0, range3(0, I, 0, J, 0, kb[0]), uf, I, J);
  launch(advu_1, range3(1, I, 0, J, 1, kbm1[0]), u, uf, w, I, J);
  launch(advu_2, range2(1, imm1[0], 1, jmm1[0]), uf, ub, v, advx, aru, dy, dz, cor, dt, egf,
         egb, e_atmos, drhox, h, etf, etb, I, J, kbm1[0], grav[0], dti2[0]);
  finish();
}

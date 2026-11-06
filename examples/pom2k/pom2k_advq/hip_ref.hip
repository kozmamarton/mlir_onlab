// Native HIP reference of ext_advq_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Horizontal fluxes: advection, then diffusion, then the face width. The C
// source runs advection and diffusion as two loops over the same points that
// only touch the flux of their own point, so both run in one kernel and the
// fluxes stay in registers until they are stored.
POM2K_KERNEL void advq_0(Range r, const real_t *__restrict__ q, const real_t *__restrict__ qb,
                         real_t *__restrict__ xflux, real_t *__restrict__ yflux,
                         const real_t *__restrict__ dt, const real_t *__restrict__ u,
                         const real_t *__restrict__ v, const real_t *__restrict__ aam,
                         const real_t *__restrict__ h, const real_t *__restrict__ dum,
                         const real_t *__restrict__ dx, const real_t *__restrict__ dvm,
                         const real_t *__restrict__ dy, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  // Calculate horizontal advection.
  real_t xf = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i - 1, j, k)]) *
              (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
              (u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
  real_t yf = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i, j - 1, k)]) *
              (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
              (v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
  // Calculate horizontal diffusion; dum/dvm mask the fluxes over land.
  xf -= dum[ACC2(i, j)] * 0.25f *
        (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)] + aam[ACC3(i, j, k - 1)] +
         aam[ACC3(i - 1, j, k - 1)]) *
        (h[ACC2(i, j)] + h[ACC2(i - 1, j)]) * (qb[ACC3(i, j, k)] - qb[ACC3(i - 1, j, k)]) /
        (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);
  yf -= dvm[ACC2(i, j)] * 0.25f *
        (aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)] + aam[ACC3(i, j, k - 1)] +
         aam[ACC3(i, j - 1, k - 1)]) *
        (h[ACC2(i, j)] + h[ACC2(i, j - 1)]) * (qb[ACC3(i, j, k)] - qb[ACC3(i, j - 1, k)]) /
        (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);
  xflux[ACC3(i, j, k)] = xf * (0.5f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]));
  yflux[ACC3(i, j, k)] = yf * (0.5f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]));
}

// Calculate vertical advection, add flux terms, then step forward in time.
POM2K_KERNEL void advq_1(Range r, const real_t *__restrict__ qb, const real_t *__restrict__ q,
                         real_t *__restrict__ qf, const real_t *__restrict__ xflux,
                         const real_t *__restrict__ yflux, const real_t *__restrict__ h,
                         const real_t *__restrict__ w, const real_t *__restrict__ dz,
                         const real_t *__restrict__ art, const real_t *__restrict__ etb,
                         const real_t *__restrict__ etf, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  const real_t tend = (w[ACC3(i, j, k - 1)] * q[ACC3(i, j, k - 1)] -
                       w[ACC3(i, j, k + 1)] * q[ACC3(i, j, k + 1)]) *
                          art[ACC2(i, j)] / (dz[k] + dz[k - 1]) +
                      xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                      yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)];
  qf[ACC3(i, j, k)] =
      ((h[ACC2(i, j)] + etb[ACC2(i, j)]) * art[ACC2(i, j)] * qb[ACC3(i, j, k)] - dti2 * tend) /
      ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
}

}  // namespace

void ext_advq__hip(real_t *qb, real_t *q, real_t *qf, real_t *xflux, real_t *yflux, real_t *dt,
                   real_t *u, real_t *v, real_t *aam, real_t *h, real_t *dum, real_t *dx,
                   real_t *dvm, real_t *dy, real_t *w, real_t *dz, real_t *art, real_t *etb,
                   real_t *etf) {
  launch(advq_0, range3(1, im[0], 1, jm[0], 1, kbm1[0]), q, qb, xflux, yflux, dt, u, v, aam, h,
         dum, dx, dvm, dy, im[0], jm[0]);
  launch(advq_1, range3(1, imm1[0], 1, jmm1[0], 1, kbm1[0]), qb, q, qf, xflux, yflux, h, w, dz,
         art, etb, etf, im[0], jm[0], dti2[0]);
  finish();
}

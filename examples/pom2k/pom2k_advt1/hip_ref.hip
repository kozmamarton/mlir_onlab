// Native HIP reference of ext_advt1_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Reset boundaries
POM2K_KERNEL void advt1_0(Range r, real_t *__restrict__ fb, real_t *__restrict__ f, int im,
                          int jm, int kbm1, int kbm2) {
  POM2K_INDEX(r, i, j, k);
  f[ACC3(i, j, kbm1)] = f[ACC3(i, j, kbm2)];
  fb[ACC3(i, j, kbm1)] = fb[ACC3(i, j, kbm2)];
}

// fb -= fclim (sign = -1) before the diffusive fluxes, fb += fclim (sign = +1)
// after them, as in the C source (the round trip is not bitwise neutral).
POM2K_KERNEL void advt1_clim(Range r, real_t *__restrict__ fb, const real_t *__restrict__ fclim,
                             int im, int jm, real_t sign) {
  POM2K_INDEX(r, i, j, k);
  if (sign < 0.0f)
    fb[ACC3(i, j, k)] = fb[ACC3(i, j, k)] - fclim[ACC3(i, j, k)];
  else
    fb[ACC3(i, j, k)] += fclim[ACC3(i, j, k)];
}

// Horizontal fluxes: advective, then diffusive, then the face width. The C
// source computes the advective fluxes in a separate loop over the same points
// (before fb -= fclim, which they do not read); here both parts run in one
// kernel and the fluxes stay in registers until they are stored.
POM2K_KERNEL void advt1_1(Range r, const real_t *__restrict__ f, const real_t *__restrict__ fb,
                          real_t *__restrict__ xflux, real_t *__restrict__ yflux,
                          const real_t *__restrict__ u, const real_t *__restrict__ v,
                          const real_t *__restrict__ dt, const real_t *__restrict__ aam,
                          const real_t *__restrict__ dum, const real_t *__restrict__ dvm,
                          const real_t *__restrict__ dx, const real_t *__restrict__ dy,
                          const real_t *__restrict__ h, int im, int jm, real_t tprni) {
  POM2K_INDEX(r, i, j, k);
  // Do advective fluxes
  real_t xf = 0.25f * ((dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                       (f[ACC3(i, j, k)] + f[ACC3(i - 1, j, k)]) * u[ACC3(i, j, k)]);
  real_t yf = 0.25f * ((dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                       (f[ACC3(i, j, k)] + f[ACC3(i, j - 1, k)]) * v[ACC3(i, j, k)]);
  // Add diffusive fluxes
  xf -= 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)]) *
        (h[ACC2(i, j)] + h[ACC2(i - 1, j)]) * tprni *
        (fb[ACC3(i, j, k)] - fb[ACC3(i - 1, j, k)]) * dum[ACC2(i, j)] /
        (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);
  yf -= 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)]) *
        (h[ACC2(i, j)] + h[ACC2(i, j - 1)]) * tprni *
        (fb[ACC3(i, j, k)] - fb[ACC3(i, j - 1, k)]) * dvm[ACC2(i, j)] /
        (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);
  xflux[ACC3(i, j, k)] = 0.5f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) * xf;
  yflux[ACC3(i, j, k)] = 0.5f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) * yf;
}

// Do vertical advection: surface and bottom levels
POM2K_KERNEL void advt1_2(Range r, const real_t *__restrict__ f, real_t *__restrict__ zflux,
                          const real_t *__restrict__ w, const real_t *__restrict__ art, int im,
                          int jm, int kbm1) {
  POM2K_INDEX(r, i, j, k);
  zflux[ACC3(i, j, 0)] = f[ACC3(i, j, 0)] * w[ACC3(i, j, 0)] * art[ACC2(i, j)];
  zflux[ACC3(i, j, kbm1)] = 0.0f;
}

// and interior levels
POM2K_KERNEL void advt1_3(Range r, const real_t *__restrict__ f, real_t *__restrict__ zflux,
                          const real_t *__restrict__ w, const real_t *__restrict__ art, int im,
                          int jm) {
  POM2K_INDEX(r, i, j, k);
  zflux[ACC3(i, j, k)] =
      0.5f * (f[ACC3(i, j, k - 1)] + f[ACC3(i, j, k)]) * w[ACC3(i, j, k)] * art[ACC2(i, j)];
}

// Add net horizontal fluxes and then step forward in time
POM2K_KERNEL void advt1_4(Range r, const real_t *__restrict__ fb, real_t *__restrict__ ff,
                          const real_t *__restrict__ xflux, const real_t *__restrict__ yflux,
                          const real_t *__restrict__ zflux, const real_t *__restrict__ dz,
                          const real_t *__restrict__ h, const real_t *__restrict__ art,
                          const real_t *__restrict__ etb, const real_t *__restrict__ etf,
                          int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  const real_t tend = xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                      yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)] +
                      (zflux[ACC3(i, j, k)] - zflux[ACC3(i, j, k + 1)]) / dz[k];
  ff[ACC3(i, j, k)] =
      (fb[ACC3(i, j, k)] * (h[ACC2(i, j)] + etb[ACC2(i, j)]) * art[ACC2(i, j)] - dti2 * tend) /
      ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
}

}  // namespace

void ext_advt1__hip(real_t *fb, real_t *f, real_t *fclim, real_t *ff, real_t *xflux,
                    real_t *yflux, real_t *zflux, real_t *u, real_t *v, real_t *dt,
                    real_t *aam, real_t *dum, real_t *dvm, real_t *dx, real_t *dy, real_t *dz,
                    real_t *h, real_t *w, real_t *art, real_t *etb, real_t *etf) {
  const int I = im[0], J = jm[0];
  const Range all = range3(0, I, 0, J, 0, kb[0]);
  const Range interior = range3(1, imm1[0], 1, jmm1[0], 0, kbm1[0]);
  launch(advt1_0, range2(0, I, 0, J), fb, f, I, J, kbm1[0], kbm2[0]);
  launch(advt1_clim, all, fb, fclim, I, J, -1.0f);
  launch(advt1_1, range3(1, I, 1, J, 0, kbm1[0]), f, fb, xflux, yflux, u, v, dt, aam, dum, dvm,
         dx, dy, h, I, J, tprni[0]);
  launch(advt1_clim, all, fb, fclim, I, J, 1.0f);
  launch(advt1_2, range2(1, imm1[0], 1, jmm1[0]), f, zflux, w, art, I, J, kbm1[0]);
  launch(advt1_3, range3(1, imm1[0], 1, jmm1[0], 1, kbm1[0]), f, zflux, w, art, I, J);
  launch(advt1_4, interior, fb, ff, xflux, yflux, zflux, dz, h, art, etb, etf, I, J, dti2[0]);
  finish();
}

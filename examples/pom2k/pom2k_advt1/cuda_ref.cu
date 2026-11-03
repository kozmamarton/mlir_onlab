// Native CUDA reference of ext_advt1_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

// Reset boundaries
__global__ void advt1_0(Range r, real_t *fb, real_t *f, int im, int jm, int kbm1, int kbm2) {
  POM2K_INDEX(r, i, j, k);
  f[ACC3(i, j, kbm1)] = f[ACC3(i, j, kbm2)];
  fb[ACC3(i, j, kbm1)] = fb[ACC3(i, j, kbm2)];
}

// Do advective fluxes
__global__ void advt1_1(Range r, const real_t *f, real_t *xflux, real_t *yflux, const real_t *u,
                        const real_t *v, const real_t *dt, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  xflux[ACC3(i, j, k)] = 0.25f * ((dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                                  (f[ACC3(i, j, k)] + f[ACC3(i - 1, j, k)]) * u[ACC3(i, j, k)]);
  yflux[ACC3(i, j, k)] = 0.25f * ((dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                                  (f[ACC3(i, j, k)] + f[ACC3(i, j - 1, k)]) * v[ACC3(i, j, k)]);
}

__global__ void advt1_2(Range r, real_t *fb, const real_t *fclim, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  fb[ACC3(i, j, k)] = fb[ACC3(i, j, k)] - fclim[ACC3(i, j, k)];
}

// Add diffusive fluxes
__global__ void advt1_3(Range r, const real_t *fb, real_t *xflux, real_t *yflux,
                        const real_t *aam, const real_t *dum, const real_t *dvm,
                        const real_t *dx, const real_t *dy, const real_t *h, int im, int jm,
                        real_t tprni) {
  POM2K_INDEX(r, i, j, k);
  xflux[ACC3(i, j, k)] -= 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)]) *
                          (h[ACC2(i, j)] + h[ACC2(i - 1, j)]) * tprni *
                          (fb[ACC3(i, j, k)] - fb[ACC3(i - 1, j, k)]) * dum[ACC2(i, j)] /
                          (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);
  yflux[ACC3(i, j, k)] -= 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)]) *
                          (h[ACC2(i, j)] + h[ACC2(i, j - 1)]) * tprni *
                          (fb[ACC3(i, j, k)] - fb[ACC3(i, j - 1, k)]) * dvm[ACC2(i, j)] /
                          (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);
  xflux[ACC3(i, j, k)] = 0.5f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) * xflux[ACC3(i, j, k)];
  yflux[ACC3(i, j, k)] = 0.5f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) * yflux[ACC3(i, j, k)];
}

__global__ void advt1_4(Range r, real_t *fb, const real_t *fclim, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  fb[ACC3(i, j, k)] += fclim[ACC3(i, j, k)];
}

// Do vertical advection
__global__ void advt1_5(Range r, const real_t *f, real_t *zflux, const real_t *w,
                        const real_t *art, int im, int jm, int kbm1) {
  POM2K_INDEX(r, i, j, k);
  zflux[ACC3(i, j, 0)] = f[ACC3(i, j, 0)] * w[ACC3(i, j, 0)] * art[ACC2(i, j)];
  zflux[ACC3(i, j, kbm1)] = 0.0f;
}

__global__ void advt1_6(Range r, const real_t *f, real_t *zflux, const real_t *w,
                        const real_t *art, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  zflux[ACC3(i, j, k)] =
      0.5f * (f[ACC3(i, j, k - 1)] + f[ACC3(i, j, k)]) * w[ACC3(i, j, k)] * art[ACC2(i, j)];
}

// Add net horizontal fluxes and then step forward in time
__global__ void advt1_7(Range r, const real_t *fb, real_t *ff, const real_t *xflux,
                        const real_t *yflux, const real_t *zflux, const real_t *dz,
                        const real_t *h, const real_t *art, const real_t *etb,
                        const real_t *etf, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  ff[ACC3(i, j, k)] = xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                      yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)] +
                      (zflux[ACC3(i, j, k)] - zflux[ACC3(i, j, k + 1)]) / dz[k];

  ff[ACC3(i, j, k)] = (fb[ACC3(i, j, k)] * (h[ACC2(i, j)] + etb[ACC2(i, j)]) * art[ACC2(i, j)] -
                       dti2 * ff[ACC3(i, j, k)]) /
                      ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
}

}  // namespace

void ext_advt1__cuda(real_t *fb, real_t *f, real_t *fclim, real_t *ff, real_t *xflux,
                     real_t *yflux, real_t *zflux, real_t *u, real_t *v, real_t *dt,
                     real_t *aam, real_t *dum, real_t *dvm, real_t *dx, real_t *dy, real_t *dz,
                     real_t *h, real_t *w, real_t *art, real_t *etb, real_t *etf) {
  const int I = im[0], J = jm[0];
  launch(advt1_0, range2(0, I, 0, J), fb, f, I, J, kbm1[0], kbm2[0]);
  launch(advt1_1, range3(1, I, 1, J, 0, kbm1[0]), f, xflux, yflux, u, v, dt, I, J);
  launch(advt1_2, range3(0, I, 0, J, 0, kb[0]), fb, fclim, I, J);
  launch(advt1_3, range3(1, I, 1, J, 0, kbm1[0]), fb, xflux, yflux, aam, dum, dvm, dx, dy, h, I,
         J, tprni[0]);
  launch(advt1_4, range3(0, I, 0, J, 0, kb[0]), fb, fclim, I, J);
  launch(advt1_5, range2(1, imm1[0], 1, jmm1[0]), f, zflux, w, art, I, J, kbm1[0]);
  launch(advt1_6, range3(1, imm1[0], 1, jmm1[0], 1, kbm1[0]), f, zflux, w, art, I, J);
  launch(advt1_7, range3(1, imm1[0], 1, jmm1[0], 0, kbm1[0]), fb, ff, xflux, yflux, zflux, dz, h,
         art, etb, etf, I, J, dti2[0]);
  finish();
}

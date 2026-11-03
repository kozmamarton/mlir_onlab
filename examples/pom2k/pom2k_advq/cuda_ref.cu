// Native CUDA reference of ext_advq_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

// Calculate horizontal advection.
__global__ void advq_0(Range r, const real_t *q, real_t *xflux, real_t *yflux, const real_t *dt,
                       const real_t *u, const real_t *v, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  xflux[ACC3(i, j, k)] = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i - 1, j, k)]) *
                         (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                         (u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
  yflux[ACC3(i, j, k)] = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i, j - 1, k)]) *
                         (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                         (v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
}

// Calculate horizontal diffusion.
__global__ void advq_1(Range r, const real_t *qb, real_t *xflux, real_t *yflux,
                       const real_t *aam, const real_t *h, const real_t *dum, const real_t *dx,
                       const real_t *dvm, const real_t *dy, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  // dum masks xflux over land (dum=0)!
  xflux[ACC3(i, j, k)] -= dum[ACC2(i, j)] * 0.25f *
                          (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)] +
                           aam[ACC3(i, j, k - 1)] + aam[ACC3(i - 1, j, k - 1)]) *
                          (h[ACC2(i, j)] + h[ACC2(i - 1, j)]) *
                          (qb[ACC3(i, j, k)] - qb[ACC3(i - 1, j, k)]) /
                          (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);

  // dvm masks yflux over land (dvm=0)!
  yflux[ACC3(i, j, k)] -= dvm[ACC2(i, j)] * 0.25f *
                          (aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)] +
                           aam[ACC3(i, j, k - 1)] + aam[ACC3(i, j - 1, k - 1)]) *
                          (h[ACC2(i, j)] + h[ACC2(i, j - 1)]) *
                          (qb[ACC3(i, j, k)] - qb[ACC3(i, j - 1, k)]) /
                          (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);

  xflux[ACC3(i, j, k)] *= 0.5f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]);
  yflux[ACC3(i, j, k)] *= 0.5f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]);
}

// Calculate vertical advection, add flux terms, then step forward in time.
__global__ void advq_2(Range r, const real_t *qb, const real_t *q, real_t *qf,
                       const real_t *xflux, const real_t *yflux, const real_t *h,
                       const real_t *w, const real_t *dz, const real_t *art, const real_t *etb,
                       const real_t *etf, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  qf[ACC3(i, j, k)] = (w[ACC3(i, j, k - 1)] * q[ACC3(i, j, k - 1)] -
                       w[ACC3(i, j, k + 1)] * q[ACC3(i, j, k + 1)]) *
                          art[ACC2(i, j)] / (dz[k] + dz[k - 1]) +
                      xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                      yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)];
  qf[ACC3(i, j, k)] = ((h[ACC2(i, j)] + etb[ACC2(i, j)]) * art[ACC2(i, j)] * qb[ACC3(i, j, k)] -
                       (dti2)*qf[ACC3(i, j, k)]) /
                      ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
}

}  // namespace

void ext_advq__cuda(real_t *qb, real_t *q, real_t *qf, real_t *xflux, real_t *yflux, real_t *dt,
                    real_t *u, real_t *v, real_t *aam, real_t *h, real_t *dum, real_t *dx,
                    real_t *dvm, real_t *dy, real_t *w, real_t *dz, real_t *art, real_t *etb,
                    real_t *etf) {
  const Range r = range3(1, im[0], 1, jm[0], 1, kbm1[0]);
  launch(advq_0, r, q, xflux, yflux, dt, u, v, im[0], jm[0]);
  launch(advq_1, r, qb, xflux, yflux, aam, h, dum, dx, dvm, dy, im[0], jm[0]);
  launch(advq_2, range3(1, imm1[0], 1, jmm1[0], 1, kbm1[0]), qb, q, qf, xflux, yflux, h, w, dz,
         art, etb, etf, im[0], jm[0], dti2[0]);
  finish();
}

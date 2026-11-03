// Native CUDA reference of ext_advu_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

// Init variable
__global__ void advu_0(Range r, real_t *uf, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  uf[ACC3(i, j, k)] = 0.0f;
}

// Do vertical advection:
__global__ void advu_1(Range r, const real_t *u, real_t *uf, const real_t *w, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  uf[ACC3(i, j, k)] =
      0.25f * (w[ACC3(i, j, k)] + w[ACC3(i - 1, j, k)]) * (u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
}

// Combine horizontal and vertical advection with coriolis, surface slope and
// baroclinic terms. Level k reads uf(k + 1) before level k + 1 overwrites it,
// so every (i, j) column walks k upwards as in the C source.
__global__ void advu_2(Range r, real_t *uf, const real_t *v, const real_t *advx,
                       const real_t *aru, const real_t *dy, const real_t *dz,
                       const real_t *cor, const real_t *dt, const real_t *egf,
                       const real_t *egb, const real_t *e_atmos, const real_t *drhox, int im,
                       int jm, int kbm1, real_t grav) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 0; k < kbm1; k++) {
    uf[ACC3(i, j, k)] =
        advx[ACC3(i, j, k)] +
        (uf[ACC3(i, j, k)] - uf[ACC3(i, j, k + 1)]) * aru[ACC2(i, j)] / dz[k] -
        aru[ACC2(i, j)] * 0.25f *
            (cor[ACC2(i, j)] * dt[ACC2(i, j)] * (v[ACC3(i, j + 1, k)] + v[ACC3(i, j, k)]) +
             cor[ACC2(i - 1, j)] * dt[ACC2(i - 1, j)] *
                 (v[ACC3(i - 1, j + 1, k)] + v[ACC3(i - 1, j, k)])) +
        grav * 0.125f * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
            (egf[ACC2(i, j)] - egf[ACC2(i - 1, j)] + egb[ACC2(i, j)] - egb[ACC2(i - 1, j)] +
             (e_atmos[ACC2(i, j)] - e_atmos[ACC2(i - 1, j)]) * 2.0f) *
            (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) +
        drhox[ACC3(i, j, k)];
  }
}

// Step forward in time:
__global__ void advu_3(Range r, real_t *uf, const real_t *ub, const real_t *aru, const real_t *h,
                       const real_t *etf, const real_t *etb, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  uf[ACC3(i, j, k)] =
      ((h[ACC2(i, j)] + etb[ACC2(i, j)] + h[ACC2(i - 1, j)] + etb[ACC2(i - 1, j)]) *
           aru[ACC2(i, j)] * ub[ACC3(i, j, k)] -
       2.0f * dti2 * uf[ACC3(i, j, k)]) /
      ((h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) *
       aru[ACC2(i, j)]);
}

}  // namespace

void ext_advu__cuda(real_t *u, real_t *uf, real_t *ub, real_t *v, real_t *w, real_t *advx,
                    real_t *aru, real_t *dy, real_t *dz, real_t *cor, real_t *dt, real_t *egf,
                    real_t *egb, real_t *e_atmos, real_t *drhox, real_t *h, real_t *etf,
                    real_t *etb) {
  const int I = im[0], J = jm[0];
  launch(advu_0, range3(0, I, 0, J, 0, kb[0]), uf, I, J);
  launch(advu_1, range3(1, I, 0, J, 1, kbm1[0]), u, uf, w, I, J);
  launch(advu_2, range2(1, imm1[0], 1, jmm1[0]), uf, v, advx, aru, dy, dz, cor, dt, egf, egb,
         e_atmos, drhox, I, J, kbm1[0], grav[0]);
  launch(advu_3, range3(1, imm1[0], 1, jmm1[0], 0, kbm1[0]), uf, ub, aru, h, etf, etb, I, J,
         dti2[0]);
  finish();
}

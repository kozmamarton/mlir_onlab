// Native CUDA reference of ext_advv_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

// Init variable
__global__ void advv_0(Range r, real_t *vf, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  vf[ACC3(i, j, k)] = 0.0f;
}

// Do vertical advection:
__global__ void advv_1(Range r, const real_t *v, real_t *vf, const real_t *w, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  vf[ACC3(i, j, k)] =
      0.25f * (w[ACC3(i, j, k)] + w[ACC3(i, j - 1, k)]) * (v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
}

// Combine horizontal and vertical advection with coriolis, surface slope and
// baroclinic terms. Level k reads vf(k + 1) before level k + 1 overwrites it,
// so every (i, j) column walks k upwards as in the C source.
__global__ void advv_2(Range r, real_t *vf, const real_t *u, const real_t *advy,
                       const real_t *arv, const real_t *dx, const real_t *dz,
                       const real_t *cor, const real_t *dt, const real_t *egf,
                       const real_t *egb, const real_t *e_atmos, const real_t *drhoy, int im,
                       int jm, int kbm1, real_t grav) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 0; k < kbm1; k++) {
    vf[ACC3(i, j, k)] =
        advy[ACC3(i, j, k)] +
        (vf[ACC3(i, j, k)] - vf[ACC3(i, j, k + 1)]) * arv[ACC2(i, j)] / dz[k] +
        arv[ACC2(i, j)] * 0.25f *
            (cor[ACC2(i, j)] * dt[ACC2(i, j)] * (u[ACC3(i + 1, j, k)] + u[ACC3(i, j, k)]) +
             cor[ACC2(i, j - 1)] * dt[ACC2(i, j - 1)] *
                 (u[ACC3(i + 1, j - 1, k)] + u[ACC3(i, j - 1, k)])) +
        grav * 0.125f * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
            (egf[ACC2(i, j)] - egf[ACC2(i, j - 1)] + egb[ACC2(i, j)] - egb[ACC2(i, j - 1)] +
             (e_atmos[ACC2(i, j)] - e_atmos[ACC2(i, j - 1)]) * 2.0f) *
            (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) +
        drhoy[ACC3(i, j, k)];
  }
}

// Step forward in time:
__global__ void advv_3(Range r, real_t *vf, const real_t *vb, const real_t *arv, const real_t *h,
                       const real_t *etf, const real_t *etb, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  vf[ACC3(i, j, k)] =
      ((h[ACC2(i, j)] + etb[ACC2(i, j)] + h[ACC2(i, j - 1)] + etb[ACC2(i, j - 1)]) *
           arv[ACC2(i, j)] * vb[ACC3(i, j, k)] -
       2.0f * dti2 * vf[ACC3(i, j, k)]) /
      ((h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i, j - 1)] + etf[ACC2(i, j - 1)]) *
       arv[ACC2(i, j)]);
}

}  // namespace

void ext_advv__cuda(real_t *v, real_t *vf, real_t *vb, real_t *u, real_t *w, real_t *advy,
                    real_t *arv, real_t *dx, real_t *dz, real_t *cor, real_t *dt, real_t *egf,
                    real_t *egb, real_t *e_atmos, real_t *drhoy, real_t *h, real_t *etf,
                    real_t *etb) {
  const int I = im[0], J = jm[0];
  launch(advv_0, range3(0, I, 0, J, 0, kb[0]), vf, I, J);
  launch(advv_1, range3(0, I, 1, J, 1, kbm1[0]), v, vf, w, I, J);
  launch(advv_2, range2(1, imm1[0], 1, jmm1[0]), vf, u, advy, arv, dx, dz, cor, dt, egf, egb,
         e_atmos, drhoy, I, J, kbm1[0], grav[0]);
  launch(advv_3, range3(1, imm1[0], 1, jmm1[0], 0, kbm1[0]), vf, vb, arv, h, etf, etb, I, J,
         dti2[0]);
  finish();
}

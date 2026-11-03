// Native CUDA reference of ext_proft_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void proft_0(Range r, real_t *dh, const real_t *h, const real_t *etf, int im) {
  POM2K_INDEX(r, i, j, k);
  dh[ACC2(i, j)] = h[ACC2(i, j)] + etf[ACC2(i, j)];
}

__global__ void proft_1(Range r, const real_t *dh, real_t *a, const real_t *kh,
                        const real_t *dz, const real_t *dzz, int im, int jm, real_t dti2,
                        real_t umol) {
  POM2K_INDEX(r, i, j, k);
  a[ACC3(i, j, k)] =
      -dti2 * (kh[ACC3(i, j, k + 1)] + umol) / (dz[k] * dzz[k] * dh[ACC2(i, j)] * dh[ACC2(i, j)]);
}

__global__ void proft_2(Range r, const real_t *dh, const real_t *kh, real_t *c,
                        const real_t *dz, const real_t *dzz, int im, int jm, real_t dti2,
                        real_t umol) {
  POM2K_INDEX(r, i, j, k);
  c[ACC3(i, j, k)] = -dti2 * (kh[ACC3(i, j, k)] + umol) /
                     (dz[k] * dzz[k - 1] * dh[ACC2(i, j)] * dh[ACC2(i, j)]);
}

__global__ void proft_3(Range r, real_t *rad2, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  rad2[ACC3(i, j, k)] = 0.0f;
}

// nbc == 2 or nbc == 4 only (penetrative radiation):
__global__ void proft_4(Range r, const real_t *dh, const real_t *z, const real_t *swrad,
                        real_t *rad2, int im, int jm, int ntp) {
  POM2K_INDEX(r, i, j, k);
  const real_t r_[5] = {0.58f, 0.62f, 0.67f, 0.77f, 0.78f};
  const real_t ad1[5] = {0.35f, 0.6f, 1.0f, 1.5f, 1.4f};
  const real_t ad2[5] = {23.0f, 20.0f, 17.0f, 14.0f, 7.9f};
  rad2[ACC3(i, j, k)] = swrad[ACC2(i, j)] *
                        (r_[ntp - 1] * expf(z[k] * dh[ACC2(i, j)] / ad1[ntp - 1]) +
                         (1.0f - r_[ntp - 1]) * expf(z[k] * dh[ACC2(i, j)] / ad2[ntp - 1]));
}

// Surface boundary condition, nbc == 1:
__global__ void proft_5(Range r, const real_t *f, const real_t *wfsurf, const real_t *dh,
                        const real_t *a, real_t *ee, real_t *gg, const real_t *dz, int im,
                        int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
  gg[ACC3(i, j, 0)] = -dti2 * wfsurf[ACC2(i, j)] / (-dz[0] * dh[ACC2(i, j)]) - f[ACC3(i, j, 0)];
  gg[ACC3(i, j, 0)] = gg[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
}

// nbc == 2:
__global__ void proft_6(Range r, const real_t *f, const real_t *wfsurf, const real_t *dh,
                        const real_t *a, real_t *ee, real_t *gg, const real_t *dz,
                        const real_t *rad2, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
  gg[ACC3(i, j, 0)] = dti2 * (wfsurf[ACC2(i, j)] + rad2[ACC3(i, j, 0)] - rad2[ACC3(i, j, 1)]) /
                          (dz[0] * dh[ACC2(i, j)]) -
                      f[ACC3(i, j, 0)];
  gg[ACC3(i, j, 0)] = gg[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
}

// nbc == 3 or nbc == 4:
__global__ void proft_7(Range r, const real_t *fsurf, real_t *ee, real_t *gg, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  ee[ACC3(i, j, 0)] = 0.0f;
  gg[ACC3(i, j, 0)] = fsurf[ACC2(i, j)];
}

// Forward sweep: level k depends on level k - 1 of the same (i, j) column.
__global__ void proft_8(Range r, const real_t *f, const real_t *dh, const real_t *a,
                        const real_t *c, real_t *ee, real_t *gg, const real_t *dz,
                        const real_t *rad2, int im, int jm, int kbm2, real_t dti2) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 1; k < kbm2; k++) {
    gg[ACC3(i, j, k)] =
        1.0f / (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
    ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
    gg[ACC3(i, j, k)] = (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - f[ACC3(i, j, k)] +
                         dti2 * (rad2[ACC3(i, j, k)] - rad2[ACC3(i, j, k + 1)]) /
                             (dh[ACC2(i, j)] * dz[k])) *
                        gg[ACC3(i, j, k)];
  }
}

// Bottom adiabatic boundary condition:
__global__ void proft_9(Range r, real_t *f, const real_t *dh, const real_t *c, const real_t *ee,
                        const real_t *gg, const real_t *dz, const real_t *rad2, int im, int jm,
                        int kb, int kbm2, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  f[ACC3(i, j, kbm2)] =
      (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] - f[ACC3(i, j, kbm2)] +
       dti2 * (rad2[ACC3(i, j, kbm2)] - rad2[ACC3(i, j, kb - 1)]) / (dh[ACC2(i, j)] * dz[kbm2])) /
      (c[ACC3(i, j, kbm2)] * (1.0f - ee[ACC3(i, j, kbm2 - 1)]) - 1.0f);
}

// Back substitution: level k depends on level k + 1 of the same column.
__global__ void proft_10(Range r, real_t *f, const real_t *ee, const real_t *gg, int im, int jm,
                         int kb) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = kb - 3; k >= 0; k--) {
    f[ACC3(i, j, k)] = (ee[ACC3(i, j, k)] * f[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]);
  }
}

}  // namespace

// nbc lives in managed memory and is read on the host, like the branch
// conditions of the C source.
void ext_proft__cuda(real_t *f, real_t *wfsurf, real_t *fsurf, int *nbc, real_t *dh, real_t *h,
                     real_t *etf, real_t *a, real_t *kh, real_t *c, real_t *z, real_t *swrad,
                     real_t *ee, real_t *gg, real_t *dz, real_t *dzz, real_t *rad2) {
  const int I = im[0], J = jm[0], K = kb[0], KM1 = kbm1[0], KM2 = kbm2[0];
  const Range plane = range2(0, I, 0, J);
  launch(proft_0, plane, dh, h, etf, I);
  launch(proft_1, range3(0, I, 0, J, 0, KM2), dh, a, kh, dz, dzz, I, J, dti2[0], umol[0]);
  launch(proft_2, range3(0, I, 0, J, 1, KM1), dh, kh, c, dz, dzz, I, J, dti2[0], umol[0]);
  launch(proft_3, range3(0, I, 0, J, 0, K), rad2, I, J);
  if ((*nbc) == 2 || (*nbc) == 4)
    launch(proft_4, range3(0, I, 0, J, 0, KM1), dh, z, swrad, rad2, I, J, ntp[0]);
  if ((*nbc) == 1)
    launch(proft_5, plane, f, wfsurf, dh, a, ee, gg, dz, I, J, dti2[0]);
  else if ((*nbc) == 2)
    launch(proft_6, plane, f, wfsurf, dh, a, ee, gg, dz, rad2, I, J, dti2[0]);
  else if ((*nbc) == 3 || (*nbc) == 4)
    launch(proft_7, plane, fsurf, ee, gg, I, J);
  launch(proft_8, plane, f, dh, a, c, ee, gg, dz, rad2, I, J, KM2, dti2[0]);
  launch(proft_9, plane, f, dh, c, ee, gg, dz, rad2, I, J, K, KM2, dti2[0]);
  launch(proft_10, plane, f, ee, gg, I, J, K);
  finish();
}

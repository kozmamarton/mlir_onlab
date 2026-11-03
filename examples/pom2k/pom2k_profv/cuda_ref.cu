// Native CUDA reference of ext_profv_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void profv_0(Range r, real_t *dhloc, int im) {
  POM2K_INDEX(r, i, j, k);
  dhloc[ACC2(i, j)] = 1.0f;
}

__global__ void profv_1(Range r, const real_t *etf, const real_t *h, real_t *dhloc, int im) {
  POM2K_INDEX(r, i, j, k);
  dhloc[ACC2(i, j)] =
      0.5f * (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i, j - 1)] + etf[ACC2(i, j - 1)]);
}

__global__ void profv_2(Range r, real_t *c, const real_t *km, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  c[ACC3(i, j, k)] = (km[ACC3(i, j, k)] + km[ACC3(i, j - 1, k)]) * 0.5f;
}

__global__ void profv_3(Range r, const real_t *c, real_t *a, const real_t *dz, const real_t *dzz,
                        const real_t *dhloc, int im, int jm, real_t dti2, real_t umol) {
  POM2K_INDEX(r, i, j, k);
  a[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k + 1)] + umol) /
                     (dz[k] * dzz[k] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
}

__global__ void profv_4(Range r, real_t *c, const real_t *dz, const real_t *dzz,
                        const real_t *dhloc, int im, int jm, real_t dti2, real_t umol) {
  POM2K_INDEX(r, i, j, k);
  c[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k)] + umol) /
                     (dz[k] * dzz[k - 1] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
}

__global__ void profv_5(Range r, const real_t *a, const real_t *dz, real_t *ee, real_t *gg,
                        const real_t *wvsurf, const real_t *vf, const real_t *dhloc, int im,
                        int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
  gg[ACC3(i, j, 0)] =
      (-dti2 * wvsurf[ACC2(i, j)] / (-(dz[0]) * dhloc[ACC2(i, j)]) - vf[ACC3(i, j, 0)]) /
      (a[ACC3(i, j, 0)] - 1.0f);
}

// Forward sweep: level k depends on level k - 1 of the same (i, j) column.
__global__ void profv_6(Range r, const real_t *c, const real_t *a, real_t *ee, real_t *gg,
                        const real_t *vf, int im, int jm, int kbm2) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 1; k < kbm2; k++) {
    gg[ACC3(i, j, k)] =
        1.0f / (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
    ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
    gg[ACC3(i, j, k)] =
        (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - vf[ACC3(i, j, k)]) * gg[ACC3(i, j, k)];
  }
}

__global__ void profv_7(Range r, const real_t *c, const real_t *dz, const real_t *ee,
                        const real_t *gg, real_t *vf, real_t *tps, const real_t *cbc,
                        const real_t *ub, const real_t *vb, const real_t *dvm,
                        const real_t *dhloc, int im, int jm, int kbm2, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  tps[ACC2(i, j)] =
      0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i, j - 1)]) *
      sqrtf((0.25f * (ub[ACC3(i, j, kbm2)] + ub[ACC3(i + 1, j, kbm2)] + ub[ACC3(i, j - 1, kbm2)] +
                      ub[ACC3(i + 1, j - 1, kbm2)])) *
                (0.25f * (ub[ACC3(i, j, kbm2)] + ub[ACC3(i + 1, j, kbm2)] +
                          ub[ACC3(i, j - 1, kbm2)] + ub[ACC3(i + 1, j - 1, kbm2)])) +
            vb[ACC3(i, j, kbm2)] * vb[ACC3(i, j, kbm2)]);
  vf[ACC3(i, j, kbm2)] = (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] - vf[ACC3(i, j, kbm2)]) /
                         (tps[ACC2(i, j)] * dti2 / (-(dz[kbm2]) * dhloc[ACC2(i, j)]) - 1.0f -
                          (ee[ACC3(i, j, kbm2 - 1)] - 1.0f) * c[ACC3(i, j, kbm2)]);
  vf[ACC3(i, j, kbm2)] = vf[ACC3(i, j, kbm2)] * dvm[ACC2(i, j)];
}

// Back substitution: level k depends on level k + 1 of the same column.
__global__ void profv_8(Range r, const real_t *ee, const real_t *gg, real_t *vf,
                        const real_t *dvm, int im, int jm, int kb) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = kb - 3; k >= 0; k--) {
    vf[ACC3(i, j, k)] =
        (ee[ACC3(i, j, k)] * vf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]) * dvm[ACC2(i, j)];
  }
}

__global__ void profv_9(Range r, const real_t *vf, const real_t *tps, real_t *wvbot, int im,
                        int jm, int kbm2) {
  POM2K_INDEX(r, i, j, k);
  wvbot[ACC2(i, j)] = -tps[ACC2(i, j)] * vf[ACC3(i, j, kbm2)];
}

}  // namespace

void ext_profv__cuda(real_t *etf, real_t *h, real_t *c, real_t *km, real_t *a, real_t *dz,
                     real_t *dzz, real_t *ee, real_t *gg, real_t *wvsurf, real_t *vf,
                     real_t *tps, real_t *cbc, real_t *ub, real_t *vb, real_t *dvm,
                     real_t *wvbot, real_t *dhloc) {
  const int I = im[0], J = jm[0], K = kb[0], KM2 = kbm2[0];
  const Range interior = range2(1, imm1[0], 1, jmm1[0]);
  launch(profv_0, range2(0, I, 0, J), dhloc, I);
  launch(profv_1, range2(1, I, 1, J), etf, h, dhloc, I);
  launch(profv_2, range3(1, I, 1, J, 0, K), c, km, I, J);
  launch(profv_3, range3(0, I, 0, J, 0, KM2), c, a, dz, dzz, dhloc, I, J, dti2[0], umol[0]);
  launch(profv_4, range3(0, I, 0, J, 1, kbm1[0]), c, dz, dzz, dhloc, I, J, dti2[0], umol[0]);
  launch(profv_5, range2(0, I, 0, J), a, dz, ee, gg, wvsurf, vf, dhloc, I, J, dti2[0]);
  launch(profv_6, range2(0, I, 0, J), c, a, ee, gg, vf, I, J, KM2);
  launch(profv_7, interior, c, dz, ee, gg, vf, tps, cbc, ub, vb, dvm, dhloc, I, J, KM2, dti2[0]);
  launch(profv_8, interior, ee, gg, vf, dvm, I, J, K);
  launch(profv_9, interior, vf, tps, wvbot, I, J, KM2);
  finish();
}

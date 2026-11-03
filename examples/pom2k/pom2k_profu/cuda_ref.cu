// Native CUDA reference of ext_profu_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void profu_0(Range r, real_t *dhloc, int im) {
  POM2K_INDEX(r, i, j, k);
  dhloc[ACC2(i, j)] = 1.0f;
}

__global__ void profu_1(Range r, const real_t *h, const real_t *etf, real_t *dhloc, int im) {
  POM2K_INDEX(r, i, j, k);
  dhloc[ACC2(i, j)] =
      (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) * 0.5f;
}

__global__ void profu_2(Range r, real_t *c, const real_t *km, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  c[ACC3(i, j, k)] = (km[ACC3(i, j, k)] + km[ACC3(i - 1, j, k)]) * 0.5f;
}

__global__ void profu_3(Range r, const real_t *c, real_t *a, const real_t *dz, const real_t *dzz,
                        const real_t *dhloc, int im, int jm, real_t dti2, real_t umol) {
  POM2K_INDEX(r, i, j, k);
  a[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k + 1)] + umol) /
                     (dz[k] * dzz[k] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
}

__global__ void profu_4(Range r, real_t *c, const real_t *dz, const real_t *dzz,
                        const real_t *dhloc, int im, int jm, real_t dti2, real_t umol) {
  POM2K_INDEX(r, i, j, k);
  c[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k)] + umol) /
                     (dz[k] * dzz[k - 1] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
}

__global__ void profu_5(Range r, const real_t *a, const real_t *dz, real_t *ee, real_t *gg,
                        const real_t *wusurf, const real_t *uf, const real_t *dhloc, int im,
                        int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
  gg[ACC3(i, j, 0)] =
      (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dhloc[ACC2(i, j)]) - uf[ACC3(i, j, 0)]) /
      (a[ACC3(i, j, 0)] - 1.0f);
}

// Forward sweep: level k depends on level k - 1 of the same (i, j) column.
__global__ void profu_6(Range r, const real_t *c, const real_t *a, real_t *ee, real_t *gg,
                        const real_t *uf, int im, int jm, int kbm2) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 1; k < kbm2; k++) {
    gg[ACC3(i, j, k)] =
        1.0f / (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
    ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
    gg[ACC3(i, j, k)] =
        (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - uf[ACC3(i, j, k)]) * gg[ACC3(i, j, k)];
  }
}

__global__ void profu_7(Range r, const real_t *c, const real_t *dz, const real_t *ee,
                        const real_t *gg, real_t *uf, real_t *tps, const real_t *cbc,
                        const real_t *ub, const real_t *vb, const real_t *dum,
                        const real_t *dhloc, int im, int jm, int kbm2, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  tps[ACC2(i, j)] =
      0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
      sqrtf(ub[ACC3(i, j, kbm2)] * ub[ACC3(i, j, kbm2)] +
            (0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] + vb[ACC3(i - 1, j, kbm2)] +
                      vb[ACC3(i - 1, j + 1, kbm2)])) *
                (0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                          vb[ACC3(i - 1, j, kbm2)] + vb[ACC3(i - 1, j + 1, kbm2)])));
  uf[ACC3(i, j, kbm2)] = (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] - uf[ACC3(i, j, kbm2)]) /
                         (tps[ACC2(i, j)] * (dti2) / (-dz[kbm2] * dhloc[ACC2(i, j)]) - 1.0f -
                          (ee[ACC3(i, j, kbm2 - 1)] - 1.0f) * c[ACC3(i, j, kbm2)]);
  uf[ACC3(i, j, kbm2)] = uf[ACC3(i, j, kbm2)] * dum[ACC2(i, j)];
}

// Back substitution: level k depends on level k + 1 of the same column.
__global__ void profu_8(Range r, const real_t *ee, const real_t *gg, real_t *uf,
                        const real_t *dum, int im, int jm, int kb) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = kb - 3; k >= 0; k--) {
    uf[ACC3(i, j, k)] =
        (ee[ACC3(i, j, k)] * uf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]) * dum[ACC2(i, j)];
  }
}

__global__ void profu_9(Range r, const real_t *uf, const real_t *tps, real_t *wubot, int im,
                        int jm, int kbm2) {
  POM2K_INDEX(r, i, j, k);
  wubot[ACC2(i, j)] = -tps[ACC2(i, j)] * uf[ACC3(i, j, kbm2)];
}

}  // namespace

void ext_profu__cuda(real_t *h, real_t *etf, real_t *c, real_t *km, real_t *a, real_t *dz,
                     real_t *dzz, real_t *ee, real_t *gg, real_t *wusurf, real_t *uf,
                     real_t *tps, real_t *cbc, real_t *ub, real_t *vb, real_t *dum,
                     real_t *wubot, real_t *dhloc) {
  const int I = im[0], J = jm[0], K = kb[0], KM2 = kbm2[0];
  const Range interior = range2(1, imm1[0], 1, jmm1[0]);
  launch(profu_0, range2(0, I, 0, J), dhloc, I);
  launch(profu_1, range2(1, I, 1, J), h, etf, dhloc, I);
  launch(profu_2, range3(1, I, 1, J, 0, K), c, km, I, J);
  launch(profu_3, range3(0, I, 0, J, 0, KM2), c, a, dz, dzz, dhloc, I, J, dti2[0], umol[0]);
  launch(profu_4, range3(0, I, 0, J, 1, kbm1[0]), c, dz, dzz, dhloc, I, J, dti2[0], umol[0]);
  launch(profu_5, range2(0, I, 0, J), a, dz, ee, gg, wusurf, uf, dhloc, I, J, dti2[0]);
  launch(profu_6, range2(0, I, 0, J), c, a, ee, gg, uf, I, J, KM2);
  launch(profu_7, interior, c, dz, ee, gg, uf, tps, cbc, ub, vb, dum, dhloc, I, J, KM2, dti2[0]);
  launch(profu_8, interior, ee, gg, uf, dum, I, J, K);
  launch(profu_9, interior, uf, tps, wubot, I, J, KM2);
  finish();
}

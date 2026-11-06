// Native HIP reference of ext_profu_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Implicit vertical diffusion of u, one thread per (i, j) column. Every loop of
// the C source only reads and writes its own column (neighbours are read from
// inputs only), so one thread runs them all in order: depth, viscosity,
// tridiagonal coefficients, surface condition, forward sweep, and on the
// interior the bottom condition and the back substitution. The sweeps carry
// the previous level in registers.
POM2K_KERNEL void profu_column(Range r, const real_t *__restrict__ h,
                               const real_t *__restrict__ etf, real_t *__restrict__ c,
                               const real_t *__restrict__ km, real_t *__restrict__ a,
                               const real_t *__restrict__ dz, const real_t *__restrict__ dzz,
                               real_t *__restrict__ ee, real_t *__restrict__ gg,
                               const real_t *__restrict__ wusurf, real_t *__restrict__ uf,
                               real_t *__restrict__ tps, const real_t *__restrict__ cbc,
                               const real_t *__restrict__ ub, const real_t *__restrict__ vb,
                               const real_t *__restrict__ dum, real_t *__restrict__ wubot,
                               real_t *__restrict__ dhloc, int im, int jm, int imm1, int jmm1,
                               int kb, int kbm1, int kbm2, real_t dti2, real_t umol) {
  POM2K_INDEX(r, i, j, unused_k);
  // The C loops over 1..im x 1..jm skip the first row and column; the bottom
  // condition and back substitution only run on the interior.
  const bool inner = i >= 1 && j >= 1;
  const bool interior = inner && i < imm1 && j < jmm1;

  // Depth at the u point (1 on the first row and column).
  const real_t dh =
      inner ? (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) * 0.5f
            : 1.0f;
  dhloc[ACC2(i, j)] = dh;
  // Viscosity at the u point (the input is kept on the first row and column).
  if (inner)
    for (int k = 0; k < kb; k++)
      c[ACC3(i, j, k)] = (km[ACC3(i, j, k)] + km[ACC3(i - 1, j, k)]) * 0.5f;
  // Tridiagonal coefficients; a reads c before c becomes a coefficient itself.
  for (int k = 0; k < kbm2; k++)
    a[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k + 1)] + umol) / (dz[k] * dzz[k] * dh * dh);
  for (int k = 1; k < kbm1; k++)
    c[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k)] + umol) / (dz[k] * dzz[k - 1] * dh * dh);

  // Surface boundary condition (wind stress).
  const real_t a0 = a[ACC3(i, j, 0)];
  real_t eePrev = a0 / (a0 - 1.0f);
  real_t ggPrev = (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dh) - uf[ACC3(i, j, 0)]) / (a0 - 1.0f);
  ee[ACC3(i, j, 0)] = eePrev;
  gg[ACC3(i, j, 0)] = ggPrev;

  // Forward sweep: level k depends on level k - 1.
  for (int k = 1; k < kbm2; k++) {
    const real_t ak = a[ACC3(i, j, k)], ck = c[ACC3(i, j, k)];
    real_t g = 1.0f / (ak + ck * (1.0f - eePrev) - 1.0f);
    const real_t e = ak * g;
    g = (ck * ggPrev - uf[ACC3(i, j, k)]) * g;
    ee[ACC3(i, j, k)] = e;
    gg[ACC3(i, j, k)] = g;
    eePrev = e;
    ggPrev = g;
  }
  if (!interior)
    return;

  // Bottom boundary condition: quadratic bottom stress.
  const real_t ubk = ub[ACC3(i, j, kbm2)];
  const real_t vbk = 0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                              vb[ACC3(i - 1, j, kbm2)] + vb[ACC3(i - 1, j + 1, kbm2)]);
  const real_t stress = 0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) * sqrtf(ubk * ubk + vbk * vbk);
  tps[ACC2(i, j)] = stress;
  const real_t ck = c[ACC3(i, j, kbm2)];
  real_t ufBottom = (ck * ggPrev - uf[ACC3(i, j, kbm2)]) /
                    (stress * (dti2) / (-dz[kbm2] * dh) - 1.0f - (eePrev - 1.0f) * ck);
  ufBottom = ufBottom * dum[ACC2(i, j)];
  uf[ACC3(i, j, kbm2)] = ufBottom;

  // Back substitution: level k depends on level k + 1.
  real_t ufBelow = ufBottom;
  for (int k = kb - 3; k >= 0; k--) {
    ufBelow = (ee[ACC3(i, j, k)] * ufBelow + gg[ACC3(i, j, k)]) * dum[ACC2(i, j)];
    uf[ACC3(i, j, k)] = ufBelow;
  }
  wubot[ACC2(i, j)] = -stress * ufBottom;
}

}  // namespace

void ext_profu__hip(real_t *h, real_t *etf, real_t *c, real_t *km, real_t *a, real_t *dz,
                    real_t *dzz, real_t *ee, real_t *gg, real_t *wusurf, real_t *uf,
                    real_t *tps, real_t *cbc, real_t *ub, real_t *vb, real_t *dum,
                    real_t *wubot, real_t *dhloc) {
  launch(profu_column, range2(0, im[0], 0, jm[0]), h, etf, c, km, a, dz, dzz, ee, gg, wusurf, uf,
         tps, cbc, ub, vb, dum, wubot, dhloc, im[0], jm[0], imm1[0], jmm1[0], kb[0], kbm1[0],
         kbm2[0], dti2[0], umol[0]);
  finish();
}

// Native HIP reference of ext_profv_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Implicit vertical diffusion of v, one thread per (i, j) column. Every loop of
// the C source only reads and writes its own column (neighbours are read from
// inputs only), so one thread runs them all in order: depth, viscosity,
// tridiagonal coefficients, surface condition, forward sweep, and on the
// interior the bottom condition and the back substitution. The sweeps carry
// the previous level in registers.
POM2K_KERNEL void profv_column(Range r, const real_t *__restrict__ etf,
                               const real_t *__restrict__ h, real_t *__restrict__ c,
                               const real_t *__restrict__ km, real_t *__restrict__ a,
                               const real_t *__restrict__ dz, const real_t *__restrict__ dzz,
                               real_t *__restrict__ ee, real_t *__restrict__ gg,
                               const real_t *__restrict__ wvsurf, real_t *__restrict__ vf,
                               real_t *__restrict__ tps, const real_t *__restrict__ cbc,
                               const real_t *__restrict__ ub, const real_t *__restrict__ vb,
                               const real_t *__restrict__ dvm, real_t *__restrict__ wvbot,
                               real_t *__restrict__ dhloc, int im, int jm, int imm1, int jmm1,
                               int kb, int kbm1, int kbm2, real_t dti2, real_t umol) {
  POM2K_INDEX(r, i, j, unused_k);
  // The C loops over 1..im x 1..jm skip the first row and column; the bottom
  // condition and back substitution only run on the interior.
  const bool inner = i >= 1 && j >= 1;
  const bool interior = inner && i < imm1 && j < jmm1;

  // Depth at the v point (1 on the first row and column).
  const real_t dh =
      inner ? 0.5f * (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i, j - 1)] + etf[ACC2(i, j - 1)])
            : 1.0f;
  dhloc[ACC2(i, j)] = dh;
  // Viscosity at the v point (the input is kept on the first row and column).
  if (inner)
    for (int k = 0; k < kb; k++)
      c[ACC3(i, j, k)] = (km[ACC3(i, j, k)] + km[ACC3(i, j - 1, k)]) * 0.5f;
  // Tridiagonal coefficients; a reads c before c becomes a coefficient itself.
  for (int k = 0; k < kbm2; k++)
    a[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k + 1)] + umol) / (dz[k] * dzz[k] * dh * dh);
  for (int k = 1; k < kbm1; k++)
    c[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k)] + umol) / (dz[k] * dzz[k - 1] * dh * dh);

  // Surface boundary condition (wind stress).
  const real_t a0 = a[ACC3(i, j, 0)];
  real_t eePrev = a0 / (a0 - 1.0f);
  real_t ggPrev = (-dti2 * wvsurf[ACC2(i, j)] / (-(dz[0]) * dh) - vf[ACC3(i, j, 0)]) / (a0 - 1.0f);
  ee[ACC3(i, j, 0)] = eePrev;
  gg[ACC3(i, j, 0)] = ggPrev;

  // Forward sweep: level k depends on level k - 1.
  for (int k = 1; k < kbm2; k++) {
    const real_t ak = a[ACC3(i, j, k)], ck = c[ACC3(i, j, k)];
    real_t g = 1.0f / (ak + ck * (1.0f - eePrev) - 1.0f);
    const real_t e = ak * g;
    g = (ck * ggPrev - vf[ACC3(i, j, k)]) * g;
    ee[ACC3(i, j, k)] = e;
    gg[ACC3(i, j, k)] = g;
    eePrev = e;
    ggPrev = g;
  }
  if (!interior)
    return;

  // Bottom boundary condition: quadratic bottom stress.
  const real_t ubk = 0.25f * (ub[ACC3(i, j, kbm2)] + ub[ACC3(i + 1, j, kbm2)] +
                              ub[ACC3(i, j - 1, kbm2)] + ub[ACC3(i + 1, j - 1, kbm2)]);
  const real_t vbk = vb[ACC3(i, j, kbm2)];
  const real_t stress = 0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i, j - 1)]) * sqrtf(ubk * ubk + vbk * vbk);
  tps[ACC2(i, j)] = stress;
  const real_t ck = c[ACC3(i, j, kbm2)];
  real_t vfBottom = (ck * ggPrev - vf[ACC3(i, j, kbm2)]) /
                    (stress * dti2 / (-(dz[kbm2]) * dh) - 1.0f - (eePrev - 1.0f) * ck);
  vfBottom = vfBottom * dvm[ACC2(i, j)];
  vf[ACC3(i, j, kbm2)] = vfBottom;

  // Back substitution: level k depends on level k + 1.
  real_t vfBelow = vfBottom;
  for (int k = kb - 3; k >= 0; k--) {
    vfBelow = (ee[ACC3(i, j, k)] * vfBelow + gg[ACC3(i, j, k)]) * dvm[ACC2(i, j)];
    vf[ACC3(i, j, k)] = vfBelow;
  }
  wvbot[ACC2(i, j)] = -stress * vfBottom;
}

}  // namespace

void ext_profv__hip(real_t *etf, real_t *h, real_t *c, real_t *km, real_t *a, real_t *dz,
                    real_t *dzz, real_t *ee, real_t *gg, real_t *wvsurf, real_t *vf,
                    real_t *tps, real_t *cbc, real_t *ub, real_t *vb, real_t *dvm,
                    real_t *wvbot, real_t *dhloc) {
  launch(profv_column, range2(0, im[0], 0, jm[0]), etf, h, c, km, a, dz, dzz, ee, gg, wvsurf, vf,
         tps, cbc, ub, vb, dvm, wvbot, dhloc, im[0], jm[0], imm1[0], jmm1[0], kb[0], kbm1[0],
         kbm2[0], dti2[0], umol[0]);
  finish();
}

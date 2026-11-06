// Native HIP reference of ext_proft_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Surface boundary condition selected by nbc (read on the host).
struct SurfaceBc {
  int nbc;
  // Penetrative radiation (nbc 2 and 4): fraction r and the two attenuation
  // depths ad1, ad2 of the water type ntp.
  bool penetrative;
  real_t rfrac, ad1, ad2;
};

// Implicit vertical diffusion of a tracer, one thread per (i, j) column. Every
// loop of the C source works on the whole (i, j) plane and only touches its
// own column, so one thread runs them all in order: depth, tridiagonal
// coefficients, radiation, surface condition, forward sweep, bottom condition
// and back substitution. The sweeps carry the previous level in registers.
POM2K_KERNEL void proft_column(Range r, real_t *__restrict__ f,
                               const real_t *__restrict__ wfsurf,
                               const real_t *__restrict__ fsurf, real_t *__restrict__ dh,
                               const real_t *__restrict__ h, const real_t *__restrict__ etf,
                               real_t *__restrict__ a, const real_t *__restrict__ kh,
                               real_t *__restrict__ c, const real_t *__restrict__ z,
                               const real_t *__restrict__ swrad, real_t *__restrict__ ee,
                               real_t *__restrict__ gg, const real_t *__restrict__ dz,
                               const real_t *__restrict__ dzz, real_t *__restrict__ rad2,
                               SurfaceBc bc, int im, int jm, int kb, int kbm1, int kbm2,
                               real_t dti2, real_t umol) {
  POM2K_INDEX(r, i, j, unused_k);
  const real_t d = h[ACC2(i, j)] + etf[ACC2(i, j)];
  dh[ACC2(i, j)] = d;
  // Tridiagonal coefficients.
  for (int k = 0; k < kbm2; k++)
    a[ACC3(i, j, k)] = -dti2 * (kh[ACC3(i, j, k + 1)] + umol) / (dz[k] * dzz[k] * d * d);
  for (int k = 1; k < kbm1; k++)
    c[ACC3(i, j, k)] = -dti2 * (kh[ACC3(i, j, k)] + umol) / (dz[k] * dzz[k - 1] * d * d);
  // Short wave radiation: zero, or penetrating down to kbm1 for nbc 2 and 4.
  for (int k = 0; k < kb; k++)
    rad2[ACC3(i, j, k)] =
        bc.penetrative && k < kbm1
            ? swrad[ACC2(i, j)] * (bc.rfrac * expf(z[k] * d / bc.ad1) +
                                   (1.0f - bc.rfrac) * expf(z[k] * d / bc.ad2))
            : 0.0f;

  // Surface boundary condition.
  const real_t a0 = a[ACC3(i, j, 0)];
  if (bc.nbc == 1) {
    ee[ACC3(i, j, 0)] = a0 / (a0 - 1.0f);
    const real_t g = -dti2 * wfsurf[ACC2(i, j)] / (-dz[0] * d) - f[ACC3(i, j, 0)];
    gg[ACC3(i, j, 0)] = g / (a0 - 1.0f);
  } else if (bc.nbc == 2) {
    ee[ACC3(i, j, 0)] = a0 / (a0 - 1.0f);
    const real_t g =
        dti2 * (wfsurf[ACC2(i, j)] + rad2[ACC3(i, j, 0)] - rad2[ACC3(i, j, 1)]) / (dz[0] * d) -
        f[ACC3(i, j, 0)];
    gg[ACC3(i, j, 0)] = g / (a0 - 1.0f);
  } else if (bc.nbc == 3 || bc.nbc == 4) {
    ee[ACC3(i, j, 0)] = 0.0f;
    gg[ACC3(i, j, 0)] = fsurf[ACC2(i, j)];
  }
  real_t eePrev = ee[ACC3(i, j, 0)], ggPrev = gg[ACC3(i, j, 0)];

  // Forward sweep: level k depends on level k - 1.
  for (int k = 1; k < kbm2; k++) {
    const real_t ak = a[ACC3(i, j, k)], ck = c[ACC3(i, j, k)];
    real_t g = 1.0f / (ak + ck * (1.0f - eePrev) - 1.0f);
    const real_t e = ak * g;
    g = (ck * ggPrev - f[ACC3(i, j, k)] +
         dti2 * (rad2[ACC3(i, j, k)] - rad2[ACC3(i, j, k + 1)]) / (d * dz[k])) *
        g;
    ee[ACC3(i, j, k)] = e;
    gg[ACC3(i, j, k)] = g;
    eePrev = e;
    ggPrev = g;
  }

  // Bottom adiabatic boundary condition:
  const real_t ck = c[ACC3(i, j, kbm2)];
  real_t fBelow = (ck * ggPrev - f[ACC3(i, j, kbm2)] +
                   dti2 * (rad2[ACC3(i, j, kbm2)] - rad2[ACC3(i, j, kb - 1)]) / (d * dz[kbm2])) /
                  (ck * (1.0f - eePrev) - 1.0f);
  f[ACC3(i, j, kbm2)] = fBelow;

  // Back substitution: level k depends on level k + 1.
  for (int k = kb - 3; k >= 0; k--) {
    fBelow = (ee[ACC3(i, j, k)] * fBelow + gg[ACC3(i, j, k)]);
    f[ACC3(i, j, k)] = fBelow;
  }
}

}  // namespace

// nbc is read on the host, like the branch conditions of the C source.
void ext_proft__hip(real_t *f, real_t *wfsurf, real_t *fsurf, int *nbc, real_t *dh, real_t *h,
                    real_t *etf, real_t *a, real_t *kh, real_t *c, real_t *z, real_t *swrad,
                    real_t *ee, real_t *gg, real_t *dz, real_t *dzz, real_t *rad2) {
  SurfaceBc bc{readScalar(nbc), false, 0.0f, 1.0f, 1.0f};
  bc.penetrative = bc.nbc == 2 || bc.nbc == 4;
  if (bc.penetrative) {
    // Jerlov water types, indexed by ntp (1-based):
    const real_t r_[5] = {0.58f, 0.62f, 0.67f, 0.77f, 0.78f};
    const real_t ad1[5] = {0.35f, 0.6f, 1.0f, 1.5f, 1.4f};
    const real_t ad2[5] = {23.0f, 20.0f, 17.0f, 14.0f, 7.9f};
    bc.rfrac = r_[ntp[0] - 1];
    bc.ad1 = ad1[ntp[0] - 1];
    bc.ad2 = ad2[ntp[0] - 1];
  }
  launch(proft_column, range2(0, im[0], 0, jm[0]), f, wfsurf, fsurf, dh, h, etf, a, kh, c, z,
         swrad, ee, gg, dz, dzz, rad2, bc, im[0], jm[0], kb[0], kbm1[0], kbm2[0], dti2[0],
         umol[0]);
  finish();
}

// Native HIP reference of ext_smol_adif_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Smolarkiewicz antidiffusive mass flux through one cell face: `flux` is the
// face's mass flux, `courant` its flux * flux term, and the C source's mol is
// (fhi - flo) / (flo + fhi + 1e-14) for the two cells next to the face.
__device__ inline real_t antidiffusiveFlux(real_t flux, real_t fhi, real_t flo, real_t courant,
                                           real_t sw) {
  const real_t udx = fabsf(flux);
  const real_t mol = (fhi - flo) / (flo + fhi + 1.0e-14f);
  return fabsf(udx) < fabsf(courant) ? 0.0f : (udx - courant) * mol * sw;
}

// Apply temperature and salinity mask:
POM2K_KERNEL void smol_adif_0(Range r, real_t *__restrict__ ff, const real_t *__restrict__ fsm,
                              int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  ff[ACC3(i, j, k)] *= fsm[ACC2(i, j)];
}

// Recalculate mass fluxes with antidiffusion velocity:
POM2K_KERNEL void smol_adif_1(Range r, real_t *__restrict__ xmassflux,
                              const real_t *__restrict__ ff, const real_t *__restrict__ sw,
                              const real_t *__restrict__ aru, const real_t *__restrict__ dt,
                              int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  const real_t f = ff[ACC3(i, j, k)], fw = ff[ACC3(i - 1, j, k)];
  real_t &flux = xmassflux[ACC3(i, j, k)];
  if ((f < 1.0e-9f) || (fw < 1.0e-9f)) {
    flux = 0.0f;
    return;
  }
  const real_t u2dt = dti2 * flux * flux * 2.0f / (aru[ACC2(i, j)] * (dt[ACC2(i - 1, j)] + dt[ACC2(i, j)]));
  flux = antidiffusiveFlux(flux, f, fw, u2dt, *sw);
}

POM2K_KERNEL void smol_adif_2(Range r, real_t *__restrict__ ymassflux,
                              const real_t *__restrict__ ff, const real_t *__restrict__ sw,
                              const real_t *__restrict__ arv, const real_t *__restrict__ dt,
                              int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  const real_t f = ff[ACC3(i, j, k)], fs = ff[ACC3(i, j - 1, k)];
  real_t &flux = ymassflux[ACC3(i, j, k)];
  if ((f < 1.0e-9f) || (fs < 1.0e-9f)) {
    flux = 0.0f;
    return;
  }
  const real_t v2dt = dti2 * flux * flux * 2.0f / (arv[ACC2(i, j)] * (dt[ACC2(i, j - 1)] + dt[ACC2(i, j)]));
  flux = antidiffusiveFlux(flux, f, fs, v2dt, *sw);
}

// Vertical faces: the C source differences the field the other way round
// (level k - 1 minus level k).
POM2K_KERNEL void smol_adif_3(Range r, real_t *__restrict__ zwflux,
                              const real_t *__restrict__ ff, const real_t *__restrict__ sw,
                              const real_t *__restrict__ dt, const real_t *__restrict__ dzz,
                              int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  const real_t f = ff[ACC3(i, j, k)], fa = ff[ACC3(i, j, k - 1)];
  real_t &flux = zwflux[ACC3(i, j, k)];
  if ((f < 1.0e-9f) || (fa < 1.0e-9f)) {
    flux = 0.0f;
    return;
  }
  const real_t w2dt = dti2 * flux * flux / (dzz[k - 1] * dt[ACC2(i, j)]);
  flux = antidiffusiveFlux(flux, fa, f, w2dt, *sw);
}

}  // namespace

void ext_smol_adif__hip(real_t *xmassflux, real_t *ymassflux, real_t *zwflux, real_t *ff,
                        real_t *sw, real_t *fsm, real_t *aru, real_t *arv, real_t *dt,
                        real_t *dzz) {
  launch(smol_adif_0, range3(0, im[0], 0, jm[0], 0, kb[0]), ff, fsm, im[0], jm[0]);
  launch(smol_adif_1, range3(1, im[0], 1, jmm1[0], 0, kbm1[0]), xmassflux, ff, sw, aru, dt,
         im[0], jm[0], dti2[0]);
  launch(smol_adif_2, range3(1, imm1[0], 1, jm[0], 0, kbm1[0]), ymassflux, ff, sw, arv, dt,
         im[0], jm[0], dti2[0]);
  launch(smol_adif_3, range3(1, imm1[0], 1, jmm1[0], 1, kbm1[0]), zwflux, ff, sw, dt, dzz,
         im[0], jm[0], dti2[0]);
  finish();
}

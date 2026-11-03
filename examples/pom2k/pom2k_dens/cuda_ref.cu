// Native CUDA reference of ext_dens_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void dens_0(Range r, const real_t *si, const real_t *ti, real_t *rhoo,
                       const real_t *h, const real_t *fsm, const real_t *zz,
                       const real_t *tbias, const real_t *sbias, int im, int jm, real_t grav,
                       real_t rhoref) {
  POM2K_INDEX(r, i, j, k);
  real_t cr, p, rhor, sr, tr, tr2, tr3, tr4;
  tr = ti[ACC3(i, j, k)] + *tbias;
  sr = si[ACC3(i, j, k)] + *sbias;
  tr2 = tr * tr;
  tr3 = tr2 * tr;
  tr4 = tr3 * tr;
  // Approximate pressure in units of bars:
  p = grav * rhoref * (-zz[k] * h[ACC2(i, j)]) * 1.e-5f;
  rhor = -0.157406f + 6.793952e-2f * tr - 9.095290e-3f * tr2 + 1.001685e-4f * tr3 -
         1.120083e-6f * tr4 + 6.536332e-9f * tr4 * tr;
  rhor = rhor +
         (0.824493f - 4.0899e-3f * tr + 7.6438e-5f * tr2 - 8.2467e-7f * tr3 +
          5.3875e-9f * tr4) *
             sr +
         (-5.72466e-3f + 1.0227e-4f * tr - 1.6546e-6f * tr2) * powf(fabs(sr), 1.5f) +
         4.8314e-4f * sr * sr;
  cr = 1449.1f + .0821f * p + 4.55f * tr - .045f * tr2 + 1.34f * (sr - 35.0f);
  rhor = rhor + 1.e5f * p / (cr * cr) * (1.0f - 2.0f * p / (cr * cr));
  rhoo[ACC3(i, j, k)] = rhor / rhoref * fsm[ACC2(i, j)];
}

}  // namespace

void ext_dens__cuda(real_t *si, real_t *ti, real_t *rhoo, real_t *h, real_t *fsm, real_t *zz,
                    real_t *tbias, real_t *sbias) {
  launch(dens_0, range3(0, im[0], 0, jm[0], 0, kbm1[0]), si, ti, rhoo, h, fsm, zz, tbias, sbias,
         im[0], jm[0], grav[0], rhoref[0]);
  finish();
}

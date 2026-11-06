// Native HIP reference of ext_vaf_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// External-mode v momentum. The C source runs two loops over the same range;
// the second only reads vaf at the point it writes, so both steps run in one
// kernel and the intermediate stays in a register.
POM2K_KERNEL void vaf_0(Range r, real_t *__restrict__ vaf, const real_t *__restrict__ ady2d,
                        const real_t *__restrict__ advva, const real_t *__restrict__ arv,
                        const real_t *__restrict__ cor, const real_t *__restrict__ d,
                        const real_t *__restrict__ ua, const real_t *__restrict__ dx,
                        const real_t *__restrict__ el, const real_t *__restrict__ elb,
                        const real_t *__restrict__ elf, const real_t *__restrict__ e_atmos,
                        const real_t *__restrict__ dry2d, const real_t *__restrict__ wvsurf,
                        const real_t *__restrict__ wvbot, const real_t *__restrict__ h,
                        const real_t *__restrict__ vab, int im, real_t grav, real_t alpha,
                        real_t dte) {
  POM2K_INDEX(r, i, j, k);
  // Forcing: advection, Coriolis, pressure gradient, baroclinic and stress terms.
  const real_t force =
      ady2d[ACC2(i, j)] + advva[ACC2(i, j)] +
      arv[ACC2(i, j)] * .25f *
          (cor[ACC2(i, j)] * d[ACC2(i, j)] * (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) +
           cor[ACC2(i, j - 1)] * d[ACC2(i, j - 1)] *
               (ua[ACC2(i + 1, j - 1)] + ua[ACC2(i, j - 1)])) +
      .25f * grav * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) *
          (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) *
          ((1.0f - 2.0f * alpha) * (el[ACC2(i, j)] - el[ACC2(i, j - 1)]) +
           alpha * (elb[ACC2(i, j)] - elb[ACC2(i, j - 1)] + elf[ACC2(i, j)] -
                    elf[ACC2(i, j - 1)]) +
           e_atmos[ACC2(i, j)] - e_atmos[ACC2(i, j - 1)]) +
      dry2d[ACC2(i, j)] + arv[ACC2(i, j)] * (wvsurf[ACC2(i, j)] - wvbot[ACC2(i, j)]);
  // Leapfrog step of the transport.
  vaf[ACC2(i, j)] =
      ((h[ACC2(i, j)] + elb[ACC2(i, j)] + h[ACC2(i, j - 1)] + elb[ACC2(i, j - 1)]) *
           vab[ACC2(i, j)] * arv[ACC2(i, j)] -
       4.0f * dte * force) /
      ((h[ACC2(i, j)] + elf[ACC2(i, j)] + h[ACC2(i, j - 1)] + elf[ACC2(i, j - 1)]) *
       arv[ACC2(i, j)]);
}

}  // namespace

void ext_vaf__hip(real_t *vaf, real_t *ady2d, real_t *advva, real_t *arv, real_t *cor,
                  real_t *d, real_t *ua, real_t *dx, real_t *el, real_t *elb, real_t *elf,
                  real_t *e_atmos, real_t *dry2d, real_t *wvsurf, real_t *wvbot, real_t *h,
                  real_t *vab) {
  launch(vaf_0, range2(1, imm1[0], 1, jm[0]), vaf, ady2d, advva, arv, cor, d, ua, dx, el, elb,
         elf, e_atmos, dry2d, wvsurf, wvbot, h, vab, im[0], grav[0], alpha[0], dte[0]);
  finish();
}

// Native HIP reference of ext_uaf_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// External-mode u momentum. The C source runs two loops over the same range;
// the second only reads uaf at the point it writes, so both steps run in one
// kernel and the intermediate stays in a register.
POM2K_KERNEL void uaf_0(Range r, real_t *__restrict__ uaf, const real_t *__restrict__ adx2d,
                        const real_t *__restrict__ advua, const real_t *__restrict__ aru,
                        const real_t *__restrict__ cor, const real_t *__restrict__ d,
                        const real_t *__restrict__ va, const real_t *__restrict__ dy,
                        const real_t *__restrict__ el, const real_t *__restrict__ elb,
                        const real_t *__restrict__ elf, const real_t *__restrict__ e_atmos,
                        const real_t *__restrict__ drx2d, const real_t *__restrict__ wusurf,
                        const real_t *__restrict__ wubot, const real_t *__restrict__ h,
                        const real_t *__restrict__ uab, int im, real_t grav, real_t alpha,
                        real_t dte) {
  POM2K_INDEX(r, i, j, k);
  // Forcing: advection, Coriolis, pressure gradient, baroclinic and stress terms.
  const real_t force =
      adx2d[ACC2(i, j)] + advua[ACC2(i, j)] -
      aru[ACC2(i, j)] * .25f *
          (cor[ACC2(i, j)] * d[ACC2(i, j)] * (va[ACC2(i, j + 1)] + va[ACC2(i, j)]) +
           cor[ACC2(i - 1, j)] * d[ACC2(i - 1, j)] *
               (va[ACC2(i - 1, j + 1)] + va[ACC2(i - 1, j)])) +
      .25f * grav * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) *
          (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) *
          ((1.0f - 2.0f * alpha) * (el[ACC2(i, j)] - el[ACC2(i - 1, j)]) +
           alpha * (elb[ACC2(i, j)] - elb[ACC2(i - 1, j)] + elf[ACC2(i, j)] -
                    elf[ACC2(i - 1, j)]) +
           e_atmos[ACC2(i, j)] - e_atmos[ACC2(i - 1, j)]) +
      drx2d[ACC2(i, j)] + aru[ACC2(i, j)] * (wusurf[ACC2(i, j)] - wubot[ACC2(i, j)]);
  // Leapfrog step of the transport.
  uaf[ACC2(i, j)] =
      ((h[ACC2(i, j)] + elb[ACC2(i, j)] + h[ACC2(i - 1, j)] + elb[ACC2(i - 1, j)]) *
           aru[ACC2(i, j)] * uab[ACC2(i, j)] -
       4.0f * dte * force) /
      ((h[ACC2(i, j)] + elf[ACC2(i, j)] + h[ACC2(i - 1, j)] + elf[ACC2(i - 1, j)]) *
       aru[ACC2(i, j)]);
}

}  // namespace

void ext_uaf__hip(real_t *uaf, real_t *adx2d, real_t *advua, real_t *aru, real_t *cor,
                  real_t *d, real_t *va, real_t *dy, real_t *el, real_t *elb, real_t *elf,
                  real_t *e_atmos, real_t *drx2d, real_t *wusurf, real_t *wubot, real_t *h,
                  real_t *uab) {
  launch(uaf_0, range2(1, im[0], 1, jmm1[0]), uaf, adx2d, advua, aru, cor, d, va, dy, el, elb,
         elf, e_atmos, drx2d, wusurf, wubot, h, uab, im[0], grav[0], alpha[0], dte[0]);
  finish();
}

// Native CUDA reference of ext_uaf_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void uaf_0(Range r, real_t *uaf, const real_t *adx2d, const real_t *advua,
                      const real_t *aru, const real_t *cor, const real_t *d, const real_t *va,
                      const real_t *dy, const real_t *el, const real_t *elb, const real_t *elf,
                      const real_t *e_atmos, const real_t *drx2d, const real_t *wusurf,
                      const real_t *wubot, int im, real_t grav, real_t alpha) {
  POM2K_INDEX(r, i, j, k);
  uaf[ACC2(i, j)] =
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
}

__global__ void uaf_1(Range r, real_t *uaf, const real_t *aru, const real_t *elb,
                      const real_t *elf, const real_t *h, const real_t *uab, int im,
                      real_t dte) {
  POM2K_INDEX(r, i, j, k);
  uaf[ACC2(i, j)] =
      ((h[ACC2(i, j)] + elb[ACC2(i, j)] + h[ACC2(i - 1, j)] + elb[ACC2(i - 1, j)]) *
           aru[ACC2(i, j)] * uab[ACC2(i, j)] -
       4.0f * dte * uaf[ACC2(i, j)]) /
      ((h[ACC2(i, j)] + elf[ACC2(i, j)] + h[ACC2(i - 1, j)] + elf[ACC2(i - 1, j)]) *
       aru[ACC2(i, j)]);
}

}  // namespace

void ext_uaf__cuda(real_t *uaf, real_t *adx2d, real_t *advua, real_t *aru, real_t *cor,
                   real_t *d, real_t *va, real_t *dy, real_t *el, real_t *elb, real_t *elf,
                   real_t *e_atmos, real_t *drx2d, real_t *wusurf, real_t *wubot, real_t *h,
                   real_t *uab) {
  const Range r = range2(1, im[0], 1, jmm1[0]);
  launch(uaf_0, r, uaf, adx2d, advua, aru, cor, d, va, dy, el, elb, elf, e_atmos, drx2d, wusurf,
         wubot, im[0], grav[0], alpha[0]);
  launch(uaf_1, r, uaf, aru, elb, elf, h, uab, im[0], dte[0]);
  finish();
}

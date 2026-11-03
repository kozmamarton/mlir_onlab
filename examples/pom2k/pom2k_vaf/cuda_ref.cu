// Native CUDA reference of ext_vaf_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void vaf_0(Range r, real_t *vaf, const real_t *ady2d, const real_t *advva,
                      const real_t *arv, const real_t *cor, const real_t *d, const real_t *ua,
                      const real_t *dx, const real_t *el, const real_t *elb, const real_t *elf,
                      const real_t *e_atmos, const real_t *dry2d, const real_t *wvsurf,
                      const real_t *wvbot, int im, real_t grav, real_t alpha) {
  POM2K_INDEX(r, i, j, k);
  vaf[ACC2(i, j)] =
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
}

__global__ void vaf_1(Range r, real_t *vaf, const real_t *arv, const real_t *elb,
                      const real_t *elf, const real_t *h, const real_t *vab, int im,
                      real_t dte) {
  POM2K_INDEX(r, i, j, k);
  vaf[ACC2(i, j)] =
      ((h[ACC2(i, j)] + elb[ACC2(i, j)] + h[ACC2(i, j - 1)] + elb[ACC2(i, j - 1)]) *
           vab[ACC2(i, j)] * arv[ACC2(i, j)] -
       4.0f * dte * vaf[ACC2(i, j)]) /
      ((h[ACC2(i, j)] + elf[ACC2(i, j)] + h[ACC2(i, j - 1)] + elf[ACC2(i, j - 1)]) *
       arv[ACC2(i, j)]);
}

}  // namespace

void ext_vaf__cuda(real_t *vaf, real_t *ady2d, real_t *advva, real_t *arv, real_t *cor,
                   real_t *d, real_t *ua, real_t *dx, real_t *el, real_t *elb, real_t *elf,
                   real_t *e_atmos, real_t *dry2d, real_t *wvsurf, real_t *wvbot, real_t *h,
                   real_t *vab) {
  const Range r = range2(1, imm1[0], 1, jm[0]);
  launch(vaf_0, r, vaf, ady2d, advva, arv, cor, d, ua, dx, el, elb, elf, e_atmos, dry2d, wvsurf,
         wvbot, im[0], grav[0], alpha[0]);
  launch(vaf_1, r, vaf, arv, elb, elf, h, vab, im[0], dte[0]);
  finish();
}

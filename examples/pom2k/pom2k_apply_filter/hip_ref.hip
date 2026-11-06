// Native HIP reference of ext_apply_filter_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Asselin filter of the external mode, then the time-level shift. The
// statements keep the C order: the b fields receive the filtered values.
POM2K_KERNEL void apply_filter_0(Range r, const real_t *__restrict__ smoth,
                                 real_t *__restrict__ ua, real_t *__restrict__ uab,
                                 const real_t *__restrict__ uaf, real_t *__restrict__ va,
                                 real_t *__restrict__ vab, const real_t *__restrict__ vaf,
                                 real_t *__restrict__ el, real_t *__restrict__ elb,
                                 const real_t *__restrict__ elf, real_t *__restrict__ d,
                                 const real_t *__restrict__ h, int im) {
  POM2K_INDEX(r, i, j, k);
  const int n = ACC2(i, j);
  ua[n] = ua[n] + .5f * *smoth * (uab[n] - 2.0f * ua[n] + uaf[n]);
  va[n] = va[n] + .5f * *smoth * (vab[n] - 2.0f * va[n] + vaf[n]);
  el[n] = el[n] + .5f * *smoth * (elb[n] - 2.0f * el[n] + elf[n]);
  elb[n] = el[n];
  el[n] = elf[n];
  d[n] = h[n] + el[n];
  uab[n] = ua[n];
  ua[n] = uaf[n];
  vab[n] = va[n];
  va[n] = vaf[n];
}

// Accumulation of the time averages for the internal mode.
POM2K_KERNEL void apply_filter_1(Range r, const real_t *__restrict__ ispi,
                                 const real_t *__restrict__ el, real_t *__restrict__ egf,
                                 int im) {
  POM2K_INDEX(r, i, j, k);
  egf[ACC2(i, j)] = egf[ACC2(i, j)] + el[ACC2(i, j)] * *ispi;
}

POM2K_KERNEL void apply_filter_2(Range r, const real_t *__restrict__ isp2i,
                                 const real_t *__restrict__ ua, const real_t *__restrict__ d,
                                 real_t *__restrict__ utf, int im) {
  POM2K_INDEX(r, i, j, k);
  utf[ACC2(i, j)] =
      utf[ACC2(i, j)] + ua[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * *isp2i;
}

POM2K_KERNEL void apply_filter_3(Range r, const real_t *__restrict__ isp2i,
                                 const real_t *__restrict__ va, const real_t *__restrict__ d,
                                 real_t *__restrict__ vtf, int im) {
  POM2K_INDEX(r, i, j, k);
  vtf[ACC2(i, j)] =
      vtf[ACC2(i, j)] + va[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * *isp2i;
}

}  // namespace

// The branch conditions are read on the host, like in the C source.
void ext_apply_filter__hip(real_t *vamax, real_t *vmaxl, real_t *smoth, int *iext, int *isplit,
                           real_t *ispi, real_t *isp2i, real_t *ua, real_t *uab, real_t *uaf,
                           real_t *va, real_t *vab, real_t *vaf, real_t *el, real_t *elb,
                           real_t *elf, real_t *d, real_t *h, real_t *egf, real_t *utf,
                           real_t *vtf) {
  if (readScalar(vamax) < readScalar(vmaxl)) {
    // Apply filter to remove time split and reset time sequence:
    launch(apply_filter_0, range2(0, im[0], 0, jm[0]), smoth, ua, uab, uaf, va, vab, vaf, el,
           elb, elf, d, h, im[0]);
    if (readScalar(iext) != readScalar(isplit)) {
      launch(apply_filter_1, range2(0, im[0], 0, jm[0]), ispi, el, egf, im[0]);
      launch(apply_filter_2, range2(1, im[0], 0, jm[0]), isp2i, ua, d, utf, im[0]);
      launch(apply_filter_3, range2(0, im[0], 1, jm[0]), isp2i, va, d, vtf, im[0]);
    }
  }
  finish();
}

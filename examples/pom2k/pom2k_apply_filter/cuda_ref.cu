// Native CUDA reference of ext_apply_filter_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void apply_filter_0(Range r, const real_t *smoth, real_t *ua, real_t *uab,
                               const real_t *uaf, real_t *va, real_t *vab, const real_t *vaf,
                               real_t *el, real_t *elb, const real_t *elf, real_t *d,
                               const real_t *h, int im) {
  POM2K_INDEX(r, i, j, k);
  ua[ACC2(i, j)] =
      ua[ACC2(i, j)] + .5f * *smoth * (uab[ACC2(i, j)] - 2.0f * ua[ACC2(i, j)] + uaf[ACC2(i, j)]);
  va[ACC2(i, j)] =
      va[ACC2(i, j)] + .5f * *smoth * (vab[ACC2(i, j)] - 2.0f * va[ACC2(i, j)] + vaf[ACC2(i, j)]);
  el[ACC2(i, j)] =
      el[ACC2(i, j)] + .5f * *smoth * (elb[ACC2(i, j)] - 2.0f * el[ACC2(i, j)] + elf[ACC2(i, j)]);
  elb[ACC2(i, j)] = el[ACC2(i, j)];
  el[ACC2(i, j)] = elf[ACC2(i, j)];
  d[ACC2(i, j)] = h[ACC2(i, j)] + el[ACC2(i, j)];
  uab[ACC2(i, j)] = ua[ACC2(i, j)];
  ua[ACC2(i, j)] = uaf[ACC2(i, j)];
  vab[ACC2(i, j)] = va[ACC2(i, j)];
  va[ACC2(i, j)] = vaf[ACC2(i, j)];
}

__global__ void apply_filter_1(Range r, const real_t *ispi, const real_t *el, real_t *egf,
                               int im) {
  POM2K_INDEX(r, i, j, k);
  egf[ACC2(i, j)] = egf[ACC2(i, j)] + el[ACC2(i, j)] * *ispi;
}

__global__ void apply_filter_2(Range r, const real_t *isp2i, const real_t *ua, const real_t *d,
                               real_t *utf, int im) {
  POM2K_INDEX(r, i, j, k);
  utf[ACC2(i, j)] = utf[ACC2(i, j)] + ua[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * *isp2i;
}

__global__ void apply_filter_3(Range r, const real_t *isp2i, const real_t *va, const real_t *d,
                               real_t *vtf, int im) {
  POM2K_INDEX(r, i, j, k);
  vtf[ACC2(i, j)] = vtf[ACC2(i, j)] + va[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * *isp2i;
}

}  // namespace

// The branch conditions read scalars from managed memory on the host, like the
// C source.
void ext_apply_filter__cuda(real_t *vamax, real_t *vmaxl, real_t *smoth, int *iext, int *isplit,
                            real_t *ispi, real_t *isp2i, real_t *ua, real_t *uab, real_t *uaf,
                            real_t *va, real_t *vab, real_t *vaf, real_t *el, real_t *elb,
                            real_t *elf, real_t *d, real_t *h, real_t *egf, real_t *utf,
                            real_t *vtf) {
  if (*vamax < *vmaxl) {
    // Apply filter to remove time split and reset time sequence:
    launch(apply_filter_0, range2(0, im[0], 0, jm[0]), smoth, ua, uab, uaf, va, vab, vaf, el,
           elb, elf, d, h, im[0]);
    if (*iext != *isplit) {
      launch(apply_filter_1, range2(0, im[0], 0, jm[0]), ispi, el, egf, im[0]);
      launch(apply_filter_2, range2(1, im[0], 0, jm[0]), isp2i, ua, d, utf, im[0]);
      launch(apply_filter_3, range2(0, im[0], 1, jm[0]), isp2i, va, d, vtf, im[0]);
    }
  }
  finish();
}

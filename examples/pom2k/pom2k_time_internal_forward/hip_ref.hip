// Native HIP reference of ext_time_internal_forward_
// (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Time averages of the external mode, accumulated for the internal mode.
POM2K_KERNEL void time_internal_forward_0(Range r, real_t *__restrict__ egf,
                                          const real_t *__restrict__ el,
                                          const real_t *__restrict__ ispi, int im) {
  POM2K_INDEX(r, i, j, k);
  egf[ACC2(i, j)] = el[ACC2(i, j)] * (*ispi);
}

POM2K_KERNEL void time_internal_forward_1(Range r, real_t *__restrict__ utf,
                                          const real_t *__restrict__ ua,
                                          const real_t *__restrict__ d,
                                          const real_t *__restrict__ isp2i, int im) {
  POM2K_INDEX(r, i, j, k);
  utf[ACC2(i, j)] = ua[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * (*isp2i);
}

POM2K_KERNEL void time_internal_forward_2(Range r, real_t *__restrict__ vtf,
                                          const real_t *__restrict__ va,
                                          const real_t *__restrict__ d,
                                          const real_t *__restrict__ isp2i, int im) {
  POM2K_INDEX(r, i, j, k);
  vtf[ACC2(i, j)] = va[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * (*isp2i);
}

}  // namespace

void ext_time_internal_forward__hip(real_t *egf, real_t *el, real_t *ispi, real_t *utf,
                                    real_t *ua, real_t *d, real_t *isp2i, real_t *vtf,
                                    real_t *va) {
  launch(time_internal_forward_0, range2(0, im[0], 0, jm[0]), egf, el, ispi, im[0]);
  launch(time_internal_forward_1, range2(1, im[0], 0, jm[0]), utf, ua, d, isp2i, im[0]);
  launch(time_internal_forward_2, range2(1, im[0], 1, jm[0]), vtf, va, d, isp2i, im[0]);
  finish();
}

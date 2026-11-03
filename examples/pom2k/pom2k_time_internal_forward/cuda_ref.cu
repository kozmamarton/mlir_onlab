// Native CUDA reference of ext_time_internal_forward_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void time_internal_forward_0(Range r, real_t *egf, const real_t *el,
                                        const real_t *ispi, int im) {
  POM2K_INDEX(r, i, j, k);
  egf[ACC2(i, j)] = el[ACC2(i, j)] * (*ispi);
}

__global__ void time_internal_forward_1(Range r, real_t *utf, const real_t *ua, const real_t *d,
                                        const real_t *isp2i, int im) {
  POM2K_INDEX(r, i, j, k);
  utf[ACC2(i, j)] = ua[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * (*isp2i);
}

__global__ void time_internal_forward_2(Range r, real_t *vtf, const real_t *va, const real_t *d,
                                        const real_t *isp2i, int im) {
  POM2K_INDEX(r, i, j, k);
  vtf[ACC2(i, j)] = va[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * (*isp2i);
}

}  // namespace

void ext_time_internal_forward__cuda(real_t *egf, real_t *el, real_t *ispi, real_t *utf,
                                     real_t *ua, real_t *d, real_t *isp2i, real_t *vtf,
                                     real_t *va) {
  launch(time_internal_forward_0, range2(0, im[0], 0, jm[0]), egf, el, ispi, im[0]);
  launch(time_internal_forward_1, range2(1, im[0], 0, jm[0]), utf, ua, d, isp2i, im[0]);
  launch(time_internal_forward_2, range2(1, im[0], 1, jm[0]), vtf, va, d, isp2i, im[0]);
  finish();
}

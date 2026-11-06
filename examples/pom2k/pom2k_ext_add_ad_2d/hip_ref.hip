// Native HIP reference of ext_add_ad_2d_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

POM2K_KERNEL void add_ad_2d_0(Range r, real_t *__restrict__ adx2d, real_t *__restrict__ ady2d,
                              const real_t *__restrict__ advua,
                              const real_t *__restrict__ advva, int im) {
  POM2K_INDEX(r, i, j, k);
  adx2d[ACC2(i, j)] -= advua[ACC2(i, j)];
  ady2d[ACC2(i, j)] -= advva[ACC2(i, j)];
}

}  // namespace

void ext_add_ad_2d__hip(real_t *adx2d, real_t *ady2d, real_t *advua, real_t *advva) {
  launch(add_ad_2d_0, range2(0, im[0], 0, jm[0]), adx2d, ady2d, advua, advva, im[0]);
  finish();
}

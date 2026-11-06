// Native HIP reference of ext_bcond_5_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Masks the vertical velocity with the land/sea mask.
POM2K_KERNEL void bcond_5_0(Range r, real_t *__restrict__ w, const real_t *__restrict__ fsm,
                            int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  w[ACC3(i, j, k)] = w[ACC3(i, j, k)] * fsm[ACC2(i, j)];
}

}  // namespace

void ext_bcond_5__hip(real_t *w, real_t *fsm) {
  launch(bcond_5_0, range3(0, im[0], 0, jm[0], 0, kbm1[0]), w, fsm, im[0], jm[0]);
  finish();
}

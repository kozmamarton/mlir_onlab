// Native HIP reference of ext_init_horizontal_velocities_
// (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

POM2K_KERNEL void init_horizontal_velocities_0(Range r, real_t *__restrict__ uf,
                                               real_t *__restrict__ vf, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  uf[ACC3(i, j, k)] = 0.0f;
  vf[ACC3(i, j, k)] = 0.0f;
}

}  // namespace

void ext_init_horizontal_velocities__hip(real_t *uf, real_t *vf) {
  launch(init_horizontal_velocities_0, range3(1, im[0], 1, jm[0], 0, kb[0]), uf, vf, im[0],
         jm[0]);
  finish();
}

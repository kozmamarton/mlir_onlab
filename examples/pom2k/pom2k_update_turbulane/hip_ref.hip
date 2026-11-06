// Native HIP reference of ext_update_turbulane_
// (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Asselin filter of the turbulence fields, then the time-level shift. The
// statements keep the C order: q2b receives the filtered q2.
POM2K_KERNEL void update_turbulane_0(Range r, real_t *__restrict__ q2, real_t *__restrict__ q2b,
                                     real_t *__restrict__ q2l, real_t *__restrict__ q2lb,
                                     const real_t *__restrict__ uf,
                                     const real_t *__restrict__ vf,
                                     const real_t *__restrict__ smoth, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  const int n = ACC3(i, j, k);
  q2[n] += 0.5f * (*smoth) * (uf[n] + q2b[n] - 2.0f * q2[n]);
  q2l[n] += 0.5f * (*smoth) * (vf[n] + q2lb[n] - 2.0f * q2l[n]);
  q2b[n] = q2[n];
  q2[n] = uf[n];
  q2lb[n] = q2l[n];
  q2l[n] = vf[n];
}

}  // namespace

void ext_update_turbulane__hip(real_t *q2, real_t *q2b, real_t *q2l, real_t *q2lb, real_t *uf,
                               real_t *vf, real_t *smoth) {
  launch(update_turbulane_0, range3(0, im[0], 0, jm[0], 0, kb[0]), q2, q2b, q2l, q2lb, uf, vf,
         smoth, im[0], jm[0]);
  finish();
}

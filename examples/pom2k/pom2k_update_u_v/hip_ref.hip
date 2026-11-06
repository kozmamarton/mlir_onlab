// Native HIP reference of ext_update_u_v_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

POM2K_KERNEL void update_u_v_0(Range r, real_t *__restrict__ tps, int im) {
  POM2K_INDEX(r, i, j, k);
  tps[ACC2(i, j)] = 0.0f;
}

// Asselin filter of v (tps is the zeroed correction of the C source).
POM2K_KERNEL void update_u_v_1(Range r, real_t *__restrict__ v, const real_t *__restrict__ vf,
                               const real_t *__restrict__ vb, const real_t *__restrict__ tps,
                               const real_t *__restrict__ smoth, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  const int n = ACC3(i, j, k);
  v[n] += 0.5f * (*smoth) * (vf[n] + vb[n] - 2.0f * v[n] - tps[ACC2(i, j)]);
}

// Time-level shift of u and v.
POM2K_KERNEL void update_u_v_2(Range r, real_t *__restrict__ u, const real_t *__restrict__ uf,
                               real_t *__restrict__ ub, real_t *__restrict__ v,
                               const real_t *__restrict__ vf, real_t *__restrict__ vb, int im,
                               int jm) {
  POM2K_INDEX(r, i, j, k);
  const int n = ACC3(i, j, k);
  ub[n] = u[n];
  u[n] = uf[n];
  vb[n] = v[n];
  v[n] = vf[n];
}

}  // namespace

// The u smoothing and the second tps reset are commented out in the C source
// and are therefore absent here as well.
void ext_update_u_v__hip(real_t *tps, real_t *u, real_t *uf, real_t *ub, real_t *v, real_t *vf,
                         real_t *vb, real_t *dz, real_t *smoth) {
  (void)dz;
  launch(update_u_v_0, range2(0, im[0], 0, jm[0]), tps, im[0]);
  launch(update_u_v_1, range3(0, im[0], 0, jm[0], 0, kbm1[0]), v, vf, vb, tps, smoth, im[0],
         jm[0]);
  launch(update_u_v_2, range3(0, im[0], 0, jm[0], 0, kb[0]), u, uf, ub, v, vf, vb, im[0], jm[0]);
  finish();
}

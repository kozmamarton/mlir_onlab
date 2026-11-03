// Native CUDA reference of ext_update_u_v_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void update_u_v_0(Range r, real_t *tps, int im) {
  POM2K_INDEX(r, i, j, k);
  tps[ACC2(i, j)] = 0.0f;
}

__global__ void update_u_v_1(Range r, real_t *v, const real_t *vf, const real_t *vb,
                             const real_t *tps, const real_t *smoth, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  v[ACC3(i, j, k)] += 0.5f * (*smoth) *
                      (vf[ACC3(i, j, k)] + vb[ACC3(i, j, k)] - 2.0f * v[ACC3(i, j, k)] -
                       tps[ACC2(i, j)]);
}

__global__ void update_u_v_2(Range r, real_t *u, const real_t *uf, real_t *ub, real_t *v,
                             const real_t *vf, real_t *vb, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  ub[ACC3(i, j, k)] = u[ACC3(i, j, k)];
  u[ACC3(i, j, k)] = uf[ACC3(i, j, k)];
  vb[ACC3(i, j, k)] = v[ACC3(i, j, k)];
  v[ACC3(i, j, k)] = vf[ACC3(i, j, k)];
}

}  // namespace

// The u smoothing and the second tps reset are commented out in the C source
// and are therefore absent here as well.
void ext_update_u_v__cuda(real_t *tps, real_t *u, real_t *uf, real_t *ub, real_t *v, real_t *vf,
                          real_t *vb, real_t *dz, real_t *smoth) {
  (void)dz;
  launch(update_u_v_0, range2(0, im[0], 0, jm[0]), tps, im[0]);
  launch(update_u_v_1, range3(0, im[0], 0, jm[0], 0, kbm1[0]), v, vf, vb, tps, smoth, im[0],
         jm[0]);
  launch(update_u_v_2, range3(0, im[0], 0, jm[0], 0, kb[0]), u, uf, ub, v, vf, vb, im[0], jm[0]);
  finish();
}

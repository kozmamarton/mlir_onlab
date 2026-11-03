// Native CUDA reference of ext_update_turbulane_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void update_turbulane_0(Range r, real_t *q2, real_t *q2b, real_t *q2l, real_t *q2lb,
                                   const real_t *uf, const real_t *vf, const real_t *smoth,
                                   int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  q2[ACC3(i, j, k)] +=
      0.5f * (*smoth) * (uf[ACC3(i, j, k)] + q2b[ACC3(i, j, k)] - 2.0f * q2[ACC3(i, j, k)]);
  q2l[ACC3(i, j, k)] +=
      0.5f * (*smoth) * (vf[ACC3(i, j, k)] + q2lb[ACC3(i, j, k)] - 2.0f * q2l[ACC3(i, j, k)]);
  q2b[ACC3(i, j, k)] = q2[ACC3(i, j, k)];
  q2[ACC3(i, j, k)] = uf[ACC3(i, j, k)];
  q2lb[ACC3(i, j, k)] = q2l[ACC3(i, j, k)];
  q2l[ACC3(i, j, k)] = vf[ACC3(i, j, k)];
}

}  // namespace

void ext_update_turbulane__cuda(real_t *q2, real_t *q2b, real_t *q2l, real_t *q2lb, real_t *uf,
                                real_t *vf, real_t *smoth) {
  launch(update_turbulane_0, range3(0, im[0], 0, jm[0], 0, kb[0]), q2, q2b, q2l, q2lb, uf, vf,
         smoth, im[0], jm[0]);
  finish();
}

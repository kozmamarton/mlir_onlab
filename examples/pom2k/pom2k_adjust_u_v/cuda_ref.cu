// Native CUDA reference of ext_adjust_u_v_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void adjust_u_v_zero(Range r, real_t *tps, int im) {
  POM2K_INDEX(r, i, j, k);
  tps[ACC2(i, j)] = 0.0f;
}

// tps accumulates over k, so every (i, j) column sums its k levels in the
// order of the C source.
__global__ void adjust_u_v_sum(Range r, real_t *tps, const real_t *x, const real_t *dz, int im,
                               int jm, int kbm1) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 0; k < kbm1; k++)
    tps[ACC2(i, j)] = tps[ACC2(i, j)] + x[ACC3(i, j, k)] * dz[k];
}

__global__ void adjust_u_v_u(Range r, const real_t *tps, real_t *u, const real_t *utb,
                             const real_t *utf, const real_t *dt, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  u[ACC3(i, j, k)] = (u[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                     (utb[ACC2(i, j)] + utf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]);
}

__global__ void adjust_u_v_v(Range r, const real_t *tps, real_t *v, const real_t *vtb,
                             const real_t *vtf, const real_t *dt, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  v[ACC3(i, j, k)] = (v[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                     (vtb[ACC2(i, j)] + vtf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]);
}

}  // namespace

void ext_adjust_u_v__cuda(real_t *tps, real_t *u, real_t *v, real_t *dz, real_t *utb,
                          real_t *utf, real_t *vtb, real_t *vtf, real_t *dt) {
  const Range plane = range2(0, im[0], 0, jm[0]);
  launch(adjust_u_v_zero, plane, tps, im[0]);
  launch(adjust_u_v_sum, plane, tps, u, dz, im[0], jm[0], kbm1[0]);
  launch(adjust_u_v_u, range3(1, im[0], 0, jm[0], 0, kbm1[0]), tps, u, utb, utf, dt, im[0],
         jm[0]);
  launch(adjust_u_v_zero, plane, tps, im[0]);
  launch(adjust_u_v_sum, plane, tps, v, dz, im[0], jm[0], kbm1[0]);
  launch(adjust_u_v_v, range3(0, im[0], 1, jm[0], 0, kbm1[0]), tps, v, vtb, vtf, dt, im[0],
         jm[0]);
  finish();
}

// Native CUDA reference of ext_baropg_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void baropg_sub_rmean(Range r, real_t *rho, const real_t *rmean, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  rho[ACC3(i, j, k)] = rho[ACC3(i, j, k)] - rmean[ACC3(i, j, k)];
}

// Calculate x-component of baroclinic pressure gradient: the surface level,
// then the loop-carried k recurrence, walked upwards by every (i, j) column.
__global__ void baropg_x_0(Range r, const real_t *rho, real_t *drhox, const real_t *zz,
                           const real_t *dt, int im, int jm, real_t grav) {
  POM2K_INDEX(r, i, j, k);
  drhox[ACC3(i, j, 0)] = 0.5f * grav * (-zz[0]) * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                         (rho[ACC3(i, j, 0)] - rho[ACC3(i - 1, j, 0)]);
}

__global__ void baropg_x_1(Range r, const real_t *rho, real_t *drhox, const real_t *zz,
                           const real_t *dt, int im, int jm, int kbm1, real_t grav) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 1; k < kbm1; k++) {
    drhox[ACC3(i, j, k)] =
        drhox[ACC3(i, j, k - 1)] +
        grav * 0.25f * (zz[k - 1] - zz[k]) * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
            (rho[ACC3(i, j, k)] - rho[ACC3(i - 1, j, k)] + rho[ACC3(i, j, k - 1)] -
             rho[ACC3(i - 1, j, k - 1)]) +
        grav * 0.25f * (zz[k - 1] + zz[k]) * (dt[ACC2(i, j)] - dt[ACC2(i - 1, j)]) *
            (rho[ACC3(i, j, k)] + rho[ACC3(i - 1, j, k)] - rho[ACC3(i, j, k - 1)] -
             rho[ACC3(i - 1, j, k - 1)]);
  }
}

__global__ void baropg_x_2(Range r, real_t *drhox, const real_t *dt, const real_t *dum,
                           const real_t *dy, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  drhox[ACC3(i, j, k)] = 0.25f * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) * drhox[ACC3(i, j, k)] *
                         dum[ACC2(i, j)] * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]);
}

// Calculate y-component of baroclinic pressure gradient:
__global__ void baropg_y_0(Range r, const real_t *rho, real_t *drhoy, const real_t *zz,
                           const real_t *dt, int im, int jm, real_t grav) {
  POM2K_INDEX(r, i, j, k);
  drhoy[ACC3(i, j, 0)] = 0.5f * grav * (-zz[0]) * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                         (rho[ACC3(i, j, 0)] - rho[ACC3(i, j - 1, 0)]);
}

__global__ void baropg_y_1(Range r, const real_t *rho, real_t *drhoy, const real_t *zz,
                           const real_t *dt, int im, int jm, int kbm1, real_t grav) {
  POM2K_INDEX(r, i, j, unused_k);
  for (int k = 1; k < kbm1; k++) {
    drhoy[ACC3(i, j, k)] =
        drhoy[ACC3(i, j, k - 1)] +
        grav * 0.25f * (zz[k - 1] - zz[k]) * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
            (rho[ACC3(i, j, k)] - rho[ACC3(i, j - 1, k)] + rho[ACC3(i, j, k - 1)] -
             rho[ACC3(i, j - 1, k - 1)]) +
        grav * 0.25f * (zz[k - 1] + zz[k]) * (dt[ACC2(i, j)] - dt[ACC2(i, j - 1)]) *
            (rho[ACC3(i, j, k)] + rho[ACC3(i, j - 1, k)] - rho[ACC3(i, j, k - 1)] -
             rho[ACC3(i, j - 1, k - 1)]);
  }
}

__global__ void baropg_y_2(Range r, real_t *drhoy, const real_t *dt, const real_t *dvm,
                           const real_t *dx, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  drhoy[ACC3(i, j, k)] = 0.25f * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) * drhoy[ACC3(i, j, k)] *
                         dvm[ACC2(i, j)] * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]);
}

__global__ void baropg_ramp(Range r, real_t *drhox, real_t *drhoy, const real_t *ramp, int im,
                            int jm) {
  POM2K_INDEX(r, i, j, k);
  drhox[ACC3(i, j, k)] = *ramp * drhox[ACC3(i, j, k)];
  drhoy[ACC3(i, j, k)] = *ramp * drhoy[ACC3(i, j, k)];
}

__global__ void baropg_add_rmean(Range r, real_t *rho, const real_t *rmean, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  rho[ACC3(i, j, k)] = rho[ACC3(i, j, k)] + rmean[ACC3(i, j, k)];
}

}  // namespace

void ext_baropg__cuda(real_t *rho, real_t *rmean, real_t *drhox, real_t *drhoy, real_t *zz,
                      real_t *dt, real_t *dum, real_t *dvm, real_t *dx, real_t *dy,
                      real_t *ramp) {
  const int I = im[0], J = jm[0], K = kb[0], KM1 = kbm1[0];
  const Range interior = range2(1, imm1[0], 1, jmm1[0]);
  launch(baropg_sub_rmean, range3(0, I, 0, J, 0, K), rho, rmean, I, J);
  launch(baropg_x_0, interior, rho, drhox, zz, dt, I, J, grav[0]);
  launch(baropg_x_1, interior, rho, drhox, zz, dt, I, J, KM1, grav[0]);
  launch(baropg_x_2, range3(1, imm1[0], 1, jmm1[0], 0, KM1), drhox, dt, dum, dy, I, J);
  launch(baropg_y_0, interior, rho, drhoy, zz, dt, I, J, grav[0]);
  launch(baropg_y_1, interior, rho, drhoy, zz, dt, I, J, KM1, grav[0]);
  launch(baropg_y_2, range3(1, imm1[0], 1, jmm1[0], 0, KM1), drhoy, dt, dvm, dx, I, J);
  launch(baropg_ramp, range3(1, imm1[0], 1, jmm1[0], 0, K), drhox, drhoy, ramp, I, J);
  launch(baropg_add_rmean, range3(0, I, 0, J, 0, K), rho, rmean, I, J);
  finish();
}

// Native HIP reference of ext_aam_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Smagorinsky horizontal viscosity from the local velocity gradients. The C
// source spells every term out twice (x * x); the named terms below compute
// exactly the same products.
POM2K_KERNEL void aam_0(Range r, real_t *__restrict__ aam, const real_t *__restrict__ dx,
                        const real_t *__restrict__ dy, const real_t *__restrict__ u,
                        const real_t *__restrict__ v, int im, int jm, real_t horcon) {
  POM2K_INDEX(r, i, j, k);
  const real_t dudx = (u[ACC3(i + 1, j, k)] - u[ACC3(i, j, k)]) / dx[ACC2(i, j)];
  const real_t dvdy = (v[ACC3(i, j + 1, k)] - v[ACC3(i, j, k)]) / dy[ACC2(i, j)];
  const real_t shear = 0.25f *
                           (u[ACC3(i, j + 1, k)] + u[ACC3(i + 1, j + 1, k)] -
                            u[ACC3(i, j - 1, k)] - u[ACC3(i + 1, j - 1, k)]) /
                           dy[ACC2(i, j)] +
                       0.25f *
                           (v[ACC3(i + 1, j, k)] + v[ACC3(i + 1, j + 1, k)] -
                            v[ACC3(i - 1, j, k)] - v[ACC3(i - 1, j + 1, k)]) /
                           dx[ACC2(i, j)];
  aam[ACC3(i, j, k)] = horcon * dx[ACC2(i, j)] * dy[ACC2(i, j)] *
                       sqrtf(dudx * dudx + dvdy * dvdy + 0.5f * shear * shear);
}

}  // namespace

void ext_aam__hip(real_t *aam, real_t *dx, real_t *dy, real_t *u, real_t *v) {
  launch(aam_0, range3(1, imm1[0], 1, jmm1[0], 0, kbm1[0]), aam, dx, dy, u, v, im[0], jm[0],
         horcon[0]);
  finish();
}

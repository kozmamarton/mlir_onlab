// Native HIP reference of ext_flux_update_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Depth-integrated fluxes on the u and v points of the staggered grid.
POM2K_KERNEL void flux_update_0(Range r, real_t *__restrict__ fluxua,
                                real_t *__restrict__ fluxva, const real_t *__restrict__ d,
                                const real_t *__restrict__ dy, const real_t *__restrict__ dx,
                                const real_t *__restrict__ ua, const real_t *__restrict__ va,
                                int im) {
  POM2K_INDEX(r, i, j, k);
  fluxua[ACC2(i, j)] = 0.25f * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) *
                       (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) * ua[ACC2(i, j)];
  fluxva[ACC2(i, j)] = 0.25f * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) *
                       (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) * va[ACC2(i, j)];
}

}  // namespace

void ext_flux_update__hip(real_t *fluxua, real_t *fluxva, real_t *d, real_t *dy, real_t *dx,
                          real_t *ua, real_t *va) {
  launch(flux_update_0, range2(1, im[0], 1, jm[0]), fluxua, fluxva, d, dy, dx, ua, va, im[0]);
  finish();
}

// Native HIP reference of ext_advave_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// The flux arrays are read at neighbouring points between the steps, so this
// stays a sequence of 2D kernels, one per C loop nest. C loops over the same
// points that only touch their own point are merged into one kernel (their
// intermediate values then stay in registers), and "zero the whole array, then
// set its interior" becomes a single kernel over the whole array.

// u-momentum fluxes: advective (x) and diffusive x flux.
POM2K_KERNEL void advave_ux(Range r, real_t *__restrict__ fluxua, const real_t *__restrict__ ua,
                            const real_t *__restrict__ uab, const real_t *__restrict__ d,
                            const real_t *__restrict__ dx, const real_t *__restrict__ aam2d,
                            int im) {
  POM2K_INDEX(r, i, j, k);
  const real_t adv = .125f *
                     ((d[ACC2(i + 1, j)] + d[ACC2(i, j)]) * ua[ACC2(i + 1, j)] +
                      (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * ua[ACC2(i, j)]) *
                     (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]);
  fluxua[ACC2(i, j)] = adv - d[ACC2(i, j)] * 2.0f * aam2d[ACC2(i, j)] *
                                 (uab[ACC2(i + 1, j)] - uab[ACC2(i, j)]) / dx[ACC2(i, j)];
}

// u-momentum y flux with the shear stress tps, and the x flux times dy.
POM2K_KERNEL void advave_uy(Range r, real_t *__restrict__ fluxua, real_t *__restrict__ fluxva,
                            const real_t *__restrict__ ua, const real_t *__restrict__ va,
                            const real_t *__restrict__ uab, const real_t *__restrict__ vab,
                            const real_t *__restrict__ d, const real_t *__restrict__ dx,
                            const real_t *__restrict__ dy, const real_t *__restrict__ aam2d,
                            real_t *__restrict__ tps, int im) {
  POM2K_INDEX(r, i, j, k);
  const real_t adv = .125f *
                     ((d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * va[ACC2(i, j)] +
                      (d[ACC2(i - 1, j)] + d[ACC2(i - 1, j - 1)]) * va[ACC2(i - 1, j)]) *
                     (ua[ACC2(i, j)] + ua[ACC2(i, j - 1)]);
  const real_t dxsum = dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] + dx[ACC2(i - 1, j - 1)];
  const real_t shear =
      .25f * (d[ACC2(i, j)] + d[ACC2(i - 1, j)] + d[ACC2(i, j - 1)] + d[ACC2(i - 1, j - 1)]) *
      (aam2d[ACC2(i, j)] + aam2d[ACC2(i, j - 1)] + aam2d[ACC2(i - 1, j)] +
       aam2d[ACC2(i - 1, j - 1)]) *
      ((uab[ACC2(i, j)] - uab[ACC2(i, j - 1)]) /
           (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] + dy[ACC2(i - 1, j - 1)]) +
       (vab[ACC2(i, j)] - vab[ACC2(i - 1, j)]) / dxsum);
  tps[ACC2(i, j)] = shear;
  fluxua[ACC2(i, j)] = fluxua[ACC2(i, j)] * dy[ACC2(i, j)];
  fluxva[ACC2(i, j)] = (adv - shear) * .25f * dxsum;
}

// advua over the whole plane: the flux divergence inside, 0 on the boundary.
POM2K_KERNEL void advave_advua(Range r, Range inside, real_t *__restrict__ advua,
                               const real_t *__restrict__ fluxua,
                               const real_t *__restrict__ fluxva, int im) {
  POM2K_INDEX(r, i, j, k);
  const bool in = i >= inside.i0 && i < inside.i1 && j >= inside.j0 && j < inside.j1;
  advua[ACC2(i, j)] = in ? fluxua[ACC2(i, j)] - fluxua[ACC2(i - 1, j)] + fluxva[ACC2(i, j + 1)] -
                               fluxva[ACC2(i, j)]
                         : 0.0f;
}

// v-momentum y flux: advective and diffusive.
POM2K_KERNEL void advave_vy(Range r, real_t *__restrict__ fluxva, const real_t *__restrict__ va,
                            const real_t *__restrict__ vab, const real_t *__restrict__ d,
                            const real_t *__restrict__ dy, const real_t *__restrict__ aam2d,
                            int im) {
  POM2K_INDEX(r, i, j, k);
  const real_t adv = .125f *
                     ((d[ACC2(i, j + 1)] + d[ACC2(i, j)]) * va[ACC2(i, j + 1)] +
                      (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * va[ACC2(i, j)]) *
                     (va[ACC2(i, j + 1)] + va[ACC2(i, j)]);
  fluxva[ACC2(i, j)] = adv - d[ACC2(i, j)] * 2.0f * aam2d[ACC2(i, j)] *
                                 (vab[ACC2(i, j + 1)] - vab[ACC2(i, j)]) / dy[ACC2(i, j)];
}

// v-momentum x flux with the shear stress tps, and the y flux times dx.
POM2K_KERNEL void advave_vx(Range r, real_t *__restrict__ fluxua, real_t *__restrict__ fluxva,
                            const real_t *__restrict__ ua, const real_t *__restrict__ va,
                            const real_t *__restrict__ d, const real_t *__restrict__ dx,
                            const real_t *__restrict__ dy, const real_t *__restrict__ tps,
                            int im) {
  POM2K_INDEX(r, i, j, k);
  const real_t adv = .125f *
                     ((d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * ua[ACC2(i, j)] +
                      (d[ACC2(i, j - 1)] + d[ACC2(i - 1, j - 1)]) * ua[ACC2(i, j - 1)]) *
                     (va[ACC2(i - 1, j)] + va[ACC2(i, j)]);
  fluxva[ACC2(i, j)] = fluxva[ACC2(i, j)] * dx[ACC2(i, j)];
  fluxua[ACC2(i, j)] =
      (adv - tps[ACC2(i, j)]) * .25f *
      (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] + dy[ACC2(i - 1, j - 1)]);
}

// advva over the whole plane: the flux divergence inside, 0 on the boundary.
POM2K_KERNEL void advave_advva(Range r, Range inside, real_t *__restrict__ advva,
                               const real_t *__restrict__ fluxua,
                               const real_t *__restrict__ fluxva, int im) {
  POM2K_INDEX(r, i, j, k);
  const bool in = i >= inside.i0 && i < inside.i1 && j >= inside.j0 && j < inside.j1;
  advva[ACC2(i, j)] = in ? fluxua[ACC2(i + 1, j)] - fluxua[ACC2(i, j)] + fluxva[ACC2(i, j)] -
                               fluxva[ACC2(i, j - 1)]
                         : 0.0f;
}

// mode == 2 only: bottom stresses and the curvature term.
POM2K_KERNEL void advave_bottom(Range r, real_t *__restrict__ wubot, real_t *__restrict__ wvbot,
                                real_t *__restrict__ curv2d, const real_t *__restrict__ ua,
                                const real_t *__restrict__ va, const real_t *__restrict__ uab,
                                const real_t *__restrict__ vab, const real_t *__restrict__ cbc,
                                const real_t *__restrict__ dx, const real_t *__restrict__ dy,
                                int im) {
  POM2K_INDEX(r, i, j, k);
  const real_t vabu = .25f * (vab[ACC2(i, j)] + vab[ACC2(i, j + 1)] + vab[ACC2(i - 1, j)] +
                              vab[ACC2(i - 1, j + 1)]);
  wubot[ACC2(i, j)] = -0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
                      sqrtf(uab[ACC2(i, j)] * uab[ACC2(i, j)] + vabu * vabu) * uab[ACC2(i, j)];
  const real_t uabv = .25f * (uab[ACC2(i, j)] + uab[ACC2(i + 1, j)] + uab[ACC2(i, j - 1)] +
                              uab[ACC2(i + 1, j - 1)]);
  wvbot[ACC2(i, j)] = -0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i, j - 1)]) *
                      sqrtf(vab[ACC2(i, j)] * vab[ACC2(i, j)] + uabv * uabv) * vab[ACC2(i, j)];
  curv2d[ACC2(i, j)] =
      .25f *
      ((va[ACC2(i, j + 1)] + va[ACC2(i, j)]) * (dy[ACC2(i + 1, j)] - dy[ACC2(i - 1, j)]) -
       (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) * (dx[ACC2(i, j + 1)] - dx[ACC2(i, j - 1)])) /
      (dx[ACC2(i, j)] * dy[ACC2(i, j)]);
}

POM2K_KERNEL void advave_curv_u(Range r, const real_t *__restrict__ curv2d,
                                real_t *__restrict__ advua, const real_t *__restrict__ va,
                                const real_t *__restrict__ d, const real_t *__restrict__ aru,
                                int im) {
  POM2K_INDEX(r, i, j, k);
  advua[ACC2(i, j)] =
      advua[ACC2(i, j)] -
      aru[ACC2(i, j)] * .25f *
          (curv2d[ACC2(i, j)] * d[ACC2(i, j)] * (va[ACC2(i, j + 1)] + va[ACC2(i, j)]) +
           curv2d[ACC2(i - 1, j)] * d[ACC2(i - 1, j)] *
               (va[ACC2(i - 1, j + 1)] + va[ACC2(i - 1, j)]));
}

POM2K_KERNEL void advave_curv_v(Range r, const real_t *__restrict__ curv2d,
                                real_t *__restrict__ advva, const real_t *__restrict__ ua,
                                const real_t *__restrict__ d, const real_t *__restrict__ arv,
                                int im) {
  POM2K_INDEX(r, i, j, k);
  advva[ACC2(i, j)] =
      advva[ACC2(i, j)] +
      arv[ACC2(i, j)] * .25f *
          (curv2d[ACC2(i, j)] * d[ACC2(i, j)] * (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) +
           curv2d[ACC2(i, j - 1)] * d[ACC2(i, j - 1)] *
               (ua[ACC2(i + 1, j - 1)] + ua[ACC2(i, j - 1)]));
}

}  // namespace

void ext_advave__hip(real_t *curv2d, real_t *advua, real_t *advva, real_t *fluxua,
                     real_t *fluxva, real_t *ua, real_t *va, real_t *uab, real_t *vab,
                     real_t *wubot, real_t *wvbot, real_t *d, real_t *dx, real_t *dy,
                     real_t *aru, real_t *arv, real_t *aam2d, real_t *tps, real_t *cbc) {
  const int I = im[0], J = jm[0], IM1 = imm1[0], JM1 = jmm1[0];
  const Range plane = range2(0, I, 0, J), interior = range2(1, IM1, 1, JM1);
  // u-momentum advection and diffusion:
  launch(advave_ux, range2(1, IM1, 1, J), fluxua, ua, uab, d, dx, aam2d, I);
  launch(advave_uy, range2(1, I, 1, J), fluxua, fluxva, ua, va, uab, vab, d, dx, dy, aam2d, tps,
         I);
  launch(advave_advua, plane, interior, advua, fluxua, fluxva, I);
  // v-momentum advection and diffusion:
  launch(advave_vy, range2(1, I, 1, JM1), fluxva, va, vab, d, dy, aam2d, I);
  launch(advave_vx, range2(1, I, 1, J), fluxua, fluxva, ua, va, d, dx, dy, tps, I);
  launch(advave_advva, plane, interior, advva, fluxua, fluxva, I);
  if (mode[0] == 2) {
    launch(advave_bottom, interior, wubot, wvbot, curv2d, ua, va, uab, vab, cbc, dx, dy, I);
    launch(advave_curv_u, range2(2, IM1, 1, JM1), curv2d, advua, va, d, aru, I);
    launch(advave_curv_v, range2(1, IM1, 2, JM1), curv2d, advva, ua, d, arv, I);
  }
  finish();
}

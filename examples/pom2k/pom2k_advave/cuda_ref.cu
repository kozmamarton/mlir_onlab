// Native CUDA reference of ext_advave_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void advave_zero(Range r, real_t *x, int im) {
  POM2K_INDEX(r, i, j, k);
  x[ACC2(i, j)] = 0.0f;
}

__global__ void advave_0(Range r, real_t *fluxua, const real_t *ua, const real_t *d, int im) {
  POM2K_INDEX(r, i, j, k);
  fluxua[ACC2(i, j)] = .125f *
                       ((d[ACC2(i + 1, j)] + d[ACC2(i, j)]) * ua[ACC2(i + 1, j)] +
                        (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * ua[ACC2(i, j)]) *
                       (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]);
}

__global__ void advave_1(Range r, real_t *fluxva, const real_t *ua, const real_t *va,
                         const real_t *d, int im) {
  POM2K_INDEX(r, i, j, k);
  fluxva[ACC2(i, j)] = .125f *
                       ((d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * va[ACC2(i, j)] +
                        (d[ACC2(i - 1, j)] + d[ACC2(i - 1, j - 1)]) * va[ACC2(i - 1, j)]) *
                       (ua[ACC2(i, j)] + ua[ACC2(i, j - 1)]);
}

__global__ void advave_2(Range r, real_t *fluxua, const real_t *uab, const real_t *d,
                         const real_t *dx, const real_t *aam2d, int im) {
  POM2K_INDEX(r, i, j, k);
  fluxua[ACC2(i, j)] = fluxua[ACC2(i, j)] - d[ACC2(i, j)] * 2.0f * aam2d[ACC2(i, j)] *
                                                (uab[ACC2(i + 1, j)] - uab[ACC2(i, j)]) /
                                                dx[ACC2(i, j)];
}

__global__ void advave_3(Range r, real_t *fluxua, real_t *fluxva, const real_t *uab,
                         const real_t *vab, const real_t *d, const real_t *dx,
                         const real_t *dy, const real_t *aam2d, real_t *tps, int im) {
  POM2K_INDEX(r, i, j, k);
  tps[ACC2(i, j)] =
      .25f * (d[ACC2(i, j)] + d[ACC2(i - 1, j)] + d[ACC2(i, j - 1)] + d[ACC2(i - 1, j - 1)]) *
      (aam2d[ACC2(i, j)] + aam2d[ACC2(i, j - 1)] + aam2d[ACC2(i - 1, j)] +
       aam2d[ACC2(i - 1, j - 1)]) *
      ((uab[ACC2(i, j)] - uab[ACC2(i, j - 1)]) /
           (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] + dy[ACC2(i - 1, j - 1)]) +
       (vab[ACC2(i, j)] - vab[ACC2(i - 1, j)]) /
           (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] + dx[ACC2(i - 1, j - 1)]));
  fluxua[ACC2(i, j)] = fluxua[ACC2(i, j)] * dy[ACC2(i, j)];
  fluxva[ACC2(i, j)] =
      (fluxva[ACC2(i, j)] - tps[ACC2(i, j)]) * .25f *
      (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] + dx[ACC2(i - 1, j - 1)]);
}

__global__ void advave_4(Range r, real_t *advua, const real_t *fluxua, const real_t *fluxva,
                         int im) {
  POM2K_INDEX(r, i, j, k);
  advua[ACC2(i, j)] =
      fluxua[ACC2(i, j)] - fluxua[ACC2(i - 1, j)] + fluxva[ACC2(i, j + 1)] - fluxva[ACC2(i, j)];
}

__global__ void advave_5(Range r, real_t *fluxua, const real_t *ua, const real_t *va,
                         const real_t *d, int im) {
  POM2K_INDEX(r, i, j, k);
  fluxua[ACC2(i, j)] = .125f *
                       ((d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * ua[ACC2(i, j)] +
                        (d[ACC2(i, j - 1)] + d[ACC2(i - 1, j - 1)]) * ua[ACC2(i, j - 1)]) *
                       (va[ACC2(i - 1, j)] + va[ACC2(i, j)]);
}

__global__ void advave_6(Range r, real_t *fluxva, const real_t *va, const real_t *d, int im) {
  POM2K_INDEX(r, i, j, k);
  fluxva[ACC2(i, j)] = .125f *
                       ((d[ACC2(i, j + 1)] + d[ACC2(i, j)]) * va[ACC2(i, j + 1)] +
                        (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * va[ACC2(i, j)]) *
                       (va[ACC2(i, j + 1)] + va[ACC2(i, j)]);
}

__global__ void advave_7(Range r, real_t *fluxva, const real_t *vab, const real_t *d,
                         const real_t *dy, const real_t *aam2d, int im) {
  POM2K_INDEX(r, i, j, k);
  fluxva[ACC2(i, j)] = fluxva[ACC2(i, j)] - d[ACC2(i, j)] * 2.0f * aam2d[ACC2(i, j)] *
                                                (vab[ACC2(i, j + 1)] - vab[ACC2(i, j)]) /
                                                dy[ACC2(i, j)];
}

__global__ void advave_8(Range r, real_t *fluxua, real_t *fluxva, const real_t *dx,
                         const real_t *dy, const real_t *tps, int im) {
  POM2K_INDEX(r, i, j, k);
  fluxva[ACC2(i, j)] = fluxva[ACC2(i, j)] * dx[ACC2(i, j)];
  fluxua[ACC2(i, j)] =
      (fluxua[ACC2(i, j)] - tps[ACC2(i, j)]) * .25f *
      (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] + dy[ACC2(i - 1, j - 1)]);
}

__global__ void advave_9(Range r, real_t *advva, const real_t *fluxua, const real_t *fluxva,
                         int im) {
  POM2K_INDEX(r, i, j, k);
  advva[ACC2(i, j)] =
      fluxua[ACC2(i + 1, j)] - fluxua[ACC2(i, j)] + fluxva[ACC2(i, j)] - fluxva[ACC2(i, j - 1)];
}

// mode == 2 only:
__global__ void advave_10(Range r, real_t *wubot, const real_t *uab, const real_t *vab,
                          const real_t *cbc, int im) {
  POM2K_INDEX(r, i, j, k);
  wubot[ACC2(i, j)] =
      -0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
      sqrtf(uab[ACC2(i, j)] * uab[ACC2(i, j)] +
            (.25f * (vab[ACC2(i, j)] + vab[ACC2(i, j + 1)] + vab[ACC2(i - 1, j)] +
                     vab[ACC2(i - 1, j + 1)])) *
                (.25f * (vab[ACC2(i, j)] + vab[ACC2(i, j + 1)] + vab[ACC2(i - 1, j)] +
                         vab[ACC2(i - 1, j + 1)]))) *
      uab[ACC2(i, j)];
}

__global__ void advave_11(Range r, real_t *wvbot, const real_t *uab, const real_t *vab,
                          const real_t *cbc, int im) {
  POM2K_INDEX(r, i, j, k);
  wvbot[ACC2(i, j)] =
      -0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i, j - 1)]) *
      sqrtf(vab[ACC2(i, j)] * vab[ACC2(i, j)] +
            (.25f * (uab[ACC2(i, j)] + uab[ACC2(i + 1, j)] + uab[ACC2(i, j - 1)] +
                     uab[ACC2(i + 1, j - 1)])) *
                (.25f * (uab[ACC2(i, j)] + uab[ACC2(i + 1, j)] + uab[ACC2(i, j - 1)] +
                         uab[ACC2(i + 1, j - 1)]))) *
      vab[ACC2(i, j)];
}

__global__ void advave_12(Range r, real_t *curv2d, const real_t *ua, const real_t *va,
                          const real_t *dx, const real_t *dy, int im) {
  POM2K_INDEX(r, i, j, k);
  curv2d[ACC2(i, j)] =
      .25f *
      ((va[ACC2(i, j + 1)] + va[ACC2(i, j)]) * (dy[ACC2(i + 1, j)] - dy[ACC2(i - 1, j)]) -
       (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) * (dx[ACC2(i, j + 1)] - dx[ACC2(i, j - 1)])) /
      (dx[ACC2(i, j)] * dy[ACC2(i, j)]);
}

__global__ void advave_13(Range r, const real_t *curv2d, real_t *advua, const real_t *va,
                          const real_t *d, const real_t *aru, int im) {
  POM2K_INDEX(r, i, j, k);
  advua[ACC2(i, j)] =
      advua[ACC2(i, j)] -
      aru[ACC2(i, j)] * .25f *
          (curv2d[ACC2(i, j)] * d[ACC2(i, j)] * (va[ACC2(i, j + 1)] + va[ACC2(i, j)]) +
           curv2d[ACC2(i - 1, j)] * d[ACC2(i - 1, j)] *
               (va[ACC2(i - 1, j + 1)] + va[ACC2(i - 1, j)]));
}

__global__ void advave_14(Range r, const real_t *curv2d, real_t *advva, const real_t *ua,
                          const real_t *d, const real_t *arv, int im) {
  POM2K_INDEX(r, i, j, k);
  advva[ACC2(i, j)] =
      advva[ACC2(i, j)] +
      arv[ACC2(i, j)] * .25f *
          (curv2d[ACC2(i, j)] * d[ACC2(i, j)] * (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) +
           curv2d[ACC2(i, j - 1)] * d[ACC2(i, j - 1)] *
               (ua[ACC2(i + 1, j - 1)] + ua[ACC2(i, j - 1)]));
}

}  // namespace

void ext_advave__cuda(real_t *curv2d, real_t *advua, real_t *advva, real_t *fluxua,
                      real_t *fluxva, real_t *ua, real_t *va, real_t *uab, real_t *vab,
                      real_t *wubot, real_t *wvbot, real_t *d, real_t *dx, real_t *dy,
                      real_t *aru, real_t *arv, real_t *aam2d, real_t *tps, real_t *cbc) {
  const int I = im[0], J = jm[0], IM1 = imm1[0], JM1 = jmm1[0];
  launch(advave_zero, range2(0, I, 0, J), advua, I);
  launch(advave_0, range2(1, IM1, 1, J), fluxua, ua, d, I);
  launch(advave_1, range2(1, I, 1, J), fluxva, ua, va, d, I);
  launch(advave_2, range2(1, IM1, 1, J), fluxua, uab, d, dx, aam2d, I);
  launch(advave_3, range2(1, I, 1, J), fluxua, fluxva, uab, vab, d, dx, dy, aam2d, tps, I);
  launch(advave_4, range2(1, IM1, 1, JM1), advua, fluxua, fluxva, I);
  launch(advave_zero, range2(0, I, 0, J), advva, I);
  launch(advave_5, range2(1, I, 1, J), fluxua, ua, va, d, I);
  launch(advave_6, range2(1, I, 1, JM1), fluxva, va, d, I);
  launch(advave_7, range2(1, I, 1, JM1), fluxva, vab, d, dy, aam2d, I);
  launch(advave_8, range2(1, I, 1, J), fluxua, fluxva, dx, dy, tps, I);
  launch(advave_9, range2(1, IM1, 1, JM1), advva, fluxua, fluxva, I);
  if (mode[0] == 2) {
    launch(advave_10, range2(1, IM1, 1, JM1), wubot, uab, vab, cbc, I);
    launch(advave_11, range2(1, IM1, 1, JM1), wvbot, uab, vab, cbc, I);
    launch(advave_12, range2(1, IM1, 1, JM1), curv2d, ua, va, dx, dy, I);
    launch(advave_13, range2(2, IM1, 1, JM1), curv2d, advua, va, d, aru, I);
    launch(advave_14, range2(1, IM1, 2, JM1), curv2d, advva, ua, d, arv, I);
  }
  finish();
}

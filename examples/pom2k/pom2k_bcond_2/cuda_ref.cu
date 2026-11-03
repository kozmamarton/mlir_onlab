// Native CUDA reference of ext_bcond_2_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void bcond_2_0(Range r, real_t *uaf, real_t *vaf, const real_t *uabe,
                          const real_t *uabw, const real_t *h, const real_t *el,
                          const real_t *ele, const real_t *elw, const real_t *ramp,
                          const real_t *rfe, const real_t *rfw, int im, int imm1, int imm2,
                          real_t grav) {
  POM2K_INDEX(r, j, unused_j, unused_k);
  // East:
  uaf[ACC2(imm1, j)] =
      uabe[j] + *rfe * sqrtf(grav / h[ACC2(imm2, j)]) * (el[ACC2(imm2, j)] - ele[j]);

  uaf[ACC2(imm1, j)] = *ramp * uaf[ACC2(imm1, j)];
  vaf[ACC2(imm1, j)] = 0.0f;
  // West:
  uaf[ACC2(1, j)] = uabw[j] - *rfw * sqrtf(grav / h[ACC2(1, j)]) * (el[ACC2(1, j)] - elw[j]);
  uaf[ACC2(1, j)] = *ramp * uaf[ACC2(1, j)];
  uaf[ACC2(0, j)] = uaf[ACC2(1, j)];
  vaf[ACC2(0, j)] = 0.0f;
}

__global__ void bcond_2_1(Range r, real_t *uaf, real_t *vaf, const real_t *vabn,
                          const real_t *vabs, const real_t *h, const real_t *el,
                          const real_t *eln, const real_t *els, const real_t *ramp,
                          const real_t *rfn, const real_t *rfs, int im, int jmm1, int jmm2,
                          real_t grav) {
  POM2K_INDEX(r, i, unused_j, unused_k);
  // North:
  vaf[ACC2(i, jmm1)] =
      vabn[i] + *rfn * sqrtf(grav / h[ACC2(i, jmm2)]) * (el[ACC2(i, jmm2)] - eln[i]);
  vaf[ACC2(i, jmm1)] = *ramp * vaf[ACC2(i, jmm1)];
  uaf[ACC2(i, jmm1)] = 0.0f;
  // South:
  vaf[ACC2(i, 1)] = vabs[i] - *rfs * sqrtf(grav / h[ACC2(i, 1)]) * (el[ACC2(i, 1)] - els[i]);
  vaf[ACC2(i, 1)] = *ramp * vaf[ACC2(i, 1)];
  vaf[ACC2(i, 0)] = vaf[ACC2(i, 1)];
  uaf[ACC2(i, 0)] = 0.0f;
}

__global__ void bcond_2_2(Range r, real_t *uaf, real_t *vaf, const real_t *dum,
                          const real_t *dvm, int im) {
  POM2K_INDEX(r, i, j, k);
  uaf[ACC2(i, j)] = uaf[ACC2(i, j)] * dum[ACC2(i, j)];
  vaf[ACC2(i, j)] = vaf[ACC2(i, j)] * dvm[ACC2(i, j)];
}

}  // namespace

void ext_bcond_2__cuda(real_t *uaf, real_t *vaf, real_t *uabe, real_t *uabw, real_t *vabn,
                       real_t *vabs, real_t *h, real_t *el, real_t *ele, real_t *elw,
                       real_t *eln, real_t *els, real_t *dum, real_t *dvm, real_t *ramp,
                       real_t *rfe, real_t *rfw, real_t *rfn, real_t *rfs) {
  launch(bcond_2_0, range2(1, jmm1[0], 0, 1), uaf, vaf, uabe, uabw, h, el, ele, elw, ramp, rfe,
         rfw, im[0], imm1[0], imm2[0], grav[0]);
  launch(bcond_2_1, range2(1, imm1[0], 0, 1), uaf, vaf, vabn, vabs, h, el, eln, els, ramp, rfn,
         rfs, im[0], jmm1[0], jmm2[0], grav[0]);
  launch(bcond_2_2, range2(0, im[0], 0, jm[0]), uaf, vaf, dum, dvm, im[0]);
  finish();
}

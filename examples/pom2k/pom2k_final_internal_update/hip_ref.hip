// Native HIP reference of ext_final_internal_update_
// (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Time-level shift of the 2D internal-mode fields.
POM2K_KERNEL void final_internal_update_0(
    Range r, real_t *__restrict__ egb, const real_t *__restrict__ egf, real_t *__restrict__ etb,
    real_t *__restrict__ et, const real_t *__restrict__ etf, real_t *__restrict__ dt,
    const real_t *__restrict__ h, real_t *__restrict__ utb, const real_t *__restrict__ utf,
    real_t *__restrict__ vtb, const real_t *__restrict__ vtf, real_t *__restrict__ vfluxb,
    const real_t *__restrict__ vfluxf, int im) {
  POM2K_INDEX(r, i, j, k);
  const int n = ACC2(i, j);
  egb[n] = egf[n];
  etb[n] = et[n];
  et[n] = etf[n];
  dt[n] = h[n] + et[n];
  utb[n] = utf[n];
  vtb[n] = vtf[n];
  vfluxb[n] = vfluxf[n];
}

}  // namespace

void ext_final_internal_update__hip(real_t *egb, real_t *egf, real_t *etb, real_t *et,
                                    real_t *etf, real_t *dt, real_t *h, real_t *utb,
                                    real_t *utf, real_t *vtb, real_t *vtf, real_t *vfluxb,
                                    real_t *vfluxf) {
  launch(final_internal_update_0, range2(0, im[0], 0, jm[0]), egb, egf, etb, et, etf, dt, h,
         utb, utf, vtb, vtf, vfluxb, vfluxf, im[0]);
  finish();
}

// Native CUDA reference of ext_final_internal_update_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void final_internal_update_0(Range r, real_t *egb, const real_t *egf, real_t *etb,
                                        real_t *et, const real_t *etf, real_t *dt,
                                        const real_t *h, real_t *utb, const real_t *utf,
                                        real_t *vtb, const real_t *vtf, real_t *vfluxb,
                                        const real_t *vfluxf, int im) {
  POM2K_INDEX(r, i, j, k);
  egb[ACC2(i, j)] = egf[ACC2(i, j)];
  etb[ACC2(i, j)] = et[ACC2(i, j)];
  et[ACC2(i, j)] = etf[ACC2(i, j)];
  dt[ACC2(i, j)] = h[ACC2(i, j)] + et[ACC2(i, j)];
  utb[ACC2(i, j)] = utf[ACC2(i, j)];
  vtb[ACC2(i, j)] = vtf[ACC2(i, j)];
  vfluxb[ACC2(i, j)] = vfluxf[ACC2(i, j)];
}

}  // namespace

void ext_final_internal_update__cuda(real_t *egb, real_t *egf, real_t *etb, real_t *et,
                                     real_t *etf, real_t *dt, real_t *h, real_t *utb,
                                     real_t *utf, real_t *vtb, real_t *vtf, real_t *vfluxb,
                                     real_t *vfluxf) {
  launch(final_internal_update_0, range2(0, im[0], 0, jm[0]), egb, egf, etb, et, etf, dt, h,
         utb, utf, vtb, vtf, vfluxb, vfluxf, im[0]);
  finish();
}

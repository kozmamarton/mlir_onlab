// Native CUDA reference of ext_etf_update_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void etf_update_0(Range r, const real_t *smoth, real_t *etf, const real_t *elf,
                             int im) {
  POM2K_INDEX(r, i, j, k);
  etf[ACC2(i, j)] = .25f * *smoth * elf[ACC2(i, j)];
}

__global__ void etf_update_1(Range r, const real_t *smoth, real_t *etf, const real_t *elf,
                             int im) {
  POM2K_INDEX(r, i, j, k);
  etf[ACC2(i, j)] = etf[ACC2(i, j)] + .5f * (1.0f - .5f * *smoth) * elf[ACC2(i, j)];
}

__global__ void etf_update_2(Range r, real_t *etf, const real_t *elf, const real_t *fsm,
                             int im) {
  POM2K_INDEX(r, i, j, k);
  etf[ACC2(i, j)] = (etf[ACC2(i, j)] + .5f * elf[ACC2(i, j)]) * fsm[ACC2(i, j)];
}

}  // namespace

// The selectors live in managed memory and are read on the host, like the
// branch conditions of the C source.
void ext_etf_update__cuda(int *iext, int *isplit, real_t *smoth, real_t *etf, real_t *elf,
                          real_t *fsm) {
  const Range all = range2(0, im[0], 0, jm[0]);
  if (*iext == *isplit - 2)
    launch(etf_update_0, all, smoth, etf, elf, im[0]);
  else if (*iext == *isplit - 1)
    launch(etf_update_1, all, smoth, etf, elf, im[0]);
  else if (*iext == *isplit)
    launch(etf_update_2, all, etf, elf, fsm, im[0]);
  finish();
}

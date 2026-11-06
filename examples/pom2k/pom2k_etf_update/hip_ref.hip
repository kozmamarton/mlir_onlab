// Native HIP reference of ext_etf_update_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Accumulates the time-averaged elevation etf over the last three external
// steps; which step this is decides the kernel.
POM2K_KERNEL void etf_update_0(Range r, const real_t *__restrict__ smoth,
                               real_t *__restrict__ etf, const real_t *__restrict__ elf,
                               int im) {
  POM2K_INDEX(r, i, j, k);
  etf[ACC2(i, j)] = .25f * *smoth * elf[ACC2(i, j)];
}

POM2K_KERNEL void etf_update_1(Range r, const real_t *__restrict__ smoth,
                               real_t *__restrict__ etf, const real_t *__restrict__ elf,
                               int im) {
  POM2K_INDEX(r, i, j, k);
  etf[ACC2(i, j)] = etf[ACC2(i, j)] + .5f * (1.0f - .5f * *smoth) * elf[ACC2(i, j)];
}

POM2K_KERNEL void etf_update_2(Range r, real_t *__restrict__ etf, const real_t *__restrict__ elf,
                               const real_t *__restrict__ fsm, int im) {
  POM2K_INDEX(r, i, j, k);
  etf[ACC2(i, j)] = (etf[ACC2(i, j)] + .5f * elf[ACC2(i, j)]) * fsm[ACC2(i, j)];
}

}  // namespace

// The selectors are read on the host, like the branch conditions of the C source.
void ext_etf_update__hip(int *iext, int *isplit, real_t *smoth, real_t *etf, real_t *elf,
                         real_t *fsm) {
  const Range all = range2(0, im[0], 0, jm[0]);
  const int ext = readScalar(iext), split = readScalar(isplit);
  if (ext == split - 2)
    launch(etf_update_0, all, smoth, etf, elf, im[0]);
  else if (ext == split - 1)
    launch(etf_update_1, all, smoth, etf, elf, im[0]);
  else if (ext == split)
    launch(etf_update_2, all, etf, elf, fsm, im[0]);
  finish();
}

// Native HIP reference of ext_bcond_1_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// East and west boundaries, one thread per j. The three kernels run in the
// order of the C loops, so the corners get the same values as in C.
POM2K_KERNEL void bcond_1_0(Range r, real_t *__restrict__ elf, int im, int imm1, int imm2) {
  POM2K_INDEX(r, j, unused_j, unused_k);
  elf[ACC2(0, j)] = elf[ACC2(1, j)];
  elf[ACC2(imm1, j)] = elf[ACC2(imm2, j)];
}

// North and south boundaries, one thread per i.
POM2K_KERNEL void bcond_1_1(Range r, real_t *__restrict__ elf, int im, int jmm1, int jmm2) {
  POM2K_INDEX(r, i, unused_j, unused_k);
  elf[ACC2(i, 0)] = elf[ACC2(i, 1)];
  elf[ACC2(i, jmm1)] = elf[ACC2(i, jmm2)];
}

POM2K_KERNEL void bcond_1_2(Range r, real_t *__restrict__ elf, const real_t *__restrict__ fsm,
                            int im) {
  POM2K_INDEX(r, i, j, k);
  elf[ACC2(i, j)] = elf[ACC2(i, j)] * fsm[ACC2(i, j)];
}

}  // namespace

void ext_bcond_1__hip(real_t *elf, real_t *fsm) {
  launch(bcond_1_0, range2(0, jm[0], 0, 1), elf, im[0], imm1[0], imm2[0]);
  launch(bcond_1_1, range2(0, im[0], 0, 1), elf, im[0], jmm1[0], jmm2[0]);
  launch(bcond_1_2, range2(0, im[0], 0, jm[0]), elf, fsm, im[0]);
  finish();
}

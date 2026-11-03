// Native CUDA reference of ext_elf_update_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void elf_update_0(Range r, real_t *elf, const real_t *elb, const real_t *fluxua,
                             const real_t *fluxva, const real_t *art, const real_t *vfluxf,
                             int im, real_t dte2) {
  POM2K_INDEX(r, i, j, k);
  elf[ACC2(i, j)] =
      elb[ACC2(i, j)] + dte2 * (-(fluxua[ACC2(i + 1, j)] - fluxua[ACC2(i, j)] +
                                  fluxva[ACC2(i, j + 1)] - fluxva[ACC2(i, j)]) /
                                    art[ACC2(i, j)] -
                                vfluxf[ACC2(i, j)]);
}

}  // namespace

void ext_elf_update__cuda(real_t *elf, real_t *elb, real_t *fluxua, real_t *fluxva, real_t *art,
                          real_t *vfluxf) {
  launch(elf_update_0, range2(1, imm1[0], 1, jmm1[0]), elf, elb, fluxua, fluxva, art, vfluxf,
         im[0], dte2[0]);
  finish();
}

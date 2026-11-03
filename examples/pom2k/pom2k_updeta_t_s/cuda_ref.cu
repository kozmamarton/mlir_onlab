// Native CUDA reference of ext_updeta_t_s_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

__global__ void updeta_t_s_0(Range r, real_t *t, real_t *tb, real_t *s, real_t *sb,
                             const real_t *uf, const real_t *vf, const real_t *smoth, int im,
                             int jm) {
  POM2K_INDEX(r, i, j, k);
  t[ACC3(i, j, k)] = t[ACC3(i, j, k)] + 0.5f * (*smoth) *
                                            (uf[ACC3(i, j, k)] + tb[ACC3(i, j, k)] -
                                             2.0f * t[ACC3(i, j, k)]);
  s[ACC3(i, j, k)] = s[ACC3(i, j, k)] + 0.5f * (*smoth) *
                                            (vf[ACC3(i, j, k)] + sb[ACC3(i, j, k)] -
                                             2.0f * s[ACC3(i, j, k)]);
  tb[ACC3(i, j, k)] = t[ACC3(i, j, k)];
  t[ACC3(i, j, k)] = uf[ACC3(i, j, k)];
  sb[ACC3(i, j, k)] = s[ACC3(i, j, k)];
  s[ACC3(i, j, k)] = vf[ACC3(i, j, k)];
}

}  // namespace

void ext_updeta_t_s__cuda(real_t *t, real_t *tb, real_t *s, real_t *sb, real_t *uf, real_t *vf,
                          real_t *smoth) {
  launch(updeta_t_s_0, range3(0, im[0], 0, jm[0], 0, kb[0]), t, tb, s, sb, uf, vf, smoth,
         im[0], jm[0]);
  finish();
}

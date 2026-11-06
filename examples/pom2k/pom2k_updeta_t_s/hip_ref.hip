// Native HIP reference of ext_updeta_t_s_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_hip.hpp"

namespace {

// Asselin filter of temperature and salinity, then the time-level shift. The
// statements keep the C order: tb/sb receive the filtered t/s.
POM2K_KERNEL void updeta_t_s_0(Range r, real_t *__restrict__ t, real_t *__restrict__ tb,
                               real_t *__restrict__ s, real_t *__restrict__ sb,
                               const real_t *__restrict__ uf, const real_t *__restrict__ vf,
                               const real_t *__restrict__ smoth, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  const int n = ACC3(i, j, k);
  t[n] = t[n] + 0.5f * (*smoth) * (uf[n] + tb[n] - 2.0f * t[n]);
  s[n] = s[n] + 0.5f * (*smoth) * (vf[n] + sb[n] - 2.0f * s[n]);
  tb[n] = t[n];
  t[n] = uf[n];
  sb[n] = s[n];
  s[n] = vf[n];
}

}  // namespace

void ext_updeta_t_s__hip(real_t *t, real_t *tb, real_t *s, real_t *sb, real_t *uf, real_t *vf,
                         real_t *smoth) {
  launch(updeta_t_s_0, range3(0, im[0], 0, jm[0], 0, kb[0]), t, tb, s, sb, uf, vf, smoth,
         im[0], jm[0]);
  finish();
}

// Native CUDA reference of ext_smol_adif_ (src/pom2k_generated_affine_loops/pom2k_fun.c).
#include "pom2k_cuda.cuh"

namespace {

// Apply temperature and salinity mask:
__global__ void smol_adif_0(Range r, real_t *ff, const real_t *fsm, int im, int jm) {
  POM2K_INDEX(r, i, j, k);
  ff[ACC3(i, j, k)] *= fsm[ACC2(i, j)];
}

// Recalculate mass fluxes with antidiffusion velocity:
__global__ void smol_adif_1(Range r, real_t *xmassflux, const real_t *ff, const real_t *sw,
                            const real_t *aru, const real_t *dt, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  real_t udx, u2dt, mol;

  if ((ff[ACC3(i, j, k)] < 1.0e-9f) || (ff[ACC3(i - 1, j, k)] < 1.0e-9f)) {
    xmassflux[ACC3(i, j, k)] = 0.0f;
  } else {
    udx = fabs(xmassflux[ACC3(i, j, k)]);
    u2dt = dti2 * xmassflux[ACC3(i, j, k)] * xmassflux[ACC3(i, j, k)] * 2.0f /
           (aru[ACC2(i, j)] * (dt[ACC2(i - 1, j)] + dt[ACC2(i, j)]));
    mol = (ff[ACC3(i, j, k)] - ff[ACC3(i - 1, j, k)]) /
          (ff[ACC3(i - 1, j, k)] + ff[ACC3(i, j, k)] + 1.0e-14f);
    xmassflux[ACC3(i, j, k)] = (udx - u2dt) * mol * (*sw);

    if (fabs(udx) < fabs(u2dt)) {
      xmassflux[ACC3(i, j, k)] = 0.0f;
    }
  }
}

__global__ void smol_adif_2(Range r, real_t *ymassflux, const real_t *ff, const real_t *sw,
                            const real_t *arv, const real_t *dt, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  real_t vdy, v2dt, mol;

  if ((ff[ACC3(i, j, k)] < 1.0e-9f) || (ff[ACC3(i, j - 1, k)] < 1.0e-9f)) {
    ymassflux[ACC3(i, j, k)] = 0.0f;
  } else {
    vdy = fabs(ymassflux[ACC3(i, j, k)]);
    v2dt = dti2 * ymassflux[ACC3(i, j, k)] * ymassflux[ACC3(i, j, k)] * 2.0f /
           (arv[ACC2(i, j)] * (dt[ACC2(i, j - 1)] + dt[ACC2(i, j)]));
    mol = (ff[ACC3(i, j, k)] - ff[ACC3(i, j - 1, k)]) /
          (ff[ACC3(i, j - 1, k)] + ff[ACC3(i, j, k)] + 1.0e-14f);
    ymassflux[ACC3(i, j, k)] = (vdy - v2dt) * mol * (*sw);

    if (fabs(vdy) < fabs(v2dt)) {
      ymassflux[ACC3(i, j, k)] = 0.0f;
    }
  }
}

__global__ void smol_adif_3(Range r, real_t *zwflux, const real_t *ff, const real_t *sw,
                            const real_t *dt, const real_t *dzz, int im, int jm, real_t dti2) {
  POM2K_INDEX(r, i, j, k);
  real_t wdz, w2dt, mol;

  if ((ff[ACC3(i, j, k)] < 1.0e-9f) || (ff[ACC3(i, j, k - 1)] < 1.0e-9f)) {
    zwflux[ACC3(i, j, k)] = 0.0f;
  } else {
    wdz = fabs(zwflux[ACC3(i, j, k)]);
    w2dt = dti2 * zwflux[ACC3(i, j, k)] * zwflux[ACC3(i, j, k)] / (dzz[k - 1] * dt[ACC2(i, j)]);
    mol = (ff[ACC3(i, j, k - 1)] - ff[ACC3(i, j, k)]) /
          (ff[ACC3(i, j, k)] + ff[ACC3(i, j, k - 1)] + 1.0e-14f);
    zwflux[ACC3(i, j, k)] = (wdz - w2dt) * mol * (*sw);

    if (fabs(wdz) < fabs(w2dt)) {
      zwflux[ACC3(i, j, k)] = 0.0f;
    }
  }
}

}  // namespace

void ext_smol_adif__cuda(real_t *xmassflux, real_t *ymassflux, real_t *zwflux, real_t *ff,
                         real_t *sw, real_t *fsm, real_t *aru, real_t *arv, real_t *dt,
                         real_t *dzz) {
  launch(smol_adif_0, range3(0, im[0], 0, jm[0], 0, kb[0]), ff, fsm, im[0], jm[0]);
  launch(smol_adif_1, range3(1, im[0], 1, jmm1[0], 0, kbm1[0]), xmassflux, ff, sw, aru, dt,
         im[0], jm[0], dti2[0]);
  launch(smol_adif_2, range3(1, imm1[0], 1, jm[0], 0, kbm1[0]), ymassflux, ff, sw, arv, dt,
         im[0], jm[0], dti2[0]);
  launch(smol_adif_3, range3(1, imm1[0], 1, jmm1[0], 1, kbm1[0]), zwflux, ff, sw, dt, dzz,
         im[0], jm[0], dti2[0]);
  finish();
}

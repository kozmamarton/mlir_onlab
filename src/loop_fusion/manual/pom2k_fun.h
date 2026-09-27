#pragma once
#include "imports/pom2k_imports.c"

void ext_profu_transformed(real_t *h, real_t *etf, real_t *c, real_t *km, real_t *a, real_t *dz, real_t *dzz,
                real_t *ee, real_t *gg, real_t *wusurf, real_t *uf, real_t *tps, real_t *cbc,
                real_t *ub, real_t *vb, real_t *dum, real_t *wubot, real_t *dhloc)
{

  for (int j = 0; j < jm; j++)
  {
    for (int i = 0; i < im; i++)
    {
      if (j > 0 && i > 0) // fusion 1
      {
        dhloc[ACC2(i, j)] =
            (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) * 0.5f;
      }
      else
      {
        dhloc[ACC2(i, j)] = 1.0f;
      }
    }
  }

  /* ----- fusion 2 eliminated loop ------
                  ||||
                  ˇˇˇˇ
  for (int j = 1; j < jm; j++)
    {
      for (int i = 1; i < im; i++)
      {
          dhloc[ACC2(i, j)] =
              (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) * 0.5f;
      }
    }
  */
  for (int k = 0; k < kb; k++)
  {
    for (int j = 1; j < jm; j++)
    {
      for (int i = 1; i < im; i++)
      {
        c[ACC3(i, j, k)] = (km[ACC3(i, j, k)] + km[ACC3(i - 1, j, k)]) * 0.5f;
      }
    }
  }

  for (int k = 0; k < kbm2; k++)
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        a[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k + 1)] + umol) /
                           (dz[k] * dzz[k] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
      }
    }
  }
  for (int k = 1; k < kbm1; k++)
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        c[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k)] + umol) /
                           (dz[k] * dzz[k - 1] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
      }
    }
  }
  /* ----- fusion 2 eliminated loop ------
                   ||||
                   ˇˇˇˇ*/
  for (int j = 0; j < jm; j++)
  {
    for (int i = 0; i < im; i++)
    {
      ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
      gg[ACC3(i, j, 0)] =
          (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dhloc[ACC2(i, j)]) - uf[ACC3(i, j, 0)]) /
          (a[ACC3(i, j, 0)] - 1.0f);
    }
  }

  for (int k = 1; k < kbm2; k++)
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        /* if (k < 2) /// fusion 2
         {
           ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
           gg[ACC3(i, j, 0)] =
               (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dhloc[ACC2(i, j)]) - uf[ACC3(i, j, 0)]) /
               (a[ACC3(i, j, 0)] - 1.0f);
         }*/

        gg[ACC3(i, j, k)] =
            1.0f /
            (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
        ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
        gg[ACC3(i, j, k)] = (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - uf[ACC3(i, j, k)]) *
                            gg[ACC3(i, j, k)];
      }
    }
  }

  // kbm1 -> kbm1-1
  for (int j = 1; j < jmm1; j++)
  {
    for (int i = 1; i < imm1; i++)
    {
      tps[ACC2(i, j)] =
          0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
          sqrtf(ub[ACC3(i, j, kbm2)] * ub[ACC3(i, j, kbm2)] +
                (0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                          vb[ACC3(i - 1, j, kbm2)] + vb[ACC3(i - 1, j + 1, kbm2)])) *
                    (0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                              vb[ACC3(i - 1, j, kbm2)] + vb[ACC3(i - 1, j + 1, kbm2)])));
      uf[ACC3(i, j, kbm2)] =
          (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] - uf[ACC3(i, j, kbm2)]) /
          (tps[ACC2(i, j)] * (dti2) / (-dz[kbm2] * dhloc[ACC2(i, j)]) - 1.0f -
           (ee[ACC3(i, j, kbm2 - 1)] - 1.0f) * c[ACC3(i, j, kbm2)]);
      uf[ACC3(i, j, kbm2)] = uf[ACC3(i, j, kbm2)] * dum[ACC2(i, j)];
    }
  }

  // ki -> ki-1
  for (int k = kb - 3; k >= 0; k--)
  {
    for (int j = 1; j < jmm1; j++)
    {
      for (int i = 1; i < imm1; i++)
      {
        uf[ACC3(i, j, k)] =
            (ee[ACC3(i, j, k)] * uf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]) *
            dum[ACC2(i, j)];
      }
    }
  }
  // kbm1 -> kbm1-1
  for (int j = 1; j < jmm1; j++)
  {
    for (int i = 1; i < imm1; i++)
    {
      wubot[ACC2(i, j)] = -tps[ACC2(i, j)] * uf[ACC3(i, j, kbm2)];
    }
  }
}
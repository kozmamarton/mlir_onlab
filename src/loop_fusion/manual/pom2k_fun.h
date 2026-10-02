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

  /*for (int k = 0; k < kbm1; k++) //example of a bad loop fusion
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        if (k < kbm2){
          a[ACC3(i, j, k)] = -dti2 * (c[ACC3(i, j, k + 1)] + umol) /
                             (dz[k] * dzz[k] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
        }
        if (k > 0){
          c[ACC3(i, j, k)] = -dti2 * (c[ACC3(i, j, k)] + umol) /
                             (dz[k] * dzz[k - 1] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
        }

      }
    }
  }*/

  for (int k = 0; k < kbm2; k++)
  {
    for (int j = 1; j < jm; j++)
    {
      for (int i = 1; i < im; i++)
      {
        a[ACC3(i, j, k)] = -dti2 * (c[ACC3(i, j, k + 1)] + umol) /
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
  /*for (int j = 0; j < jm; j++)
 {
   for (int i = 0; i < im; i++)
   {
     ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
     gg[ACC3(i, j, 0)] =
         (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dhloc[ACC2(i, j)]) - uf[ACC3(i, j, 0)]) /
         (a[ACC3(i, j, 0)] - 1.0f);
   }
 }*/

  for (int k = 1; k < kbm2; k++)
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        if (k < 2) /// fusion 2
        {
          ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
          gg[ACC3(i, j, 0)] =
              (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dhloc[ACC2(i, j)]) - uf[ACC3(i, j, 0)]) /
              (a[ACC3(i, j, 0)] - 1.0f);
        }

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
  /*for (int j = 1; j < jmm1; j++)
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
  }*/

  // ki -> ki-1
  for (int k = kb - 3; k >= 0; k--)
  {
    for (int j = 1; j < jmm1; j++)
    {
      for (int i = 1; i < imm1; i++)
      {
        if (k > kb - 4)
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

void ext_advq_transformed(real_t *qb, real_t *q, real_t *qf, real_t *xflux, real_t *yflux, real_t *dt, /// should fuse ----
                          real_t *u, real_t *v, real_t *aam, real_t *h, real_t *dum, real_t *dx, real_t *dvm,
                          real_t *dy, real_t *w, real_t *dz, real_t *art, real_t *etb, real_t *etf)
{

  // Calculate horizontal advection.
  /*for (int k = 1; k < kbm1; k++)
  {
    for (int j = 1; j < jm; j++)
    {
      for (int i = 1; i < im; i++)
      {
        xflux[ACC3(i, j, k)] = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i - 1, j, k)]) *
                               (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                               (u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
        yflux[ACC3(i, j, k)] = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i, j - 1, k)]) *
                               (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                               (v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
      }
    }
  }*/

  // Calculate horizontal diffusion.
  for (int k = 1; k < kbm1; k++)
  {
    for (int j = 1; j < jm; j++)
    {
      for (int i = 1; i < im; i++)
      {
         xflux[ACC3(i, j, k)] = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i - 1, j, k)]) *
                               (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                               (u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
        yflux[ACC3(i, j, k)] = 0.125f * (q[ACC3(i, j, k)] + q[ACC3(i, j - 1, k)]) *
                               (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                               (v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
        // dum masks xflux over land (dum=0)!
        xflux[ACC3(i, j, k)] -= dum[ACC2(i, j)] * 0.25f *
                                (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)] +
                                 aam[ACC3(i, j, k - 1)] + aam[ACC3(i - 1, j, k - 1)]) *
                                (h[ACC2(i, j)] + h[ACC2(i - 1, j)]) *
                                (qb[ACC3(i, j, k)] - qb[ACC3(i - 1, j, k)]) /
                                (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);

        // dvm masks yflux over land (dvm=0)!
        yflux[ACC3(i, j, k)] -= dvm[ACC2(i, j)] * 0.25f *
                                (aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)] +
                                 aam[ACC3(i, j, k - 1)] + aam[ACC3(i, j - 1, k - 1)]) *
                                (h[ACC2(i, j)] + h[ACC2(i, j - 1)]) *
                                (qb[ACC3(i, j, k)] - qb[ACC3(i, j - 1, k)]) /
                                (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);

        xflux[ACC3(i, j, k)] *= 0.5f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]);
        yflux[ACC3(i, j, k)] *= 0.5f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]);
      }
    }
  }

  // Calculate vertical advection, add flux terms, then step forward in time.
  for (int k = 1; k < kbm1; k++)
  {
    for (int j = 1; j < jmm1; j++)
    {
      for (int i = 1; i < imm1; i++)
      {
        qf[ACC3(i, j, k)] = (w[ACC3(i, j, k - 1)] * q[ACC3(i, j, k - 1)] -
                             w[ACC3(i, j, k + 1)] * q[ACC3(i, j, k + 1)]) *
                                art[ACC2(i, j)] / (dz[k] + dz[k - 1]) +
                            xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                            yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)];
        qf[ACC3(i, j, k)] =
            ((h[ACC2(i, j)] + etb[ACC2(i, j)]) * art[ACC2(i, j)] * qb[ACC3(i, j, k)] -
             (dti2)*qf[ACC3(i, j, k)]) /
            ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
      }
    }
  }
}
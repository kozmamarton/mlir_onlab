#include "pom2k_c_header.h"

#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int im;
int jm;
int kb;
int imm1;
int jmm1;
int kbm1;
int kbm2;
int imm2;
int jmm2;

real_t alpha;
real_t dte;
real_t dte2;
real_t dti;
real_t dti2;
real_t grav;
real_t hmax;
real_t pi;
real_t ramp;
real_t rfe;
real_t rfn;
real_t rfs;
real_t rfw;
real_t rhoref;
real_t sbias;
real_t slmax;
real_t small;
real_t tbias;
real_t time2;
real_t tprni;
real_t umol;
real_t vmaxl;
real_t horcon;

real_t period;
real_t time0;
real_t time1;

const real_t kappa = 0.4f;    // von Karman's constant
const real_t z0b = .01f;      // Bottom roughness (metres)
const real_t cbcmin = .0025f; // Minimum bottom friction coeff.
const real_t cbcmax = 1.0f;   // Maximum bottom friction coeff.

const real_t r[5] = {0.58f, 0.62f, 0.67f, 0.77f, 0.78f};
const real_t ad1[5] = {0.35f, 0.6f, 1.0f, 1.5f, 1.4f};
const real_t ad2[5] = {23.0f, 20.0f, 17.0f, 14.0f, 7.9f};

int iint;
int iprint;
int iskp;
int jskp;
int kl1;
int kl2;
int mode;
int ntp;

void save_1d_array_fort(char* fname, real_t* data, int _im);
void save_2d_array_fort(char* fname, real_t* data, int _im, int _jm);
void save_3d_array_fort(char* fname, real_t* data, int _im, int _jm, int _kb);

void set_sizes_(int* _jm, int* _im, int* _kb)
{
    im = *_im;
    jm = *_jm;
    kb = *_kb;
    imm1 = imm1 - 1;
    jmm1 = jmm1 - 1;
    kbm1 = kb - 1;
    kbm2 = kb - 2;
    imm2 = im - 2;
    jmm2 = jm - 2;
    kbm2 = kb - 2;
}

void copy_real_constants_(real_t* _alpha, real_t* _dte, real_t* _dte2, real_t* _dti, real_t* _dti2,
                          real_t* _grav, real_t* _hmax, real_t* _kappa, real_t* _pi, real_t* _ramp,
                          real_t* _rfe, real_t* _rfn, real_t* _rfs, real_t* _rfw, real_t* _rhoref,
                          real_t* _sbias, real_t* _slmax, real_t* _small, real_t* _tbias,
                          real_t* _time, real_t* _tprni, real_t* _umol, real_t* _vmaxl,
                          real_t* _horcon)
{
    alpha = *_alpha;
    dte = *_dte;
    dte2 = *_dte2;
    dti = *_dti;
    dti2 = *_dti2;
    grav = *_grav;
    hmax = *_hmax;
    pi = *_pi;
    ramp = *_ramp;
    rfe = *_rfe;
    rfn = *_rfn;
    rfs = *_rfs;
    rfw = *_rfw;
    rhoref = *_rhoref;
    sbias = *_sbias;
    slmax = *_slmax;
    small = *_small;
    tbias = *_tbias;
    time2 = *_time;
    tprni = *_tprni;
    umol = *_umol;
    vmaxl = *_vmaxl;
    horcon = *_horcon;
}

void copy_int_constants_(int* _iint, int* _iprint, int* _iskp, int* _jskp, int* _kl1, int* _kl2,
                         int* _mode, int* _ntp)
{
    iint = *_iint;
    iprint = *_iprint;
    iskp = *_iskp;
    jskp = *_jskp;
    kl1 = *_kl1;
    kl2 = *_kl2;
    mode = *_mode;
    ntp = *_ntp;
}

void ext_depth_(real_t* z, real_t* zz, real_t* dz, real_t* dzz)
{
    real_t delz;
    int kdz[12] = {1, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512, 1024};
    z[0] = 0.0f;
    for (int k = 1; k < kl1; k++)
    {
        z[k] = z[k - 1] + (real_t)kdz[k - 1];
    }
    delz = z[kl1 - 1] - z[kl1 - 2];
    for (int k = kl1; k < kl2; k++)
    {
        z[k] = z[k - 1] + delz;
    }
    for (int k = kl2; k < kb; k++)
    {
        dz[k] = (real_t)kdz[kb - k - 1] * delz / (real_t)kdz[kb - kl2 - 1];
        z[k] = z[k - 1] + dz[k];
    }
    for (int k = 0; k < kb; k++)
    {
        z[k] = -z[k] / z[kb - 1];
    }
    for (int k = 0; k < kb - 1; k++)
    {
        zz[k] = 0.5f * (z[k] + z[k + 1]);
    }
    zz[kb - 1] = 2.0f * zz[kb - 2] - zz[kb - 3];
    for (int k = 0; k < kb - 1; k++)
    {
        dz[k] = z[k] - z[k + 1];
        dzz[k] = zz[k] - zz[k + 1];
    }
    dz[kb - 1] = 0.0f;
    dzz[kb - 1] = 0.0f;
    // printf("  k       z         zz         dz         dzz\n");
    // for (int k = 0; k < kb; k++) {
    //   printf("%5d,%20.10f,%20.10f,%20.10f,%20.10f\n", k+1, z[k], zz[k],
    //   dz[k], dzz[k]);
    // }
    // printf("\n");
}

void ext_areas_masks_(real_t* art, real_t* aru, real_t* arv, real_t* dum, real_t* dvm, real_t* fsm,
                      real_t* dx, real_t* dy, real_t* h)
{
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            art[ACC2(i, j)] = dx[ACC2(i, j)] * dy[ACC2(i, j)];
        }
    }
    // C
    // C     Calculate areas of "u" and "v" cells:
    // C
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            aru[ACC2(i, j)] = .25f * (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]) *
                              (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]);
            arv[ACC2(i, j)] = .25f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) *
                              (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);
        }
    }
    for (int j = 0; j < jm; j++)
    {
        aru[ACC2(0, j)] = aru[ACC2(1, j)];
        arv[ACC2(0, j)] = arv[ACC2(1, j)];
    }
    for (int i = 0; i < im; i++)
    {
        aru[ACC2(i, 0)] = aru[ACC2(i, 1)];
        arv[ACC2(i, 0)] = arv[ACC2(i, 1)];
    }
    // C
    // C     Initialise and set up free surface mask:
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            fsm[ACC2(i, j)] = 0.0f;
            dum[ACC2(i, j)] = 0.0f;
            dvm[ACC2(i, j)] = 0.0f;
            if (h[ACC2(i, j)] > 1.0f)
                fsm[ACC2(i, j)] = 1.0f;
        }
    }
    // C
    // C     Set up velocity masks:
    // C
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            dum[ACC2(i, j)] = fsm[ACC2(i, j)] * fsm[ACC2(i - 1, j)];
            dvm[ACC2(i, j)] = fsm[ACC2(i, j)] * fsm[ACC2(i, j - 1)];
        }
    }
}

void ext_slpmax_(real_t* fsm, real_t* h)
{
    real_t mean, del;
    for (int loop = 0; loop < 10; loop++)
    {
        // C
        // C     Sweep right:
        // C
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {

                if ((fsm[ACC2(i, j)] != 0.0f) && (fsm[ACC2(i + 1, j)] != 0.0f))
                {
                    if (fabs(h[ACC2(i + 1, j)] - h[ACC2(i, j)]) /
                            (h[ACC2(i, j)] + h[ACC2(i + 1, j)]) >=
                        slmax)
                    {
                        mean = (h[ACC2(i + 1, j)] + h[ACC2(i, j)]) / 2.0f;
                        del = copysignf(slmax, h[ACC2(i + 1, j)] - h[ACC2(i, j)]);
                        h[ACC2(i + 1, j)] = mean * (1.0f + del);
                        h[ACC2(i, j)] = mean * (1.0f - del);
                    }
                }
            }
            // C
            // C    Sweep left:
            // C
            for (int i = imm2; i > 0; i--)
            {
                if ((fsm[ACC2(i, j)] != 0.0f) && (fsm[ACC2(i + 1, j)] != 0.0f))
                {
                    if (fabs(h[ACC2(i + 1, j)] - h[ACC2(i, j)]) /
                            (h[ACC2(i, j)] + h[ACC2(i + 1, j)]) >=
                        slmax)
                    {
                        mean = (h[ACC2(i + 1, j)] + h[ACC2(i, j)]) / 2.0f;
                        del = copysignf(slmax, h[ACC2(i + 1, j)] - h[ACC2(i, j)]);
                        h[ACC2(i + 1, j)] = mean * (1.0f + del);
                        h[ACC2(i, j)] = mean * (1.0f - del);
                    }
                }
            }
        }
        // C
        // C   Sweep up:
        // C
        for (int i = 1; i < imm1; i++)
        {
            for (int j = 1; j < jmm1; j++)
            {
                if ((fsm[ACC2(i, j)] != 0.0f) && (fsm[ACC2(i, j + 1)] != 0.0f))
                {
                    if (fabs(h[ACC2(i, j + 1)] - h[ACC2(i, j)]) /
                            (h[ACC2(i, j)] + h[ACC2(i, j + 1)]) >=
                        slmax)
                    {
                        mean = (h[ACC2(i, j + 1)] + h[ACC2(i, j)]) / 2.0f;
                        del = copysignf(slmax, h[ACC2(i, j + 1)] - h[ACC2(i, j)]);
                        h[ACC2(i, j + 1)] = mean * (1.0f + del);
                        h[ACC2(i, j)] = mean * (1.0f - del);
                    }
                }
            }
            // C
            // C   Sweep down:
            // C
            for (int j = jmm2; j > 0; j--)
            {
                if ((fsm[ACC2(i, j)] != 0.0f) && (fsm[ACC2(i, j + 1)] != 0.0f))
                {
                    if (fabs(h[ACC2(i, j + 1)] - h[ACC2(i, j)]) /
                            (h[ACC2(i, j)] + h[ACC2(i, j + 1)]) >=
                        slmax)
                    {
                        mean = (h[ACC2(i, j + 1)] + h[ACC2(i, j)]) / 2.0f;
                        del = copysignf(slmax, h[ACC2(i, j + 1)] - h[ACC2(i, j)]);
                        h[ACC2(i, j + 1)] = mean * (1.0f + del);
                        h[ACC2(i, j)] = mean * (1.0f - del);
                    }
                }
            }
        }
    }
}

void ext_dens_(real_t* si, real_t* ti, real_t* rhoo, real_t* h, real_t* fsm, real_t* zz,
               real_t* tbias, real_t* sbias)
{
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                real_t cr, p, rhor, sr, tr, tr2, tr3, tr4;
                tr = ti[ACC3(i, j, k)] + *tbias;
                sr = si[ACC3(i, j, k)] + *sbias;
                tr2 = tr * tr;
                tr3 = tr2 * tr;
                tr4 = tr3 * tr;
                // C
                // C     Approximate pressure in units of bars:
                // C
                p = grav * rhoref * (-zz[k] * h[ACC2(i, j)]) * 1.e-5f;
                rhor = -0.157406f + 6.793952e-2f * tr - 9.095290e-3f * tr2 + 1.001685e-4f * tr3 -
                       1.120083e-6f * tr4 + 6.536332e-9f * tr4 * tr;
                rhor = rhor +
                       (0.824493f - 4.0899e-3f * tr + 7.6438e-5f * tr2 - 8.2467e-7f * tr3 +
                        5.3875e-9f * tr4) *
                           sr +
                       (-5.72466e-3f + 1.0227e-4f * tr - 1.6546e-6f * tr2) * powf(fabs(sr), 1.5f) +
                       4.8314e-4f * sr * sr;
                cr = 1449.1f + .0821f * p + 4.55f * tr - .045f * tr2 + 1.34f * (sr - 35.0f);
                rhor = rhor + 1.e5f * p / (cr * cr) * (1.0f - 2.0f * p / (cr * cr));
                rhoo[ACC3(i, j, k)] = rhor / rhoref * fsm[ACC2(i, j)];
            }
        }
    }
}

void ext_seamount_(real_t* dx, real_t* dy, real_t* cor, real_t* east_c, real_t* north_c,
                   real_t* east_e, real_t* north_e, real_t* east_u, real_t* north_u, real_t* east_v,
                   real_t* north_v, real_t* rot, real_t* h, real_t* art, real_t* aru, real_t* arv,
                   real_t* dum, real_t* dvm, real_t* fsm, real_t* tb, real_t* sb, real_t* tclim,
                   real_t* sclim, real_t* ub, real_t* uab, real_t* zz, real_t* elb, real_t* etb,
                   real_t* e_atmos, real_t* dt, real_t* aam2d, real_t* aam, real_t* rho,
                   real_t* tbias, real_t* sbias, real_t* rmean, real_t* uabw, real_t* uabe,
                   real_t* ele, real_t* elw, real_t* tbe, real_t* tbw, real_t* sbe, real_t* sbw,
                   real_t* tbn, real_t* tbs, real_t* sbn, real_t* sbs, real_t* _rfe, real_t* _rfn,
                   real_t* _rfs, real_t* _rfw)
{
    real_t delh, delx, elejmid, elwjmid, ra, vel;
    // C
    // C     Set delh > 1.0 for an island or delh < 1.0 for a seamount:
    // C
    delh = 0.9f;
    // C
    // C     Grid size:
    // C
    delx = 8000.0f;
    // C
    // C     Radius island or seamount:
    // C
    ra = 25000.0f;
    // C
    // C     Current velocity:
    // C
    vel = 0.2f;
    // C
    // C     Set up grid dimensions, areas of free surface cells, and
    // C     Coriolis parameter:
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            // C
            // C     For constant grid size:
            // C
            // C         dx(i,j)=delx
            // C         dy(i,j)=delx
            // C
            // C     For variable grid size:
            // C
            dx[ACC2(i, j)] = delx - delx * sinf(pi * (float)(i + 1) / (float)(im)) / 2.0f;
            dy[ACC2(i, j)] = delx - delx * sinf(pi * (float)(j + 1) / (float)(jm)) / 2.0f;
            cor[ACC2(i, j)] = 1.e-4f;
        }
    }
    // C
    // C     Calculate horizontal coordinates of grid points and rotation
    // C     angle.
    // C
    // C     NOTE that this is introduced solely for the benefit of any post-
    // C     processing software, and in order to conform with the requirements
    // C     of the NetCDF Climate and Forecast (CF) Metadata Conventions.
    // C
    // C     There are four horizontal coordinate systems, denoted by the
    // C     subscripts u, v, e and c ("u" is a u-point, "v" is a v-point,
    // C     "e" is an elevation point and "c" is a cell corner), as shown
    // C     below. In addition, "east_*" is an easting and "north_*" is a
    // C     northing. Hence the coordinates of the "u" points are given by
    // C     (east_u,north_u).
    // C
    // C     Also, if the centre point of the cell shown below is at
    // C     (east_e(i,j),north_e(i,j)), then (east_u(i,j),north_u(i,j)) are
    // C     the coordinates of the western of the two "u" points,
    // C     (east_v(i,j),north_v(i,j)) are the coordinates of the southern of
    // C     the two "v" points, and (east_c(i,j),north_c(i,j)) are the
    // C     coordinates of the southwestern corner point of the cell. The
    // C     southwest corner of the entire grid is at
    // C     (east_c(1,1),north_c(1,1)).
    // C
    // C                      |              |
    // C                    --c------v-------c--
    // C                      |              |
    // C                      |              |
    // C                      |              |
    // C                      |              |
    // C                      u      e       u
    // C                      |              |
    // C                      |              |
    // C                      |              |
    // C                      |              |
    // C                    --c------v-------c--
    // C                      |              |
    // C
    // C
    // C     NOTE that the following calculation of east_c and north_c only
    // C     works properly for a rectangular grid with east and north aligned
    // C     with i and j, respectively:
    // C
    for (int j = 0; j < jm; j++)
    {
        east_c[ACC2(1, j)] = 0.0f;
        for (int i = 1; i < im; i++)
        {
            east_c[ACC2(i, j)] = east_c[ACC2(i - 1, j)] + dx[ACC2(i - 1, j)];
        }
    }
    for (int i = 0; i < im; i++)
    {
        north_c[ACC2(i, 1)] = 0.0;
        for (int j = 1; j < jm; j++)
        {
            north_c[ACC2(i, j)] = north_c[ACC2(i, j - 1)] + dy[ACC2(i, j - 1)];
        }
    }
    // C
    // C     The following works properly for any grid:
    // C
    // C     Elevation points:
    // C
    for (int j = 0; j < jmm1; j++)
    {
        for (int i = 0; i < imm1; i++)
        {
            east_e[ACC2(i, j)] = (east_c[ACC2(i, j)] + east_c[ACC2(i + 1, j)] +
                                  east_c[ACC2(i, j + 1)] + east_c[ACC2(i + 1, j + 1)]) /
                                 4.0f;
            north_e[ACC2(i, j)] = (north_c[ACC2(i, j)] + north_c[ACC2(i + 1, j)] +
                                   north_c[ACC2(i, j + 1)] + north_c[ACC2(i + 1, j + 1)]) /
                                  4.0f;
        }
    }
    // C
    // C     Extrapolate ends:
    // C
    for (int i = 0; i < imm1; i++)
    {
        east_e[ACC2(i, jmm1)] = ((east_c[ACC2(i, jmm1)] + east_c[ACC2(i + 1, jmm1)]) * 3.0f -
                                 east_c[ACC2(i, jmm2)] - east_c[ACC2(i + 1, jmm2)]) /
                                4.0f;
        north_e[ACC2(i, jmm1)] = ((north_c[ACC2(i, jmm1)] + north_c[ACC2(i + 1, jmm1)]) * 3.0f -
                                  north_c[ACC2(i, jmm2)] - north_c[ACC2(i + 1, jmm2)]) /
                                 4.0f;
    }
    for (int j = 0; j < jmm1; j++)
    {
        east_e[ACC2(imm1, j)] = ((east_c[ACC2(imm1, j)] + east_c[ACC2(imm1, j + 1)]) * 3.0f -
                                 east_c[ACC2(imm2, j)] - east_c[ACC2(imm2, j + 1)]) /
                                4.0f;
        north_e[ACC2(imm1, j)] = ((north_c[ACC2(imm1, j)] + north_c[ACC2(imm1, j + 1)]) * 3.0f -
                                  north_c[ACC2(imm2, j)] - north_c[ACC2(imm2, j + 1)]) /
                                 4.0f;
    }
    east_e[ACC2(imm1, jmm1)] = east_e[ACC2(imm2, jmm1)] + east_e[ACC2(imm1, jmm2)] -
                               (east_e[ACC2(im - 3, jmm1)] + east_e[ACC2(imm1, jm - 3)]) / 2.0f;
    north_e[ACC2(imm1, jmm1)] = north_e[ACC2(imm2, jmm1)] + north_e[ACC2(imm1, jmm2)] -
                                (north_e[ACC2(im - 3, jmm1)] + north_e[ACC2(imm1, jm - 3)]) / 2.0f;
    // C
    // C     u-points:
    // C
    for (int j = 0; j < jmm1; j++)
    {
        for (int i = 0; i < im; i++)
        {
            east_u[ACC2(i, j)] = (east_c[ACC2(i, j)] + east_c[ACC2(i, j + 1)]) / 2.0f;
            north_u[ACC2(i, j)] = (north_c[ACC2(i, j)] + north_c[ACC2(i, j + 1)]) / 2.0f;
        }
    }
    // C
    // C     Extrapolate ends:
    // C
    for (int i = 0; i < im; i++)
    {
        east_u[ACC2(i, jmm1)] = (east_c[ACC2(i, jmm1)] * 3.0f - east_c[ACC2(i, jmm2)]) / 2.0f;
        north_u[ACC2(i, jmm1)] = (north_c[ACC2(i, jmm1)] * 3.0f - north_c[ACC2(i, jmm2)]) / 2.0f;
    }
    // C
    // C     v-points:
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < imm1; i++)
        {
            east_v[ACC2(i, j)] = (east_c[ACC2(i, j)] + east_c[ACC2(i + 1, j)]) / 2.0f;
            north_v[ACC2(i, j)] = (north_c[ACC2(i, j)] + north_c[ACC2(i + 1, j)]) / 2.0f;
        }
    }
    // C
    // C     Extrapolate ends:
    // C
    for (int j = 0; j < jm; j++)
    {
        east_v[ACC2(imm1, j)] = (east_c[ACC2(imm1, j)] * 3.0f - east_c[ACC2(imm2, j)]) / 2.0f;
        north_v[ACC2(imm1, j)] = (north_c[ACC2(imm1, j)] * 3.0f - north_c[ACC2(imm2, j)]) / 2.0f;
    }
    // C
    // C     rot is the angle (radians, anticlockwise) of the i-axis relative
    // C     to east, averaged to a cell centre:
    // C
    // C     (NOTE that the following calculation of rot only works properly
    // C     for this particular rectangular grid)
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            rot[ACC2(i, j)] = 0.0f;
        }
    }
    // C
    // C     Define depth:
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            h[ACC2(i, j)] =
                4500.0f *
                (1.0f -
                 delh * expf(-((east_c[ACC2(i, j)] - east_c[ACC2((im + 1) / 2 - 1, j)]) *
                                   (east_c[ACC2(i, j)] - east_c[ACC2((im + 1) / 2 - 1, j)]) +
                               (north_c[ACC2(i, j)] - north_c[ACC2(i, (jm + 1) / 2 - 1)]) *
                                   (north_c[ACC2(i, j)] - north_c[ACC2(i, (jm + 1) / 2 - 1)])) /
                             (ra * ra)));
            if (h[ACC2(i, j)] < 1.0f)
            {
                h[ACC2(i, j)] = 1.0f;
            }
        }
    }
    // C
    // C     Close the north and south boundaries to form a channel:
    // C
    for (int i = 0; i < im; i++)
    {
        h[ACC2(i, 0)] = 1.0f;
        h[ACC2(i, jmm1)] = 1.0f;
    }
    // C
    // C     Calculate areas and masks:
    // C
    ext_areas_masks_(art, aru, arv, dum, dvm, fsm, dx, dy, h);
    // C
    // C     Adjust bottom topography so that cell to cell variations
    // C     in h do not exceed parameter slmax:
    // C
    if (slmax < 1.0f)
    {
        ext_slpmax_(fsm, h);
    }
    // C
    // C     Set initial conditions:
    // C
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                tb[ACC3(i, j, k)] = 5.0f + 15.0f * expf(zz[k] * h[ACC2(i, j)] / 1000.0f) - *tbias;
                sb[ACC3(i, j, k)] = 35.0f - *sbias;
                tclim[ACC3(i, j, k)] = tb[ACC3(i, j, k)];
                sclim[ACC3(i, j, k)] = sb[ACC3(i, j, k)];
                ub[ACC3(i, j, k)] = vel * dum[ACC2(i, j)];
            }
        }
    }
    // C
    // C     Initialise uab and vab as necessary
    // C     (NOTE that these have already been initialised to zero in the
    // C     main program):
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            uab[ACC2(i, j)] = vel * dum[ACC2(i, j)];
        }
    }
    // C
    // C     Set surface boundary conditions, e_atmos, vflux, wusurf,
    // C     wvsurf, wtsurf, wssurf and swrad, as necessary
    // C     (NOTE:
    // C      1. These have all been initialised to zero in the main program.
    // C      2. The temperature and salinity of inflowing water must be
    // C         defined relative to tbias and sbias.):
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            // C     No conditions necessary for this problem
        }
    }
    // C
    // C     Initialise elb, etb, dt and aam2d:
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            elb[ACC2(i, j)] = -e_atmos[ACC2(i, j)];
            etb[ACC2(i, j)] = -e_atmos[ACC2(i, j)];
            dt[ACC2(i, j)] = h[ACC2(i, j)] - e_atmos[ACC2(i, j)];
            aam2d[ACC2(i, j)] = aam[ACC3(i, j, 0)];
        }
    }

    ext_dens_(sb, tb, rho, h, fsm, zz, tbias, sbias);
    // C
    // C     Generated horizontally averaged density field (in this
    // C     application, the initial condition for density is a function
    // C     of z (the vertical cartesian coordinate) -- when this is not
    // C     so, make sure that rmean has been area averaged BEFORE transfer
    // C     to sigma coordinates):
    // C
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                rmean[ACC3(i, j, k)] = rho[ACC3(i, j, k)];
            }
        }
    }
    // C
    // C     Set lateral boundary conditions, for use in subroutine bcond
    // C     (in the seamount problem, the east and west boundaries are open,
    // C     while the south and north boundaries are closed through the
    // C     specification of the masks fsm, dum and dvm):
    // C
    // rfe = 1.0f;
    // rfw = 1.0f;
    // rfn = 1.0f;
    // rfs = 1.0f;
    rfe = *_rfe = 1.0f; // initialize C and Fortran global scalar variable
    rfw = *_rfw = 1.0f;
    rfn = *_rfn = 1.0f;
    rfs = *_rfs = 1.0f;
    for (int j = 1; j < jmm1; j++)
    {
        uabw[j] = uab[ACC2(1, j)];
        uabe[j] = uab[ACC2(imm2, j)];
        // C
        // C     Set geostrophically conditioned elevations at the boundaries:
        // C
        ele[j] =
            ele[j - 1] - cor[ACC2(imm2, j)] * uab[ACC2(imm2, j)] / grav * dy[ACC2(imm2, j - 1)];
        elw[j] = elw[j - 1] - cor[ACC2(1, j)] * uab[ACC2(1, j)] / grav * dy[ACC2(1, j - 1)];
    }
    // C
    // C     Adjust boundary elevations so that they are zero in the middle
    // C     of the channel:
    // C
    elejmid = ele[jmm1 / 2 - 1];
    elwjmid = elw[jmm1 / 2 - 1];
    for (int j = 1; j < jmm1; j++)
    {
        ele[j] = (ele[j] - elejmid) * fsm[ACC2(imm1, j)];
        elw[j] = (elw[j] - elwjmid) * fsm[ACC2(1, j)];
    }
    // C
    // C     Set thermodynamic boundary conditions (for the seamount
    // C     problem, and other possible applications, lateral thermodynamic
    // C     boundary conditions are set equal to the initial conditions and
    // C     are held constant thereafter - users may, of course, create
    // C     variable boundary conditions):
    // C
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            tbe[ACC2DFULL(j, k, jm, kb)] = tb[ACC3(imm1, j, k)];
            tbw[ACC2DFULL(j, k, jm, kb)] = tb[ACC3(0, j, k)];
            sbe[ACC2DFULL(j, k, jm, kb)] = sb[ACC3(imm1, j, k)];
            sbw[ACC2DFULL(j, k, jm, kb)] = sb[ACC3(0, j, k)];
        }
        for (int i = 0; i < im; i++)
        {
            tbn[ACC2DFULL(i, k, im, kb)] = tb[ACC3(i, jmm1, k)];
            tbs[ACC2DFULL(i, k, im, kb)] = tb[ACC3(i, 0, k)];
            sbn[ACC2DFULL(i, k, im, kb)] = sb[ACC3(i, jmm1, k)];
            sbs[ACC2DFULL(i, k, im, kb)] = sb[ACC3(i, 0, k)];
        }
    }
}

void ext_init_cond_(real_t* _period, real_t* cor, real_t* _time0, real_t* _time, real_t* ua,
                    real_t* uab, real_t* va, real_t* vab, real_t* el, real_t* elb, real_t* et,
                    real_t* etb, real_t* etf, real_t* d, real_t* h, real_t* dt, real_t* vfluxf,
                    real_t* w, real_t* l, real_t* q2b, real_t* q2lb, real_t* kh, real_t* km,
                    real_t* kq, real_t* aam, real_t* q2, real_t* q2l, real_t* t, real_t* tb,
                    real_t* s, real_t* sb, real_t* u, real_t* ub, real_t* v, real_t* vb,
                    real_t* aam_init)
{
    // C
    // C     Inertial period for temporal filter:
    // C
    period = *_period = (2.0f * pi) / fabs(cor[ACC2(im / 2, jm / 2)]) / 86400.0f;
    // C
    // C     Initialise time:
    // C
    time0 = *_time0 = 0.0f;
    time1 = *_time = 0.0f;
    // C
    // C     Initial conditions:
    // C
    // C     NOTE that lateral thermodynamic boundary conditions are often set
    // C     equal to the initial conditions and are held constant thereafter.
    // C     Users can of course create variable boundary conditions.
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            ua[ACC2(i, j)] = uab[ACC2(i, j)];
            va[ACC2(i, j)] = vab[ACC2(i, j)];
            el[ACC2(i, j)] = elb[ACC2(i, j)];
            et[ACC2(i, j)] = etb[ACC2(i, j)];
            etf[ACC2(i, j)] = et[ACC2(i, j)];
            d[ACC2(i, j)] = h[ACC2(i, j)] + el[ACC2(i, j)];
            dt[ACC2(i, j)] = h[ACC2(i, j)] + et[ACC2(i, j)];
            w[ACC3(i, j, 0)] = vfluxf[ACC2(i, j)];
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                l[ACC3(i, j, k)] = 0.1f * dt[ACC2(i, j)];
                q2b[ACC3(i, j, k)] = small;
                q2lb[ACC3(i, j, k)] = l[ACC3(i, j, k)] * q2b[ACC3(i, j, k)];
                kh[ACC3(i, j, k)] = l[ACC3(i, j, k)] * sqrtf(q2b[ACC3(i, j, k)]);
                km[ACC3(i, j, k)] = kh[ACC3(i, j, k)];
                kq[ACC3(i, j, k)] = kh[ACC3(i, j, k)];
                aam[ACC3(i, j, k)] = *aam_init;
            }
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                q2[ACC3(i, j, k)] = q2b[ACC3(i, j, k)];
                q2l[ACC3(i, j, k)] = q2lb[ACC3(i, j, k)];
                t[ACC3(i, j, k)] = tb[ACC3(i, j, k)];
                s[ACC3(i, j, k)] = sb[ACC3(i, j, k)];
                u[ACC3(i, j, k)] = ub[ACC3(i, j, k)];
                v[ACC3(i, j, k)] = vb[ACC3(i, j, k)];
            }
        }
    }
}

void ext_baropg_(real_t* rho, real_t* rmean, real_t* drhox, real_t* drhoy, real_t* zz, real_t* dt,
                 real_t* dum, real_t* dvm, real_t* dx, real_t* dy, real_t* ramp)
{
    // C **********************************************************************
    // C *                                                                    *
    // C * FUNCTION    :  Calculates  baroclinic pressure gradient.           *
    // C *                                                                    *
    // C **********************************************************************
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                rho[ACC3(i, j, k)] = rho[ACC3(i, j, k)] - rmean[ACC3(i, j, k)];
            }
        }
    }
    // C
    // C     Calculate x-component of baroclinic pressure gradient:
    // C
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            drhox[ACC3(i, j, 0)] = 0.5f * grav * (-zz[0]) * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                                   (rho[ACC3(i, j, 0)] - rho[ACC3(i - 1, j, 0)]);
        }
    }

    // #warning loop carried dependency in K
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                drhox[ACC3(i, j, k)] =
                    drhox[ACC3(i, j, k - 1)] +
                    grav * 0.25f * (zz[k - 1] - zz[k]) * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                        (rho[ACC3(i, j, k)] - rho[ACC3(i - 1, j, k)] + rho[ACC3(i, j, k - 1)] -
                         rho[ACC3(i - 1, j, k - 1)]) +
                    grav * 0.25f * (zz[k - 1] + zz[k]) * (dt[ACC2(i, j)] - dt[ACC2(i - 1, j)]) *
                        (rho[ACC3(i, j, k)] + rho[ACC3(i - 1, j, k)] - rho[ACC3(i, j, k - 1)] -
                         rho[ACC3(i - 1, j, k - 1)]);
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                drhox[ACC3(i, j, k)] = 0.25f * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                                       drhox[ACC3(i, j, k)] * dum[ACC2(i, j)] *
                                       (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]);
            }
        }
    }
    // // C
    // // C     Calculate y-component of baroclinic pressure gradient:
    // // C
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            drhoy[ACC3(i, j, 0)] = 0.5f * grav * (-zz[0]) * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                                   (rho[ACC3(i, j, 0)] - rho[ACC3(i, j - 1, 0)]);
        }
    }
    // #warning loop carried dependency in K
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                drhoy[ACC3(i, j, k)] =
                    drhoy[ACC3(i, j, k - 1)] +
                    grav * 0.25f * (zz[k - 1] - zz[k]) * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                        (rho[ACC3(i, j, k)] - rho[ACC3(i, j - 1, k)] + rho[ACC3(i, j, k - 1)] -
                         rho[ACC3(i, j - 1, k - 1)]) +
                    grav * 0.25f * (zz[k - 1] + zz[k]) * (dt[ACC2(i, j)] - dt[ACC2(i, j - 1)]) *
                        (rho[ACC3(i, j, k)] + rho[ACC3(i, j - 1, k)] - rho[ACC3(i, j, k - 1)] -
                         rho[ACC3(i, j - 1, k - 1)]);
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                drhoy[ACC3(i, j, k)] = 0.25f * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                                       drhoy[ACC3(i, j, k)] * dvm[ACC2(i, j)] *
                                       (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]);
            }
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                drhox[ACC3(i, j, k)] = *ramp * drhox[ACC3(i, j, k)];
                drhoy[ACC3(i, j, k)] = *ramp * drhoy[ACC3(i, j, k)];
            }
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                rho[ACC3(i, j, k)] = rho[ACC3(i, j, k)] + rmean[ACC3(i, j, k)];
            }
        }
    }
}

void ext_init_cond2_(real_t* drx2d, real_t* dry2d, real_t* drhox, real_t* drhoy, real_t* dz,
                     real_t* cbc, real_t* zz, real_t* h, real_t* dx, real_t* dy, real_t* tps,
                     real_t* fsm)
{
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                drx2d[ACC2(i, j)] = drx2d[ACC2(i, j)] + drhox[ACC3(i, j, k)] * dz[k];
                dry2d[ACC2(i, j)] = dry2d[ACC2(i, j)] + drhoy[ACC3(i, j, k)] * dz[k];
            }
        }
    }
    // C
    // C     Calculate bottom friction coefficient:
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            cbc[ACC2(i, j)] = (kappa / logf((1.0f + zz[kbm2]) * h[ACC2(i, j)] / z0b)) *
                              (kappa / logf((1.0f + zz[kbm2]) * h[ACC2(i, j)] / z0b));
            cbc[ACC2(i, j)] = fmax(cbcmin, cbc[ACC2(i, j)]);
            // C
            // C     If the following is invoked, then it is probable that the
            // wrong C     choice of z0b or vertical spacing has been made:
            // C
            cbc[ACC2(i, j)] = fmin(cbcmax, cbc[ACC2(i, j)]);
        }
    }
    // C
    // C     Calculate external (2-D) CFL time step:
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            tps[ACC2(i, j)] = 0.5f /
                              sqrtf(1.0f / (dx[ACC2(i, j)] * dx[ACC2(i, j)]) +
                                    1.0f / (dy[ACC2(i, j)] * dy[ACC2(i, j)])) /
                              sqrtf(grav * (h[ACC2(i, j)] + small)) * fsm[ACC2(i, j)];
        }
    }
}

void ext_init_cond3_(real_t* d, real_t* dt, real_t* el, real_t* et, real_t* h, real_t* _time,
                     real_t* _time0)
{
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            d[ACC2(i, j)] = h[ACC2(i, j)] + el[ACC2(i, j)];
            dt[ACC2(i, j)] = h[ACC2(i, j)] + et[ACC2(i, j)];
        }
    }

    time1 = *_time = *_time0;
}

void ext_init_internal_(real_t* _time, real_t* _time0, int* iint, real_t* _period, real_t* _ramp,
                        int* lramp, int* iproblem, real_t* wusurf, real_t* wvsurf, real_t* dvm,
                        real_t* e_atmos, real_t* vfluxf, real_t* w, real_t* wtsurf, real_t* wssurf,
                        real_t* swrad, real_t* tbias, real_t* sbias, real_t* t, real_t* s)
{
    time1 = *_time = dti * (float)*iint / 86400.0f + *_time0;

    if (*lramp)
    {
        ramp = *_ramp = time1 / *_period;
        if (ramp > 1.0f)
        {
            ramp = *_ramp = 1.0f;
        }
    }
    else
    {
        ramp = *_ramp = 1.0f;
    }
    // C-----------------------------------------------------------------------
    // C
    // C     Set time dependent, surface and lateral boundary conditions.
    // C     The latter will be used in subroutine bcond. Users may
    // C     wish to create a subroutine to supply wusurf, wvsurf, wtsurf,
    // C     wssurf, swrad and vflux.
    // C
    // C     Introduce simple wind stress. Value is negative for westerly or
    // C     southerly winds. The following wind stress has been tapered
    // C     along the boundary to suppress numerically induced oscilations
    // C     near the boundary (Jamart and Ozer, J.G.R., 91, 10621-10631).
    // C     To make a healthy surface Ekman layer, it would be well to set
    // C     kl1=9.
    // C
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            real_t satm, tatm;
            if (*iproblem != 3)
            { // constant wind read in file2ic

                //            wusurf(i,j)=ramp*(1.e-4*cos(pi*(j-1)/jmm1))
                wusurf[ACC2(i, j)] = 1.0f * (1.e-4f * cosf(pi * (float)(j) / (float)jmm1)) * .25f *
                                     (dvm[ACC2(i, j + 1)] + dvm[ACC2(i - 1, j + 1)] +
                                      dvm[ACC2(i - 1, j)] + dvm[ACC2(i, j)]);
                // C --- no wind ----
                // c           wusurf(i,j)=0.0f
                wvsurf[ACC2(i, j)] = 0.0f;
            }
            e_atmos[ACC2(i, j)] = 0.0f;
            vfluxf[ACC2(i, j)] = 0.0f;
            // C
            // C     Set w(i,j,1)=vflux(i,j).ne.0 if one wishes non-zero flow
            // across C     the sea surface. See calculation of elf(i,j) below
            // and subroutines C     vertvl, advt1 (or advt2). If w(1,j,1)=0,
            // and, additionally, there C     is no net flow across lateral
            // boundaries, the basin volume will be C     constant; if also
            // vflux(i,j).ne.0, then, for example, the average C     salinity
            // will change and, unrealistically, so will total salt.
            // C
            w[ACC3(i, j, 0)] = vfluxf[ACC2(i, j)];
            // C
            // C     Set wtsurf to the sensible heat, the latent heat (which
            // involves C     only the evaporative component of vflux) and the
            // long wave C     radiation:
            // C
            wtsurf[ACC2(i, j)] = 0.0;
            // C
            // C     Set swrad to the short wave radiation:
            // C
            swrad[ACC2(i, j)] = 0.0;
            // C
            // C     To account for change in temperature of flow crossing the
            // sea C     surface (generally quite small compared to latent heat
            // effect)
            // C
            tatm = t[ACC3(i, j, 0)] + *tbias; // an approximation
            wtsurf[ACC2(i, j)] =
                wtsurf[ACC2(i, j)] + vfluxf[ACC2(i, j)] * (tatm - t[ACC3(i, j, 0)] - *tbias);
            // C
            // C     Set the salinity of water vapor/precipitation which
            // enters/leaves C     the atmosphere (or e.g., an ice cover)
            // C
            satm = 0.0f;
            wssurf[ACC2(i, j)] = vfluxf[ACC2(i, j)] * (satm - s[ACC3(i, j, 0)] - *sbias);
        }
    }
}

void ext_flux_update_(real_t* fluxua, real_t* fluxva, real_t* d, real_t* dy, real_t* dx, real_t* ua,
                      real_t* va)
{
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            fluxua[ACC2(i, j)] = 0.25f * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) *
                                 (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) * ua[ACC2(i, j)];
            fluxva[ACC2(i, j)] = 0.25f * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) *
                                 (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) * va[ACC2(i, j)];
        }
    }
}

void ext_elf_update_(real_t* elf, real_t* elb, real_t* fluxua, real_t* fluxva, real_t* art,
                     real_t* vfluxf)
{
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            elf[ACC2(i, j)] =
                elb[ACC2(i, j)] + dte2 * (-(fluxua[ACC2(i + 1, j)] - fluxua[ACC2(i, j)] +
                                            fluxva[ACC2(i, j + 1)] - fluxva[ACC2(i, j)]) /
                                              art[ACC2(i, j)] -
                                          vfluxf[ACC2(i, j)]);
        }
    }
}

void ext_bcond_1_(real_t* elf, real_t* fsm)
{
    for (int j = 0; j < jm; j++)
    {
        elf[ACC2(0, j)] = elf[ACC2(1, j)];
        elf[ACC2(imm1, j)] = elf[ACC2(imm2, j)];
    }

    for (int i = 0; i < im; i++)
    {
        elf[ACC2(i, 0)] = elf[ACC2(i, 1)];
        elf[ACC2(i, jmm1)] = elf[ACC2(i, jmm2)];
    }

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            elf[ACC2(i, j)] = elf[ACC2(i, j)] * fsm[ACC2(i, j)];
        }
    }
}

void ext_bcond_2_(real_t* uaf, real_t* vaf, real_t* uabe, real_t* uabw, real_t* vabn, real_t* vabs,
                  real_t* h, real_t* el, real_t* ele, real_t* elw, real_t* eln, real_t* els,
                  real_t* dum, real_t* dvm, real_t* ramp, real_t* rfe, real_t* rfw, real_t* rfn,
                  real_t* rfs)
{
    // C
    // C     External (2-D) velocity:
    // C
    for (int j = 1; j < jmm1; j++)
    {
        // C
        // C     East:
        // C
        uaf[ACC2(imm1, j)] =
            uabe[j] + *rfe * sqrtf(grav / h[ACC2(imm2, j)]) * (el[ACC2(imm2, j)] - ele[j]);

        uaf[ACC2(imm1, j)] = *ramp * uaf[ACC2(imm1, j)];
        vaf[ACC2(imm1, j)] = 0.0f;
        // C
        // C     West:
        // C
        uaf[ACC2(1, j)] = uabw[j] - *rfw * sqrtf(grav / h[ACC2(1, j)]) * (el[ACC2(1, j)] - elw[j]);
        uaf[ACC2(1, j)] = *ramp * uaf[ACC2(1, j)];
        uaf[ACC2(0, j)] = uaf[ACC2(1, j)];
        vaf[ACC2(0, j)] = 0.0f;
    }
    for (int i = 1; i < imm1; i++)
    {
        // C
        // C     North:
        // C
        vaf[ACC2(i, jmm1)] =
            vabn[i] + *rfn * sqrtf(grav / h[ACC2(i, jmm2)]) * (el[ACC2(i, jmm2)] - eln[i]);
        vaf[ACC2(i, jmm1)] = *ramp * vaf[ACC2(i, jmm1)];
        uaf[ACC2(i, jmm1)] = 0.0f;
        // C
        // C     South:
        // C
        vaf[ACC2(i, 1)] = vabs[i] - *rfs * sqrtf(grav / h[ACC2(i, 1)]) * (el[ACC2(i, 1)] - els[i]);
        vaf[ACC2(i, 1)] = *ramp * vaf[ACC2(i, 1)];
        vaf[ACC2(i, 0)] = vaf[ACC2(i, 1)];
        uaf[ACC2(i, 0)] = 0.0f;
    }
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            uaf[ACC2(i, j)] = uaf[ACC2(i, j)] * dum[ACC2(i, j)];
            vaf[ACC2(i, j)] = vaf[ACC2(i, j)] * dvm[ACC2(i, j)];
        }
    }
}
/*
C-----------------------------------------------------------------------
C
C     Internal (3-D) boundary conditions:
C
C     Velocity (radiation conditions; smoothing is used in the direction
C     tangential to the boundaries):
C
*/
void ext_bcond_3_(real_t* h, real_t* uf, real_t* u, real_t* vf, real_t* v, real_t* dum, real_t* dvm)
{
    /*
            do k=1,kbm1
              do j=2,jmm1
    */
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            // EAST
            /*
                        ga=sqrt(h(im,j)/hmax)
                        uf(im,j,k)=ga*(.25e0*u(imm1,j-1,k)+.5e0*u(imm1,j,k)
                 $                     +.25e0*u(imm1,j+1,k))
                 $                  +(1.e0-ga)*(.25e0*u(im,j-1,k)+.5e0*u(im,j,k)
                 $                    +.25e0*u(im,j+1,k))
                        vf(im,j,k)=0.e0
            */
            real_t ga;
            ga = sqrtf(h[ACC2(imm1, j)] / hmax);
            uf[ACC3(imm1, j, k)] =
                ga * (0.25f * u[ACC3(imm2, j - 1, k)] + 0.5f * u[ACC3(imm2, j, k)] +
                      0.25f * u[ACC3(imm2, j + 1, k)]) +
                (1.0f - ga) * (0.25f * u[ACC3(imm1, j - 1, k)] + 0.5f * u[ACC3(imm1, j, k)] +
                               0.25f * u[ACC3(imm1, j + 1, k)]);
            vf[ACC3(imm1, j, k)] = 0.0f;

            // WEST
            /*
                        ga=sqrt(h(1,j)/hmax)
                        uf(2,j,k)=ga*(.25e0*u(3,j-1,k)+.5e0*u(3,j,k)
                 $                    +.25e0*u(3,j+1,k))
                 $                 +(1.e0-ga)*(.25e0*u(2,j-1,k)+.5e0*u(2,j,k)
                 $                   +.25e0*u(2,j+1,k))
                        uf(1,j,k)=uf(2,j,k)
                        vf(1,j,k)=0.e0
                      end do
                    end do
            */
            ga = sqrtf(h[ACC2(0, j)] / hmax);
            uf[ACC3(1, j, k)] =
                ga * (0.25f * u[ACC3(2, j - 1, k)] + 0.5f * u[ACC3(2, j, k)] +
                      0.25f * u[ACC3(2, j + 1, k)]) +
                (1.0f - ga) * (0.25f * u[ACC3(1, j - 1, k)] + 0.5f * u[ACC3(1, j, k)] +
                               0.25f * u[ACC3(1, j + 1, k)]);
            uf[ACC3(0, j, k)] = uf[ACC3(1, j, k)];
            vf[ACC3(0, j, k)] = 0.0f;
        }
    }
    /*
            do k=1,kbm1
              do i=2,imm1
    */
    for (int k = 0; k < kbm1; k++)
    {
        for (int i = 1; i < imm1; i++)
        {
            // NORTH
            /*
                        ga=sqrt(h(i,jm)/hmax)
                        vf(i,jm,k)=ga*(.25e0*v(i-1,jmm1,k)+.5e0*v(i,jmm1,k)
                 $                     +.25e0*v(i+1,jmm1,k))
                 $                  +(1.e0-ga)*(.25e0*v(i-1,jm,k)+.5e0*v(i,jm,k)
                 $                    +.25e0*v(i+1,jm,k))
                        uf(i,jm,k)=0.e0
            */
            real_t ga;
            ga = sqrtf(h[ACC2(i, jmm1)] / hmax);
            vf[ACC3(i, jmm1, k)] =
                ga * (0.25f * v[ACC3(i - 1, jmm2, k)] + 0.5f * v[ACC3(i, jmm2, k)] +
                      0.25f * v[ACC3(i + 1, jmm2, k)]) +
                (1.0f - ga) * (0.25f * v[ACC3(i - 1, jmm1, k)] + 0.5f * v[ACC3(i, jmm1, k)] +
                               0.25f * v[ACC3(i + 1, jmm1, k)]);
            uf[ACC3(i, jmm1, k)] = 0.0f;
            // SOUTH
            /*
                        ga=sqrt(h(i,1)/hmax)
                        vf(i,2,k)=ga*(.25e0*v(i-1,3,k)+.5e0*v(i,3,k)
                 $                    +.25e0*v(i+1,3,k))
                 $                 +(1.e0-ga)*(.25e0*v(i-1,2,k)+.5e0*v(i,2,k)
                 $                   +.25e0*v(i+1,2,k))
                        vf(i,1,k)=vf(i,2,k)
                        uf(i,1,k)=0.e0
                      end do
                    end do
            */
            ga = sqrtf(h[ACC2(i, 0)] / hmax);
            vf[ACC3(i, 1, k)] =
                ga * (0.25f * v[ACC3(i - 1, 2, k)] + 0.5f * v[ACC3(i, 2, k)] +
                      0.25f * v[ACC3(i + 1, 2, k)]) +
                (1.0f - ga) * (0.25f * v[ACC3(i - 1, 1, k)] + 0.5f * v[ACC3(i, 1, k)] +
                               0.25f * v[ACC3(i + 1, 1, k)]);
            vf[ACC3(i, 0, k)] = vf[ACC3(i, 1, k)];
            uf[ACC3(i, 0, k)] = 0.0f;
        }
    }
    /*
            do k=1,kbm1
              do j=1,jm
                do i=1,im
                  uf(i,j,k)=uf(i,j,k)*dum(i,j)
                  vf(i,j,k)=vf(i,j,k)*dvm(i,j)
                end do
              end do
            end do
    */
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                uf[ACC3(i, j, k)] = uf[ACC3(i, j, k)] * dum[ACC2(i, j)];
                vf[ACC3(i, j, k)] = vf[ACC3(i, j, k)] * dvm[ACC2(i, j)];
            }
        }
    }
}

void ext_bcond_4_(real_t* uf, real_t* vf, real_t* dx, real_t* u, real_t* s, real_t* t, real_t* sbe,
                  real_t* tbe, real_t* zz, real_t* dt, real_t* tbw, real_t* sbw, real_t* dy,
                  real_t* tbn, real_t* sbn, real_t* tbs, real_t* sbs, real_t* v, real_t* w,
                  real_t* fsm)
{

    //     Temperature and salinity boundary conditions (using uf and vf,
    //     respectively):
    /*
            do k=1,kbm1
              do j=1,jm
    */
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            real_t u1;
            real_t wm;
            // EAST
            /*
                        u1=2.e0*u(im,j,k)*dti/(dx(im,j)+dx(imm1,j))
                        if(u1.le.0.e0) then
                          uf(im,j,k)=t(im,j,k)-u1*(tbe(j,k)-t(im,j,k))
                          vf(im,j,k)=s(im,j,k)-u1*(sbe(j,k)-s(im,j,k))
                        else
                          uf(im,j,k)=t(im,j,k)-u1*(t(im,j,k)-t(imm1,j,k))
                          vf(im,j,k)=s(im,j,k)-u1*(s(im,j,k)-s(imm1,j,k))
                          if(k.ne.1.and.k.ne.kbm1) then
                            wm=.5e0*(w(imm1,j,k)+w(imm1,j,k+1))*dti
                 $              /((zz(k-1)-zz(k+1))*dt(imm1,j))
                            uf(im,j,k)=uf(im,j,k)-wm*(t(imm1,j,k-1)-t(imm1,j,k+1))
                            vf(im,j,k)=vf(im,j,k)-wm*(s(imm1,j,k-1)-s(imm1,j,k+1))
                          endif
                        endif
            */
            u1 = 2.0f * u[ACC3(imm1, j, k)] * dti / (dx[ACC2(imm1, j)] + dx[ACC2(imm2, j)]);
            if (u1 <= 0.0f)
            {
                uf[ACC3(imm1, j, k)] =
                    t[ACC3(imm1, j, k)] - u1 * (tbe[ACC2DFULL(j, k, jm, kb)] - t[ACC3(imm1, j, k)]);
                vf[ACC3(imm1, j, k)] =
                    s[ACC3(imm1, j, k)] - u1 * (sbe[ACC2DFULL(j, k, jm, kb)] - s[ACC3(imm1, j, k)]);
            }
            else
            {
                uf[ACC3(imm1, j, k)] =
                    t[ACC3(imm1, j, k)] - u1 * (t[ACC3(imm1, j, k)] - t[ACC3(imm2, j, k)]);
                vf[ACC3(imm1, j, k)] =
                    s[ACC3(imm1, j, k)] - u1 * (s[ACC3(imm1, j, k)] - s[ACC3(imm2, j, k)]);
                if ((k != 0) && (k != (kbm2)))
                {
                    wm = 0.5f * (w[ACC3(imm2, j, k)] + w[ACC3(imm2, j, k + 1)]) * dti /
                         ((zz[k - 1] - zz[k + 1]) * dt[ACC2(imm2, j)]);
                    uf[ACC3(imm1, j, k)] = uf[ACC3(imm1, j, k)] -
                                           wm * (t[ACC3(imm2, j, k - 1)] - t[ACC3(imm2, j, k + 1)]);
                    vf[ACC3(imm1, j, k)] = vf[ACC3(imm1, j, k)] -
                                           wm * (s[ACC3(imm2, j, k - 1)] - s[ACC3(imm2, j, k + 1)]);
                }
            }
            // WEST
            /*
                        u1=2.e0*u(2,j,k)*dti/(dx(1,j)+dx(2,j))
                        if(u1.ge.0.e0) then
                          uf(1,j,k)=t(1,j,k)-u1*(t(1,j,k)-tbw(j,k))
                          vf(1,j,k)=s(1,j,k)-u1*(s(1,j,k)-sbw(j,k))
                        else
                          uf(1,j,k)=t(1,j,k)-u1*(t(2,j,k)-t(1,j,k))
                          vf(1,j,k)=s(1,j,k)-u1*(s(2,j,k)-s(1,j,k))
                          if(k.ne.1.and.k.ne.kbm1) then
                            wm=.5e0*(w(2,j,k)+w(2,j,k+1))*dti
                 $              /((zz(k-1)-zz(k+1))*dt(2,j))
                            uf(1,j,k)=uf(1,j,k)-wm*(t(2,j,k-1)-t(2,j,k+1))
                            vf(1,j,k)=vf(1,j,k)-wm*(s(2,j,k-1)-s(2,j,k+1))
                          endif
                        endif
                      end do
                    end do
            */
            u1 = 2.0f * u[ACC3(1, j, k)] * dti / (dx[ACC2(0, j)] + dx[ACC2(1, j)]);
            if (u1 >= 0.0f)
            {
                uf[ACC3(0, j, k)] =
                    t[ACC3(0, j, k)] - u1 * (t[ACC3(0, j, k)] - tbw[ACC2DFULL(j, k, jm, kb)]);
                vf[ACC3(0, j, k)] =
                    s[ACC3(0, j, k)] - u1 * (s[ACC3(0, j, k)] - sbw[ACC2DFULL(j, k, jm, kb)]);
            }
            else
            {
                uf[ACC3(0, j, k)] = t[ACC3(0, j, k)] - u1 * (t[ACC3(1, j, k)] - t[ACC3(0, j, k)]);
                vf[ACC3(0, j, k)] = s[ACC3(0, j, k)] - u1 * (s[ACC3(1, j, k)] - s[ACC3(0, j, k)]);
                if ((k != 0) && (k != (kbm2)))
                {
                    wm = 0.5f * (w[ACC3(1, j, k)] + w[ACC3(1, j, k + 1)]) * dti /
                         ((zz[k - 1] - zz[k + 1]) * dt[ACC2(1, j)]);
                    uf[ACC3(0, j, k)] =
                        uf[ACC3(0, j, k)] - wm * (t[ACC3(1, j, k - 1)] - t[ACC3(1, j, k + 1)]);
                    vf[ACC3(0, j, k)] =
                        vf[ACC3(0, j, k)] - wm * (s[ACC3(1, j, k - 1)] - s[ACC3(1, j, k + 1)]);
                }
            }
        }
    }
    /*
    C
            do k=1,kbm1
              do i=1,im
              */
    for (int k = 0; k < kbm1; k++)
    {
        for (int i = 0; i < im; i++)
        {
            real_t u1;
            real_t wm;
            // NORTH
            /*
                        u1=2.e0*v(i,jm,k)*dti/(dy(i,jm)+dy(i,jmm1))
                        if(u1.le.0.e0) then
                          uf(i,jm,k)=t(i,jm,k)-u1*(tbn(i,k)-t(i,jm,k))
                          vf(i,jm,k)=s(i,jm,k)-u1*(sbn(i,k)-s(i,jm,k))
                        else
                          uf(i,jm,k)=t(i,jm,k)-u1*(t(i,jm,k)-t(i,jmm1,k))
                          vf(i,jm,k)=s(i,jm,k)-u1*(s(i,jm,k)-s(i,jmm1,k))
                          if(k.ne.1.and.k.ne.kbm1) then
                            wm=.5e0*(w(i,jmm1,k)+w(i,jmm1,k+1))*dti
                 $              /((zz(k-1)-zz(k+1))*dt(i,jmm1))
                            uf(i,jm,k)=uf(i,jm,k)-wm*(t(i,jmm1,k-1)-t(i,jmm1,k+1))
                            vf(i,jm,k)=vf(i,jm,k)-wm*(s(i,jmm1,k-1)-s(i,jmm1,k+1))
                          endif
                        endif
            */
            u1 = 2.0f * v[ACC3(i, jmm1, k)] * dti / (dy[ACC2(i, jmm1)] + dy[ACC2(i, jmm2)]);
            if (u1 <= 0.0f)
            {
                uf[ACC3(i, jmm1, k)] =
                    t[ACC3(i, jmm1, k)] - u1 * (tbn[ACC2(i, k)] - t[ACC3(i, jmm1, k)]);
                vf[ACC3(i, jmm1, k)] =
                    s[ACC3(i, jmm1, k)] - u1 * (sbn[ACC2(i, k)] - s[ACC3(i, jmm1, k)]);
            }
            else
            {
                uf[ACC3(i, jmm1, k)] =
                    t[ACC3(i, jmm1, k)] - u1 * (t[ACC3(i, jmm1, k)] - t[ACC3(i, jmm2, k)]);
                vf[ACC3(i, jmm1, k)] =
                    s[ACC3(i, jmm1, k)] - u1 * (s[ACC3(i, jmm1, k)] - s[ACC3(i, jmm2, k)]);
                if ((k != 0) && (k != (kbm2)))
                {
                    wm = 0.5f * (w[ACC3(i, jmm2, k)] + w[ACC3(i, jmm2, k + 1)]) * dti /
                         ((zz[k - 1] - zz[k + 1]) * dt[ACC2(i, jmm2)]);
                    uf[ACC3(i, jmm1, k)] = uf[ACC3(i, jmm1, k)] -
                                           wm * (t[ACC3(i, jmm2, k - 1)] - t[ACC3(i, jmm2, k + 1)]);
                    vf[ACC3(i, jmm1, k)] = vf[ACC3(i, jmm1, k)] -
                                           wm * (s[ACC3(i, jmm2, k - 1)] - s[ACC3(i, jmm2, k + 1)]);
                }
            }
            // SOUTH
            /*
                        u1=2.e0*v(i,2,k)*dti/(dy(i,1)+dy(i,2))
                        if(u1.ge.0.e0) then
                          uf(i,1,k)=t(i,1,k)-u1*(t(i,1,k)-tbs(i,k))
                          vf(i,1,k)=s(i,1,k)-u1*(s(i,1,k)-sbs(i,k))
                        else
                          uf(i,1,k)=t(i,1,k)-u1*(t(i,2,k)-t(i,1,k))
                          vf(i,1,k)=s(i,1,k)-u1*(s(i,2,k)-s(i,1,k))
                          if(k.ne.1.and.k.ne.kbm1) then
                            wm=.5e0*(w(i,2,k)+w(i,2,k+1))*dti
                 $              /((zz(k-1)-zz(k+1))*dt(i,2))
                            uf(i,1,k)=uf(i,1,k)-wm*(t(i,2,k-1)-t(i,2,k+1))
                            vf(i,1,k)=vf(i,1,k)-wm*(s(i,2,k-1)-s(i,2,k+1))
                          endif
                        endif
                      end do
                    end do
            */
            u1 = 2.0f * v[ACC3(i, 1, k)] * dti / (dy[ACC2(i, 0)] + dy[ACC2(i, 1)]);
            if (u1 >= 0.0f)
            {
                uf[ACC3(i, 0, k)] = t[ACC3(i, 0, k)] - u1 * (t[ACC3(i, 0, k)] - tbs[ACC2(i, k)]);
                vf[ACC3(i, 0, k)] = s[ACC3(i, 0, k)] - u1 * (s[ACC3(i, 0, k)] - sbs[ACC2(i, k)]);
            }
            else
            {
                uf[ACC3(i, 0, k)] = t[ACC3(i, 0, k)] - u1 * (t[ACC3(i, 1, k)] - t[ACC3(i, 0, k)]);
                vf[ACC3(i, 0, k)] = s[ACC3(i, 0, k)] - u1 * (s[ACC3(i, 1, k)] - s[ACC3(i, 0, k)]);
                if ((k != 0) && (k != (kbm2)))
                {
                    wm = 0.5f * (w[ACC3(i, 1, k)] + w[ACC3(i, 1, k + 1)]) * dti /
                         ((zz[k - 1] - zz[k + 1]) * dt[ACC2(i, 1)]);
                    uf[ACC3(i, 0, k)] =
                        uf[ACC3(i, 0, k)] - wm * (t[ACC3(i, 1, k - 1)] - t[ACC3(i, 1, k + 1)]);
                    vf[ACC3(i, 0, k)] =
                        vf[ACC3(i, 0, k)] - wm * (s[ACC3(i, 1, k - 1)] - s[ACC3(i, 1, k + 1)]);
                }
            }
        }
    }

    /*
   do k=1,kbm1
     do j=1,jm
       do i=1,im
         uf(i,j,k)=uf(i,j,k)*fsm(i,j)
         vf(i,j,k)=vf(i,j,k)*fsm(i,j)
       end do
     end do
   end do
  C
   return*/
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                uf[ACC3(i, j, k)] = uf[ACC3(i, j, k)] * fsm[ACC2(i, j)];
                vf[ACC3(i, j, k)] = vf[ACC3(i, j, k)] * fsm[ACC2(i, j)];
            }
        }
    }
}
/////*****Calculate vertical velocity boundary conditions*****/////
/////
/////   real_t *w                 vertical velocity (m/s^-1) 3D array.
/////   real_t *fsm               Mask for scalar variables; = 0 over land; = 1
/// over water. 2D array.
/////
/////   boundary limits
/////   int kbm1                    vertical grid limit (kbm1=kb-1).
/////   int im, jm                  limits of horizontal grid
/////
/////********************************************************/////
void ext_bcond_5_(real_t* w, real_t* fsm)
{
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                // fsm masks w over land! (fsm=0)
                w[ACC3(i, j, k)] = w[ACC3(i, j, k)] * fsm[ACC2(i, j)];
            }
        }
    }
}

void ext_advave_(real_t* curv2d, real_t* advua, real_t* advva, real_t* fluxua, real_t* fluxva,
                 real_t* ua, real_t* va, real_t* uab, real_t* vab, real_t* wubot, real_t* wvbot,
                 real_t* d, real_t* dx, real_t* dy, real_t* aru, real_t* arv, real_t* aam2d,
                 real_t* tps, real_t* cbc)
{
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            advua[ACC2(i, j)] = 0.0f;
        }
    }

    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            fluxua[ACC2(i, j)] = .125f *
                                 ((d[ACC2(i + 1, j)] + d[ACC2(i, j)]) * ua[ACC2(i + 1, j)] +
                                  (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * ua[ACC2(i, j)]) *
                                 (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]);
        }
    }

    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            fluxva[ACC2(i, j)] =
                .125f *
                ((d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * va[ACC2(i, j)] +
                 (d[ACC2(i - 1, j)] + d[ACC2(i - 1, j - 1)]) * va[ACC2(i - 1, j)]) *
                (ua[ACC2(i, j)] + ua[ACC2(i, j - 1)]);
        }
    }

    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            fluxua[ACC2(i, j)] = fluxua[ACC2(i, j)] - d[ACC2(i, j)] * 2.0f * aam2d[ACC2(i, j)] *
                                                          (uab[ACC2(i + 1, j)] - uab[ACC2(i, j)]) /
                                                          dx[ACC2(i, j)];
        }
    }

    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            tps[ACC2(i, j)] =
                .25f *
                (d[ACC2(i, j)] + d[ACC2(i - 1, j)] + d[ACC2(i, j - 1)] + d[ACC2(i - 1, j - 1)]) *
                (aam2d[ACC2(i, j)] + aam2d[ACC2(i, j - 1)] + aam2d[ACC2(i - 1, j)] +
                 aam2d[ACC2(i - 1, j - 1)]) *
                ((uab[ACC2(i, j)] - uab[ACC2(i, j - 1)]) /
                     (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] +
                      dy[ACC2(i - 1, j - 1)]) +
                 (vab[ACC2(i, j)] - vab[ACC2(i - 1, j)]) /
                     (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] +
                      dx[ACC2(i - 1, j - 1)]));
            fluxua[ACC2(i, j)] = fluxua[ACC2(i, j)] * dy[ACC2(i, j)];
            fluxva[ACC2(i, j)] =
                (fluxva[ACC2(i, j)] - tps[ACC2(i, j)]) * .25f *
                (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] + dx[ACC2(i - 1, j - 1)]);
        }
    }

    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            advua[ACC2(i, j)] = fluxua[ACC2(i, j)] - fluxua[ACC2(i - 1, j)] +
                                fluxva[ACC2(i, j + 1)] - fluxva[ACC2(i, j)];
        }
    }

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            advva[ACC2(i, j)] = 0.0f;
        }
    }

    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            fluxua[ACC2(i, j)] =
                .125f *
                ((d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * ua[ACC2(i, j)] +
                 (d[ACC2(i, j - 1)] + d[ACC2(i - 1, j - 1)]) * ua[ACC2(i, j - 1)]) *
                (va[ACC2(i - 1, j)] + va[ACC2(i, j)]);
        }
    }

    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < im; i++)
        {
            fluxva[ACC2(i, j)] = .125f *
                                 ((d[ACC2(i, j + 1)] + d[ACC2(i, j)]) * va[ACC2(i, j + 1)] +
                                  (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * va[ACC2(i, j)]) *
                                 (va[ACC2(i, j + 1)] + va[ACC2(i, j)]);
        }
    }

    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < im; i++)
        {
            fluxva[ACC2(i, j)] = fluxva[ACC2(i, j)] - d[ACC2(i, j)] * 2.0f * aam2d[ACC2(i, j)] *
                                                          (vab[ACC2(i, j + 1)] - vab[ACC2(i, j)]) /
                                                          dy[ACC2(i, j)];
        }
    }

    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            fluxva[ACC2(i, j)] = fluxva[ACC2(i, j)] * dx[ACC2(i, j)];
            fluxua[ACC2(i, j)] =
                (fluxua[ACC2(i, j)] - tps[ACC2(i, j)]) * .25f *
                (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] + dy[ACC2(i - 1, j - 1)]);
        }
    }

    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            advva[ACC2(i, j)] = fluxua[ACC2(i + 1, j)] - fluxua[ACC2(i, j)] + fluxva[ACC2(i, j)] -
                                fluxva[ACC2(i, j - 1)];
        }
    }

    if (mode == 2)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                wubot[ACC2(i, j)] =
                    -0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
                    sqrtf(uab[ACC2(i, j)] * uab[ACC2(i, j)] +
                          (.25f * (vab[ACC2(i, j)] + vab[ACC2(i, j + 1)] + vab[ACC2(i - 1, j)] +
                                   vab[ACC2(i - 1, j + 1)])) *
                              (.25f * (vab[ACC2(i, j)] + vab[ACC2(i, j + 1)] + vab[ACC2(i - 1, j)] +
                                       vab[ACC2(i - 1, j + 1)]))) *
                    uab[ACC2(i, j)];
            }
        }

        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                wvbot[ACC2(i, j)] =
                    -0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i, j - 1)]) *
                    sqrtf(vab[ACC2(i, j)] * vab[ACC2(i, j)] +
                          (.25f * (uab[ACC2(i, j)] + uab[ACC2(i + 1, j)] + uab[ACC2(i, j - 1)] +
                                   uab[ACC2(i + 1, j - 1)])) *
                              (.25f * (uab[ACC2(i, j)] + uab[ACC2(i + 1, j)] + uab[ACC2(i, j - 1)] +
                                       uab[ACC2(i + 1, j - 1)]))) *
                    vab[ACC2(i, j)];
            }
        }

        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                curv2d[ACC2(i, j)] = .25f *
                                     ((va[ACC2(i, j + 1)] + va[ACC2(i, j)]) *
                                          (dy[ACC2(i + 1, j)] - dy[ACC2(i - 1, j)]) -
                                      (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) *
                                          (dx[ACC2(i, j + 1)] - dx[ACC2(i, j - 1)])) /
                                     (dx[ACC2(i, j)] * dy[ACC2(i, j)]);
            }
        }

        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 2; i < imm1; i++)
            {
                advua[ACC2(i, j)] =
                    advua[ACC2(i, j)] - aru[ACC2(i, j)] * .25f *
                                            (curv2d[ACC2(i, j)] * d[ACC2(i, j)] *
                                                 (va[ACC2(i, j + 1)] + va[ACC2(i, j)]) +
                                             curv2d[ACC2(i - 1, j)] * d[ACC2(i - 1, j)] *
                                                 (va[ACC2(i - 1, j + 1)] + va[ACC2(i - 1, j)]));
            }
        }

        for (int j = 2; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                advva[ACC2(i, j)] =
                    advva[ACC2(i, j)] + arv[ACC2(i, j)] * .25f *
                                            (curv2d[ACC2(i, j)] * d[ACC2(i, j)] *
                                                 (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) +
                                             curv2d[ACC2(i, j - 1)] * d[ACC2(i, j - 1)] *
                                                 (ua[ACC2(i + 1, j - 1)] + ua[ACC2(i, j - 1)]));
            }
        }
    }
}

void ext_uaf_(real_t* uaf, real_t* adx2d, real_t* advua, real_t* aru, real_t* cor, real_t* d,
              real_t* va, real_t* dy, real_t* el, real_t* elb, real_t* elf, real_t* e_atmos,
              real_t* drx2d, real_t* wusurf, real_t* wubot, real_t* h, real_t* uab)
{
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < im; i++)
        {
            uaf[ACC2(i, j)] =
                adx2d[ACC2(i, j)] + advua[ACC2(i, j)] -
                aru[ACC2(i, j)] * .25f *
                    (cor[ACC2(i, j)] * d[ACC2(i, j)] * (va[ACC2(i, j + 1)] + va[ACC2(i, j)]) +
                     cor[ACC2(i - 1, j)] * d[ACC2(i - 1, j)] *
                         (va[ACC2(i - 1, j + 1)] + va[ACC2(i - 1, j)])) +
                .25f * grav * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) *
                    (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) *
                    ((1.0f - 2.0f * alpha) * (el[ACC2(i, j)] - el[ACC2(i - 1, j)]) +
                     alpha * (elb[ACC2(i, j)] - elb[ACC2(i - 1, j)] + elf[ACC2(i, j)] -
                              elf[ACC2(i - 1, j)]) +
                     e_atmos[ACC2(i, j)] - e_atmos[ACC2(i - 1, j)]) +
                drx2d[ACC2(i, j)] + aru[ACC2(i, j)] * (wusurf[ACC2(i, j)] - wubot[ACC2(i, j)]);
        }
    }
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < im; i++)
        {
            uaf[ACC2(i, j)] =
                ((h[ACC2(i, j)] + elb[ACC2(i, j)] + h[ACC2(i - 1, j)] + elb[ACC2(i - 1, j)]) *
                     aru[ACC2(i, j)] * uab[ACC2(i, j)] -
                 4.0f * dte * uaf[ACC2(i, j)]) /
                ((h[ACC2(i, j)] + elf[ACC2(i, j)] + h[ACC2(i - 1, j)] + elf[ACC2(i - 1, j)]) *
                 aru[ACC2(i, j)]);
        }
    }
}

void ext_vaf_(real_t* vaf, real_t* ady2d, real_t* advva, real_t* arv, real_t* cor, real_t* d,
              real_t* ua, real_t* dx, real_t* el, real_t* elb, real_t* elf, real_t* e_atmos,
              real_t* dry2d, real_t* wvsurf, real_t* wvbot, real_t* h, real_t* vab)
{
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            vaf[ACC2(i, j)] =
                ady2d[ACC2(i, j)] + advva[ACC2(i, j)] +
                arv[ACC2(i, j)] * .25f *
                    (cor[ACC2(i, j)] * d[ACC2(i, j)] * (ua[ACC2(i + 1, j)] + ua[ACC2(i, j)]) +
                     cor[ACC2(i, j - 1)] * d[ACC2(i, j - 1)] *
                         (ua[ACC2(i + 1, j - 1)] + ua[ACC2(i, j - 1)])) +
                .25f * grav * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) *
                    (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) *
                    ((1.0f - 2.0f * alpha) * (el[ACC2(i, j)] - el[ACC2(i, j - 1)]) +
                     alpha * (elb[ACC2(i, j)] - elb[ACC2(i, j - 1)] + elf[ACC2(i, j)] -
                              elf[ACC2(i, j - 1)]) +
                     e_atmos[ACC2(i, j)] - e_atmos[ACC2(i, j - 1)]) +
                dry2d[ACC2(i, j)] + arv[ACC2(i, j)] * (wvsurf[ACC2(i, j)] - wvbot[ACC2(i, j)]);
        }
    }
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            vaf[ACC2(i, j)] =
                ((h[ACC2(i, j)] + elb[ACC2(i, j)] + h[ACC2(i, j - 1)] + elb[ACC2(i, j - 1)]) *
                     vab[ACC2(i, j)] * arv[ACC2(i, j)] -
                 4.0f * dte * vaf[ACC2(i, j)]) /
                ((h[ACC2(i, j)] + elf[ACC2(i, j)] + h[ACC2(i, j - 1)] + elf[ACC2(i, j - 1)]) *
                 arv[ACC2(i, j)]);
        }
    }
}

void ext_etf_(int* iext, int* isplit, real_t* smoth, real_t* etf, real_t* elf, real_t* fsm) {
    ext_etf_update_(iext, isplit, smoth, etf, elf, fsm);
}

void ext_etf_update_(int* iext, int* isplit, real_t* smoth, real_t* etf, real_t* elf, real_t* fsm)
{
    if (*iext == *isplit - 2)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                etf[ACC2(i, j)] = .25f * *smoth * elf[ACC2(i, j)];
            }
        }
    }
    else if (*iext == *isplit - 1)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                etf[ACC2(i, j)] = etf[ACC2(i, j)] + .5f * (1.0f - .5f * *smoth) * elf[ACC2(i, j)];
            }
        }
    }
    else if (*iext == *isplit)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                etf[ACC2(i, j)] = (etf[ACC2(i, j)] + .5f * elf[ACC2(i, j)]) * fsm[ACC2(i, j)];
            }
        }
    }
}

void ext_comp_vamax_(real_t* _vamax, real_t* vaf, int* _imax, int* _jmax)
{
    real_t vamax = 0.0f;
    real_t bla = *_vamax;
    int imax;
    int jmaxxx;
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            if (fabs(vaf[ACC2(i, j)] * bla) > vamax)
            {
                vamax = fabs(vaf[ACC2(i, j)]);
                imax = i;
                jmaxxx = j;
            }
        }
    }
    *_vamax = vamax;
    *_imax = imax;
    *_jmax = jmaxxx;
}

void ext_apply_filter_(real_t* vamax, real_t* vmaxl, real_t* smoth, int* iext, int* isplit,
                       real_t* ispi, real_t* isp2i, real_t* ua, real_t* uab, real_t* uaf,
                       real_t* va, real_t* vab, real_t* vaf, real_t* el, real_t* elb, real_t* elf,
                       real_t* d, real_t* h, real_t* egf, real_t* utf, real_t* vtf)
{
    if (*vamax < *vmaxl)
    {
        // C
        // C     Apply filter to remove time split and reset time sequence:
        // C
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                ua[ACC2(i, j)] =
                    ua[ACC2(i, j)] +
                    .5f * *smoth * (uab[ACC2(i, j)] - 2.0f * ua[ACC2(i, j)] + uaf[ACC2(i, j)]);
                va[ACC2(i, j)] =
                    va[ACC2(i, j)] +
                    .5f * *smoth * (vab[ACC2(i, j)] - 2.0f * va[ACC2(i, j)] + vaf[ACC2(i, j)]);
                el[ACC2(i, j)] =
                    el[ACC2(i, j)] +
                    .5f * *smoth * (elb[ACC2(i, j)] - 2.0f * el[ACC2(i, j)] + elf[ACC2(i, j)]);
                elb[ACC2(i, j)] = el[ACC2(i, j)];
                el[ACC2(i, j)] = elf[ACC2(i, j)];
                d[ACC2(i, j)] = h[ACC2(i, j)] + el[ACC2(i, j)];
                uab[ACC2(i, j)] = ua[ACC2(i, j)];
                ua[ACC2(i, j)] = uaf[ACC2(i, j)];
                vab[ACC2(i, j)] = va[ACC2(i, j)];
                va[ACC2(i, j)] = vaf[ACC2(i, j)];
            }
        }
        if (*iext != *isplit)
        {
            for (int j = 0; j < jm; j++)
            {
                for (int i = 0; i < im; i++)
                {
                    egf[ACC2(i, j)] = egf[ACC2(i, j)] + el[ACC2(i, j)] * *ispi;
                }
            }
            for (int j = 0; j < jm; j++)
            {
                for (int i = 1; i < im; i++)
                {
                    utf[ACC2(i, j)] = utf[ACC2(i, j)] +
                                      ua[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * *isp2i;
                }
            }
            for (int j = 1; j < jm; j++)
            {
                for (int i = 0; i < im; i++)
                {
                    vtf[ACC2(i, j)] = vtf[ACC2(i, j)] +
                                      va[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * *isp2i;
                }
            }
        }
    }
}

void ext_adjust_u_v_(real_t* tps, real_t* u, real_t* v, real_t* dz, real_t* utb, real_t* utf,
                     real_t* vtb, real_t* vtf, real_t* dt)
{
    // C
    // C     Adjust u(z) and v(z) such that depth average of (u,v) = (ua,va):
    // C
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            tps[ACC2(i, j)] = 0.0f;
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                tps[ACC2(i, j)] = tps[ACC2(i, j)] + u[ACC3(i, j, k)] * dz[k];
            }
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                u[ACC3(i, j, k)] =
                    (u[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                    (utb[ACC2(i, j)] + utf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]);
            }
        }
    }
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            tps[ACC2(i, j)] = 0.0f;
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                tps[ACC2(i, j)] = tps[ACC2(i, j)] + v[ACC3(i, j, k)] * dz[k];
            }
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                v[ACC3(i, j, k)] =
                    (v[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                    (vtb[ACC2(i, j)] + vtf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]);
            }
        }
    }
}

void ext_vertvl_(real_t* xflux, real_t* yflux, real_t* dx, real_t* dy, real_t* dt, real_t* u,
                 real_t* v, real_t* w, real_t* vfluxb, real_t* vfluxf, real_t* etf, real_t* etb,
                 real_t* dz, real_t* dti2)
{
    // C
    // C     Reestablish boundary conditions:
    // C
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xflux[ACC3(i, j, k)] = .25f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) *
                                       (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) * u[ACC3(i, j, k)];
            }
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                yflux[ACC3(i, j, k)] = .25f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) *
                                       (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) * v[ACC3(i, j, k)];
            }
        }
    }
    // C
    // C     NOTE that, if one wishes to include freshwater flux, the
    // C     surface velocity should be set to vflux(i,j). See also
    // C     change made to 2-D volume conservation equation which
    // C     calculates elf.
    // C
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            w[ACC3(i, j, 0)] = 0.5f * (vfluxb[ACC2(i, j)] + vfluxf[ACC2(i, j)]);
        }
    }

#warning loop carried dependency in K
    for (int k = 1; k < kb; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                w[ACC3(i, j, k)] =
                    w[ACC3(i, j, k - 1)] +
                    dz[k - 1] * ((xflux[ACC3(i + 1, j, k - 1)] - xflux[ACC3(i, j, k - 1)] +
                                  yflux[ACC3(i, j + 1, k - 1)] - yflux[ACC3(i, j, k - 1)]) /
                                     (dx[ACC2(i, j)] * dy[ACC2(i, j)]) +
                                 (etf[ACC2(i, j)] - etb[ACC2(i, j)]) / (*dti2));
            }
        }
    }
}

/////*****Initialize horizontal velocity vectors representing n+1 time
/// level.*****/////
/////
/////   real_t *uf               Horizontal velocity(u) at n+1 time level(m/s^-1
///). 3D array.
/////   real_t *vf               Horizontal velocity(v) at n+1 time level(m/s^-1
///). 3D array.
/////
/////   Note! uf and vf can be used as temporary variables, still representing
/// n+1 time level,
/////   for turbulence parameters(q2 and q2l), salinity, and potential
/// temperature.
/////
/////   boundary limits
/////   int kb                      vertical grid limit.
/////   int im, jm                  limits of horizontal grid
/////
/////*****************************************************************************/////
void ext_init_horizontal_velocities_(real_t* uf, real_t* vf)
{
    for (int k = 0; k < kb; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                uf[ACC3(i, j, k)] = 0.0f;
                vf[ACC3(i, j, k)] = 0.0f;
            }
        }
    }
}

/////*****Calculates horizontal advection and diffusion, and *****/////
/////*****vertical advection for turbulent quantities.       *****/////
/////
/////   real_t *qb                N-1 time level of q. (3D array)
/////   real_t *q                 The exact meaning depends on the call (3D
/// array in both cases)
/////                             q2:Twice the turbulence kinetic energy
///(m^2/s^-2) or
/////                             q2l: The turbulence length scale (m^3/s^-2)
/////   real_t *qf                N+1 time level of q. (3D array)
/////   real_t *xflux             Sum of advective and diffusive flux. (3D
/// array)
/////   real_t *yflux             Sum of advective and diffusive flux (3D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *u                 horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *v                 horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *aam               horizontal kinematic viscosity (m^2/s^-1) (3D
/// array)
/////   real_t *h                 bottom depth (m) (2D array)
/////   real_t *dum               Mask for the u component of velocity; = 0 over
/// land; = 1 over water. (2D array)
/////   real_t *dx                grid spacing x (m) (2D array)
/////   real_t *dvm               Mask for the v component of velocity; = 0 over
/// land; = 1 over water. (2D array)
/////   real_t *dy                grid spacing y (m) (2D array)
/////   real_t *w                 sigma coordinate vertical velocity (m/s^-1)
///(3D array)
/////   real_t *dz                grid spacing z (=z(k)-z(k-1) z is spanned
/// between 0 and 1) (1D array)
/////   real_t *art               cell areas of time (T) cells. (m^2) (2D array)
/////   real_t *etb               The surface elevation (backward in time) as
/// used in the internal mode and derived from EL (m) (2D array)
/////   real_t *etf               The surface elevation (forward in time) as
/// used in the internal mode and derived from EL (m) (2D array)
/////
/////   Used constants
/////   real_t dti2              Internal mode time stamp =dti*2 (s)
/////
/////   boundary limits
/////   int kbm1                    kbm1=kb-1.  vertical grid limit.
/////   int im, jm                  limits of horizontal grid
/////   int imm1, jmm1              imm1 = im-1, jmm1=jm-1. Limits of horizontal
/// grid in time step forward
/////
/////*****************************************************************************/////
void ext_advq_(real_t* qb, real_t* q, real_t* qf, real_t* xflux, real_t* yflux, real_t* dt, ///should fuse ----
               real_t* u, real_t* v, real_t* aam, real_t* h, real_t* dum, real_t* dx, real_t* dvm,
               real_t* dy, real_t* w, real_t* dz, real_t* art, real_t* etb, real_t* etf)
{

    // Calculate horizontal advection.
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
            }
        }
    }

    // Calculate horizontal diffusion.
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
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

void ext_profu_(real_t* h, real_t* etf, real_t* c, real_t* km, real_t* a, real_t* dz, real_t* dzz,
                real_t* ee, real_t* gg, real_t* wusurf, real_t* uf, real_t* tps, real_t* cbc,
                real_t* ub, real_t* vb, real_t* dum, real_t* wubot, real_t* dhloc)
{

    /*
  C
  C     The following section solves the equation:
  C
  C       dti2*(km*u')'-u=-ub
  C
        do j=1,jm
          do i=1,im
            dhloc(i,j)=1.e0
          end do
        end do
  */
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            dhloc[ACC2(i, j)] = 1.0f;
        }
    }
    /*
          do j=2,jm
            do i=2,im
              dhloc(i,j)=(h(i,j)+etf(i,j)+h(i-1,j)+etf(i-1,j))*.5e0
            end do
          end do
    */
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            dhloc[ACC2(i, j)] =
                (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) * 0.5f;
        }
    }
    /*
          do k=1,kb
            do j=2,jm
              do i=2,im
                c(i,j,k)=(km(i,j,k)+km(i-1,j,k))*.5e0
              end do
            end do
          end do
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
    /*
          do k=2,kbm1
            do j=1,jm
              do i=1,im
                a(i,j,k-1)=-dti2*(c(i,j,k)+umol)
         $                  /(dz(k-1)*dzz(k-1)*dhloc(i,j)*dhloc(i,j))
                c(i,j,k)=-dti2*(c(i,j,k)+umol)
         $                /(dz(k)*dzz(k-1)*dhloc(i,j)*dhloc(i,j))
              end do
            end do
          end do
    */
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
    /*
          do j=1,jm
            do i=1,im
              ee(i,j,1)=a(i,j,1)/(a(i,j,1)-1.e0)
              gg(i,j,1)=(-dti2*wusurf(i,j)/(-dz(1)*dhloc(i,j))
         $               -uf(i,j,1))
         $               /(a(i,j,1)-1.e0)
            end do
          end do
    */
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
    /*
          do k=2,kbm2
            do j=1,jm
              do i=1,im
                gg(i,j,k)=1.e0/(a(i,j,k)+c(i,j,k)*(1.e0-ee(i,j,k-1))-1.e0)
                ee(i,j,k)=a(i,j,k)*gg(i,j,k)
                gg(i,j,k)=(c(i,j,k)*gg(i,j,k-1)-uf(i,j,k))*gg(i,j,k)
              end do
            end do
          end do
    */
    for (int k = 1; k < kbm2; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                gg[ACC3(i, j, k)] =
                    1.0f /
                    (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
                ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
                gg[ACC3(i, j, k)] = (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - uf[ACC3(i, j, k)]) *
                                    gg[ACC3(i, j, k)];
            }
        }
    }
    /*
          do j=2,jmm1
            do i=2,imm1
              tps(i,j)=0.5e0*(cbc(i,j)+cbc(i-1,j))
         $              *sqrt(ub(i,j,kbm1)**2
         $                +(.25e0*(vb(i,j,kbm1)+vb(i,j+1,kbm1)
         $                         +vb(i-1,j,kbm1)+vb(i-1,j+1,kbm1)))**2)
              uf(i,j,kbm1)=(c(i,j,kbm1)*gg(i,j,kbm2)-uf(i,j,kbm1))
         $                  /(tps(i,j)*dti2/(-dz(kbm1)*dhloc(i,j))-1.e0
         $                    -(ee(i,j,kbm2)-1.e0)*c(i,j,kbm1))
              uf(i,j,kbm1)=uf(i,j,kbm1)*dum(i,j)
            end do
          end do
    */
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
    /*

          do k=2,kbm1
            ki=kb-k
            do j=2,jmm1
              do i=2,imm1
                uf(i,j,ki)=(ee(i,j,ki)*uf(i,j,ki+1)+gg(i,j,ki))*dum(i,j)
              end do
            end do
          end do
    */
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
    /*
          do j=2,jmm1
            do i=2,imm1
              wubot(i,j)=-tps(i,j)*uf(i,j,kbm1)
            end do
          end do
      */
    // kbm1 -> kbm1-1
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            wubot[ACC2(i, j)] = -tps[ACC2(i, j)] * uf[ACC3(i, j, kbm2)];
        }
    }
}

void ext_profv_(real_t* etf, real_t* h, real_t* c, real_t* km, real_t* a, real_t* dz, real_t* dzz,
                real_t* ee, real_t* gg, real_t* wvsurf, real_t* vf, real_t* tps, real_t* cbc,
                real_t* ub, real_t* vb, real_t* dvm, real_t* wvbot, real_t* dhloc)
{
    /*
  C **********************************************************************
  C                                                                      *
  C * FUNCTION    :  Solves for vertical diffusion of y-momentum using   *
  C *                method described by Richmeyer and Morton.           *
  C *                                                                    *
  C *                See:                                                *
  C *                                                                    *
  C *                Richtmeyer R.D., and K.W. Morton, 1967. Difference  *
  C *                  Methods for Initial-Value Problems, 2nd edition,  *
  C *                  Interscience, New York, 198-201.                  *
  C *                                                                    *
  C *                NOTE that wvsurf has the opposite sign to the wind  *
  C *                speed.                                              *
  C *                                                                    *
  C **********************************************************************
  C
  C     The following section solves the equation:
  C
  C       dti2*(km*u')'-u=-ub
  C

        do j=1,jm
          do i=1,im
            dhloc(i,j)=1.e0
          end do
        end do
  */
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            dhloc[ACC2(i, j)] = 1.0f;
        }
    }
    /*
          do j=2,jm
            do i=2,im
              dhloc(i,j)=.5e0*(h(i,j)+etf(i,j)+h(i,j-1)+etf(i,j-1))
            end do
          end do
    */
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            dhloc[ACC2(i, j)] =
                0.5f * (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i, j - 1)] + etf[ACC2(i, j - 1)]);
        }
    }
    /*
          do k=1,kb
            do j=2,jm
              do i=2,im
                c(i,j,k)=(km(i,j,k)+km(i,j-1,k))*.5e0
              end do
            end do
          end do
    */
    for (int k = 0; k < kb; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                c[ACC3(i, j, k)] = (km[ACC3(i, j, k)] + km[ACC3(i, j - 1, k)]) * 0.5f;
            }
        }
    }
    /*
          do k=2,kbm1
            do j=1,jm
              do i=1,im
                a(i,j,k-1)=-dti2*(c(i,j,k)+umol)
         $                  /(dz(k-1)*dzz(k-1)*dhloc(i,j)*dhloc(i,j))
                c(i,j,k)=-dti2*(c(i,j,k)+umol)
         $                /(dz(k)*dzz(k-1)*dhloc(i,j)*dhloc(i,j))
              end do
            end do
          end do
    */
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
    /*
          do j=1,jm
            do i=1,im
              ee(i,j,1)=a(i,j,1)/(a(i,j,1)-1.e0)
              gg(i,j,1)=(-dti2*wvsurf(i,j)/(-dz(1)*dhloc(i,j))-vf(i,j,1))
         $               /(a(i,j,1)-1.e0)
            end do
          end do
    */
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
            gg[ACC3(i, j, 0)] =
                (-dti2 * wvsurf[ACC2(i, j)] / (-(dz[0]) * dhloc[ACC2(i, j)]) - vf[ACC3(i, j, 0)]) /
                (a[ACC3(i, j, 0)] - 1.0f);
        }
    }
    /*
          do k=2,kbm2
            do j=1,jm
              do i=1,im
                gg(i,j,k)=1.e0/(a(i,j,k)+c(i,j,k)*(1.e0-ee(i,j,k-1))-1.e0)
                ee(i,j,k)=a(i,j,k)*gg(i,j,k)
                gg(i,j,k)=(c(i,j,k)*gg(i,j,k-1)-vf(i,j,k))*gg(i,j,k)
              end do
            end do
          end do
    */
    for (int k = 1; k < kbm2; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                gg[ACC3(i, j, k)] =
                    1.0f /
                    (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
                ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
                gg[ACC3(i, j, k)] = (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - vf[ACC3(i, j, k)]) *
                                    gg[ACC3(i, j, k)];
            }
        }
    }
    /*
          do j=2,jmm1
            do i=2,imm1
              tps(i,j)=0.5e0*(cbc(i,j)+cbc(i,j-1))
         $              *sqrt((.25e0*(ub(i,j,kbm1)+ub(i+1,j,kbm1)
         $                            +ub(i,j-1,kbm1)+ub(i+1,j-1,kbm1)))**2
         $                    +vb(i,j,kbm1)**2)
              vf(i,j,kbm1)=(c(i,j,kbm1)*gg(i,j,kbm2)-vf(i,j,kbm1))
         $                  /(tps(i,j)*dti2/(-dz(kbm1)*dhloc(i,j))-1.e0
         $                    -(ee(i,j,kbm2)-1.e0)*c(i,j,kbm1))
              vf(i,j,kbm1)=vf(i,j,kbm1)*dvm(i,j)
            end do
          end do
    */
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            tps[ACC2(i, j)] =
                0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i, j - 1)]) *
                sqrtf((0.25f * (ub[ACC3(i, j, kbm2)] + ub[ACC3(i + 1, j, kbm2)] +
                                ub[ACC3(i, j - 1, kbm2)] + ub[ACC3(i + 1, j - 1, kbm2)])) *
                          (0.25f * (ub[ACC3(i, j, kbm2)] + ub[ACC3(i + 1, j, kbm2)] +
                                    ub[ACC3(i, j - 1, kbm2)] + ub[ACC3(i + 1, j - 1, kbm2)])) +
                      vb[ACC3(i, j, kbm2)] * vb[ACC3(i, j, kbm2)]);
            vf[ACC3(i, j, kbm2)] =
                (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] - vf[ACC3(i, j, kbm2)]) /
                (tps[ACC2(i, j)] * dti2 / (-(dz[kbm2]) * dhloc[ACC2(i, j)]) - 1.0f -
                 (ee[ACC3(i, j, kbm2 - 1)] - 1.0f) * c[ACC3(i, j, kbm2)]);
            vf[ACC3(i, j, kbm2)] = vf[ACC3(i, j, kbm2)] * dvm[ACC2(i, j)];
        }
    }
    /*
          do k=2,kbm1
            ki=kb-k
            do j=2,jmm1
              do i=2,imm1
                vf(i,j,ki)=(ee(i,j,ki)*vf(i,j,ki+1)+gg(i,j,ki))*dvm(i,j)
              end do
            end do
          end do
    */

    for (int k = kb - 3; k >= 0; k--)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                vf[ACC3(i, j, k)] =
                    (ee[ACC3(i, j, k)] * vf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]) *
                    dvm[ACC2(i, j)];
            }
        }
    }
    /*
          do j=2,jmm1
            do i=2,imm1
              wvbot(i,j)=-tps(i,j)*vf(i,j,kbm1)
            end do
          end do
    */
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            wvbot[ACC2(i, j)] = -tps[ACC2(i, j)] * vf[ACC3(i, j, kbm2)];
        }
    }
}
/////***** Calculates the horizontal portions of momentum      *****/////
/////***** advection well in advance of their use in advu and  *****/////
/////***** advv so that their vertical integrals (created in   *****/////
/////***** he main program) may be used in the external (2-D)  *****/////
/////***** mode calculation.                                   *****/////
/////
/////   real_t *xflux             Sum of advective and diffusive flux. (3D
/// array)
/////   real_t *yflux             Sum of advective and diffusive flux (3D array)
/////   real_t *curv              curvature terms; see user doc equation (28)
///(3D array)
/////   real_t *advx              the horizontal advection (including curvature
/// terms) and the diffusion terms. (3D array)
/////   real_t *advy              the horizontal advection (including curvature
/// terms) and the diffusion terms (3D array)
/////   real_t *u                 horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *v                 horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *dx                grid spacing x (m) (2D array)
/////   real_t *dy                grid spacing y (m) (2D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *aam               horizontal kinematic viscosity (m^2/s^-1) (3D
/// array)
/////   real_t *ub                horizontal velocity backward in time.(U)
///(m/s^-1) (3D array)
/////   real_t *vb                horizontal velocity backward in time.(V)
///(m/s^-1) (3D array)
/////   real_t *aru               cell areas centered on the variable U (m^2)
///(2D array)
/////   real_t *arv               cell areas centered on the variable V (m^2)
///(2D array)
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int im, jm                limits of horizontal grid
/////   int kbm1                  kbm1=kb-1.
/////   int imm1, jmm1            imm1 = im-1, jmm1=jm-1.
/////
/////*****************************************************************************/////
void ext_advct_(real_t* xflux, real_t* yflux, real_t* curv, real_t* advx, real_t* advy, real_t* u,
                real_t* v, real_t* dx, real_t* dy, real_t* dt, real_t* aam, real_t* ub, real_t* vb,
                real_t* aru, real_t* arv)
{

    ///// ---------------------------- Calculate advx -----------------------
    /////////

    // Init variables.
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                curv[ACC3(i, j, k)] = 0.0f;
                advx[ACC3(i, j, k)] = 0.0f;
                xflux[ACC3(i, j, k)] = 0.0f;
                yflux[ACC3(i, j, k)] = 0.0f;
            }
        }
    }

    // Calculate curvature terms
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                curv[ACC3(i, j, k)] = 0.25f *
                                      ((v[ACC3(i, j + 1, k)] + v[ACC3(i, j, k)]) *
                                           (dy[ACC2(i + 1, j)] - dy[ACC2(i - 1, j)]) -
                                       (u[ACC3(i + 1, j, k)] + u[ACC3(i, j, k)]) *
                                           (dx[ACC2(i, j + 1)] - dx[ACC2(i, j - 1)])) /
                                      (dx[ACC2(i, j)] * dy[ACC2(i, j)]);
            }
        }
    }

    // Calculate horizontal advective fluxes:

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                xflux[ACC3(i, j, k)] =
                    0.125f *
                    ((dt[ACC2(i + 1, j)] + dt[ACC2(i, j)]) * u[ACC3(i + 1, j, k)] +
                     (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) * u[ACC3(i, j, k)]) *
                    (u[ACC3(i + 1, j, k)] + u[ACC3(i, j, k)]);
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                yflux[ACC3(i, j, k)] =
                    0.125f *
                    ((dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) * v[ACC3(i, j, k)] +
                     (dt[ACC2(i - 1, j)] + dt[ACC2(i - 1, j - 1)]) * v[ACC3(i - 1, j, k)]) *
                    (u[ACC3(i, j, k)] + u[ACC3(i, j - 1, k)]);
            }
        }
    }

    // Add horizontal diffusive fluxes:

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                xflux[ACC3(i, j, k)] -= dt[ACC2(i, j)] * aam[ACC3(i, j, k)] * 2.0f *
                                        (ub[ACC3(i + 1, j, k)] - ub[ACC3(i, j, k)]) /
                                        dx[ACC2(i, j)];

                real_t dtaam = 0.25f *
                               (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)] + dt[ACC2(i, j - 1)] +
                                dt[ACC2(i - 1, j - 1)]) *
                               (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)] +
                                aam[ACC3(i, j - 1, k)] + aam[ACC3(i - 1, j - 1, k)]);

                yflux[ACC3(i, j, k)] -=
                    (dtaam * ((ub[ACC3(i, j, k)] - ub[ACC3(i, j - 1, k)]) /
                                  (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] +
                                   dy[ACC2(i - 1, j - 1)]) +
                              (vb[ACC3(i, j, k)] - vb[ACC3(i - 1, j, k)]) /
                                  (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] +
                                   dx[ACC2(i - 1, j - 1)])));

                xflux[ACC3(i, j, k)] = dy[ACC2(i, j)] * xflux[ACC3(i, j, k)];
                yflux[ACC3(i, j, k)] = 0.25f *
                                       (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] +
                                        dx[ACC2(i - 1, j - 1)]) *
                                       yflux[ACC3(i, j, k)];
            }
        }
    }

    // Do horizontal advection:

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                advx[ACC3(i, j, k)] = xflux[ACC3(i, j, k)] - xflux[ACC3(i - 1, j, k)] +
                                      yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)];
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 2; i < imm1; i++)
            {
                advx[ACC3(i, j, k)] -= (aru[ACC2(i, j)] * 0.25f *
                                        (curv[ACC3(i, j, k)] * dt[ACC2(i, j)] *
                                             (v[ACC3(i, j + 1, k)] + v[ACC3(i, j, k)]) +
                                         curv[ACC3(i - 1, j, k)] * dt[ACC2(i - 1, j)] *
                                             (v[ACC3(i - 1, j + 1, k)] + v[ACC3(i - 1, j, k)])));
            }
        }
    }

    ///// ---------------------------- Calculate advy -----------------------
    /////////

    // Init variables.
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                advy[ACC3(i, j, k)] = 0.0f;
                xflux[ACC3(i, j, k)] = 0.0f;
                yflux[ACC3(i, j, k)] = 0.0f;
            }
        }
    }

    // Calculate horizontal advective fluxes:

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xflux[ACC3(i, j, k)] =
                    0.125f *
                    ((dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) * u[ACC3(i, j, k)] +
                     (dt[ACC2(i, j - 1)] + dt[ACC2(i - 1, j - 1)]) * u[ACC3(i, j - 1, k)]) *
                    (v[ACC3(i, j, k)] + v[ACC3(i - 1, j, k)]);
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 0; i < im; i++)
            {
                yflux[ACC3(i, j, k)] =
                    0.125f *
                    ((dt[ACC2(i, j + 1)] + dt[ACC2(i, j)]) * v[ACC3(i, j + 1, k)] +
                     (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) * v[ACC3(i, j, k)]) *
                    (v[ACC3(i, j + 1, k)] + v[ACC3(i, j, k)]);
            }
        }
    }

    // Add horizontal diffusive fluxes:

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < im; i++)
            {
                real_t dtaam = 0.25f *
                               (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)] + dt[ACC2(i, j - 1)] +
                                dt[ACC2(i - 1, j - 1)]) *
                               (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)] +
                                aam[ACC3(i, j - 1, k)] + aam[ACC3(i - 1, j - 1, k)]);

                xflux[ACC3(i, j, k)] -=
                    (dtaam * ((ub[ACC3(i, j, k)] - ub[ACC3(i, j - 1, k)]) /
                                  (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] +
                                   dy[ACC2(i - 1, j - 1)]) +
                              (vb[ACC3(i, j, k)] - vb[ACC3(i - 1, j, k)]) /
                                  (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)] + dx[ACC2(i, j - 1)] +
                                   dx[ACC2(i - 1, j - 1)])));

                yflux[ACC3(i, j, k)] -= dt[ACC2(i, j)] * aam[ACC3(i, j, k)] * 2.0f *
                                        (vb[ACC3(i, j + 1, k)] - vb[ACC3(i, j, k)]) /
                                        dy[ACC2(i, j)];

                xflux[ACC3(i, j, k)] = 0.25f *
                                       (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)] + dy[ACC2(i, j - 1)] +
                                        dy[ACC2(i - 1, j - 1)]) *
                                       xflux[ACC3(i, j, k)];
                yflux[ACC3(i, j, k)] = dx[ACC2(i, j)] * yflux[ACC3(i, j, k)];
            }
        }
    }

    // Do horizontal advection:

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                advy[ACC3(i, j, k)] = xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                                      yflux[ACC3(i, j, k)] - yflux[ACC3(i, j - 1, k)];
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 2; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                advy[ACC3(i, j, k)] += (arv[ACC2(i, j)] * 0.25f *
                                        (curv[ACC3(i, j, k)] * dt[ACC2(i, j)] *
                                             (u[ACC3(i + 1, j, k)] + u[ACC3(i, j, k)]) +
                                         curv[ACC3(i, j - 1, k)] * dt[ACC2(i, j - 1)] *
                                             (u[ACC3(i + 1, j - 1, k)] + u[ACC3(i, j - 1, k)])));
            }
        }
    }
}

/////***** Calculate the horizontal horizontal kinematic viscosity. *****/////
/////
/////   real_t *aam               horizontal kinematic viscosity (m^2*s^(-1))
///(3D array)
/////   real_t *u                 horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *v                 horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *dx                grid spacing x (m) (2D array)
/////   real_t *dy                grid spacing y (m) (2D array)
/////
/////   Used constants
/////   real_t horcon             Smagorinsky diffusivity coeff.
/////
/////   boundary limits
/////   int kbm1                  kbm1=kb-1. kb is the vertical grid limit.
/////   int imm1, jmm1            imm1 = im-1, jmm1=jm-1. im and jm are the
/// limits of horizontal grid.
/////
/////*****************************************************************************/////
void ext_aam_(real_t* aam, real_t* dx, real_t* dy, real_t* u, real_t* v)
{
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                aam[ACC3(i, j, k)] =
                    horcon * dx[ACC2(i, j)] * dy[ACC2(i, j)] *
                    sqrtf(((u[ACC3(i + 1, j, k)] - u[ACC3(i, j, k)]) / dx[ACC2(i, j)]) *
                              ((u[ACC3(i + 1, j, k)] - u[ACC3(i, j, k)]) / dx[ACC2(i, j)]) +
                          ((v[ACC3(i, j + 1, k)] - v[ACC3(i, j, k)]) / dy[ACC2(i, j)]) *
                              ((v[ACC3(i, j + 1, k)] - v[ACC3(i, j, k)]) / dy[ACC2(i, j)]) +
                          0.5f *
                              (0.25f *
                                   (u[ACC3(i, j + 1, k)] + u[ACC3(i + 1, j + 1, k)] -
                                    u[ACC3(i, j - 1, k)] - u[ACC3(i + 1, j - 1, k)]) /
                                   dy[ACC2(i, j)] +
                               0.25f *
                                   (v[ACC3(i + 1, j, k)] + v[ACC3(i + 1, j + 1, k)] -
                                    v[ACC3(i - 1, j, k)] - v[ACC3(i - 1, j + 1, k)]) /
                                   dx[ACC2(i, j)]) *
                              (0.25f *
                                   (u[ACC3(i, j + 1, k)] + u[ACC3(i + 1, j + 1, k)] -
                                    u[ACC3(i, j - 1, k)] - u[ACC3(i + 1, j - 1, k)]) /
                                   dy[ACC2(i, j)] +
                               0.25f *
                                   (v[ACC3(i + 1, j, k)] + v[ACC3(i + 1, j + 1, k)] -
                                    v[ACC3(i - 1, j, k)] - v[ACC3(i - 1, j + 1, k)]) /
                                   dx[ACC2(i, j)]));
            }
        }
    }
}

/////***** Form vertical averages of 3-D fields for use in external (2-D) mode:
///*****/////
/////
/////   real_t *adx2d             Vertical integrals of advx (2D array) (may
/// vary the exact meaning in other functions.)
/////   real_t *ady2d             Vertical integrals of advy (2D array) (may
/// vary the exact meaning in other functions.)
/////   real_t *drx2d             Vertical integrals of drhox (2D array)
/////   real_t *dry2d             Vertical integrals of drhoy (2D array)
/////   real_t *aam2d             Vertical integrals of aam (2D array)
/////   real_t *advx              the horizontal advection (including curvature
/// terms) and the diffusion terms. (3D array)
/////   real_t *advy              the horizontal advection (including curvature
/// terms) and the diffusion terms (3D array)
/////   real_t *drhox             x-component of the internal baroclinic
/// pressure gradient
/////   real_t *drhoy             y-component of the internal baroclinic
/// pressure gradient
/////   real_t *dz                grid spacing z (=z(k)-z(k-1) z is spanned
/// between 0 and 1) (1D array)
/////
/////   boundary limits
/////   int im, jm                limits of horizontal grid
/////   int kbm1                  kbm1=kb-1.
/////   int imm1, jmm1            imm1 = im-1, jmm1=jm-1.
/////
/////*****************************************************************************/////
void ext_vert_avgs_(real_t* adx2d, real_t* ady2d, real_t* drx2d, real_t* dry2d, real_t* aam2d,
                    real_t* advx, real_t* advy, real_t* drhox, real_t* drhoy, real_t* aam,
                    real_t* dz)
{

    // Init variables.
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            adx2d[ACC2(i, j)] = 0.0f;
            ady2d[ACC2(i, j)] = 0.0f;
            drx2d[ACC2(i, j)] = 0.0f;
            dry2d[ACC2(i, j)] = 0.0f;
            aam2d[ACC2(i, j)] = 0.0f;
        }
    }

    // Calculate the 2-D integrals.
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                adx2d[ACC2(i, j)] += advx[ACC3(i, j, k)] * dz[k];
                ady2d[ACC2(i, j)] += advy[ACC3(i, j, k)] * dz[k];
                drx2d[ACC2(i, j)] += drhox[ACC3(i, j, k)] * dz[k];
                dry2d[ACC2(i, j)] += drhoy[ACC3(i, j, k)] * dz[k];
                aam2d[ACC2(i, j)] += aam[ACC3(i, j, k)] * dz[k];
            }
        }
    }
}

/////***** Add remaning component to the the horizontal advection     *****/////
/////
/////   real_t *adx2d             Vertical integrals of advx (the horizontal
/// advection) (2D array) (may vary the exact meaning in other functions.)
/////   real_t *ady2d             Vertical integrals of advy (the horizontal
/// advection) (2D array) (may vary the exact meaning in other functions.)
/////   real_t *advua             sum of the second, third and fourth terms in
/// equation (18, 19) Check Documentation!
/////   real_t *advva             sum of the second, third and fourth terms in
/// equation (18, 19) Check Documentation!
/////
/////   boundary limits
/////   int im, jm                limits of horizontal grid
/////
/////*****************************************************************************/////
void ext_add_ad_2d_(real_t* adx2d, real_t* ady2d, real_t* advua, real_t* advva)
{

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            adx2d[ACC2(i, j)] -= advua[ACC2(i, j)];
            ady2d[ACC2(i, j)] -= advva[ACC2(i, j)];
        }
    }
}

/////***** Calculate the time forwarded values of eg (surface elevation), ut,
/// and vt (internal mode time average of the velocities) *****/////
/////
/////   real_t *egf               The surface elevation also used in theinternal
/// mode for the pressure gradient and derived from el (m) (2D array) (forward
/// in time)
/////   real_t *el                The surface elevation used in external mode
///(m) (2D-array)
/////   real_t *ispi              1/isplit. isplit = dti/dte (internal mode time
/// stamp / external mode time stamp). Constant! (unitless)
/////   real_t *utf               Internal mode time average of the velocities
///(forward in time). (2D array) (m/s)
/////   real_t *ua                Vertical mean of the velocitie (2D array).
///(m/s)
/////   real_t *d                 h + et. bottom depth + the surface elevation
/// as used in the internal mode and derived from el. (m)
/////   real_t *ispi2             ispi/2. Constant! (unitless)
/////   real_t *vtf               internal mode time average of the velocities
///(forward in time). (2D array) (m/s)
/////   real_t *va                Vertical mean of the velocitie (2D array).
///(m/s)
/////
/////   boundary limits
/////   int im, jm                limits of horizontal grid
/////
/////*****************************************************************************/////
void ext_time_internal_forward_(real_t* egf, real_t* el, real_t* ispi, real_t* utf, real_t* ua,
                                real_t* d, real_t* isp2i, real_t* vtf, real_t* va)
{

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            egf[ACC2(i, j)] = el[ACC2(i, j)] * (*ispi);
        }
    }

    for (int j = 0; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            utf[ACC2(i, j)] = ua[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i - 1, j)]) * (*isp2i);
        }
    }
    for (int j = 1; j < jm; j++)
    {
        for (int i = 1; i < im; i++)
        {
            vtf[ACC2(i, j)] = va[ACC2(i, j)] * (d[ACC2(i, j)] + d[ACC2(i, j - 1)]) * (*isp2i);
        }
    }
}

/////***** Integrates conservative scalar equations.*****/////
/////***** This is centred scheme, as originally provide in  POM (previously
/// called advt).  *****/////
/////***** Check Equation 24 and advt function desription in the user guide
///*****/////
/////
/////   real_t *fb                f backward in time
/////   real_t *f                 scalar field / variable (e.g. Temperature (T)
/// or Salinity (S)).
/////   real_t *fclim             a stationary field which approximately has the
/// same vertical structure as f
/////   real_t *ff                new value of f (forward in time)
/////   real_t *xflux             Sum of (horizontal) advective and diffusive
/// flux. (3D array)
/////   real_t *yflux             Sum of (horizontal) advective and diffusive
/// flux. (3D array)
/////   real_t *zflux             Sum of vertical advection and diffusive flux.
///(3D array)
/////   real_t *u                 Horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *v                 Horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *aam               Horizontal kinematic viscosity (m^2*s^(-1))
///(3D array)
/////   real_t *dum               Mask for the u component of velocity; = 0 over
/// land; =1 over water
/////   real_t *dvm               Mask for the v component of velocity; = 0 over
/// land; =1 over water
/////   real_t *dx                Grid spacing x (m) (2D array)
/////   real_t *dy                Grid spacing y (m) (2D array)
/////   real_t *dz                grid spacing z (=z(k)-z(k-1) z is spanned
/// between 0 and 1) (1D array)
/////   real_t *h                 Buttom depth (m) (2D array)
/////   real_t *w                 Sigma coordinate vertical velocity (m s -1 )
///(3D array)
/////   real_t *art               Cell areas centered on the variables T
///(m^2)(2D array)
/////   real_t *etb               et backward in time. et= the surface elevation
/// as used in the internal mode and derived from EL (m)
/////   real_t *etf               et forward in time. et= the surface elevation
/// as used in the internal mode and derived from EL (m)
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int im, jm                limits of horizontal grid
/////   int kbm1                  kbm1=kb-1.
/////   int imm1, jmm1            imm1 = im-1, jmm1=jm-1.
/////
/////*****************************************************************************/////
void ext_advt1_(real_t* fb, real_t* f, real_t* fclim, real_t* ff, real_t* xflux, real_t* yflux,
                real_t* zflux, real_t* u, real_t* v, real_t* dt, real_t* aam, real_t* dum,
                real_t* dvm, real_t* dx, real_t* dy, real_t* dz, real_t* h, real_t* w, real_t* art,
                real_t* etb, real_t* etf)
{

    // Reset boundaries
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            f[ACC3(i, j, kbm1)] = f[ACC3(i, j, kbm2)];
            fb[ACC3(i, j, kbm1)] = fb[ACC3(i, j, kbm2)];
        }
    }

    // Do advective fluxes
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xflux[ACC3(i, j, k)] =
                    0.25f * ((dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                             (f[ACC3(i, j, k)] + f[ACC3(i - 1, j, k)]) * u[ACC3(i, j, k)]);
                yflux[ACC3(i, j, k)] =
                    0.25f * ((dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                             (f[ACC3(i, j, k)] + f[ACC3(i, j - 1, k)]) * v[ACC3(i, j, k)]);
            }
        }
    }

    //////// Add diffusive fluxes /////////

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                fb[ACC3(i, j, k)] = fb[ACC3(i, j, k)] - fclim[ACC3(i, j, k)];
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xflux[ACC3(i, j, k)] -= 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)]) *
                                        (h[ACC2(i, j)] + h[ACC2(i - 1, j)]) * tprni *
                                        (fb[ACC3(i, j, k)] - fb[ACC3(i - 1, j, k)]) *
                                        dum[ACC2(i, j)] / (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);
                yflux[ACC3(i, j, k)] -= 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)]) *
                                        (h[ACC2(i, j)] + h[ACC2(i, j - 1)]) * tprni *
                                        (fb[ACC3(i, j, k)] - fb[ACC3(i, j - 1, k)]) *
                                        dvm[ACC2(i, j)] / (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);
                xflux[ACC3(i, j, k)] =
                    0.5f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) * xflux[ACC3(i, j, k)];
                yflux[ACC3(i, j, k)] =
                    0.5f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) * yflux[ACC3(i, j, k)];
            }
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                fb[ACC3(i, j, k)] += fclim[ACC3(i, j, k)];
            }
        }
    }

    // Do vertical advection
    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            zflux[ACC3(i, j, 0)] = f[ACC3(i, j, 0)] * w[ACC3(i, j, 0)] * art[ACC2(i, j)];
            zflux[ACC3(i, j, kbm1)] = 0.0f;
        }
    }

    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                zflux[ACC3(i, j, k)] = 0.5f * (f[ACC3(i, j, k - 1)] + f[ACC3(i, j, k)]) *
                                       w[ACC3(i, j, k)] * art[ACC2(i, j)];
            }
        }
    }

    // Add net horizontal fluxes and then step forward in time
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                ff[ACC3(i, j, k)] = xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                                    yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)] +
                                    (zflux[ACC3(i, j, k)] - zflux[ACC3(i, j, k + 1)]) / dz[k];

                ff[ACC3(i, j, k)] =
                    (fb[ACC3(i, j, k)] * (h[ACC2(i, j)] + etb[ACC2(i, j)]) * art[ACC2(i, j)] -
                     dti2 * ff[ACC3(i, j, k)]) /
                    ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
            }
        }
    }
}

/////*****Update temperature and salinity values.*****/////
/////
/////   real_t *t                Potential temperature (°C). (3D array)
/////   real_t *tb               t backward in time. (3D array)
/////   real_t *s                Salinity (psu) (3D array)
/////   real_t *sb               s backward in time. (3D array)
/////   real_t *uf               Temporary variable to calculate t
///(temperature)forward in time values. 3D array.
/////   real_t *vf               Temporary variable to calculate s (salinity)
/// forward in time values. 3D array.
/////   real_t *smoth            Constant in temporal filter used to prevent
/// solution splitting  (dimensionless).
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int im, jm                limits of horizontal grid
/////
/////*****************************************************************************/////
void ext_updeta_t_s_(real_t* t, real_t* tb, real_t* s, real_t* sb, real_t* uf, real_t* vf,
                     real_t* smoth)
{

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
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
        }
    }
}

/////***** Calculates the antidiffusive velocity used to reduce the numerical
/// diffusion *****/////
/////***** associated with the upstream differencing scheme. *****/////
/////
/////***** This is based on a subroutine of Gianmaria Sannino (Inter-university
///*****/////
/////***** Computing Consortium, Rome, Italy) and Vincenzo Artale (Italian
/// National     *****/////
/////***** Agency for New Technology and Environment, Rome, Italy), downloaded
/// from     *****/////
/////***** the POM FTP site on 1 Nov. 2001. The calculations have been
/// simplified       *****/////
/////***** by removing the shock switch option. *****/////
/////
/////   real_t *xmassflux         working arrays used to save memory   (3D
/// array)
/////   real_t *ymassflux         working arrays used to save memory   (3D
/// array)
/////   real_t *zwflux            working arrays used to save memory   (3D
/// array)
/////   real_t *ff                new value of f(scalar field / variable (e.g.
/// Temperature (T) or Salinity (S))) (forward in time)
/////   real_t *sw                smoothing parameter. This should preferably be
/// 1, but 0 < sw < 1 gives smoother solutions with less overshoot when nitera
///> 1.
/////   real_t *fsm               Mask for scalar variables; = 0 over land; = 1
/// over water. 2D array.
/////   real_t *aru               cell areas centered on the variable U (m^2)
///(2D array)
/////   real_t *arv               cell areas centered on the variable V (m^2)
///(2D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *dzz               zz(k)−zz(k+1). zz = sigma coordinate,
/// intermediate between Z. Z =sigma coordinate which spans the domain, z =
/// 0(surface) to z = -1 (bottom). (1D array)
/////
/////*****************************************************************************/////
void ext_smol_adif_(real_t* xmassflux, real_t* ymassflux, real_t* zwflux, real_t* ff, real_t* sw,
                    real_t* fsm, real_t* aru, real_t* arv, real_t* dt, real_t* dzz)
{

    const real_t value_min = 1.0e-9f, epsilon = 1.0e-14f;
    // Apply temperature and salinity mask:
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                ff[ACC3(i, j, k)] *= fsm[ACC2(i, j)];
            }
        }
    }

    // Recalculate mass fluxes with antidiffusion velocity:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < im; i++)
            {

                real_t udx, u2dt, mol;

                if ((ff[ACC3(i, j, k)] < 1.0e-9f) || (ff[ACC3(i - 1, j, k)] < 1.0e-9f))
                {
                    xmassflux[ACC3(i, j, k)] = 0.0f;
                }
                else
                {
                    udx = fabs(xmassflux[ACC3(i, j, k)]);
                    u2dt = dti2 * xmassflux[ACC3(i, j, k)] * xmassflux[ACC3(i, j, k)] * 2.0f /
                           (aru[ACC2(i, j)] * (dt[ACC2(i - 1, j)] + dt[ACC2(i, j)]));
                    mol = (ff[ACC3(i, j, k)] - ff[ACC3(i - 1, j, k)]) /
                          (ff[ACC3(i - 1, j, k)] + ff[ACC3(i, j, k)] + 1.0e-14f);
                    xmassflux[ACC3(i, j, k)] = (udx - u2dt) * mol * (*sw);

                    if (fabs(udx) < fabs(u2dt))
                    {
                        xmassflux[ACC3(i, j, k)] = 0.0f;
                    }
                }
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < imm1; i++)
            {

                real_t vdy, v2dt, mol;

                if ((ff[ACC3(i, j, k)] < 1.0e-9f) || (ff[ACC3(i, j - 1, k)] < 1.0e-9f))
                {
                    ymassflux[ACC3(i, j, k)] = 0.0f;
                }
                else
                {
                    vdy = fabs(ymassflux[ACC3(i, j, k)]);
                    v2dt = dti2 * ymassflux[ACC3(i, j, k)] * ymassflux[ACC3(i, j, k)] * 2.0f /
                           (arv[ACC2(i, j)] * (dt[ACC2(i, j - 1)] + dt[ACC2(i, j)]));
                    mol = (ff[ACC3(i, j, k)] - ff[ACC3(i, j - 1, k)]) /
                          (ff[ACC3(i, j - 1, k)] + ff[ACC3(i, j, k)] + 1.0e-14f);
                    ymassflux[ACC3(i, j, k)] = (vdy - v2dt) * mol * (*sw);

                    if (fabs(vdy) < fabs(v2dt))
                    {
                        ymassflux[ACC3(i, j, k)] = 0.0f;
                    }
                }
            }
        }
    }

    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {

                real_t wdz, w2dt, mol;

                if ((ff[ACC3(i, j, k)] < 1.0e-9f) || (ff[ACC3(i, j, k - 1)] < 1.0e-9f))
                {
                    zwflux[ACC3(i, j, k)] = 0.0f;
                }
                else
                {
                    wdz = fabs(zwflux[ACC3(i, j, k)]);
                    w2dt = dti2 * zwflux[ACC3(i, j, k)] * zwflux[ACC3(i, j, k)] /
                           (dzz[k - 1] * dt[ACC2(i, j)]);
                    mol = (ff[ACC3(i, j, k - 1)] - ff[ACC3(i, j, k)]) /
                          (ff[ACC3(i, j, k)] + ff[ACC3(i, j, k - 1)] + 1.0e-14f);
                    zwflux[ACC3(i, j, k)] = (wdz - w2dt) * mol * (*sw);

                    if (fabs(wdz) < fabs(w2dt))
                    {
                        zwflux[ACC3(i, j, k)] = 0.0f;
                    }
                }
            }
        }
    }
}
/////***** Integrates conservative scalar equations.*****/////
/////
/////***** This is a first-order upstream scheme, which reduces implicit
/// diffusion using  *****/////
/////***** the Smolarkiewicz iterative upstream scheme with an antidiffusive
/// velocity.    *****/////
/////
/////***** It is based on the subroutines of Gianmaria Sannino (Inter-university
///*****/////
/////***** Computing Consortium, Rome, Italy) and Vincenzo Artale (Italian
/// National       *****/////
/////***** Agency for New Technology and Environment, Rome, Italy), downloaded
/// from the   *****/////
/////***** POM FTP site on 1 Nov. 2001. The calculations have been simplified by
/// removing *****/////
/////***** the shock switch option. It should be noted that this implementation
///*****/////
/////***** does not include cross-terms which are in the original formulation.
///*****/////
/////
/////***** Reference:
/////***** Smolarkiewicz, P.K.; A fully multidimensional positive definite
/// advection      *****/////
/////***** transport algorithm with small implicit diffusion, Journal of
///*****/////
/////***** Computational Physics, 54, 325-362, 1984. *****/////
/////
///// fb,f,fclim,ff . as used in subroutine advt1
///// xflux,yflux ... working arrays used to save memory
/////
/////
///*****************************************************************************************/////
/////
/////   real_t *fb                f backward in time
/////   real_t *f                 scalar field / variable (e.g. Temperature (T)
/// or Salinity (S)).
/////   real_t *fclim             a stationary field which approximately has the
/// same vertical structure as f
/////   real_t *ff                new value of f (forward in time)
/////   real_t *xflux             working arrays used to save memory   (3D
/// array)
/////   real_t *yflux             working arrays used to save memory   (3D
/// array)
/////   real_t *zflux             Sum of vertical advection and diffusive flux.
///(3D array)
/////   int    *nitera            Number of iterations. This should be in the
/// range 1 - 4. 1 is standard upstream differencing; 3 adds 50% CPU time to
/// POM.
/////   real_t *sw                smoothing parameter. This should preferably be
/// 1, but 0 < sw < 1 gives smoother solutions with less overshoot when nitera
///> 1.
/////   real_t *u                 Horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *v                 Horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *aam               Horizontal kinematic viscosity (m^2*s^(-1))
///(3D array)
/////   real_t *dum               Mask for the u component of velocity; = 0 over
/// land; =1 over water
/////   real_t *dvm               Mask for the v component of velocity; = 0 over
/// land; =1 over water
/////   real_t *dx                Grid spacing x (m) (2D array)
/////   real_t *dy                Grid spacing y (m) (2D array)
/////   real_t *dz                grid spacing z (=z(k)-z(k-1) z is spanned
/// between 0 and 1) (1D array)
/////   real_t *h                 Buttom depth (m) (2D array)
/////   real_t *w                 Sigma coordinate vertical velocity (m s -1 )
///(3D array)
/////   real_t *art               Cell areas centered on the variables T
///(m^2)(2D array)
/////   real_t *etb               et backward in time. et= the surface elevation
/// as used in the internal mode and derived from EL (m)
/////   real_t *etf               et forward in time. et= the surface elevation
/// as used in the internal mode and derived from EL (m)
/////   real_t *fsm               Mask for scalar variables; = 0 over land; = 1
/// over water. 2D array.
/////   real_t *aru               cell areas centered on the variable U (m^2)
///(2D array)
/////   real_t *arv               cell areas centered on the variable V (m^2)
///(2D array)
/////   real_t *dzz               zz(k)−zz(k+1). zz = sigma coordinate,
/// intermediate between Z. Z =sigma coordinate which spans the domain, z =
/// 0(surface) to z = -1 (bottom). (1D array)
/////
/////   real_t *fbmem             working array to save fb values  (3D array)
/////   real_t *eta               working arrays used to save memory   (2D
/// array)
/////   real_t *xmassflux         working arrays used to save memory   (3D
/// array)
/////   real_t *ymassflux         working arrays used to save memory   (3D
/// array)
/////   real_t *zwflux            working arrays used to save memory   (3D
/// array)
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int im, jm                limits of horizontal grid
/////   int kbm1                  kbm1=kb-1.
/////   int imm1, jmm1            imm1 = im-1, jmm1=jm-1.
/////
/////*****************************************************************************/////
void ext_advt2_(real_t* fb, real_t* f, real_t* fclim, real_t* ff, real_t* xflux, real_t* yflux,
                real_t* zflux, int* nitera, real_t* sw, real_t* u, real_t* v, real_t* dt,
                real_t* aam, real_t* dum, real_t* dvm, real_t* dx, real_t* dy, real_t* dz,
                real_t* h, real_t* w, real_t* art, real_t* etb, real_t* etf, real_t* fsm,
                real_t* aru, real_t* arv, real_t* dzz, real_t* fbmem, real_t* eta,
                real_t* xmassflux, real_t* ymassflux, real_t* zwflux)
{

    // Init varriables
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                xmassflux[ACC3(i, j, k)] = 0.0f;
                ymassflux[ACC3(i, j, k)] = 0.0f;
            }
        }
    }

    // Calculate horizontal mass fluxes:
    for (int k = 0; k < kbm1; k++) //unroll neeeded for fusion
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xmassflux[ACC3(i, j, k)] = 0.25f * (dy[ACC2(i - 1, j)] + dy[ACC2(i, j)]) *
                                           (dt[ACC2(i - 1, j)] + dt[ACC2(i, j)]) * u[ACC3(i, j, k)];
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                ymassflux[ACC3(i, j, k)] = 0.25f * (dx[ACC2(i, j - 1)] + dx[ACC2(i, j)]) *
                                           (dt[ACC2(i, j - 1)] + dt[ACC2(i, j)]) * v[ACC3(i, j, k)];
            }
        }
    }

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            eta[ACC2(i, j)] = etb[ACC2(i, j)];
            fb[ACC3(i, j, kbm1)] = fb[ACC3(i, j, (kbm2))];
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                zwflux[ACC3(i, j, k)] = w[ACC3(i, j, k)];
                fbmem[ACC3(i, j, k)] = fb[ACC3(i, j, k)];
            }
        }
    }

    // Start Smolarkiewicz scheme:
    // for (int itera = 0; itera < 10; itera++) { //uncomment for interest
    int itera = 0;

    // Upwind advection scheme:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xflux[ACC3(i, j, k)] =
                    0.5f * ((xmassflux[ACC3(i, j, k)] + fabs(xmassflux[ACC3(i, j, k)])) *
                                fbmem[ACC3(i - 1, j, k)] +
                            (xmassflux[ACC3(i, j, k)] - fabs(xmassflux[ACC3(i, j, k)])) *
                                fbmem[ACC3(i, j, k)]);

                yflux[ACC3(i, j, k)] =
                    0.5f * ((ymassflux[ACC3(i, j, k)] + fabs(ymassflux[ACC3(i, j, k)])) *
                                fbmem[ACC3(i, j - 1, k)] +
                            (ymassflux[ACC3(i, j, k)] - fabs(ymassflux[ACC3(i, j, k)])) *
                                fbmem[ACC3(i, j, k)]);
            }
        }
    }

    for (int j = 1; j < jmm1; j++)
    {
        for (int i = 1; i < imm1; i++)
        {
            zflux[ACC3(i, j, 0)] = 0.0f;
            zflux[ACC3(i, j, kbm1)] = 0.0f;
        }
    }

    if (itera == 0)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                zflux[ACC3(i, j, 0)] = w[ACC3(i, j, 0)] * f[ACC3(i, j, 0)] * art[ACC2(i, j)];
            }
        }
    }

    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                zflux[ACC3(i, j, k)] =
                    0.5f *
                    ((zwflux[ACC3(i, j, k)] + fabs(zwflux[ACC3(i, j, k)])) * fbmem[ACC3(i, j, k)] +
                     (zwflux[ACC3(i, j, k)] - fabs(zwflux[ACC3(i, j, k)])) *
                         fbmem[ACC3(i, j, k - 1)]);
                zflux[ACC3(i, j, k)] *= art[ACC2(i, j)];
            }
        }
    }

    // Add net advective fluxes and step forward in time:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                ff[ACC3(i, j, k)] = xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                                    yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)] +
                                    (zflux[ACC3(i, j, k)] - zflux[ACC3(i, j, k + 1)]) / dz[k];
                ff[ACC3(i, j, k)] =
                    (fbmem[ACC3(i, j, k)] * (h[ACC2(i, j)] + eta[ACC2(i, j)]) * art[ACC2(i, j)] -
                     dti2 * ff[ACC3(i, j, k)]) /
                    ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
            }
        }
    }

    // Calculate antidiffusion velocity:
    // call_ext_smol_adif_(xmassflux, ymassflux, zwflux, ff, sw, fsm, aru, arv,
    // dt,
    //                dzz);

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            eta[ACC2(i, j)] = etf[ACC2(i, j)];
        }
    }

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            for (int k = 0; k < kb; k++)
            {
                fbmem[ACC3(i, j, k)] = ff[ACC3(i, j, k)];
            }
        }
    }

    // End of Smolarkiewicz scheme
    // }

    // Add horizontal diffusive fluxes:

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                fb[ACC3(i, j, k)] -= fclim[ACC3(i, j, k)];
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xmassflux[ACC3(i, j, k)] = 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)]);
                ymassflux[ACC3(i, j, k)] = 0.5f * (aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)]);
            }
        }
    }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                xflux[ACC3(i, j, k)] = -xmassflux[ACC3(i, j, k)] *
                                       (h[ACC2(i, j)] + h[ACC2(i - 1, j)]) * tprni *
                                       (fb[ACC3(i, j, k)] - fb[ACC3(i - 1, j, k)]) *
                                       dum[ACC2(i, j)] * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) *
                                       0.5f / (dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);
                yflux[ACC3(i, j, k)] = -ymassflux[ACC3(i, j, k)] *
                                       (h[ACC2(i, j)] + h[ACC2(i, j - 1)]) * tprni *
                                       (fb[ACC3(i, j, k)] - fb[ACC3(i, j - 1, k)]) *
                                       dvm[ACC2(i, j)] * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) *
                                       0.5f / (dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);
            }
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                fb[ACC3(i, j, k)] += fclim[ACC3(i, j, k)];
            }
        }
    }

    // Add net horizontal fluxes and step forward in time:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                ff[ACC3(i, j, k)] =
                    ff[ACC3(i, j, k)] - dti2 *
                                            (xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
                                             yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)]) /
                                            ((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
            }
        }
    }
}

/////*****Final (2D arrayy) updete of an internal mode iteration*****/////
/////
/////   real_t *egb               The surface elevation also used in theinternal
/// mode for the pressure gradient and derived from el (m) (2D array) (backward
/// in time)
/////   real_t *egf               The surface elevation also used in theinternal
/// mode for the pressure gradient and derived from el (m) (2D array) (forward
/// in time)
/////   real_t *etb               et backward in time (m) (2D array)
/////   real_t *et                The surface elevation as used in the internal
/// mode and derived from EL (m) (2D array)
/////   real_t *etf               et forward in time (m) (2D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *h                 bottom depth (m) (2D array)
/////   real_t *utb               Internal mode time average of the velocities
///(backward in time). (2D array) (m/s)
/////   real_t *utf               Internal mode time average of the velocities
///(forward in time). (2D array) (m/s)
/////   real_t *vtb               Internal mode time average of the velocities
///(backward in time). (2D array) (m/s)
/////   real_t *vtf               Internal mode time average of the velocities
///(forward in time). (2D array) (m/s)
/////   real_t *vfluxb            vertical velocity flux (backward in time) (2D
/// array)
/////   real_t *vfluxf            vertical velocity flux (backward in time) (2D
/// array)
/////
/////   boundary limits
/////   int im, jm                limits of horizontal grid
/////
/////*****************************************************************************/////
void ext_final_internal_update_(real_t* egb, real_t* egf, real_t* etb, real_t* et, real_t* etf,
                                real_t* dt, real_t* h, real_t* utb, real_t* utf, real_t* vtb,
                                real_t* vtf, real_t* vfluxb, real_t* vfluxf)
{

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            egb[ACC2(i, j)] = egf[ACC2(i, j)];
            etb[ACC2(i, j)] = et[ACC2(i, j)];
            et[ACC2(i, j)] = etf[ACC2(i, j)];
            dt[ACC2(i, j)] = h[ACC2(i, j)] + et[ACC2(i, j)];
            utb[ACC2(i, j)] = utf[ACC2(i, j)];
            vtb[ACC2(i, j)] = vtf[ACC2(i, j)];
            vfluxb[ACC2(i, j)] = vfluxf[ACC2(i, j)];
        }
    }
}

/////*****Updete horizontal velocities*****/////
/////
/////   real_t *tps               Temporary variable? (2D array)
/////   real_t *u                 horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *uf                u forward in time (m/s^-1) (3D array)
/////   real_t *ub                u backward in time (m/s^-1) (3D array)
/////   real_t *v                 horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *vf                v forward in time (m/s^-1) (3D array)
/////   real_t *vb                v backward in time (m/s^-1) (3D array)
/////   real_t *dz                grid spacing z (=z(k)-z(k-1) z is spanned
/// between 0 and 1) (1D array)
/////   real_t *smoth             Constant in temporal filter used to prevent
/// solution splitting  (dimensionless).
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int kbm1                  kbm1=kb-1.
/////   int im, jm                limits of horizontal grid
/////
/////*****************************************************************************/////
void ext_update_u_v_(real_t* tps, real_t* u, real_t* uf, real_t* ub, real_t* v, real_t* vf,
                     real_t* vb, real_t* dz, real_t* smoth)
{

    // Initialize variable
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            tps[ACC2(i, j)] = 0.0f;
        }
    }

    // for (int k = 0; k < kbm1; k++)
    // {
    //     for (int j = 0; j < jm; j++)
    //     {
    //         for (int i = 0; i < im; i++)
    //         {
    //             tps[ACC2(i, j)] +=
    //                 (uf[ACC3(i, j, k)] + ub[ACC3(i, j, k)] - 2.0f * u[ACC3(i, j, k)]) * dz[k];
    //         }
    //     }
    // }

    // for (int k = 0; k < kbm1; k++)
    // {
    //     for (int j = 0; j < jm; j++)
    //     {
    //         for (int i = 0; i < im; i++)
    //         {
    //             u[ACC3(i, j, k)] += 0.5f * (*smoth) *
    //                                 (uf[ACC3(i, j, k)] + ub[ACC3(i, j, k)] -
    //                                  2.0f * u[ACC3(i, j, k)] - tps[ACC2(i, j)]);
    //         }
    //     }
    // }

    // // Initialize variable
    // for (int j = 0; j < jm; j++)
    // {
    //     for (int i = 0; i < im; i++)
    //     {
    //         tps[ACC2(i, j)] = 0.0f;
    //     }
    // }

    // for (int k = 0; k < kbm1; k++)
    // {
    //     for (int j = 0; j < jm; j++)
    //     {
    //         for (int i = 0; i < im; i++)
    //         {
    //             tps[ACC2(i, j)] +=
    //                 (vf[ACC3(i, j, k)] + vb[ACC3(i, j, k)] - 2.0f * v[ACC3(i, j, k)]) * dz[k];
    //         }
    //     }
    // }

    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                v[ACC3(i, j, k)] += 0.5f * (*smoth) *
                                    (vf[ACC3(i, j, k)] + vb[ACC3(i, j, k)] -
                                     2.0f * v[ACC3(i, j, k)] - tps[ACC2(i, j)]);
            }
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                ub[ACC3(i, j, k)] = u[ACC3(i, j, k)];
                u[ACC3(i, j, k)] = uf[ACC3(i, j, k)];
                vb[ACC3(i, j, k)] = v[ACC3(i, j, k)];
                v[ACC3(i, j, k)] = vf[ACC3(i, j, k)];
            }
        }
    }
}

//////***** Does horizontal and vertical advection of u-momentum, *****/////
/////*****  and includes coriolis, surface slope and baroclinic terms.
///*****/////
/////
/////   real_t *u                 horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *uf                u forward in time (m/s^-1) (3D array)
/////   real_t *ub                u backward in time (m/s^-1) (3D array)
/////   real_t *v                 horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *w                 sigma coordinate vertical velocity (m/s^-1)
///(3D array)
/////   real_t *advx              the horizontal advection (including curvature
/// terms) and the diffusion terms. (3D array)
/////   real_t *aru               cell areas centered on the variable U (m^2)
///(2D array)
/////   real_t *dy                grid spacing y (m) (2D array)
/////   real_t *dz                grid spacing z (=z(k)-z(k-1) z is spanned
/// between 0 and 1) (1D array)
/////   real_t *cor               the Coriolis parameter (s^(-1)) (2D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *egf               The surface elevation also used in theinternal
/// mode for the pressure gradient and derived from el (m) (2D array) (forward
/// in time)
/////   real_t *egb               The surface elevation also used in theinternal
/// mode for the pressure gradient and derived from el (m) (2D array) (backward
/// in time)
/////   real_t *e_atoms           Atmospheric pressure (2D array)
/////   real_t *drhox             x-component of the internal baroclinic
/// pressure gradient (3D array)
/////   real_t *h                 bottom depth (m) (2D array)
/////   real_t *etf               et (The surface elevation as used in the
/// internal mode and derived from EL) forward in time (m) (2D array)
/////   real_t *etb               et (The surface elevation as used in the
/// internal mode and derived from EL) backward in time (m) (2D array)
/////
/////   Used constants
/////   real_t dti2              Internal mode time stamp =dti*2 (s)
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int im, jm                limits of horizontal grid
/////   int kbm1                  kbm1=kb-1.
/////   int imm1, jmm1            imm1 = im-1, jmm1=jm-1.
/////
/////*****************************************************************************/////
void ext_advu_(real_t* u, real_t* uf, real_t* ub, real_t* v, real_t* w, real_t* advx, real_t* aru,
               real_t* dy, real_t* dz, real_t* cor, real_t* dt, real_t* egf, real_t* egb,
               real_t* e_atmos, real_t* drhox, real_t* h, real_t* etf, real_t* etb)
{

    // Init variable
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                uf[ACC3(i, j, k)] = 0.0f;
            }
        }
    }

    // Do vertical advection:
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                uf[ACC3(i, j, k)] = 0.25f * (w[ACC3(i, j, k)] + w[ACC3(i - 1, j, k)]) *
                                    (u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
            }
        }
    }

    // Combine horizontal and vertical advection with coriolis, surface slope
    // and baroclinic terms:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                uf[ACC3(i, j, k)] =
                    advx[ACC3(i, j, k)] +
                    (uf[ACC3(i, j, k)] - uf[ACC3(i, j, k + 1)]) * aru[ACC2(i, j)] / dz[k] -
                    aru[ACC2(i, j)] * 0.25f *
                        (cor[ACC2(i, j)] * dt[ACC2(i, j)] *
                             (v[ACC3(i, j + 1, k)] + v[ACC3(i, j, k)]) +
                         cor[ACC2(i - 1, j)] * dt[ACC2(i - 1, j)] *
                             (v[ACC3(i - 1, j + 1, k)] + v[ACC3(i - 1, j, k)])) +
                    grav * 0.125f * (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
                        (egf[ACC2(i, j)] - egf[ACC2(i - 1, j)] + egb[ACC2(i, j)] -
                         egb[ACC2(i - 1, j)] +
                         (e_atmos[ACC2(i, j)] - e_atmos[ACC2(i - 1, j)]) * 2.0f) *
                        (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]) +
                    drhox[ACC3(i, j, k)];
            }
        }
    }

    // Step forward in time:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                uf[ACC3(i, j, k)] =
                    ((h[ACC2(i, j)] + etb[ACC2(i, j)] + h[ACC2(i - 1, j)] + etb[ACC2(i - 1, j)]) *
                         aru[ACC2(i, j)] * ub[ACC3(i, j, k)] -
                     2.0f * dti2 * uf[ACC3(i, j, k)]) /
                    ((h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) *
                     aru[ACC2(i, j)]);
            }
        }
    }
}

//////***** Does horizontal and vertical advection of v-momentum, *****/////
/////*****  and includes coriolis, surface slope and baroclinic terms.
///*****/////
/////
/////   real_t *v                 horizontal velocity (V) (m/s^-1) (3D array)
/////   real_t *vf                v forward in time (m/s^-1) (3D array)
/////   real_t *vb                v backward in time (m/s^-1) (3D array)
/////   real_t *u                 horizontal velocity (U) (m/s^-1) (3D array)
/////   real_t *w                 sigma coordinate vertical velocity (m/s^-1)
///(3D array)
/////   real_t *advy              the horizontal advection (including curvature
/// terms) and the diffusion terms. (3D array)
/////   real_t *arv               cell areas centered on the variable V (m^2)
///(2D array)
/////   real_t *dx                grid spacing x (m) (2D array)
/////   real_t *dz                grid spacing z (=z(k)-z(k-1) z is spanned
/// between 0 and 1) (1D array)
/////   real_t *cor               the Coriolis parameter (s^(-1)) (2D array)
/////   real_t *dt                (m) h+et = bottom depth + the surface
/// elevation as used in the internal mode. (2D array)
/////   real_t *egf               The surface elevation also used in theinternal
/// mode for the pressure gradient and derived from el (m) (2D array) (forward
/// in time)
/////   real_t *egb               The surface elevation also used in theinternal
/// mode for the pressure gradient and derived from el (m) (2D array) (backward
/// in time)
/////   real_t *e_atoms           Atmospheric pressure (2D array)
/////   real_t *drhoy             y-component of the internal baroclinic
/// pressure gradient (3D array)
/////   real_t *h                 bottom depth (m) (2D array)
/////   real_t *etf               et (The surface elevation as used in the
/// internal mode and derived from EL) forward in time (m) (2D array)
/////   real_t *etb               et (The surface elevation as used in the
/// internal mode and derived from EL) backward in time (m) (2D array)
/////
/////   Used constants
/////   real_t dti2              Internal mode time stamp =dti*2 (s)
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int im, jm                limits of horizontal grid
/////   int kbm1                  kbm1=kb-1.
/////   int imm1, jmm1            imm1 = im-1, jmm1=jm-1.
/////
/////*****************************************************************************/////
void ext_advv_(real_t* v, real_t* vf, real_t* vb, real_t* u, real_t* w, real_t* advy, real_t* arv,
               real_t* dx, real_t* dz, real_t* cor, real_t* dt, real_t* egf, real_t* egb,
               real_t* e_atmos, real_t* drhoy, real_t* h, real_t* etf, real_t* etb)
{

    // Init variable
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                vf[ACC3(i, j, k)] = 0.0f;
            }
        }
    }

    // Do vertical advection:
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                vf[ACC3(i, j, k)] = 0.25f * (w[ACC3(i, j, k)] + w[ACC3(i, j - 1, k)]) *
                                    (v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
            }
        }
    }

    // Combine horizontal and vertical advection with coriolis, surface slope
    // and baroclinic terms:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                vf[ACC3(i, j, k)] =
                    advy[ACC3(i, j, k)] +
                    (vf[ACC3(i, j, k)] - vf[ACC3(i, j, k + 1)]) * arv[ACC2(i, j)] / dz[k] +
                    arv[ACC2(i, j)] * 0.25f *
                        (cor[ACC2(i, j)] * dt[ACC2(i, j)] *
                             (u[ACC3(i + 1, j, k)] + u[ACC3(i, j, k)]) +
                         cor[ACC2(i, j - 1)] * dt[ACC2(i, j - 1)] *
                             (u[ACC3(i + 1, j - 1, k)] + u[ACC3(i, j - 1, k)])) +
                    grav * 0.125f * (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
                        (egf[ACC2(i, j)] - egf[ACC2(i, j - 1)] + egb[ACC2(i, j)] -
                         egb[ACC2(i, j - 1)] +
                         (e_atmos[ACC2(i, j)] - e_atmos[ACC2(i, j - 1)]) * 2.0f) *
                        (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]) +
                    drhoy[ACC3(i, j, k)];
            }
        }
    }

    // Step forward in time:
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                vf[ACC3(i, j, k)] =
                    ((h[ACC2(i, j)] + etb[ACC2(i, j)] + h[ACC2(i, j - 1)] + etb[ACC2(i, j - 1)]) *
                         arv[ACC2(i, j)] * vb[ACC3(i, j, k)] -
                     2.0f * dti2 * vf[ACC3(i, j, k)]) /
                    ((h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i, j - 1)] + etf[ACC2(i, j - 1)]) *
                     arv[ACC2(i, j)]);
            }
        }
    }
}

/////***** Update turbulance parameters     *****/////
/////
/////   real_t *q2        twice the turbulence kinetic energy (m^2/s^2) (3D
/// array)
/////   real_t *q2b       q2 backward in time (m^2/s^2) (3D array)
/////   real_t *q2l       q2 * the turbulence length scale (m^3/s^2) (3D array)
/////   real_t *q2lb      q2l backward in time (m^3/s^2) (3D array)
/////   real_t *uf        u, horizontal velocity, forward in time (m/s^-1) (3D
/// array)
/////   real_t *vf        v, horizontal velocity, forward in time (m/s^-1) (3D
/// array)
/////   real_t *smoth     Constant in temporal filter used to prevent solution
/// splitting  (dimensionless).
/////
/////   boundary limits
/////   int kb                    vertical grid limit.
/////   int im, jm                limits of horizontal grid
/////
/////*****************************************************************************/////
void ext_update_turbulane_(real_t* q2, real_t* q2b, real_t* q2l, real_t* q2lb, real_t* uf,
                           real_t* vf, real_t* smoth)
{

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                q2[ACC3(i, j, k)] +=
                    0.5f * (*smoth) *
                    (uf[ACC3(i, j, k)] + q2b[ACC3(i, j, k)] - 2.0f * q2[ACC3(i, j, k)]);
                q2l[ACC3(i, j, k)] +=
                    0.5f * (*smoth) *
                    (vf[ACC3(i, j, k)] + q2lb[ACC3(i, j, k)] - 2.0f * q2l[ACC3(i, j, k)]);
                q2b[ACC3(i, j, k)] = q2[ACC3(i, j, k)];
                q2[ACC3(i, j, k)] = uf[ACC3(i, j, k)];
                q2lb[ACC3(i, j, k)] = q2l[ACC3(i, j, k)];
                q2l[ACC3(i, j, k)] = vf[ACC3(i, j, k)];
            }
        }
    }
}

void ext_save_state_for_restart_(real_t* time, real_t* wubot, real_t* wvbot, real_t* aam2d,
                                 real_t* ua, real_t* uab, real_t* va, real_t* vab, real_t* el,
                                 real_t* elb, real_t* et, real_t* etb, real_t* egb, real_t* utb,
                                 real_t* vtb, real_t* u, real_t* ub, real_t* w, real_t* v,
                                 real_t* vb, real_t* t, real_t* tb, real_t* s, real_t* sb,
                                 real_t* rho, real_t* adx2d, real_t* ady2d, real_t* advua,
                                 real_t* advva, real_t* km, real_t* kh, real_t* kq, real_t* l,
                                 real_t* q2, real_t* q2b, real_t* aam, real_t* q2l, real_t* q2lb)
{
    FILE* fptr = fopen("fort.71", "wb");
    int data_in_bytes = sizeof(real_t) * (1 + 18 * im * jm + 19 * im * jm * kb);
    fwrite(&data_in_bytes, sizeof(int), 1, fptr);
    fwrite(time, sizeof(real_t), 1, fptr);
    fwrite(wubot, sizeof(real_t), im * jm, fptr);
    fwrite(wvbot, sizeof(real_t), im * jm, fptr);
    fwrite(aam2d, sizeof(real_t), im * jm, fptr);
    fwrite(ua, sizeof(real_t), im * jm, fptr);
    fwrite(uab, sizeof(real_t), im * jm, fptr);
    fwrite(va, sizeof(real_t), im * jm, fptr);
    fwrite(vab, sizeof(real_t), im * jm, fptr);
    fwrite(el, sizeof(real_t), im * jm, fptr);
    fwrite(elb, sizeof(real_t), im * jm, fptr);
    fwrite(et, sizeof(real_t), im * jm, fptr);
    fwrite(etb, sizeof(real_t), im * jm, fptr);
    fwrite(egb, sizeof(real_t), im * jm, fptr);
    fwrite(utb, sizeof(real_t), im * jm, fptr);
    fwrite(vtb, sizeof(real_t), im * jm, fptr);

    fwrite(u, sizeof(real_t), im * jm * kb, fptr);
    fwrite(ub, sizeof(real_t), im * jm * kb, fptr);
    fwrite(w, sizeof(real_t), im * jm * kb, fptr);
    fwrite(v, sizeof(real_t), im * jm * kb, fptr);
    fwrite(vb, sizeof(real_t), im * jm * kb, fptr);
    fwrite(t, sizeof(real_t), im * jm * kb, fptr);
    fwrite(tb, sizeof(real_t), im * jm * kb, fptr);
    fwrite(s, sizeof(real_t), im * jm * kb, fptr);
    fwrite(sb, sizeof(real_t), im * jm * kb, fptr);
    fwrite(rho, sizeof(real_t), im * jm * kb, fptr);

    fwrite(adx2d, sizeof(real_t), im * jm, fptr);
    fwrite(ady2d, sizeof(real_t), im * jm, fptr);
    fwrite(advua, sizeof(real_t), im * jm, fptr);
    fwrite(advva, sizeof(real_t), im * jm, fptr);

    fwrite(km, sizeof(real_t), im * jm * kb, fptr);
    fwrite(kh, sizeof(real_t), im * jm * kb, fptr);
    fwrite(kq, sizeof(real_t), im * jm * kb, fptr);
    fwrite(l, sizeof(real_t), im * jm * kb, fptr);
    fwrite(q2, sizeof(real_t), im * jm * kb, fptr);
    fwrite(q2b, sizeof(real_t), im * jm * kb, fptr);
    fwrite(aam, sizeof(real_t), im * jm * kb, fptr);
    fwrite(q2l, sizeof(real_t), im * jm * kb, fptr);
    fwrite(q2lb, sizeof(real_t), im * jm * kb, fptr);

    fwrite(&data_in_bytes, sizeof(int), 1, fptr);

    fclose(fptr);
}

void ext_profq_(real_t* sm, real_t* sh, real_t* dh, real_t* cc, real_t* h, real_t* etf, real_t* a,
                real_t* c, real_t* kq, real_t* dz, real_t* dzz, real_t* ee, real_t* gg,
                real_t* wusurf, real_t* wvsurf, real_t* uf, real_t* wubot, real_t* wvbot, real_t* t,
                real_t* s, real_t* zz, real_t* q2b, real_t* q2lb, real_t* l, real_t* z, real_t* km,
                real_t* u, real_t* v, real_t* kh, real_t* vf, real_t* fsm, real_t* q2, real_t* dt,
                real_t* rho, real_t* dtef, real_t* l0, real_t* gh, real_t* boygr, real_t* stf,
                real_t* prod, real_t* zmin, real_t* zmax)
{

    real_t a1 = 0.92f;
    real_t a2 = 0.74f;
    real_t b1 = 16.6f;
    real_t b2 = 10.1f;
    real_t c1 = 0.08f;
    real_t e1 = 1.8f;
    real_t e2 = 1.33f;
    real_t sef = 1.0f;
    real_t cbcnst = 100.0f;
    real_t surfl = 2e5;
    real_t shiw = 0.0f;
    real_t ghc = -6.0f;
    real_t df0;
    real_t df1;
    real_t df2;
    //   real_t * l0;
    //   real_t * gh;
    //   real_t * boygr;
    //   real_t * stf;
    //   real_t * prod;
    //   real_t * kn;

    //   l0 = (real_t*)malloc(im * jm * sizeof(real_t));
    //   gh = (real_t*)malloc(im * jm * kb * sizeof(real_t));
    //   boygr = (real_t*)malloc(im * jm * kb * sizeof(real_t));
    //   stf = (real_t*)malloc(im * jm * kb * sizeof(real_t));

    //   prod = kn = (real_t*)malloc(im * jm * kb * sizeof(real_t));
    //  kétszer kéne dtef-et hívni???
    //  real_t * dtef = cc;

    /*
      union {
        real_t prod[im*jm*kb];
        real_t kn[im*jm*kb];
      } equivalence;  //equivalence (prod,kn)
      */

    /*
          real sm(im,jm,kb),sh(im,jm,kb),cc(im,jm,kb)
          real gh(im,jm,kb),boygr(im,jm,kb),dh(im,jm),stf(im,jm,kb)
          real prod(im,jm,kb),kn(im,jm,kb)
          real a1,a2,b1,b2,c1
          real coef1,coef2,coef3,coef4,coef5
          real const1,e1,e2,ghc
          real p,sef,sp,tp
          real l0(im,jm)
          real cbcnst,surfl,shiw
          real utau2, df0,df1,df2
    C
          integer i,j,k,ki
    C
          equivalence (prod,kn)
    C
          data a1,b1,a2,b2,c1/0.92e0,16.6e0,0.74e0,10.1e0,0.08e0/
          data e1/1.8e0/,e2/1.33e0/
          data sef/1.e0/
          data cbcnst/100./surfl/2.e5/shiw/0.0/
    */
    /*       do j=1,jm
            do i=1,im
              dh(i,j)=h(i,j)+etf(i,j)
            end do
          end do
          */
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            dh[ACC2(i, j)] = h[ACC2(i, j)] + etf[ACC2(i, j)];
        }
    }

    /*       do k=2,kbm1
            do j=1,jm
              do i=1,im
                a(i,j,k)=-dti2*(kq(i,j,k+1)+kq(i,j,k)+2.e0*umol)*.5e0
         $                /(dzz(k-1)*dz(k)*dh(i,j)*dh(i,j))
                c(i,j,k)=-dti2*(kq(i,j,k-1)+kq(i,j,k)+2.e0*umol)*.5e0
         $                /(dzz(k-1)*dz(k-1)*dh(i,j)*dh(i,j))
              end do
            end do
          end do */
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                a[ACC3(i, j, k)] = -dti2 *
                                   (kq[ACC3(i, j, k + 1)] + kq[ACC3(i, j, k)] + 2.0f * umol) *
                                   0.5f / (dzz[k - 1] * dz[k] * dh[ACC2(i, j)] * dh[ACC2(i, j)]);
                c[ACC3(i, j, k)] =
                    -dti2 * (kq[ACC3(i, j, k - 1)] + kq[ACC3(i, j, k)] + 2.0f * umol) * 0.5f /
                    (dzz[k - 1] * dz[k - 1] * dh[ACC2(i, j)] * dh[ACC2(i, j)]);
            }
        }
    }

    // -- -- -- -- -- -- -- -- -- -- -
    // C
    // C     The following section solves the equation:
    // C
    // C       dti2*(kq*q2')' - q2*(2.*dti2*dtef+1.) = -q2b
    // C
    // C     Surface and bottom boundary conditions:
    // C
    real_t const1 = (powf(16.6f, (2.0f / 3.0f))) * sef;
    /*       const1=(16.6e0**(2.e0/3.e0))*sef */
    // C
    // C initialize fields that are not calculated on all boundaries
    // C but are later used there
    /*       do i=1,im
            ee(i,jm,1)=0.
            gg(i,jm,1)=0.
            l0(i,jm)=0.
          end do
          do j=1,jm
            ee(im,j,1)=0.
            gg(im,j,1)=0.
            l0(im,j)=0.
          end do
          do i=1,im
          do j=1,jm
           do k=2,kbm1
            prod(i,j,k)=0.
           end do
          end do
          end do */
    for (int i = 0; i < im; i++)
    {
        ee[ACC3(i, jmm1, 0)] = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben
                                     // 1-től, ezért k az 0
        gg[ACC3(i, jmm1, 0)] = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben
                                     // 1-től, ezért k az 0
        l0[ACC2(i, jmm1)] = 0.0f;
    }
    for (int j = 0; j < jm; j++)
    {
        ee[ACC3(imm1, j, 0)] = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben
                                     // 1-től, ezért k az 0
        gg[ACC3(imm1, j, 0)] = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben
                                     // 1-től, ezért k az 0
        l0[ACC2(imm1, j)] = 0.0f;
    }
    for (int i = 0; i < im; i++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int k = 1; k < kbm1; k++)
            {
                prod[ACC3(i, j, k)] = 0.0f;
            }
        }
    }

    /*       do j=1,jmm1
            do i=1,imm1
              utau2=sqrt((.5e0*(wusurf(i,j)+wusurf(i+1,j)))**2
         $                  +(.5e0*(wvsurf(i,j)+wvsurf(i,j+1)))**2) */
    for (int j = 0; j < jmm1; j++)
    {
        for (int i = 0; i < imm1; i++)
        {
            real_t utau2 = sqrtf((0.5f * (wusurf[ACC2(i, j)] + wusurf[ACC2(i + 1, j)])) *
                                     (0.5f * (wusurf[ACC2(i, j)] + wusurf[ACC2(i + 1, j)])) +
                                 (0.5f * (wvsurf[ACC2(i, j)] + wvsurf[ACC2(i, j + 1)])) *
                                     (0.5f * (wvsurf[ACC2(i, j)] + wvsurf[ACC2(i, j + 1)])));

            // C Wave breaking energy- a variant of Craig & Banner (1994)
            // C see Mellor and Blumberg, 2003.
            /*           ee(i,j,1)=0.e0
                      gg(i,j,1)=(15.8*cbcnst)**(2./3.)*utau2  */
            ee[ACC3(i, j, 0)] = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben
                                      // 1-től, ezért k az0
            gg[ACC3(i, j, 0)] = powf(15.8f * 100.0f, (2.0f / 3.0f)) *
                                utau2; // A k tag C-ben 0-tól számozódik, F-ben1
                                       // - től,
            // ezért k az 0 itt

            // C Surface length scale following Stacey (1999).
            /*           l0(i,j)=surfl*utau2/grav */
            l0[ACC2(i, j)] = surfl * utau2 / grav;
            /*           uf(i,j,kb)=sqrt((.5e0*(wubot(i,j)+wubot(i+1,j)))**2
                 $ +(.5e0*(wvbot(i,j)+wvbot(i,j+1)))**2)*const1 end do end do */
            uf[ACC3(i, j, kb - 1)] =
                sqrtf((0.5f * (wubot[ACC2(i, j)] + wubot[ACC2(i + 1, j)])) *
                          (0.5f * (wubot[ACC2(i, j)] + wubot[ACC2(i + 1, j)])) +
                      (0.5f * (wvbot[ACC2(i, j)] + wvbot[ACC2(i, j + 1)])) *
                          (0.5f * (wvbot[ACC2(i, j)] + wvbot[ACC2(i, j + 1)]))) *
                const1;
        }
    }

    // C
    // C    Calculate speed of sound squared:
    // C
    /*       do k=1,kbm1
            do j=1,jm
              do i=1,im
                tp=t(i,j,k)+tbias
                sp=s(i,j,k)+sbias */
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                real_t tp = t[ACC3(i, j, k)] + tbias;
                real_t sp = s[ACC3(i, j, k)] + sbias;

                // C
                // C     Calculate pressure in units of decibars:
                // C
                /*             p=grav*rhoref*(-zz(k)* h(i,j))*1.e-4
                            cc(i,j,k)=1449.1e0+.00821e0*p+4.55e0*tp
                   -.045e0*tp**2 $                 +1.34e0*(sp-35.0e0)
                            cc(i,j,k)=cc(i,j,k)
                     $                 /sqrt((1.e0-.01642e0*p/cc(i,j,k))
                     $                   *(1.e0-0.40e0*p/cc(i,j,k)**2))
                          end do
                        end do
                      end do */
                real_t p = grav * rhoref * (-zz[k] * h[ACC2(i, j)]) * (0.0001f);
                cc[ACC3(i, j, k)] =
                    1449.1f + 0.00821f * p + 4.55f * tp - 0.045f * tp * tp + 1.34f * (sp - 35.0f);
                cc[ACC3(i, j, k)] =
                    cc[ACC3(i, j, k)] /
                    sqrtf((1.0f - 0.01642f * p / cc[ACC3(i, j, k)]) *
                          (1.0f - 0.4f * p / ((cc[ACC3(i, j, k)]) * (cc[ACC3(i, j, k)]))));
            }
        }
    }
    // C
    // C     Calculate buoyancy gradient:
    // C
    /*       do k=2,kbm1
            do j=1,jm
              do i=1,im
                q2b(i,j,k)=abs(q2b(i,j,k))
                q2lb(i,j,k)=abs(q2lb(i,j,k))
                boygr(i,j,k)=grav*(rho(i,j,k-1)-rho(i,j,k))
         $                    /(dzz(k-1)* h(i,j)) */
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                q2b[ACC3(i, j, k)] = fabsf(q2b[ACC3(i, j, k)]);
                q2lb[ACC3(i, j, k)] = fabsf(q2lb[ACC3(i, j, k)]);
                boygr[ACC3(i, j, k)] = grav * (rho[ACC3(i, j, k - 1)] - rho[ACC3(i, j, k)]) /
                                           (dzz[k - 1] * h[ACC2(i, j)])

                                       // C *** NOTE: comment out next line if dens does not
                                       // include pressure
                                       /*      $
                                       +(grav**2)*2.e0/(cc(i,j,k-1)**2+cc(i,j,k)**2)
                                                 end do
                                               end do
                                             end do */
                                       + (grav * grav) * 2.0f /
                                             ((cc[ACC3(i, j, k - 1)] * cc[ACC3(i, j, k - 1)]) +
                                              cc[ACC3(i, j, k)] * cc[ACC3(i, j, k)]);
            }
        }
    }
    /*       do k=2,kbm1
          do j=1,jm
            do i=1,im
              l(i,j,k)=abs(q2lb(i,j,k)/q2b(i,j,k))
              if(z(k).gt.-0.5) l(i,j,k)=max(l(i,j,k),kappa*l0(i,j))
              gh(i,j,k)=(l(i,j,k)**2)*boygr(i,j,k)/q2b(i,j,k)
              gh(i,j,k)=min(gh(i,j,k),.028e0)
            end do
          end do
        end do */
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                l[ACC3(i, j, k)] = fabsf(q2lb[ACC3(i, j, k)] / q2b[ACC3(i, j, k)]);
                if (z[k] > -0.5f)
                    l[ACC3(i, j, k)] = fmaxf(l[ACC3(i, j, k)], kappa * l0[ACC2(i, j)]);
                gh[ACC3(i, j, k)] = (l[ACC3(i, j, k)] * l[ACC3(i, j, k)]) * boygr[ACC3(i, j, k)] /
                                    q2b[ACC3(i, j, k)];
                gh[ACC3(i, j, k)] = fminf(gh[ACC3(i, j, k)], 0.028f);
            }
        }
    }
    /*      do j=1,jm
            do i=1,im
              l(i,j,1)=kappa*l0(i,j)
              l(i,j,kb)=0.e0
              gh(i,j,1)=0.e0
              gh(i,j,kb)=0.e0
            end do
          end do */
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            l[ACC3(i, j, 0)] = kappa * l0[ACC2(i,
                                               j)]; // A k tag C-ben 0-tól számozódik,
                                                    // F-ben 1-től, ezért k az 0 itt
            l[ACC3(i, j, kb - 1)] = 0.0f;
            gh[ACC3(i, j, 0)] = 0.0f;
            // A k tag C-ben 0-tól számozódik, F-ben1 - től,
            // ezért k az 0 itt
            gh[ACC3(i, j, kb - 1)] = 0.0f;
        }
    }

    // C
    // C    Calculate production of turbulent kinetic energy:
    // C
    /*       do k=2,kbm1
            do j=2,jmm1
              do i=2,imm1
                prod(i,j,k)=km(i,j,k)*.25e0*sef
         $                   *((u(i,j,k)-u(i,j,k-1)
         $                      +u(i+1,j,k)-u(i+1,j,k-1))**2
         $                     +(v(i,j,k)-v(i,j,k-1)
         $                      +v(i,j+1,k)-v(i,j+1,k-1))**2)
         $                   /(dzz(k-1)*dh(i,j))**2 */
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 1; j < jmm1; j++)
        {
            for (int i = 1; i < imm1; i++)
            {
                prod[ACC3(i, j, k)] =
                    km[ACC3(i, j, k)] * 0.25f * sef *
                        ((u[ACC3(i, j, k)] - u[ACC3(i, j, k - 1)] + u[ACC3(i + 1, j, k)] -
                          u[ACC3(i + 1, j, k - 1)]) *
                             (u[ACC3(i, j, k)] - u[ACC3(i, j, k - 1)] + u[ACC3(i + 1, j, k)] -
                              u[ACC3(i + 1, j, k - 1)]) +
                         (v[ACC3(i, j, k)] - v[ACC3(i, j, k - 1)] + v[ACC3(i, j + 1, k)] -
                          v[ACC3(i, j + 1, k - 1)]) *
                             (v[ACC3(i, j, k)] - v[ACC3(i, j, k - 1)] + v[ACC3(i, j + 1, k)] -
                              v[ACC3(i, j + 1, k - 1)])) /
                        ((dzz[k - 1] * dh[ACC2(i, j)]) * (dzz[k - 1] * dh[ACC2(i, j)]))
                    // C   Add shear due to internal wave field
                    /*      $             -shiw*km(i,j,k)*boygr(i,j,k)
                                prod(i,j,k)=prod(i,j,k)+kh(i,j,k)*boygr(i,j,k)
                              end do
                            end do
                          end do */
                    - shiw * km[ACC3(i, j, k)] * boygr[ACC3(i, j, k)];
                prod[ACC3(i, j, k)] =
                    prod[ACC3(i, j, k)] + kh[ACC3(i, j, k)] * boygr[ACC3(i, j, k)];
            }
        }
    }
    // C
    // C  NOTE: Richardson # dep. dissipation correction (Mellor, 2001; Ezer,
    // 2000), C  depends on ghc the critical number (empirical -6 to -2) to
    // increase mixing.
    /*       ghc=-6.0e0
          do k=1,kb
            do j=1,jm
              do i=1,im
                stf(i,j,k)=1.e0 */
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                stf[ACC3(i, j, k)] = 1.0f;

                // C It is unclear yet if diss. corr. is needed when surf. waves
                // are
                // included. c           if(gh(i,j,k).lt.0.e0) c    $
                // stf(i,j,k)=1.0e0-0.9e0*(gh(i,j,k)/ghc)**1.5e0 c
                // if (gh(i, j, k).lt.ghc)
                // stf(i,j,k)=0.1e0
                /*             dtef(i,j,k)=sqrt(abs(q2b(i,j,k)))*stf(i,j,k)
                     $                   /(b1*l(i,j,k)+small)
                          end do
                        end do
                      end do */
                dtef[ACC3(i, j, k)] = sqrtf(fabsf(q2b[ACC3(i, j, k)])) * stf[ACC3(i, j, k)] /
                                      (b1 * l[ACC3(i, j, k)] + small);

                dtef[ACC3(i, j, k)] = sqrtf(fabsf(q2b[ACC3(i, j, k)])) * stf[ACC3(i, j, k)] /
                                      (b1 * l[ACC3(i, j, k)] + small);
            }
        }
    }
    /*       do k=2,kbm1
          do j=1,jm
            do i=1,im
              gg(i,j,k)=1.e0/(a(i,j,k)+c(i,j,k)*(1.e0-ee(i,j,k-1))
       $                      -(2.e0*dti2*dtef(i,j,k)+1.e0))
              ee(i,j,k)=a(i,j,k)*gg(i,j,k)
              gg(i,j,k)=(-2.e0*dti2*prod(i,j,k)+c(i,j,k)*gg(i,j,k-1)
       $                 -uf(i,j,k))*gg(i,j,k)
            end do
          end do
        end do
   */
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                gg[ACC3(i, j, k)] =
                    1.0f / (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) -
                            (2.0f * dti2 * dtef[ACC3(i, j, k)] + 1.0f));
                ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
                gg[ACC3(i, j, k)] = (-2.0f * dti2 * prod[ACC3(i, j, k)] +
                                     c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - uf[ACC3(i, j, k)]) *
                                    gg[ACC3(i, j, k)];
            }
        }
    }

    /*       do k=1,kbm1
            ki=kb-k
            do j=1,jm
              do i=1,im
                uf(i,j,ki)=ee(i,j,ki)*uf(i,j,ki+1)+gg(i,j,ki)
              end do
            end do
          end do */
    for (int k = kb - 1; k >= 0; k--)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                uf[ACC3(i, j, k)] = ee[ACC3(i, j, k)] * uf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)];
            }
        }
    }

    // C
    // C     The following section solves the equation:
    // C
    // C       dti2(kq*q2l')' - q2l*(dti2*dtef+1.) = -q2lb
    /*       do j=1,jm
            do i=1,im
              ee(i,j,2)=0.e0
              gg(i,j,2)=0.e0
              vf(i,j,kb)=0.e0
            end do
          end do */
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            ee[ACC3(i, j, 1)] = 0.0f;
            // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 1 itt
            gg[ACC3(i, j, 1)] = 0.0f;
            // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 1 itt
            vf[ACC3(i, j, kb - 1)] = 0.0f;
        }
    }

    /*       do k=2,kbm1
            do j=1,jm
              do i=1,im
                dtef(i,j,k)=dtef(i,j,k)
         $                   *(1.e0+e2*((1.e0/abs(z(k)-z(1))
         $                               +1.e0/abs(z(k)-z(kb)))
         $                                *l(i,j,k)/(dh(i,j)*kappa))**2)
                gg(i,j,k)=1.e0/(a(i,j,k)+c(i,j,k)*(1.e0-ee(i,j,k-1))
         $                      -(dti2*dtef(i,j,k)+1.e0))
                ee(i,j,k)=a(i,j,k)*gg(i,j,k)
                gg(i,j,k)=(dti2*(-prod(i,j,k)*l(i,j,k)*e1)
         $                 +c(i,j,k)*gg(i,j,k-1)-vf(i,j,k))*gg(i,j,k)
              end do
            end do
          end do */
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                dtef[ACC3(i, j, k)] =
                    dtef[ACC3(i, j, k)] *
                    (1.0f + e2 *
                                ((1.0f / fabsf(z[k] - *zmin) + 1.0f / fabsf(z[k] - *zmax)) *
                                 l[ACC3(i, j, k)] / (dh[ACC2(i, j)] * kappa)) *
                                ((1.0f / fabsf(z[k] - *zmin) + 1.0f / fabsf(z[k] - *zmax)) *
                                 l[ACC3(i, j, k)] / (dh[ACC2(i, j)] * kappa)));
                gg[ACC3(i, j, k)] =
                    1.0f / (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) -
                            (dti2 * dtef[ACC3(i, j, k)] + 1.0f));
                ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
                gg[ACC3(i, j, k)] = (dti2 * (-prod[ACC3(i, j, k)] * l[ACC3(i, j, k)] * e1) +
                                     c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - vf[ACC3(i, j, k)]) *
                                    gg[ACC3(i, j, k)];
            }
        }
    }

    /*       do k=1,kb-2
            ki=kb-k
            do j=1,jm
              do i=1,im
                vf(i,j,ki)=ee(i,j,ki)*vf(i,j,ki+1)+gg(i,j,ki)
              end do
            end do
          end do */
    for (int k = kb - 2; k >= 0; k--)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                vf[ACC3(i, j, k)] = ee[ACC3(i, j, k)] * vf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)];
            }
        }
    }

    /*       do k=2,kbm1
            do j=1,jm
              do i=1,im
                if(uf(i,j,k).le.small.or.vf(i,j,k).le.small) then
                  uf(i,j,k)=small
                  vf(i,j,k)=0.1*dt(i,j)*small
                endif
              end do
            end do
          end do */
    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                if ((uf[ACC3(i, j, k)] <= small) || (vf[ACC3(i, j, k)] <= small))
                {
                    uf[ACC3(i, j, k)] = small;
                    vf[ACC3(i, j, k)] = 0.1f * dt[ACC2(i, j)] * small;
                }
            }
        }
    }

    // C
    // C-----------------------------------------------------------------------
    // C
    // C     The following section solves for km and kh:
    // C
    /*       coef4=18.e0*a1*a1+9.e0*a1*a2
          coef5=9.e0*a1*a2 */
    real_t coef4 = 18.0f * a1 * a1 + 9.0f * a1 * a2;
    real_t coef5 = 9.0f * a1 * a2;

    // C
    // C     Note that sm and sh limit to infinity when gh approaches 0.0288:
    // C
    /*       do k=1,kb
            do j=1,jm
              do i=1,im
                coef1=a2*(1.e0-6.e0*a1/b1*stf(i,j,k))
                coef2=3.e0*a2*b2/stf(i,j,k)+18.e0*a1*a2
                coef3=a1*(1.e0-3.e0*c1-6.e0*a1/b1*stf(i,j,k))
                sh(i,j,k)=coef1/(1.e0-coef2*gh(i,j,k))
                sm(i,j,k)=coef3+sh(i,j,k)*coef4*gh(i,j,k)
                sm(i,j,k)=sm(i,j,k)/(1.e0-coef5*gh(i,j,k))
              end do
            end do
          end do */
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                real_t coef1 = a2 * (1.0f - 6.0f * a1 / b1 * stf[ACC3(i, j, k)]);
                real_t coef2 = 3.0f * a2 * b2 / stf[ACC3(i, j, k)] + 18.0f * a1 * a2;
                real_t coef3 = a1 * (1.0f - 3.0f * c1 - 6.0f * a1 / b1 * stf[ACC3(i, j, k)]);
                sh[ACC3(i, j, k)] = coef1 / (1.0f - coef2 * gh[ACC3(i, j, k)]);
                sm[ACC3(i, j, k)] = coef3 + sh[ACC3(i, j, k)] * coef4 * gh[ACC3(i, j, k)];
                sm[ACC3(i, j, k)] = sm[ACC3(i, j, k)] / (1.0f - coef5 * gh[ACC3(i, j, k)]);
            }
        }
    }

    /*       do k=1,kb
            do j=1,jm
              do i=1,im
                kn(i,j,k)=l(i,j,k)*sqrt(abs(q2(i,j,k)))
                kq(i,j,k)=(kn(i,j,k)*.41e0*sh(i,j,k)+kq(i,j,k))*.5e0
                km(i,j,k)=(kn(i,j,k)*sm(i,j,k)+km(i,j,k))*.5e0
                kh(i,j,k)=(kn(i,j,k)*sh(i,j,k)+kh(i,j,k))*.5e0
              end do
            end do
          end do */
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                prod[ACC3(i, j, k)] = l[ACC3(i, j, k)] * sqrtf(fabsf(q2[ACC3(i, j, k)]));
                kq[ACC3(i, j, k)] =
                    (prod[ACC3(i, j, k)] * 0.41f * sh[ACC3(i, j, k)] + kq[ACC3(i, j, k)]) * 0.5f;
                km[ACC3(i, j, k)] =
                    (prod[ACC3(i, j, k)] * sm[ACC3(i, j, k)] + km[ACC3(i, j, k)]) * 0.5f;
                kh[ACC3(i, j, k)] =
                    (prod[ACC3(i, j, k)] * sh[ACC3(i, j, k)] + kh[ACC3(i, j, k)]) * 0.5f;
            }
        }
    }

    // C cosmetics: make boundr. values as interior
    // C (even if not used, printout otherwise may show strange values)
    /*       do k=1,kb
            do i=1,im
               km(i,jm,k)=km(i,jmm1,k)*fsm(i,jm)
               kh(i,jm,k)=kh(i,jmm1,k)*fsm(i,jm)
               km(i,1,k)=km(i,2,k)*fsm(i,1)
               kh(i,1,k)=kh(i,2,k)*fsm(i,1)
            end do
            do j=1,jm
               km(im,j,k)=km(imm1,j,k)*fsm(im,j)
               kh(im,j,k)=kh(imm1,j,k)*fsm(im,j)
               km(1,j,k)=km(2,j,k)*fsm(1,j)
               kh(1,j,k)=kh(2,j,k)*fsm(1,j)
            end do
          end do
     */
    for (int k = 0; k < kb; k++)
    {
        for (int i = 0; i < im; i++)
        {
            km[ACC3(i, jmm1, k)] = km[ACC3(i, jmm2, k)] * fsm[ACC2(i, jmm1)];
            kh[ACC3(i, jmm1, k)] = kh[ACC3(i, jmm2, k)] * fsm[ACC2(i, jmm1)];
            km[ACC3(i, 0, k)] =
                km[ACC3(i, 1, k)] * fsm[ACC2(i,
                                             0)]; // j 0-tól számozódik C-ben, nem 1-től
            kh[ACC3(i, 0, k)] =
                kh[ACC3(i, 1, k)] * fsm[ACC2(i,
                                             0)]; // j 0-tól számozódik C-ben, nem 1-től
        }
    }

    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            km[ACC3(imm1, j, k)] = km[ACC3(imm2, j, k)] * fsm[ACC2(imm1, j)];
            kh[ACC3(imm1, j, k)] = kh[ACC3(imm2, j, k)] * fsm[ACC2(imm1, j)];
            km[ACC3(0, j, k)] =
                km[ACC3(1, j, k)] * fsm[ACC2(0,
                                             j)]; // i 0-tól számozódik C-ben, nem 1-től
            kh[ACC3(0, j, k)] =
                kh[ACC3(1, j, k)] * fsm[ACC2(0,
                                             j)]; // i 0-tól számozódik C-ben, nem 1-től
        }
    }

    // free(l0);
    // free(gh);
    // free(boygr);
    // free(stf);
    //  free(dtef);
}

void ext_proft_(real_t* f, real_t* wfsurf, real_t* fsurf, int* nbc, real_t* dh, real_t* h,
                real_t* etf, real_t* a, real_t* kh, real_t* c, real_t* z, real_t* swrad, real_t* ee,
                real_t* gg, real_t* dz, real_t* dzz, real_t* rad2)
{

    //-----------------------------------------------------------------------
    //
    //     The following section solves the equation:
    //
    //       dti2*(kh*f')'-f=-fb
    //

    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            dh[ACC2(i, j)] = h[ACC2(i, j)] + etf[ACC2(i, j)];
        }
    }

    for (int k = 0; k < kbm2; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                a[ACC3(i, j, k)] = -dti2 * (kh[ACC3(i, j, k + 1)] + umol) /
                                   (dz[k] * dzz[k] * dh[ACC2(i, j)] * dh[ACC2(i, j)]);
            }
        }
    }

    for (int k = 1; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                c[ACC3(i, j, k)] = -dti2 * (kh[ACC3(i, j, k)] + umol) /
                                   (dz[k] * dzz[k - 1] * dh[ACC2(i, j)] * dh[ACC2(i, j)]);
            }
        }
    }
    //
    //     Calculate penetrative radiation. At the bottom any unattenuated
    //     radiation is deposited in the bottom layer:
    //
    for (int k = 0; k < kb; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                rad2[ACC3(i, j, k)] = 0.0f;
            }
        }
    }

    if ((*nbc) == 2 || (*nbc) == 4)
    {

        const real_t r[5] = {0.58f, 0.62f, 0.67f, 0.77f, 0.78f};
        const real_t ad1[5] = {0.35f, 0.6f, 1.0f, 1.5f, 1.4f};
        const real_t ad2[5] = {23.0f, 20.0f, 17.0f, 14.0f, 7.9f};

        for (int k = 0; k < kbm1; k++)
        {
            for (int j = 0; j < jm; j++)
            {
                for (int i = 0; i < im; i++)
                {

                    rad2[ACC3(i, j, k)] =
                        swrad[ACC2(i, j)] *
                        (r[ntp - 1] * expf(z[k] * dh[ACC2(i, j)] / ad1[ntp - 1]) +
                         (1.0f - r[ntp - 1]) * expf(z[k] * dh[ACC2(i, j)] / ad2[ntp - 1]));
                }
            }
        }
    }

    if ((*nbc) == 1)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
                gg[ACC3(i, j, 0)] =
                    -dti2 * wfsurf[ACC2(i, j)] / (-dz[0] * dh[ACC2(i, j)]) - f[ACC3(i, j, 0)];
                gg[ACC3(i, j, 0)] = gg[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
            }
        }
    }

    else if ((*nbc) == 2)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
                gg[ACC3(i, j, 0)] =
                    dti2 * (wfsurf[ACC2(i, j)] + rad2[ACC3(i, j, 0)] - rad2[ACC3(i, j, 1)]) /
                        (dz[0] * dh[ACC2(i, j)]) -
                    f[ACC3(i, j, 0)];
                gg[ACC3(i, j, 0)] = gg[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
            }
        }
    }

    else if ((*nbc) == 3 || (*nbc) == 4)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                ee[ACC3(i, j, 0)] = 0.0f;
                gg[ACC3(i, j, 0)] = fsurf[ACC2(i, j)];
            }
        }
    }

    for (int k = 1; k < kbm2; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                gg[ACC3(i, j, k)] =
                    1.0f /
                    (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
                ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
                gg[ACC3(i, j, k)] = (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - f[ACC3(i, j, k)] +
                                     dti2 * (rad2[ACC3(i, j, k)] - rad2[ACC3(i, j, k + 1)]) /
                                         (dh[ACC2(i, j)] * dz[k])) *
                                    gg[ACC3(i, j, k)];
            }
        }
    }

    //
    //     Bottom adiabatic boundary condition:
    //
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            f[ACC3(i, j, kbm2)] =
                (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] - f[ACC3(i, j, kbm2)] +
                 dti2 * (rad2[ACC3(i, j, kbm2)] - rad2[ACC3(i, j, kb - 1)]) /
                     (dh[ACC2(i, j)] * dz[kbm2])) /
                (c[ACC3(i, j, kbm2)] * (1.0f - ee[ACC3(i, j, kbm2 - 1)]) - 1.0f);
        }
    }

    // v1 - ki = kb - 2 ....  kb - 1 - (kb-1)=0
    // v2 - ki = kb - 3 ....  kb - 1 - 1 - (kb-1)>=0

    for (int k = kb - 3; k >= 0; k--)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                f[ACC3(i, j, k)] = (ee[ACC3(i, j, k)] * f[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]);
            }
        }
    }
}

void ext_load_state_for_restart_(real_t* time, real_t* wubot, real_t* wvbot, real_t* aam2d,
                                 real_t* ua, real_t* uab, real_t* va, real_t* vab, real_t* el,
                                 real_t* elb, real_t* et, real_t* etb, real_t* egb, real_t* utb,
                                 real_t* vtb, real_t* u, real_t* ub, real_t* w, real_t* v,
                                 real_t* vb, real_t* t, real_t* tb, real_t* s, real_t* sb,
                                 real_t* rho, real_t* adx2d, real_t* ady2d, real_t* advua,
                                 real_t* advva, real_t* km, real_t* kh, real_t* kq, real_t* l,
                                 real_t* q2, real_t* q2b, real_t* aam, real_t* q2l, real_t* q2lb)
{
    FILE* fptr = fopen("fort.70", "rb");
    int data_in_bytes = sizeof(real_t) * (1 + 18 * im * jm + 19 * im * jm * kb);
    fread(&data_in_bytes, sizeof(int), 1, fptr);
    fread(time, sizeof(real_t), 1, fptr);
    fread(wubot, sizeof(real_t), im * jm, fptr);
    fread(wvbot, sizeof(real_t), im * jm, fptr);
    fread(aam2d, sizeof(real_t), im * jm, fptr);
    fread(ua, sizeof(real_t), im * jm, fptr);
    fread(uab, sizeof(real_t), im * jm, fptr);
    fread(va, sizeof(real_t), im * jm, fptr);
    fread(vab, sizeof(real_t), im * jm, fptr);
    fread(el, sizeof(real_t), im * jm, fptr);
    fread(elb, sizeof(real_t), im * jm, fptr);
    fread(et, sizeof(real_t), im * jm, fptr);
    fread(etb, sizeof(real_t), im * jm, fptr);
    fread(egb, sizeof(real_t), im * jm, fptr);
    fread(utb, sizeof(real_t), im * jm, fptr);
    fread(vtb, sizeof(real_t), im * jm, fptr);

    fread(u, sizeof(real_t), im * jm * kb, fptr);
    fread(ub, sizeof(real_t), im * jm * kb, fptr);
    fread(w, sizeof(real_t), im * jm * kb, fptr);
    fread(v, sizeof(real_t), im * jm * kb, fptr);
    fread(vb, sizeof(real_t), im * jm * kb, fptr);
    fread(t, sizeof(real_t), im * jm * kb, fptr);
    fread(tb, sizeof(real_t), im * jm * kb, fptr);
    fread(s, sizeof(real_t), im * jm * kb, fptr);
    fread(sb, sizeof(real_t), im * jm * kb, fptr);
    fread(rho, sizeof(real_t), im * jm * kb, fptr);

    fread(adx2d, sizeof(real_t), im * jm, fptr);
    fread(ady2d, sizeof(real_t), im * jm, fptr);
    fread(advua, sizeof(real_t), im * jm, fptr);
    fread(advva, sizeof(real_t), im * jm, fptr);

    fread(km, sizeof(real_t), im * jm * kb, fptr);
    fread(kh, sizeof(real_t), im * jm * kb, fptr);
    fread(kq, sizeof(real_t), im * jm * kb, fptr);
    fread(l, sizeof(real_t), im * jm * kb, fptr);
    fread(q2, sizeof(real_t), im * jm * kb, fptr);
    fread(q2b, sizeof(real_t), im * jm * kb, fptr);
    fread(aam, sizeof(real_t), im * jm * kb, fptr);
    fread(q2l, sizeof(real_t), im * jm * kb, fptr);
    fread(q2lb, sizeof(real_t), im * jm * kb, fptr);

    fread(&data_in_bytes, sizeof(int), 1, fptr);

    fclose(fptr);
}

void ext_save_2d_array_(char* fname, real_t* data, int* iint, int* iext, int* isplit)
{
    char fn[100];
    int frame = *iint * *isplit + *iext;
    // sprintf(fn, "%s_%04d_%04d.raw", fname, *iint, *iext);
    sprintf(fn, "%s_%06d.raw", fname, frame);
    FILE* fptr = fopen(fn, "wb");
    fwrite(data, sizeof(real_t), im * jm, fptr);
    fclose(fptr);
}

void ext_save_3d_array_(char* fname, real_t* data, int* iint, int* iext, int* isplit)
{
    char fn[100];
    int frame = *iint;
    // sprintf(fn,"%s_%04d_%04d.raw",fname,*iint,*iext);
    sprintf(fn, "%s_%06d.raw", fname, frame);
    FILE* fptr = fopen(fn, "wb");
    fwrite(data, sizeof(real_t), im * jm * kb, fptr);
    fclose(fptr);
}

void save_1d_array_fort_(char* fname, real_t* data, int _im)
{
    FILE* fptr = fopen(fname, "wb");
    int datasize = _im * sizeof(real_t);
    fwrite(&datasize, sizeof(int), 1, fptr);
    fwrite(data, sizeof(real_t), _im, fptr);
    fwrite(&datasize, sizeof(int), 1, fptr);
    fclose(fptr);
}

/////***** Save 2D real_t type arrays in binary form for future analysis.
///*****/////
/////***** If the file exists the new values will be appended! *****/////
/////
/////   char *fname       Destination / file name
/////   real_t *data      Pointer to the date
/////   int *_im          X size of the array (Pointer to teh value!)
/////   int *_jm          Y size of the array (Pointer to teh value!)
/////
/////*****************************************************************************/////
void save_2d_array_fort_(char* fname, real_t* data, int* _im, int* _jm)
{
    FILE* fptr = fopen(fname, "ab");
    int datasize = (*_im) * (*_jm) * sizeof(real_t);
    fwrite(&datasize, sizeof(int), 1, fptr);
    fwrite(data, sizeof(real_t), (*_im) * (*_jm), fptr);
    fwrite(&datasize, sizeof(int), 1, fptr);
    fclose(fptr);
}

/////***** Save 3D real_t type arrays in binary form for future analysis.
///*****/////
/////***** If the file exists the new values will be appended! *****/////
/////
/////   char *fname       Destination / file name
/////   real_t *data      Pointer to the date
/////   int *_im          X size of the array (Pointer to teh value!)
/////   int *_jm          Y size of the array (Pointer to teh value!)
/////   int *_kb          Z size of the array (Pointer to teh value!)
/////
/////*****************************************************************************/////
void save_3d_array_fort_(char* fname, real_t* data, int* _im, int* _jm, int* _kb)
{
    FILE* fptr = fopen(fname, "ab");
    int datasize = (*_im) * (*_jm) * (*_kb) * sizeof(real_t);
    fwrite(&datasize, sizeof(int), 1, fptr);
    fwrite(data, sizeof(real_t), (*_im) * (*_jm) * (*_kb), fptr);
    fwrite(&datasize, sizeof(int), 1, fptr);
    fclose(fptr);
}

/////***** Save 3D real_t type arrays in text form for future analysis.
///*****/////
/////***** If the file exists the new values will be appended! *****/////
/////
/////   char *fname       Destination / file name
/////   real_t *data      Pointer to the date
/////   int *_im          X size of the array (Pointer to teh value!)
/////   int *_jm          Y size of the array (Pointer to teh value!)
/////   int *_kb          Z size of the array (Pointer to teh value!)
/////
/////*****************************************************************************/////
void save_3d_array_fort2_(char* fname, real_t* data, int* _im, int* _jm, int* _kb)
{
    FILE* fptr = fopen(fname, "a");
    int num_element = (*_im) * (*_jm) * (*_kb);
    fprintf(fptr, "----- Start of printing -----\n");
    fprintf(fptr, "Datasize: %i\n", num_element);
    for (int i = 0; i < num_element; i++)
    {
        fprintf(fptr, "Data %i.: %f\n", i, data[i]);
    }
    fprintf(fptr, "----- End of printing -----\n");
    fclose(fptr);
}

/////***** Save 2D real_t type arrays in text form for future analysis.
///*****/////
/////***** If the file exists the new values will be appended! *****/////
/////
/////   char *fname       Destination / file name
/////   real_t *data      Pointer to the date
/////   int *_im          X size of the array (Pointer to teh value!)
/////   int *_jm          Y size of the array (Pointer to teh value!)
/////
/////*****************************************************************************/////
void save_2d_array_fort2_(char* fname, real_t* data, int* _im, int* _jm)
{
    FILE* fptr = fopen(fname, "a");
    int num_element = (*_im) * (*_jm);
    fprintf(fptr, "----- Start of printing -----\n");
    fprintf(fptr, "Datasize: %i\n", num_element);
    for (int i = 0; i < num_element; i++)
    {
        fprintf(fptr, "Data %i.: %f\n", i, data[i]);
    }
    fprintf(fptr, "----- End of printing -----\n");
    fclose(fptr);
}

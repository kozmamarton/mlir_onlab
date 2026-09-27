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

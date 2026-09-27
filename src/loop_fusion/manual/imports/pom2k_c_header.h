#ifndef POM2K_C_HEADER
#define POM2K_C_HEADER

#define real_t float
#define ACC2DFULL(i, j, sx, sy) ((i) + (j)*sx)
#define ACC2(i, j) ACC2DFULL(i, j, im, jm)
#define ACC3DFULL(i, j, k, sx, sy, sz) ((i) + (j)*sx + (k)*sx*sy)
#define ACC3(i, j, k) ACC3DFULL(i, j, k, im, jm, kb)

extern int im;
extern int jm;
extern int kb;
extern int imm1;
extern int jmm1;
extern int kbm1;
extern int imm2;
extern int jmm2;
extern int kbm2;

extern real_t alpha, dte, dte2, dti, dti2;
extern real_t grav, hmax, pi;
extern const real_t kappa;
extern real_t ramp, rfe, rfn, rfs;
extern real_t rfw, rhoref, sbias, slmax;
extern real_t small, tbias, time2, tprni;
extern real_t umol, vmaxl;
extern real_t horcon;

extern int iint, iprint, iskp, jskp;
extern int kl1, kl2, mode, ntp;

#ifdef __cplusplus
extern "C"
#endif
void save_3d_array_fort2_(char *fname, real_t *data, int *_im, int *_jm, int *_kb);
#ifdef __cplusplus
extern "C"
#endif
void save_3d_array_fort_(char *fname, real_t *data, int *_im, int *_jm, int *_kb);

#ifdef __cplusplus
extern "C"
#endif
void save_2d_array_fort2_(char *fname, real_t *data, int *_im, int *_jm); 
#ifdef __cplusplus
extern "C"
#endif
void save_2d_array_fort_(char *fname, real_t *data, int *_im, int *_jm); 

#endif //POM2K_C_HEADER
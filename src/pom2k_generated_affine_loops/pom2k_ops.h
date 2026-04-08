#include <map>
#include <math.h>
#include <stdio.h>
#define OPS_3D
#include "ops_seq_v2.h"
#include "pom2k_c_header.h"

/*
        dz             ,dzz            ,z              ,zz             ,
        aam2d          ,advua          ,advva          ,adx2d          ,
        ady2d          ,art            ,aru            ,arv            ,
        cbc            ,cor            ,d              ,drx2d          ,
        dry2d          ,dt             ,dum            ,dvm            ,
        dx             ,dy             ,east_c         ,east_e         ,
        east_u         ,east_v         ,e_atmos        ,egb            ,
        egf            ,el             ,elb            ,elf            ,
        et             ,etb            ,etf            ,fluxua         ,
        fluxva         ,fsm            ,h              ,north_c        ,
        north_e        ,north_u        ,north_v        ,psi            ,
        rot            ,ssurf          ,swrad          ,vfluxb         ,
        tps            ,tsurf          ,ua             ,vfluxf         ,
        uab            ,uaf            ,utb            ,utf            ,
        va             ,vab            ,vaf                            ,
        vtb            ,vtf            ,wssurf         ,wtsurf         ,
        wubot          ,wusurf         ,wvbot          ,wvsurf         ,
        dhloc          ,l0,
        aam            ,advx           ,advy           ,a              ,
        c              ,drhox          ,drhoy          ,dtef           ,
        ee             ,gg             ,kh             ,km             ,
        kq             ,l              ,q2b            ,q2             ,
        q2lb           ,q2l            ,rho            ,rmean          ,
        sb             ,sclim          ,s              ,tb             ,
        tclim          ,t              ,ub             ,uf             ,
        u              ,vb             ,vf             ,v              ,
        w              ,zflux          ,rad2            ,
        ele            ,eln            ,els            ,elw            ,
        sbe            ,sbn            ,sbs            ,sbw            ,
        tbe            ,tbn            ,tbs            ,tbw            ,
        uabe           ,uabw           ,ube            ,ubw            ,
        vabn           ,vabs           ,vbn            ,vbs
        */
ops_block block;

ops_dat d_dz, d_dzz, d_z, d_zz;

ops_dat d_aam2d, d_advua, d_advva, d_adx2d, d_ady2d, d_art, d_aru, d_arv, d_cbc, d_cor, d_d,
    d_drx2d, d_dry2d, d_dt, d_dum, d_dvm, d_dx, d_dy, d_east_c, d_east_e, d_east_u, d_east_v,
    d_e_atmos, d_egb, d_egf, d_el, d_elb, d_elf, d_et, d_etb, d_etf, d_fluxua, d_fluxva, d_fsm, d_h,
    d_north_c, d_north_e, d_north_u, d_north_v, d_psi, d_rot, d_ssurf, d_swrad, d_vfluxb, d_tps,
    d_tsurf, d_ua, d_vfluxf, d_uab, d_uaf, d_utb, d_utf, d_va, d_vab, d_vaf, d_vtb, d_vtf, d_wssurf,
    d_wtsurf, d_wubot, d_wusurf, d_wvbot, d_wvsurf, d_dhloc, d_l0, d_eta;
ops_dat d_aam, d_advx, d_advy, d_a, d_c, d_drhox, d_drhoy, d_dtef, d_ee, d_gg, d_kh, d_km, d_kq,
    d_l, d_q2b, d_q2, d_q2lb, d_q2l, d_rho, d_rmean, d_sb, d_sclim, d_s, d_tb, d_tclim, d_t, d_ub,
    d_uf, d_u, d_vb, d_vf, d_v, d_w, d_zflux, d_rad2, d_gh, d_boygr, d_stf, d_prod, d_fbmem,
    d_xmassflux, d_ymassflux, d_zwflux;

ops_dat d_ele, d_eln, d_els, d_elw, d_sbe, d_sbn, d_sbs, d_sbw, d_tbe, d_tbn, d_tbs, d_tbw, d_uabe,
    d_uabw, d_ube, d_ubw, d_vabn, d_vabs, d_vbn, d_vbs;

ops_stencil S3D_0_0_0_0_0_0;
ops_stencil S3D_0_0_0_0_0_0_STRID3D_X;
ops_stencil S3D_0_0_0_0_0_0_STRID3D_Y;
ops_stencil S3D_0_0_0_0_0_0_STRID3D_Z;
ops_stencil S3D_0_0_0_0_0_0_STRID3D_XY;
ops_stencil S3D_0_0_0_0_0_0_STRID3D_YZ;
ops_stencil S3D_0_0_0_0_0_0_STRID3D_XZ;
ops_stencil S3D_M1_0_M1_0_0_0_STRID3D_XY;
ops_stencil S3D_M1_1_M1_1_0_0_STRID3D_XY;
ops_stencil S3D_M1_0_0_0_0_0_STRID3D_XY;
ops_stencil S3D_0_0_M1_0_0_0_STRID3D_XY;
ops_stencil S3D_0_1_M1_0_0_0_STRID3D_XY;
ops_stencil S3D_M1_0_0_1_0_0_STRID3D_XY;
ops_stencil S3D_M1_0_M1_1_0_0_STRID3D_XY;
ops_stencil S3D_M1_1_M1_0_0_0_STRID3D_XY;
ops_stencil S3D_M1_1_0_0_0_0_STRID3D_XY;
ops_stencil S3D_0_1_0_0_0_0_STRID3D_XY;
ops_stencil S3D_0_0_0_1_0_0_STRID3D_XY;
ops_stencil S3D_0_0_M1_1_0_0_STRID3D_XY;
ops_stencil S3D_M1_0_M1_0_0_0;
ops_stencil S3D_0_0_0_0_M1_0;
ops_stencil S3D_M1_0_M1_0_M1_0;
ops_stencil S3D_0_0_0_0_M1_1;
ops_stencil S3D_0_1_0_0_0_0;
ops_stencil S3D_0_0_0_1_0_0;
ops_stencil S3D_0_0_M1_1_0_0;
ops_stencil S3D_M1_1_0_0_0_0;
ops_stencil S3D_0_0_0_0_0_1;
ops_stencil S3D_0_0_M1_0_M1_0;
ops_stencil S3D_M1_0_0_0_M1_0;
ops_stencil S3D_0_1_0_0_M1_0;
ops_stencil S3D_0_0_0_1_M1_0;
ops_stencil S3D_0_0_0_0_M1_0_STRID3D_Z;
ops_stencil S3D_0_0_0_0_M1_1_STRID3D_Z;
ops_stencil S3D_0_0_M1_0_0_0;
ops_stencil S3D_M1_0_0_0_0_0;
ops_stencil S3D_M1_0_0_1_0_0;
ops_stencil S3D_0_1_M1_0_0_0;
ops_stencil S3D_0_1_M1_1_0_0;
ops_stencil S3D_M1_1_0_1_0_0;

double t1, t2;

std::map<real_t*, ops_dat> datmap;

extern "C" void declare_ops_dats_(
    real_t* dz, real_t* dzz, real_t* z, real_t* zz, real_t* aam2d, real_t* advua, real_t* advva,
    real_t* adx2d, real_t* ady2d, real_t* art, real_t* aru, real_t* arv, real_t* cbc, real_t* cor,
    real_t* d, real_t* drx2d, real_t* dry2d, real_t* dt, real_t* dum, real_t* dvm, real_t* dx,
    real_t* dy, real_t* east_c, real_t* east_e, real_t* east_u, real_t* east_v, real_t* e_atmos,
    real_t* egb, real_t* egf, real_t* el, real_t* elb, real_t* elf, real_t* et, real_t* etb,
    real_t* etf, real_t* fluxua, real_t* fluxva, real_t* fsm, real_t* h, real_t* north_c,
    real_t* north_e, real_t* north_u, real_t* north_v, real_t* psi, real_t* rot, real_t* ssurf,
    real_t* swrad, real_t* vfluxb, real_t* tps, real_t* tsurf, real_t* ua, real_t* vfluxf,
    real_t* uab, real_t* uaf, real_t* utb, real_t* utf, real_t* va, real_t* vab, real_t* vaf,
    real_t* vtb, real_t* vtf, real_t* wssurf, real_t* wtsurf, real_t* wubot, real_t* wusurf,
    real_t* wvbot, real_t* wvsurf, real_t* dhloc, real_t* l0, real_t* aam, real_t* advx,
    real_t* advy, real_t* a, real_t* c, real_t* drhox, real_t* drhoy, real_t* dtef, real_t* ee,
    real_t* gg, real_t* kh, real_t* km, real_t* kq, real_t* l, real_t* q2b, real_t* q2,
    real_t* q2lb, real_t* q2l, real_t* rho, real_t* rmean, real_t* sb, real_t* sclim, real_t* s,
    real_t* tb, real_t* tclim, real_t* t, real_t* ub, real_t* uf, real_t* u, real_t* vb, real_t* vf,
    real_t* v, real_t* w, real_t* zflux, real_t* rad2, real_t* ele, real_t* eln, real_t* els,
    real_t* elw, real_t* sbe, real_t* sbn, real_t* sbs, real_t* sbw, real_t* tbe, real_t* tbn,
    real_t* tbs, real_t* tbw, real_t* uabe, real_t* uabw, real_t* ube, real_t* ubw, real_t* vabn,
    real_t* vabs, real_t* vbn, real_t* vbs, real_t* gh, real_t* boygr, real_t* stf, real_t* prod,
    real_t* eta, real_t* fbmem, real_t* xmassflux, real_t* ymassflux, real_t* zwflux)
{

    int base[] = {0, 0, 0};
    int d_m[] = {0, 0, 0}; //{-1, -1, -1};
    int d_p[] = {0, 0, 0}; //{1, 1, 1};
    int stride_k[] = {0, 0, 1};
    int size_k[] = {1, 1, kb};
    int argc = 1;
    const char* argv[] = {"pom2k"};
    ops_init(argc, argv, 3);
    block = ops_decl_block(3, "block");
    //
    //-----------------------------------------------------------------------
    //
    //     1-D arrays:
    //

    d_dz = ops_decl_dat(block, 1, size_k, base, d_m, d_p, dz, "float", "dz");
    d_dzz = ops_decl_dat(block, 1, size_k, base, d_m, d_p, dzz, "float", "dzz");
    d_z = ops_decl_dat(block, 1, size_k, base, d_m, d_p, z, "float", "z");
    d_zz = ops_decl_dat(block, 1, size_k, base, d_m, d_p, zz, "float", "zz");
    datmap[dz] = d_dz;
    datmap[dzz] = d_dzz;
    datmap[z] = d_z;
    datmap[zz] = d_zz;
    //
    //-----------------------------------------------------------------------
    //
    //     2-D arrays:
    //
    int size_ij[] = {im, jm, 1};
    d_aam2d = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, aam2d, "float", "aam2d");
    d_advua = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, advua, "float", "advua");
    d_advva = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, advva, "float", "advva");
    d_adx2d = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, adx2d, "float", "adx2d");
    d_ady2d = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, ady2d, "float", "ady2d");
    d_art = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, art, "float", "art");
    d_aru = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, aru, "float", "aru");
    d_arv = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, arv, "float", "arv");
    d_cbc = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, cbc, "float", "cbc");
    d_cor = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, cor, "float", "cor");
    d_d = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, d, "float", "d");
    d_drx2d = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, drx2d, "float", "drx2d");
    d_dry2d = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, dry2d, "float", "dry2d");
    d_dt = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, dt, "float", "dt");
    d_dum = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, dum, "float", "dum");
    d_dvm = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, dvm, "float", "dvm");
    d_dx = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, dx, "float", "dx");
    d_dy = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, dy, "float", "dy");
    d_east_c = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, east_c, "float", "east_c");
    d_east_e = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, east_e, "float", "east_e");
    d_east_u = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, east_u, "float", "east_u");
    d_east_v = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, east_v, "float", "east_v");
    d_e_atmos = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, e_atmos, "float", "e_atmos");
    d_egb = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, egb, "float", "egb");
    d_egf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, egf, "float", "egf");
    d_el = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, el, "float", "el");
    d_elb = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, elb, "float", "elb");
    d_elf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, elf, "float", "elf");
    d_et = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, et, "float", "et");
    d_etb = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, etb, "float", "etb");
    d_etf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, etf, "float", "etf");
    d_fluxua = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, fluxua, "float", "fluxua");
    d_fluxva = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, fluxva, "float", "fluxva");
    d_fsm = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, fsm, "float", "fsm");
    d_h = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, h, "float", "h");
    d_north_c = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, north_c, "float", "north_c");
    d_north_e = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, north_e, "float", "north_e");
    d_north_u = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, north_u, "float", "north_u");
    d_north_v = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, north_v, "float", "north_v");
    d_psi = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, psi, "float", "psi");
    d_rot = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, rot, "float", "rot");
    d_ssurf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, ssurf, "float", "ssurf");
    d_swrad = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, swrad, "float", "swrad");
    d_vfluxb = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, vfluxb, "float", "vfluxb");
    d_tps = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, tps, "float", "tps");
    d_tsurf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, tsurf, "float", "tsurf");
    d_ua = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, ua, "float", "ua");
    d_vfluxf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, vfluxf, "float", "vfluxf");
    d_uab = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, uab, "float", "uab");
    d_uaf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, uaf, "float", "uaf");
    d_utb = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, utb, "float", "utb");
    d_utf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, utf, "float", "utf");
    d_va = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, va, "float", "va");
    d_vab = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, vab, "float", "vab");
    d_vaf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, vaf, "float", "vaf");
    d_vtb = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, vtb, "float", "vtb");
    d_vtf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, vtf, "float", "vtf");
    d_wssurf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, wssurf, "float", "wssurf");
    d_wtsurf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, wtsurf, "float", "wtsurf");
    d_wubot = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, wubot, "float", "wubot");
    d_wusurf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, wusurf, "float", "wusurf");
    d_wvbot = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, wvbot, "float", "wvbot");
    d_wvsurf = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, wvsurf, "float", "wvsurf");
    d_dhloc = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, dhloc, "float", "dhloc");
    d_l0 = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, l0, "float", "l0");
    d_eta = ops_decl_dat(block, 1, size_ij, base, d_m, d_p, eta, "float", "eta");

    datmap[aam2d] = d_aam2d;
    datmap[advua] = d_advua;
    datmap[advva] = d_advva;
    datmap[adx2d] = d_adx2d;
    datmap[ady2d] = d_ady2d;
    datmap[art] = d_art;
    datmap[aru] = d_aru;
    datmap[arv] = d_arv;
    datmap[cbc] = d_cbc;
    datmap[cor] = d_cor;
    datmap[d] = d_d;
    datmap[drx2d] = d_drx2d;
    datmap[dry2d] = d_dry2d;
    datmap[dt] = d_dt;
    datmap[dum] = d_dum;
    datmap[dvm] = d_dvm;
    datmap[dx] = d_dx;
    datmap[dy] = d_dy;
    datmap[east_c] = d_east_c;
    datmap[east_e] = d_east_e;
    datmap[east_u] = d_east_u;
    datmap[east_v] = d_east_v;
    datmap[e_atmos] = d_e_atmos;
    datmap[egb] = d_egb;
    datmap[egf] = d_egf;
    datmap[el] = d_el;
    datmap[elb] = d_elb;
    datmap[elf] = d_elf;
    datmap[et] = d_et;
    datmap[etb] = d_etb;
    datmap[etf] = d_etf;
    datmap[fluxua] = d_fluxua;
    datmap[fluxva] = d_fluxva;
    datmap[fsm] = d_fsm;
    datmap[h] = d_h;
    datmap[north_c] = d_north_c;
    datmap[north_e] = d_north_e;
    datmap[north_u] = d_north_u;
    datmap[north_v] = d_north_v;
    datmap[psi] = d_psi;
    datmap[rot] = d_rot;
    datmap[ssurf] = d_ssurf;
    datmap[swrad] = d_swrad;
    datmap[vfluxb] = d_vfluxb;
    datmap[tps] = d_tps;
    datmap[tsurf] = d_tsurf;
    datmap[ua] = d_ua;
    datmap[vfluxf] = d_vfluxf;
    datmap[uab] = d_uab;
    datmap[uaf] = d_uaf;
    datmap[utb] = d_utb;
    datmap[utf] = d_utf;
    datmap[va] = d_va;
    datmap[vab] = d_vab;
    datmap[vaf] = d_vaf;
    datmap[vtb] = d_vtb;
    datmap[vtf] = d_vtf;
    datmap[wssurf] = d_wssurf;
    datmap[wtsurf] = d_wtsurf;
    datmap[wubot] = d_wubot;
    datmap[wusurf] = d_wusurf;
    datmap[wvbot] = d_wvbot;
    datmap[wvsurf] = d_wvsurf;
    datmap[dhloc] = d_dhloc;
    datmap[l0] = d_l0;
    datmap[eta] = d_eta;
    //
    //-----------------------------------------------------------------------
    //
    //     3-D arrays:
    //
    int size_ijk[] = {im, jm, kb};
    d_aam = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, aam, "float", "aam");
    d_advx = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, advx, "float", "advx");
    d_advy = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, advy, "float", "advy");
    d_a = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, a, "float", "a");
    d_c = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, c, "float", "c");
    d_drhox = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, drhox, "float", "drhox");
    d_drhoy = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, drhoy, "float", "drhoy");
    d_dtef = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, dtef, "float", "dtef");
    d_ee = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, ee, "float", "ee");
    d_gg = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, gg, "float", "gg");
    d_kh = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, kh, "float", "kh");
    d_km = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, km, "float", "km");
    d_kq = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, kq, "float", "kq");
    d_l = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, l, "float", "l");
    d_q2b = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, q2b, "float", "q2b");
    d_q2 = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, q2, "float", "q2");
    d_q2lb = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, q2lb, "float", "q2lb");
    d_q2l = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, q2l, "float", "q2l");
    d_rho = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, rho, "float", "rho");
    d_rmean = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, rmean, "float", "rmean");
    d_sb = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, sb, "float", "sb");
    d_sclim = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, sclim, "float", "sclim");
    d_s = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, s, "float", "s");
    d_tb = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, tb, "float", "tb");
    d_tclim = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, tclim, "float", "tclim");
    d_t = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, t, "float", "t");
    d_ub = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, ub, "float", "ub");
    d_uf = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, uf, "float", "uf");
    d_u = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, u, "float", "u");
    d_vb = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, vb, "float", "vb");
    d_vf = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, vf, "float", "vf");
    d_v = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, v, "float", "v");
    d_w = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, w, "float", "w");
    d_zflux = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, zflux, "float", "zflux");
    d_rad2 = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, rad2, "float", "rad2");
    d_gh = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, gh, "float", "gh");
    d_boygr = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, boygr, "float", "boygr");
    d_stf = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, stf, "float", "stf");
    d_prod = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, prod, "float", "prod");
    d_fbmem = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, fbmem, "float", "fbmem");
    d_xmassflux = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, xmassflux, "float", "xmassflux");
    d_ymassflux = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, ymassflux, "float", "ymassflux");
    d_zwflux = ops_decl_dat(block, 1, size_ijk, base, d_m, d_p, zwflux, "float", "zwflux");

    datmap[aam] = d_aam;
    datmap[advx] = d_advx;
    datmap[advy] = d_advy;
    datmap[a] = d_a;
    datmap[c] = d_c;
    datmap[drhox] = d_drhox;
    datmap[drhoy] = d_drhoy;
    datmap[dtef] = d_dtef;
    datmap[ee] = d_ee;
    datmap[gg] = d_gg;
    datmap[kh] = d_kh;
    datmap[km] = d_km;
    datmap[kq] = d_kq;
    datmap[l] = d_l;
    datmap[q2b] = d_q2b;
    datmap[q2] = d_q2;
    datmap[q2lb] = d_q2lb;
    datmap[q2l] = d_q2l;
    datmap[rho] = d_rho;
    datmap[rmean] = d_rmean;
    datmap[sb] = d_sb;
    datmap[sclim] = d_sclim;
    datmap[s] = d_s;
    datmap[tb] = d_tb;
    datmap[tclim] = d_tclim;
    datmap[t] = d_t;
    datmap[ub] = d_ub;
    datmap[uf] = d_uf;
    datmap[u] = d_u;
    datmap[vb] = d_vb;
    datmap[vf] = d_vf;
    datmap[v] = d_v;
    datmap[w] = d_w;
    datmap[zflux] = d_zflux;
    datmap[rad2] = d_rad2;
    datmap[gh] = d_gh;
    datmap[boygr] = d_boygr;
    datmap[stf] = d_stf;
    datmap[prod] = d_prod;
    datmap[fbmem] = d_fbmem;
    datmap[xmassflux] = d_xmassflux;
    datmap[ymassflux] = d_ymassflux;
    datmap[zwflux] = d_zwflux;
    //
    //-----------------------------------------------------------------------
    //
    //     1 and 2-D boundary value arrays:
    //

    int size_j[] = {1, jm, 1};
    int size_i[] = {im, 1, 1};
    int size_ik[] = {im, 1, kb};
    int size_jk[] = {1, jm, kb};
    d_ele = ops_decl_dat(block, 1, size_j, base, d_m, d_p, ele, "float", "ele");
    d_eln = ops_decl_dat(block, 1, size_i, base, d_m, d_p, eln, "float", "eln");
    d_els = ops_decl_dat(block, 1, size_i, base, d_m, d_p, els, "float", "els");
    d_elw = ops_decl_dat(block, 1, size_j, base, d_m, d_p, elw, "float", "elw");
    d_sbe = ops_decl_dat(block, 1, size_jk, base, d_m, d_p, sbe, "float", "sbe");
    d_sbn = ops_decl_dat(block, 1, size_ik, base, d_m, d_p, sbn, "float", "sbn");
    d_sbs = ops_decl_dat(block, 1, size_ik, base, d_m, d_p, sbs, "float", "sbs");
    d_sbw = ops_decl_dat(block, 1, size_jk, base, d_m, d_p, sbw, "float", "sbw");
    d_tbe = ops_decl_dat(block, 1, size_jk, base, d_m, d_p, tbe, "float", "tbe");
    d_tbn = ops_decl_dat(block, 1, size_ik, base, d_m, d_p, tbn, "float", "tbn");
    d_tbs = ops_decl_dat(block, 1, size_ik, base, d_m, d_p, tbs, "float", "tbs");
    d_tbw = ops_decl_dat(block, 1, size_jk, base, d_m, d_p, tbw, "float", "tbw");
    d_uabe = ops_decl_dat(block, 1, size_j, base, d_m, d_p, uabe, "float", "uabe");
    d_uabw = ops_decl_dat(block, 1, size_j, base, d_m, d_p, uabw, "float", "uabw");
    d_ube = ops_decl_dat(block, 1, size_jk, base, d_m, d_p, ube, "float", "ube");
    d_ubw = ops_decl_dat(block, 1, size_jk, base, d_m, d_p, ubw, "float", "ubw");
    d_vabn = ops_decl_dat(block, 1, size_i, base, d_m, d_p, vabn, "float", "vabn");
    d_vabs = ops_decl_dat(block, 1, size_i, base, d_m, d_p, vabs, "float", "vabs");
    d_vbn = ops_decl_dat(block, 1, size_ik, base, d_m, d_p, vbn, "float", "vbn");
    d_vbs = ops_decl_dat(block, 1, size_ik, base, d_m, d_p, vbs, "float", "vbs");
    datmap[ele] = d_ele;
    datmap[eln] = d_eln;
    datmap[els] = d_els;
    datmap[elw] = d_elw;
    datmap[sbe] = d_sbe;
    datmap[sbn] = d_sbn;
    datmap[sbs] = d_sbs;
    datmap[sbw] = d_sbw;
    datmap[tbe] = d_tbe;
    datmap[tbn] = d_tbn;
    datmap[tbs] = d_tbs;
    datmap[tbw] = d_tbw;
    datmap[uabe] = d_uabe;
    datmap[uabw] = d_uabw;
    datmap[ube] = d_ube;
    datmap[ubw] = d_ubw;
    datmap[vabn] = d_vabn;
    datmap[vabs] = d_vabs;
    datmap[vbn] = d_vbn;
    datmap[vbs] = d_vbs;

    // Stencils
    int s3D_000[] = {0, 0, 0};
    int stride3D_x[] = {1, 0, 0};
    int stride3D_y[] = {0, 1, 0};
    int stride3D_z[] = {0, 0, 1};
    S3D_0_0_0_0_0_0 = ops_decl_stencil(3, 1, s3D_000, "S3D_000");
    S3D_0_0_0_0_0_0_STRID3D_X =
        ops_decl_strided_stencil(3, 1, s3D_000, stride3D_x, "s3D_000_stride3D_x");
    S3D_0_0_0_0_0_0_STRID3D_Y =
        ops_decl_strided_stencil(3, 1, s3D_000, stride3D_y, "s3D_000_stride3D_y");
    S3D_0_0_0_0_0_0_STRID3D_Z =
        ops_decl_strided_stencil(3, 1, s3D_000, stride3D_z, "s3D_000_stride3D_z");
    int stride3D_xy[] = {1, 1, 0};
    int stride3D_yz[] = {0, 1, 1};
    int stride3D_xz[] = {1, 0, 1};
    S3D_0_0_0_0_0_0_STRID3D_XY =
        ops_decl_strided_stencil(3, 1, s3D_000, stride3D_xy, "s3D_000_stride3D_xy");
    S3D_0_0_0_0_0_0_STRID3D_YZ =
        ops_decl_strided_stencil(3, 1, s3D_000, stride3D_yz, "s3D_000_stride3D_yz");
    S3D_0_0_0_0_0_0_STRID3D_XZ =
        ops_decl_strided_stencil(3, 1, s3D_000, stride3D_xz, "s3D_000_stride3D_xz");

    int s3D_M1_0_M1_0_0_0[] = {-1, -1, 0, 0, 0, 0};
    S3D_M1_0_M1_0_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 2, s3D_M1_0_M1_0_0_0, stride3D_xy,
                                                            "s3D_M1_0_M1_0_0_0_stride3D_xy");
    int s3D_M1_1_M1_1_0_0[] = {-1, -1, 0, 1, 1, 0, 0, 0, 0};
    S3D_M1_1_M1_1_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 3, s3D_M1_1_M1_1_0_0, stride3D_xy,
                                                            "s3D_M1_1_M1_1_0_0_stride3D_xy");
    int s3D_M1_0_0_0_0_0[] = {-1, 0, 0, 0, 0, 0};
    S3D_M1_0_0_0_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 2, s3D_M1_0_0_0_0_0, stride3D_xy,
                                                           "s3D_M1_0_0_0_0_0_stride3D_xy");
    int s3D_0_0_M1_0_0_0[] = {
        0, -1, 0, 0, 0, 0,
    };
    S3D_0_0_M1_0_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 2, s3D_0_0_M1_0_0_0, stride3D_xy,
                                                           "s3D_0_0_M1_0_0_0_stride3D_xy");
    int s3D_0_1_M1_0_0_0[] = {1, 0, 0, 0, -1, 0, 0, 0, 0};
    S3D_0_1_M1_0_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 3, s3D_0_1_M1_0_0_0, stride3D_xy,
                                                           "s3D_0_1_M1_0_0_0_stride3D_xy");
    int s3D_M1_0_0_1_0_0[] = {-1, 0, 0, 0, 1, 0, 0, 0, 0};
    S3D_M1_0_0_1_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 3, s3D_M1_0_0_1_0_0, stride3D_xy,
                                                           "s3D_M1_0_0_1_0_0_stride3D_xy");

    int s3D_M1_0_M1_1_0_0[] = {-1, -1, 0, 0, 1, 0, 0, 0, 0};
    S3D_M1_0_M1_1_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 3, s3D_M1_0_M1_1_0_0, stride3D_xy,
                                                            "s3D_M1_0_M1_1_0_0_stride3D_xy");
    int S3D_M1_1_M1_0_0_0[] = {-1, -1, 0, 1, 0, 0, 0, 0, 0};
    S3D_M1_1_M1_0_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 3, S3D_M1_1_M1_0_0_0, stride3D_xy,
                                                            "S3D_M1_1_M1_0_0_0_stride3D_xy");

    int s3D_M1_1_0_0_0_0[] = {-1, 0, 0, 1, 0, 0, 0, 0, 0};
    S3D_M1_1_0_0_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 3, s3D_M1_1_0_0_0_0, stride3D_xy,
                                                           "s3D_M1_1_0_0_0_0_stride3D_xy");
    int s3D_0_1_0_0_0_0[] = {1, 0, 0, 0, 0, 0};
    S3D_0_1_0_0_0_0_STRID3D_XY =
        ops_decl_strided_stencil(3, 2, s3D_0_1_0_0_0_0, stride3D_xy, "s3D_0_1_0_0_0_0_stride3D_xy");
    int s3D_0_0_0_1_0_0[] = {0, 1, 0, 0, 0, 0};
    S3D_0_0_0_1_0_0_STRID3D_XY =
        ops_decl_strided_stencil(3, 2, s3D_0_0_0_1_0_0, stride3D_xy, "s3D_0_0_0_1_0_0_stride3D_xy");
    int s3D_0_0_M1_1_0_0[] = {0, -1, 0, 0, 1, 0, 0, 0, 0};
    S3D_0_0_M1_1_0_0_STRID3D_XY = ops_decl_strided_stencil(3, 3, s3D_0_0_M1_1_0_0, stride3D_xy,
                                                           "s3D_0_0_M1_1_0_0_stride3D_xy");

    S3D_M1_0_M1_0_0_0 = ops_decl_stencil(3, 1, s3D_M1_0_M1_0_0_0, "s3D_M1_0_M1_0_0_0");
    int s3D_0_0_0_0_M1_0[] = {0, 0, -1, 0, 0, 0};
    S3D_0_0_0_0_M1_0 = ops_decl_stencil(3, 2, s3D_0_0_0_0_M1_0, "s3D_0_0_0_0_M1_0");
    int s3D_M1_0_M1_0_M1_0[] = {-1, -1, -1, 0, 0, 0};
    S3D_M1_0_M1_0_M1_0 = ops_decl_stencil(3, 2, s3D_M1_0_M1_0_M1_0, "s3D_M1_0_M1_0_M1_0");
    int s3D_0_0_0_0_M1_1[] = {0, 0, -1, 0, 0, 1, 0, 0, 0};
    S3D_0_0_0_0_M1_1 = ops_decl_stencil(3, 2, s3D_0_0_0_0_M1_1, "s3D_0_0_0_0_M1_1");
    S3D_0_1_0_0_0_0 = ops_decl_stencil(3, 1, s3D_0_1_0_0_0_0, "s3D_0_1_0_0_0_0");
    S3D_0_0_0_1_0_0 = ops_decl_stencil(3, 1, s3D_0_0_0_1_0_0, "s3D_0_0_0_1_0_0");
    S3D_0_0_M1_1_0_0 = ops_decl_stencil(3, 3, s3D_0_0_M1_1_0_0, "s3D_0_0_M1_1_0_0");
    S3D_M1_1_0_0_0_0 = ops_decl_stencil(3, 3, s3D_M1_1_0_0_0_0, "s3D_M1_1_0_0_0_0");
    int s3D_0_0_0_0_0_1[] = {0, 0, 0, 0, 0, 1};
    S3D_0_0_0_0_0_1 = ops_decl_stencil(3, 2, s3D_0_0_0_0_0_1, "s3D_0_0_0_0_0_1");
    int s3D_0_1_M1_1_0_0[] = {0, -1, 0, 0, 0, 0, 1, 1, 0};
    S3D_0_1_M1_1_0_0 = ops_decl_stencil(3, 3, s3D_0_1_M1_1_0_0, "s3D_0_1_M1_1_0_0");
    int s3D_M1_1_0_1_0_0[] = {-1, 0, 0, 0, 0, 0, 1, 1, 0};
    S3D_M1_1_0_1_0_0 = ops_decl_stencil(3, 3, s3D_M1_1_0_1_0_0, "s3D_M1_1_0_1_0_0");

    int s3D_0_0_M1_0_M1_0[] = {0, -1, -1, 0, 0, 0};
    S3D_0_0_M1_0_M1_0 = ops_decl_stencil(3, 2, s3D_0_0_M1_0_M1_0, "s3D_0_0_M1_0_M1_0");
    int s3D_M1_0_0_0_M1_0[] = {-1, 0, -1, 0, 0, 0};
    S3D_M1_0_0_0_M1_0 = ops_decl_stencil(3, 2, s3D_M1_0_0_0_M1_0, "s3D_M1_0_0_0_M1_0");

    int s3D_0_1_0_0_M1_0[] = {0, 0, -1, 1, 0, 0, 0, 0, 0};
    S3D_0_1_0_0_M1_0 = ops_decl_stencil(3, 2, s3D_0_1_0_0_M1_0, "s3D_0_1_0_0_M1_0");
    int s3D_0_0_0_1_M1_0[] = {0, 0, -1, 0, 1, 0, 0, 0, 0};
    S3D_0_0_0_1_M1_0 = ops_decl_stencil(3, 2, s3D_0_0_0_1_M1_0, "s3D_0_0_0_1_M1_0");
    S3D_0_0_0_0_M1_0_STRID3D_Z =
        ops_decl_strided_stencil(3, 2, s3D_0_0_0_0_M1_0, stride3D_z, "s3D_0_0_0_0_M1_0_STRID3D_Z");
    S3D_0_0_0_0_M1_1_STRID3D_Z =
        ops_decl_strided_stencil(3, 3, s3D_0_0_0_0_M1_1, stride3D_z, "s3D_0_0_0_0_M1_1_STRID3D_Z");

    S3D_0_0_M1_0_0_0 = ops_decl_stencil(3, 2, s3D_0_0_M1_0_0_0, "s3D_0_0_M1_0_0_0");
    S3D_M1_0_0_0_0_0 = ops_decl_stencil(3, 2, s3D_M1_0_0_0_0_0, "s3D_M1_0_0_0_0_0");
    S3D_M1_0_0_1_0_0 = ops_decl_stencil(3, 3, s3D_M1_0_0_1_0_0, "s3D_M1_0_0_1_0_0");
    S3D_0_1_M1_0_0_0 = ops_decl_stencil(3, 3, s3D_0_1_M1_0_0_0, "s3D_0_1_M1_0_0_0");

    ops_partition("");
    ops_diagnostic_output();
    double c1;
    ops_timers(&c1, &t1);
}

ops_dat get_dat(real_t* ptr)
{
    return datmap[ptr];
}

extern "C" void ops_stop_()
{
    double c1;
    ops_timers(&c1, &t2);
    ops_printf("Max total runtime: %g seconds\n", t2 - t1);
    ops_timing_output(std::cout);
    ops_exit();
}
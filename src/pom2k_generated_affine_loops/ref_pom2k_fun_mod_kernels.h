
void ext_bcond_5_0(ACC<float>& w, const ACC<float>& fsm)
{
    // fsm masks w over land! (fsm=0)
    w(0, 0, 0) = w(0, 0, 0) * fsm(0, 0, 0);
}

void ext_adjust_u_v_0(ACC<float>& tps)
{
    tps(0, 0, 0) = 0.0f;
}

void ext_adjust_u_v_1(ACC<float>& tps, const ACC<float>& u, const ACC<float>& dz)
{
    tps(0, 0, 0) = tps(0, 0, 0) + u(0, 0, 0) * dz(0, 0, 0);
}

void ext_adjust_u_v_2(const ACC<float>& tps, ACC<float>& u, const ACC<float>& utb,
                      const ACC<float>& utf, const ACC<float>& dt)
{
    u(0, 0, 0) =
        (u(0, 0, 0) - tps(0, 0, 0)) + (utb(0, 0, 0) + utf(0, 0, 0)) / (dt(0, 0, 0) + dt(-1, 0, 0));
}

void ext_adjust_u_v_3(ACC<float>& tps)
{
    tps(0, 0, 0) = 0.0f;
}

void ext_adjust_u_v_4(ACC<float>& tps, const ACC<float>& v, const ACC<float>& dz)
{
    tps(0, 0, 0) = tps(0, 0, 0) + v(0, 0, 0) * dz(0, 0, 0);
}

void ext_adjust_u_v_5(const ACC<float>& tps, ACC<float>& v, const ACC<float>& vtb,
                      const ACC<float>& vtf, const ACC<float>& dt)
{
    v(0, 0, 0) =
        (v(0, 0, 0) - tps(0, 0, 0)) + (vtb(0, 0, 0) + vtf(0, 0, 0)) / (dt(0, 0, 0) + dt(0, -1, 0));
}

void ext_init_internal_0(ACC<float>& e_atmos, ACC<float>& vfluxf, ACC<float>& w, ACC<float>& wtsurf,
                         ACC<float>& wssurf, ACC<float>& swrad, const float* tbias,
                         const float* sbias, const ACC<float>& t, const ACC<float>& s,
                         const int* iproblem, ACC<float>& wusurf, ACC<float>& wvsurf,
                         const ACC<float>& dvm, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    real_t satm, tatm;
    if (*iproblem != 3)
    { // constant wind read in file2ic

        //            wusurf(i,j)=ramp*(1.e-4*cos(pi*(j-1)/jmm1))
        wusurf(0, 0, 0) = 1.0f * (1.e-4f * cosf(pi * (float)(j) / (float)jmm1)) * .25f *
                          (dvm(0, 1, 0) + dvm(-1, 1, 0) + dvm(-1, 0, 0) + dvm(0, 0, 0));
        // C --- no wind ----
        // c           wusurf(i,j)=0.0f
        wvsurf(0, 0, 0) = 0.0f;
    }
    e_atmos(0, 0, 0) = 0.0f;
    vfluxf(0, 0, 0) = 0.0f;
    // C
    // C     Set w(i,j,1)=vflux(i,j).ne.0 if one wishes non-zero flow across
    // C     the sea surface. See calculation of elf(i,j) below and
    // subroutines C     vertvl, advt1 (or advt2). If w(1,j,1)=0, and,
    // additionally, there C     is no net flow across lateral boundaries, the
    // basin volume will be C     constant; if also vflux(i,j).ne.0, then, for
    // example, the average C     salinity will change and, unrealistically,
    // so will total salt.
    // C
    w(0, 0, 0) = vfluxf(0, 0, 0);
    // C
    // C     Set wtsurf to the sensible heat, the latent heat (which involves
    // C     only the evaporative component of vflux) and the long wave
    // C     radiation:
    // C
    wtsurf(0, 0, 0) = 0.0;
    // C
    // C     Set swrad to the short wave radiation:
    // C
    swrad(0, 0, 0) = 0.0;
    // C
    // C     To account for change in temperature of flow crossing the sea
    // C     surface (generally quite small compared to latent heat effect)
    // C
    tatm = t(0, 0, 0) + *tbias; // an approximation
    wtsurf(0, 0, 0) = wtsurf(0, 0, 0) + vfluxf(0, 0, 0) * (tatm - t(0, 0, 0) - *tbias);
    // C
    // C     Set the salinity of water vapor/precipitation which enters/leaves
    // C     the atmosphere (or e.g., an ice cover)
    // C
    satm = 0.0f;
    wssurf(0, 0, 0) = vfluxf(0, 0, 0) * (satm - s(0, 0, 0) - *sbias);
}

void ext_advt1_0(ACC<float>& fb, ACC<float>& f)
{
    f(0, 0, kbm1) = f(0, 0, kbm2);
    fb(0, 0, kbm1) = fb(0, 0, kbm2);
}

void ext_advt1_1(const ACC<float>& f, ACC<float>& xflux, ACC<float>& yflux, const ACC<float>& u,
                 const ACC<float>& v, const ACC<float>& dt)
{
    xflux(0, 0, 0) =
        0.25f * ((dt(0, 0, 0) + dt(-1, 0, 0)) * (f(0, 0, 0) + f(-1, 0, 0)) * u(0, 0, 0));
    yflux(0, 0, 0) =
        0.25f * ((dt(0, 0, 0) + dt(0, -1, 0)) * (f(0, 0, 0) + f(0, -1, 0)) * v(0, 0, 0));
}

void ext_advt1_2(ACC<float>& fb, const ACC<float>& fclim)
{
    fb(0, 0, 0) = fb(0, 0, 0) - fclim(0, 0, 0);
}

void ext_advt1_3(const ACC<float>& fb, const ACC<float>& aam, const ACC<float>& dum,
                 const ACC<float>& dvm, const ACC<float>& dx, ACC<float>& xflux,
                 const ACC<float>& dy, const ACC<float>& h, ACC<float>& yflux)
{
    xflux(0, 0, 0) -= 0.5f * (aam(0, 0, 0) + aam(-1, 0, 0)) * (h(0, 0, 0) + h(-1, 0, 0)) * tprni *
                      (fb(0, 0, 0) - fb(-1, 0, 0)) * dum(0, 0, 0) / (dx(0, 0, 0) + dx(-1, 0, 0));
    yflux(0, 0, 0) -= 0.5f * (aam(0, 0, 0) + aam(0, -1, 0)) * (h(0, 0, 0) + h(0, -1, 0)) * tprni *
                      (fb(0, 0, 0) - fb(0, -1, 0)) * dvm(0, 0, 0) / (dy(0, 0, 0) + dy(0, -1, 0));
    xflux(0, 0, 0) = 0.5f * (dy(0, 0, 0) + dy(-1, 0, 0)) * xflux(0, 0, 0);
    yflux(0, 0, 0) = 0.5f * (dx(0, 0, 0) + dx(0, -1, 0)) * yflux(0, 0, 0);
}

void ext_advt1_4(ACC<float>& fb, const ACC<float>& fclim)
{
    fb(0, 0, 0) += fclim(0, 0, 0);
}

void ext_advt1_5(const ACC<float>& f, ACC<float>& zflux, const ACC<float>& w, const ACC<float>& art)
{
    zflux(0, 0, 0) = f(0, 0, 0) * w(0, 0, 0) * art(0, 0, 0);
    zflux(0, 0, kbm1) = 0.0f;
}

void ext_advt1_6(const ACC<float>& f, ACC<float>& zflux, const ACC<float>& w, const ACC<float>& art)
{
    zflux(0, 0, 0) = 0.5f * (f(0, 0, -1) + f(0, 0, 0)) * w(0, 0, 0) * art(0, 0, 0);
}

void ext_advt1_7(const ACC<float>& fb, const ACC<float>& etf, ACC<float>& ff,
                 const ACC<float>& xflux, const ACC<float>& yflux, const ACC<float>& zflux,
                 const ACC<float>& dz, const ACC<float>& h, const ACC<float>& art,
                 const ACC<float>& etb)
{
    ff(0, 0, 0) = xflux(1, 0, 0) - xflux(0, 0, 0) + yflux(0, 1, 0) - yflux(0, 0, 0) +
                  (zflux(0, 0, 0) - zflux(0, 0, 1)) / dz(0, 0, 0);

    ff(0, 0, 0) = (fb(0, 0, 0) * (h(0, 0, 0) + etb(0, 0, 0)) * art(0, 0, 0) - dti2 * ff(0, 0, 0)) /
                  ((h(0, 0, 0) + etf(0, 0, 0)) * art(0, 0, 0));
}

void ext_flux_update_0(ACC<float>& fluxua, ACC<float>& fluxva, const ACC<float>& d,
                       const ACC<float>& dy, const ACC<float>& dx, const ACC<float>& ua,
                       const ACC<float>& va)
{
    fluxua(0, 0, 0) =
        0.25f * (d(0, 0, 0) + d(-1, 0, 0)) * (dy(0, 0, 0) + dy(-1, 0, 0)) * ua(0, 0, 0);
    fluxva(0, 0, 0) =
        0.25f * (d(0, 0, 0) + d(0, -1, 0)) * (dx(0, 0, 0) + dx(0, -1, 0)) * va(0, 0, 0);
}

void ext_time_internal_forward_0(ACC<float>& egf, const ACC<float>& el, const float* ispi)
{
    egf(0, 0, 0) = el(0, 0, 0) * (*ispi);
}

void ext_time_internal_forward_1(ACC<float>& utf, const ACC<float>& ua, const ACC<float>& d,
                                 const float* isp2i)
{
    utf(0, 0, 0) = ua(0, 0, 0) * (d(0, 0, 0) + d(-1, 0, 0)) * (*isp2i);
}

void ext_time_internal_forward_2(const ACC<float>& d, const float* isp2i, ACC<float>& vtf,
                                 const ACC<float>& va)
{
    vtf(0, 0, 0) = va(0, 0, 0) * (d(0, 0, 0) + d(0, -1, 0)) * (*isp2i);
}

void ext_advq_0(const ACC<float>& q, ACC<float>& xflux, ACC<float>& yflux, const ACC<float>& dt,
                const ACC<float>& u, const ACC<float>& v)
{
    xflux(0, 0, 0) = 0.125f * (q(0, 0, 0) + q(-1, 0, 0)) * (dt(0, 0, 0) + dt(-1, 0, 0)) *
                     (u(0, 0, 0) + u(0, 0, -1));
    yflux(0, 0, 0) = 0.125f * (q(0, 0, 0) + q(0, -1, 0)) * (dt(0, 0, 0) + dt(0, -1, 0)) *
                     (v(0, 0, 0) + v(0, 0, -1));
}

void ext_advq_1(const ACC<float>& qb, const ACC<float>& dum, const ACC<float>& dx,
                ACC<float>& xflux, const ACC<float>& dvm, const ACC<float>& dy, ACC<float>& yflux,
                const ACC<float>& aam, const ACC<float>& h)
{
    // dum masks xflux over land (dum=0)!
    xflux(0, 0, 0) -=
        dum(0, 0, 0) * 0.25f * (aam(0, 0, 0) + aam(-1, 0, 0) + aam(0, 0, -1) + aam(-1, 0, -1)) *
        (h(0, 0, 0) + h(-1, 0, 0)) * (qb(0, 0, 0) - qb(-1, 0, 0)) / (dx(0, 0, 0) + dx(-1, 0, 0));

    // dvm masks yflux over land (dvm=0)!
    yflux(0, 0, 0) -=
        dvm(0, 0, 0) * 0.25f * (aam(0, 0, 0) + aam(0, -1, 0) + aam(0, 0, -1) + aam(0, -1, -1)) *
        (h(0, 0, 0) + h(0, -1, 0)) * (qb(0, 0, 0) - qb(0, -1, 0)) / (dy(0, 0, 0) + dy(0, -1, 0));

    xflux(0, 0, 0) *= 0.5f * (dy(0, 0, 0) + dy(-1, 0, 0));
    yflux(0, 0, 0) *= 0.5f * (dx(0, 0, 0) + dx(0, -1, 0));
}

void ext_advq_2(const ACC<float>& qb, const ACC<float>& q, ACC<float>& qf, const ACC<float>& xflux,
                const ACC<float>& yflux, const ACC<float>& w, const ACC<float>& dz,
                const ACC<float>& art, const ACC<float>& etb, const ACC<float>& h,
                const ACC<float>& etf)
{
    qf(0, 0, 0) = (w(0, 0, -1) * q(0, 0, -1) - w(0, 0, 1) * q(0, 0, 1)) * art(0, 0, 0) /
                      (dz(0, 0, 0) + dz(0, 0, 0 - 1)) +
                  xflux(1, 0, 0) - xflux(0, 0, 0) + yflux(0, 1, 0) - yflux(0, 0, 0);
    qf(0, 0, 0) = ((h(0, 0, 0) + etb(0, 0, 0)) * art(0, 0, 0) * qb(0, 0, 0) - (dti2)*qf(0, 0, 0)) /
                  ((h(0, 0, 0) + etf(0, 0, 0)) * art(0, 0, 0));
}

void ext_etf_0(const float* smoth, ACC<float>& etf, const ACC<float>& elf)
{
    etf(0, 0, 0) = .25f * *smoth * elf(0, 0, 0);
}

void ext_etf_1(const float* smoth, ACC<float>& etf, const ACC<float>& elf)
{
    etf(0, 0, 0) = etf(0, 0, 0) + .5f * (1.0f - .5f * *smoth) * elf(0, 0, 0);
}

void ext_etf_2(ACC<float>& etf, const ACC<float>& elf, const ACC<float>& fsm)
{
    etf(0, 0, 0) = (etf(0, 0, 0) + .5f * elf(0, 0, 0)) * fsm(0, 0, 0);
}

void ext_proft_0(ACC<float>& dh, const ACC<float>& h, const ACC<float>& etf)
{
    dh(0, 0, 0) = h(0, 0, 0) + etf(0, 0, 0);
}

void ext_proft_1(const ACC<float>& dh, const ACC<float>& dz, const ACC<float>& dzz, ACC<float>& a,
                 const ACC<float>& kh)
{
    a(0, 0, 0) =
        -dti2 * (kh(0, 0, 1) + umol) / (dz(0, 0, 0) * dzz(0, 0, 0) * dh(0, 0, 0) * dh(0, 0, 0));
}

void ext_proft_2(const ACC<float>& dh, const ACC<float>& dz, const ACC<float>& dzz,
                 const ACC<float>& kh, ACC<float>& c)
{
    c(0, 0, 0) =
        -dti2 * (kh(0, 0, 0) + umol) / (dz(0, 0, 0) * dzz(0, 0, 0 - 1) * dh(0, 0, 0) * dh(0, 0, 0));
}

void ext_proft_3(ACC<float>& rad2)
{
    rad2(0, 0, 0) = 0.0f;
}

void ext_proft_4(const ACC<float>& z, const ACC<float>& swrad, const ACC<float>& dh,
                 ACC<float>& rad2)
{
    real_t r[5] = {0.58f, 0.62f, 0.67f, 0.77f, 0.78f};
    real_t ad1[5] = {0.35f, 0.6f, 1.0f, 1.5f, 1.4f};
    real_t ad2[5] = {23.0f, 20.0f, 17.0f, 14.0f, 7.9f};
    rad2(0, 0, 0) =
        swrad(0, 0, 0) * (r[ntp - 1] * expf(z(0, 0, 0) * dh(0, 0, 0) / ad1[ntp - 1]) +
                          (1.0f - r[ntp - 1]) * expf(z(0, 0, 0) * dh(0, 0, 0) / ad2[ntp - 1]));
}

void ext_proft_5(const ACC<float>& f, const ACC<float>& wfsurf, ACC<float>& ee,
                 const ACC<float>& dh, const ACC<float>& dz, const ACC<float>& a, ACC<float>& gg)
{
    ee(0, 0, 0) = a(0, 0, 0) / (a(0, 0, 0) - 1.0f);
    gg(0, 0, 0) = -dti2 * wfsurf(0, 0, 0) / (-dz(0, 0, 0) * dh(0, 0, 0)) - f(0, 0, 0);
    gg(0, 0, 0) = gg(0, 0, 0) / (a(0, 0, 0) - 1.0f);
}

void ext_proft_6(const ACC<float>& f, const ACC<float>& wfsurf, ACC<float>& ee,
                 const ACC<float>& dh, const ACC<float>& dz, const ACC<float>& a,
                 const ACC<float>& rad2, ACC<float>& gg)
{
    ee(0, 0, 0) = a(0, 0, 0) / (a(0, 0, 0) - 1.0f);
    gg(0, 0, 0) =
        dti2 * (wfsurf(0, 0, 0) + rad2(0, 0, 0) - rad2(0, 0, 1)) / (dz(0, 0, 0) * dh(0, 0, 0)) -
        f(0, 0, 0);
    gg(0, 0, 0) = gg(0, 0, 0) / (a(0, 0, 0) - 1.0f);
}

void ext_proft_7(const ACC<float>& fsurf, ACC<float>& ee, ACC<float>& gg)
{
    ee(0, 0, 0) = 0.0f;
    gg(0, 0, 0) = fsurf(0, 0, 0);
}

void ext_proft_8(const ACC<float>& f, ACC<float>& ee, ACC<float>& gg, const ACC<float>& dh,
                 const ACC<float>& dz, const ACC<float>& a, const ACC<float>& rad2,
                 const ACC<float>& c)
{
    gg(0, 0, 0) = 1.0f / (a(0, 0, 0) + c(0, 0, 0) * (1.0f - ee(0, 0, -1)) - 1.0f);
    ee(0, 0, 0) = a(0, 0, 0) * gg(0, 0, 0);
    gg(0, 0, 0) = (c(0, 0, 0) * gg(0, 0, -1) - f(0, 0, 0) +
                   dti2 * (rad2(0, 0, 0) - rad2(0, 0, 1)) / (dh(0, 0, 0) * dz(0, 0, 0))) *
                  gg(0, 0, 0);
}

void ext_proft_9(ACC<float>& f, const ACC<float>& ee, const ACC<float>& gg, const ACC<float>& dh,
                 const ACC<float>& dz, const ACC<float>& rad2, const ACC<float>& c)
{
    f(0, 0, kbm1 - 1) =
        (c(0, 0, kbm1 - 1) * gg(0, 0, kbm2 - 1) - f(0, 0, kbm1 - 1) +
         dti2 * (rad2(0, 0, kbm1 - 1) - rad2(0, 0, kb - 1)) / (dh(0, 0, 0) * dz(0, 0, kbm1 - 1))) /
        (c(0, 0, kbm1 - 1) * (1.0f - ee(0, 0, kbm2 - 1)) - 1.0f);
}

void ext_proft_10(ACC<float>& f, const ACC<float>& ee, const ACC<float>& gg)
{
    f(0, 0, 0) = (ee(0, 0, 0) * f(0, 0, 1) + gg(0, 0, 0));
}

void ext_profu_0(ACC<float>& dhloc)
{
    dhloc(0, 0, 0) = 1.0f;
}

void ext_profu_1(const ACC<float>& h, const ACC<float>& etf, ACC<float>& dhloc)
{
    dhloc(0, 0, 0) = (h(0, 0, 0) + etf(0, 0, 0) + h(-1, 0, 0) + etf(-1, 0, 0)) * 0.5f;
}

void ext_profu_2(ACC<float>& c, const ACC<float>& km)
{
    c(0, 0, 0) = (km(0, 0, 0) + km(-1, 0, 0)) * 0.5f;
}

void ext_profu_3(const ACC<float>& c, ACC<float>& a, const ACC<float>& dz, const ACC<float>& dzz,
                 const ACC<float>& dhloc)
{
    a(0, 0, 0) = -(dti2) * (c(0, 0, 1) + umol) /
                 (dz(0, 0, 0) * dzz(0, 0, 0) * dhloc(0, 0, 0) * dhloc(0, 0, 0));
}

void ext_profu_4(ACC<float>& c, const ACC<float>& dz, const ACC<float>& dzz,
                 const ACC<float>& dhloc)
{
    c(0, 0, 0) = -(dti2) * (c(0, 0, 0) + umol) /
                 (dz(0, 0, 0) * dzz(0, 0, 0 - 1) * dhloc(0, 0, 0) * dhloc(0, 0, 0));
}

void ext_profu_5(const ACC<float>& uf, const ACC<float>& a, const ACC<float>& dz, ACC<float>& ee,
                 const ACC<float>& dhloc, const ACC<float>& wusurf, ACC<float>& gg)
{
    ee(0, 0, 0) = a(0, 0, 0) / (a(0, 0, 0) - 1.0f);
    gg(0, 0, 0) = (-(dti2)*wusurf(0, 0, 0) / (-dz(0, 0, 0) * dhloc(0, 0, 0)) - uf(0, 0, 0)) /
                  (a(0, 0, 0) - 1.0f);
}

void ext_profu_6(const ACC<float>& uf, const ACC<float>& c, const ACC<float>& a, ACC<float>& ee,
                 ACC<float>& gg)
{
    gg(0, 0, 0) = 1.0f / (a(0, 0, 0) + c(0, 0, 0) * (1.0f - ee(0, 0, -1)) - 1.0f);
    ee(0, 0, 0) = a(0, 0, 0) * gg(0, 0, 0);
    gg(0, 0, 0) = (c(0, 0, 0) * gg(0, 0, -1) - uf(0, 0, 0)) * gg(0, 0, 0);
}

void ext_profu_7(ACC<float>& uf, ACC<float>& tps, const ACC<float>& cbc, const ACC<float>& ub,
                 const ACC<float>& vb, const ACC<float>& dz, const ACC<float>& ee,
                 const ACC<float>& c, const ACC<float>& gg, const ACC<float>& dhloc,
                 const ACC<float>& dum)
{
    tps(0, 0, 0) = 0.5f * (cbc(0, 0, 0) + cbc(-1, 0, 0)) *
                   sqrtf(ub(0, 0, kbm1 - 1) * ub(0, 0, kbm1 - 1) +
                         (0.25f * (vb(0, 0, kbm1 - 1) + vb(0, 1, kbm1 - 1) + vb(-1, 0, kbm1 - 1) +
                                   vb(-1, 1, kbm1 - 1))) *
                             (0.25f * (vb(0, 0, kbm1 - 1) + vb(0, 1, kbm1 - 1) +
                                       vb(-1, 0, kbm1 - 1) + vb(-1, 1, kbm1 - 1))));
    uf(0, 0, kbm1 - 1) = (c(0, 0, kbm1 - 1) * gg(0, 0, kbm2 - 1) - uf(0, 0, kbm1 - 1)) /
                         (tps(0, 0, 0) * (dti2) / (-dz(0, 0, kbm1 - 1) * dhloc(0, 0, 0)) - 1.0f -
                          (ee(0, 0, kbm2 - 1) - 1.0f) * c(0, 0, kbm1 - 1));
    uf(0, 0, kbm1 - 1) = uf(0, 0, kbm1 - 1) * dum(0, 0, 0);
}

void ext_profu_8(ACC<float>& uf, const ACC<float>& dum, const ACC<float>& ee, const ACC<float>& gg)
{
    uf(0, 0, 0) = (ee(0, 0, 0) * uf(0, 0, 1) + gg(0, 0, 0)) * dum(0, 0, 0);
}

void ext_profu_9(const ACC<float>& uf, const ACC<float>& tps, ACC<float>& wubot)
{
    wubot(0, 0, 0) = -tps(0, 0, 0) * uf(0, 0, kbm1 - 1);
}

void ext_smol_adif_0(ACC<float>& ff, const ACC<float>& fsm)
{
    ff(0, 0, 0) *= fsm(0, 0, 0);
}

void ext_smol_adif_1(ACC<float>& xmassflux, const ACC<float>& ff, const float* sw,
                     const ACC<float>& aru, const ACC<float>& dt)
{
    real_t udx, u2dt, mol;

    if ((ff(0, 0, 0) < 1.0e-9f) || (ff(-1, 0, 0) < 1.0e-9f))
    {
        xmassflux(0, 0, 0) = 0.0f;
    }
    else
    {
        udx = fabs(xmassflux(0, 0, 0));
        u2dt = dti2 * xmassflux(0, 0, 0) * xmassflux(0, 0, 0) * 2.0f /
               (aru(0, 0, 0) * (dt(-1, 0, 0) + dt(0, 0, 0)));
        mol = (ff(0, 0, 0) - ff(-1, 0, 0)) / (ff(-1, 0, 0) + ff(0, 0, 0) + 1.0e-14f);
        xmassflux(0, 0, 0) = (udx - u2dt) * mol * (*sw);

        if (fabs(udx) < fabs(u2dt))
        {
            xmassflux(0, 0, 0) = 0.0f;
        }
    }
}

void ext_smol_adif_2(ACC<float>& ymassflux, const ACC<float>& ff, const float* sw,
                     const ACC<float>& arv, const ACC<float>& dt)
{
    real_t vdy, v2dt, mol;

    if ((ff(0, 0, 0) < 1.0e-9f) || (ff(0, -1, 0) < 1.0e-9f))
    {
        ymassflux(0, 0, 0) = 0.0f;
    }
    else
    {
        vdy = fabs(ymassflux(0, 0, 0));
        v2dt = dti2 * ymassflux(0, 0, 0) * ymassflux(0, 0, 0) * 2.0f /
               (arv(0, 0, 0) * (dt(0, -1, 0) + dt(0, 0, 0)));
        mol = (ff(0, 0, 0) - ff(0, -1, 0)) / (ff(0, -1, 0) + ff(0, 0, 0) + 1.0e-14f);
        ymassflux(0, 0, 0) = (vdy - v2dt) * mol * (*sw);

        if (fabs(vdy) < fabs(v2dt))
        {
            ymassflux(0, 0, 0) = 0.0f;
        }
    }
}

void ext_smol_adif_3(ACC<float>& zwflux, const ACC<float>& ff, const float* sw,
                     const ACC<float>& dt, const ACC<float>& dzz)
{
    real_t wdz, w2dt, mol;

    if ((ff(0, 0, 0) < 1.0e-9f) || (ff(0, 0, -1) < 1.0e-9f))
    {
        zwflux(0, 0, 0) = 0.0f;
    }
    else
    {
        wdz = fabs(zwflux(0, 0, 0));
        w2dt = dti2 * zwflux(0, 0, 0) * zwflux(0, 0, 0) / (dzz(0, 0, 0 - 1) * dt(0, 0, 0));
        mol = (ff(0, 0, -1) - ff(0, 0, 0)) / (ff(0, 0, 0) + ff(0, 0, -1) + 1.0e-14f);
        zwflux(0, 0, 0) = (wdz - w2dt) * mol * (*sw);

        if (fabs(wdz) < fabs(w2dt))
        {
            zwflux(0, 0, 0) = 0.0f;
        }
    }
}

void ext_profv_0(ACC<float>& dhloc)
{
    dhloc(0, 0, 0) = 1.0f;
}

void ext_profv_1(const ACC<float>& etf, const ACC<float>& h, ACC<float>& dhloc)
{
    dhloc(0, 0, 0) = 0.5f * (h(0, 0, 0) + etf(0, 0, 0) + h(0, -1, 0) + etf(0, -1, 0));
}

void ext_profv_2(ACC<float>& c, const ACC<float>& km)
{
    c(0, 0, 0) = (km(0, 0, 0) + km(0, -1, 0)) * 0.5f;
}

void ext_profv_3(const ACC<float>& c, ACC<float>& a, const ACC<float>& dz, const ACC<float>& dzz,
                 const ACC<float>& dhloc)
{
    a(0, 0, 0) = -(dti2) * (c(0, 0, 1) + umol) /
                 (dz(0, 0, 0) * dzz(0, 0, 0) * dhloc(0, 0, 0) * dhloc(0, 0, 0));
}

void ext_profv_4(ACC<float>& c, const ACC<float>& dz, const ACC<float>& dzz,
                 const ACC<float>& dhloc)
{
    c(0, 0, 0) = -(dti2) * (c(0, 0, 0) + umol) /
                 (dz(0, 0, 0) * dzz(0, 0, 0 - 1) * dhloc(0, 0, 0) * dhloc(0, 0, 0));
}

void ext_profv_5(const ACC<float>& vf, const ACC<float>& a, const ACC<float>& dz, ACC<float>& ee,
                 const ACC<float>& dhloc, const ACC<float>& wvsurf, ACC<float>& gg)
{
    ee(0, 0, 0) = a(0, 0, 0) / (a(0, 0, 0) - 1.0f);
    gg(0, 0, 0) = (-dti2 * wvsurf(0, 0, 0) / (-(dz(0, 0, 0))*dhloc(0, 0, 0)) - vf(0, 0, 0)) /
                  (a(0, 0, 0) - 1.0f);
}

void ext_profv_6(const ACC<float>& vf, const ACC<float>& c, const ACC<float>& a, ACC<float>& ee,
                 ACC<float>& gg)
{
    gg(0, 0, 0) = 1.0f / (a(0, 0, 0) + c(0, 0, 0) * (1.0f - ee(0, 0, -1)) - 1.0f);
    ee(0, 0, 0) = a(0, 0, 0) * gg(0, 0, 0);
    gg(0, 0, 0) = (c(0, 0, 0) * gg(0, 0, -1) - vf(0, 0, 0)) * gg(0, 0, 0);
}

void ext_profv_7(ACC<float>& vf, ACC<float>& tps, const ACC<float>& cbc, const ACC<float>& ub,
                 const ACC<float>& vb, const ACC<float>& dz, const ACC<float>& ee,
                 const ACC<float>& c, const ACC<float>& gg, const ACC<float>& dhloc,
                 const ACC<float>& dvm)
{
    tps(0, 0, 0) = 0.5f * (cbc(0, 0, 0) + cbc(0, -1, 0)) *
                   sqrtf((0.25f * (ub(0, 0, kbm1 - 1) + ub(1, 0, kbm1 - 1) + ub(0, -1, kbm1 - 1) +
                                   ub(1, -1, kbm1 - 1))) *
                             (0.25f * (ub(0, 0, kbm1 - 1) + ub(1, 0, kbm1 - 1) +
                                       ub(0, -1, kbm1 - 1) + ub(1, -1, kbm1 - 1))) +
                         vb(0, 0, kbm1 - 1) * vb(0, 0, kbm1 - 1));
    vf(0, 0, kbm1 - 1) = (c(0, 0, kbm1 - 1) * gg(0, 0, kbm2 - 1) - vf(0, 0, kbm1 - 1)) /
                         (tps(0, 0, 0) * dti2 / (-(dz(0, 0, kbm1 - 1)) * dhloc(0, 0, 0)) - 1.0f -
                          (ee(0, 0, kbm2 - 1) - 1.0f) * c(0, 0, kbm1 - 1));
    vf(0, 0, kbm1 - 1) = vf(0, 0, kbm1 - 1) * dvm(0, 0, 0);
}

void ext_profv_8(ACC<float>& vf, const ACC<float>& dvm, const ACC<float>& ee, const ACC<float>& gg)
{
    vf(0, 0, 0) = (ee(0, 0, 0) * vf(0, 0, 1) + gg(0, 0, 0)) * dvm(0, 0, 0);
}

void ext_profv_9(const ACC<float>& vf, const ACC<float>& tps, ACC<float>& wvbot)
{
    wvbot(0, 0, 0) = -tps(0, 0, 0) * vf(0, 0, kbm1 - 1);
}

void ext_advave_0(ACC<float>& advua)
{
    advua(0, 0, 0) = 0.0f;
}

void ext_advave_1(const ACC<float>& d, ACC<float>& fluxua, const ACC<float>& ua)
{
    fluxua(0, 0, 0) =
        .125f *
        ((d(1, 0, 0) + d(0, 0, 0)) * ua(1, 0, 0) + (d(0, 0, 0) + d(-1, 0, 0)) * ua(0, 0, 0)) *
        (ua(1, 0, 0) + ua(0, 0, 0));
}

void ext_advave_2(const ACC<float>& d, ACC<float>& fluxva, const ACC<float>& ua,
                  const ACC<float>& va)
{
    fluxva(0, 0, 0) =
        .125f *
        ((d(0, 0, 0) + d(0, -1, 0)) * va(0, 0, 0) + (d(-1, 0, 0) + d(-1, -1, 0)) * va(-1, 0, 0)) *
        (ua(0, 0, 0) + ua(0, -1, 0));
}

void ext_advave_3(const ACC<float>& d, ACC<float>& fluxua, const ACC<float>& dx,
                  const ACC<float>& aam2d, const ACC<float>& uab)
{
    fluxua(0, 0, 0) = fluxua(0, 0, 0) - d(0, 0, 0) * 2.0f * aam2d(0, 0, 0) *
                                            (uab(1, 0, 0) - uab(0, 0, 0)) / dx(0, 0, 0);
}

void ext_advave_4(const ACC<float>& d, const ACC<float>& dx, const ACC<float>& dy,
                  ACC<float>& fluxva, ACC<float>& fluxua, const ACC<float>& aam2d,
                  const ACC<float>& uab, const ACC<float>& vab, ACC<float>& tps)
{
    tps(0, 0, 0) = .25f * (d(0, 0, 0) + d(-1, 0, 0) + d(0, -1, 0) + d(-1, -1, 0)) *
                   (aam2d(0, 0, 0) + aam2d(0, -1, 0) + aam2d(-1, 0, 0) + aam2d(-1, -1, 0)) *
                   ((uab(0, 0, 0) - uab(0, -1, 0)) /
                        (dy(0, 0, 0) + dy(-1, 0, 0) + dy(0, -1, 0) + dy(-1, -1, 0)) +
                    (vab(0, 0, 0) - vab(-1, 0, 0)) /
                        (dx(0, 0, 0) + dx(-1, 0, 0) + dx(0, -1, 0) + dx(-1, -1, 0)));
    fluxua(0, 0, 0) = fluxua(0, 0, 0) * dy(0, 0, 0);
    fluxva(0, 0, 0) = (fluxva(0, 0, 0) - tps(0, 0, 0)) * .25f *
                      (dx(0, 0, 0) + dx(-1, 0, 0) + dx(0, -1, 0) + dx(-1, -1, 0));
}

void ext_advave_5(ACC<float>& advua, const ACC<float>& fluxua, const ACC<float>& fluxva)
{
    advua(0, 0, 0) = fluxua(0, 0, 0) - fluxua(-1, 0, 0) + fluxva(0, 1, 0) - fluxva(0, 0, 0);
}

void ext_advave_6(ACC<float>& advva)
{
    advva(0, 0, 0) = 0.0f;
}

void ext_advave_7(const ACC<float>& d, ACC<float>& fluxua, const ACC<float>& ua,
                  const ACC<float>& va)
{
    fluxua(0, 0, 0) =
        .125f *
        ((d(0, 0, 0) + d(-1, 0, 0)) * ua(0, 0, 0) + (d(0, -1, 0) + d(-1, -1, 0)) * ua(0, -1, 0)) *
        (va(-1, 0, 0) + va(0, 0, 0));
}

void ext_advave_8(const ACC<float>& d, ACC<float>& fluxva, const ACC<float>& va)
{
    fluxva(0, 0, 0) =
        .125f *
        ((d(0, 1, 0) + d(0, 0, 0)) * va(0, 1, 0) + (d(0, 0, 0) + d(0, -1, 0)) * va(0, 0, 0)) *
        (va(0, 1, 0) + va(0, 0, 0));
}

void ext_advave_9(const ACC<float>& d, ACC<float>& fluxva, const ACC<float>& dy,
                  const ACC<float>& aam2d, const ACC<float>& vab)
{
    fluxva(0, 0, 0) = fluxva(0, 0, 0) - d(0, 0, 0) * 2.0f * aam2d(0, 0, 0) *
                                            (vab(0, 1, 0) - vab(0, 0, 0)) / dy(0, 0, 0);
}

void ext_advave_10(const ACC<float>& dx, ACC<float>& fluxva, const ACC<float>& dy,
                   ACC<float>& fluxua, const ACC<float>& tps)
{
    fluxva(0, 0, 0) = fluxva(0, 0, 0) * dx(0, 0, 0);
    fluxua(0, 0, 0) = (fluxua(0, 0, 0) - tps(0, 0, 0)) * .25f *
                      (dy(0, 0, 0) + dy(-1, 0, 0) + dy(0, -1, 0) + dy(-1, -1, 0));
}

void ext_advave_11(ACC<float>& advva, const ACC<float>& fluxua, const ACC<float>& fluxva)
{
    advva(0, 0, 0) = fluxua(1, 0, 0) - fluxua(0, 0, 0) + fluxva(0, 0, 0) - fluxva(0, -1, 0);
}

void ext_advave_12(const ACC<float>& uab, const ACC<float>& vab, const ACC<float>& cbc,
                   ACC<float>& wubot)
{
    wubot(0, 0, 0) =
        -0.5f * (cbc(0, 0, 0) + cbc(-1, 0, 0)) *
        sqrtf(uab(0, 0, 0) * uab(0, 0, 0) +
              (.25f * (vab(0, 0, 0) + vab(0, 1, 0) + vab(-1, 0, 0) + vab(-1, 1, 0))) *
                  (.25f * (vab(0, 0, 0) + vab(0, 1, 0) + vab(-1, 0, 0) + vab(-1, 1, 0)))) *
        uab(0, 0, 0);
}

void ext_advave_13(ACC<float>& wvbot, const ACC<float>& uab, const ACC<float>& vab,
                   const ACC<float>& cbc)
{
    wvbot(0, 0, 0) =
        -0.5f * (cbc(0, 0, 0) + cbc(0, -1, 0)) *
        sqrtf(vab(0, 0, 0) * vab(0, 0, 0) +
              (.25f * (uab(0, 0, 0) + uab(1, 0, 0) + uab(0, -1, 0) + uab(1, -1, 0))) *
                  (.25f * (uab(0, 0, 0) + uab(1, 0, 0) + uab(0, -1, 0) + uab(1, -1, 0)))) *
        vab(0, 0, 0);
}

void ext_advave_14(ACC<float>& curv2d, const ACC<float>& dx, const ACC<float>& dy,
                   const ACC<float>& ua, const ACC<float>& va)
{
    curv2d(0, 0, 0) = .25f *
                      ((va(0, 1, 0) + va(0, 0, 0)) * (dy(1, 0, 0) - dy(-1, 0, 0)) -
                       (ua(1, 0, 0) + ua(0, 0, 0)) * (dx(0, 1, 0) - dx(0, -1, 0))) /
                      (dx(0, 0, 0) * dy(0, 0, 0));
}

void ext_advave_15(const ACC<float>& curv2d, ACC<float>& advua, const ACC<float>& d,
                   const ACC<float>& aru, const ACC<float>& va)
{
    advua(0, 0, 0) =
        advua(0, 0, 0) - aru(0, 0, 0) * .25f *
                             (curv2d(0, 0, 0) * d(0, 0, 0) * (va(0, 1, 0) + va(0, 0, 0)) +
                              curv2d(-1, 0, 0) * d(-1, 0, 0) * (va(-1, 1, 0) + va(-1, 0, 0)));
}

void ext_advave_16(const ACC<float>& curv2d, ACC<float>& advva, const ACC<float>& d,
                   const ACC<float>& ua, const ACC<float>& arv)
{
    advva(0, 0, 0) =
        advva(0, 0, 0) + arv(0, 0, 0) * .25f *
                             (curv2d(0, 0, 0) * d(0, 0, 0) * (ua(1, 0, 0) + ua(0, 0, 0)) +
                              curv2d(0, -1, 0) * d(0, -1, 0) * (ua(1, -1, 0) + ua(0, -1, 0)));
}

void ext_baropg_0(ACC<float>& rho, const ACC<float>& rmean)
{
    rho(0, 0, 0) = rho(0, 0, 0) - rmean(0, 0, 0);
}

void ext_baropg_1(const ACC<float>& rho, ACC<float>& drhox, const ACC<float>& zz,
                  const ACC<float>& dt)
{
    drhox(0, 0, 0) = 0.5f * grav * (-zz(0, 0, 0)) * (dt(0, 0, 0) + dt(-1, 0, 0)) *
                     (rho(0, 0, 0) - rho(-1, 0, 0));
}

void ext_baropg_2(const ACC<float>& rho, ACC<float>& drhox, const ACC<float>& zz,
                  const ACC<float>& dt)
{
    drhox(0, 0, 0) = drhox(0, 0, -1) +
                     grav * 0.25f * (zz(0, 0, 0 - 1) - zz(0, 0, 0)) * (dt(0, 0, 0) + dt(-1, 0, 0)) *
                         (rho(0, 0, 0) - rho(-1, 0, 0) + rho(0, 0, -1) - rho(-1, 0, -1)) +
                     grav * 0.25f * (zz(0, 0, 0 - 1) + zz(0, 0, 0)) * (dt(0, 0, 0) - dt(-1, 0, 0)) *
                         (rho(0, 0, 0) + rho(-1, 0, 0) - rho(0, 0, -1) - rho(-1, 0, -1));
}

void ext_baropg_3(ACC<float>& drhox, const ACC<float>& dt, const ACC<float>& dum,
                  const ACC<float>& dy)
{
    drhox(0, 0, 0) = 0.25f * (dt(0, 0, 0) + dt(-1, 0, 0)) * drhox(0, 0, 0) * dum(0, 0, 0) *
                     (dy(0, 0, 0) + dy(-1, 0, 0));
}

void ext_baropg_4(const ACC<float>& rho, ACC<float>& drhoy, const ACC<float>& zz,
                  const ACC<float>& dt)
{
    drhoy(0, 0, 0) = 0.5f * grav * (-zz(0, 0, 0)) * (dt(0, 0, 0) + dt(0, -1, 0)) *
                     (rho(0, 0, 0) - rho(0, -1, 0));
}

void ext_baropg_5(const ACC<float>& rho, ACC<float>& drhoy, const ACC<float>& zz,
                  const ACC<float>& dt)
{
    drhoy(0, 0, 0) = drhoy(0, 0, -1) +
                     grav * 0.25f * (zz(0, 0, 0 - 1) - zz(0, 0, 0)) * (dt(0, 0, 0) + dt(0, -1, 0)) *
                         (rho(0, 0, 0) - rho(0, -1, 0) + rho(0, 0, -1) - rho(0, -1, -1)) +
                     grav * 0.25f * (zz(0, 0, 0 - 1) + zz(0, 0, 0)) * (dt(0, 0, 0) - dt(0, -1, 0)) *
                         (rho(0, 0, 0) + rho(0, -1, 0) - rho(0, 0, -1) - rho(0, -1, -1));
}

void ext_baropg_6(ACC<float>& drhoy, const ACC<float>& dt, const ACC<float>& dvm,
                  const ACC<float>& dx)
{
    drhoy(0, 0, 0) = 0.25f * (dt(0, 0, 0) + dt(0, -1, 0)) * drhoy(0, 0, 0) * dvm(0, 0, 0) *
                     (dx(0, 0, 0) + dx(0, -1, 0));
}

void ext_baropg_7(const float* ramp, ACC<float>& drhox, ACC<float>& drhoy)
{
    drhox(0, 0, 0) = *ramp * drhox(0, 0, 0);
    drhoy(0, 0, 0) = *ramp * drhoy(0, 0, 0);
}

void ext_baropg_8(ACC<float>& rho, const ACC<float>& rmean)
{
    rho(0, 0, 0) = rho(0, 0, 0) + rmean(0, 0, 0);
}

void ext_vaf_0(const ACC<float>& elf, const ACC<float>& e_atmos, const ACC<float>& dry2d,
               const ACC<float>& wvsurf, const ACC<float>& wvbot, ACC<float>& vaf,
               const ACC<float>& ady2d, const ACC<float>& advva, const ACC<float>& arv,
               const ACC<float>& cor, const ACC<float>& d, const ACC<float>& ua,
               const ACC<float>& dx, const ACC<float>& el, const ACC<float>& elb)
{
    vaf(0, 0, 0) = ady2d(0, 0, 0) + advva(0, 0, 0) +
                   arv(0, 0, 0) * .25f *
                       (cor(0, 0, 0) * d(0, 0, 0) * (ua(1, 0, 0) + ua(0, 0, 0)) +
                        cor(0, -1, 0) * d(0, -1, 0) * (ua(1, -1, 0) + ua(0, -1, 0))) +
                   .25f * grav * (dx(0, 0, 0) + dx(0, -1, 0)) * (d(0, 0, 0) + d(0, -1, 0)) *
                       ((1.0f - 2.0f * alpha) * (el(0, 0, 0) - el(0, -1, 0)) +
                        alpha * (elb(0, 0, 0) - elb(0, -1, 0) + elf(0, 0, 0) - elf(0, -1, 0)) +
                        e_atmos(0, 0, 0) - e_atmos(0, -1, 0)) +
                   dry2d(0, 0, 0) + arv(0, 0, 0) * (wvsurf(0, 0, 0) - wvbot(0, 0, 0));
}

void ext_vaf_1(ACC<float>& vaf, const ACC<float>& elf, const ACC<float>& arv, const ACC<float>& h,
               const ACC<float>& vab, const ACC<float>& elb)
{
    vaf(0, 0, 0) =
        ((h(0, 0, 0) + elb(0, 0, 0) + h(0, -1, 0) + elb(0, -1, 0)) * vab(0, 0, 0) * arv(0, 0, 0) -
         4.0f * dte * vaf(0, 0, 0)) /
        ((h(0, 0, 0) + elf(0, 0, 0) + h(0, -1, 0) + elf(0, -1, 0)) * arv(0, 0, 0));
}

void ext_elf_update_0(ACC<float>& elf, const ACC<float>& elb, const ACC<float>& fluxua,
                      const ACC<float>& fluxva, const ACC<float>& art, const ACC<float>& vfluxf)
{
    elf(0, 0, 0) =
        elb(0, 0, 0) +
        dte2 * (-(fluxua(1, 0, 0) - fluxua(0, 0, 0) + fluxva(0, 1, 0) - fluxva(0, 0, 0)) /
                    art(0, 0, 0) -
                vfluxf(0, 0, 0));
}

void ext_aam_0(ACC<float>& aam, const ACC<float>& dx, const ACC<float>& dy, const ACC<float>& u,
               const ACC<float>& v)
{
    aam(0, 0, 0) =
        horcon * dx(0, 0, 0) * dy(0, 0, 0) *
        sqrtf(
            ((u(1, 0, 0) - u(0, 0, 0)) / dx(0, 0, 0)) * ((u(1, 0, 0) - u(0, 0, 0)) / dx(0, 0, 0)) +
            ((v(0, 1, 0) - v(0, 0, 0)) / dy(0, 0, 0)) * ((v(0, 1, 0) - v(0, 0, 0)) / dy(0, 0, 0)) +
            0.5f *
                (0.25f * (u(0, 1, 0) + u(1, 1, 0) - u(0, -1, 0) - u(1, -1, 0)) / dy(0, 0, 0) +
                 0.25f * (v(1, 0, 0) + v(1, 1, 0) - v(-1, 0, 0) - v(-1, 1, 0)) / dx(0, 0, 0)) *
                (0.25f * (u(0, 1, 0) + u(1, 1, 0) - u(0, -1, 0) - u(1, -1, 0)) / dy(0, 0, 0) +
                 0.25f * (v(1, 0, 0) + v(1, 1, 0) - v(-1, 0, 0) - v(-1, 1, 0)) / dx(0, 0, 0)));
}

void ext_add_ad_2d_0(ACC<float>& adx2d, ACC<float>& ady2d, const ACC<float>& advua,
                     const ACC<float>& advva)
{
    adx2d(0, 0, 0) -= advua(0, 0, 0);
    ady2d(0, 0, 0) -= advva(0, 0, 0);
}

void ext_advu_0(ACC<float>& uf)
{
    uf(0, 0, 0) = 0.0f;
}

void ext_advu_1(const ACC<float>& u, ACC<float>& uf, const ACC<float>& w)
{
    uf(0, 0, 0) = 0.25f * (w(0, 0, 0) + w(-1, 0, 0)) * (u(0, 0, 0) + u(0, 0, -1));
}

void ext_advu_2(ACC<float>& uf, const ACC<float>& dt, const ACC<float>& v, const ACC<float>& egb,
                const ACC<float>& advx, const ACC<float>& aru, const ACC<float>& e_atmos,
                const ACC<float>& dz, const ACC<float>& cor, const ACC<float>& dy,
                const ACC<float>& drhox, const ACC<float>& egf)
{
    uf(0, 0, 0) = advx(0, 0, 0) + (uf(0, 0, 0) - uf(0, 0, 1)) * aru(0, 0, 0) / dz(0, 0, 0) -
                  aru(0, 0, 0) * 0.25f *
                      (cor(0, 0, 0) * dt(0, 0, 0) * (v(0, 1, 0) + v(0, 0, 0)) +
                       cor(-1, 0, 0) * dt(-1, 0, 0) * (v(-1, 1, 0) + v(-1, 0, 0))) +
                  grav * 0.125f * (dt(0, 0, 0) + dt(-1, 0, 0)) *
                      (egf(0, 0, 0) - egf(-1, 0, 0) + egb(0, 0, 0) - egb(-1, 0, 0) +
                       (e_atmos(0, 0, 0) - e_atmos(-1, 0, 0)) * 2.0f) *
                      (dy(0, 0, 0) + dy(-1, 0, 0)) +
                  drhox(0, 0, 0);
}

void ext_advu_3(ACC<float>& uf, const ACC<float>& ub, const ACC<float>& h, const ACC<float>& aru,
                const ACC<float>& etb, const ACC<float>& etf)
{
    uf(0, 0, 0) =
        ((h(0, 0, 0) + etb(0, 0, 0) + h(-1, 0, 0) + etb(-1, 0, 0)) * aru(0, 0, 0) * ub(0, 0, 0) -
         2.0f * dti2 * uf(0, 0, 0)) /
        ((h(0, 0, 0) + etf(0, 0, 0) + h(-1, 0, 0) + etf(-1, 0, 0)) * aru(0, 0, 0));
}

void ext_bcond_2_0(ACC<float>& uaf, ACC<float>& vaf, const ACC<float>& uabe, const ACC<float>& uabw,
                   const float* ramp, const float* rfe, const ACC<float>& h, const ACC<float>& el,
                   const ACC<float>& ele, const float* rfw, const ACC<float>& elw)
{
    // C
    // C     East:
    // C
    uaf(imm1, 0, 0) =
        uabe(0, 0, 0) + *rfe * sqrtf(grav / h(imm2, 0, 0)) * (el(imm2, 0, 0) - ele(0, 0, 0));
    uaf(imm1, 0, 0) = *ramp * uaf(imm1, 0, 0);
    vaf(imm1, 0, 0) = 0.0f;
    // C
    // C     West:
    // C
    uaf(1, 0, 0) = uabw(0, 0, 0) - *rfw * sqrtf(grav / h(1, 0, 0)) * (el(1, 0, 0) - elw(0, 0, 0));
    uaf(1, 0, 0) = *ramp * uaf(1, 0, 0);
    uaf(0, 0, 0) = uaf(1, 0, 0);
    vaf(0, 0, 0) = 0.0f;
}

void ext_bcond_2_1(ACC<float>& uaf, const ACC<float>& eln, ACC<float>& vaf, const ACC<float>& els,
                   const ACC<float>& vabn, const float* ramp, const ACC<float>& h,
                   const ACC<float>& el, const float* rfn, const float* rfs, const ACC<float>& vabs)
{
    // C
    // C     North:
    // C
    vaf(0, jmm1, 0) =
        vabn(0, 0, 0) + *rfn * sqrtf(grav / h(0, jmm2, 0)) * (el(0, jmm2, 0) - eln(0, 0, 0));
    vaf(0, jmm1, 0) = *ramp * vaf(0, jmm1, 0);
    uaf(0, jmm1, 0) = 0.0f;
    // C
    // C     South:
    // C
    vaf(0, 1, 0) = vabs(0, 0, 0) - *rfs * sqrtf(grav / h(0, 1, 0)) * (el(0, 1, 0) - els(0, 0, 0));
    vaf(0, 1, 0) = *ramp * vaf(0, 1, 0);
    vaf(0, 0, 0) = vaf(0, 1, 0);
    uaf(0, 0, 0) = 0.0f;
}

void ext_bcond_2_2(ACC<float>& uaf, ACC<float>& vaf, const ACC<float>& dum, const ACC<float>& dvm)
{
    uaf(0, 0, 0) = uaf(0, 0, 0) * dum(0, 0, 0);
    vaf(0, 0, 0) = vaf(0, 0, 0) * dvm(0, 0, 0);
}

void ext_profq_0(ACC<float>& dh, const ACC<float>& h, const ACC<float>& etf)
{
    dh(0, 0, 0) = h(0, 0, 0) + etf(0, 0, 0);
}

void ext_profq_1(const ACC<float>& dzz, const ACC<float>& dh, ACC<float>& a, ACC<float>& c,
                 const ACC<float>& kq, const ACC<float>& dz)
{
    a(0, 0, 0) = -dti2 * (kq(0, 0, 1) + kq(0, 0, 0) + 2.0f * umol) * 0.5f /
                 (dzz(0, 0, 0 - 1) * dz(0, 0, 0) * dh(0, 0, 0) * dh(0, 0, 0));
    c(0, 0, 0) = -dti2 * (kq(0, 0, -1) + kq(0, 0, 0) + 2.0f * umol) * 0.5f /
                 (dzz(0, 0, 0 - 1) * dz(0, 0, 0 - 1) * dh(0, 0, 0) * dh(0, 0, 0));
}

void ext_profq_2(ACC<float>& ee, ACC<float>& gg, ACC<float>& l0, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    ee(0, jm - 1, 0) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 0 itt
    gg(0, jm - 1, 0) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 0 itt
    l0(0, jm - 1, 0) = 0.0f;
}

void ext_profq_3(ACC<float>& ee, ACC<float>& gg, ACC<float>& l0, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    ee(im - 1, 0, 0) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 0 itt
    gg(im - 1, 0, 0) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 0 itt
    l0(im - 1, 0, 0) = 0.0f;
}

void ext_profq_4(ACC<float>& prod)
{
    prod(0, 0, 0) = 0.0f;
}

void ext_profq_5(ACC<float>& ee, ACC<float>& gg, const ACC<float>& wusurf, const ACC<float>& wvsurf,
                 ACC<float>& uf, const ACC<float>& wubot, ACC<float>& l0, const ACC<float>& wvbot,
                 int* arg_idx, const float* _surfl, const float* _const1)
{
    const float surfl = *_surfl;
    const float const1 = *_const1;
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    real_t utau2 = sqrtf((0.5f * (wusurf(0, 0, 0) + wusurf(1, 0, 0))) *
                             (0.5f * (wusurf(0, 0, 0) + wusurf(1, 0, 0))) +
                         (0.5f * (wvsurf(0, 0, 0) + wvsurf(0, 1, 0))) *
                             (0.5f * (wvsurf(0, 0, 0) + wvsurf(0, 1, 0))));

    // C Wave breaking energy- a variant of Craig & Banner (1994)
    // C see Mellor and Blumberg, 2003.
    /*           ee(i,j,1)=0.e0
              gg(i,j,1)=(15.8*cbcnst)**(2./3.)*utau2  */
    ee(0, 0, 0) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 0 itt
    gg(0, 0, 0) = powf(15.8f * 100.0f, (2.0f / 3.0f)) * utau2; // A k tag C-ben 0-tól számozódik,
                                                               // F-ben 1-től, ezért k az 0 itt

    // C Surface length scale following Stacey (1999).
    /*           l0(i,j)=surfl*utau2/grav */
    l0(0, 0, 0) = surfl * utau2 / grav;
    /*           uf(i,j,kb)=sqrt((.5e0*(wubot(i,j)+wubot(i+1,j)))**2
         $                   +(.5e0*(wvbot(i,j)+wvbot(i,j+1)))**2)*const1
            end do
          end do */
    uf(0, 0, kb - 1) = sqrtf((0.5f * (wubot(0, 0, 0) + wubot(1, 0, 0))) *
                                 (0.5f * (wubot(0, 0, 0) + wubot(1, 0, 0))) +
                             (0.5f * (wvbot(0, 0, 0) + wvbot(0, 1, 0))) *
                                 (0.5f * (wvbot(0, 0, 0) + wvbot(0, 1, 0)))) *
                       const1;
}

void ext_profq_6(const ACC<float>& zz, ACC<float>& cc, const ACC<float>& h, const ACC<float>& t,
                 const ACC<float>& s, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    real_t tp = t(0, 0, 0) + tbias;
    real_t sp = s(0, 0, 0) + sbias;

    // C
    // C     Calculate pressure in units of decibars:
    // C
    /*             p=grav*rhoref*(-zz(k)* h(i,j))*1.e-4
                cc(i,j,k)=1449.1e0+.00821e0*p+4.55e0*tp -.045e0*tp**2
         $                 +1.34e0*(sp-35.0e0)
                cc(i,j,k)=cc(i,j,k)
         $                 /sqrt((1.e0-.01642e0*p/cc(i,j,k))
         $                   *(1.e0-0.40e0*p/cc(i,j,k)**2))
              end do
            end do
          end do */
    real_t p = grav * rhoref * (-zz(0, 0, 0) * h(0, 0, 0)) * (0.0001f);
    cc(0, 0, 0) = 1449.1f + 0.00821f * p + 4.55f * tp - 0.045f * tp * tp + 1.34f * (sp - 35.0f);
    cc(0, 0, 0) = cc(0, 0, 0) / sqrtf((1.0f - 0.01642f * p / cc(0, 0, 0)) *
                                      (1.0f - 0.4f * p / ((cc(0, 0, 0)) * (cc(0, 0, 0)))));
}

void ext_profq_7(const ACC<float>& dzz, ACC<float>& q2b, ACC<float>& q2lb, const ACC<float>& h,
                 const ACC<float>& rho, const ACC<float>& cc, ACC<float>& boygr, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    q2b(0, 0, 0) = fabsf(q2b(0, 0, 0));
    q2lb(0, 0, 0) = fabsf(q2lb(0, 0, 0));
    boygr(0, 0, 0) =
        grav * (rho(0, 0, -1) - rho(0, 0, 0)) / (dzz(0, 0, 0 - 1) * h(0, 0, 0))

        // C *** NOTE: comment out next line if dens does not include
        // pressure
        /*      $      +(grav**2)*2.e0/(cc(i,j,k-1)**2+cc(i,j,k)**2)
                  end do
                end do
              end do */
        + (grav * grav) * 2.0f / ((cc(0, 0, -1) * cc(0, 0, -1)) + cc(0, 0, 0) * cc(0, 0, 0));
}

void ext_profq_8(const ACC<float>& q2b, const ACC<float>& q2lb, ACC<float>& l, const ACC<float>& z,
                 const ACC<float>& l0, ACC<float>& gh, const ACC<float>& boygr)
{
    l(0, 0, 0) = fabsf(q2lb(0, 0, 0) / q2b(0, 0, 0));
    if (z(0, 0, 0) > -0.5f)
        l(0, 0, 0) = fmaxf(l(0, 0, 0), kappa * l0(0, 0, 0));
    gh(0, 0, 0) = (l(0, 0, 0) * l(0, 0, 0)) * boygr(0, 0, 0) / q2b(0, 0, 0);
    gh(0, 0, 0) = fminf(gh(0, 0, 0), 0.028f);
}

void ext_profq_9(ACC<float>& l, const ACC<float>& l0, ACC<float>& gh, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    l(0, 0, 0) = kappa * l0(0, 0, 0); // A k tag C-ben 0-tól számozódik, F-ben
                                      // 1-től, ezért k az 0 itt
    l(0, 0, kb - 1) = 0.0f;
    gh(0, 0, 0) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 0 itt
    gh(0, 0, kb - 1) = 0.0f;
}

void ext_profq_10(const ACC<float>& dzz, const ACC<float>& dh, const ACC<float>& km,
                  const ACC<float>& u, const ACC<float>& v, const ACC<float>& boygr,
                  const ACC<float>& kh, ACC<float>& prod, int* arg_idx, const float* _sef,
                  const float* _shiw)
{
    const float sef = *_sef;
    const float shiw = *_shiw;
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    prod(0, 0, 0) = km(0, 0, 0) * 0.25f * sef *
                        ((u(0, 0, 0) - u(0, 0, -1) + u(1, 0, 0) - u(1, 0, -1)) *
                             (u(0, 0, 0) - u(0, 0, -1) + u(1, 0, 0) - u(1, 0, -1)) +
                         (v(0, 0, 0) - v(0, 0, -1) + v(0, 1, 0) - v(0, 1, -1)) *
                             (v(0, 0, 0) - v(0, 0, -1) + v(0, 1, 0) - v(0, 1, -1))) /
                        ((dzz(0, 0, 0 - 1) * dh(0, 0, 0)) * (dzz(0, 0, 0 - 1) * dh(0, 0, 0)))
                    // C   Add shear due to internal wave field
                    /*      $             -shiw*km(i,j,k)*boygr(i,j,k)
                                prod(i,j,k)=prod(i,j,k)+kh(i,j,k)*boygr(i,j,k)
                              end do
                            end do
                          end do */
                    - shiw * km(0, 0, 0) * boygr(0, 0, 0);
    prod(0, 0, 0) = prod(0, 0, 0) + kh(0, 0, 0) * boygr(0, 0, 0);
}

void ext_profq_11(const ACC<float>& q2b, const ACC<float>& l, ACC<float>& dtef, ACC<float>& stf,
                  int* arg_idx, const float* _b1)
{
    const float b1 = *_b1;
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    stf(0, 0, 0) = 1.0f;

    // C It is unclear yet if diss. corr. is needed when surf. waves are
    // included. c           if(gh(i,j,k).lt.0.e0) c    $
    // stf(i,j,k)=1.0e0-0.9e0*(gh(i,j,k)/ghc)**1.5e0 c if(gh(i,j,k).lt.ghc)
    // stf(i,j,k)=0.1e0
    /*             dtef(i,j,k)=sqrt(abs(q2b(i,j,k)))*stf(i,j,k)
         $                   /(b1*l(i,j,k)+small)
              end do
            end do
          end do */
    dtef(0, 0, 0) = sqrtf(fabsf(q2b(0, 0, 0))) * stf(0, 0, 0) / (b1 * l(0, 0, 0) + small);
}

void ext_profq_12(ACC<float>& ee, ACC<float>& gg, const ACC<float>& a, const ACC<float>& c,
                  const ACC<float>& dtef, const ACC<float>& uf, const ACC<float>& prod)
{
    gg(0, 0, 0) = 1.0f / (a(0, 0, 0) + c(0, 0, 0) * (1.0f - ee(0, 0, -1)) -
                          (2.0f * dti2 * dtef(0, 0, 0) + 1.0f));
    ee(0, 0, 0) = a(0, 0, 0) * gg(0, 0, 0);
    gg(0, 0, 0) =
        (-2.0f * dti2 * prod(0, 0, 0) + c(0, 0, 0) * gg(0, 0, -1) - uf(0, 0, 0)) * gg(0, 0, 0);
}

void ext_profq_13(const ACC<float>& ee, const ACC<float>& gg, ACC<float>& uf)
{
    uf(0, 0, 0) = ee(0, 0, 0) * uf(0, 0, 1) + gg(0, 0, 0);
}

void ext_profq_14(ACC<float>& ee, ACC<float>& gg, ACC<float>& vf, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    ee(0, 0, 1) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 1 itt
    gg(0, 0, 1) = 0.0f; // A k tag C-ben 0-tól számozódik, F-ben 1-től, ezért k az 1 itt
    vf(0, 0, kb - 1) = 0.0f;
}

void ext_profq_15(const ACC<float>& dh, ACC<float>& ee, const float* zmin, const float* zmax,
                  const ACC<float>& z, ACC<float>& dtef, const ACC<float>& l, const ACC<float>& a,
                  const ACC<float>& c, const ACC<float>& vf, const ACC<float>& prod, ACC<float>& gg,
                  const float* _e2, const float* _e1)
{
    const float e2 = *_e2;
    const float e1 = *_e1;
    dtef(0, 0, 0) =
        dtef(0, 0, 0) *
        (1.0f + e2 *
                    ((1.0f / fabsf(z(0, 0, 0) - *zmin) + 1.0f / fabsf(z(0, 0, 0) - *zmax)) *
                     l(0, 0, 0) / (dh(0, 0, 0) * kappa)) *
                    ((1.0f / fabsf(z(0, 0, 0) - *zmin) + 1.0f / fabsf(z(0, 0, 0) - *zmax)) *
                     l(0, 0, 0) / (dh(0, 0, 0) * kappa)));
    gg(0, 0, 0) =
        1.0f / (a(0, 0, 0) + c(0, 0, 0) * (1.0f - ee(0, 0, -1)) - (dti2 * dtef(0, 0, 0) + 1.0f));
    ee(0, 0, 0) = a(0, 0, 0) * gg(0, 0, 0);
    gg(0, 0, 0) =
        (dti2 * (-prod(0, 0, 0) * l(0, 0, 0) * e1) + c(0, 0, 0) * gg(0, 0, -1) - vf(0, 0, 0)) *
        gg(0, 0, 0);
}

void ext_profq_16(const ACC<float>& ee, const ACC<float>& gg, ACC<float>& vf)
{
    vf(0, 0, 0) = ee(0, 0, 0) * vf(0, 0, 1) + gg(0, 0, 0);
}

void ext_profq_17(const ACC<float>& dt, ACC<float>& uf, ACC<float>& vf)
{
    if ((uf(0, 0, 0) <= small) || (vf(0, 0, 0) <= small))
    {
        uf(0, 0, 0) = small;
        vf(0, 0, 0) = 0.1f * dt(0, 0, 0) * small;
    }
}

void ext_profq_18(ACC<float>& sm, ACC<float>& sh, const ACC<float>& gh, const ACC<float>& stf,
                  const float* _a1, const float* _b1, const float* _a2, const float* _b2,
                  const float* _c1, const float* _coef4, const float* _coef5)
{
    const float a1 = *_a1;
    const float b1 = *_b1;
    const float a2 = *_a2;
    const float b2 = *_b2;
    const float c1 = *_c1;
    const float coef4 = *_coef4;
    const float coef5 = *_coef5;
    real_t coef1 = a2 * (1.0f - 6.0f * a1 / b1 * stf(0, 0, 0));
    real_t coef2 = 3.0f * a2 * b2 / stf(0, 0, 0) + 18.0f * a1 * a2;
    real_t coef3 = a1 * (1.0f - 3.0f * c1 - 6.0f * a1 / b1 * stf(0, 0, 0));
    sh(0, 0, 0) = coef1 / (1.0f - coef2 * gh(0, 0, 0));
    sm(0, 0, 0) = coef3 + sh(0, 0, 0) * coef4 * gh(0, 0, 0);
    sm(0, 0, 0) = sm(0, 0, 0) / (1.0f - coef5 * gh(0, 0, 0));
}

void ext_profq_19(const ACC<float>& sm, const ACC<float>& sh, const ACC<float>& q2,
                  const ACC<float>& l, ACC<float>& km, ACC<float>& kq, ACC<float>& kh,
                  ACC<float>& prod)
{
    prod(0, 0, 0) = l(0, 0, 0) * sqrtf(fabsf(q2(0, 0, 0)));
    kq(0, 0, 0) = (prod(0, 0, 0) * 0.41f * sh(0, 0, 0) + kq(0, 0, 0)) * 0.5f;
    km(0, 0, 0) = (prod(0, 0, 0) * sm(0, 0, 0) + km(0, 0, 0)) * 0.5f;
    kh(0, 0, 0) = (prod(0, 0, 0) * sh(0, 0, 0) + kh(0, 0, 0)) * 0.5f;
}

void ext_profq_20(const ACC<float>& fsm, ACC<float>& km, ACC<float>& kh, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    km(0, jm - 1, 0) = km(0, jmm1 - 1, 0) * fsm(0, jm - 1, 0);
    kh(0, jm - 1, 0) = kh(0, jmm1 - 1, 0) * fsm(0, jm - 1, 0);
    km(0, 0, 0) = km(0, 1, 0) * fsm(0, 0, 0); // j 0-tól számozódik C-ben, nem 1-től
    kh(0, 0, 0) = kh(0, 1, 0) * fsm(0, 0, 0); // j 0-tól számozódik C-ben, nem 1-től
}

void ext_profq_21(const ACC<float>& fsm, ACC<float>& km, ACC<float>& kh, int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
    km(im - 1, 0, 0) = km(imm1 - 1, 0, 0) * fsm(im - 1, 0, 0);
    kh(im - 1, 0, 0) = kh(imm1 - 1, 0, 0) * fsm(im - 1, 0, 0);
    km(0, 0, 0) = km(1, 0, 0) * fsm(0, 0, 0); // i 0-tól számozódik C-ben, nem 1-től
    kh(0, 0, 0) = kh(1, 0, 0) * fsm(0, 0, 0); // i 0-tól számozódik C-ben, nem 1-től
}

void ext_bcond_1_0(ACC<float>& elf)
{
    elf(0, 0, 0) = elf(1, 0, 0);
    elf(imm1, 0, 0) = elf(imm2, 0, 0);
}

void ext_bcond_1_1(ACC<float>& elf)
{
    elf(0, 0, 0) = elf(0, 1, 0);
    elf(0, jmm1, 0) = elf(0, jmm2, 0);
}

void ext_bcond_1_2(ACC<float>& elf, const ACC<float>& fsm)
{
    elf(0, 0, 0) = elf(0, 0, 0) * fsm(0, 0, 0);
}

void ext_advv_0(ACC<float>& vf)
{
    vf(0, 0, 0) = 0.0f;
}

void ext_advv_1(const ACC<float>& v, ACC<float>& vf, const ACC<float>& w)
{
    vf(0, 0, 0) = 0.25f * (w(0, 0, 0) + w(0, -1, 0)) * (v(0, 0, 0) + v(0, 0, -1));
}

void ext_advv_2(ACC<float>& vf, const ACC<float>& dt, const ACC<float>& u, const ACC<float>& egb,
                const ACC<float>& advy, const ACC<float>& arv, const ACC<float>& e_atmos,
                const ACC<float>& dz, const ACC<float>& cor, const ACC<float>& dx,
                const ACC<float>& drhoy, const ACC<float>& egf)
{
    vf(0, 0, 0) = advy(0, 0, 0) + (vf(0, 0, 0) - vf(0, 0, 1)) * arv(0, 0, 0) / dz(0, 0, 0) +
                  arv(0, 0, 0) * 0.25f *
                      (cor(0, 0, 0) * dt(0, 0, 0) * (u(1, 0, 0) + u(0, 0, 0)) +
                       cor(0, -1, 0) * dt(0, -1, 0) * (u(1, -1, 0) + u(0, -1, 0))) +
                  grav * 0.125f * (dt(0, 0, 0) + dt(0, -1, 0)) *
                      (egf(0, 0, 0) - egf(0, -1, 0) + egb(0, 0, 0) - egb(0, -1, 0) +
                       (e_atmos(0, 0, 0) - e_atmos(0, -1, 0)) * 2.0f) *
                      (dx(0, 0, 0) + dx(0, -1, 0)) +
                  drhoy(0, 0, 0);
}

void ext_advv_3(ACC<float>& vf, const ACC<float>& vb, const ACC<float>& h, const ACC<float>& arv,
                const ACC<float>& etb, const ACC<float>& etf)
{
    vf(0, 0, 0) =
        ((h(0, 0, 0) + etb(0, 0, 0) + h(0, -1, 0) + etb(0, -1, 0)) * arv(0, 0, 0) * vb(0, 0, 0) -
         2.0f * dti2 * vf(0, 0, 0)) /
        ((h(0, 0, 0) + etf(0, 0, 0) + h(0, -1, 0) + etf(0, -1, 0)) * arv(0, 0, 0));
}

void ext_vert_avgs_0(ACC<float>& adx2d, ACC<float>& ady2d, ACC<float>& drx2d, ACC<float>& dry2d,
                     ACC<float>& aam2d)
{
    adx2d(0, 0, 0) = 0.0f;
    ady2d(0, 0, 0) = 0.0f;
    drx2d(0, 0, 0) = 0.0f;
    dry2d(0, 0, 0) = 0.0f;
    aam2d(0, 0, 0) = 0.0f;
}

void ext_vert_avgs_1(ACC<float>& adx2d, const ACC<float>& dz, ACC<float>& ady2d, ACC<float>& drx2d,
                     ACC<float>& dry2d, const ACC<float>& advx, const ACC<float>& advy,
                     const ACC<float>& drhox, const ACC<float>& drhoy, const ACC<float>& aam,
                     ACC<float>& aam2d)
{
    adx2d(0, 0, 0) += advx(0, 0, 0) * dz(0, 0, 0);
    ady2d(0, 0, 0) += advy(0, 0, 0) * dz(0, 0, 0);
    drx2d(0, 0, 0) += drhox(0, 0, 0) * dz(0, 0, 0);
    dry2d(0, 0, 0) += drhoy(0, 0, 0) * dz(0, 0, 0);
    aam2d(0, 0, 0) += aam(0, 0, 0) * dz(0, 0, 0);
}

void ext_apply_filter_0(ACC<float>& va, const float* smoth, ACC<float>& vab, const ACC<float>& vaf,
                        ACC<float>& el, ACC<float>& elb, ACC<float>& ua, ACC<float>& uab,
                        const ACC<float>& uaf, ACC<float>& d, const ACC<float>& h,
                        const ACC<float>& elf)
{
    ua(0, 0, 0) = ua(0, 0, 0) + .5f * *smoth * (uab(0, 0, 0) - 2.0f * ua(0, 0, 0) + uaf(0, 0, 0));
    va(0, 0, 0) = va(0, 0, 0) + .5f * *smoth * (vab(0, 0, 0) - 2.0f * va(0, 0, 0) + vaf(0, 0, 0));
    el(0, 0, 0) = el(0, 0, 0) + .5f * *smoth * (elb(0, 0, 0) - 2.0f * el(0, 0, 0) + elf(0, 0, 0));
    elb(0, 0, 0) = el(0, 0, 0);
    el(0, 0, 0) = elf(0, 0, 0);
    d(0, 0, 0) = h(0, 0, 0) + el(0, 0, 0);
    uab(0, 0, 0) = ua(0, 0, 0);
    ua(0, 0, 0) = uaf(0, 0, 0);
    vab(0, 0, 0) = va(0, 0, 0);
    va(0, 0, 0) = vaf(0, 0, 0);
}

void ext_apply_filter_1(const ACC<float>& el, const float* ispi, ACC<float>& egf)
{
    egf(0, 0, 0) = egf(0, 0, 0) + el(0, 0, 0) * *ispi;
}

void ext_apply_filter_2(const float* isp2i, const ACC<float>& ua, const ACC<float>& d,
                        ACC<float>& utf)
{
    utf(0, 0, 0) = utf(0, 0, 0) + ua(0, 0, 0) * (d(0, 0, 0) + d(-1, 0, 0)) * *isp2i;
}

void ext_apply_filter_3(const ACC<float>& va, ACC<float>& vtf, const float* isp2i,
                        const ACC<float>& d)
{
    vtf(0, 0, 0) = vtf(0, 0, 0) + va(0, 0, 0) * (d(0, 0, 0) + d(0, -1, 0)) * *isp2i;
}

void ext_vertvl_0(ACC<float>& xflux, const ACC<float>& dy, const ACC<float>& dt,
                  const ACC<float>& u)
{
    xflux(0, 0, 0) =
        .25f * (dy(0, 0, 0) + dy(-1, 0, 0)) * (dt(0, 0, 0) + dt(-1, 0, 0)) * u(0, 0, 0);
}

void ext_vertvl_1(ACC<float>& yflux, const ACC<float>& dx, const ACC<float>& dt,
                  const ACC<float>& v)
{
    yflux(0, 0, 0) =
        .25f * (dx(0, 0, 0) + dx(0, -1, 0)) * (dt(0, 0, 0) + dt(0, -1, 0)) * v(0, 0, 0);
}

void ext_vertvl_2(ACC<float>& w, const ACC<float>& vfluxb, const ACC<float>& vfluxf)
{
    w(0, 0, 0) = 0.5f * (vfluxb(0, 0, 0) + vfluxf(0, 0, 0));
}

void ext_vertvl_3(const ACC<float>& xflux, const ACC<float>& yflux, const ACC<float>& dx,
                  const ACC<float>& dz, const ACC<float>& dy, const ACC<float>& etb, ACC<float>& w,
                  const float* dti2, const ACC<float>& etf)
{
    w(0, 0, 0) =
        w(0, 0, -1) +
        dz(0, 0, 0 - 1) * ((xflux(1, 0, -1) - xflux(0, 0, -1) + yflux(0, 1, -1) - yflux(0, 0, -1)) /
                               (dx(0, 0, 0) * dy(0, 0, 0)) +
                           (etf(0, 0, 0) - etb(0, 0, 0)) / (*dti2));
}

void ext_updeta_t_s_0(ACC<float>& t, ACC<float>& tb, ACC<float>& s, ACC<float>& sb,
                      const ACC<float>& uf, const ACC<float>& vf, const float* smoth)
{
    t(0, 0, 0) = t(0, 0, 0) + 0.5f * (*smoth) * (uf(0, 0, 0) + tb(0, 0, 0) - 2.0f * t(0, 0, 0));
    s(0, 0, 0) = s(0, 0, 0) + 0.5f * (*smoth) * (vf(0, 0, 0) + sb(0, 0, 0) - 2.0f * s(0, 0, 0));
    tb(0, 0, 0) = t(0, 0, 0);
    t(0, 0, 0) = uf(0, 0, 0);
    sb(0, 0, 0) = s(0, 0, 0);
    s(0, 0, 0) = vf(0, 0, 0);
}

void ext_uaf_0(const ACC<float>& elf, const ACC<float>& e_atmos, const ACC<float>& drx2d,
               const ACC<float>& wusurf, const ACC<float>& wubot, ACC<float>& uaf,
               const ACC<float>& adx2d, const ACC<float>& advua, const ACC<float>& aru,
               const ACC<float>& cor, const ACC<float>& d, const ACC<float>& va,
               const ACC<float>& dy, const ACC<float>& el, const ACC<float>& elb)
{
    uaf(0, 0, 0) = adx2d(0, 0, 0) + advua(0, 0, 0) -
                   aru(0, 0, 0) * .25f *
                       (cor(0, 0, 0) * d(0, 0, 0) * (va(0, 1, 0) + va(0, 0, 0)) +
                        cor(-1, 0, 0) * d(-1, 0, 0) * (va(-1, 1, 0) + va(-1, 0, 0))) +
                   .25f * grav * (dy(0, 0, 0) + dy(-1, 0, 0)) * (d(0, 0, 0) + d(-1, 0, 0)) *
                       ((1.0f - 2.0f * alpha) * (el(0, 0, 0) - el(-1, 0, 0)) +
                        alpha * (elb(0, 0, 0) - elb(-1, 0, 0) + elf(0, 0, 0) - elf(-1, 0, 0)) +
                        e_atmos(0, 0, 0) - e_atmos(-1, 0, 0)) +
                   drx2d(0, 0, 0) + aru(0, 0, 0) * (wusurf(0, 0, 0) - wubot(0, 0, 0));
}

void ext_uaf_1(ACC<float>& uaf, const ACC<float>& elf, const ACC<float>& aru, const ACC<float>& h,
               const ACC<float>& uab, const ACC<float>& elb)
{
    uaf(0, 0, 0) =
        ((h(0, 0, 0) + elb(0, 0, 0) + h(-1, 0, 0) + elb(-1, 0, 0)) * aru(0, 0, 0) * uab(0, 0, 0) -
         4.0f * dte * uaf(0, 0, 0)) /
        ((h(0, 0, 0) + elf(0, 0, 0) + h(-1, 0, 0) + elf(-1, 0, 0)) * aru(0, 0, 0));
}

void ext_update_turbulane_0(ACC<float>& q2, ACC<float>& q2b, ACC<float>& q2l, ACC<float>& q2lb,
                            const ACC<float>& uf, const ACC<float>& vf, const float* smoth)
{
    q2(0, 0, 0) += 0.5f * (*smoth) * (uf(0, 0, 0) + q2b(0, 0, 0) - 2.0f * q2(0, 0, 0));
    q2l(0, 0, 0) += 0.5f * (*smoth) * (vf(0, 0, 0) + q2lb(0, 0, 0) - 2.0f * q2l(0, 0, 0));
    q2b(0, 0, 0) = q2(0, 0, 0);
    q2(0, 0, 0) = uf(0, 0, 0);
    q2lb(0, 0, 0) = q2l(0, 0, 0);
    q2l(0, 0, 0) = vf(0, 0, 0);
}

void ext_final_internal_update_0(const ACC<float>& vtf, ACC<float>& vfluxb,
                                 const ACC<float>& vfluxf, ACC<float>& egb, const ACC<float>& egf,
                                 ACC<float>& etb, ACC<float>& et, const ACC<float>& etf,
                                 ACC<float>& dt, const ACC<float>& h, ACC<float>& utb,
                                 const ACC<float>& utf, ACC<float>& vtb)
{
    egb(0, 0, 0) = egf(0, 0, 0);
    etb(0, 0, 0) = et(0, 0, 0);
    et(0, 0, 0) = etf(0, 0, 0);
    dt(0, 0, 0) = h(0, 0, 0) + et(0, 0, 0);
    utb(0, 0, 0) = utf(0, 0, 0);
    vtb(0, 0, 0) = vtf(0, 0, 0);
    vfluxb(0, 0, 0) = vfluxf(0, 0, 0);
}

void ext_bcond_3_0(const ACC<float>& h, ACC<float>& uf, const ACC<float>& u, ACC<float>& vf,
                   int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
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
    ga = sqrtf(h(im - 1, 0, 0) / hmax);
    uf(im - 1, 0, 0) =
        ga * (0.25f * u(imm1 - 1, -1, 0) + 0.5f * u(imm1 - 1, 0, 0) + 0.25f * u(imm1 - 1, 1, 0)) +
        (1.0f - ga) * (0.25f * u(im - 1, -1, 0) + 0.5f * u(im - 1, 0, 0) + 0.25f * u(im - 1, 1, 0));
    vf(im - 1, 0, 0) = 0.0f;

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
    ga = sqrtf(h(0, 0, 0) / hmax);
    uf(1, 0, 0) = ga * (0.25f * u(2, -1, 0) + 0.5f * u(2, 0, 0) + 0.25f * u(2, 1, 0)) +
                  (1.0f - ga) * (0.25f * u(1, -1, 0) + 0.5f * u(1, 0, 0) + 0.25f * u(1, 1, 0));
    uf(0, 0, 0) = uf(1, 0, 0);
    vf(0, 0, 0) = 0.0f;
}

void ext_bcond_3_1(const ACC<float>& h, ACC<float>& uf, ACC<float>& vf, const ACC<float>& v,
                   int* arg_idx)
{
    int i = arg_idx[0];
    int j = arg_idx[1];
    int k = arg_idx[2];
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
    ga = sqrtf(h(0, jm - 1, 0) / hmax);
    vf(0, jm - 1, 0) =
        ga * (0.25f * v(-1, jmm1 - 1, 0) + 0.5f * v(0, jmm1 - 1, 0) + 0.25f * v(1, jmm1 - 1, 0)) +
        (1.0f - ga) * (0.25f * v(-1, jm - 1, 0) + 0.5f * v(0, jm - 1, 0) + 0.25f * v(1, jm - 1, 0));
    uf(0, jm - 1, 0) = 0.0f;
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
    ga = sqrtf(h(0, 0, 0) / hmax);
    vf(0, 1, 0) = ga * (0.25f * v(-1, 2, 0) + 0.5f * v(0, 2, 0) + 0.25f * v(1, 2, 0)) +
                  (1.0f - ga) * (0.25f * v(-1, 1, 0) + 0.5f * v(0, 1, 0) + 0.25f * v(1, 1, 0));
    vf(0, 0, 0) = vf(0, 1, 0);
    uf(0, 0, 0) = 0.0f;
}

void ext_bcond_3_2(ACC<float>& uf, ACC<float>& vf, const ACC<float>& dum, const ACC<float>& dvm)
{
    uf(0, 0, 0) = uf(0, 0, 0) * dum(0, 0, 0);
    vf(0, 0, 0) = vf(0, 0, 0) * dvm(0, 0, 0);
}

void ext_advct_0(ACC<float>& xflux, ACC<float>& yflux, ACC<float>& curv, ACC<float>& advx)
{
    curv(0, 0, 0) = 0.0f;
    advx(0, 0, 0) = 0.0f;
    xflux(0, 0, 0) = 0.0f;
    yflux(0, 0, 0) = 0.0f;
}

void ext_advct_1(ACC<float>& curv, const ACC<float>& u, const ACC<float>& v, const ACC<float>& dx,
                 const ACC<float>& dy)
{
    curv(0, 0, 0) = 0.25f *
                    ((v(0, 1, 0) + v(0, 0, 0)) * (dy(1, 0, 0) - dy(-1, 0, 0)) -
                     (u(1, 0, 0) + u(0, 0, 0)) * (dx(0, 1, 0) - dx(0, -1, 0))) /
                    (dx(0, 0, 0) * dy(0, 0, 0));
}

void ext_advct_2(ACC<float>& xflux, const ACC<float>& u, const ACC<float>& dt)
{
    xflux(0, 0, 0) =
        0.125f *
        ((dt(1, 0, 0) + dt(0, 0, 0)) * u(1, 0, 0) + (dt(0, 0, 0) + dt(-1, 0, 0)) * u(0, 0, 0)) *
        (u(1, 0, 0) + u(0, 0, 0));
}

void ext_advct_3(ACC<float>& yflux, const ACC<float>& u, const ACC<float>& v, const ACC<float>& dt)
{
    yflux(0, 0, 0) =
        0.125f *
        ((dt(0, 0, 0) + dt(0, -1, 0)) * v(0, 0, 0) + (dt(-1, 0, 0) + dt(-1, -1, 0)) * v(-1, 0, 0)) *
        (u(0, 0, 0) + u(0, -1, 0));
}

void ext_advct_4(ACC<float>& xflux, const ACC<float>& aam, const ACC<float>& ub,
                 const ACC<float>& vb, ACC<float>& yflux, const ACC<float>& dx,
                 const ACC<float>& dy, const ACC<float>& dt)
{
    xflux(0, 0, 0) -= dt(0, 0, 0) * aam(0, 0, 0) * 2.0f * (ub(1, 0, 0) - ub(0, 0, 0)) / dx(0, 0, 0);

    real_t dtaam = 0.25f * (dt(0, 0, 0) + dt(-1, 0, 0) + dt(0, -1, 0) + dt(-1, -1, 0)) *
                   (aam(0, 0, 0) + aam(-1, 0, 0) + aam(0, -1, 0) + aam(-1, -1, 0));

    yflux(0, 0, 0) -= (dtaam * ((ub(0, 0, 0) - ub(0, -1, 0)) /
                                    (dy(0, 0, 0) + dy(-1, 0, 0) + dy(0, -1, 0) + dy(-1, -1, 0)) +
                                (vb(0, 0, 0) - vb(-1, 0, 0)) /
                                    (dx(0, 0, 0) + dx(-1, 0, 0) + dx(0, -1, 0) + dx(-1, -1, 0))));

    xflux(0, 0, 0) = dy(0, 0, 0) * xflux(0, 0, 0);
    yflux(0, 0, 0) =
        0.25f * (dx(0, 0, 0) + dx(-1, 0, 0) + dx(0, -1, 0) + dx(-1, -1, 0)) * yflux(0, 0, 0);
}

void ext_advct_5(const ACC<float>& xflux, const ACC<float>& yflux, ACC<float>& advx)
{
    advx(0, 0, 0) = xflux(0, 0, 0) - xflux(-1, 0, 0) + yflux(0, 1, 0) - yflux(0, 0, 0);
}

void ext_advct_6(const ACC<float>& curv, ACC<float>& advx, const ACC<float>& aru,
                 const ACC<float>& v, const ACC<float>& dt)
{
    advx(0, 0, 0) -= (aru(0, 0, 0) * 0.25f *
                      (curv(0, 0, 0) * dt(0, 0, 0) * (v(0, 1, 0) + v(0, 0, 0)) +
                       curv(-1, 0, 0) * dt(-1, 0, 0) * (v(-1, 1, 0) + v(-1, 0, 0))));
}

void ext_advct_7(ACC<float>& xflux, ACC<float>& yflux, ACC<float>& advy)
{
    advy(0, 0, 0) = 0.0f;
    xflux(0, 0, 0) = 0.0f;
    yflux(0, 0, 0) = 0.0f;
}

void ext_advct_8(ACC<float>& xflux, const ACC<float>& u, const ACC<float>& v, const ACC<float>& dt)
{
    xflux(0, 0, 0) =
        0.125f *
        ((dt(0, 0, 0) + dt(-1, 0, 0)) * u(0, 0, 0) + (dt(0, -1, 0) + dt(-1, -1, 0)) * u(0, -1, 0)) *
        (v(0, 0, 0) + v(-1, 0, 0));
}

void ext_advct_9(ACC<float>& yflux, const ACC<float>& v, const ACC<float>& dt)
{
    yflux(0, 0, 0) =
        0.125f *
        ((dt(0, 1, 0) + dt(0, 0, 0)) * v(0, 1, 0) + (dt(0, 0, 0) + dt(0, -1, 0)) * v(0, 0, 0)) *
        (v(0, 1, 0) + v(0, 0, 0));
}

void ext_advct_10(ACC<float>& xflux, const ACC<float>& aam, const ACC<float>& ub,
                  const ACC<float>& vb, ACC<float>& yflux, const ACC<float>& dx,
                  const ACC<float>& dy, const ACC<float>& dt)
{
    real_t dtaam = 0.25f * (dt(0, 0, 0) + dt(-1, 0, 0) + dt(0, -1, 0) + dt(-1, -1, 0)) *
                   (aam(0, 0, 0) + aam(-1, 0, 0) + aam(0, -1, 0) + aam(-1, -1, 0));

    xflux(0, 0, 0) -= (dtaam * ((ub(0, 0, 0) - ub(0, -1, 0)) /
                                    (dy(0, 0, 0) + dy(-1, 0, 0) + dy(0, -1, 0) + dy(-1, -1, 0)) +
                                (vb(0, 0, 0) - vb(-1, 0, 0)) /
                                    (dx(0, 0, 0) + dx(-1, 0, 0) + dx(0, -1, 0) + dx(-1, -1, 0))));

    yflux(0, 0, 0) -= dt(0, 0, 0) * aam(0, 0, 0) * 2.0f * (vb(0, 1, 0) - vb(0, 0, 0)) / dy(0, 0, 0);

    xflux(0, 0, 0) =
        0.25f * (dy(0, 0, 0) + dy(-1, 0, 0) + dy(0, -1, 0) + dy(-1, -1, 0)) * xflux(0, 0, 0);
    yflux(0, 0, 0) = dx(0, 0, 0) * yflux(0, 0, 0);
}

void ext_advct_11(const ACC<float>& xflux, const ACC<float>& yflux, ACC<float>& advy)
{
    advy(0, 0, 0) = xflux(1, 0, 0) - xflux(0, 0, 0) + yflux(0, 0, 0) - yflux(0, -1, 0);
}

void ext_advct_12(const ACC<float>& curv, ACC<float>& advy, const ACC<float>& arv,
                  const ACC<float>& u, const ACC<float>& dt)
{
    advy(0, 0, 0) += (arv(0, 0, 0) * 0.25f *
                      (curv(0, 0, 0) * dt(0, 0, 0) * (u(1, 0, 0) + u(0, 0, 0)) +
                       curv(0, -1, 0) * dt(0, -1, 0) * (u(1, -1, 0) + u(0, -1, 0))));
}

void ext_dens_0(const ACC<float>& si, const ACC<float>& ti, ACC<float>& rhoo, const ACC<float>& h,
                const ACC<float>& fsm, const ACC<float>& zz, const float* tbias, const float* sbias)
{
    real_t cr, p, rhor, sr, tr, tr2, tr3, tr4;
    tr = ti(0, 0, 0) + *tbias;
    sr = si(0, 0, 0) + *sbias;
    tr2 = tr * tr;
    tr3 = tr2 * tr;
    tr4 = tr3 * tr;
    // C
    // C     Approximate pressure in units of bars:
    // C
    p = grav * rhoref * (-zz(0, 0, 0) * h(0, 0, 0)) * 1.e-5f;
    rhor = -0.157406f + 6.793952e-2f * tr - 9.095290e-3f * tr2 + 1.001685e-4f * tr3 -
           1.120083e-6f * tr4 + 6.536332e-9f * tr4 * tr;
    rhor = rhor +
           (0.824493f - 4.0899e-3f * tr + 7.6438e-5f * tr2 - 8.2467e-7f * tr3 + 5.3875e-9f * tr4) *
               sr +
           (-5.72466e-3f + 1.0227e-4f * tr - 1.6546e-6f * tr2) * powf(fabs(sr), 1.5f) +
           4.8314e-4f * sr * sr;
    cr = 1449.1f + .0821f * p + 4.55f * tr - .045f * tr2 + 1.34f * (sr - 35.0f);
    rhor = rhor + 1.e5f * p / (cr * cr) * (1.0f - 2.0f * p / (cr * cr));
    rhoo(0, 0, 0) = rhor / rhoref * fsm(0, 0, 0);
}

void ext_init_horizontal_velocities_0(ACC<float>& uf, ACC<float>& vf)
{
    uf(0, 0, 0) = 0.0f;
    vf(0, 0, 0) = 0.0f;
}

void ext_update_u_v_0(ACC<float>& tps)
{
    tps(0, 0, 0) = 0.0f;
}

void ext_update_u_v_1(ACC<float>& tps, const ACC<float>& u, const ACC<float>& uf,
                      const ACC<float>& ub, const ACC<float>& dz)
{
    tps(0, 0, 0) += (uf(0, 0, 0) + ub(0, 0, 0) - 2.0f * u(0, 0, 0)) * dz(0, 0, 0);
}

void ext_update_u_v_2(const ACC<float>& tps, ACC<float>& u, const ACC<float>& uf,
                      const ACC<float>& ub, const float* smoth)
{
    u(0, 0, 0) += 0.5f * (*smoth) * (uf(0, 0, 0) + ub(0, 0, 0) - 2.0f * u(0, 0, 0) - tps(0, 0, 0));
}

void ext_update_u_v_3(ACC<float>& tps)
{
    tps(0, 0, 0) = 0.0f;
}

void ext_update_u_v_4(ACC<float>& tps, const ACC<float>& v, const ACC<float>& vf,
                      const ACC<float>& vb, const ACC<float>& dz)
{
    tps(0, 0, 0) += (vf(0, 0, 0) + vb(0, 0, 0) - 2.0f * v(0, 0, 0)) * dz(0, 0, 0);
}

void ext_update_u_v_5(const ACC<float>& tps, ACC<float>& v, const ACC<float>& vf,
                      const ACC<float>& vb, const float* smoth)
{
    v(0, 0, 0) += 0.5f * (*smoth) * (vf(0, 0, 0) + vb(0, 0, 0) - 2.0f * v(0, 0, 0) - tps(0, 0, 0));
}

void ext_update_u_v_6(ACC<float>& u, const ACC<float>& uf, ACC<float>& ub, ACC<float>& v,
                      const ACC<float>& vf, ACC<float>& vb)
{
    ub(0, 0, 0) = u(0, 0, 0);
    u(0, 0, 0) = uf(0, 0, 0);
    vb(0, 0, 0) = v(0, 0, 0);
    v(0, 0, 0) = vf(0, 0, 0);
}

void ext_comp_vamax_0(const ACC<float>& vaf, float* vamax)
{
    *vamax = MAX(*vamax, fabs(vaf(0, 0, 0)));
}

void ext_comp_vamax_1(const ACC<float>& vaf, const float* vamax, const int* idx, int* imax,
                      int* jmax)
{
    if (fabs(vaf(0, 0, 0)) == *vamax)
    {
        *imax = idx[0];
        *jmax = idx[1];
    }
}
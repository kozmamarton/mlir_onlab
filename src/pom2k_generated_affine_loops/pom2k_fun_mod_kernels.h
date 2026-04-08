void ext_vaf_0(ACC<float>& vaf, const ACC<float>& dx, const ACC<float>& wvbot,
               const ACC<float>& advva, const ACC<float>& elb, const ACC<float>& cor,
               const ACC<float>& e_atmos, const ACC<float>& ua, const ACC<float>& wvsurf,
               const ACC<float>& ady2d, const ACC<float>& el, const ACC<float>& arv,
               const ACC<float>& elf, const ACC<float>& d, const ACC<float>& dry2d)
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
void ext_vaf_1(ACC<float>& vaf, const ACC<float>& elb, const ACC<float>& vab, const ACC<float>& h,
               const ACC<float>& arv, const ACC<float>& elf)
{

    vaf(0, 0, 0) =
        ((h(0, 0, 0) + elb(0, 0, 0) + h(0, -1, 0) + elb(0, -1, 0)) * vab(0, 0, 0) * arv(0, 0, 0) -
         4.0f * dte * vaf(0, 0, 0)) /
        ((h(0, 0, 0) + elf(0, 0, 0) + h(0, -1, 0) + elf(0, -1, 0)) * arv(0, 0, 0));
}
// MLIR (scf.parallel / scf.for) version of ext_profu_transformed.
// Layout: ACC2(i,j) = i + j*im  -> memref [jm][im]
//         ACC3(i,j,k) = i + j*im + k*im*jm -> memref [kb][jm][im]
// k-recurrences (forward elimination, back substitution) stay sequential
// (scf.for); every (j,i) / (k,j,i) space without a carried dependency is scf.parallel.
module {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>

  func.func @ext_profu_transformed(
      %h: memref<?xf32>, %etf: memref<?xf32>, %c: memref<?xf32>, %km: memref<?xf32>,
      %a: memref<?xf32>, %dz: memref<?xf32>, %dzz: memref<?xf32>, %ee: memref<?xf32>,
      %gg: memref<?xf32>, %wusurf: memref<?xf32>, %uf: memref<?xf32>, %tps: memref<?xf32>,
      %cbc: memref<?xf32>, %ub: memref<?xf32>, %vb: memref<?xf32>, %dum: memref<?xf32>,
      %wubot: memref<?xf32>, %dhloc: memref<?xf32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %f0_5 = arith.constant 0.5 : f32
    %f0_25 = arith.constant 0.25 : f32
    %f1 = arith.constant 1.0 : f32

    // ---- scalars ----
    %im_g = memref.get_global @im : memref<1xi32>
    %jm_g = memref.get_global @jm : memref<1xi32>
    %kb_g = memref.get_global @kb : memref<1xi32>
    %imm1_g = memref.get_global @imm1 : memref<1xi32>
    %jmm1_g = memref.get_global @jmm1 : memref<1xi32>
    %kbm1_g = memref.get_global @kbm1 : memref<1xi32>
    %kbm2_g = memref.get_global @kbm2 : memref<1xi32>
    %umol_g = memref.get_global @umol : memref<1xf32>
    %dti2_g = memref.get_global @dti2 : memref<1xf32>
    %im_i = memref.load %im_g[%c0] : memref<1xi32>
    %jm_i = memref.load %jm_g[%c0] : memref<1xi32>
    %kb_i = memref.load %kb_g[%c0] : memref<1xi32>
    %imm1_i = memref.load %imm1_g[%c0] : memref<1xi32>
    %jmm1_i = memref.load %jmm1_g[%c0] : memref<1xi32>
    %kbm1_i = memref.load %kbm1_g[%c0] : memref<1xi32>
    %kbm2_i = memref.load %kbm2_g[%c0] : memref<1xi32>
    %im = arith.index_cast %im_i : i32 to index
    %jm = arith.index_cast %jm_i : i32 to index
    %kb = arith.index_cast %kb_i : i32 to index
    %imm1 = arith.index_cast %imm1_i : i32 to index
    %jmm1 = arith.index_cast %jmm1_i : i32 to index
    %kbm1 = arith.index_cast %kbm1_i : i32 to index
    %kbm2 = arith.index_cast %kbm2_i : i32 to index
    %umol = memref.load %umol_g[%c0] : memref<1xf32>
    %dti2 = memref.load %dti2_g[%c0] : memref<1xf32>
    %ndti2 = arith.negf %dti2 : f32
    %stride_k = arith.muli %im, %jm : index

    // ---- 2D / 3D views of the flat buffers ----
    %h2 = memref.reinterpret_cast %h to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %etf2 = memref.reinterpret_cast %etf to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %dh2 = memref.reinterpret_cast %dhloc to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %wus2 = memref.reinterpret_cast %wusurf to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %tps2 = memref.reinterpret_cast %tps to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %cbc2 = memref.reinterpret_cast %cbc to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %dum2 = memref.reinterpret_cast %dum to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %wub2 = memref.reinterpret_cast %wubot to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %km3 = memref.reinterpret_cast %km to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %c3 = memref.reinterpret_cast %c to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %a3 = memref.reinterpret_cast %a to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %ee3 = memref.reinterpret_cast %ee to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %gg3 = memref.reinterpret_cast %gg to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %uf3 = memref.reinterpret_cast %uf to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %ub3 = memref.reinterpret_cast %ub to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %vb3 = memref.reinterpret_cast %vb to offset: [0], sizes: [%kb, %jm, %im], strides: [%stride_k, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>

    // ---- loop 1: dhloc (fusion 1, boundary = 1.0) ----
    scf.parallel (%j, %i) = (%c0, %c0) to (%jm, %im) step (%c1, %c1) {
      %jp = arith.cmpi sgt, %j, %c0 : index
      %ip = arith.cmpi sgt, %i, %c0 : index
      %inner = arith.andi %jp, %ip : i1
      %v = scf.if %inner -> f32 {
        %im1 = arith.subi %i, %c1 : index
        %h0 = memref.load %h2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
        %e0 = memref.load %etf2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
        %h1 = memref.load %h2[%j, %im1] : memref<?x?xf32, strided<[?, 1]>>
        %e1 = memref.load %etf2[%j, %im1] : memref<?x?xf32, strided<[?, 1]>>
        %s0 = arith.addf %h0, %e0 : f32
        %s1 = arith.addf %s0, %h1 : f32
        %s2 = arith.addf %s1, %e1 : f32
        %r = arith.mulf %s2, %f0_5 : f32
        scf.yield %r : f32
      } else {
        scf.yield %f1 : f32
      }
      memref.store %v, %dh2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce
    }

    // ---- loop 2: c = average of km in i ----
    scf.parallel (%k, %j, %i) = (%c0, %c1, %c1) to (%kb, %jm, %im) step (%c1, %c1, %c1) {
      %im1 = arith.subi %i, %c1 : index
      %k0 = memref.load %km3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %k1 = memref.load %km3[%k, %j, %im1] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %s = arith.addf %k0, %k1 : f32
      %r = arith.mulf %s, %f0_5 : f32
      memref.store %r, %c3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce
    }

    // ---- loop 3: a (reads c[k+1], must precede loop 4 which rewrites c) ----
    scf.parallel (%k, %j, %i) = (%c0, %c0, %c0) to (%kbm2, %jm, %im) step (%c1, %c1, %c1) {
      %kp1 = arith.addi %k, %c1 : index
      %cv = memref.load %c3[%kp1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %dzk = memref.load %dz[%k] : memref<?xf32>
      %dzzk = memref.load %dzz[%k] : memref<?xf32>
      %dh = memref.load %dh2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
      %t = arith.addf %cv, %umol : f32
      %num = arith.mulf %ndti2, %t : f32
      %d0 = arith.mulf %dzk, %dzzk : f32
      %d1 = arith.mulf %d0, %dh : f32
      %d2 = arith.mulf %d1, %dh : f32
      %r = arith.divf %num, %d2 : f32
      memref.store %r, %a3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce
    }

    // ---- loop 4: c (in place, pointwise -> parallel) ----
    scf.parallel (%k, %j, %i) = (%c1, %c0, %c0) to (%kbm1, %jm, %im) step (%c1, %c1, %c1) {
      %km1 = arith.subi %k, %c1 : index
      %cv = memref.load %c3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %dzk = memref.load %dz[%k] : memref<?xf32>
      %dzzk = memref.load %dzz[%km1] : memref<?xf32>
      %dh = memref.load %dh2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
      %t = arith.addf %cv, %umol : f32
      %num = arith.mulf %ndti2, %t : f32
      %d0 = arith.mulf %dzk, %dzzk : f32
      %d1 = arith.mulf %d0, %dh : f32
      %d2 = arith.mulf %d1, %dh : f32
      %r = arith.divf %num, %d2 : f32
      memref.store %r, %c3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce
    }

    // ---- forward elimination: k-recurrence on ee/gg, runs only if kbm2 > 1 ----
    %has_fwd = arith.cmpi sgt, %kbm2, %c1 : index
    scf.if %has_fwd {
      // k == 0 initialisation (the "k < 2" guard of the fused loop)
      %dz0 = memref.load %dz[%c0] : memref<?xf32>
      scf.parallel (%j, %i) = (%c0, %c0) to (%jm, %im) step (%c1, %c1) {
        %a0 = memref.load %a3[%c0, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %am1 = arith.subf %a0, %f1 : f32
        %e = arith.divf %a0, %am1 : f32
        memref.store %e, %ee3[%c0, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %wu = memref.load %wus2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
        %dh = memref.load %dh2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
        %u0 = memref.load %uf3[%c0, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %ndz0 = arith.negf %dz0 : f32
        %den = arith.mulf %ndz0, %dh : f32
        %num = arith.mulf %ndti2, %wu : f32
        %q = arith.divf %num, %den : f32
        %p = arith.subf %q, %u0 : f32
        %g = arith.divf %p, %am1 : f32
        memref.store %g, %gg3[%c0, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce
      }
      scf.for %k = %c1 to %kbm2 step %c1 {
        %km1 = arith.subi %k, %c1 : index
        scf.parallel (%j, %i) = (%c0, %c0) to (%jm, %im) step (%c1, %c1) {
          %av = memref.load %a3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %cv = memref.load %c3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %ep = memref.load %ee3[%km1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %gp = memref.load %gg3[%km1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %uv = memref.load %uf3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %omep = arith.subf %f1, %ep : f32
          %t0 = arith.mulf %cv, %omep : f32
          %t1 = arith.addf %av, %t0 : f32
          %t2 = arith.subf %t1, %f1 : f32
          %g1 = arith.divf %f1, %t2 : f32
          %e = arith.mulf %av, %g1 : f32
          memref.store %e, %ee3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %cg = arith.mulf %cv, %gp : f32
          %cgu = arith.subf %cg, %uv : f32
          %g2 = arith.mulf %cgu, %g1 : f32
          memref.store %g2, %gg3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          scf.reduce
        }
      }
    }

    // ---- back substitution, runs only if kb >= 3 (i.e. kbm2 >= 1) ----
    %has_bwd = arith.cmpi sge, %kbm2, %c1 : index
    scf.if %has_bwd {
      // k == kbm2 (bottom) peel, with tps
      %dzb = memref.load %dz[%kbm2] : memref<?xf32>
      scf.parallel (%j, %i) = (%c1, %c1) to (%jmm1, %imm1) step (%c1, %c1) {
        %im1 = arith.subi %i, %c1 : index
        %jp1 = arith.addi %j, %c1 : index
        %cb0 = memref.load %cbc2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
        %cb1 = memref.load %cbc2[%j, %im1] : memref<?x?xf32, strided<[?, 1]>>
        %ubv = memref.load %ub3[%kbm2, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %v0 = memref.load %vb3[%kbm2, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %v1 = memref.load %vb3[%kbm2, %jp1, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %v2 = memref.load %vb3[%kbm2, %j, %im1] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %v3 = memref.load %vb3[%kbm2, %jp1, %im1] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %vs0 = arith.addf %v0, %v1 : f32
        %vs1 = arith.addf %vs0, %v2 : f32
        %vs2 = arith.addf %vs1, %v3 : f32
        %vav = arith.mulf %f0_25, %vs2 : f32
        %vsq = arith.mulf %vav, %vav : f32
        %usq = arith.mulf %ubv, %ubv : f32
        %sum = arith.addf %usq, %vsq : f32
        %sq = math.sqrt %sum : f32
        %cs = arith.addf %cb0, %cb1 : f32
        %cavg = arith.mulf %f0_5, %cs : f32
        %tp = arith.mulf %cavg, %sq : f32
        memref.store %tp, %tps2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>

        %kbm2m1 = arith.subi %kbm2, %c1 : index
        %cv = memref.load %c3[%kbm2, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %gp = memref.load %gg3[%kbm2m1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %ep = memref.load %ee3[%kbm2m1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %uv = memref.load %uf3[%kbm2, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %dh = memref.load %dh2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
        %dm = memref.load %dum2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
        %cg = arith.mulf %cv, %gp : f32
        %num = arith.subf %cg, %uv : f32
        %ndzb = arith.negf %dzb : f32
        %den0 = arith.mulf %ndzb, %dh : f32
        %tq = arith.mulf %tp, %dti2 : f32
        %q = arith.divf %tq, %den0 : f32
        %q1 = arith.subf %q, %f1 : f32
        %em1 = arith.subf %ep, %f1 : f32
        %emc = arith.mulf %em1, %cv : f32
        %den = arith.subf %q1, %emc : f32
        %u = arith.divf %num, %den : f32
        %un = arith.mulf %u, %dm : f32
        memref.store %un, %uf3[%kbm2, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce
      }
      // k = kbm2-1 .. 0 : sequential (uf[k] depends on uf[k+1])
      scf.for %it = %c0 to %kbm2 step %c1 {
        %t = arith.subi %kbm2, %it : index
        %k = arith.subi %t, %c1 : index
        %kp1 = arith.addi %k, %c1 : index
        scf.parallel (%j, %i) = (%c1, %c1) to (%jmm1, %imm1) step (%c1, %c1) {
          %e = memref.load %ee3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %g = memref.load %gg3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %un = memref.load %uf3[%kp1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %dm = memref.load %dum2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
          %p = arith.mulf %e, %un : f32
          %s = arith.addf %p, %g : f32
          %r = arith.mulf %s, %dm : f32
          memref.store %r, %uf3[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          scf.reduce
        }
      }
    }

    // ---- wubot ----
    scf.parallel (%j, %i) = (%c1, %c1) to (%jmm1, %imm1) step (%c1, %c1) {
      %tp = memref.load %tps2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
      %u = memref.load %uf3[%kbm2, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %ntp = arith.negf %tp : f32
      %r = arith.mulf %ntp, %u : f32
      memref.store %r, %wub2[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce
    }
    return
  }
}

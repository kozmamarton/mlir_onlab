module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_uaf_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "drx2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 4.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @grav : memref<1xf32>
    %5 = memref.get_global @alpha : memref<1xf32>
    %6 = affine.load %3[0] : memref<1xi32>
    %7 = affine.load %4[0] : memref<1xf32>
    %8 = affine.load %5[0] : memref<1xf32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.mulf %7, %cst_2 : f32
    %11 = arith.mulf %8, %cst_0 : f32
    %12 = arith.subf %cst_1, %11 : f32
    affine.for %arg17 = 1 to %2 {
      affine.for %arg18 = 1 to %9 {
        %20 = affine.load %arg1[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %21 = affine.load %arg2[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %22 = arith.addf %20, %21 : f32
        %23 = affine.load %arg3[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %24 = arith.mulf %23, %cst_2 : f32
        %25 = affine.load %arg4[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %26 = affine.load %arg5[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %27 = arith.mulf %25, %26 : f32
        %28 = affine.load %arg6[%arg18 + (%arg17 + 1) * symbol(%9)] : memref<?xf32>
        %29 = affine.load %arg6[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %30 = arith.addf %28, %29 : f32
        %31 = arith.mulf %27, %30 : f32
        %32 = affine.load %arg4[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %33 = affine.load %arg5[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %34 = arith.mulf %32, %33 : f32
        %35 = affine.load %arg6[%arg18 + (%arg17 + 1) * symbol(%9) - 1] : memref<?xf32>
        %36 = affine.load %arg6[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %37 = arith.addf %35, %36 : f32
        %38 = arith.mulf %34, %37 : f32
        %39 = arith.addf %31, %38 : f32
        %40 = arith.mulf %24, %39 : f32
        %41 = arith.subf %22, %40 : f32
        %42 = affine.load %arg7[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %43 = affine.load %arg7[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %44 = arith.addf %42, %43 : f32
        %45 = arith.mulf %10, %44 : f32
        %46 = arith.addf %26, %33 : f32
        %47 = arith.mulf %45, %46 : f32
        %48 = affine.load %arg8[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %49 = affine.load %arg8[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %50 = arith.subf %48, %49 : f32
        %51 = arith.mulf %12, %50 : f32
        %52 = affine.load %arg9[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %53 = affine.load %arg9[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %54 = arith.subf %52, %53 : f32
        %55 = affine.load %arg10[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %56 = arith.addf %54, %55 : f32
        %57 = affine.load %arg10[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %58 = arith.subf %56, %57 : f32
        %59 = arith.mulf %8, %58 : f32
        %60 = arith.addf %51, %59 : f32
        %61 = affine.load %arg11[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %62 = arith.addf %60, %61 : f32
        %63 = affine.load %arg11[%arg18 + %arg17 * symbol(%9) - 1] : memref<?xf32>
        %64 = arith.subf %62, %63 : f32
        %65 = arith.mulf %47, %64 : f32
        %66 = arith.addf %41, %65 : f32
        %67 = affine.load %arg12[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %68 = arith.addf %66, %67 : f32
        %69 = affine.load %arg13[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %70 = affine.load %arg14[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
        %71 = arith.subf %69, %70 : f32
        %72 = arith.mulf %23, %71 : f32
        %73 = arith.addf %68, %72 : f32
        affine.store %73, %arg0[%arg18 + %arg17 * symbol(%9)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %13 = affine.load %0[0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = memref.get_global @dte : memref<1xf32>
    %16 = affine.load %3[0] : memref<1xi32>
    %17 = affine.load %15[0] : memref<1xf32>
    %18 = arith.index_cast %16 : i32 to index
    %19 = arith.mulf %17, %cst : f32
    affine.for %arg17 = 1 to %14 {
      affine.for %arg18 = 1 to %18 {
        %20 = affine.load %arg15[%arg18 + %arg17 * symbol(%18)] : memref<?xf32>
        %21 = affine.load %arg9[%arg18 + %arg17 * symbol(%18)] : memref<?xf32>
        %22 = arith.addf %20, %21 : f32
        %23 = affine.load %arg15[%arg18 + %arg17 * symbol(%18) - 1] : memref<?xf32>
        %24 = arith.addf %22, %23 : f32
        %25 = affine.load %arg9[%arg18 + %arg17 * symbol(%18) - 1] : memref<?xf32>
        %26 = arith.addf %24, %25 : f32
        %27 = affine.load %arg3[%arg18 + %arg17 * symbol(%18)] : memref<?xf32>
        %28 = arith.mulf %26, %27 : f32
        %29 = affine.load %arg16[%arg18 + %arg17 * symbol(%18)] : memref<?xf32>
        %30 = arith.mulf %28, %29 : f32
        %31 = affine.load %arg0[%arg18 + %arg17 * symbol(%18)] : memref<?xf32>
        %32 = arith.mulf %19, %31 : f32
        %33 = arith.subf %30, %32 : f32
        %34 = affine.load %arg10[%arg18 + %arg17 * symbol(%18)] : memref<?xf32>
        %35 = arith.addf %20, %34 : f32
        %36 = arith.addf %35, %23 : f32
        %37 = affine.load %arg10[%arg18 + %arg17 * symbol(%18) - 1] : memref<?xf32>
        %38 = arith.addf %36, %37 : f32
        %39 = arith.mulf %38, %27 : f32
        %40 = arith.divf %33, %39 : f32
        affine.store %40, %arg0[%arg18 + %arg17 * symbol(%18)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    return
  }
}

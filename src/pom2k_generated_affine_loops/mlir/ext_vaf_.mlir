module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_vaf_(%arg0: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dry2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 4.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @alpha : memref<1xf32>
    %7 = affine.load %3[0] : memref<1xi32>
    %8 = affine.load %4[0] : memref<1xi32>
    %9 = affine.load %5[0] : memref<1xf32>
    %10 = affine.load %6[0] : memref<1xf32>
    %11 = arith.index_cast %7 : i32 to index
    %12 = arith.index_cast %8 : i32 to index
    %13 = arith.mulf %9, %cst_2 : f32
    %14 = arith.mulf %10, %cst_0 : f32
    %15 = arith.subf %cst_1, %14 : f32
    affine.for %arg17 = 1 to %2 {
      affine.for %arg18 = 1 to %11 {
        %25 = affine.load %arg1[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %26 = affine.load %arg2[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %27 = arith.addf %25, %26 : f32
        %28 = affine.load %arg3[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %29 = arith.mulf %28, %cst_2 : f32
        %30 = affine.load %arg4[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %31 = affine.load %arg5[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %32 = arith.mulf %30, %31 : f32
        %33 = affine.load %arg6[%arg18 + %arg17 * symbol(%12) + 1] : memref<?xf32>
        %34 = affine.load %arg6[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %35 = arith.addf %33, %34 : f32
        %36 = arith.mulf %32, %35 : f32
        %37 = affine.load %arg4[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %38 = affine.load %arg5[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %39 = arith.mulf %37, %38 : f32
        %40 = affine.load %arg6[%arg18 + (%arg17 - 1) * symbol(%12) + 1] : memref<?xf32>
        %41 = affine.load %arg6[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %42 = arith.addf %40, %41 : f32
        %43 = arith.mulf %39, %42 : f32
        %44 = arith.addf %36, %43 : f32
        %45 = arith.mulf %29, %44 : f32
        %46 = arith.addf %27, %45 : f32
        %47 = affine.load %arg7[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %48 = affine.load %arg7[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %49 = arith.addf %47, %48 : f32
        %50 = arith.mulf %13, %49 : f32
        %51 = arith.addf %31, %38 : f32
        %52 = arith.mulf %50, %51 : f32
        %53 = affine.load %arg8[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %54 = affine.load %arg8[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %55 = arith.subf %53, %54 : f32
        %56 = arith.mulf %15, %55 : f32
        %57 = affine.load %arg9[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %58 = affine.load %arg9[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %59 = arith.subf %57, %58 : f32
        %60 = affine.load %arg10[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %61 = arith.addf %59, %60 : f32
        %62 = affine.load %arg10[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %63 = arith.subf %61, %62 : f32
        %64 = arith.mulf %10, %63 : f32
        %65 = arith.addf %56, %64 : f32
        %66 = affine.load %arg11[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %67 = arith.addf %65, %66 : f32
        %68 = affine.load %arg11[%arg18 + (%arg17 - 1) * symbol(%12)] : memref<?xf32>
        %69 = arith.subf %67, %68 : f32
        %70 = arith.mulf %52, %69 : f32
        %71 = arith.addf %46, %70 : f32
        %72 = affine.load %arg12[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %73 = arith.addf %71, %72 : f32
        %74 = affine.load %arg13[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %75 = affine.load %arg14[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
        %76 = arith.subf %74, %75 : f32
        %77 = arith.mulf %28, %76 : f32
        %78 = arith.addf %73, %77 : f32
        affine.store %78, %arg0[%arg18 + %arg17 * symbol(%12)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %16 = affine.load %0[0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @dte : memref<1xf32>
    %19 = affine.load %3[0] : memref<1xi32>
    %20 = affine.load %4[0] : memref<1xi32>
    %21 = affine.load %18[0] : memref<1xf32>
    %22 = arith.index_cast %19 : i32 to index
    %23 = arith.index_cast %20 : i32 to index
    %24 = arith.mulf %21, %cst : f32
    affine.for %arg17 = 1 to %17 {
      affine.for %arg18 = 1 to %22 {
        %25 = affine.load %arg15[%arg18 + %arg17 * symbol(%23)] : memref<?xf32>
        %26 = affine.load %arg9[%arg18 + %arg17 * symbol(%23)] : memref<?xf32>
        %27 = arith.addf %25, %26 : f32
        %28 = affine.load %arg15[%arg18 + (%arg17 - 1) * symbol(%23)] : memref<?xf32>
        %29 = arith.addf %27, %28 : f32
        %30 = affine.load %arg9[%arg18 + (%arg17 - 1) * symbol(%23)] : memref<?xf32>
        %31 = arith.addf %29, %30 : f32
        %32 = affine.load %arg16[%arg18 + %arg17 * symbol(%23)] : memref<?xf32>
        %33 = arith.mulf %31, %32 : f32
        %34 = affine.load %arg3[%arg18 + %arg17 * symbol(%23)] : memref<?xf32>
        %35 = arith.mulf %33, %34 : f32
        %36 = affine.load %arg0[%arg18 + %arg17 * symbol(%23)] : memref<?xf32>
        %37 = arith.mulf %24, %36 : f32
        %38 = arith.subf %35, %37 : f32
        %39 = affine.load %arg10[%arg18 + %arg17 * symbol(%23)] : memref<?xf32>
        %40 = arith.addf %25, %39 : f32
        %41 = arith.addf %40, %28 : f32
        %42 = affine.load %arg10[%arg18 + (%arg17 - 1) * symbol(%23)] : memref<?xf32>
        %43 = arith.addf %41, %42 : f32
        %44 = arith.mulf %43, %34 : f32
        %45 = arith.divf %38, %44 : f32
        affine.store %45, %arg0[%arg18 + %arg17 * symbol(%23)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}

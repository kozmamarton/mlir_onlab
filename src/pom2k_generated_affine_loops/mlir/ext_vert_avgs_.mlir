module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_vert_avgs_(%arg0: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "drx2d", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dry2d", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "aam2d", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advx", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "advy", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    affine.for %arg11 = 0 to %2 {
      affine.for %arg12 = 0 to %5 {
        affine.store %cst, %arg0[%arg12 + %arg11 * symbol(%5)] : memref<?xf32>
        affine.store %cst, %arg1[%arg12 + %arg11 * symbol(%5)] : memref<?xf32>
        affine.store %cst, %arg2[%arg12 + %arg11 * symbol(%5)] : memref<?xf32>
        affine.store %cst, %arg3[%arg12 + %arg11 * symbol(%5)] : memref<?xf32>
        affine.store %cst, %arg4[%arg12 + %arg11 * symbol(%5)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = affine.load %6[0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = affine.load %0[0] : memref<1xi32>
    %10 = affine.load %3[0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    affine.for %arg11 = 0 to %8 {
      %13 = affine.load %arg10[%arg11] : memref<?xf32>
      affine.for %arg12 = 0 to %11 {
        affine.for %arg13 = 0 to %12 {
          %14 = affine.load %arg5[%arg13 + %arg12 * symbol(%12) + (%arg11 * symbol(%12)) * symbol(%11)] : memref<?xf32>
          %15 = arith.mulf %14, %13 : f32
          %16 = affine.load %arg0[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %17 = arith.addf %16, %15 : f32
          affine.store %17, %arg0[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %18 = affine.load %arg6[%arg13 + %arg12 * symbol(%12) + (%arg11 * symbol(%12)) * symbol(%11)] : memref<?xf32>
          %19 = arith.mulf %18, %13 : f32
          %20 = affine.load %arg1[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %21 = arith.addf %20, %19 : f32
          affine.store %21, %arg1[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %22 = affine.load %arg7[%arg13 + %arg12 * symbol(%12) + (%arg11 * symbol(%12)) * symbol(%11)] : memref<?xf32>
          %23 = arith.mulf %22, %13 : f32
          %24 = affine.load %arg2[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %25 = arith.addf %24, %23 : f32
          affine.store %25, %arg2[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %26 = affine.load %arg8[%arg13 + %arg12 * symbol(%12) + (%arg11 * symbol(%12)) * symbol(%11)] : memref<?xf32>
          %27 = arith.mulf %26, %13 : f32
          %28 = affine.load %arg3[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %29 = arith.addf %28, %27 : f32
          affine.store %29, %arg3[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %30 = affine.load %arg9[%arg13 + %arg12 * symbol(%12) + (%arg11 * symbol(%12)) * symbol(%11)] : memref<?xf32>
          %31 = arith.mulf %30, %13 : f32
          %32 = affine.load %arg4[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
          %33 = arith.addf %32, %31 : f32
          affine.store %33, %arg4[%arg13 + %arg12 * symbol(%12)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

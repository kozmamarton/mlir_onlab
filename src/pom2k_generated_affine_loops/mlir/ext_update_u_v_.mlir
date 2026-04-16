module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_update_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    affine.for %arg9 = 0 to %2 {
      affine.for %arg10 = 0 to %5 {
        affine.store %cst_1, %arg0[%arg10 + %arg9 * symbol(%5)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = affine.load %6[0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = affine.load %0[0] : memref<1xi32>
    %10 = affine.load %3[0] : memref<1xi32>
    %11 = affine.load %arg8[0] : memref<?xf32>
    %12 = arith.index_cast %9 : i32 to index
    %13 = arith.index_cast %10 : i32 to index
    %14 = arith.mulf %11, %cst_0 : f32
    affine.for %arg9 = 0 to %8 {
      affine.for %arg10 = 0 to %12 {
        affine.for %arg11 = 0 to %13 {
          %22 = affine.load %arg5[%arg11 + %arg10 * symbol(%13) + (%arg9 * symbol(%13)) * symbol(%12)] : memref<?xf32>
          %23 = affine.load %arg6[%arg11 + %arg10 * symbol(%13) + (%arg9 * symbol(%13)) * symbol(%12)] : memref<?xf32>
          %24 = arith.addf %22, %23 : f32
          %25 = affine.load %arg4[%arg11 + %arg10 * symbol(%13) + (%arg9 * symbol(%13)) * symbol(%12)] : memref<?xf32>
          %26 = arith.mulf %25, %cst : f32
          %27 = arith.subf %24, %26 : f32
          %28 = affine.load %arg0[%arg11 + %arg10 * symbol(%13)] : memref<?xf32>
          %29 = arith.subf %27, %28 : f32
          %30 = arith.mulf %14, %29 : f32
          %31 = arith.addf %25, %30 : f32
          affine.store %31, %arg4[%arg11 + %arg10 * symbol(%13) + (%arg9 * symbol(%13)) * symbol(%12)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %15 = memref.get_global @kb : memref<1xi32>
    %16 = affine.load %15[0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = affine.load %0[0] : memref<1xi32>
    %19 = affine.load %3[0] : memref<1xi32>
    %20 = arith.index_cast %18 : i32 to index
    %21 = arith.index_cast %19 : i32 to index
    affine.for %arg9 = 0 to %17 {
      affine.for %arg10 = 0 to %20 {
        affine.for %arg11 = 0 to %21 {
          %22 = affine.load %arg1[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          affine.store %22, %arg3[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %23 = affine.load %arg2[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          affine.store %23, %arg1[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %24 = affine.load %arg4[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          affine.store %24, %arg6[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %25 = affine.load %arg5[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          affine.store %25, %arg4[%arg11 + %arg10 * symbol(%21) + (%arg9 * symbol(%21)) * symbol(%20)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    return
  }
}

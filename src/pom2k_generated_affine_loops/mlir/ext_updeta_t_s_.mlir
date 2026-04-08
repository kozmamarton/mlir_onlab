module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_updeta_t_s_(%arg0: memref<?xf32> {polygeist.name = "t", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "tb", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "s", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "sb", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = affine.load %3[0] : memref<1xi32>
    %6 = affine.load %4[0] : memref<1xi32>
    %7 = affine.load %arg6[0] : memref<?xf32>
    %8 = arith.index_cast %5 : i32 to index
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.mulf %7, %cst_0 : f32
    affine.for %arg7 = 0 to %2 {
      affine.for %arg8 = 0 to %8 {
        affine.for %arg9 = 0 to %9 {
          %11 = affine.load %arg0[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %12 = affine.load %arg4[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %13 = affine.load %arg1[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %14 = arith.addf %12, %13 : f32
          %15 = arith.mulf %11, %cst : f32
          %16 = arith.subf %14, %15 : f32
          %17 = arith.mulf %10, %16 : f32
          %18 = arith.addf %11, %17 : f32
          affine.store %18, %arg0[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %19 = affine.load %arg2[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %20 = affine.load %arg5[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %21 = affine.load %arg3[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %22 = arith.addf %20, %21 : f32
          %23 = arith.mulf %19, %cst : f32
          %24 = arith.subf %22, %23 : f32
          %25 = arith.mulf %10, %24 : f32
          %26 = arith.addf %19, %25 : f32
          affine.store %26, %arg2[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %27 = affine.load %arg0[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          affine.store %27, %arg1[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %28 = affine.load %arg4[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          affine.store %28, %arg0[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %29 = affine.load %arg2[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          affine.store %29, %arg3[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          %30 = affine.load %arg5[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
          affine.store %30, %arg2[%arg9 + %arg8 * symbol(%9) + (%arg7 * symbol(%9)) * symbol(%8)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    return
  }
}

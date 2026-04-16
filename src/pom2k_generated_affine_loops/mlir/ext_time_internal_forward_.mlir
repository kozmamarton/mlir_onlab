module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_time_internal_forward_(%arg0: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "ispi", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "isp2i", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = affine.load %arg2[0] : memref<?xf32>
    %6 = arith.index_cast %4 : i32 to index
    affine.for %arg9 = 0 to %2 {
      affine.for %arg10 = 0 to %6 {
        %17 = affine.load %arg1[%arg10 + %arg9 * symbol(%6)] : memref<?xf32>
        %18 = arith.mulf %17, %5 : f32
        affine.store %18, %arg0[%arg10 + %arg9 * symbol(%6)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %7 = affine.load %0[0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = affine.load %3[0] : memref<1xi32>
    %10 = affine.load %arg6[0] : memref<?xf32>
    %11 = arith.index_cast %9 : i32 to index
    affine.for %arg9 = 0 to %8 {
      affine.for %arg10 = 1 to %11 {
        %17 = affine.load %arg4[%arg10 + %arg9 * symbol(%11)] : memref<?xf32>
        %18 = affine.load %arg5[%arg10 + %arg9 * symbol(%11)] : memref<?xf32>
        %19 = affine.load %arg5[%arg10 + %arg9 * symbol(%11) - 1] : memref<?xf32>
        %20 = arith.addf %18, %19 : f32
        %21 = arith.mulf %17, %20 : f32
        %22 = arith.mulf %21, %10 : f32
        affine.store %22, %arg3[%arg10 + %arg9 * symbol(%11)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %12 = affine.load %0[0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = affine.load %3[0] : memref<1xi32>
    %15 = affine.load %arg6[0] : memref<?xf32>
    %16 = arith.index_cast %14 : i32 to index
    affine.for %arg9 = 1 to %13 {
      affine.for %arg10 = 1 to %16 {
        %17 = affine.load %arg8[%arg10 + %arg9 * symbol(%16)] : memref<?xf32>
        %18 = affine.load %arg5[%arg10 + %arg9 * symbol(%16)] : memref<?xf32>
        %19 = affine.load %arg5[%arg10 + (%arg9 - 1) * symbol(%16)] : memref<?xf32>
        %20 = arith.addf %18, %19 : f32
        %21 = arith.mulf %17, %20 : f32
        %22 = arith.mulf %21, %15 : f32
        affine.store %22, %arg7[%arg10 + %arg9 * symbol(%16)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}

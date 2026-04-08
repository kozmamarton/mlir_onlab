module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_final_internal_update_(%arg0: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "et", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "utb", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "vtb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "vfluxb", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    affine.for %arg13 = 0 to %2 {
      affine.for %arg14 = 0 to %5 {
        %6 = affine.load %arg1[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        affine.store %6, %arg0[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %7 = affine.load %arg3[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        affine.store %7, %arg2[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %8 = affine.load %arg4[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        affine.store %8, %arg3[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %9 = affine.load %arg6[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %10 = affine.load %arg3[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %11 = arith.addf %9, %10 : f32
        affine.store %11, %arg5[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %12 = affine.load %arg8[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        affine.store %12, %arg7[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %13 = affine.load %arg10[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        affine.store %13, %arg9[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        %14 = affine.load %arg12[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
        affine.store %14, %arg11[%arg14 + %arg13 * symbol(%5)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}

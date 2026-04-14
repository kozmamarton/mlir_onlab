module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_flux_update_(%arg0: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    affine.for %arg7 = 1 to %2 {
      affine.for %arg8 = 1 to %5 {
        %6 = affine.load %arg2[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
        %7 = affine.load %arg2[%arg8 + %arg7 * symbol(%5) - 1] : memref<?xf32>
        %8 = arith.addf %6, %7 : f32
        %9 = arith.mulf %8, %cst : f32
        %10 = affine.load %arg3[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
        %11 = affine.load %arg3[%arg8 + %arg7 * symbol(%5) - 1] : memref<?xf32>
        %12 = arith.addf %10, %11 : f32
        %13 = arith.mulf %9, %12 : f32
        %14 = affine.load %arg5[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
        %15 = arith.mulf %13, %14 : f32
        affine.store %15, %arg0[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
        %16 = affine.load %arg2[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
        %17 = affine.load %arg2[%arg8 + (%arg7 - 1) * symbol(%5)] : memref<?xf32>
        %18 = arith.addf %16, %17 : f32
        %19 = arith.mulf %18, %cst : f32
        %20 = affine.load %arg4[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
        %21 = affine.load %arg4[%arg8 + (%arg7 - 1) * symbol(%5)] : memref<?xf32>
        %22 = arith.addf %20, %21 : f32
        %23 = arith.mulf %19, %22 : f32
        %24 = affine.load %arg6[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
        %25 = arith.mulf %23, %24 : f32
        affine.store %25, %arg1[%arg8 + %arg7 * symbol(%5)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}

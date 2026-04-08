module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @jmm2 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @imm2 : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_bcond_1_(%arg0: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @imm1 : memref<1xi32>
    %5 = memref.get_global @imm2 : memref<1xi32>
    %6 = affine.load %3[0] : memref<1xi32>
    %7 = affine.load %4[0] : memref<1xi32>
    %8 = affine.load %5[0] : memref<1xi32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    %11 = arith.index_cast %8 : i32 to index
    affine.for %arg2 = 0 to %2 {
      %26 = affine.load %arg0[%arg2 * symbol(%9) + 1] : memref<?xf32>
      affine.store %26, %arg0[%arg2 * symbol(%9)] : memref<?xf32>
      %27 = affine.load %arg0[%arg2 * symbol(%9) + symbol(%11)] : memref<?xf32>
      affine.store %27, %arg0[%arg2 * symbol(%9) + symbol(%10)] : memref<?xf32>
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %12 = affine.load %3[0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.get_global @jmm1 : memref<1xi32>
    %15 = memref.get_global @jmm2 : memref<1xi32>
    %16 = affine.load %14[0] : memref<1xi32>
    %17 = affine.load %15[0] : memref<1xi32>
    %18 = arith.index_cast %16 : i32 to index
    %19 = arith.muli %18, %13 : index
    %20 = arith.index_cast %17 : i32 to index
    %21 = arith.muli %20, %13 : index
    affine.for %arg2 = 0 to %13 {
      %26 = affine.load %arg0[%arg2 + symbol(%13)] : memref<?xf32>
      affine.store %26, %arg0[%arg2] : memref<?xf32>
      %27 = affine.load %arg0[%arg2 + symbol(%21)] : memref<?xf32>
      affine.store %27, %arg0[%arg2 + symbol(%19)] : memref<?xf32>
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    %22 = affine.load %0[0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = affine.load %3[0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    affine.for %arg2 = 0 to %23 {
      affine.for %arg3 = 0 to %25 {
        %26 = affine.load %arg0[%arg3 + %arg2 * symbol(%25)] : memref<?xf32>
        %27 = affine.load %arg1[%arg3 + %arg2 * symbol(%25)] : memref<?xf32>
        %28 = arith.mulf %26, %27 : f32
        affine.store %28, %arg0[%arg3 + %arg2 * symbol(%25)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}

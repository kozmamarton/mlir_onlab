module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = ""} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_add_ad_2d_(%arg0: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    affine.for %arg4 = 0 to %2 {
      affine.for %arg5 = 0 to %5 {
        %6 = affine.load %arg2[%arg5 + %arg4 * symbol(%5)] : memref<?xf32>
        %7 = affine.load %arg0[%arg5 + %arg4 * symbol(%5)] : memref<?xf32>
        %8 = arith.subf %7, %6 : f32
        affine.store %8, %arg0[%arg5 + %arg4 * symbol(%5)] : memref<?xf32>
        %9 = affine.load %arg3[%arg5 + %arg4 * symbol(%5)] : memref<?xf32>
        %10 = affine.load %arg1[%arg5 + %arg4 * symbol(%5)] : memref<?xf32>
        %11 = arith.subf %10, %9 : f32
        affine.store %11, %arg1[%arg5 + %arg4 * symbol(%5)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}


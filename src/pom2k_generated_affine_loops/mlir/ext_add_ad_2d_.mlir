module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "x86_64-unknown-linux-gnu", "polygeist.target-cpu" = "x86-64", "polygeist.target-features" = ""} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_add_ad_2d_(%arg0: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %arg0_2d = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1], offset: 0>>
    %arg1_2d = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1], offset: 0>>
    %arg2_2d = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1], offset: 0>>
    %arg3_2d = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1], offset: 0>>
    affine.for %arg4 = 0 to %2 {
      affine.for %arg5 = 0 to %5 {
        %6 = affine.load %arg2_2d[%arg4, %arg5] : memref<?x?xf32, strided<[?, 1], offset: 0>>
        %7 = affine.load %arg0_2d[%arg4, %arg5] : memref<?x?xf32, strided<[?, 1], offset: 0>>
        %8 = arith.subf %7, %6 : f32
        affine.store %8, %arg0_2d[%arg4, %arg5] : memref<?x?xf32, strided<[?, 1], offset: 0>>
        %9 = affine.load %arg3_2d[%arg4, %arg5] : memref<?x?xf32, strided<[?, 1], offset: 0>>
        %10 = affine.load %arg1_2d[%arg4, %arg5] : memref<?x?xf32, strided<[?, 1], offset: 0>>
        %11 = arith.subf %10, %9 : f32
        affine.store %11, %arg1_2d[%arg4, %arg5] : memref<?x?xf32, strided<[?, 1], offset: 0>>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}

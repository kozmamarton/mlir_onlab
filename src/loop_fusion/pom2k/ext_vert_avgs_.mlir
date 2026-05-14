module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
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
        %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %cst, %reinterpret_cast[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %cst, %reinterpret_cast_0[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %cst, %reinterpret_cast_1[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %cst, %reinterpret_cast_2[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %cst, %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
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
          %14 = arith.muli %12, %11 : index
          %reinterpret_cast = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%8, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %15 = affine.load %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %16 = arith.mulf %15, %13 : f32
          %reinterpret_cast_0 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %17 = affine.load %reinterpret_cast_0[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %18 = arith.addf %17, %16 : f32
          affine.store %18, %reinterpret_cast_0[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %reinterpret_cast_1 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%8, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %19 = affine.load %reinterpret_cast_1[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %20 = arith.mulf %19, %13 : f32
          %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %21 = affine.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %22 = arith.addf %21, %20 : f32
          affine.store %22, %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %reinterpret_cast_3 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%8, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %23 = affine.load %reinterpret_cast_3[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %24 = arith.mulf %23, %13 : f32
          %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %25 = affine.load %reinterpret_cast_4[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %26 = arith.addf %25, %24 : f32
          affine.store %26, %reinterpret_cast_4[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %reinterpret_cast_5 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%8, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %27 = affine.load %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %28 = arith.mulf %27, %13 : f32
          %reinterpret_cast_6 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %29 = affine.load %reinterpret_cast_6[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %30 = arith.addf %29, %28 : f32
          affine.store %30, %reinterpret_cast_6[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %reinterpret_cast_7 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%8, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %31 = affine.load %reinterpret_cast_7[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %32 = arith.mulf %31, %13 : f32
          %reinterpret_cast_8 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %33 = affine.load %reinterpret_cast_8[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
          %34 = arith.addf %33, %32 : f32
          affine.store %34, %reinterpret_cast_8[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}


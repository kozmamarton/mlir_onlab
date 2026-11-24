module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_update_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      memref.store %cst_1, %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %arg8[%c0] : memref<?xf32>
    %10 = arith.mulf %9, %cst_0 : f32
    %11 = memref.get_global @kb : memref<1xi32>
    %12 = memref.load %11[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = arith.muli %5, %2 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c0, %c0) to (%8, %2, %5) step (%c1, %c1, %c1) {
      %15 = memref.load %reinterpret_cast_2[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %16 = memref.load %reinterpret_cast_3[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %17 = arith.addf %15, %16 : f32
      %18 = memref.load %reinterpret_cast_4[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %19 = arith.mulf %18, %cst : f32
      %20 = arith.subf %17, %19 : f32
      %21 = memref.load %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %22 = arith.subf %20, %21 : f32
      %23 = arith.mulf %10, %22 : f32
      %24 = arith.addf %18, %23 : f32
      memref.store %24, %reinterpret_cast_4[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%13, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%13, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%13, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%13, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%13, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%13, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c0, %c0) to (%13, %2, %5) step (%c1, %c1, %c1) {
      %15 = memref.load %reinterpret_cast_5[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %15, %reinterpret_cast_6[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %16 = memref.load %reinterpret_cast_7[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %16, %reinterpret_cast_5[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %17 = memref.load %reinterpret_cast_8[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %17, %reinterpret_cast_9[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %18 = memref.load %reinterpret_cast_10[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %18, %reinterpret_cast_8[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


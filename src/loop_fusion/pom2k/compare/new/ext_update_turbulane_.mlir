module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_update_turbulane_(%arg0: memref<?xf32> {polygeist.name = "q2", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q2b", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "q2l", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "q2lb", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = memref.load %arg6[%c0] : memref<?xf32>
    %8 = arith.index_cast %5 : i32 to index
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.mulf %7, %cst_0 : f32
    %11 = arith.muli %9, %8 : index
    %reinterpret_cast = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %8, %9], strides: [%11, %9, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %8, %9], strides: [%11, %9, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %8, %9], strides: [%11, %9, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %8, %9], strides: [%11, %9, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %8, %9], strides: [%11, %9, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %8, %9], strides: [%11, %9, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg7, %arg8, %arg9) = (%c0, %c0, %c0) to (%2, %8, %9) step (%c1, %c1, %c1) {
      %12 = memref.load %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %13 = memref.load %reinterpret_cast_1[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %14 = arith.addf %12, %13 : f32
      %15 = memref.load %reinterpret_cast_2[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %16 = arith.mulf %15, %cst : f32
      %17 = arith.subf %14, %16 : f32
      %18 = arith.mulf %10, %17 : f32
      %19 = arith.addf %15, %18 : f32
      memref.store %19, %reinterpret_cast_2[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %20 = memref.load %reinterpret_cast_3[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %21 = memref.load %reinterpret_cast_4[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %22 = arith.addf %20, %21 : f32
      %23 = memref.load %reinterpret_cast_5[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %24 = arith.mulf %23, %cst : f32
      %25 = arith.subf %22, %24 : f32
      %26 = arith.mulf %10, %25 : f32
      %27 = arith.addf %23, %26 : f32
      memref.store %27, %reinterpret_cast_5[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %28 = memref.load %reinterpret_cast_2[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %28, %reinterpret_cast_1[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = memref.load %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %29, %reinterpret_cast_2[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = memref.load %reinterpret_cast_5[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %30, %reinterpret_cast_4[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %31 = memref.load %reinterpret_cast_3[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %31, %reinterpret_cast_5[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


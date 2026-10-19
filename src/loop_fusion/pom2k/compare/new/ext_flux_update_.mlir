module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_flux_update_(%arg0: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg7, %arg8) = (%c1, %c1) to (%2, %5) step (%c1, %c1) {
      %6 = memref.load %reinterpret_cast[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %7 = arith.muli %arg7, %5 overflow<nsw> : index
      %8 = arith.addi %arg8, %7 : index
      %9 = arith.addi %8, %c-1 : index
      %10 = memref.load %arg2[%9] : memref<?xf32>
      %11 = arith.addf %6, %10 : f32
      %12 = arith.mulf %11, %cst : f32
      %13 = memref.load %reinterpret_cast_0[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %14 = memref.load %arg3[%9] : memref<?xf32>
      %15 = arith.addf %13, %14 : f32
      %16 = arith.mulf %12, %15 : f32
      %17 = memref.load %reinterpret_cast_1[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %18 = arith.mulf %16, %17 : f32
      memref.store %18, %reinterpret_cast_2[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %19 = memref.load %reinterpret_cast[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %20 = arith.addi %arg7, %c-1 : index
      %21 = memref.load %reinterpret_cast[%20, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %22 = arith.addf %19, %21 : f32
      %23 = arith.mulf %22, %cst : f32
      %24 = memref.load %reinterpret_cast_3[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %25 = memref.load %reinterpret_cast_3[%20, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %26 = arith.addf %24, %25 : f32
      %27 = arith.mulf %23, %26 : f32
      %28 = memref.load %reinterpret_cast_4[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      %29 = arith.mulf %27, %28 : f32
      memref.store %29, %reinterpret_cast_5[%arg7, %arg8] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_time_internal_forward_(%arg0: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "ispi", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "isp2i", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = memref.load %arg2[%c0] : memref<?xf32>
    %6 = arith.index_cast %4 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %7 = memref.load %arg6[%c0] : memref<?xf32>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %6) step (%c1, %c1) {
      %13 = memref.load %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      %14 = arith.mulf %13, %5 : f32
      memref.store %14, %reinterpret_cast_0[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      %15 = arith.addi %arg10, %c-1 : index
      %16 = arith.cmpi sge, %15, %c0 : index
      scf.if %16 {
        %17 = memref.load %reinterpret_cast_1[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
        %18 = memref.load %reinterpret_cast_2[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
        %19 = arith.muli %arg9, %6 overflow<nsw> : index
        %20 = arith.addi %arg10, %19 : index
        %21 = arith.addi %20, %c-1 : index
        %22 = memref.load %arg5[%21] : memref<?xf32>
        %23 = arith.addf %18, %22 : f32
        %24 = arith.mulf %17, %23 : f32
        %25 = arith.mulf %24, %7 : f32
        memref.store %25, %reinterpret_cast_3[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    %8 = memref.load %0[%c0] : memref<1xi32>
    %9 = arith.index_cast %8 : i32 to index
    %10 = memref.load %3[%c0] : memref<1xi32>
    %11 = memref.load %arg6[%c0] : memref<?xf32>
    %12 = arith.index_cast %10 : i32 to index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%9, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%9, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%9, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10) = (%c1, %c1) to (%9, %12) step (%c1, %c1) {
      %13 = memref.load %reinterpret_cast_4[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      %14 = memref.load %reinterpret_cast_5[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      %15 = arith.addi %arg9, %c-1 : index
      %16 = memref.load %reinterpret_cast_5[%15, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      %17 = arith.addf %14, %16 : f32
      %18 = arith.mulf %13, %17 : f32
      %19 = arith.mulf %18, %11 : f32
      memref.store %19, %reinterpret_cast_6[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


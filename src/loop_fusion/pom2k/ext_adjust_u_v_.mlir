module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global constant @kbm1 : memref<1xi32>
  memref.global constant @im : memref<1xi32>
  memref.global constant @jm : memref<1xi32>
  func.func @ext_adjust_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "utb", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vtb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = arith.muli %2, %5 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      memref.store %cst, %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      scf.for %arg11 = %c0 to %8 step %c1 {
        %10 = memref.load %arg3[%arg11] : memref<?xf32>
        %11 = memref.load %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
        %12 = memref.load %reinterpret_cast_0[%arg11, %arg9, %arg10] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %13 = arith.mulf %12, %10 : f32
        %14 = arith.addf %11, %13 : f32
        memref.store %14, %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c0, %c1) to (%8, %2, %5) step (%c1, %c1, %c1) {
      %10 = memref.load %reinterpret_cast_0[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %11 = memref.load %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %12 = arith.subf %10, %11 : f32
      %13 = memref.load %reinterpret_cast_2[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %14 = memref.load %reinterpret_cast_3[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %15 = arith.addf %13, %14 : f32
      %16 = memref.load %reinterpret_cast_6[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %17 = arith.addi %arg11, %c-1 : index
      %18 = memref.load %reinterpret_cast_6[%arg10, %17] : memref<?x?xf32, strided<[?, 1]>>
      %19 = arith.addf %16, %18 : f32
      %20 = arith.divf %15, %19 : f32
      %21 = arith.addf %12, %20 : f32
      memref.store %21, %reinterpret_cast_0[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      memref.store %cst, %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    scf.for %arg9 = %c0 to %8 step %c1 {
      %10 = memref.load %arg3[%arg9] : memref<?xf32>
      scf.parallel (%arg10, %arg11) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
        %11 = memref.load %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %12 = memref.load %reinterpret_cast_1[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %13 = arith.mulf %12, %10 : f32
        %14 = arith.addf %11, %13 : f32
        memref.store %14, %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      }
    }
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c1, %c0) to (%8, %2, %5) step (%c1, %c1, %c1) {
      %10 = memref.load %reinterpret_cast_1[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %11 = memref.load %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %12 = arith.subf %10, %11 : f32
      %13 = memref.load %reinterpret_cast_4[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %14 = memref.load %reinterpret_cast_5[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %15 = arith.addf %13, %14 : f32
      %16 = memref.load %reinterpret_cast_6[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %17 = arith.addi %arg10, %c-1 : index
      %18 = memref.load %reinterpret_cast_6[%17, %arg11] : memref<?x?xf32, strided<[?, 1]>>
      %19 = arith.addf %16, %18 : f32
      %20 = arith.divf %15, %19 : f32
      %21 = arith.addf %12, %20 : f32
      memref.store %21, %reinterpret_cast_1[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


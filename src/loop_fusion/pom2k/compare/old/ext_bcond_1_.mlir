module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @jmm2 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @imm2 : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_bcond_1_(%arg0: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @imm1 : memref<1xi32>
    %5 = memref.get_global @imm2 : memref<1xi32>
    %6 = memref.load %3[%c0] : memref<1xi32>
    %7 = memref.load %4[%c0] : memref<1xi32>
    %8 = memref.load %5[%c0] : memref<1xi32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    %11 = arith.index_cast %8 : i32 to index
    scf.for %arg2 = %c0 to %2 step %c1 {
      %26 = arith.muli %arg2, %9 overflow<nsw> : index
      %27 = arith.addi %26, %c1 : index
      %28 = memref.load %arg0[%27] : memref<?xf32>
      memref.store %28, %arg0[%26] : memref<?xf32>
      %29 = arith.addi %26, %11 : index
      %30 = memref.load %arg0[%29] : memref<?xf32>
      %31 = arith.addi %26, %10 : index
      memref.store %30, %arg0[%31] : memref<?xf32>
    }
    %12 = memref.load %3[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.get_global @jmm1 : memref<1xi32>
    %15 = memref.get_global @jmm2 : memref<1xi32>
    %16 = memref.load %14[%c0] : memref<1xi32>
    %17 = memref.load %15[%c0] : memref<1xi32>
    %18 = arith.index_cast %16 : i32 to index
    %19 = arith.muli %18, %13 : index
    %20 = arith.index_cast %17 : i32 to index
    %21 = arith.muli %20, %13 : index
    scf.for %arg2 = %c0 to %13 step %c1 {
      %26 = arith.addi %arg2, %13 : index
      %27 = memref.load %arg0[%26] : memref<?xf32>
      memref.store %27, %arg0[%arg2] : memref<?xf32>
      %28 = arith.addi %arg2, %21 : index
      %29 = memref.load %arg0[%28] : memref<?xf32>
      %30 = arith.addi %arg2, %19 : index
      memref.store %29, %arg0[%30] : memref<?xf32>
    }
    %22 = memref.load %0[%c0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = memref.load %3[%c0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg2, %arg3) = (%c0, %c0) to (%23, %25) step (%c1, %c1) {
      %26 = memref.load %reinterpret_cast[%arg2, %arg3] : memref<?x?xf32, strided<[?, 1]>>
      %27 = memref.load %reinterpret_cast_0[%arg2, %arg3] : memref<?x?xf32, strided<[?, 1]>>
      %28 = arith.mulf %26, %27 : f32
      memref.store %28, %reinterpret_cast[%arg2, %arg3] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


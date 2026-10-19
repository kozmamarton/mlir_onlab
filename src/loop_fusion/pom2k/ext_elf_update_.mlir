module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte2 : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_elf_update_(%arg0: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @dte2 : memref<1xf32>
    %6 = memref.load %3[%c0] : memref<1xi32>
    %7 = memref.load %4[%c0] : memref<1xi32>
    %8 = memref.load %5[%c0] : memref<1xf32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg6, %arg7) = (%c1, %c1) to (%2, %9) step (%c1, %c1) {
      %11 = memref.load %reinterpret_cast[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %12 = arith.muli %arg6, %10 overflow<nsw> : index
      %13 = arith.addi %arg7, %12 : index
      %14 = arith.addi %13, %c1 : index
      %15 = memref.load %arg2[%14] : memref<?xf32>
      %16 = memref.load %reinterpret_cast_0[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %17 = arith.subf %15, %16 : f32
      %18 = arith.addi %arg6, %c1 : index
      %19 = memref.load %reinterpret_cast_1[%18, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %20 = arith.addf %17, %19 : f32
      %21 = memref.load %reinterpret_cast_1[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %22 = arith.subf %20, %21 : f32
      %23 = arith.negf %22 : f32
      %24 = memref.load %reinterpret_cast_2[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %25 = arith.divf %23, %24 : f32
      %26 = memref.load %reinterpret_cast_3[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %27 = arith.subf %25, %26 : f32
      %28 = arith.mulf %8, %27 : f32
      %29 = arith.addf %11, %28 : f32
      memref.store %29, %reinterpret_cast_4[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


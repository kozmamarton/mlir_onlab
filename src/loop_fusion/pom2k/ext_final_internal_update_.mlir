#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_final_internal_update_(%arg0: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "et", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "utb", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "vtb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "vfluxb", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg13, %arg14) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %6 = affine.min #map(%arg13)[%2]
      %7 = affine.min #map1(%arg14)[%5]
      scf.parallel (%arg15, %arg16) = (%c0, %c0) to (%6, %7) step (%c1, %c1) {
        %8 = arith.addi %arg15, %arg13 : index
        %9 = arith.addi %arg16, %arg14 : index
        %10 = memref.load %reinterpret_cast[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        memref.store %10, %reinterpret_cast_0[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        %11 = memref.load %reinterpret_cast_1[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        memref.store %11, %reinterpret_cast_2[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        %12 = memref.load %reinterpret_cast_3[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        memref.store %12, %reinterpret_cast_1[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        %13 = memref.load %reinterpret_cast_4[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        %14 = arith.addf %13, %12 : f32
        memref.store %14, %reinterpret_cast_5[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        %15 = memref.load %reinterpret_cast_6[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        memref.store %15, %reinterpret_cast_7[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        %16 = memref.load %reinterpret_cast_8[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        memref.store %16, %reinterpret_cast_9[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        %17 = memref.load %reinterpret_cast_10[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        memref.store %17, %reinterpret_cast_11[%8, %9] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


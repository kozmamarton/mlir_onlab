#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_time_internal_forward_(%arg0: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "ispi", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "isp2i", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c-1 = arith.constant -1 : index
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
    %reinterpret_cast_1 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %10 = affine.min #map(%arg9)[%2]
      %11 = affine.min #map1(%arg10)[%5]
      scf.parallel (%arg11, %arg12) = (%c0, %c0) to (%10, %11) step (%c1, %c1) {
        %12 = arith.addi %arg11, %arg9 : index
        %13 = arith.addi %arg12, %arg10 : index
        %14 = memref.load %arg2[%c0] : memref<?xf32>
        %15 = memref.load %arg6[%c0] : memref<?xf32>
        %16 = memref.load %reinterpret_cast[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        %17 = arith.mulf %16, %14 : f32
        memref.store %17, %reinterpret_cast_0[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        %18 = arith.addi %13, %c-1 : index
        %19 = arith.cmpi sge, %18, %c0 : index
        scf.if %19 {
          %20 = memref.load %reinterpret_cast_1[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
          %21 = memref.load %reinterpret_cast_2[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
          %22 = arith.muli %12, %5 overflow<nsw> : index
          %23 = arith.addi %13, %22 : index
          %24 = arith.addi %23, %c-1 : index
          %25 = memref.load %arg5[%24] : memref<?xf32>
          %26 = arith.addf %21, %25 : f32
          %27 = arith.mulf %20, %26 : f32
          %28 = arith.mulf %27, %15 : f32
          memref.store %28, %reinterpret_cast_3[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %6 = memref.load %0[%c0] : memref<1xi32>
    %7 = arith.index_cast %6 : i32 to index
    %8 = memref.load %3[%c0] : memref<1xi32>
    %9 = arith.index_cast %8 : i32 to index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%7, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%7, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10) = (%c1, %c1) to (%7, %9) step (%c8, %c32) {
      %10 = affine.min #map(%arg9)[%7]
      %11 = affine.min #map1(%arg10)[%9]
      scf.parallel (%arg11, %arg12) = (%c0, %c0) to (%10, %11) step (%c1, %c1) {
        %12 = arith.addi %arg11, %arg9 : index
        %13 = arith.addi %arg12, %arg10 : index
        %14 = memref.load %arg6[%c0] : memref<?xf32>
        %15 = memref.load %reinterpret_cast_4[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        %16 = memref.load %reinterpret_cast_5[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        %17 = arith.addi %12, %c-1 : index
        %18 = memref.load %reinterpret_cast_5[%17, %13] : memref<?x?xf32, strided<[?, 1]>>
        %19 = arith.addf %16, %18 : f32
        %20 = arith.mulf %15, %19 : f32
        %21 = arith.mulf %20, %14 : f32
        memref.store %21, %reinterpret_cast_6[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


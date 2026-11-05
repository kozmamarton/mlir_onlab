#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map3 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_update_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
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
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %17 = affine.min #map(%arg9)[%2]
      %18 = affine.min #map1(%arg10)[%5]
      scf.parallel (%arg11, %arg12) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg11, %arg9 : index
        %20 = arith.addi %arg12, %arg10 : index
        memref.store %cst_1, %reinterpret_cast[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %0[%c0] : memref<1xi32>
    %10 = memref.load %3[%c0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    %13 = memref.get_global @kb : memref<1xi32>
    %14 = memref.load %13[%c0] : memref<1xi32>
    %15 = arith.index_cast %14 : i32 to index
    %16 = arith.muli %12, %11 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%8, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%8, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%8, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c0, %c0) to (%8, %11, %12) step (%c2, %c4, %c32) {
      %17 = affine.min #map2(%arg9)[%8]
      %18 = affine.min #map3(%arg10)[%11]
      %19 = affine.min #map1(%arg11)[%12]
      scf.parallel (%arg12, %arg13, %arg14) = (%c0, %c0, %c0) to (%17, %18, %19) step (%c1, %c1, %c1) {
        %20 = arith.addi %arg12, %arg9 : index
        %21 = arith.addi %arg13, %arg10 : index
        %22 = arith.addi %arg14, %arg11 : index
        %23 = memref.load %arg8[%c0] : memref<?xf32>
        %24 = arith.mulf %23, %cst_0 : f32
        %25 = memref.load %reinterpret_cast_2[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %26 = memref.load %reinterpret_cast_3[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %27 = arith.addf %25, %26 : f32
        %28 = memref.load %reinterpret_cast_4[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %29 = arith.mulf %28, %cst : f32
        %30 = arith.subf %27, %29 : f32
        %31 = memref.load %reinterpret_cast_5[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %32 = arith.subf %30, %31 : f32
        %33 = arith.mulf %24, %32 : f32
        %34 = arith.addf %28, %33 : f32
        memref.store %34, %reinterpret_cast_4[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_6 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%15, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%15, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%15, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%15, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%15, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%15, %11, %12], strides: [%16, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c0, %c0) to (%15, %11, %12) step (%c2, %c4, %c32) {
      %17 = affine.min #map2(%arg9)[%15]
      %18 = affine.min #map3(%arg10)[%11]
      %19 = affine.min #map1(%arg11)[%12]
      scf.parallel (%arg12, %arg13, %arg14) = (%c0, %c0, %c0) to (%17, %18, %19) step (%c1, %c1, %c1) {
        %20 = arith.addi %arg12, %arg9 : index
        %21 = arith.addi %arg13, %arg10 : index
        %22 = arith.addi %arg14, %arg11 : index
        %23 = memref.load %reinterpret_cast_6[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %23, %reinterpret_cast_7[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %24 = memref.load %reinterpret_cast_8[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %24, %reinterpret_cast_6[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %25 = memref.load %reinterpret_cast_9[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %25, %reinterpret_cast_10[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %26 = memref.load %reinterpret_cast_11[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %26, %reinterpret_cast_9[%20, %21, %22] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


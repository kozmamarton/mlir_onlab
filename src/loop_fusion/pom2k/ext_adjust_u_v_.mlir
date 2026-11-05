#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map3 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global constant @kbm1 : memref<1xi32>
  memref.global constant @im : memref<1xi32>
  memref.global constant @jm : memref<1xi32>
  func.func @ext_adjust_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "utb", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vtb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
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
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %10 = affine.min #map(%arg9)[%2]
      %11 = affine.min #map1(%arg10)[%5]
      scf.parallel (%arg11, %arg12) = (%c0, %c0) to (%10, %11) step (%c1, %c1) {
        %12 = arith.addi %arg11, %arg9 : index
        %13 = arith.addi %arg12, %arg10 : index
        memref.store %cst, %reinterpret_cast[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        scf.for %arg13 = %c0 to %8 step %c1 {
          %14 = memref.load %arg3[%arg13] : memref<?xf32>
          %15 = memref.load %reinterpret_cast[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
          %16 = memref.load %reinterpret_cast_0[%arg13, %12, %13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %17 = arith.mulf %16, %14 : f32
          %18 = arith.addf %15, %17 : f32
          memref.store %18, %reinterpret_cast[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c0, %c1) to (%8, %2, %5) step (%c2, %c4, %c32) {
      %10 = affine.min #map2(%arg9)[%8]
      %11 = affine.min #map3(%arg10)[%2]
      %12 = affine.min #map1(%arg11)[%5]
      scf.parallel (%arg12, %arg13, %arg14) = (%c0, %c0, %c0) to (%10, %11, %12) step (%c1, %c1, %c1) {
        %13 = arith.addi %arg12, %arg9 : index
        %14 = arith.addi %arg13, %arg10 : index
        %15 = arith.addi %arg14, %arg11 : index
        %16 = memref.load %reinterpret_cast_0[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %17 = memref.load %reinterpret_cast[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %18 = arith.subf %16, %17 : f32
        %19 = memref.load %reinterpret_cast_2[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %20 = memref.load %reinterpret_cast_3[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %21 = arith.addf %19, %20 : f32
        %22 = memref.load %reinterpret_cast_6[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %23 = arith.addi %15, %c-1 : index
        %24 = memref.load %reinterpret_cast_6[%14, %23] : memref<?x?xf32, strided<[?, 1]>>
        %25 = arith.addf %22, %24 : f32
        %26 = arith.divf %21, %25 : f32
        %27 = arith.addf %18, %26 : f32
        memref.store %27, %reinterpret_cast_0[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %10 = affine.min #map(%arg9)[%2]
      %11 = affine.min #map1(%arg10)[%5]
      scf.parallel (%arg11, %arg12) = (%c0, %c0) to (%10, %11) step (%c1, %c1) {
        %12 = arith.addi %arg11, %arg9 : index
        %13 = arith.addi %arg12, %arg10 : index
        memref.store %cst, %reinterpret_cast[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %10 = affine.min #map(%arg9)[%2]
      %11 = affine.min #map1(%arg10)[%5]
      scf.parallel (%arg11, %arg12) = (%c0, %c0) to (%10, %11) step (%c1, %c1) {
        %12 = arith.addi %arg11, %arg9 : index
        %13 = arith.addi %arg12, %arg10 : index
        scf.for %arg13 = %c0 to %8 step %c1 {
          %14 = memref.load %arg3[%arg13] : memref<?xf32>
          %15 = memref.load %reinterpret_cast[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
          %16 = memref.load %reinterpret_cast_1[%arg13, %12, %13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %17 = arith.mulf %16, %14 : f32
          %18 = arith.addf %15, %17 : f32
          memref.store %18, %reinterpret_cast[%12, %13] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    scf.parallel (%arg9, %arg10, %arg11) = (%c0, %c1, %c0) to (%8, %2, %5) step (%c2, %c4, %c32) {
      %10 = affine.min #map2(%arg9)[%8]
      %11 = affine.min #map3(%arg10)[%2]
      %12 = affine.min #map1(%arg11)[%5]
      scf.parallel (%arg12, %arg13, %arg14) = (%c0, %c0, %c0) to (%10, %11, %12) step (%c1, %c1, %c1) {
        %13 = arith.addi %arg12, %arg9 : index
        %14 = arith.addi %arg13, %arg10 : index
        %15 = arith.addi %arg14, %arg11 : index
        %16 = memref.load %reinterpret_cast_1[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %17 = memref.load %reinterpret_cast[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %18 = arith.subf %16, %17 : f32
        %19 = memref.load %reinterpret_cast_4[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %20 = memref.load %reinterpret_cast_5[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %21 = arith.addf %19, %20 : f32
        %22 = memref.load %reinterpret_cast_6[%14, %15] : memref<?x?xf32, strided<[?, 1]>>
        %23 = arith.addi %14, %c-1 : index
        %24 = memref.load %reinterpret_cast_6[%23, %15] : memref<?x?xf32, strided<[?, 1]>>
        %25 = arith.addf %22, %24 : f32
        %26 = arith.divf %21, %25 : f32
        %27 = arith.addf %18, %26 : f32
        memref.store %27, %reinterpret_cast_1[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


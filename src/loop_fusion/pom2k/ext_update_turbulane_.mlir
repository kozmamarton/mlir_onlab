#map = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_update_turbulane_(%arg0: memref<?xf32> {polygeist.name = "q2", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q2b", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "q2l", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "q2lb", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
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
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg7, %arg8, %arg9) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c2, %c4, %c32) {
      %10 = affine.min #map(%arg7)[%2]
      %11 = affine.min #map1(%arg8)[%7]
      %12 = affine.min #map2(%arg9)[%8]
      scf.parallel (%arg10, %arg11, %arg12) = (%c0, %c0, %c0) to (%10, %11, %12) step (%c1, %c1, %c1) {
        %13 = arith.addi %arg10, %arg7 : index
        %14 = arith.addi %arg11, %arg8 : index
        %15 = arith.addi %arg12, %arg9 : index
        %16 = memref.load %arg6[%c0] : memref<?xf32>
        %17 = arith.mulf %16, %cst_0 : f32
        %18 = memref.load %reinterpret_cast[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %19 = memref.load %reinterpret_cast_1[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %20 = arith.addf %18, %19 : f32
        %21 = memref.load %reinterpret_cast_2[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %22 = arith.mulf %21, %cst : f32
        %23 = arith.subf %20, %22 : f32
        %24 = arith.mulf %17, %23 : f32
        %25 = arith.addf %21, %24 : f32
        memref.store %25, %reinterpret_cast_2[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %26 = memref.load %reinterpret_cast_3[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %27 = memref.load %reinterpret_cast_4[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %28 = arith.addf %26, %27 : f32
        %29 = memref.load %reinterpret_cast_5[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %30 = arith.mulf %29, %cst : f32
        %31 = arith.subf %28, %30 : f32
        %32 = arith.mulf %17, %31 : f32
        %33 = arith.addf %29, %32 : f32
        memref.store %33, %reinterpret_cast_5[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %34 = memref.load %reinterpret_cast_2[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %34, %reinterpret_cast_1[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %35 = memref.load %reinterpret_cast[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %35, %reinterpret_cast_2[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %36 = memref.load %reinterpret_cast_5[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %36, %reinterpret_cast_4[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %37 = memref.load %reinterpret_cast_3[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        memref.store %37, %reinterpret_cast_5[%13, %14, %15] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


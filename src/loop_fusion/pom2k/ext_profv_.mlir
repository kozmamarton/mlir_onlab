#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map3 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_profv_(%arg0: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "km", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "dhloc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c0 = arith.constant 0 : index
    %c-1 = arith.constant -1 : index
    %c-3_i32 = arith.constant -3 : i32
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %c1_i32 = arith.constant 1 : i32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %c1 = arith.constant 1 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = memref.get_global @kb : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %85 = affine.min #map(%arg18)[%2]
      %86 = affine.min #map1(%arg19)[%5]
      scf.parallel (%arg20, %arg21) = (%c0, %c0) to (%85, %86) step (%c1, %c1) {
        %87 = arith.addi %arg20, %arg18 : index
        %88 = arith.addi %arg21, %arg19 : index
        memref.store %cst_1, %reinterpret_cast[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %89 = arith.addi %87, %c-1 : index
        %90 = arith.cmpi sge, %89, %c0 : index
        %91 = arith.addi %88, %c-1 : index
        %92 = arith.cmpi sge, %91, %c0 : index
        %93 = arith.andi %90, %92 : i1
        scf.if %93 {
          %94 = memref.load %reinterpret_cast_2[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
          %95 = memref.load %reinterpret_cast_3[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
          %96 = arith.addf %94, %95 : f32
          %97 = memref.load %reinterpret_cast_2[%89, %88] : memref<?x?xf32, strided<[?, 1]>>
          %98 = arith.addf %96, %97 : f32
          %99 = memref.load %reinterpret_cast_3[%89, %88] : memref<?x?xf32, strided<[?, 1]>>
          %100 = arith.addf %98, %99 : f32
          %101 = arith.mulf %100, %cst_0 : f32
          memref.store %101, %reinterpret_cast[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %9 = arith.muli %5, %2 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%8, %2, %5) step (%c2, %c4, %c32) {
      %85 = affine.min #map2(%arg18)[%8]
      %86 = affine.min #map3(%arg19)[%2]
      %87 = affine.min #map1(%arg20)[%5]
      scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%85, %86, %87) step (%c1, %c1, %c1) {
        %88 = arith.addi %arg21, %arg18 : index
        %89 = arith.addi %arg22, %arg19 : index
        %90 = arith.addi %arg23, %arg20 : index
        %91 = memref.load %reinterpret_cast_4[%88, %89, %90] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %92 = arith.addi %89, %c-1 : index
        %93 = memref.load %reinterpret_cast_4[%88, %92, %90] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %94 = arith.addf %91, %93 : f32
        %95 = arith.mulf %94, %cst_0 : f32
        memref.store %95, %reinterpret_cast_5[%88, %89, %90] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %10 = memref.get_global @kbm2 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @dti2 : memref<1xf32>
    %14 = memref.get_global @umol : memref<1xf32>
    %15 = memref.load %0[%c0] : memref<1xi32>
    %16 = memref.load %3[%c0] : memref<1xi32>
    %17 = memref.load %13[%c0] : memref<1xf32>
    %18 = memref.load %14[%c0] : memref<1xf32>
    %19 = arith.index_cast %15 : i32 to index
    %20 = arith.index_cast %16 : i32 to index
    %21 = arith.negf %17 : f32
    %22 = arith.muli %20, %19 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%12, %19, %20], strides: [%22, %20, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%12, %19, %20], strides: [%22, %20, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%19, %20], strides: [%20, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%12, %19, %20) step (%c2, %c4, %c32) {
      %85 = affine.min #map2(%arg18)[%12]
      %86 = affine.min #map3(%arg19)[%19]
      %87 = affine.min #map1(%arg20)[%20]
      scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%85, %86, %87) step (%c1, %c1, %c1) {
        %88 = arith.addi %arg21, %arg18 : index
        %89 = arith.addi %arg22, %arg19 : index
        %90 = arith.addi %arg23, %arg20 : index
        %91 = memref.load %arg5[%88] : memref<?xf32>
        %92 = memref.load %arg6[%88] : memref<?xf32>
        %93 = arith.mulf %91, %92 : f32
        %94 = arith.addi %88, %c1 : index
        %95 = memref.load %reinterpret_cast_6[%94, %89, %90] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %96 = arith.addf %95, %18 : f32
        %97 = arith.mulf %21, %96 : f32
        %98 = memref.load %reinterpret_cast_8[%89, %90] : memref<?x?xf32, strided<[?, 1]>>
        %99 = arith.mulf %93, %98 : f32
        %100 = arith.mulf %99, %98 : f32
        %101 = arith.divf %97, %100 : f32
        memref.store %101, %reinterpret_cast_7[%88, %89, %90] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %23 = memref.get_global @kbm1 : memref<1xi32>
    %24 = memref.load %23[%c0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %26 = memref.load %0[%c0] : memref<1xi32>
    %27 = memref.load %3[%c0] : memref<1xi32>
    %28 = memref.load %13[%c0] : memref<1xf32>
    %29 = memref.load %14[%c0] : memref<1xf32>
    %30 = arith.index_cast %26 : i32 to index
    %31 = arith.index_cast %27 : i32 to index
    %32 = arith.negf %28 : f32
    %33 = arith.muli %31, %30 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%25, %30, %31], strides: [%33, %31, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%30, %31], strides: [%31, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c0, %c0) to (%25, %30, %31) step (%c2, %c4, %c32) {
      %85 = affine.min #map2(%arg18)[%25]
      %86 = affine.min #map3(%arg19)[%30]
      %87 = affine.min #map1(%arg20)[%31]
      scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%85, %86, %87) step (%c1, %c1, %c1) {
        %88 = arith.addi %arg21, %arg18 : index
        %89 = arith.addi %arg22, %arg19 : index
        %90 = arith.addi %arg23, %arg20 : index
        %91 = memref.load %arg5[%88] : memref<?xf32>
        %92 = arith.addi %88, %c-1 : index
        %93 = memref.load %arg6[%92] : memref<?xf32>
        %94 = arith.mulf %91, %93 : f32
        %95 = memref.load %reinterpret_cast_9[%88, %89, %90] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %96 = arith.addf %95, %29 : f32
        %97 = arith.mulf %32, %96 : f32
        %98 = memref.load %reinterpret_cast_10[%89, %90] : memref<?x?xf32, strided<[?, 1]>>
        %99 = arith.mulf %94, %98 : f32
        %100 = arith.mulf %99, %98 : f32
        %101 = arith.divf %97, %100 : f32
        memref.store %101, %reinterpret_cast_9[%88, %89, %90] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %34 = memref.load %0[%c0] : memref<1xi32>
    %35 = arith.index_cast %34 : i32 to index
    %36 = memref.load %3[%c0] : memref<1xi32>
    %37 = memref.load %13[%c0] : memref<1xf32>
    %38 = arith.index_cast %36 : i32 to index
    %39 = arith.negf %37 : f32
    %40 = memref.load %10[%c0] : memref<1xi32>
    %41 = arith.index_cast %40 : i32 to index
    %reinterpret_cast_11 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%35, %38], strides: [%38, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%35, %38], strides: [%38, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%35, %38], strides: [%38, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%35, %38], strides: [%38, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%35, %38], strides: [%38, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%35, %38], strides: [%38, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%35, %38) step (%c8, %c32) {
      %85 = affine.min #map(%arg18)[%35]
      %86 = affine.min #map1(%arg19)[%38]
      scf.parallel (%arg20, %arg21) = (%c0, %c0) to (%85, %86) step (%c1, %c1) {
        %87 = arith.addi %arg20, %arg18 : index
        %88 = arith.addi %arg21, %arg19 : index
        %89 = memref.load %arg5[%c0] : memref<?xf32>
        %90 = arith.negf %89 : f32
        %91 = memref.load %reinterpret_cast_11[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %92 = arith.subf %91, %cst_1 : f32
        %93 = arith.divf %91, %92 : f32
        memref.store %93, %reinterpret_cast_12[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %94 = memref.load %reinterpret_cast_13[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %95 = arith.mulf %39, %94 : f32
        %96 = memref.load %reinterpret_cast_14[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %97 = arith.mulf %90, %96 : f32
        %98 = arith.divf %95, %97 : f32
        %99 = memref.load %reinterpret_cast_15[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %100 = arith.subf %98, %99 : f32
        %101 = memref.load %reinterpret_cast_11[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %102 = arith.subf %101, %cst_1 : f32
        %103 = arith.divf %100, %102 : f32
        memref.store %103, %reinterpret_cast_16[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %42 = arith.muli %38, %35 : index
    %reinterpret_cast_17 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%41, %35, %38], strides: [%42, %38, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%41, %35, %38], strides: [%42, %38, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%41, %35, %38], strides: [%42, %38, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%41, %35, %38], strides: [%42, %38, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%41, %35, %38], strides: [%42, %38, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%35, %38) step (%c8, %c32) {
      %85 = affine.min #map(%arg18)[%35]
      %86 = affine.min #map1(%arg19)[%38]
      scf.parallel (%arg20, %arg21) = (%c0, %c0) to (%85, %86) step (%c1, %c1) {
        %87 = arith.addi %arg20, %arg18 : index
        %88 = arith.addi %arg21, %arg19 : index
        scf.for %arg22 = %c1 to %41 step %c1 {
          %89 = memref.load %reinterpret_cast_17[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %90 = memref.load %reinterpret_cast_18[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %91 = arith.addi %arg22, %c-1 : index
          %92 = memref.load %reinterpret_cast_19[%91, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %93 = arith.subf %cst_1, %92 : f32
          %94 = arith.mulf %90, %93 : f32
          %95 = arith.addf %89, %94 : f32
          %96 = arith.subf %95, %cst_1 : f32
          %97 = arith.divf %cst_1, %96 : f32
          memref.store %97, %reinterpret_cast_20[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %98 = memref.load %reinterpret_cast_17[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %99 = arith.mulf %98, %97 : f32
          memref.store %99, %reinterpret_cast_19[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %100 = memref.load %reinterpret_cast_18[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %101 = memref.load %reinterpret_cast_20[%91, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %102 = arith.mulf %100, %101 : f32
          %103 = memref.load %reinterpret_cast_21[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %104 = arith.subf %102, %103 : f32
          %105 = memref.load %reinterpret_cast_20[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %106 = arith.mulf %104, %105 : f32
          memref.store %106, %reinterpret_cast_20[%arg22, %87, %88] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %43 = memref.get_global @jmm1 : memref<1xi32>
    %44 = memref.load %43[%c0] : memref<1xi32>
    %45 = arith.index_cast %44 : i32 to index
    %46 = memref.get_global @imm1 : memref<1xi32>
    %47 = memref.load %46[%c0] : memref<1xi32>
    %48 = memref.load %3[%c0] : memref<1xi32>
    %49 = memref.load %10[%c0] : memref<1xi32>
    %50 = memref.load %0[%c0] : memref<1xi32>
    %51 = memref.load %13[%c0] : memref<1xf32>
    %52 = arith.index_cast %47 : i32 to index
    %53 = arith.index_cast %48 : i32 to index
    %54 = arith.index_cast %49 : i32 to index
    %55 = arith.muli %54, %53 : index
    %56 = arith.index_cast %50 : i32 to index
    %57 = arith.muli %55, %56 : index
    %58 = arith.addi %54, %c-1 : index
    %59 = arith.muli %58, %53 : index
    %60 = arith.muli %59, %56 : index
    %reinterpret_cast_22 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%45, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%45, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%45, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%45, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%45, %52) step (%c8, %c32) {
      %85 = affine.min #map(%arg18)[%45]
      %86 = affine.min #map1(%arg19)[%52]
      scf.parallel (%arg20, %arg21) = (%c0, %c0) to (%85, %86) step (%c1, %c1) {
        %87 = arith.addi %arg20, %arg18 : index
        %88 = arith.addi %arg21, %arg19 : index
        %89 = memref.load %arg5[%54] : memref<?xf32>
        %90 = arith.negf %89 : f32
        %91 = memref.load %reinterpret_cast_22[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %92 = arith.addi %87, %c-1 : index
        %93 = memref.load %reinterpret_cast_22[%92, %88] : memref<?x?xf32, strided<[?, 1]>>
        %94 = arith.addf %91, %93 : f32
        %95 = arith.mulf %94, %cst_0 : f32
        %96 = arith.muli %87, %53 overflow<nsw> : index
        %97 = arith.addi %88, %96 : index
        %98 = arith.addi %97, %57 : index
        %99 = memref.load %arg13[%98] : memref<?xf32>
        %100 = arith.addi %98, %c1 : index
        %101 = memref.load %arg13[%100] : memref<?xf32>
        %102 = arith.addf %99, %101 : f32
        %103 = arith.addi %88, %57 : index
        %104 = arith.muli %92, %53 overflow<nsw> : index
        %105 = arith.addi %103, %104 : index
        %106 = memref.load %arg13[%105] : memref<?xf32>
        %107 = arith.addf %102, %106 : f32
        %108 = arith.addi %105, %c1 : index
        %109 = memref.load %arg13[%108] : memref<?xf32>
        %110 = arith.addf %107, %109 : f32
        %111 = arith.mulf %110, %cst : f32
        %112 = arith.mulf %111, %111 : f32
        %113 = memref.load %arg14[%98] : memref<?xf32>
        %114 = arith.mulf %113, %113 : f32
        %115 = arith.addf %112, %114 : f32
        %116 = math.sqrt %115 : f32
        %117 = arith.mulf %95, %116 : f32
        memref.store %117, %reinterpret_cast_23[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %118 = memref.load %arg2[%98] : memref<?xf32>
        %119 = arith.addi %97, %60 : index
        %120 = memref.load %arg8[%119] : memref<?xf32>
        %121 = arith.mulf %118, %120 : f32
        %122 = memref.load %arg10[%98] : memref<?xf32>
        %123 = arith.subf %121, %122 : f32
        %124 = arith.mulf %117, %51 : f32
        %125 = memref.load %reinterpret_cast_24[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %126 = arith.mulf %90, %125 : f32
        %127 = arith.divf %124, %126 : f32
        %128 = arith.subf %127, %cst_1 : f32
        %129 = memref.load %arg7[%119] : memref<?xf32>
        %130 = arith.subf %129, %cst_1 : f32
        %131 = arith.mulf %130, %118 : f32
        %132 = arith.subf %128, %131 : f32
        %133 = arith.divf %123, %132 : f32
        memref.store %133, %arg10[%98] : memref<?xf32>
        %134 = memref.load %arg10[%98] : memref<?xf32>
        %135 = memref.load %reinterpret_cast_25[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %136 = arith.mulf %134, %135 : f32
        memref.store %136, %arg10[%98] : memref<?xf32>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %61 = memref.load %6[%c0] : memref<1xi32>
    %62 = arith.addi %61, %c-3_i32 : i32
    %63 = arith.index_cast %62 : i32 to index
    %64 = arith.addi %63, %c1 : index
    %65 = arith.maxsi %64, %c0 : index
    %66 = memref.load %43[%c0] : memref<1xi32>
    %67 = arith.index_cast %66 : i32 to index
    %68 = memref.load %46[%c0] : memref<1xi32>
    %69 = memref.load %3[%c0] : memref<1xi32>
    %70 = memref.load %0[%c0] : memref<1xi32>
    %71 = arith.index_cast %68 : i32 to index
    %72 = arith.index_cast %69 : i32 to index
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%67, %71) step (%c8, %c32) {
      %85 = affine.min #map(%arg18)[%67]
      %86 = affine.min #map1(%arg19)[%71]
      scf.parallel (%arg20, %arg21) = (%c0, %c0) to (%85, %86) step (%c1, %c1) {
        %87 = arith.addi %arg20, %arg18 : index
        %88 = arith.addi %arg21, %arg19 : index
        scf.for %arg22 = %c0 to %65 step %c1 {
          %89 = arith.subi %63, %arg22 : index
          %90 = arith.index_cast %89 : index to i32
          %91 = arith.muli %90, %69 : i32
          %92 = arith.muli %91, %70 : i32
          %93 = arith.addi %90, %c1_i32 : i32
          %94 = arith.muli %93, %69 : i32
          %95 = arith.muli %94, %70 : i32
          %96 = arith.index_cast %87 : index to i32
          %97 = arith.muli %96, %69 : i32
          %98 = arith.muli %87, %72 : index
          %99 = arith.index_cast %88 : index to i32
          %100 = arith.addi %99, %97 : i32
          %101 = arith.addi %100, %92 : i32
          %102 = arith.index_cast %101 : i32 to index
          %103 = memref.load %arg7[%102] : memref<?xf32>
          %104 = arith.addi %100, %95 : i32
          %105 = arith.index_cast %104 : i32 to index
          %106 = memref.load %arg10[%105] : memref<?xf32>
          %107 = arith.mulf %103, %106 : f32
          %108 = memref.load %arg8[%102] : memref<?xf32>
          %109 = arith.addf %107, %108 : f32
          %110 = arith.addi %88, %98 : index
          %111 = memref.load %arg15[%110] : memref<?xf32>
          %112 = arith.mulf %109, %111 : f32
          memref.store %112, %arg10[%102] : memref<?xf32>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %73 = memref.load %43[%c0] : memref<1xi32>
    %74 = arith.index_cast %73 : i32 to index
    %75 = memref.load %46[%c0] : memref<1xi32>
    %76 = memref.load %3[%c0] : memref<1xi32>
    %77 = memref.load %10[%c0] : memref<1xi32>
    %78 = memref.load %0[%c0] : memref<1xi32>
    %79 = arith.index_cast %75 : i32 to index
    %80 = arith.index_cast %76 : i32 to index
    %81 = arith.index_cast %77 : i32 to index
    %82 = arith.muli %81, %80 : index
    %83 = arith.index_cast %78 : i32 to index
    %84 = arith.muli %82, %83 : index
    %reinterpret_cast_26 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%74, %80], strides: [%80, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_27 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%74, %80], strides: [%80, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%74, %79) step (%c8, %c32) {
      %85 = affine.min #map(%arg18)[%74]
      %86 = affine.min #map1(%arg19)[%79]
      scf.parallel (%arg20, %arg21) = (%c0, %c0) to (%85, %86) step (%c1, %c1) {
        %87 = arith.addi %arg20, %arg18 : index
        %88 = arith.addi %arg21, %arg19 : index
        %89 = memref.load %reinterpret_cast_26[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        %90 = arith.negf %89 : f32
        %91 = arith.muli %87, %80 overflow<nsw> : index
        %92 = arith.addi %88, %91 : index
        %93 = arith.addi %92, %84 : index
        %94 = memref.load %arg10[%93] : memref<?xf32>
        %95 = arith.mulf %90, %94 : f32
        memref.store %95, %reinterpret_cast_27[%87, %88] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


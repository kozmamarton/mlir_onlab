#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map3 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map4 = affine_map<(d0, d1) -> (2, d0 - d1)>
#map5 = affine_map<(d0, d1) -> (4, d0 - d1)>
#map6 = affine_map<(d0, d1) -> (32, d0 - d1)>
#map7 = affine_map<(d0, d1) -> (8, d0 - d1)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @ntp : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_proft_(%arg0: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "wfsurf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fsurf", polygeist.type = "float *"}, %arg3: memref<?xi32> {polygeist.name = "nbc", polygeist.type = "int *"}, %arg4: memref<?xf32> {polygeist.name = "dh", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "kh", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "z", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "swrad", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "rad2", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %true = arith.constant true
    %c-1 = arith.constant -1 : index
    %c-3_i32 = arith.constant -3 : i32
    %c3_i32 = arith.constant 3 : i32
    %cst = arith.constant 7.900000e+00 : f32
    %cst_0 = arith.constant 1.400000e+01 : f32
    %cst_1 = arith.constant 1.700000e+01 : f32
    %cst_2 = arith.constant 2.000000e+01 : f32
    %cst_3 = arith.constant 2.300000e+01 : f32
    %cst_4 = arith.constant 1.400000e+00 : f32
    %cst_5 = arith.constant 1.500000e+00 : f32
    %cst_6 = arith.constant 1.000000e+00 : f32
    %cst_7 = arith.constant 6.000000e-01 : f32
    %cst_8 = arith.constant 3.500000e-01 : f32
    %cst_9 = arith.constant 7.800000e-01 : f32
    %cst_10 = arith.constant 0.76999998 : f32
    %cst_11 = arith.constant 6.700000e-01 : f32
    %cst_12 = arith.constant 6.200000e-01 : f32
    %cst_13 = arith.constant 5.800000e-01 : f32
    %c4_i32 = arith.constant 4 : i32
    %c2_i32 = arith.constant 2 : i32
    %cst_14 = arith.constant 0.000000e+00 : f32
    %c1_i32 = arith.constant 1 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %alloca = memref.alloca() {polygeist.name = "ad2"} : memref<5xf32>
    %alloca_15 = memref.alloca() {polygeist.name = "ad1"} : memref<5xf32>
    %alloca_16 = memref.alloca() {polygeist.name = "r"} : memref<5xf32>
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%2, %5) step (%c8, %c32) {
      %74 = affine.min #map(%arg17)[%2]
      %75 = affine.min #map1(%arg18)[%5]
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%74, %75) step (%c1, %c1) {
        %76 = arith.addi %arg19, %arg17 : index
        %77 = arith.addi %arg20, %arg18 : index
        %78 = memref.load %reinterpret_cast[%76, %77] : memref<?x?xf32, strided<[?, 1]>>
        %79 = memref.load %reinterpret_cast_17[%76, %77] : memref<?x?xf32, strided<[?, 1]>>
        %80 = arith.addf %78, %79 : f32
        memref.store %80, %reinterpret_cast_18[%76, %77] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %6 = memref.get_global @kbm2 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.get_global @dti2 : memref<1xf32>
    %10 = memref.get_global @umol : memref<1xf32>
    %11 = memref.load %0[%c0] : memref<1xi32>
    %12 = memref.load %3[%c0] : memref<1xi32>
    %13 = memref.load %9[%c0] : memref<1xf32>
    %14 = memref.load %10[%c0] : memref<1xf32>
    %15 = arith.index_cast %11 : i32 to index
    %16 = arith.index_cast %12 : i32 to index
    %17 = arith.negf %13 : f32
    %18 = arith.muli %16, %15 : index
    %reinterpret_cast_19 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%8, %15, %16], strides: [%18, %16, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%8, %15, %16], strides: [%18, %16, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%15, %16], strides: [%16, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18, %arg19) = (%c0, %c0, %c0) to (%8, %15, %16) step (%c2, %c4, %c32) {
      %74 = affine.min #map2(%arg17)[%8]
      %75 = affine.min #map3(%arg18)[%15]
      %76 = affine.min #map1(%arg19)[%16]
      scf.parallel (%arg20, %arg21, %arg22) = (%c0, %c0, %c0) to (%74, %75, %76) step (%c1, %c1, %c1) {
        %77 = arith.addi %arg20, %arg17 : index
        %78 = arith.addi %arg21, %arg18 : index
        %79 = arith.addi %arg22, %arg19 : index
        %80 = memref.load %arg14[%77] : memref<?xf32>
        %81 = memref.load %arg15[%77] : memref<?xf32>
        %82 = arith.mulf %80, %81 : f32
        %83 = arith.addi %77, %c1 : index
        %84 = memref.load %reinterpret_cast_19[%83, %78, %79] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %85 = arith.addf %84, %14 : f32
        %86 = arith.mulf %17, %85 : f32
        %87 = memref.load %reinterpret_cast_21[%78, %79] : memref<?x?xf32, strided<[?, 1]>>
        %88 = arith.mulf %82, %87 : f32
        %89 = arith.mulf %88, %87 : f32
        %90 = arith.divf %86, %89 : f32
        memref.store %90, %reinterpret_cast_20[%77, %78, %79] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %19 = memref.get_global @kbm1 : memref<1xi32>
    %20 = memref.load %19[%c0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.load %0[%c0] : memref<1xi32>
    %23 = memref.load %3[%c0] : memref<1xi32>
    %24 = memref.load %9[%c0] : memref<1xf32>
    %25 = memref.load %10[%c0] : memref<1xf32>
    %26 = arith.index_cast %22 : i32 to index
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.negf %24 : f32
    %29 = memref.get_global @kb : memref<1xi32>
    %30 = memref.load %29[%c0] : memref<1xi32>
    %31 = arith.index_cast %30 : i32 to index
    %32 = arith.muli %27, %26 : index
    %reinterpret_cast_22 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%21, %26, %27], strides: [%32, %27, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%21, %26, %27], strides: [%32, %27, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%26, %27], strides: [%27, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%31, %26, %27], strides: [%32, %27, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg17, %arg18, %arg19) = (%c0, %c0, %c0) to (%31, %26, %27) step (%c2, %c4, %c32) {
      %74 = affine.min #map2(%arg17)[%31]
      %75 = affine.min #map3(%arg18)[%26]
      %76 = affine.min #map1(%arg19)[%27]
      scf.parallel (%arg20, %arg21, %arg22) = (%c0, %c0, %c0) to (%74, %75, %76) step (%c1, %c1, %c1) {
        %77 = arith.addi %arg20, %arg17 : index
        %78 = arith.addi %arg21, %arg18 : index
        %79 = arith.addi %arg22, %arg19 : index
        memref.store %cst_14, %reinterpret_cast_25[%77, %78, %79] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %33 = memref.load %arg3[%c0] : memref<?xi32>
    %34 = arith.cmpi eq, %33, %c2_i32 : i32
    %35 = scf.if %34 -> (i1) {
      scf.yield %true : i1
    } else {
      %74 = arith.cmpi eq, %33, %c4_i32 : i32
      scf.yield %74 : i1
    }
    scf.if %35 {
      memref.store %cst_13, %alloca_16[%c0] : memref<5xf32>
      memref.store %cst_12, %alloca_16[%c1] : memref<5xf32>
      memref.store %cst_11, %alloca_16[%c2] : memref<5xf32>
      memref.store %cst_10, %alloca_16[%c3] : memref<5xf32>
      memref.store %cst_9, %alloca_16[%c4] : memref<5xf32>
      memref.store %cst_8, %alloca_15[%c0] : memref<5xf32>
      memref.store %cst_7, %alloca_15[%c1] : memref<5xf32>
      memref.store %cst_6, %alloca_15[%c2] : memref<5xf32>
      memref.store %cst_5, %alloca_15[%c3] : memref<5xf32>
      memref.store %cst_4, %alloca_15[%c4] : memref<5xf32>
      memref.store %cst_3, %alloca[%c0] : memref<5xf32>
      memref.store %cst_2, %alloca[%c1] : memref<5xf32>
      memref.store %cst_1, %alloca[%c2] : memref<5xf32>
      memref.store %cst_0, %alloca[%c3] : memref<5xf32>
      memref.store %cst, %alloca[%c4] : memref<5xf32>
      %74 = memref.load %19[%c0] : memref<1xi32>
      %75 = arith.index_cast %74 : i32 to index
      %76 = memref.get_global @ntp : memref<1xi32>
      %77 = memref.load %0[%c0] : memref<1xi32>
      %78 = memref.load %3[%c0] : memref<1xi32>
      %79 = memref.load %76[%c0] : memref<1xi32>
      %80 = arith.index_cast %77 : i32 to index
      %81 = arith.index_cast %78 : i32 to index
      %82 = arith.index_cast %79 : i32 to index
      %83 = arith.addi %82, %c-1 : index
      %84 = memref.load %alloca_16[%83] : memref<5xf32>
      %85 = memref.load %alloca_15[%83] : memref<5xf32>
      %86 = memref.load %alloca[%83] : memref<5xf32>
      %87 = arith.subf %cst_6, %84 : f32
      scf.parallel (%arg17, %arg18, %arg19) = (%c0, %c0, %c0) to (%75, %80, %81) step (%c2, %c4, %c32) {
        %88 = affine.min #map4(%75, %arg17)
        %89 = affine.min #map5(%80, %arg18)
        %90 = affine.min #map6(%81, %arg19)
        scf.parallel (%arg20, %arg21, %arg22) = (%c0, %c0, %c0) to (%88, %89, %90) step (%c1, %c1, %c1) {
          %91 = arith.addi %arg20, %arg17 : index
          %92 = arith.addi %arg21, %arg18 : index
          %93 = arith.addi %arg22, %arg19 : index
          %94 = memref.load %arg10[%91] : memref<?xf32>
          %95 = arith.muli %91, %81 : index
          %96 = arith.muli %95, %80 : index
          %97 = arith.muli %92, %81 : index
          %98 = arith.addi %93, %97 : index
          %99 = arith.addi %98, %96 : index
          %100 = memref.load %arg11[%98] : memref<?xf32>
          %101 = memref.load %arg4[%98] : memref<?xf32>
          %102 = arith.mulf %94, %101 : f32
          %103 = arith.divf %102, %85 : f32
          %104 = math.exp %103 : f32
          %105 = arith.mulf %84, %104 : f32
          %106 = arith.divf %102, %86 : f32
          %107 = math.exp %106 : f32
          %108 = arith.mulf %87, %107 : f32
          %109 = arith.addf %105, %108 : f32
          %110 = arith.mulf %100, %109 : f32
          memref.store %110, %arg16[%99] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    }
    %36 = memref.load %arg3[%c0] : memref<?xi32>
    %37 = arith.cmpi eq, %36, %c1_i32 : i32
    scf.if %37 {
      %74 = memref.load %0[%c0] : memref<1xi32>
      %75 = arith.index_cast %74 : i32 to index
      %76 = memref.load %3[%c0] : memref<1xi32>
      %77 = memref.load %9[%c0] : memref<1xf32>
      %78 = arith.index_cast %76 : i32 to index
      %79 = arith.negf %77 : f32
      scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%75, %78) step (%c8, %c32) {
        %80 = affine.min #map7(%75, %arg17)
        %81 = affine.min #map6(%78, %arg18)
        scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%80, %81) step (%c1, %c1) {
          %82 = arith.addi %arg19, %arg17 : index
          %83 = arith.addi %arg20, %arg18 : index
          %84 = memref.load %arg14[%c0] : memref<?xf32>
          %85 = arith.negf %84 : f32
          %86 = arith.muli %82, %78 : index
          %87 = arith.addi %83, %86 : index
          %88 = memref.load %arg7[%87] : memref<?xf32>
          %89 = arith.subf %88, %cst_6 : f32
          %90 = arith.divf %88, %89 : f32
          memref.store %90, %arg12[%87] : memref<?xf32>
          %91 = memref.load %arg1[%87] : memref<?xf32>
          %92 = arith.mulf %79, %91 : f32
          %93 = memref.load %arg4[%87] : memref<?xf32>
          %94 = arith.mulf %85, %93 : f32
          %95 = arith.divf %92, %94 : f32
          %96 = memref.load %arg0[%87] : memref<?xf32>
          %97 = arith.subf %95, %96 : f32
          memref.store %97, %arg13[%87] : memref<?xf32>
          %98 = memref.load %arg13[%87] : memref<?xf32>
          %99 = memref.load %arg7[%87] : memref<?xf32>
          %100 = arith.subf %99, %cst_6 : f32
          %101 = arith.divf %98, %100 : f32
          memref.store %101, %arg13[%87] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    } else {
      %74 = memref.load %arg3[%c0] : memref<?xi32>
      %75 = arith.cmpi eq, %74, %c2_i32 : i32
      scf.if %75 {
        %76 = memref.load %0[%c0] : memref<1xi32>
        %77 = arith.index_cast %76 : i32 to index
        %78 = memref.load %3[%c0] : memref<1xi32>
        %79 = memref.load %9[%c0] : memref<1xf32>
        %80 = arith.index_cast %78 : i32 to index
        %81 = arith.muli %80, %77 : index
        scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%77, %80) step (%c8, %c32) {
          %82 = affine.min #map7(%77, %arg17)
          %83 = affine.min #map6(%80, %arg18)
          scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%82, %83) step (%c1, %c1) {
            %84 = arith.addi %arg19, %arg17 : index
            %85 = arith.addi %arg20, %arg18 : index
            %86 = memref.load %arg14[%c0] : memref<?xf32>
            %87 = arith.muli %84, %80 : index
            %88 = arith.addi %85, %87 : index
            %89 = memref.load %arg7[%88] : memref<?xf32>
            %90 = arith.subf %89, %cst_6 : f32
            %91 = arith.divf %89, %90 : f32
            memref.store %91, %arg12[%88] : memref<?xf32>
            %92 = memref.load %arg1[%88] : memref<?xf32>
            %93 = memref.load %arg16[%88] : memref<?xf32>
            %94 = arith.addf %92, %93 : f32
            %95 = arith.addi %88, %81 : index
            %96 = memref.load %arg16[%95] : memref<?xf32>
            %97 = arith.subf %94, %96 : f32
            %98 = arith.mulf %79, %97 : f32
            %99 = memref.load %arg4[%88] : memref<?xf32>
            %100 = arith.mulf %86, %99 : f32
            %101 = arith.divf %98, %100 : f32
            %102 = memref.load %arg0[%88] : memref<?xf32>
            %103 = arith.subf %101, %102 : f32
            memref.store %103, %arg13[%88] : memref<?xf32>
            %104 = memref.load %arg13[%88] : memref<?xf32>
            %105 = memref.load %arg7[%88] : memref<?xf32>
            %106 = arith.subf %105, %cst_6 : f32
            %107 = arith.divf %104, %106 : f32
            memref.store %107, %arg13[%88] : memref<?xf32>
            scf.reduce 
          } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      } else {
        %76 = memref.load %arg3[%c0] : memref<?xi32>
        %77 = arith.cmpi eq, %76, %c3_i32 : i32
        %78 = scf.if %77 -> (i1) {
          scf.yield %true : i1
        } else {
          %79 = arith.cmpi eq, %76, %c4_i32 : i32
          scf.yield %79 : i1
        }
        scf.if %78 {
          %79 = memref.load %0[%c0] : memref<1xi32>
          %80 = arith.index_cast %79 : i32 to index
          %81 = memref.load %3[%c0] : memref<1xi32>
          %82 = arith.index_cast %81 : i32 to index
          scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%80, %82) step (%c8, %c32) {
            %83 = affine.min #map7(%80, %arg17)
            %84 = affine.min #map6(%82, %arg18)
            scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%83, %84) step (%c1, %c1) {
              %85 = arith.addi %arg19, %arg17 : index
              %86 = arith.addi %arg20, %arg18 : index
              %87 = arith.muli %85, %82 : index
              %88 = arith.addi %86, %87 : index
              memref.store %cst_14, %arg12[%88] : memref<?xf32>
              %89 = memref.load %arg2[%88] : memref<?xf32>
              memref.store %89, %arg13[%88] : memref<?xf32>
              scf.reduce 
            } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
            scf.reduce 
          } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        }
      }
    }
    %38 = memref.load %6[%c0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = memref.load %0[%c0] : memref<1xi32>
    %41 = memref.load %3[%c0] : memref<1xi32>
    %42 = memref.load %9[%c0] : memref<1xf32>
    %43 = arith.index_cast %40 : i32 to index
    %44 = arith.index_cast %41 : i32 to index
    %45 = arith.muli %44, %43 : index
    %reinterpret_cast_26 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%39, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_27 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%39, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_28 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%39, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_29 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%39, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_30 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%39, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_31 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%39, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_32 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%43, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %46 = arith.maxsi %26, %43 : index
    %47 = arith.maxsi %27, %44 : index
    scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%46, %47) step (%c8, %c32) {
      %74 = affine.min #map(%arg17)[%46]
      %75 = affine.min #map1(%arg18)[%47]
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%74, %75) step (%c1, %c1) {
        %76 = arith.addi %arg19, %arg17 : index
        %77 = arith.addi %arg20, %arg18 : index
        scf.for %arg21 = %c1 to %39 step %c1 {
          %78 = memref.load %arg14[%arg21] : memref<?xf32>
          %79 = arith.addi %arg21, %c-1 : index
          %80 = memref.load %arg15[%79] : memref<?xf32>
          %81 = arith.mulf %78, %80 : f32
          %82 = arith.cmpi slt, %76, %26 : index
          %83 = arith.cmpi slt, %77, %27 : index
          %84 = arith.andi %82, %83 : i1
          scf.if %84 {
            %89 = memref.load %reinterpret_cast_22[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %90 = arith.addf %89, %25 : f32
            %91 = arith.mulf %28, %90 : f32
            %92 = memref.load %reinterpret_cast_24[%76, %77] : memref<?x?xf32, strided<[?, 1]>>
            %93 = arith.mulf %81, %92 : f32
            %94 = arith.mulf %93, %92 : f32
            %95 = arith.divf %91, %94 : f32
            memref.store %95, %reinterpret_cast_23[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          }
          %85 = memref.load %arg14[%arg21] : memref<?xf32>
          %86 = arith.cmpi slt, %76, %43 : index
          %87 = arith.cmpi slt, %77, %44 : index
          %88 = arith.andi %86, %87 : i1
          scf.if %88 {
            %89 = memref.load %reinterpret_cast_26[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %90 = memref.load %reinterpret_cast_27[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %91 = memref.load %reinterpret_cast_28[%79, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %92 = arith.subf %cst_6, %91 : f32
            %93 = arith.mulf %90, %92 : f32
            %94 = arith.addf %89, %93 : f32
            %95 = arith.subf %94, %cst_6 : f32
            %96 = arith.divf %cst_6, %95 : f32
            memref.store %96, %reinterpret_cast_29[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %97 = memref.load %reinterpret_cast_26[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %98 = arith.mulf %97, %96 : f32
            memref.store %98, %reinterpret_cast_28[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %99 = memref.load %reinterpret_cast_27[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %100 = memref.load %reinterpret_cast_29[%79, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %101 = arith.mulf %99, %100 : f32
            %102 = memref.load %reinterpret_cast_30[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %103 = arith.subf %101, %102 : f32
            %104 = memref.load %reinterpret_cast_31[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %105 = arith.addi %arg21, %c1 : index
            %106 = memref.load %reinterpret_cast_31[%105, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %107 = arith.subf %104, %106 : f32
            %108 = arith.mulf %42, %107 : f32
            %109 = memref.load %reinterpret_cast_32[%76, %77] : memref<?x?xf32, strided<[?, 1]>>
            %110 = arith.mulf %109, %85 : f32
            %111 = arith.divf %108, %110 : f32
            %112 = arith.addf %103, %111 : f32
            %113 = memref.load %reinterpret_cast_29[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %114 = arith.mulf %112, %113 : f32
            memref.store %114, %reinterpret_cast_29[%arg21, %76, %77] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          }
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %48 = memref.load %0[%c0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    %50 = memref.load %3[%c0] : memref<1xi32>
    %51 = memref.load %6[%c0] : memref<1xi32>
    %52 = memref.load %9[%c0] : memref<1xf32>
    %53 = memref.load %29[%c0] : memref<1xi32>
    %54 = arith.index_cast %50 : i32 to index
    %55 = arith.index_cast %51 : i32 to index
    %56 = arith.muli %55, %54 : index
    %57 = arith.muli %56, %49 : index
    %58 = arith.addi %55, %c-1 : index
    %59 = arith.muli %58, %54 : index
    %60 = arith.muli %59, %49 : index
    %61 = arith.index_cast %53 : i32 to index
    %62 = arith.addi %61, %c-1 : index
    %63 = arith.muli %62, %54 : index
    %64 = arith.muli %63, %49 : index
    %reinterpret_cast_33 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%49, %54], strides: [%54, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%49, %54) step (%c8, %c32) {
      %74 = affine.min #map(%arg17)[%49]
      %75 = affine.min #map1(%arg18)[%54]
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%74, %75) step (%c1, %c1) {
        %76 = arith.addi %arg19, %arg17 : index
        %77 = arith.addi %arg20, %arg18 : index
        %78 = memref.load %arg14[%55] : memref<?xf32>
        %79 = arith.muli %76, %54 overflow<nsw> : index
        %80 = arith.addi %77, %79 : index
        %81 = arith.addi %80, %57 : index
        %82 = memref.load %arg9[%81] : memref<?xf32>
        %83 = arith.addi %80, %60 : index
        %84 = memref.load %arg13[%83] : memref<?xf32>
        %85 = arith.mulf %82, %84 : f32
        %86 = memref.load %arg0[%81] : memref<?xf32>
        %87 = arith.subf %85, %86 : f32
        %88 = memref.load %arg16[%81] : memref<?xf32>
        %89 = arith.addi %80, %64 : index
        %90 = memref.load %arg16[%89] : memref<?xf32>
        %91 = arith.subf %88, %90 : f32
        %92 = arith.mulf %52, %91 : f32
        %93 = memref.load %reinterpret_cast_33[%76, %77] : memref<?x?xf32, strided<[?, 1]>>
        %94 = arith.mulf %93, %78 : f32
        %95 = arith.divf %92, %94 : f32
        %96 = arith.addf %87, %95 : f32
        %97 = memref.load %arg12[%83] : memref<?xf32>
        %98 = arith.subf %cst_6, %97 : f32
        %99 = arith.mulf %82, %98 : f32
        %100 = arith.subf %99, %cst_6 : f32
        %101 = arith.divf %96, %100 : f32
        memref.store %101, %arg0[%81] : memref<?xf32>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %65 = memref.load %29[%c0] : memref<1xi32>
    %66 = arith.addi %65, %c-3_i32 : i32
    %67 = arith.index_cast %66 : i32 to index
    %68 = arith.addi %67, %c1 : index
    %69 = arith.maxsi %68, %c0 : index
    %70 = memref.load %0[%c0] : memref<1xi32>
    %71 = arith.index_cast %70 : i32 to index
    %72 = memref.load %3[%c0] : memref<1xi32>
    %73 = arith.index_cast %72 : i32 to index
    scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%71, %73) step (%c8, %c32) {
      %74 = affine.min #map(%arg17)[%71]
      %75 = affine.min #map1(%arg18)[%73]
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%74, %75) step (%c1, %c1) {
        %76 = arith.addi %arg19, %arg17 : index
        %77 = arith.addi %arg20, %arg18 : index
        scf.for %arg21 = %c0 to %69 step %c1 {
          %78 = arith.subi %67, %arg21 : index
          %79 = arith.index_cast %78 : index to i32
          %80 = arith.muli %79, %72 : i32
          %81 = arith.muli %80, %70 : i32
          %82 = arith.addi %79, %c1_i32 : i32
          %83 = arith.muli %82, %72 : i32
          %84 = arith.muli %83, %70 : i32
          %85 = arith.index_cast %76 : index to i32
          %86 = arith.muli %85, %72 : i32
          %87 = arith.index_cast %77 : index to i32
          %88 = arith.addi %87, %86 : i32
          %89 = arith.addi %88, %81 : i32
          %90 = arith.index_cast %89 : i32 to index
          %91 = memref.load %arg12[%90] : memref<?xf32>
          %92 = arith.addi %88, %84 : i32
          %93 = arith.index_cast %92 : i32 to index
          %94 = memref.load %arg0[%93] : memref<?xf32>
          %95 = arith.mulf %91, %94 : f32
          %96 = memref.load %arg13[%90] : memref<?xf32>
          %97 = arith.addf %95, %96 : f32
          memref.store %97, %arg0[%90] : memref<?xf32>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


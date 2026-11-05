#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map3 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @tprni : memref<1xf32>
  memref.global @kb : memref<1xi32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advt1_(%arg0: memref<?xf32> {polygeist.name = "fb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fclim", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "zflux", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg19: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg20: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c-1 = arith.constant -1 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @kbm1 : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = arith.muli %8, %7 : index
    %10 = arith.muli %9, %2 : index
    %11 = arith.subi %8, %c1 : index
    %12 = arith.muli %11, %7 : index
    %13 = arith.muli %12, %2 : index
    %14 = memref.get_global @kb : memref<1xi32>
    %15 = memref.load %14[%c0] : memref<1xi32>
    %16 = arith.index_cast %15 : i32 to index
    scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%2, %7) step (%c8, %c32) {
      %50 = affine.min #map(%arg21)[%2]
      %51 = affine.min #map1(%arg22)[%7]
      scf.parallel (%arg23, %arg24) = (%c0, %c0) to (%50, %51) step (%c1, %c1) {
        %52 = arith.addi %arg23, %arg21 : index
        %53 = arith.addi %arg24, %arg22 : index
        %54 = arith.muli %52, %7 overflow<nsw> : index
        %55 = arith.addi %53, %54 : index
        %56 = arith.addi %55, %13 : index
        %57 = memref.load %arg1[%56] : memref<?xf32>
        %58 = arith.addi %55, %10 : index
        memref.store %57, %arg1[%58] : memref<?xf32>
        %59 = memref.load %arg0[%56] : memref<?xf32>
        memref.store %59, %arg0[%58] : memref<?xf32>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %17 = arith.muli %7, %2 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%2, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%8, %2, %7) step (%c2, %c4, %c32) {
      %50 = affine.min #map2(%arg21)[%8]
      %51 = affine.min #map3(%arg22)[%2]
      %52 = affine.min #map1(%arg23)[%7]
      scf.parallel (%arg24, %arg25, %arg26) = (%c0, %c0, %c0) to (%50, %51, %52) step (%c1, %c1, %c1) {
        %53 = arith.addi %arg24, %arg21 : index
        %54 = arith.addi %arg25, %arg22 : index
        %55 = arith.addi %arg26, %arg23 : index
        %56 = memref.load %reinterpret_cast_6[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %57 = arith.muli %54, %7 overflow<nsw> : index
        %58 = arith.addi %55, %57 : index
        %59 = arith.addi %58, %c-1 : index
        %60 = memref.load %arg9[%59] : memref<?xf32>
        %61 = arith.addf %56, %60 : f32
        %62 = memref.load %reinterpret_cast[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %63 = arith.muli %53, %7 overflow<nsw> : index
        %64 = arith.muli %63, %2 overflow<nsw> : index
        %65 = arith.addi %58, %64 : index
        %66 = arith.addi %65, %c-1 : index
        %67 = memref.load %arg1[%66] : memref<?xf32>
        %68 = arith.addf %62, %67 : f32
        %69 = arith.mulf %61, %68 : f32
        %70 = memref.load %reinterpret_cast_2[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %71 = arith.mulf %69, %70 : f32
        %72 = arith.mulf %71, %cst_1 : f32
        memref.store %72, %reinterpret_cast_3[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %73 = memref.load %reinterpret_cast_6[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %74 = arith.addi %54, %c-1 : index
        %75 = memref.load %reinterpret_cast_6[%74, %55] : memref<?x?xf32, strided<[?, 1]>>
        %76 = arith.addf %73, %75 : f32
        %77 = memref.load %reinterpret_cast[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %78 = memref.load %reinterpret_cast[%53, %74, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %79 = arith.addf %77, %78 : f32
        %80 = arith.mulf %76, %79 : f32
        %81 = memref.load %reinterpret_cast_4[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %82 = arith.mulf %80, %81 : f32
        %83 = arith.mulf %82, %cst_1 : f32
        memref.store %83, %reinterpret_cast_5[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%16, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%16, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%16, %2, %7) step (%c2, %c4, %c32) {
      %50 = affine.min #map2(%arg21)[%16]
      %51 = affine.min #map3(%arg22)[%2]
      %52 = affine.min #map1(%arg23)[%7]
      scf.parallel (%arg24, %arg25, %arg26) = (%c0, %c0, %c0) to (%50, %51, %52) step (%c1, %c1, %c1) {
        %53 = arith.addi %arg24, %arg21 : index
        %54 = arith.addi %arg25, %arg22 : index
        %55 = arith.addi %arg26, %arg23 : index
        %56 = memref.load %reinterpret_cast_7[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %57 = memref.load %reinterpret_cast_8[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %58 = arith.subf %56, %57 : f32
        memref.store %58, %reinterpret_cast_7[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %18 = memref.load %4[%c0] : memref<1xi32>
    %19 = arith.index_cast %18 : i32 to index
    %20 = memref.get_global @tprni : memref<1xf32>
    %21 = memref.load %0[%c0] : memref<1xi32>
    %22 = memref.load %3[%c0] : memref<1xi32>
    %23 = memref.load %20[%c0] : memref<1xf32>
    %24 = arith.index_cast %21 : i32 to index
    %25 = arith.index_cast %22 : i32 to index
    %26 = memref.load %14[%c0] : memref<1xi32>
    %27 = arith.index_cast %26 : i32 to index
    %28 = memref.get_global @jmm1 : memref<1xi32>
    %29 = memref.load %28[%c0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = memref.get_global @imm1 : memref<1xi32>
    %32 = memref.load %31[%c0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %34 = arith.muli %19, %25 : index
    %35 = arith.muli %34, %24 : index
    %36 = arith.muli %25, %24 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%19, %24, %25) step (%c2, %c4, %c32) {
      %50 = affine.min #map2(%arg21)[%19]
      %51 = affine.min #map3(%arg22)[%24]
      %52 = affine.min #map1(%arg23)[%25]
      scf.parallel (%arg24, %arg25, %arg26) = (%c0, %c0, %c0) to (%50, %51, %52) step (%c1, %c1, %c1) {
        %53 = arith.addi %arg24, %arg21 : index
        %54 = arith.addi %arg25, %arg22 : index
        %55 = arith.addi %arg26, %arg23 : index
        %56 = memref.load %reinterpret_cast_9[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %57 = arith.muli %54, %25 overflow<nsw> : index
        %58 = arith.addi %55, %57 : index
        %59 = arith.muli %53, %25 overflow<nsw> : index
        %60 = arith.muli %59, %24 overflow<nsw> : index
        %61 = arith.addi %58, %60 : index
        %62 = arith.addi %61, %c-1 : index
        %63 = memref.load %arg10[%62] : memref<?xf32>
        %64 = arith.addf %56, %63 : f32
        %65 = arith.mulf %64, %cst_0 : f32
        %66 = memref.load %reinterpret_cast_13[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %67 = arith.addi %58, %c-1 : index
        %68 = memref.load %arg16[%67] : memref<?xf32>
        %69 = arith.addf %66, %68 : f32
        %70 = arith.mulf %65, %69 : f32
        %71 = arith.mulf %70, %23 : f32
        %72 = memref.load %reinterpret_cast_10[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %73 = memref.load %arg0[%62] : memref<?xf32>
        %74 = arith.subf %72, %73 : f32
        %75 = arith.mulf %71, %74 : f32
        %76 = memref.load %reinterpret_cast_14[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %77 = arith.mulf %75, %76 : f32
        %78 = memref.load %reinterpret_cast_15[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %79 = memref.load %arg13[%67] : memref<?xf32>
        %80 = arith.addf %78, %79 : f32
        %81 = arith.divf %77, %80 : f32
        %82 = memref.load %reinterpret_cast_11[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %83 = arith.subf %82, %81 : f32
        memref.store %83, %reinterpret_cast_11[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %84 = memref.load %reinterpret_cast_9[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %85 = arith.addi %54, %c-1 : index
        %86 = memref.load %reinterpret_cast_9[%53, %85, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %87 = arith.addf %84, %86 : f32
        %88 = arith.mulf %87, %cst_0 : f32
        %89 = memref.load %reinterpret_cast_13[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %90 = memref.load %reinterpret_cast_13[%85, %55] : memref<?x?xf32, strided<[?, 1]>>
        %91 = arith.addf %89, %90 : f32
        %92 = arith.mulf %88, %91 : f32
        %93 = arith.mulf %92, %23 : f32
        %94 = memref.load %reinterpret_cast_10[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %95 = memref.load %reinterpret_cast_10[%53, %85, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %96 = arith.subf %94, %95 : f32
        %97 = arith.mulf %93, %96 : f32
        %98 = memref.load %reinterpret_cast_16[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %99 = arith.mulf %97, %98 : f32
        %100 = memref.load %reinterpret_cast_17[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %101 = memref.load %reinterpret_cast_17[%85, %55] : memref<?x?xf32, strided<[?, 1]>>
        %102 = arith.addf %100, %101 : f32
        %103 = arith.divf %99, %102 : f32
        %104 = memref.load %reinterpret_cast_12[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %105 = arith.subf %104, %103 : f32
        memref.store %105, %reinterpret_cast_12[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %106 = memref.load %reinterpret_cast_17[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %107 = memref.load %arg14[%67] : memref<?xf32>
        %108 = arith.addf %106, %107 : f32
        %109 = arith.mulf %108, %cst_0 : f32
        %110 = memref.load %reinterpret_cast_11[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %111 = arith.mulf %109, %110 : f32
        memref.store %111, %reinterpret_cast_11[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %112 = memref.load %reinterpret_cast_15[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %113 = memref.load %reinterpret_cast_15[%85, %55] : memref<?x?xf32, strided<[?, 1]>>
        %114 = arith.addf %112, %113 : f32
        %115 = arith.mulf %114, %cst_0 : f32
        %116 = memref.load %reinterpret_cast_12[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %117 = arith.mulf %115, %116 : f32
        memref.store %117, %reinterpret_cast_12[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%27, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%27, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%27, %24, %25) step (%c2, %c4, %c32) {
      %50 = affine.min #map2(%arg21)[%27]
      %51 = affine.min #map3(%arg22)[%24]
      %52 = affine.min #map1(%arg23)[%25]
      scf.parallel (%arg24, %arg25, %arg26) = (%c0, %c0, %c0) to (%50, %51, %52) step (%c1, %c1, %c1) {
        %53 = arith.addi %arg24, %arg21 : index
        %54 = arith.addi %arg25, %arg22 : index
        %55 = arith.addi %arg26, %arg23 : index
        %56 = memref.load %reinterpret_cast_18[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %57 = memref.load %reinterpret_cast_19[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %58 = arith.addf %57, %56 : f32
        memref.store %58, %reinterpret_cast_19[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_20 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22) = (%c1, %c1) to (%30, %33) step (%c8, %c32) {
      %50 = affine.min #map(%arg21)[%30]
      %51 = affine.min #map1(%arg22)[%33]
      scf.parallel (%arg23, %arg24) = (%c0, %c0) to (%50, %51) step (%c1, %c1) {
        %52 = arith.addi %arg23, %arg21 : index
        %53 = arith.addi %arg24, %arg22 : index
        %54 = memref.load %reinterpret_cast_20[%52, %53] : memref<?x?xf32, strided<[?, 1]>>
        %55 = memref.load %reinterpret_cast_21[%52, %53] : memref<?x?xf32, strided<[?, 1]>>
        %56 = arith.mulf %54, %55 : f32
        %57 = memref.load %reinterpret_cast_22[%52, %53] : memref<?x?xf32, strided<[?, 1]>>
        %58 = arith.mulf %56, %57 : f32
        memref.store %58, %reinterpret_cast_23[%52, %53] : memref<?x?xf32, strided<[?, 1]>>
        %59 = arith.muli %52, %25 overflow<nsw> : index
        %60 = arith.addi %53, %59 : index
        %61 = arith.addi %60, %35 : index
        memref.store %cst, %arg6[%61] : memref<?xf32>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_24 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_26 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c1, %c1, %c1) to (%19, %30, %33) step (%c2, %c4, %c32) {
      %50 = affine.min #map2(%arg21)[%19]
      %51 = affine.min #map3(%arg22)[%30]
      %52 = affine.min #map1(%arg23)[%33]
      scf.parallel (%arg24, %arg25, %arg26) = (%c0, %c0, %c0) to (%50, %51, %52) step (%c1, %c1, %c1) {
        %53 = arith.addi %arg24, %arg21 : index
        %54 = arith.addi %arg25, %arg22 : index
        %55 = arith.addi %arg26, %arg23 : index
        %56 = arith.addi %53, %c-1 : index
        %57 = memref.load %reinterpret_cast_24[%56, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %58 = memref.load %reinterpret_cast_24[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %59 = arith.addf %57, %58 : f32
        %60 = arith.mulf %59, %cst_0 : f32
        %61 = memref.load %reinterpret_cast_25[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %62 = arith.mulf %60, %61 : f32
        %63 = memref.load %reinterpret_cast_22[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %64 = arith.mulf %62, %63 : f32
        memref.store %64, %reinterpret_cast_26[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %37 = memref.load %4[%c0] : memref<1xi32>
    %38 = arith.index_cast %37 : i32 to index
    %39 = memref.get_global @dti2 : memref<1xf32>
    %40 = memref.load %28[%c0] : memref<1xi32>
    %41 = memref.load %31[%c0] : memref<1xi32>
    %42 = memref.load %3[%c0] : memref<1xi32>
    %43 = memref.load %0[%c0] : memref<1xi32>
    %44 = memref.load %39[%c0] : memref<1xf32>
    %45 = arith.index_cast %40 : i32 to index
    %46 = arith.index_cast %41 : i32 to index
    %47 = arith.index_cast %42 : i32 to index
    %48 = arith.index_cast %43 : i32 to index
    %49 = arith.muli %47, %48 : index
    %reinterpret_cast_27 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_28 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_29 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_30 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_31 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_32 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_33 = memref.reinterpret_cast %arg19 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_34 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_35 = memref.reinterpret_cast %arg20 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%38, %45, %46) step (%c2, %c4, %c32) {
      %50 = affine.min #map2(%arg21)[%38]
      %51 = affine.min #map3(%arg22)[%45]
      %52 = affine.min #map1(%arg23)[%46]
      scf.parallel (%arg24, %arg25, %arg26) = (%c0, %c0, %c0) to (%50, %51, %52) step (%c1, %c1, %c1) {
        %53 = arith.addi %arg24, %arg21 : index
        %54 = arith.addi %arg25, %arg22 : index
        %55 = arith.addi %arg26, %arg23 : index
        %56 = memref.load %arg15[%53] : memref<?xf32>
        %57 = arith.muli %54, %47 overflow<nsw> : index
        %58 = arith.addi %55, %57 : index
        %59 = arith.muli %53, %47 overflow<nsw> : index
        %60 = arith.muli %59, %48 overflow<nsw> : index
        %61 = arith.addi %58, %60 : index
        %62 = arith.addi %61, %c1 : index
        %63 = memref.load %arg4[%62] : memref<?xf32>
        %64 = memref.load %reinterpret_cast_27[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %65 = arith.subf %63, %64 : f32
        %66 = arith.addi %54, %c1 : index
        %67 = memref.load %reinterpret_cast_28[%53, %66, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %68 = arith.addf %65, %67 : f32
        %69 = memref.load %reinterpret_cast_28[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %70 = arith.subf %68, %69 : f32
        %71 = memref.load %reinterpret_cast_29[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %72 = arith.addi %53, %c1 : index
        %73 = memref.load %reinterpret_cast_29[%72, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %74 = arith.subf %71, %73 : f32
        %75 = arith.divf %74, %56 : f32
        %76 = arith.addf %70, %75 : f32
        memref.store %76, %reinterpret_cast_30[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %77 = memref.load %reinterpret_cast_31[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %78 = memref.load %reinterpret_cast_32[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %79 = memref.load %reinterpret_cast_33[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %80 = arith.addf %78, %79 : f32
        %81 = arith.mulf %77, %80 : f32
        %82 = memref.load %reinterpret_cast_34[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %83 = arith.mulf %81, %82 : f32
        %84 = arith.mulf %44, %76 : f32
        %85 = arith.subf %83, %84 : f32
        %86 = memref.load %reinterpret_cast_35[%54, %55] : memref<?x?xf32, strided<[?, 1]>>
        %87 = arith.addf %78, %86 : f32
        %88 = arith.mulf %87, %82 : f32
        %89 = arith.divf %85, %88 : f32
        memref.store %89, %reinterpret_cast_30[%53, %54, %55] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


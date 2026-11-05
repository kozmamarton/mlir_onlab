#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map2 = affine_map<(d0, d1) -> (8, d0 - d1)>
#map3 = affine_map<(d0, d1) -> (32, d0 - d1)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @mode : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advave_(%arg0: memref<?xf32> {polygeist.name = "curv2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "aam2d", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c0 = arith.constant 0 : index
    %c-1 = arith.constant -1 : index
    %c2 = arith.constant 2 : index
    %cst = arith.constant -5.000000e-01 : f32
    %c2_i32 = arith.constant 2 : i32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 2.000000e+00 : f32
    %cst_2 = arith.constant 1.250000e-01 : f32
    %cst_3 = arith.constant 0.000000e+00 : f32
    %c1 = arith.constant 1 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = memref.get_global @imm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.get_global @jmm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %12 = arith.maxsi %8, %5 : index
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%2, %12) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%2]
      %18 = affine.min #map1(%arg20)[%12]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = arith.subi %5, %20 : index
        %22 = arith.addi %21, %c-1 : index
        %23 = arith.cmpi sge, %22, %c0 : index
        scf.if %23 {
          memref.store %cst_3, %reinterpret_cast[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        %24 = arith.addi %19, %c-1 : index
        %25 = arith.cmpi sge, %24, %c0 : index
        %26 = arith.addi %20, %c-1 : index
        %27 = arith.cmpi sge, %26, %c0 : index
        %28 = arith.andi %25, %27 : i1
        %29 = arith.subi %8, %20 : index
        %30 = arith.addi %29, %c-1 : index
        %31 = arith.cmpi sge, %30, %c0 : index
        %32 = arith.andi %28, %31 : i1
        scf.if %32 {
          %33 = arith.muli %19, %5 overflow<nsw> : index
          %34 = arith.addi %20, %33 : index
          %35 = arith.addi %34, %c1 : index
          %36 = memref.load %arg11[%35] : memref<?xf32>
          %37 = memref.load %reinterpret_cast_4[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %38 = arith.addf %36, %37 : f32
          %39 = memref.load %arg5[%35] : memref<?xf32>
          %40 = arith.mulf %38, %39 : f32
          %41 = arith.addi %34, %c-1 : index
          %42 = memref.load %arg11[%41] : memref<?xf32>
          %43 = arith.addf %37, %42 : f32
          %44 = memref.load %reinterpret_cast_5[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %45 = arith.mulf %43, %44 : f32
          %46 = arith.addf %40, %45 : f32
          %47 = arith.mulf %46, %cst_2 : f32
          %48 = arith.addf %39, %44 : f32
          %49 = arith.mulf %47, %48 : f32
          memref.store %49, %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_7 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %12) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%2]
      %18 = affine.min #map1(%arg20)[%12]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = arith.subi %5, %20 : index
        %22 = arith.addi %21, %c-1 : index
        %23 = arith.cmpi sge, %22, %c0 : index
        scf.if %23 {
          %27 = memref.load %reinterpret_cast_4[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %28 = arith.addi %19, %c-1 : index
          %29 = memref.load %reinterpret_cast_4[%28, %20] : memref<?x?xf32, strided<[?, 1]>>
          %30 = arith.addf %27, %29 : f32
          %31 = memref.load %reinterpret_cast_7[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %32 = arith.mulf %30, %31 : f32
          %33 = arith.muli %19, %5 overflow<nsw> : index
          %34 = arith.addi %20, %33 : index
          %35 = arith.addi %34, %c-1 : index
          %36 = memref.load %arg11[%35] : memref<?xf32>
          %37 = arith.muli %28, %5 overflow<nsw> : index
          %38 = arith.addi %20, %37 : index
          %39 = arith.addi %38, %c-1 : index
          %40 = memref.load %arg11[%39] : memref<?xf32>
          %41 = arith.addf %36, %40 : f32
          %42 = memref.load %arg6[%35] : memref<?xf32>
          %43 = arith.mulf %41, %42 : f32
          %44 = arith.addf %32, %43 : f32
          %45 = arith.mulf %44, %cst_2 : f32
          %46 = memref.load %reinterpret_cast_5[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %47 = memref.load %reinterpret_cast_5[%28, %20] : memref<?x?xf32, strided<[?, 1]>>
          %48 = arith.addf %46, %47 : f32
          %49 = arith.mulf %45, %48 : f32
          memref.store %49, %reinterpret_cast_8[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        %24 = arith.subi %8, %20 : index
        %25 = arith.addi %24, %c-1 : index
        %26 = arith.cmpi sge, %25, %c0 : index
        scf.if %26 {
          %27 = memref.load %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %28 = memref.load %reinterpret_cast_4[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %29 = arith.mulf %28, %cst_1 : f32
          %30 = memref.load %reinterpret_cast_9[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %31 = arith.mulf %29, %30 : f32
          %32 = arith.muli %19, %5 overflow<nsw> : index
          %33 = arith.addi %20, %32 : index
          %34 = arith.addi %33, %c1 : index
          %35 = memref.load %arg7[%34] : memref<?xf32>
          %36 = memref.load %reinterpret_cast_10[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %37 = arith.subf %35, %36 : f32
          %38 = arith.mulf %31, %37 : f32
          %39 = memref.load %reinterpret_cast_11[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %40 = arith.divf %38, %39 : f32
          %41 = arith.subf %27, %40 : f32
          memref.store %41, %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_12 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %5) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%2]
      %18 = affine.min #map1(%arg20)[%5]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = memref.load %reinterpret_cast_4[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %22 = arith.muli %19, %5 overflow<nsw> : index
        %23 = arith.addi %20, %22 : index
        %24 = arith.addi %23, %c-1 : index
        %25 = memref.load %arg11[%24] : memref<?xf32>
        %26 = arith.addf %21, %25 : f32
        %27 = arith.addi %19, %c-1 : index
        %28 = memref.load %reinterpret_cast_4[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
        %29 = arith.addf %26, %28 : f32
        %30 = arith.muli %27, %5 overflow<nsw> : index
        %31 = arith.addi %20, %30 : index
        %32 = arith.addi %31, %c-1 : index
        %33 = memref.load %arg11[%32] : memref<?xf32>
        %34 = arith.addf %29, %33 : f32
        %35 = arith.mulf %34, %cst_0 : f32
        %36 = memref.load %reinterpret_cast_9[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %37 = memref.load %reinterpret_cast_9[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.addf %36, %37 : f32
        %39 = memref.load %arg16[%24] : memref<?xf32>
        %40 = arith.addf %38, %39 : f32
        %41 = memref.load %arg16[%32] : memref<?xf32>
        %42 = arith.addf %40, %41 : f32
        %43 = arith.mulf %35, %42 : f32
        %44 = memref.load %reinterpret_cast_10[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %45 = memref.load %reinterpret_cast_10[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
        %46 = arith.subf %44, %45 : f32
        %47 = memref.load %reinterpret_cast_12[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %48 = memref.load %arg13[%24] : memref<?xf32>
        %49 = arith.addf %47, %48 : f32
        %50 = memref.load %reinterpret_cast_12[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
        %51 = arith.addf %49, %50 : f32
        %52 = memref.load %arg13[%32] : memref<?xf32>
        %53 = arith.addf %51, %52 : f32
        %54 = arith.divf %46, %53 : f32
        %55 = memref.load %reinterpret_cast_13[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %56 = memref.load %arg8[%24] : memref<?xf32>
        %57 = arith.subf %55, %56 : f32
        %58 = memref.load %reinterpret_cast_11[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %59 = memref.load %arg12[%24] : memref<?xf32>
        %60 = arith.addf %58, %59 : f32
        %61 = memref.load %reinterpret_cast_11[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
        %62 = arith.addf %60, %61 : f32
        %63 = memref.load %arg12[%32] : memref<?xf32>
        %64 = arith.addf %62, %63 : f32
        %65 = arith.divf %57, %64 : f32
        %66 = arith.addf %54, %65 : f32
        %67 = arith.mulf %43, %66 : f32
        memref.store %67, %reinterpret_cast_14[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %68 = memref.load %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %69 = memref.load %reinterpret_cast_12[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %70 = arith.mulf %68, %69 : f32
        memref.store %70, %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %71 = memref.load %reinterpret_cast_8[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %72 = memref.load %reinterpret_cast_14[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %73 = arith.subf %71, %72 : f32
        %74 = arith.mulf %73, %cst_0 : f32
        %75 = memref.load %reinterpret_cast_11[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %76 = memref.load %arg12[%24] : memref<?xf32>
        %77 = arith.addf %75, %76 : f32
        %78 = memref.load %reinterpret_cast_11[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
        %79 = arith.addf %77, %78 : f32
        %80 = memref.load %arg12[%32] : memref<?xf32>
        %81 = arith.addf %79, %80 : f32
        %82 = arith.mulf %74, %81 : f32
        memref.store %82, %reinterpret_cast_8[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_15 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %13 = arith.maxsi %2, %11 : index
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%13, %12) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%13]
      %18 = affine.min #map1(%arg20)[%12]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = arith.addi %19, %c-1 : index
        %22 = arith.cmpi sge, %21, %c0 : index
        %23 = arith.subi %11, %19 : index
        %24 = arith.addi %23, %c-1 : index
        %25 = arith.cmpi sge, %24, %c0 : index
        %26 = arith.andi %22, %25 : i1
        %27 = arith.addi %20, %c-1 : index
        %28 = arith.cmpi sge, %27, %c0 : index
        %29 = arith.andi %26, %28 : i1
        %30 = arith.subi %8, %20 : index
        %31 = arith.addi %30, %c-1 : index
        %32 = arith.cmpi sge, %31, %c0 : index
        %33 = arith.andi %29, %32 : i1
        scf.if %33 {
          %41 = memref.load %reinterpret_cast_15[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %42 = arith.muli %19, %5 overflow<nsw> : index
          %43 = arith.addi %20, %42 : index
          %44 = arith.addi %43, %c-1 : index
          %45 = memref.load %arg3[%44] : memref<?xf32>
          %46 = arith.subf %41, %45 : f32
          %47 = arith.addi %19, %c1 : index
          %48 = memref.load %reinterpret_cast_16[%47, %20] : memref<?x?xf32, strided<[?, 1]>>
          %49 = arith.addf %46, %48 : f32
          %50 = memref.load %reinterpret_cast_16[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %51 = arith.subf %49, %50 : f32
          memref.store %51, %reinterpret_cast_17[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        %34 = arith.subi %2, %19 : index
        %35 = arith.addi %34, %c-1 : index
        %36 = arith.cmpi sge, %35, %c0 : index
        %37 = arith.subi %5, %20 : index
        %38 = arith.addi %37, %c-1 : index
        %39 = arith.cmpi sge, %38, %c0 : index
        %40 = arith.andi %36, %39 : i1
        scf.if %40 {
          memref.store %cst_3, %reinterpret_cast_18[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_19 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%13, %5) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%13]
      %18 = affine.min #map1(%arg20)[%5]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = arith.subi %2, %19 : index
        %22 = arith.addi %21, %c-1 : index
        %23 = arith.cmpi sge, %22, %c0 : index
        scf.if %23 {
          %27 = memref.load %reinterpret_cast_4[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %28 = arith.muli %19, %5 overflow<nsw> : index
          %29 = arith.addi %20, %28 : index
          %30 = arith.addi %29, %c-1 : index
          %31 = memref.load %arg11[%30] : memref<?xf32>
          %32 = arith.addf %27, %31 : f32
          %33 = memref.load %reinterpret_cast_5[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %34 = arith.mulf %32, %33 : f32
          %35 = arith.addi %19, %c-1 : index
          %36 = memref.load %reinterpret_cast_4[%35, %20] : memref<?x?xf32, strided<[?, 1]>>
          %37 = arith.muli %35, %5 overflow<nsw> : index
          %38 = arith.addi %20, %37 : index
          %39 = arith.addi %38, %c-1 : index
          %40 = memref.load %arg11[%39] : memref<?xf32>
          %41 = arith.addf %36, %40 : f32
          %42 = memref.load %reinterpret_cast_5[%35, %20] : memref<?x?xf32, strided<[?, 1]>>
          %43 = arith.mulf %41, %42 : f32
          %44 = arith.addf %34, %43 : f32
          %45 = arith.mulf %44, %cst_2 : f32
          %46 = memref.load %arg6[%30] : memref<?xf32>
          %47 = memref.load %reinterpret_cast_7[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %48 = arith.addf %46, %47 : f32
          %49 = arith.mulf %45, %48 : f32
          memref.store %49, %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        %24 = arith.subi %11, %19 : index
        %25 = arith.addi %24, %c-1 : index
        %26 = arith.cmpi sge, %25, %c0 : index
        scf.if %26 {
          %27 = arith.addi %19, %c1 : index
          %28 = memref.load %reinterpret_cast_19[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
          %29 = memref.load %reinterpret_cast_19[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %30 = arith.addf %28, %29 : f32
          %31 = memref.load %reinterpret_cast_20[%27, %20] : memref<?x?xf32, strided<[?, 1]>>
          %32 = arith.mulf %30, %31 : f32
          %33 = arith.addi %19, %c-1 : index
          %34 = memref.load %reinterpret_cast_19[%33, %20] : memref<?x?xf32, strided<[?, 1]>>
          %35 = arith.addf %29, %34 : f32
          %36 = memref.load %reinterpret_cast_20[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
          %37 = arith.mulf %35, %36 : f32
          %38 = arith.addf %32, %37 : f32
          %39 = arith.mulf %38, %cst_2 : f32
          %40 = arith.addf %31, %36 : f32
          %41 = arith.mulf %39, %40 : f32
          memref.store %41, %reinterpret_cast_16[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_21 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%11, %5) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%11]
      %18 = affine.min #map1(%arg20)[%5]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = memref.load %reinterpret_cast_16[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %22 = memref.load %reinterpret_cast_19[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %23 = arith.mulf %22, %cst_1 : f32
        %24 = memref.load %reinterpret_cast_21[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %25 = arith.mulf %23, %24 : f32
        %26 = arith.addi %19, %c1 : index
        %27 = memref.load %reinterpret_cast_22[%26, %20] : memref<?x?xf32, strided<[?, 1]>>
        %28 = memref.load %reinterpret_cast_22[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %29 = arith.subf %27, %28 : f32
        %30 = arith.mulf %25, %29 : f32
        %31 = memref.load %reinterpret_cast_23[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %32 = arith.divf %30, %31 : f32
        %33 = arith.subf %21, %32 : f32
        memref.store %33, %reinterpret_cast_16[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %5) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%2]
      %18 = affine.min #map1(%arg20)[%5]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = memref.load %reinterpret_cast_8[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %22 = memref.load %reinterpret_cast_11[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %23 = arith.mulf %21, %22 : f32
        memref.store %23, %reinterpret_cast_8[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %24 = memref.load %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %25 = memref.load %reinterpret_cast_14[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %26 = arith.subf %24, %25 : f32
        %27 = arith.mulf %26, %cst_0 : f32
        %28 = memref.load %reinterpret_cast_12[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %29 = arith.muli %19, %5 overflow<nsw> : index
        %30 = arith.addi %20, %29 : index
        %31 = arith.addi %30, %c-1 : index
        %32 = memref.load %arg13[%31] : memref<?xf32>
        %33 = arith.addf %28, %32 : f32
        %34 = arith.addi %19, %c-1 : index
        %35 = memref.load %reinterpret_cast_12[%34, %20] : memref<?x?xf32, strided<[?, 1]>>
        %36 = arith.addf %33, %35 : f32
        %37 = arith.muli %34, %5 overflow<nsw> : index
        %38 = arith.addi %20, %37 : index
        %39 = arith.addi %38, %c-1 : index
        %40 = memref.load %arg13[%39] : memref<?xf32>
        %41 = arith.addf %36, %40 : f32
        %42 = arith.mulf %27, %41 : f32
        memref.store %42, %reinterpret_cast_6[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_24 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%11, %8) step (%c8, %c32) {
      %17 = affine.min #map(%arg19)[%11]
      %18 = affine.min #map1(%arg20)[%8]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
        %19 = arith.addi %arg21, %arg19 : index
        %20 = arith.addi %arg22, %arg20 : index
        %21 = arith.muli %19, %5 overflow<nsw> : index
        %22 = arith.addi %20, %21 : index
        %23 = arith.addi %22, %c1 : index
        %24 = memref.load %arg3[%23] : memref<?xf32>
        %25 = memref.load %reinterpret_cast_15[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %26 = arith.subf %24, %25 : f32
        %27 = memref.load %reinterpret_cast_16[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %28 = arith.addf %26, %27 : f32
        %29 = arith.addi %19, %c-1 : index
        %30 = memref.load %reinterpret_cast_16[%29, %20] : memref<?x?xf32, strided<[?, 1]>>
        %31 = arith.subf %28, %30 : f32
        memref.store %31, %reinterpret_cast_24[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %14 = memref.get_global @mode : memref<1xi32>
    %15 = memref.load %14[%c0] : memref<1xi32>
    %16 = arith.cmpi eq, %15, %c2_i32 : i32
    scf.if %16 {
      %17 = memref.load %9[%c0] : memref<1xi32>
      %18 = arith.index_cast %17 : i32 to index
      %19 = memref.load %6[%c0] : memref<1xi32>
      %20 = memref.load %3[%c0] : memref<1xi32>
      %21 = arith.index_cast %19 : i32 to index
      %22 = arith.index_cast %20 : i32 to index
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%18, %21) step (%c8, %c32) {
        %47 = affine.min #map2(%18, %arg19)
        %48 = affine.min #map3(%21, %arg20)
        scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%47, %48) step (%c1, %c1) {
          %49 = arith.addi %arg21, %arg19 : index
          %50 = arith.addi %arg22, %arg20 : index
          %51 = arith.muli %49, %22 : index
          %52 = arith.addi %49, %c1 : index
          %53 = arith.muli %52, %22 : index
          %54 = arith.addi %50, %51 : index
          %55 = memref.load %arg18[%54] : memref<?xf32>
          %56 = arith.addi %50, %c-1 : index
          %57 = arith.addi %56, %51 : index
          %58 = memref.load %arg18[%57] : memref<?xf32>
          %59 = arith.addf %55, %58 : f32
          %60 = arith.mulf %59, %cst : f32
          %61 = memref.load %arg7[%54] : memref<?xf32>
          %62 = arith.mulf %61, %61 : f32
          %63 = memref.load %arg8[%54] : memref<?xf32>
          %64 = arith.addi %50, %53 : index
          %65 = memref.load %arg8[%64] : memref<?xf32>
          %66 = arith.addf %63, %65 : f32
          %67 = memref.load %arg8[%57] : memref<?xf32>
          %68 = arith.addf %66, %67 : f32
          %69 = arith.addi %56, %53 : index
          %70 = memref.load %arg8[%69] : memref<?xf32>
          %71 = arith.addf %68, %70 : f32
          %72 = arith.mulf %71, %cst_0 : f32
          %73 = arith.mulf %72, %72 : f32
          %74 = arith.addf %62, %73 : f32
          %75 = math.sqrt %74 : f32
          %76 = arith.mulf %60, %75 : f32
          %77 = arith.mulf %76, %61 : f32
          memref.store %77, %arg9[%54] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      %23 = memref.load %9[%c0] : memref<1xi32>
      %24 = arith.index_cast %23 : i32 to index
      %25 = memref.load %6[%c0] : memref<1xi32>
      %26 = memref.load %3[%c0] : memref<1xi32>
      %27 = arith.index_cast %25 : i32 to index
      %28 = arith.index_cast %26 : i32 to index
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%24, %27) step (%c8, %c32) {
        %47 = affine.min #map2(%24, %arg19)
        %48 = affine.min #map3(%27, %arg20)
        scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%47, %48) step (%c1, %c1) {
          %49 = arith.addi %arg21, %arg19 : index
          %50 = arith.addi %arg22, %arg20 : index
          %51 = arith.muli %49, %28 : index
          %52 = arith.addi %49, %c-1 : index
          %53 = arith.muli %52, %28 : index
          %54 = arith.addi %50, %51 : index
          %55 = memref.load %arg18[%54] : memref<?xf32>
          %56 = arith.addi %50, %53 : index
          %57 = memref.load %arg18[%56] : memref<?xf32>
          %58 = arith.addf %55, %57 : f32
          %59 = arith.mulf %58, %cst : f32
          %60 = memref.load %arg8[%54] : memref<?xf32>
          %61 = arith.mulf %60, %60 : f32
          %62 = memref.load %arg7[%54] : memref<?xf32>
          %63 = arith.addi %50, %c1 : index
          %64 = arith.addi %63, %51 : index
          %65 = memref.load %arg7[%64] : memref<?xf32>
          %66 = arith.addf %62, %65 : f32
          %67 = memref.load %arg7[%56] : memref<?xf32>
          %68 = arith.addf %66, %67 : f32
          %69 = arith.addi %63, %53 : index
          %70 = memref.load %arg7[%69] : memref<?xf32>
          %71 = arith.addf %68, %70 : f32
          %72 = arith.mulf %71, %cst_0 : f32
          %73 = arith.mulf %72, %72 : f32
          %74 = arith.addf %61, %73 : f32
          %75 = math.sqrt %74 : f32
          %76 = arith.mulf %59, %75 : f32
          %77 = arith.mulf %76, %60 : f32
          memref.store %77, %arg10[%54] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      %29 = memref.load %9[%c0] : memref<1xi32>
      %30 = arith.index_cast %29 : i32 to index
      %31 = memref.load %6[%c0] : memref<1xi32>
      %32 = memref.load %3[%c0] : memref<1xi32>
      %33 = arith.index_cast %31 : i32 to index
      %34 = arith.index_cast %32 : i32 to index
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%30, %33) step (%c8, %c32) {
        %47 = affine.min #map2(%30, %arg19)
        %48 = affine.min #map3(%33, %arg20)
        scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%47, %48) step (%c1, %c1) {
          %49 = arith.addi %arg21, %arg19 : index
          %50 = arith.addi %arg22, %arg20 : index
          %51 = arith.muli %49, %34 : index
          %52 = arith.addi %49, %c1 : index
          %53 = arith.muli %52, %34 : index
          %54 = arith.addi %49, %c-1 : index
          %55 = arith.muli %54, %34 : index
          %56 = arith.addi %50, %51 : index
          %57 = arith.addi %50, %53 : index
          %58 = memref.load %arg6[%57] : memref<?xf32>
          %59 = memref.load %arg6[%56] : memref<?xf32>
          %60 = arith.addf %58, %59 : f32
          %61 = arith.addi %50, %c1 : index
          %62 = arith.addi %61, %51 : index
          %63 = memref.load %arg13[%62] : memref<?xf32>
          %64 = arith.addi %50, %c-1 : index
          %65 = arith.addi %64, %51 : index
          %66 = memref.load %arg13[%65] : memref<?xf32>
          %67 = arith.subf %63, %66 : f32
          %68 = arith.mulf %60, %67 : f32
          %69 = memref.load %arg5[%62] : memref<?xf32>
          %70 = memref.load %arg5[%56] : memref<?xf32>
          %71 = arith.addf %69, %70 : f32
          %72 = memref.load %arg12[%57] : memref<?xf32>
          %73 = arith.addi %50, %55 : index
          %74 = memref.load %arg12[%73] : memref<?xf32>
          %75 = arith.subf %72, %74 : f32
          %76 = arith.mulf %71, %75 : f32
          %77 = arith.subf %68, %76 : f32
          %78 = arith.mulf %77, %cst_0 : f32
          %79 = memref.load %arg12[%56] : memref<?xf32>
          %80 = memref.load %arg13[%56] : memref<?xf32>
          %81 = arith.mulf %79, %80 : f32
          %82 = arith.divf %78, %81 : f32
          memref.store %82, %arg0[%56] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      %35 = memref.load %9[%c0] : memref<1xi32>
      %36 = arith.index_cast %35 : i32 to index
      %37 = memref.load %6[%c0] : memref<1xi32>
      %38 = memref.load %3[%c0] : memref<1xi32>
      %39 = arith.index_cast %37 : i32 to index
      %40 = arith.index_cast %38 : i32 to index
      scf.parallel (%arg19, %arg20) = (%c1, %c2) to (%36, %39) step (%c8, %c32) {
        %47 = affine.min #map2(%36, %arg19)
        %48 = affine.min #map3(%39, %arg20)
        scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%47, %48) step (%c1, %c1) {
          %49 = arith.addi %arg21, %arg19 : index
          %50 = arith.addi %arg22, %arg20 : index
          %51 = arith.muli %49, %40 : index
          %52 = arith.addi %49, %c1 : index
          %53 = arith.muli %52, %40 : index
          %54 = arith.addi %50, %51 : index
          %55 = memref.load %arg1[%54] : memref<?xf32>
          %56 = memref.load %arg14[%54] : memref<?xf32>
          %57 = arith.mulf %56, %cst_0 : f32
          %58 = memref.load %arg0[%54] : memref<?xf32>
          %59 = memref.load %arg11[%54] : memref<?xf32>
          %60 = arith.mulf %58, %59 : f32
          %61 = arith.addi %50, %53 : index
          %62 = memref.load %arg6[%61] : memref<?xf32>
          %63 = memref.load %arg6[%54] : memref<?xf32>
          %64 = arith.addf %62, %63 : f32
          %65 = arith.mulf %60, %64 : f32
          %66 = arith.addi %50, %c-1 : index
          %67 = arith.addi %66, %51 : index
          %68 = memref.load %arg0[%67] : memref<?xf32>
          %69 = memref.load %arg11[%67] : memref<?xf32>
          %70 = arith.mulf %68, %69 : f32
          %71 = arith.addi %66, %53 : index
          %72 = memref.load %arg6[%71] : memref<?xf32>
          %73 = memref.load %arg6[%67] : memref<?xf32>
          %74 = arith.addf %72, %73 : f32
          %75 = arith.mulf %70, %74 : f32
          %76 = arith.addf %65, %75 : f32
          %77 = arith.mulf %57, %76 : f32
          %78 = arith.subf %55, %77 : f32
          memref.store %78, %arg1[%54] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      %41 = memref.load %9[%c0] : memref<1xi32>
      %42 = arith.index_cast %41 : i32 to index
      %43 = memref.load %6[%c0] : memref<1xi32>
      %44 = memref.load %3[%c0] : memref<1xi32>
      %45 = arith.index_cast %43 : i32 to index
      %46 = arith.index_cast %44 : i32 to index
      scf.parallel (%arg19, %arg20) = (%c2, %c1) to (%42, %45) step (%c8, %c32) {
        %47 = affine.min #map2(%42, %arg19)
        %48 = affine.min #map3(%45, %arg20)
        scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%47, %48) step (%c1, %c1) {
          %49 = arith.addi %arg21, %arg19 : index
          %50 = arith.addi %arg22, %arg20 : index
          %51 = arith.muli %49, %46 : index
          %52 = arith.addi %49, %c-1 : index
          %53 = arith.muli %52, %46 : index
          %54 = arith.addi %50, %51 : index
          %55 = memref.load %arg2[%54] : memref<?xf32>
          %56 = memref.load %arg15[%54] : memref<?xf32>
          %57 = arith.mulf %56, %cst_0 : f32
          %58 = memref.load %arg0[%54] : memref<?xf32>
          %59 = memref.load %arg11[%54] : memref<?xf32>
          %60 = arith.mulf %58, %59 : f32
          %61 = arith.addi %50, %c1 : index
          %62 = arith.addi %61, %51 : index
          %63 = memref.load %arg5[%62] : memref<?xf32>
          %64 = memref.load %arg5[%54] : memref<?xf32>
          %65 = arith.addf %63, %64 : f32
          %66 = arith.mulf %60, %65 : f32
          %67 = arith.addi %50, %53 : index
          %68 = memref.load %arg0[%67] : memref<?xf32>
          %69 = memref.load %arg11[%67] : memref<?xf32>
          %70 = arith.mulf %68, %69 : f32
          %71 = arith.addi %61, %53 : index
          %72 = memref.load %arg5[%71] : memref<?xf32>
          %73 = memref.load %arg5[%67] : memref<?xf32>
          %74 = arith.addf %72, %73 : f32
          %75 = arith.mulf %70, %74 : f32
          %76 = arith.addf %66, %75 : f32
          %77 = arith.mulf %57, %76 : f32
          %78 = arith.addf %55, %77 : f32
          memref.store %78, %arg2[%54] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    }
    return
  }
}


#map = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_advq_(%arg0: memref<?xf32> {polygeist.name = "qb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "qf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 5.000000e-01 : f32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 1.250000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20, %arg21) = (%c1, %c1, %c1) to (%2, %7, %8) step (%c2, %c4, %c32) {
      %25 = affine.min #map(%arg19)[%2]
      %26 = affine.min #map1(%arg20)[%7]
      %27 = affine.min #map2(%arg21)[%8]
      scf.parallel (%arg22, %arg23, %arg24) = (%c0, %c0, %c0) to (%25, %26, %27) step (%c1, %c1, %c1) {
        %28 = arith.addi %arg22, %arg19 : index
        %29 = arith.addi %arg23, %arg20 : index
        %30 = arith.addi %arg24, %arg21 : index
        %31 = memref.load %reinterpret_cast[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %32 = arith.muli %29, %8 overflow<nsw> : index
        %33 = arith.addi %30, %32 : index
        %34 = arith.muli %28, %8 overflow<nsw> : index
        %35 = arith.muli %34, %7 overflow<nsw> : index
        %36 = arith.addi %33, %35 : index
        %37 = arith.addi %36, %c-1 : index
        %38 = memref.load %arg1[%37] : memref<?xf32>
        %39 = arith.addf %31, %38 : f32
        %40 = arith.mulf %39, %cst_1 : f32
        %41 = memref.load %reinterpret_cast_8[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %42 = arith.addi %33, %c-1 : index
        %43 = memref.load %arg5[%42] : memref<?xf32>
        %44 = arith.addf %41, %43 : f32
        %45 = arith.mulf %40, %44 : f32
        %46 = memref.load %reinterpret_cast_2[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %47 = arith.addi %28, %c-1 : index
        %48 = memref.load %reinterpret_cast_2[%47, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %49 = arith.addf %46, %48 : f32
        %50 = arith.mulf %45, %49 : f32
        memref.store %50, %reinterpret_cast_3[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %51 = memref.load %reinterpret_cast[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %52 = arith.addi %29, %c-1 : index
        %53 = memref.load %reinterpret_cast[%28, %52, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %54 = arith.addf %51, %53 : f32
        %55 = arith.mulf %54, %cst_1 : f32
        %56 = memref.load %reinterpret_cast_8[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %57 = memref.load %reinterpret_cast_8[%52, %30] : memref<?x?xf32, strided<[?, 1]>>
        %58 = arith.addf %56, %57 : f32
        %59 = arith.mulf %55, %58 : f32
        %60 = memref.load %reinterpret_cast_4[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %61 = memref.load %reinterpret_cast_4[%47, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %62 = arith.addf %60, %61 : f32
        %63 = arith.mulf %59, %62 : f32
        memref.store %63, %reinterpret_cast_5[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %64 = memref.load %reinterpret_cast_9[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %65 = arith.mulf %64, %cst_0 : f32
        %66 = memref.load %reinterpret_cast_6[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %67 = memref.load %arg8[%37] : memref<?xf32>
        %68 = arith.addf %66, %67 : f32
        %69 = memref.load %reinterpret_cast_6[%47, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %70 = arith.addf %68, %69 : f32
        %71 = arith.muli %47, %8 overflow<nsw> : index
        %72 = arith.muli %71, %7 overflow<nsw> : index
        %73 = arith.addi %33, %72 : index
        %74 = arith.addi %73, %c-1 : index
        %75 = memref.load %arg8[%74] : memref<?xf32>
        %76 = arith.addf %70, %75 : f32
        %77 = arith.mulf %65, %76 : f32
        %78 = memref.load %reinterpret_cast_10[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %79 = memref.load %arg9[%42] : memref<?xf32>
        %80 = arith.addf %78, %79 : f32
        %81 = arith.mulf %77, %80 : f32
        %82 = memref.load %reinterpret_cast_7[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %83 = memref.load %arg0[%37] : memref<?xf32>
        %84 = arith.subf %82, %83 : f32
        %85 = arith.mulf %81, %84 : f32
        %86 = memref.load %reinterpret_cast_11[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %87 = memref.load %arg11[%42] : memref<?xf32>
        %88 = arith.addf %86, %87 : f32
        %89 = arith.divf %85, %88 : f32
        %90 = memref.load %reinterpret_cast_3[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %91 = arith.subf %90, %89 : f32
        memref.store %91, %reinterpret_cast_3[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %92 = memref.load %reinterpret_cast_12[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %93 = arith.mulf %92, %cst_0 : f32
        %94 = memref.load %reinterpret_cast_6[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %95 = memref.load %reinterpret_cast_6[%28, %52, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %96 = arith.addf %94, %95 : f32
        %97 = memref.load %reinterpret_cast_6[%47, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %98 = arith.addf %96, %97 : f32
        %99 = memref.load %reinterpret_cast_6[%47, %52, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %100 = arith.addf %98, %99 : f32
        %101 = arith.mulf %93, %100 : f32
        %102 = memref.load %reinterpret_cast_10[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %103 = memref.load %reinterpret_cast_10[%52, %30] : memref<?x?xf32, strided<[?, 1]>>
        %104 = arith.addf %102, %103 : f32
        %105 = arith.mulf %101, %104 : f32
        %106 = memref.load %reinterpret_cast_7[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %107 = memref.load %reinterpret_cast_7[%28, %52, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %108 = arith.subf %106, %107 : f32
        %109 = arith.mulf %105, %108 : f32
        %110 = memref.load %reinterpret_cast_13[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %111 = memref.load %reinterpret_cast_13[%52, %30] : memref<?x?xf32, strided<[?, 1]>>
        %112 = arith.addf %110, %111 : f32
        %113 = arith.divf %109, %112 : f32
        %114 = memref.load %reinterpret_cast_5[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %115 = arith.subf %114, %113 : f32
        memref.store %115, %reinterpret_cast_5[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %116 = memref.load %reinterpret_cast_13[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %117 = memref.load %arg13[%42] : memref<?xf32>
        %118 = arith.addf %116, %117 : f32
        %119 = arith.mulf %118, %cst : f32
        %120 = memref.load %reinterpret_cast_3[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %121 = arith.mulf %120, %119 : f32
        memref.store %121, %reinterpret_cast_3[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %122 = memref.load %reinterpret_cast_11[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %123 = memref.load %reinterpret_cast_11[%52, %30] : memref<?x?xf32, strided<[?, 1]>>
        %124 = arith.addf %122, %123 : f32
        %125 = arith.mulf %124, %cst : f32
        %126 = memref.load %reinterpret_cast_5[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %127 = arith.mulf %126, %125 : f32
        memref.store %127, %reinterpret_cast_5[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %10 = memref.load %0[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @jmm1 : memref<1xi32>
    %13 = memref.get_global @imm1 : memref<1xi32>
    %14 = memref.get_global @dti2 : memref<1xf32>
    %15 = memref.load %12[%c0] : memref<1xi32>
    %16 = memref.load %13[%c0] : memref<1xi32>
    %17 = memref.load %4[%c0] : memref<1xi32>
    %18 = memref.load %3[%c0] : memref<1xi32>
    %19 = memref.load %14[%c0] : memref<1xf32>
    %20 = arith.index_cast %15 : i32 to index
    %21 = arith.index_cast %16 : i32 to index
    %22 = arith.index_cast %17 : i32 to index
    %23 = arith.index_cast %18 : i32 to index
    %24 = arith.muli %22, %23 : index
    %reinterpret_cast_14 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20, %arg21) = (%c1, %c1, %c1) to (%11, %20, %21) step (%c2, %c4, %c32) {
      %25 = affine.min #map(%arg19)[%11]
      %26 = affine.min #map1(%arg20)[%20]
      %27 = affine.min #map2(%arg21)[%21]
      scf.parallel (%arg22, %arg23, %arg24) = (%c0, %c0, %c0) to (%25, %26, %27) step (%c1, %c1, %c1) {
        %28 = arith.addi %arg22, %arg19 : index
        %29 = arith.addi %arg23, %arg20 : index
        %30 = arith.addi %arg24, %arg21 : index
        %31 = memref.load %arg15[%28] : memref<?xf32>
        %32 = arith.addi %28, %c-1 : index
        %33 = memref.load %arg15[%32] : memref<?xf32>
        %34 = arith.addf %31, %33 : f32
        %35 = memref.load %reinterpret_cast_14[%32, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %36 = memref.load %reinterpret_cast_15[%32, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %37 = arith.mulf %35, %36 : f32
        %38 = arith.addi %28, %c1 : index
        %39 = memref.load %reinterpret_cast_14[%38, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %40 = memref.load %reinterpret_cast_15[%38, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = arith.mulf %39, %40 : f32
        %42 = arith.subf %37, %41 : f32
        %43 = memref.load %reinterpret_cast_20[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %44 = arith.mulf %42, %43 : f32
        %45 = arith.divf %44, %34 : f32
        %46 = arith.muli %29, %22 overflow<nsw> : index
        %47 = arith.addi %30, %46 : index
        %48 = arith.muli %28, %22 overflow<nsw> : index
        %49 = arith.muli %48, %23 overflow<nsw> : index
        %50 = arith.addi %47, %49 : index
        %51 = arith.addi %50, %c1 : index
        %52 = memref.load %arg3[%51] : memref<?xf32>
        %53 = arith.addf %45, %52 : f32
        %54 = memref.load %reinterpret_cast_16[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %55 = arith.subf %53, %54 : f32
        %56 = arith.addi %29, %c1 : index
        %57 = memref.load %reinterpret_cast_17[%28, %56, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %58 = arith.addf %55, %57 : f32
        %59 = memref.load %reinterpret_cast_17[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %60 = arith.subf %58, %59 : f32
        memref.store %60, %reinterpret_cast_18[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %61 = memref.load %reinterpret_cast_21[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %62 = memref.load %reinterpret_cast_22[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %63 = arith.addf %61, %62 : f32
        %64 = memref.load %reinterpret_cast_20[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %65 = arith.mulf %63, %64 : f32
        %66 = memref.load %reinterpret_cast_19[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %67 = arith.mulf %65, %66 : f32
        %68 = arith.mulf %19, %60 : f32
        %69 = arith.subf %67, %68 : f32
        %70 = memref.load %reinterpret_cast_23[%29, %30] : memref<?x?xf32, strided<[?, 1]>>
        %71 = arith.addf %61, %70 : f32
        %72 = arith.mulf %71, %64 : f32
        %73 = arith.divf %69, %72 : f32
        memref.store %73, %reinterpret_cast_18[%28, %29, %30] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


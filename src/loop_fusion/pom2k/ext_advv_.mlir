#map = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map3 = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advv_(%arg0: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advy", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c8 = arith.constant 8 : index
    %c32 = arith.constant 32 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 1.250000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %cst_2 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c2, %c4, %c32) {
      %32 = affine.min #map(%arg18)[%2]
      %33 = affine.min #map1(%arg19)[%7]
      %34 = affine.min #map2(%arg20)[%8]
      scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%32, %33, %34) step (%c1, %c1, %c1) {
        %35 = arith.addi %arg21, %arg18 : index
        %36 = arith.addi %arg22, %arg19 : index
        %37 = arith.addi %arg23, %arg20 : index
        memref.store %cst_2, %reinterpret_cast[%35, %36, %37] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c1, %c0) to (%11, %7, %8) step (%c2, %c4, %c32) {
      %32 = affine.min #map(%arg18)[%11]
      %33 = affine.min #map1(%arg19)[%7]
      %34 = affine.min #map2(%arg20)[%8]
      scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%32, %33, %34) step (%c1, %c1, %c1) {
        %35 = arith.addi %arg21, %arg18 : index
        %36 = arith.addi %arg22, %arg19 : index
        %37 = arith.addi %arg23, %arg20 : index
        %38 = memref.load %reinterpret_cast_3[%35, %36, %37] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %39 = arith.addi %36, %c-1 : index
        %40 = memref.load %reinterpret_cast_3[%35, %39, %37] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = arith.addf %38, %40 : f32
        %42 = arith.mulf %41, %cst_1 : f32
        %43 = memref.load %reinterpret_cast_4[%35, %36, %37] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %44 = arith.addi %35, %c-1 : index
        %45 = memref.load %reinterpret_cast_4[%44, %36, %37] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %46 = arith.addf %43, %45 : f32
        %47 = arith.mulf %42, %46 : f32
        memref.store %47, %reinterpret_cast_5[%35, %36, %37] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %13 = memref.load %9[%c0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = memref.get_global @jmm1 : memref<1xi32>
    %16 = memref.get_global @imm1 : memref<1xi32>
    %17 = memref.get_global @grav : memref<1xf32>
    %18 = memref.load %15[%c0] : memref<1xi32>
    %19 = memref.load %16[%c0] : memref<1xi32>
    %20 = memref.load %4[%c0] : memref<1xi32>
    %21 = memref.load %3[%c0] : memref<1xi32>
    %22 = memref.load %17[%c0] : memref<1xf32>
    %23 = arith.index_cast %18 : i32 to index
    %24 = arith.index_cast %19 : i32 to index
    %25 = arith.index_cast %20 : i32 to index
    %26 = arith.index_cast %21 : i32 to index
    %27 = arith.mulf %22, %cst_0 : f32
    %28 = arith.muli %25, %26 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%14, %26, %25], strides: [%28, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%14, %26, %25], strides: [%28, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%14, %26, %25], strides: [%28, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%14, %26, %25], strides: [%28, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %29 = memref.get_global @dti2 : memref<1xf32>
    %30 = memref.load %29[%c0] : memref<1xf32>
    %31 = arith.mulf %30, %cst : f32
    %reinterpret_cast_10 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%14, %26, %25], strides: [%28, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%23, %24) step (%c8, %c32) {
      %32 = affine.min #map3(%arg18)[%23]
      %33 = affine.min #map2(%arg19)[%24]
      scf.parallel (%arg20, %arg21) = (%c0, %c0) to (%32, %33) step (%c1, %c1) {
        %34 = arith.addi %arg20, %arg18 : index
        %35 = arith.addi %arg21, %arg19 : index
        scf.for %arg22 = %c0 to %14 step %c1 {
          %36 = memref.load %arg8[%arg22] : memref<?xf32>
          %37 = memref.load %reinterpret_cast_6[%arg22, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %38 = memref.load %reinterpret_cast_7[%arg22, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %39 = arith.addi %arg22, %c1 : index
          %40 = memref.load %reinterpret_cast_7[%39, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %41 = arith.subf %38, %40 : f32
          %42 = memref.load %reinterpret_cast_11[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %43 = arith.mulf %41, %42 : f32
          %44 = arith.divf %43, %36 : f32
          %45 = arith.addf %37, %44 : f32
          %46 = arith.mulf %42, %cst_1 : f32
          %47 = memref.load %reinterpret_cast_12[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %48 = memref.load %reinterpret_cast_13[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %49 = arith.mulf %47, %48 : f32
          %50 = arith.muli %34, %25 overflow<nsw> : index
          %51 = arith.addi %35, %50 : index
          %52 = arith.muli %arg22, %25 overflow<nsw> : index
          %53 = arith.muli %52, %26 overflow<nsw> : index
          %54 = arith.addi %51, %53 : index
          %55 = arith.addi %54, %c1 : index
          %56 = memref.load %arg3[%55] : memref<?xf32>
          %57 = memref.load %reinterpret_cast_8[%arg22, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %58 = arith.addf %56, %57 : f32
          %59 = arith.mulf %49, %58 : f32
          %60 = arith.addi %34, %c-1 : index
          %61 = memref.load %reinterpret_cast_12[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %62 = memref.load %reinterpret_cast_13[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %63 = arith.mulf %61, %62 : f32
          %64 = arith.muli %60, %25 overflow<nsw> : index
          %65 = arith.addi %35, %64 : index
          %66 = arith.addi %65, %53 : index
          %67 = arith.addi %66, %c1 : index
          %68 = memref.load %arg3[%67] : memref<?xf32>
          %69 = memref.load %reinterpret_cast_8[%arg22, %60, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %70 = arith.addf %68, %69 : f32
          %71 = arith.mulf %63, %70 : f32
          %72 = arith.addf %59, %71 : f32
          %73 = arith.mulf %46, %72 : f32
          %74 = arith.addf %45, %73 : f32
          %75 = arith.addf %48, %62 : f32
          %76 = arith.mulf %27, %75 : f32
          %77 = memref.load %reinterpret_cast_14[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %78 = memref.load %reinterpret_cast_14[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %79 = arith.subf %77, %78 : f32
          %80 = memref.load %reinterpret_cast_15[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %81 = arith.addf %79, %80 : f32
          %82 = memref.load %reinterpret_cast_15[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %83 = arith.subf %81, %82 : f32
          %84 = memref.load %reinterpret_cast_16[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %85 = memref.load %reinterpret_cast_16[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %86 = arith.subf %84, %85 : f32
          %87 = arith.mulf %86, %cst : f32
          %88 = arith.addf %83, %87 : f32
          %89 = arith.mulf %76, %88 : f32
          %90 = memref.load %reinterpret_cast_17[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %91 = memref.load %reinterpret_cast_17[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %92 = arith.addf %90, %91 : f32
          %93 = arith.mulf %89, %92 : f32
          %94 = arith.addf %74, %93 : f32
          %95 = memref.load %reinterpret_cast_9[%arg22, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %96 = arith.addf %94, %95 : f32
          memref.store %96, %reinterpret_cast_7[%arg22, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %97 = memref.load %reinterpret_cast_18[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %98 = memref.load %reinterpret_cast_19[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %99 = arith.addf %97, %98 : f32
          %100 = memref.load %reinterpret_cast_18[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %101 = arith.addf %99, %100 : f32
          %102 = memref.load %reinterpret_cast_19[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %103 = arith.addf %101, %102 : f32
          %104 = memref.load %reinterpret_cast_11[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %105 = arith.mulf %103, %104 : f32
          %106 = memref.load %reinterpret_cast_10[%arg22, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %107 = arith.mulf %105, %106 : f32
          %108 = arith.mulf %31, %96 : f32
          %109 = arith.subf %107, %108 : f32
          %110 = memref.load %reinterpret_cast_20[%34, %35] : memref<?x?xf32, strided<[?, 1]>>
          %111 = arith.addf %97, %110 : f32
          %112 = arith.addf %111, %100 : f32
          %113 = memref.load %reinterpret_cast_20[%60, %35] : memref<?x?xf32, strided<[?, 1]>>
          %114 = arith.addf %112, %113 : f32
          %115 = arith.mulf %114, %104 : f32
          %116 = arith.divf %109, %115 : f32
          memref.store %116, %reinterpret_cast_7[%arg22, %34, %35] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


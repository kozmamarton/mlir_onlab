#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_vaf_(%arg0: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dry2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 4.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @alpha : memref<1xf32>
    %7 = memref.load %3[%c0] : memref<1xi32>
    %8 = memref.load %4[%c0] : memref<1xi32>
    %9 = memref.load %5[%c0] : memref<1xf32>
    %10 = memref.load %6[%c0] : memref<1xf32>
    %11 = arith.index_cast %7 : i32 to index
    %12 = arith.index_cast %8 : i32 to index
    %13 = arith.mulf %9, %cst_2 : f32
    %14 = arith.mulf %10, %cst_0 : f32
    %15 = arith.subf %cst_1, %14 : f32
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %16 = memref.get_global @dte : memref<1xf32>
    %17 = memref.load %16[%c0] : memref<1xf32>
    %18 = arith.mulf %17, %cst : f32
    %reinterpret_cast_17 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%2, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18) = (%c1, %c1) to (%2, %11) step (%c8, %c32) {
      %19 = affine.min #map(%arg17)[%2]
      %20 = affine.min #map1(%arg18)[%11]
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%19, %20) step (%c1, %c1) {
        %21 = arith.addi %arg19, %arg17 : index
        %22 = arith.addi %arg20, %arg18 : index
        %23 = memref.load %reinterpret_cast[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %24 = memref.load %reinterpret_cast_3[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %25 = arith.addf %23, %24 : f32
        %26 = memref.load %reinterpret_cast_4[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %27 = arith.mulf %26, %cst_2 : f32
        %28 = memref.load %reinterpret_cast_5[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %29 = memref.load %reinterpret_cast_6[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %30 = arith.mulf %28, %29 : f32
        %31 = arith.muli %21, %12 overflow<nsw> : index
        %32 = arith.addi %22, %31 : index
        %33 = arith.addi %32, %c1 : index
        %34 = memref.load %arg6[%33] : memref<?xf32>
        %35 = memref.load %reinterpret_cast_7[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %36 = arith.addf %34, %35 : f32
        %37 = arith.mulf %30, %36 : f32
        %38 = arith.addi %21, %c-1 : index
        %39 = memref.load %reinterpret_cast_5[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %40 = memref.load %reinterpret_cast_6[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %41 = arith.mulf %39, %40 : f32
        %42 = arith.muli %38, %12 overflow<nsw> : index
        %43 = arith.addi %22, %42 : index
        %44 = arith.addi %43, %c1 : index
        %45 = memref.load %arg6[%44] : memref<?xf32>
        %46 = memref.load %reinterpret_cast_7[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %47 = arith.addf %45, %46 : f32
        %48 = arith.mulf %41, %47 : f32
        %49 = arith.addf %37, %48 : f32
        %50 = arith.mulf %27, %49 : f32
        %51 = arith.addf %25, %50 : f32
        %52 = memref.load %reinterpret_cast_8[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %53 = memref.load %reinterpret_cast_8[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %54 = arith.addf %52, %53 : f32
        %55 = arith.mulf %13, %54 : f32
        %56 = arith.addf %29, %40 : f32
        %57 = arith.mulf %55, %56 : f32
        %58 = memref.load %reinterpret_cast_9[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %59 = memref.load %reinterpret_cast_9[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %60 = arith.subf %58, %59 : f32
        %61 = arith.mulf %15, %60 : f32
        %62 = memref.load %reinterpret_cast_10[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %63 = memref.load %reinterpret_cast_10[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %64 = arith.subf %62, %63 : f32
        %65 = memref.load %reinterpret_cast_11[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %66 = arith.addf %64, %65 : f32
        %67 = memref.load %reinterpret_cast_11[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %68 = arith.subf %66, %67 : f32
        %69 = arith.mulf %10, %68 : f32
        %70 = arith.addf %61, %69 : f32
        %71 = memref.load %reinterpret_cast_12[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %72 = arith.addf %70, %71 : f32
        %73 = memref.load %reinterpret_cast_12[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %74 = arith.subf %72, %73 : f32
        %75 = arith.mulf %57, %74 : f32
        %76 = arith.addf %51, %75 : f32
        %77 = memref.load %reinterpret_cast_13[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %78 = arith.addf %76, %77 : f32
        %79 = memref.load %reinterpret_cast_14[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %80 = memref.load %reinterpret_cast_15[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %81 = arith.subf %79, %80 : f32
        %82 = arith.mulf %26, %81 : f32
        %83 = arith.addf %78, %82 : f32
        memref.store %83, %reinterpret_cast_16[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %84 = memref.load %reinterpret_cast_17[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %85 = memref.load %reinterpret_cast_10[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %86 = arith.addf %84, %85 : f32
        %87 = memref.load %reinterpret_cast_17[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %88 = arith.addf %86, %87 : f32
        %89 = memref.load %reinterpret_cast_10[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %90 = arith.addf %88, %89 : f32
        %91 = memref.load %reinterpret_cast_18[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %92 = arith.mulf %90, %91 : f32
        %93 = memref.load %reinterpret_cast_4[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %94 = arith.mulf %92, %93 : f32
        %95 = arith.mulf %18, %83 : f32
        %96 = arith.subf %94, %95 : f32
        %97 = memref.load %reinterpret_cast_11[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        %98 = arith.addf %84, %97 : f32
        %99 = arith.addf %98, %87 : f32
        %100 = memref.load %reinterpret_cast_11[%38, %22] : memref<?x?xf32, strided<[?, 1]>>
        %101 = arith.addf %99, %100 : f32
        %102 = arith.mulf %101, %93 : f32
        %103 = arith.divf %96, %102 : f32
        memref.store %103, %reinterpret_cast_16[%21, %22] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


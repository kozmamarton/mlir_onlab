#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_uaf_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "drx2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 4.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @grav : memref<1xf32>
    %5 = memref.get_global @alpha : memref<1xf32>
    %6 = memref.load %3[%c0] : memref<1xi32>
    %7 = memref.load %4[%c0] : memref<1xf32>
    %8 = memref.load %5[%c0] : memref<1xf32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.mulf %7, %cst_2 : f32
    %11 = arith.mulf %8, %cst_0 : f32
    %12 = arith.subf %cst_1, %11 : f32
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %13 = memref.get_global @dte : memref<1xf32>
    %14 = memref.load %13[%c0] : memref<1xf32>
    %15 = arith.mulf %14, %cst : f32
    %reinterpret_cast_17 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%2, %9], strides: [%9, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18) = (%c1, %c1) to (%2, %9) step (%c8, %c32) {
      %16 = affine.min #map(%arg17)[%2]
      %17 = affine.min #map1(%arg18)[%9]
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%16, %17) step (%c1, %c1) {
        %18 = arith.addi %arg19, %arg17 : index
        %19 = arith.addi %arg20, %arg18 : index
        %20 = memref.load %reinterpret_cast[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %21 = memref.load %reinterpret_cast_3[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %22 = arith.addf %20, %21 : f32
        %23 = memref.load %reinterpret_cast_4[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %24 = arith.mulf %23, %cst_2 : f32
        %25 = memref.load %reinterpret_cast_5[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %26 = memref.load %reinterpret_cast_6[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %27 = arith.mulf %25, %26 : f32
        %28 = arith.addi %18, %c1 : index
        %29 = memref.load %reinterpret_cast_7[%28, %19] : memref<?x?xf32, strided<[?, 1]>>
        %30 = memref.load %reinterpret_cast_7[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %31 = arith.addf %29, %30 : f32
        %32 = arith.mulf %27, %31 : f32
        %33 = arith.muli %18, %9 overflow<nsw> : index
        %34 = arith.addi %19, %33 : index
        %35 = arith.addi %34, %c-1 : index
        %36 = memref.load %arg4[%35] : memref<?xf32>
        %37 = memref.load %arg5[%35] : memref<?xf32>
        %38 = arith.mulf %36, %37 : f32
        %39 = arith.muli %28, %9 overflow<nsw> : index
        %40 = arith.addi %19, %39 : index
        %41 = arith.addi %40, %c-1 : index
        %42 = memref.load %arg6[%41] : memref<?xf32>
        %43 = memref.load %arg6[%35] : memref<?xf32>
        %44 = arith.addf %42, %43 : f32
        %45 = arith.mulf %38, %44 : f32
        %46 = arith.addf %32, %45 : f32
        %47 = arith.mulf %24, %46 : f32
        %48 = arith.subf %22, %47 : f32
        %49 = memref.load %reinterpret_cast_8[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %50 = memref.load %arg7[%35] : memref<?xf32>
        %51 = arith.addf %49, %50 : f32
        %52 = arith.mulf %10, %51 : f32
        %53 = arith.addf %26, %37 : f32
        %54 = arith.mulf %52, %53 : f32
        %55 = memref.load %reinterpret_cast_9[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %56 = memref.load %arg8[%35] : memref<?xf32>
        %57 = arith.subf %55, %56 : f32
        %58 = arith.mulf %12, %57 : f32
        %59 = memref.load %reinterpret_cast_10[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %60 = memref.load %arg9[%35] : memref<?xf32>
        %61 = arith.subf %59, %60 : f32
        %62 = memref.load %reinterpret_cast_11[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %63 = arith.addf %61, %62 : f32
        %64 = memref.load %arg10[%35] : memref<?xf32>
        %65 = arith.subf %63, %64 : f32
        %66 = arith.mulf %8, %65 : f32
        %67 = arith.addf %58, %66 : f32
        %68 = memref.load %reinterpret_cast_12[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %69 = arith.addf %67, %68 : f32
        %70 = memref.load %arg11[%35] : memref<?xf32>
        %71 = arith.subf %69, %70 : f32
        %72 = arith.mulf %54, %71 : f32
        %73 = arith.addf %48, %72 : f32
        %74 = memref.load %reinterpret_cast_13[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %75 = arith.addf %73, %74 : f32
        %76 = memref.load %reinterpret_cast_14[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %77 = memref.load %reinterpret_cast_15[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %78 = arith.subf %76, %77 : f32
        %79 = arith.mulf %23, %78 : f32
        %80 = arith.addf %75, %79 : f32
        memref.store %80, %reinterpret_cast_16[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %81 = memref.load %reinterpret_cast_17[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %82 = memref.load %reinterpret_cast_10[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %83 = arith.addf %81, %82 : f32
        %84 = memref.load %arg15[%35] : memref<?xf32>
        %85 = arith.addf %83, %84 : f32
        %86 = memref.load %arg9[%35] : memref<?xf32>
        %87 = arith.addf %85, %86 : f32
        %88 = memref.load %reinterpret_cast_4[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %89 = arith.mulf %87, %88 : f32
        %90 = memref.load %reinterpret_cast_18[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %91 = arith.mulf %89, %90 : f32
        %92 = arith.mulf %15, %80 : f32
        %93 = arith.subf %91, %92 : f32
        %94 = memref.load %reinterpret_cast_11[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        %95 = arith.addf %81, %94 : f32
        %96 = arith.addf %95, %84 : f32
        %97 = memref.load %arg10[%35] : memref<?xf32>
        %98 = arith.addf %96, %97 : f32
        %99 = arith.mulf %98, %88 : f32
        %100 = arith.divf %93, %99 : f32
        memref.store %100, %reinterpret_cast_16[%18, %19] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


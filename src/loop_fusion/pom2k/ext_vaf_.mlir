module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_vaf_(%arg0: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dry2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
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
    scf.parallel (%arg17, %arg18) = (%c1, %c1) to (%2, %11) step (%c1, %c1) {
      %19 = memref.load %reinterpret_cast[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %20 = memref.load %reinterpret_cast_3[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %21 = arith.addf %19, %20 : f32
      %22 = memref.load %reinterpret_cast_4[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %23 = arith.mulf %22, %cst_2 : f32
      %24 = memref.load %reinterpret_cast_5[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %25 = memref.load %reinterpret_cast_6[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %26 = arith.mulf %24, %25 : f32
      %27 = arith.muli %arg17, %12 overflow<nsw> : index
      %28 = arith.addi %arg18, %27 : index
      %29 = arith.addi %28, %c1 : index
      %30 = memref.load %arg6[%29] : memref<?xf32>
      %31 = memref.load %reinterpret_cast_7[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.addf %30, %31 : f32
      %33 = arith.mulf %26, %32 : f32
      %34 = arith.addi %arg17, %c-1 : index
      %35 = memref.load %reinterpret_cast_5[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %36 = memref.load %reinterpret_cast_6[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %37 = arith.mulf %35, %36 : f32
      %38 = arith.muli %34, %12 overflow<nsw> : index
      %39 = arith.addi %arg18, %38 : index
      %40 = arith.addi %39, %c1 : index
      %41 = memref.load %arg6[%40] : memref<?xf32>
      %42 = memref.load %reinterpret_cast_7[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %43 = arith.addf %41, %42 : f32
      %44 = arith.mulf %37, %43 : f32
      %45 = arith.addf %33, %44 : f32
      %46 = arith.mulf %23, %45 : f32
      %47 = arith.addf %21, %46 : f32
      %48 = memref.load %reinterpret_cast_8[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %49 = memref.load %reinterpret_cast_8[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %50 = arith.addf %48, %49 : f32
      %51 = arith.mulf %13, %50 : f32
      %52 = arith.addf %25, %36 : f32
      %53 = arith.mulf %51, %52 : f32
      %54 = memref.load %reinterpret_cast_9[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %55 = memref.load %reinterpret_cast_9[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %56 = arith.subf %54, %55 : f32
      %57 = arith.mulf %15, %56 : f32
      %58 = memref.load %reinterpret_cast_10[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %59 = memref.load %reinterpret_cast_10[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %60 = arith.subf %58, %59 : f32
      %61 = memref.load %reinterpret_cast_11[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %62 = arith.addf %60, %61 : f32
      %63 = memref.load %reinterpret_cast_11[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %64 = arith.subf %62, %63 : f32
      %65 = arith.mulf %10, %64 : f32
      %66 = arith.addf %57, %65 : f32
      %67 = memref.load %reinterpret_cast_12[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.addf %66, %67 : f32
      %69 = memref.load %reinterpret_cast_12[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %70 = arith.subf %68, %69 : f32
      %71 = arith.mulf %53, %70 : f32
      %72 = arith.addf %47, %71 : f32
      %73 = memref.load %reinterpret_cast_13[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %74 = arith.addf %72, %73 : f32
      %75 = memref.load %reinterpret_cast_14[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %76 = memref.load %reinterpret_cast_15[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %77 = arith.subf %75, %76 : f32
      %78 = arith.mulf %22, %77 : f32
      %79 = arith.addf %74, %78 : f32
      memref.store %79, %reinterpret_cast_16[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %80 = memref.load %reinterpret_cast_17[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %81 = memref.load %reinterpret_cast_10[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %82 = arith.addf %80, %81 : f32
      %83 = memref.load %reinterpret_cast_17[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %84 = arith.addf %82, %83 : f32
      %85 = memref.load %reinterpret_cast_10[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %86 = arith.addf %84, %85 : f32
      %87 = memref.load %reinterpret_cast_18[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %88 = arith.mulf %86, %87 : f32
      %89 = memref.load %reinterpret_cast_4[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %90 = arith.mulf %88, %89 : f32
      %91 = arith.mulf %18, %79 : f32
      %92 = arith.subf %90, %91 : f32
      %93 = memref.load %reinterpret_cast_11[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %94 = arith.addf %80, %93 : f32
      %95 = arith.addf %94, %83 : f32
      %96 = memref.load %reinterpret_cast_11[%34, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %97 = arith.addf %95, %96 : f32
      %98 = arith.mulf %97, %89 : f32
      %99 = arith.divf %92, %98 : f32
      memref.store %99, %reinterpret_cast_16[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


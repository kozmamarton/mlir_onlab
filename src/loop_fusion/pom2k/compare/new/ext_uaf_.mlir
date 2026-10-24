module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_uaf_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "drx2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
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
    scf.parallel (%arg17, %arg18) = (%c1, %c1) to (%2, %9) step (%c1, %c1) {
      %16 = memref.load %reinterpret_cast[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %17 = memref.load %reinterpret_cast_3[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %18 = arith.addf %16, %17 : f32
      %19 = memref.load %reinterpret_cast_4[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %20 = arith.mulf %19, %cst_2 : f32
      %21 = memref.load %reinterpret_cast_5[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %22 = memref.load %reinterpret_cast_6[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %23 = arith.mulf %21, %22 : f32
      %24 = arith.addi %arg17, %c1 : index
      %25 = memref.load %reinterpret_cast_7[%24, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %26 = memref.load %reinterpret_cast_7[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %27 = arith.addf %25, %26 : f32
      %28 = arith.mulf %23, %27 : f32
      %29 = arith.muli %arg17, %9 overflow<nsw> : index
      %30 = arith.addi %arg18, %29 : index
      %31 = arith.addi %30, %c-1 : index
      %32 = memref.load %arg4[%31] : memref<?xf32>
      %33 = memref.load %arg5[%31] : memref<?xf32>
      %34 = arith.mulf %32, %33 : f32
      %35 = arith.muli %24, %9 overflow<nsw> : index
      %36 = arith.addi %arg18, %35 : index
      %37 = arith.addi %36, %c-1 : index
      %38 = memref.load %arg6[%37] : memref<?xf32>
      %39 = memref.load %arg6[%31] : memref<?xf32>
      %40 = arith.addf %38, %39 : f32
      %41 = arith.mulf %34, %40 : f32
      %42 = arith.addf %28, %41 : f32
      %43 = arith.mulf %20, %42 : f32
      %44 = arith.subf %18, %43 : f32
      %45 = memref.load %reinterpret_cast_8[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %46 = memref.load %arg7[%31] : memref<?xf32>
      %47 = arith.addf %45, %46 : f32
      %48 = arith.mulf %10, %47 : f32
      %49 = arith.addf %22, %33 : f32
      %50 = arith.mulf %48, %49 : f32
      %51 = memref.load %reinterpret_cast_9[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %52 = memref.load %arg8[%31] : memref<?xf32>
      %53 = arith.subf %51, %52 : f32
      %54 = arith.mulf %12, %53 : f32
      %55 = memref.load %reinterpret_cast_10[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %56 = memref.load %arg9[%31] : memref<?xf32>
      %57 = arith.subf %55, %56 : f32
      %58 = memref.load %reinterpret_cast_11[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %59 = arith.addf %57, %58 : f32
      %60 = memref.load %arg10[%31] : memref<?xf32>
      %61 = arith.subf %59, %60 : f32
      %62 = arith.mulf %8, %61 : f32
      %63 = arith.addf %54, %62 : f32
      %64 = memref.load %reinterpret_cast_12[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %65 = arith.addf %63, %64 : f32
      %66 = memref.load %arg11[%31] : memref<?xf32>
      %67 = arith.subf %65, %66 : f32
      %68 = arith.mulf %50, %67 : f32
      %69 = arith.addf %44, %68 : f32
      %70 = memref.load %reinterpret_cast_13[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.addf %69, %70 : f32
      %72 = memref.load %reinterpret_cast_14[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %73 = memref.load %reinterpret_cast_15[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %74 = arith.subf %72, %73 : f32
      %75 = arith.mulf %19, %74 : f32
      %76 = arith.addf %71, %75 : f32
      memref.store %76, %reinterpret_cast_16[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %77 = memref.load %reinterpret_cast_17[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %78 = memref.load %reinterpret_cast_10[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %79 = arith.addf %77, %78 : f32
      %80 = memref.load %arg15[%31] : memref<?xf32>
      %81 = arith.addf %79, %80 : f32
      %82 = memref.load %arg9[%31] : memref<?xf32>
      %83 = arith.addf %81, %82 : f32
      %84 = memref.load %reinterpret_cast_4[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %85 = arith.mulf %83, %84 : f32
      %86 = memref.load %reinterpret_cast_18[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %87 = arith.mulf %85, %86 : f32
      %88 = arith.mulf %15, %76 : f32
      %89 = arith.subf %87, %88 : f32
      %90 = memref.load %reinterpret_cast_11[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %91 = arith.addf %77, %90 : f32
      %92 = arith.addf %91, %80 : f32
      %93 = memref.load %arg10[%31] : memref<?xf32>
      %94 = arith.addf %92, %93 : f32
      %95 = arith.mulf %94, %84 : f32
      %96 = arith.divf %89, %95 : f32
      memref.store %96, %reinterpret_cast_16[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


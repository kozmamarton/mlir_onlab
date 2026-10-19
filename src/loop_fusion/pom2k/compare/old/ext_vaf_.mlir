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
    scf.parallel (%arg17, %arg18) = (%c1, %c1) to (%2, %11) step (%c1, %c1) {
      %25 = memref.load %reinterpret_cast[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %26 = memref.load %reinterpret_cast_3[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %27 = arith.addf %25, %26 : f32
      %28 = memref.load %reinterpret_cast_4[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %29 = arith.mulf %28, %cst_2 : f32
      %30 = memref.load %reinterpret_cast_5[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %31 = memref.load %reinterpret_cast_6[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.mulf %30, %31 : f32
      %33 = arith.muli %arg17, %12 overflow<nsw> : index
      %34 = arith.addi %arg18, %33 : index
      %35 = arith.addi %34, %c1 : index
      %36 = memref.load %arg6[%35] : memref<?xf32>
      %37 = memref.load %reinterpret_cast_7[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %38 = arith.addf %36, %37 : f32
      %39 = arith.mulf %32, %38 : f32
      %40 = arith.addi %arg17, %c-1 : index
      %41 = memref.load %reinterpret_cast_5[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %42 = memref.load %reinterpret_cast_6[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %43 = arith.mulf %41, %42 : f32
      %44 = arith.muli %40, %12 overflow<nsw> : index
      %45 = arith.addi %arg18, %44 : index
      %46 = arith.addi %45, %c1 : index
      %47 = memref.load %arg6[%46] : memref<?xf32>
      %48 = memref.load %reinterpret_cast_7[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %49 = arith.addf %47, %48 : f32
      %50 = arith.mulf %43, %49 : f32
      %51 = arith.addf %39, %50 : f32
      %52 = arith.mulf %29, %51 : f32
      %53 = arith.addf %27, %52 : f32
      %54 = memref.load %reinterpret_cast_8[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %55 = memref.load %reinterpret_cast_8[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %56 = arith.addf %54, %55 : f32
      %57 = arith.mulf %13, %56 : f32
      %58 = arith.addf %31, %42 : f32
      %59 = arith.mulf %57, %58 : f32
      %60 = memref.load %reinterpret_cast_9[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %61 = memref.load %reinterpret_cast_9[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %62 = arith.subf %60, %61 : f32
      %63 = arith.mulf %15, %62 : f32
      %64 = memref.load %reinterpret_cast_10[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %65 = memref.load %reinterpret_cast_10[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %66 = arith.subf %64, %65 : f32
      %67 = memref.load %reinterpret_cast_11[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.addf %66, %67 : f32
      %69 = memref.load %reinterpret_cast_11[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %70 = arith.subf %68, %69 : f32
      %71 = arith.mulf %10, %70 : f32
      %72 = arith.addf %63, %71 : f32
      %73 = memref.load %reinterpret_cast_12[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %74 = arith.addf %72, %73 : f32
      %75 = memref.load %reinterpret_cast_12[%40, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %76 = arith.subf %74, %75 : f32
      %77 = arith.mulf %59, %76 : f32
      %78 = arith.addf %53, %77 : f32
      %79 = memref.load %reinterpret_cast_13[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %80 = arith.addf %78, %79 : f32
      %81 = memref.load %reinterpret_cast_14[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %82 = memref.load %reinterpret_cast_15[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %83 = arith.subf %81, %82 : f32
      %84 = arith.mulf %28, %83 : f32
      %85 = arith.addf %80, %84 : f32
      memref.store %85, %reinterpret_cast_16[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %16 = memref.load %0[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @dte : memref<1xf32>
    %19 = memref.load %3[%c0] : memref<1xi32>
    %20 = memref.load %4[%c0] : memref<1xi32>
    %21 = memref.load %18[%c0] : memref<1xf32>
    %22 = arith.index_cast %19 : i32 to index
    %23 = arith.index_cast %20 : i32 to index
    %24 = arith.mulf %21, %cst : f32
    %reinterpret_cast_17 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%17, %23], strides: [%23, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%17, %23], strides: [%23, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%17, %23], strides: [%23, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%17, %23], strides: [%23, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%17, %23], strides: [%23, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%17, %23], strides: [%23, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18) = (%c1, %c1) to (%17, %22) step (%c1, %c1) {
      %25 = memref.load %reinterpret_cast_17[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %26 = memref.load %reinterpret_cast_18[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %27 = arith.addf %25, %26 : f32
      %28 = arith.addi %arg17, %c-1 : index
      %29 = memref.load %reinterpret_cast_17[%28, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.addf %27, %29 : f32
      %31 = memref.load %reinterpret_cast_18[%28, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.addf %30, %31 : f32
      %33 = memref.load %reinterpret_cast_19[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %34 = arith.mulf %32, %33 : f32
      %35 = memref.load %reinterpret_cast_20[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %36 = arith.mulf %34, %35 : f32
      %37 = memref.load %reinterpret_cast_21[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %38 = arith.mulf %24, %37 : f32
      %39 = arith.subf %36, %38 : f32
      %40 = memref.load %reinterpret_cast_22[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %41 = arith.addf %25, %40 : f32
      %42 = arith.addf %41, %29 : f32
      %43 = memref.load %reinterpret_cast_22[%28, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %44 = arith.addf %42, %43 : f32
      %45 = arith.mulf %44, %35 : f32
      %46 = arith.divf %39, %45 : f32
      memref.store %46, %reinterpret_cast_21[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


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
    %9 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c1, %c1, %c1) {
      memref.store %cst_2, %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.get_global @kbm1 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.load %3[%c0] : memref<1xi32>
    %14 = memref.load %4[%c0] : memref<1xi32>
    %15 = arith.index_cast %13 : i32 to index
    %16 = arith.index_cast %14 : i32 to index
    %17 = arith.muli %16, %15 : index
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%12, %15, %16], strides: [%17, %16, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%12, %15, %16], strides: [%17, %16, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%12, %15, %16], strides: [%17, %16, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c1, %c0) to (%12, %15, %16) step (%c1, %c1, %c1) {
      %48 = memref.load %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %49 = arith.addi %arg19, %c-1 : index
      %50 = memref.load %reinterpret_cast_3[%arg18, %49, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %51 = arith.addf %48, %50 : f32
      %52 = arith.mulf %51, %cst_1 : f32
      %53 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %54 = arith.addi %arg18, %c-1 : index
      %55 = memref.load %reinterpret_cast_4[%54, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %56 = arith.addf %53, %55 : f32
      %57 = arith.mulf %52, %56 : f32
      memref.store %57, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %18 = memref.load %10[%c0] : memref<1xi32>
    %19 = arith.index_cast %18 : i32 to index
    %20 = memref.get_global @jmm1 : memref<1xi32>
    %21 = memref.get_global @imm1 : memref<1xi32>
    %22 = memref.get_global @grav : memref<1xf32>
    %23 = memref.load %20[%c0] : memref<1xi32>
    %24 = memref.load %21[%c0] : memref<1xi32>
    %25 = memref.load %4[%c0] : memref<1xi32>
    %26 = memref.load %3[%c0] : memref<1xi32>
    %27 = memref.load %22[%c0] : memref<1xf32>
    %28 = arith.index_cast %23 : i32 to index
    %29 = arith.index_cast %24 : i32 to index
    %30 = arith.index_cast %25 : i32 to index
    %31 = arith.index_cast %26 : i32 to index
    %32 = arith.mulf %27, %cst_0 : f32
    %33 = arith.muli %30, %31 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%19, %31, %30], strides: [%33, %30, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%19, %31, %30], strides: [%33, %30, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%19, %31, %30], strides: [%33, %30, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%19, %31, %30], strides: [%33, %30, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg18 = %c0 to %19 step %c1 {
      %48 = memref.load %arg8[%arg18] : memref<?xf32>
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%28, %29) step (%c1, %c1) {
        %49 = memref.load %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %50 = memref.load %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %51 = arith.addi %arg18, %c1 : index
        %52 = memref.load %reinterpret_cast_7[%51, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %53 = arith.subf %50, %52 : f32
        %54 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %55 = arith.mulf %53, %54 : f32
        %56 = arith.divf %55, %48 : f32
        %57 = arith.addf %49, %56 : f32
        %58 = arith.mulf %54, %cst_1 : f32
        %59 = memref.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %60 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %61 = arith.mulf %59, %60 : f32
        %62 = arith.muli %arg19, %30 overflow<nsw> : index
        %63 = arith.addi %arg20, %62 : index
        %64 = arith.muli %arg18, %30 overflow<nsw> : index
        %65 = arith.muli %64, %31 overflow<nsw> : index
        %66 = arith.addi %63, %65 : index
        %67 = arith.addi %66, %c1 : index
        %68 = memref.load %arg3[%67] : memref<?xf32>
        %69 = memref.load %reinterpret_cast_11[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %70 = arith.addf %68, %69 : f32
        %71 = arith.mulf %61, %70 : f32
        %72 = arith.addi %arg19, %c-1 : index
        %73 = memref.load %reinterpret_cast_9[%72, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %74 = memref.load %reinterpret_cast_10[%72, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %75 = arith.mulf %73, %74 : f32
        %76 = arith.muli %72, %30 overflow<nsw> : index
        %77 = arith.addi %arg20, %76 : index
        %78 = arith.addi %77, %65 : index
        %79 = arith.addi %78, %c1 : index
        %80 = memref.load %arg3[%79] : memref<?xf32>
        %81 = memref.load %reinterpret_cast_11[%arg18, %72, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %82 = arith.addf %80, %81 : f32
        %83 = arith.mulf %75, %82 : f32
        %84 = arith.addf %71, %83 : f32
        %85 = arith.mulf %58, %84 : f32
        %86 = arith.addf %57, %85 : f32
        %87 = arith.addf %60, %74 : f32
        %88 = arith.mulf %32, %87 : f32
        %89 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %90 = memref.load %reinterpret_cast_12[%72, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %91 = arith.subf %89, %90 : f32
        %92 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %93 = arith.addf %91, %92 : f32
        %94 = memref.load %reinterpret_cast_13[%72, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %95 = arith.subf %93, %94 : f32
        %96 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %97 = memref.load %reinterpret_cast_14[%72, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %98 = arith.subf %96, %97 : f32
        %99 = arith.mulf %98, %cst : f32
        %100 = arith.addf %95, %99 : f32
        %101 = arith.mulf %88, %100 : f32
        %102 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %103 = memref.load %reinterpret_cast_15[%72, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %104 = arith.addf %102, %103 : f32
        %105 = arith.mulf %101, %104 : f32
        %106 = arith.addf %86, %105 : f32
        %107 = memref.load %reinterpret_cast_16[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %108 = arith.addf %106, %107 : f32
        memref.store %108, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %34 = memref.load %10[%c0] : memref<1xi32>
    %35 = arith.index_cast %34 : i32 to index
    %36 = memref.get_global @dti2 : memref<1xf32>
    %37 = memref.load %20[%c0] : memref<1xi32>
    %38 = memref.load %21[%c0] : memref<1xi32>
    %39 = memref.load %4[%c0] : memref<1xi32>
    %40 = memref.load %3[%c0] : memref<1xi32>
    %41 = memref.load %36[%c0] : memref<1xf32>
    %42 = arith.index_cast %37 : i32 to index
    %43 = arith.index_cast %38 : i32 to index
    %44 = arith.index_cast %39 : i32 to index
    %45 = arith.index_cast %40 : i32 to index
    %46 = arith.mulf %41, %cst : f32
    %reinterpret_cast_17 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %47 = arith.muli %44, %45 : index
    %reinterpret_cast_20 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%35, %45, %44], strides: [%47, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%35, %45, %44], strides: [%47, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%35, %42, %43) step (%c1, %c1, %c1) {
      %48 = memref.load %reinterpret_cast_17[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %49 = memref.load %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %50 = arith.addf %48, %49 : f32
      %51 = arith.addi %arg19, %c-1 : index
      %52 = memref.load %reinterpret_cast_17[%51, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %53 = arith.addf %50, %52 : f32
      %54 = memref.load %reinterpret_cast_18[%51, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %55 = arith.addf %53, %54 : f32
      %56 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %57 = arith.mulf %55, %56 : f32
      %58 = memref.load %reinterpret_cast_20[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %59 = arith.mulf %57, %58 : f32
      %60 = memref.load %reinterpret_cast_21[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %61 = arith.mulf %46, %60 : f32
      %62 = arith.subf %59, %61 : f32
      %63 = memref.load %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = arith.addf %48, %63 : f32
      %65 = arith.addf %64, %52 : f32
      %66 = memref.load %reinterpret_cast_22[%51, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %67 = arith.addf %65, %66 : f32
      %68 = arith.mulf %67, %56 : f32
      %69 = arith.divf %62, %68 : f32
      memref.store %69, %reinterpret_cast_21[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advu_(%arg0: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advx", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
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
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c0, %c1) to (%12, %15, %16) step (%c1, %c1, %c1) {
      %48 = memref.load %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %49 = arith.muli %arg19, %16 overflow<nsw> : index
      %50 = arith.addi %arg20, %49 : index
      %51 = arith.muli %arg18, %16 overflow<nsw> : index
      %52 = arith.muli %51, %15 overflow<nsw> : index
      %53 = arith.addi %50, %52 : index
      %54 = arith.addi %53, %c-1 : index
      %55 = memref.load %arg4[%54] : memref<?xf32>
      %56 = arith.addf %48, %55 : f32
      %57 = arith.mulf %56, %cst_1 : f32
      %58 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %59 = arith.addi %arg18, %c-1 : index
      %60 = memref.load %reinterpret_cast_4[%59, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %61 = arith.addf %58, %60 : f32
      %62 = arith.mulf %57, %61 : f32
      memref.store %62, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
    %reinterpret_cast_8 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%19, %31, %30], strides: [%33, %30, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%19, %31, %30], strides: [%33, %30, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%28, %30], strides: [%30, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg18 = %c0 to %19 step %c1 {
      %48 = memref.load %arg8[%arg18] : memref<?xf32>
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%28, %29) step (%c1, %c1) {
        %49 = memref.load %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %50 = memref.load %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %51 = arith.addi %arg18, %c1 : index
        %52 = memref.load %reinterpret_cast_7[%51, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %53 = arith.subf %50, %52 : f32
        %54 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %55 = arith.mulf %53, %54 : f32
        %56 = arith.divf %55, %48 : f32
        %57 = arith.addf %49, %56 : f32
        %58 = arith.mulf %54, %cst_1 : f32
        %59 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %60 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %61 = arith.mulf %59, %60 : f32
        %62 = arith.addi %arg19, %c1 : index
        %63 = memref.load %reinterpret_cast_8[%arg18, %62, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %64 = memref.load %reinterpret_cast_8[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %65 = arith.addf %63, %64 : f32
        %66 = arith.mulf %61, %65 : f32
        %67 = arith.muli %arg19, %30 overflow<nsw> : index
        %68 = arith.addi %arg20, %67 : index
        %69 = arith.addi %68, %c-1 : index
        %70 = memref.load %arg9[%69] : memref<?xf32>
        %71 = memref.load %arg10[%69] : memref<?xf32>
        %72 = arith.mulf %70, %71 : f32
        %73 = arith.muli %62, %30 overflow<nsw> : index
        %74 = arith.addi %arg20, %73 : index
        %75 = arith.muli %arg18, %30 overflow<nsw> : index
        %76 = arith.muli %75, %31 overflow<nsw> : index
        %77 = arith.addi %74, %76 : index
        %78 = arith.addi %77, %c-1 : index
        %79 = memref.load %arg3[%78] : memref<?xf32>
        %80 = arith.addi %68, %76 : index
        %81 = arith.addi %80, %c-1 : index
        %82 = memref.load %arg3[%81] : memref<?xf32>
        %83 = arith.addf %79, %82 : f32
        %84 = arith.mulf %72, %83 : f32
        %85 = arith.addf %66, %84 : f32
        %86 = arith.mulf %58, %85 : f32
        %87 = arith.subf %57, %86 : f32
        %88 = arith.addf %60, %71 : f32
        %89 = arith.mulf %32, %88 : f32
        %90 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %91 = memref.load %arg11[%69] : memref<?xf32>
        %92 = arith.subf %90, %91 : f32
        %93 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %94 = arith.addf %92, %93 : f32
        %95 = memref.load %arg12[%69] : memref<?xf32>
        %96 = arith.subf %94, %95 : f32
        %97 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %98 = memref.load %arg13[%69] : memref<?xf32>
        %99 = arith.subf %97, %98 : f32
        %100 = arith.mulf %99, %cst : f32
        %101 = arith.addf %96, %100 : f32
        %102 = arith.mulf %89, %101 : f32
        %103 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %104 = memref.load %arg7[%69] : memref<?xf32>
        %105 = arith.addf %103, %104 : f32
        %106 = arith.mulf %102, %105 : f32
        %107 = arith.addf %87, %106 : f32
        %108 = memref.load %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %109 = arith.addf %107, %108 : f32
        memref.store %109, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
    %47 = arith.muli %44, %45 : index
    %reinterpret_cast_17 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%35, %45, %44], strides: [%47, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%35, %45, %44], strides: [%47, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%42, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%35, %42, %43) step (%c1, %c1, %c1) {
      %48 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %49 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %50 = arith.addf %48, %49 : f32
      %51 = arith.muli %arg19, %44 overflow<nsw> : index
      %52 = arith.addi %arg20, %51 : index
      %53 = arith.addi %52, %c-1 : index
      %54 = memref.load %arg15[%53] : memref<?xf32>
      %55 = arith.addf %50, %54 : f32
      %56 = memref.load %arg17[%53] : memref<?xf32>
      %57 = arith.addf %55, %56 : f32
      %58 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %59 = arith.mulf %57, %58 : f32
      %60 = memref.load %reinterpret_cast_17[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %61 = arith.mulf %59, %60 : f32
      %62 = memref.load %reinterpret_cast_18[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %63 = arith.mulf %46, %62 : f32
      %64 = arith.subf %61, %63 : f32
      %65 = memref.load %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %66 = arith.addf %48, %65 : f32
      %67 = arith.addf %66, %54 : f32
      %68 = memref.load %arg16[%53] : memref<?xf32>
      %69 = arith.addf %67, %68 : f32
      %70 = arith.mulf %69, %58 : f32
      %71 = arith.divf %64, %70 : f32
      memref.store %71, %reinterpret_cast_18[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


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
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c1, %c1, %c1) {
      memref.store %cst_2, %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c0, %c1) to (%11, %7, %8) step (%c1, %c1, %c1) {
      %32 = memref.load %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %33 = arith.muli %arg19, %8 overflow<nsw> : index
      %34 = arith.addi %arg20, %33 : index
      %35 = arith.muli %arg18, %8 overflow<nsw> : index
      %36 = arith.muli %35, %7 overflow<nsw> : index
      %37 = arith.addi %34, %36 : index
      %38 = arith.addi %37, %c-1 : index
      %39 = memref.load %arg4[%38] : memref<?xf32>
      %40 = arith.addf %32, %39 : f32
      %41 = arith.mulf %40, %cst_1 : f32
      %42 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %43 = arith.addi %arg18, %c-1 : index
      %44 = memref.load %reinterpret_cast_4[%43, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %45 = arith.addf %42, %44 : f32
      %46 = arith.mulf %41, %45 : f32
      memref.store %46, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
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
    scf.for %arg18 = %c0 to %14 step %c1 {
      %32 = memref.load %arg8[%arg18] : memref<?xf32>
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%23, %24) step (%c1, %c1) {
        %33 = memref.load %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %34 = memref.load %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %35 = arith.addi %arg18, %c1 : index
        %36 = memref.load %reinterpret_cast_7[%35, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %37 = arith.subf %34, %36 : f32
        %38 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %39 = arith.mulf %37, %38 : f32
        %40 = arith.divf %39, %32 : f32
        %41 = arith.addf %33, %40 : f32
        %42 = arith.mulf %38, %cst_1 : f32
        %43 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %44 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %45 = arith.mulf %43, %44 : f32
        %46 = arith.addi %arg19, %c1 : index
        %47 = memref.load %reinterpret_cast_8[%arg18, %46, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %48 = memref.load %reinterpret_cast_8[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %49 = arith.addf %47, %48 : f32
        %50 = arith.mulf %45, %49 : f32
        %51 = arith.muli %arg19, %25 overflow<nsw> : index
        %52 = arith.addi %arg20, %51 : index
        %53 = arith.addi %52, %c-1 : index
        %54 = memref.load %arg9[%53] : memref<?xf32>
        %55 = memref.load %arg10[%53] : memref<?xf32>
        %56 = arith.mulf %54, %55 : f32
        %57 = arith.muli %46, %25 overflow<nsw> : index
        %58 = arith.addi %arg20, %57 : index
        %59 = arith.muli %arg18, %25 overflow<nsw> : index
        %60 = arith.muli %59, %26 overflow<nsw> : index
        %61 = arith.addi %58, %60 : index
        %62 = arith.addi %61, %c-1 : index
        %63 = memref.load %arg3[%62] : memref<?xf32>
        %64 = arith.addi %52, %60 : index
        %65 = arith.addi %64, %c-1 : index
        %66 = memref.load %arg3[%65] : memref<?xf32>
        %67 = arith.addf %63, %66 : f32
        %68 = arith.mulf %56, %67 : f32
        %69 = arith.addf %50, %68 : f32
        %70 = arith.mulf %42, %69 : f32
        %71 = arith.subf %41, %70 : f32
        %72 = arith.addf %44, %55 : f32
        %73 = arith.mulf %27, %72 : f32
        %74 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %75 = memref.load %arg11[%53] : memref<?xf32>
        %76 = arith.subf %74, %75 : f32
        %77 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %78 = arith.addf %76, %77 : f32
        %79 = memref.load %arg12[%53] : memref<?xf32>
        %80 = arith.subf %78, %79 : f32
        %81 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %82 = memref.load %arg13[%53] : memref<?xf32>
        %83 = arith.subf %81, %82 : f32
        %84 = arith.mulf %83, %cst : f32
        %85 = arith.addf %80, %84 : f32
        %86 = arith.mulf %73, %85 : f32
        %87 = memref.load %reinterpret_cast_17[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %88 = memref.load %arg7[%53] : memref<?xf32>
        %89 = arith.addf %87, %88 : f32
        %90 = arith.mulf %86, %89 : f32
        %91 = arith.addf %71, %90 : f32
        %92 = memref.load %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %93 = arith.addf %91, %92 : f32
        memref.store %93, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %94 = memref.load %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %95 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %96 = arith.addf %94, %95 : f32
        %97 = memref.load %arg15[%53] : memref<?xf32>
        %98 = arith.addf %96, %97 : f32
        %99 = memref.load %arg17[%53] : memref<?xf32>
        %100 = arith.addf %98, %99 : f32
        %101 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %102 = arith.mulf %100, %101 : f32
        %103 = memref.load %reinterpret_cast_10[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %104 = arith.mulf %102, %103 : f32
        %105 = arith.mulf %31, %93 : f32
        %106 = arith.subf %104, %105 : f32
        %107 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %108 = arith.addf %94, %107 : f32
        %109 = arith.addf %108, %97 : f32
        %110 = memref.load %arg16[%53] : memref<?xf32>
        %111 = arith.addf %109, %110 : f32
        %112 = arith.mulf %111, %101 : f32
        %113 = arith.divf %106, %112 : f32
        memref.store %113, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    return
  }
}


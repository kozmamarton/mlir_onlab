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
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c1, %c0) to (%11, %7, %8) step (%c1, %c1, %c1) {
      %43 = memref.load %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %44 = arith.addi %arg19, %c-1 : index
      %45 = memref.load %reinterpret_cast_3[%arg18, %44, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %46 = arith.addf %43, %45 : f32
      %47 = arith.mulf %46, %cst_1 : f32
      %48 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %49 = arith.addi %arg18, %c-1 : index
      %50 = memref.load %reinterpret_cast_4[%49, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %51 = arith.addf %48, %50 : f32
      %52 = arith.mulf %47, %51 : f32
      memref.store %52, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
    %reinterpret_cast_10 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%23, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg18 = %c0 to %14 step %c1 {
      %43 = memref.load %arg8[%arg18] : memref<?xf32>
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%23, %24) step (%c1, %c1) {
        %44 = memref.load %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %45 = memref.load %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %46 = arith.addi %arg18, %c1 : index
        %47 = memref.load %reinterpret_cast_7[%46, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %48 = arith.subf %45, %47 : f32
        %49 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %50 = arith.mulf %48, %49 : f32
        %51 = arith.divf %50, %43 : f32
        %52 = arith.addf %44, %51 : f32
        %53 = arith.mulf %49, %cst_1 : f32
        %54 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %55 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %56 = arith.mulf %54, %55 : f32
        %57 = arith.muli %arg19, %25 overflow<nsw> : index
        %58 = arith.addi %arg20, %57 : index
        %59 = arith.muli %arg18, %25 overflow<nsw> : index
        %60 = arith.muli %59, %26 overflow<nsw> : index
        %61 = arith.addi %58, %60 : index
        %62 = arith.addi %61, %c1 : index
        %63 = memref.load %arg3[%62] : memref<?xf32>
        %64 = memref.load %reinterpret_cast_8[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %65 = arith.addf %63, %64 : f32
        %66 = arith.mulf %56, %65 : f32
        %67 = arith.addi %arg19, %c-1 : index
        %68 = memref.load %reinterpret_cast_11[%67, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %69 = memref.load %reinterpret_cast_12[%67, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %70 = arith.mulf %68, %69 : f32
        %71 = arith.muli %67, %25 overflow<nsw> : index
        %72 = arith.addi %arg20, %71 : index
        %73 = arith.addi %72, %60 : index
        %74 = arith.addi %73, %c1 : index
        %75 = memref.load %arg3[%74] : memref<?xf32>
        %76 = memref.load %reinterpret_cast_8[%arg18, %67, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %77 = arith.addf %75, %76 : f32
        %78 = arith.mulf %70, %77 : f32
        %79 = arith.addf %66, %78 : f32
        %80 = arith.mulf %53, %79 : f32
        %81 = arith.addf %52, %80 : f32
        %82 = arith.addf %55, %69 : f32
        %83 = arith.mulf %27, %82 : f32
        %84 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %85 = memref.load %reinterpret_cast_13[%67, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %86 = arith.subf %84, %85 : f32
        %87 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %88 = arith.addf %86, %87 : f32
        %89 = memref.load %reinterpret_cast_14[%67, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %90 = arith.subf %88, %89 : f32
        %91 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %92 = memref.load %reinterpret_cast_15[%67, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %93 = arith.subf %91, %92 : f32
        %94 = arith.mulf %93, %cst : f32
        %95 = arith.addf %90, %94 : f32
        %96 = arith.mulf %83, %95 : f32
        %97 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %98 = memref.load %reinterpret_cast_16[%67, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %99 = arith.addf %97, %98 : f32
        %100 = arith.mulf %96, %99 : f32
        %101 = arith.addf %81, %100 : f32
        %102 = memref.load %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %103 = arith.addf %101, %102 : f32
        memref.store %103, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %29 = memref.load %9[%c0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = memref.get_global @dti2 : memref<1xf32>
    %32 = memref.load %15[%c0] : memref<1xi32>
    %33 = memref.load %16[%c0] : memref<1xi32>
    %34 = memref.load %4[%c0] : memref<1xi32>
    %35 = memref.load %3[%c0] : memref<1xi32>
    %36 = memref.load %31[%c0] : memref<1xf32>
    %37 = arith.index_cast %32 : i32 to index
    %38 = arith.index_cast %33 : i32 to index
    %39 = arith.index_cast %34 : i32 to index
    %40 = arith.index_cast %35 : i32 to index
    %41 = arith.mulf %36, %cst : f32
    %42 = arith.muli %39, %40 : index
    %reinterpret_cast_17 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%30, %40, %39], strides: [%42, %39, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%30, %40, %39], strides: [%42, %39, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%37, %39], strides: [%39, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%37, %39], strides: [%39, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%37, %39], strides: [%39, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%37, %39], strides: [%39, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%30, %37, %38) step (%c1, %c1, %c1) {
      %43 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %44 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %45 = arith.addf %43, %44 : f32
      %46 = arith.addi %arg19, %c-1 : index
      %47 = memref.load %reinterpret_cast_19[%46, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %48 = arith.addf %45, %47 : f32
      %49 = memref.load %reinterpret_cast_20[%46, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %50 = arith.addf %48, %49 : f32
      %51 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %52 = arith.mulf %50, %51 : f32
      %53 = memref.load %reinterpret_cast_17[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %54 = arith.mulf %52, %53 : f32
      %55 = memref.load %reinterpret_cast_18[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %56 = arith.mulf %41, %55 : f32
      %57 = arith.subf %54, %56 : f32
      %58 = memref.load %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %59 = arith.addf %43, %58 : f32
      %60 = arith.addf %59, %47 : f32
      %61 = memref.load %reinterpret_cast_22[%46, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %62 = arith.addf %60, %61 : f32
      %63 = arith.mulf %62, %51 : f32
      %64 = arith.divf %57, %63 : f32
      memref.store %64, %reinterpret_cast_18[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


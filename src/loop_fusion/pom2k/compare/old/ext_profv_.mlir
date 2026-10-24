module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_profv_(%arg0: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "km", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "dhloc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %0 = llvm.mlir.undef : i32
    %c-1 = arith.constant -1 : index
    %c-3_i32 = arith.constant -3 : i32
    %c-1_i32 = arith.constant -1 : i32
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %c1_i32 = arith.constant 1 : i32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %alloca = memref.alloca() : memref<i32>
    memref.store %0, %alloca[] : memref<i32>
    %1 = memref.get_global @jm : memref<1xi32>
    %2 = memref.load %1[%c0] : memref<1xi32>
    %3 = arith.index_cast %2 : i32 to index
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %4[%c0] : memref<1xi32>
    %6 = arith.index_cast %5 : i32 to index
    %7 = memref.get_global @kb : memref<1xi32>
    %8 = memref.load %7[%c0] : memref<1xi32>
    %9 = arith.index_cast %8 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%3, %6) step (%c1, %c1) {
      memref.store %cst_1, %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%3, %6) step (%c1, %c1) {
      %80 = memref.load %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %81 = memref.load %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %82 = arith.addf %80, %81 : f32
      %83 = arith.addi %arg18, %c-1 : index
      %84 = memref.load %reinterpret_cast_2[%83, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %85 = arith.addf %82, %84 : f32
      %86 = memref.load %reinterpret_cast_3[%83, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %87 = arith.addf %85, %86 : f32
      %88 = arith.mulf %87, %cst_0 : f32
      memref.store %88, %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %10 = arith.muli %6, %3 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%9, %3, %6], strides: [%10, %6, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%9, %3, %6], strides: [%10, %6, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%9, %3, %6) step (%c1, %c1, %c1) {
      %80 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %81 = arith.addi %arg19, %c-1 : index
      %82 = memref.load %reinterpret_cast_4[%arg18, %81, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %83 = arith.addf %80, %82 : f32
      %84 = arith.mulf %83, %cst_0 : f32
      memref.store %84, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %11 = memref.get_global @kbm2 : memref<1xi32>
    %12 = memref.load %11[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.get_global @dti2 : memref<1xf32>
    %15 = memref.get_global @umol : memref<1xf32>
    %16 = memref.load %1[%c0] : memref<1xi32>
    %17 = memref.load %4[%c0] : memref<1xi32>
    %18 = memref.load %14[%c0] : memref<1xf32>
    %19 = memref.load %15[%c0] : memref<1xf32>
    %20 = arith.index_cast %16 : i32 to index
    %21 = arith.index_cast %17 : i32 to index
    %22 = arith.negf %18 : f32
    %23 = arith.muli %21, %20 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%13, %20, %21], strides: [%23, %21, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%13, %20, %21], strides: [%23, %21, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%20, %21], strides: [%21, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%13, %20, %21) step (%c1, %c1, %c1) {
      %80 = memref.load %arg5[%arg18] : memref<?xf32>
      %81 = memref.load %arg6[%arg18] : memref<?xf32>
      %82 = arith.mulf %80, %81 : f32
      %83 = arith.addi %arg18, %c1 : index
      %84 = memref.load %reinterpret_cast_6[%83, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %85 = arith.addf %84, %19 : f32
      %86 = arith.mulf %22, %85 : f32
      %87 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %88 = arith.mulf %82, %87 : f32
      %89 = arith.mulf %88, %87 : f32
      %90 = arith.divf %86, %89 : f32
      memref.store %90, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %24 = memref.get_global @kbm1 : memref<1xi32>
    %25 = memref.load %24[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    %27 = memref.load %1[%c0] : memref<1xi32>
    %28 = memref.load %4[%c0] : memref<1xi32>
    %29 = memref.load %14[%c0] : memref<1xf32>
    %30 = memref.load %15[%c0] : memref<1xf32>
    %31 = arith.index_cast %27 : i32 to index
    %32 = arith.index_cast %28 : i32 to index
    %33 = arith.negf %29 : f32
    %34 = arith.muli %32, %31 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%26, %31, %32], strides: [%34, %32, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%31, %32], strides: [%32, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c0, %c0) to (%26, %31, %32) step (%c1, %c1, %c1) {
      %80 = memref.load %arg5[%arg18] : memref<?xf32>
      %81 = arith.addi %arg18, %c-1 : index
      %82 = memref.load %arg6[%81] : memref<?xf32>
      %83 = arith.mulf %80, %82 : f32
      %84 = memref.load %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %85 = arith.addf %84, %30 : f32
      %86 = arith.mulf %33, %85 : f32
      %87 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %88 = arith.mulf %83, %87 : f32
      %89 = arith.mulf %88, %87 : f32
      %90 = arith.divf %86, %89 : f32
      memref.store %90, %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %35 = memref.load %1[%c0] : memref<1xi32>
    %36 = arith.index_cast %35 : i32 to index
    %37 = memref.load %4[%c0] : memref<1xi32>
    %38 = memref.load %14[%c0] : memref<1xf32>
    %39 = memref.load %arg5[%c0] : memref<?xf32>
    %40 = arith.index_cast %37 : i32 to index
    %41 = arith.negf %38 : f32
    %42 = arith.negf %39 : f32
    %43 = memref.load %11[%c0] : memref<1xi32>
    %44 = arith.index_cast %43 : i32 to index
    %reinterpret_cast_11 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%36, %40], strides: [%40, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%36, %40], strides: [%40, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%36, %40], strides: [%40, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%36, %40], strides: [%40, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%36, %40], strides: [%40, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%36, %40], strides: [%40, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%36, %40) step (%c1, %c1) {
      %80 = memref.load %reinterpret_cast_11[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %81 = arith.subf %80, %cst_1 : f32
      %82 = arith.divf %80, %81 : f32
      memref.store %82, %reinterpret_cast_12[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %83 = memref.load %reinterpret_cast_13[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %84 = arith.mulf %41, %83 : f32
      %85 = memref.load %reinterpret_cast_14[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %86 = arith.mulf %42, %85 : f32
      %87 = arith.divf %84, %86 : f32
      %88 = memref.load %reinterpret_cast_15[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %89 = arith.subf %87, %88 : f32
      %90 = memref.load %reinterpret_cast_11[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %91 = arith.subf %90, %cst_1 : f32
      %92 = arith.divf %89, %91 : f32
      memref.store %92, %reinterpret_cast_16[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %45 = arith.muli %40, %36 : index
    %reinterpret_cast_17 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%44, %36, %40], strides: [%45, %40, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%44, %36, %40], strides: [%45, %40, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%44, %36, %40], strides: [%45, %40, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%44, %36, %40], strides: [%45, %40, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%44, %36, %40], strides: [%45, %40, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%36, %40) step (%c1, %c1) {
      scf.for %arg20 = %c1 to %44 step %c1 {
        %80 = memref.load %reinterpret_cast_17[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %81 = memref.load %reinterpret_cast_18[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %82 = arith.addi %arg20, %c-1 : index
        %83 = memref.load %reinterpret_cast_19[%82, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %84 = arith.subf %cst_1, %83 : f32
        %85 = arith.mulf %81, %84 : f32
        %86 = arith.addf %80, %85 : f32
        %87 = arith.subf %86, %cst_1 : f32
        %88 = arith.divf %cst_1, %87 : f32
        memref.store %88, %reinterpret_cast_20[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %89 = memref.load %reinterpret_cast_17[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %90 = arith.mulf %89, %88 : f32
        memref.store %90, %reinterpret_cast_19[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %91 = memref.load %reinterpret_cast_18[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %92 = memref.load %reinterpret_cast_20[%82, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %93 = arith.mulf %91, %92 : f32
        %94 = memref.load %reinterpret_cast_21[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %95 = arith.subf %93, %94 : f32
        %96 = memref.load %reinterpret_cast_20[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %97 = arith.mulf %95, %96 : f32
        memref.store %97, %reinterpret_cast_20[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      }
      scf.reduce 
    }
    %46 = memref.get_global @jmm1 : memref<1xi32>
    %47 = memref.load %46[%c0] : memref<1xi32>
    %48 = arith.index_cast %47 : i32 to index
    %49 = memref.get_global @imm1 : memref<1xi32>
    %50 = memref.load %49[%c0] : memref<1xi32>
    %51 = memref.load %4[%c0] : memref<1xi32>
    %52 = memref.load %11[%c0] : memref<1xi32>
    %53 = memref.load %1[%c0] : memref<1xi32>
    %54 = memref.load %14[%c0] : memref<1xf32>
    %55 = arith.index_cast %50 : i32 to index
    %56 = arith.index_cast %51 : i32 to index
    %57 = arith.index_cast %52 : i32 to index
    %58 = arith.muli %57, %56 : index
    %59 = arith.index_cast %53 : i32 to index
    %60 = arith.muli %58, %59 : index
    %61 = arith.addi %57, %c-1 : index
    %62 = arith.muli %61, %56 : index
    %63 = arith.muli %62, %59 : index
    %64 = memref.load %arg5[%57] : memref<?xf32>
    %65 = arith.negf %64 : f32
    %reinterpret_cast_22 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%48, %56], strides: [%56, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%48, %56], strides: [%56, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%48, %56], strides: [%56, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%48, %56], strides: [%56, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg18 = %c1 to %48 step %c1 {
      scf.for %arg19 = %c1 to %55 step %c1 {
        %80 = memref.load %reinterpret_cast_22[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %81 = arith.addi %arg18, %c-1 : index
        %82 = memref.load %reinterpret_cast_22[%81, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %83 = arith.addf %80, %82 : f32
        %84 = arith.mulf %83, %cst_0 : f32
        %85 = arith.muli %arg18, %56 overflow<nsw> : index
        %86 = arith.addi %arg19, %85 : index
        %87 = arith.addi %86, %60 : index
        %88 = memref.load %arg13[%87] : memref<?xf32>
        %89 = arith.addi %87, %c1 : index
        %90 = memref.load %arg13[%89] : memref<?xf32>
        %91 = arith.addf %88, %90 : f32
        %92 = arith.addi %arg19, %60 : index
        %93 = arith.muli %81, %56 overflow<nsw> : index
        %94 = arith.addi %92, %93 : index
        %95 = memref.load %arg13[%94] : memref<?xf32>
        %96 = arith.addf %91, %95 : f32
        %97 = arith.addi %94, %c1 : index
        %98 = memref.load %arg13[%97] : memref<?xf32>
        %99 = arith.addf %96, %98 : f32
        %100 = arith.mulf %99, %cst : f32
        %101 = arith.mulf %100, %100 : f32
        %102 = memref.load %arg14[%87] : memref<?xf32>
        %103 = arith.mulf %102, %102 : f32
        %104 = arith.addf %101, %103 : f32
        %105 = math.sqrt %104 : f32
        %106 = arith.mulf %84, %105 : f32
        memref.store %106, %reinterpret_cast_23[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %107 = memref.load %arg2[%87] : memref<?xf32>
        %108 = arith.addi %86, %63 : index
        %109 = memref.load %arg8[%108] : memref<?xf32>
        %110 = arith.mulf %107, %109 : f32
        %111 = memref.load %arg10[%87] : memref<?xf32>
        %112 = arith.subf %110, %111 : f32
        %113 = arith.mulf %106, %54 : f32
        %114 = memref.load %reinterpret_cast_24[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %115 = arith.mulf %65, %114 : f32
        %116 = arith.divf %113, %115 : f32
        %117 = arith.subf %116, %cst_1 : f32
        %118 = memref.load %arg7[%108] : memref<?xf32>
        %119 = arith.subf %118, %cst_1 : f32
        %120 = arith.mulf %119, %107 : f32
        %121 = arith.subf %117, %120 : f32
        %122 = arith.divf %112, %121 : f32
        memref.store %122, %arg10[%87] : memref<?xf32>
        %123 = memref.load %arg10[%87] : memref<?xf32>
        %124 = memref.load %reinterpret_cast_25[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %125 = arith.mulf %123, %124 : f32
        memref.store %125, %arg10[%87] : memref<?xf32>
      }
    }
    %66 = memref.load %7[%c0] : memref<1xi32>
    %67 = arith.addi %66, %c-3_i32 : i32
    memref.store %67, %alloca[] : memref<i32>
    scf.while : () -> () {
      %80 = memref.load %alloca[] : memref<i32>
      %81 = arith.cmpi sge, %80, %c0_i32 : i32
      scf.condition(%81)
    } do {
      %80 = memref.load %46[%c0] : memref<1xi32>
      %81 = arith.index_cast %80 : i32 to index
      %82 = memref.load %49[%c0] : memref<1xi32>
      %83 = memref.load %4[%c0] : memref<1xi32>
      %84 = memref.load %alloca[] : memref<i32>
      %85 = memref.load %1[%c0] : memref<1xi32>
      %86 = arith.index_cast %82 : i32 to index
      %87 = arith.muli %84, %83 : i32
      %88 = arith.muli %87, %85 : i32
      %89 = arith.addi %84, %c1_i32 : i32
      %90 = arith.muli %89, %83 : i32
      %91 = arith.muli %90, %85 : i32
      %92 = arith.index_cast %83 : i32 to index
      scf.for %arg18 = %c1 to %81 step %c1 {
        %94 = arith.index_cast %arg18 : index to i32
        %95 = arith.muli %94, %83 : i32
        %96 = arith.muli %arg18, %92 : index
        scf.for %arg19 = %c1 to %86 step %c1 {
          %97 = arith.index_cast %arg19 : index to i32
          %98 = arith.addi %97, %95 : i32
          %99 = arith.addi %98, %88 : i32
          %100 = arith.index_cast %99 : i32 to index
          %101 = memref.load %arg7[%100] : memref<?xf32>
          %102 = arith.addi %98, %91 : i32
          %103 = arith.index_cast %102 : i32 to index
          %104 = memref.load %arg10[%103] : memref<?xf32>
          %105 = arith.mulf %101, %104 : f32
          %106 = memref.load %arg8[%100] : memref<?xf32>
          %107 = arith.addf %105, %106 : f32
          %108 = arith.addi %arg19, %96 : index
          %109 = memref.load %arg15[%108] : memref<?xf32>
          %110 = arith.mulf %107, %109 : f32
          memref.store %110, %arg10[%100] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %93 = arith.addi %84, %c-1_i32 : i32
      memref.store %93, %alloca[] : memref<i32>
      scf.yield
    }
    %68 = memref.load %46[%c0] : memref<1xi32>
    %69 = arith.index_cast %68 : i32 to index
    %70 = memref.load %49[%c0] : memref<1xi32>
    %71 = memref.load %4[%c0] : memref<1xi32>
    %72 = memref.load %11[%c0] : memref<1xi32>
    %73 = memref.load %1[%c0] : memref<1xi32>
    %74 = arith.index_cast %70 : i32 to index
    %75 = arith.index_cast %71 : i32 to index
    %76 = arith.index_cast %72 : i32 to index
    %77 = arith.muli %76, %75 : index
    %78 = arith.index_cast %73 : i32 to index
    %79 = arith.muli %77, %78 : index
    %reinterpret_cast_26 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%69, %75], strides: [%75, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_27 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%69, %75], strides: [%75, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%69, %74) step (%c1, %c1) {
      %80 = memref.load %reinterpret_cast_26[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %81 = arith.negf %80 : f32
      %82 = arith.muli %arg18, %75 overflow<nsw> : index
      %83 = arith.addi %arg19, %82 : index
      %84 = arith.addi %83, %79 : index
      %85 = memref.load %arg10[%84] : memref<?xf32>
      %86 = arith.mulf %81, %85 : f32
      memref.store %86, %reinterpret_cast_27[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


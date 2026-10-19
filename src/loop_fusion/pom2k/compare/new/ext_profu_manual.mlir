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
  func.func @ext_profu_(%arg0: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "km", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "dhloc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c-4_i32 = arith.constant -4 : i32
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
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%3, %6) step (%c1, %c1) {
      %77 = arith.addi %arg18, %c-1 : index
      %78 = arith.cmpi sge, %77, %c0 : index
      %79 = arith.addi %arg19, %c-1 : index
      %80 = arith.cmpi sge, %79, %c0 : index
      %81 = arith.andi %78, %80 : i1
      scf.if %81 {
        %82 = memref.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %83 = memref.load %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %84 = arith.addf %82, %83 : f32
        %85 = arith.muli %arg18, %6 overflow<nsw> : index
        %86 = arith.addi %arg19, %85 : index
        %87 = arith.addi %86, %c-1 : index
        %88 = memref.load %arg0[%87] : memref<?xf32>
        %89 = arith.addf %84, %88 : f32
        %90 = memref.load %arg1[%87] : memref<?xf32>
        %91 = arith.addf %89, %90 : f32
        %92 = arith.mulf %91, %cst_0 : f32
        memref.store %92, %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      } else {
        memref.store %cst_1, %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    %7 = memref.get_global @kb : memref<1xi32>
    %8 = memref.load %7[%c0] : memref<1xi32>
    %9 = arith.index_cast %8 : i32 to index
    %10 = memref.load %1[%c0] : memref<1xi32>
    %11 = memref.load %4[%c0] : memref<1xi32>
    %12 = arith.index_cast %10 : i32 to index
    %13 = arith.index_cast %11 : i32 to index
    %14 = arith.muli %13, %12 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%9, %12, %13], strides: [%14, %13, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%9, %12, %13], strides: [%14, %13, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%9, %12, %13) step (%c1, %c1, %c1) {
      %77 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %78 = arith.muli %arg19, %13 overflow<nsw> : index
      %79 = arith.addi %arg20, %78 : index
      %80 = arith.muli %arg18, %13 overflow<nsw> : index
      %81 = arith.muli %80, %12 overflow<nsw> : index
      %82 = arith.addi %79, %81 : index
      %83 = arith.addi %82, %c-1 : index
      %84 = memref.load %arg3[%83] : memref<?xf32>
      %85 = arith.addf %77, %84 : f32
      %86 = arith.mulf %85, %cst_0 : f32
      memref.store %86, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %15 = memref.get_global @kbm2 : memref<1xi32>
    %16 = memref.load %15[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @dti2 : memref<1xf32>
    %19 = memref.get_global @umol : memref<1xf32>
    %20 = memref.load %1[%c0] : memref<1xi32>
    %21 = memref.load %4[%c0] : memref<1xi32>
    %22 = memref.load %18[%c0] : memref<1xf32>
    %23 = memref.load %19[%c0] : memref<1xf32>
    %24 = arith.index_cast %20 : i32 to index
    %25 = arith.index_cast %21 : i32 to index
    %26 = arith.negf %22 : f32
    %27 = arith.muli %25, %24 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%17, %24, %25], strides: [%27, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%17, %24, %25], strides: [%27, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%17, %24, %25) step (%c1, %c1, %c1) {
      %77 = memref.load %arg5[%arg18] : memref<?xf32>
      %78 = memref.load %arg6[%arg18] : memref<?xf32>
      %79 = arith.mulf %77, %78 : f32
      %80 = arith.addi %arg18, %c1 : index
      %81 = memref.load %reinterpret_cast_6[%80, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %82 = arith.addf %81, %23 : f32
      %83 = arith.mulf %26, %82 : f32
      %84 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %85 = arith.mulf %79, %84 : f32
      %86 = arith.mulf %85, %84 : f32
      %87 = arith.divf %83, %86 : f32
      memref.store %87, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %28 = memref.get_global @kbm1 : memref<1xi32>
    %29 = memref.load %28[%c0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = memref.load %1[%c0] : memref<1xi32>
    %32 = memref.load %4[%c0] : memref<1xi32>
    %33 = memref.load %18[%c0] : memref<1xf32>
    %34 = memref.load %19[%c0] : memref<1xf32>
    %35 = arith.index_cast %31 : i32 to index
    %36 = arith.index_cast %32 : i32 to index
    %37 = arith.negf %33 : f32
    %38 = arith.muli %36, %35 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%30, %35, %36], strides: [%38, %36, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%35, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c0, %c0) to (%30, %35, %36) step (%c1, %c1, %c1) {
      %77 = memref.load %arg5[%arg18] : memref<?xf32>
      %78 = arith.addi %arg18, %c-1 : index
      %79 = memref.load %arg6[%78] : memref<?xf32>
      %80 = arith.mulf %77, %79 : f32
      %81 = memref.load %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %82 = arith.addf %81, %34 : f32
      %83 = arith.mulf %37, %82 : f32
      %84 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %85 = arith.mulf %80, %84 : f32
      %86 = arith.mulf %85, %84 : f32
      %87 = arith.divf %83, %86 : f32
      memref.store %87, %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %39 = memref.load %15[%c0] : memref<1xi32>
    %40 = arith.index_cast %39 : i32 to index
    %41 = memref.load %1[%c0] : memref<1xi32>
    %42 = memref.load %4[%c0] : memref<1xi32>
    %43 = arith.index_cast %41 : i32 to index
    %44 = arith.index_cast %42 : i32 to index
    %45 = arith.muli %44, %43 : index
    %reinterpret_cast_11 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%40, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%40, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%40, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%40, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%40, %43, %44], strides: [%45, %44, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg18 = %c1 to %40 step %c1 {
      %77 = arith.addi %arg18, %c-1 : index
      %78 = arith.cmpi eq, %77, %c0 : index
      scf.if %78 {
        %reinterpret_cast_18 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%43, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_19 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%43, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_20 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%43, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_21 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%43, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_22 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%43, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_23 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%43, %44], strides: [%44, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%43, %44) step (%c1, %c1) {
          %79 = memref.load %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %80 = arith.subf %79, %cst_1 : f32
          %81 = arith.divf %79, %80 : f32
          memref.store %81, %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %82 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %83 = arith.mulf %26, %82 : f32
          %84 = memref.load %arg5[%c0] : memref<?xf32>
          %85 = arith.negf %84 : f32
          %86 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %87 = arith.mulf %85, %86 : f32
          %88 = arith.divf %83, %87 : f32
          %89 = memref.load %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %90 = arith.subf %88, %89 : f32
          %91 = arith.divf %90, %80 : f32
          memref.store %91, %reinterpret_cast_23[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          scf.reduce 
        }
      }
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%43, %44) step (%c1, %c1) {
        %79 = memref.load %reinterpret_cast_11[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %80 = memref.load %reinterpret_cast_12[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %81 = memref.load %reinterpret_cast_13[%77, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %82 = arith.subf %cst_1, %81 : f32
        %83 = arith.mulf %80, %82 : f32
        %84 = arith.addf %79, %83 : f32
        %85 = arith.subf %84, %cst_1 : f32
        %86 = arith.divf %cst_1, %85 : f32
        memref.store %86, %reinterpret_cast_14[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %87 = memref.load %reinterpret_cast_11[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %88 = arith.mulf %87, %86 : f32
        memref.store %88, %reinterpret_cast_13[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %89 = memref.load %reinterpret_cast_12[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %90 = memref.load %reinterpret_cast_14[%77, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %91 = arith.mulf %89, %90 : f32
        %92 = memref.load %reinterpret_cast_15[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %93 = arith.subf %91, %92 : f32
        %94 = memref.load %reinterpret_cast_14[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %95 = arith.mulf %93, %94 : f32
        memref.store %95, %reinterpret_cast_14[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %46 = memref.get_global @jmm1 : memref<1xi32>
    %47 = memref.get_global @imm1 : memref<1xi32>
    %48 = memref.load %4[%c0] : memref<1xi32>
    %49 = memref.load %15[%c0] : memref<1xi32>
    %50 = memref.load %1[%c0] : memref<1xi32>
    %51 = memref.load %18[%c0] : memref<1xf32>
    %52 = arith.index_cast %48 : i32 to index
    %53 = arith.index_cast %49 : i32 to index
    %54 = arith.muli %53, %52 : index
    %55 = arith.index_cast %50 : i32 to index
    %56 = arith.muli %54, %55 : index
    %57 = arith.addi %53, %c-1 : index
    %58 = arith.muli %57, %52 : index
    %59 = arith.muli %58, %55 : index
    %60 = memref.load %arg5[%53] : memref<?xf32>
    %61 = arith.negf %60 : f32
    %62 = memref.load %7[%c0] : memref<1xi32>
    %63 = arith.addi %62, %c-3_i32 : i32
    %64 = arith.addi %62, %c-4_i32 : i32
    memref.store %63, %alloca[] : memref<i32>
    scf.while : () -> () {
      %77 = memref.load %alloca[] : memref<i32>
      %78 = arith.cmpi sge, %77, %c0_i32 : i32
      scf.condition(%78)
    } do {
      %77 = memref.load %46[%c0] : memref<1xi32>
      %78 = arith.index_cast %77 : i32 to index
      %79 = memref.load %47[%c0] : memref<1xi32>
      %80 = memref.load %4[%c0] : memref<1xi32>
      %81 = memref.load %alloca[] : memref<i32>
      %82 = memref.load %1[%c0] : memref<1xi32>
      %83 = arith.index_cast %79 : i32 to index
      %84 = arith.muli %81, %80 : i32
      %85 = arith.muli %84, %82 : i32
      %86 = arith.addi %81, %c1_i32 : i32
      %87 = arith.muli %86, %80 : i32
      %88 = arith.muli %87, %82 : i32
      %89 = arith.index_cast %80 : i32 to index
      %90 = arith.cmpi sgt, %81, %64 : i32
      scf.if %90 {
        scf.for %arg18 = %c1 to %78 step %c1 {
          %92 = arith.muli %arg18, %89 : index
          %93 = arith.addi %arg18, %c1 : index
          %94 = arith.muli %93, %89 : index
          scf.for %arg19 = %c1 to %83 step %c1 {
            %95 = arith.addi %arg19, %92 : index
            %96 = arith.addi %95, %56 : index
            %97 = arith.addi %95, %59 : index
            %98 = arith.addi %95, %c-1 : index
            %99 = arith.addi %arg19, %94 : index
            %100 = arith.addi %99, %56 : index
            %101 = arith.addi %100, %c-1 : index
            %102 = arith.addi %96, %c-1 : index
            %103 = memref.load %arg12[%95] : memref<?xf32>
            %104 = memref.load %arg12[%98] : memref<?xf32>
            %105 = arith.addf %103, %104 : f32
            %106 = arith.mulf %105, %cst_0 : f32
            %107 = memref.load %arg13[%96] : memref<?xf32>
            %108 = arith.mulf %107, %107 : f32
            %109 = memref.load %arg14[%96] : memref<?xf32>
            %110 = memref.load %arg14[%100] : memref<?xf32>
            %111 = arith.addf %109, %110 : f32
            %112 = memref.load %arg14[%102] : memref<?xf32>
            %113 = arith.addf %111, %112 : f32
            %114 = memref.load %arg14[%101] : memref<?xf32>
            %115 = arith.addf %113, %114 : f32
            %116 = arith.mulf %115, %cst : f32
            %117 = arith.mulf %116, %116 : f32
            %118 = arith.addf %108, %117 : f32
            %119 = math.sqrt %118 : f32
            %120 = arith.mulf %106, %119 : f32
            memref.store %120, %arg11[%95] : memref<?xf32>
            %121 = memref.load %arg2[%96] : memref<?xf32>
            %122 = memref.load %arg8[%97] : memref<?xf32>
            %123 = arith.mulf %121, %122 : f32
            %124 = memref.load %arg10[%96] : memref<?xf32>
            %125 = arith.subf %123, %124 : f32
            %126 = memref.load %arg11[%95] : memref<?xf32>
            %127 = arith.mulf %126, %51 : f32
            %128 = memref.load %arg17[%95] : memref<?xf32>
            %129 = arith.mulf %61, %128 : f32
            %130 = arith.divf %127, %129 : f32
            %131 = arith.subf %130, %cst_1 : f32
            %132 = memref.load %arg7[%97] : memref<?xf32>
            %133 = arith.subf %132, %cst_1 : f32
            %134 = arith.mulf %133, %121 : f32
            %135 = arith.subf %131, %134 : f32
            %136 = arith.divf %125, %135 : f32
            memref.store %136, %arg10[%96] : memref<?xf32>
            %137 = memref.load %arg10[%96] : memref<?xf32>
            %138 = memref.load %arg15[%95] : memref<?xf32>
            %139 = arith.mulf %137, %138 : f32
            memref.store %139, %arg10[%96] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      }
      scf.for %arg18 = %c1 to %78 step %c1 {
        %92 = arith.index_cast %arg18 : index to i32
        %93 = arith.muli %92, %80 : i32
        %94 = arith.muli %arg18, %89 : index
        scf.for %arg19 = %c1 to %83 step %c1 {
          %95 = arith.index_cast %arg19 : index to i32
          %96 = arith.addi %95, %93 : i32
          %97 = arith.addi %96, %85 : i32
          %98 = arith.index_cast %97 : i32 to index
          %99 = memref.load %arg7[%98] : memref<?xf32>
          %100 = arith.addi %96, %88 : i32
          %101 = arith.index_cast %100 : i32 to index
          %102 = memref.load %arg10[%101] : memref<?xf32>
          %103 = arith.mulf %99, %102 : f32
          %104 = memref.load %arg8[%98] : memref<?xf32>
          %105 = arith.addf %103, %104 : f32
          %106 = arith.addi %arg19, %94 : index
          %107 = memref.load %arg15[%106] : memref<?xf32>
          %108 = arith.mulf %105, %107 : f32
          memref.store %108, %arg10[%98] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %91 = arith.addi %81, %c-1_i32 : i32
      memref.store %91, %alloca[] : memref<i32>
      scf.yield
    }
    %65 = memref.load %46[%c0] : memref<1xi32>
    %66 = arith.index_cast %65 : i32 to index
    %67 = memref.load %47[%c0] : memref<1xi32>
    %68 = memref.load %4[%c0] : memref<1xi32>
    %69 = memref.load %15[%c0] : memref<1xi32>
    %70 = memref.load %1[%c0] : memref<1xi32>
    %71 = arith.index_cast %67 : i32 to index
    %72 = arith.index_cast %68 : i32 to index
    %73 = arith.index_cast %69 : i32 to index
    %74 = arith.muli %73, %72 : index
    %75 = arith.index_cast %70 : i32 to index
    %76 = arith.muli %74, %75 : index
    %reinterpret_cast_16 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%66, %72], strides: [%72, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%66, %72], strides: [%72, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%66, %71) step (%c1, %c1) {
      %77 = memref.load %reinterpret_cast_16[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %78 = arith.negf %77 : f32
      %79 = arith.muli %arg18, %72 overflow<nsw> : index
      %80 = arith.addi %arg19, %79 : index
      %81 = arith.addi %80, %76 : index
      %82 = memref.load %arg10[%81] : memref<?xf32>
      %83 = arith.mulf %78, %82 : f32
      memref.store %83, %reinterpret_cast_17[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


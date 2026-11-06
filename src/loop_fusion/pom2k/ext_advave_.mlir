module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @mode : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advave_(%arg0: memref<?xf32> {polygeist.name = "curv2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "aam2d", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c-1 = arith.constant -1 : index
    %c2 = arith.constant 2 : index
    %cst = arith.constant -5.000000e-01 : f32
    %c2_i32 = arith.constant 2 : i32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 2.000000e+00 : f32
    %cst_2 = arith.constant 1.250000e-01 : f32
    %cst_3 = arith.constant 0.000000e+00 : f32
    %c1 = arith.constant 1 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = memref.get_global @imm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.get_global @jmm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %12 = arith.maxsi %8, %5 : index
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%2, %12) step (%c1, %c1) {
      %17 = arith.subi %5, %arg20 : index
      %18 = arith.addi %17, %c-1 : index
      %19 = arith.cmpi sge, %18, %c0 : index
      scf.if %19 {
        memref.store %cst_3, %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      %20 = arith.addi %arg19, %c-1 : index
      %21 = arith.cmpi sge, %20, %c0 : index
      %22 = arith.addi %arg20, %c-1 : index
      %23 = arith.cmpi sge, %22, %c0 : index
      %24 = arith.andi %21, %23 : i1
      %25 = arith.subi %8, %arg20 : index
      %26 = arith.addi %25, %c-1 : index
      %27 = arith.cmpi sge, %26, %c0 : index
      %28 = arith.andi %24, %27 : i1
      scf.if %28 {
        %29 = arith.muli %arg19, %5 overflow<nsw> : index
        %30 = arith.addi %arg20, %29 : index
        %31 = arith.addi %30, %c1 : index
        %32 = memref.load %arg11[%31] : memref<?xf32>
        %33 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %34 = arith.addf %32, %33 : f32
        %35 = memref.load %arg5[%31] : memref<?xf32>
        %36 = arith.mulf %34, %35 : f32
        %37 = arith.addi %30, %c-1 : index
        %38 = memref.load %arg11[%37] : memref<?xf32>
        %39 = arith.addf %33, %38 : f32
        %40 = memref.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %41 = arith.mulf %39, %40 : f32
        %42 = arith.addf %36, %41 : f32
        %43 = arith.mulf %42, %cst_2 : f32
        %44 = arith.addf %35, %40 : f32
        %45 = arith.mulf %43, %44 : f32
        memref.store %45, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    %reinterpret_cast_7 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %12) step (%c1, %c1) {
      %17 = arith.subi %5, %arg20 : index
      %18 = arith.addi %17, %c-1 : index
      %19 = arith.cmpi sge, %18, %c0 : index
      scf.if %19 {
        %23 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %24 = arith.addi %arg19, %c-1 : index
        %25 = memref.load %reinterpret_cast_4[%24, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %26 = arith.addf %23, %25 : f32
        %27 = memref.load %reinterpret_cast_7[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %28 = arith.mulf %26, %27 : f32
        %29 = arith.muli %arg19, %5 overflow<nsw> : index
        %30 = arith.addi %arg20, %29 : index
        %31 = arith.addi %30, %c-1 : index
        %32 = memref.load %arg11[%31] : memref<?xf32>
        %33 = arith.muli %24, %5 overflow<nsw> : index
        %34 = arith.addi %arg20, %33 : index
        %35 = arith.addi %34, %c-1 : index
        %36 = memref.load %arg11[%35] : memref<?xf32>
        %37 = arith.addf %32, %36 : f32
        %38 = memref.load %arg6[%31] : memref<?xf32>
        %39 = arith.mulf %37, %38 : f32
        %40 = arith.addf %28, %39 : f32
        %41 = arith.mulf %40, %cst_2 : f32
        %42 = memref.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %43 = memref.load %reinterpret_cast_5[%24, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %44 = arith.addf %42, %43 : f32
        %45 = arith.mulf %41, %44 : f32
        memref.store %45, %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      %20 = arith.subi %8, %arg20 : index
      %21 = arith.addi %20, %c-1 : index
      %22 = arith.cmpi sge, %21, %c0 : index
      scf.if %22 {
        %23 = memref.load %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %24 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %25 = arith.mulf %24, %cst_1 : f32
        %26 = memref.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %27 = arith.mulf %25, %26 : f32
        %28 = arith.muli %arg19, %5 overflow<nsw> : index
        %29 = arith.addi %arg20, %28 : index
        %30 = arith.addi %29, %c1 : index
        %31 = memref.load %arg7[%30] : memref<?xf32>
        %32 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %33 = arith.subf %31, %32 : f32
        %34 = arith.mulf %27, %33 : f32
        %35 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %36 = arith.divf %34, %35 : f32
        %37 = arith.subf %23, %36 : f32
        memref.store %37, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    %reinterpret_cast_12 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %5) step (%c1, %c1) {
      %17 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %18 = arith.muli %arg19, %5 overflow<nsw> : index
      %19 = arith.addi %arg20, %18 : index
      %20 = arith.addi %19, %c-1 : index
      %21 = memref.load %arg11[%20] : memref<?xf32>
      %22 = arith.addf %17, %21 : f32
      %23 = arith.addi %arg19, %c-1 : index
      %24 = memref.load %reinterpret_cast_4[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %25 = arith.addf %22, %24 : f32
      %26 = arith.muli %23, %5 overflow<nsw> : index
      %27 = arith.addi %arg20, %26 : index
      %28 = arith.addi %27, %c-1 : index
      %29 = memref.load %arg11[%28] : memref<?xf32>
      %30 = arith.addf %25, %29 : f32
      %31 = arith.mulf %30, %cst_0 : f32
      %32 = memref.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %33 = memref.load %reinterpret_cast_9[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %34 = arith.addf %32, %33 : f32
      %35 = memref.load %arg16[%20] : memref<?xf32>
      %36 = arith.addf %34, %35 : f32
      %37 = memref.load %arg16[%28] : memref<?xf32>
      %38 = arith.addf %36, %37 : f32
      %39 = arith.mulf %31, %38 : f32
      %40 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %41 = memref.load %reinterpret_cast_10[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %42 = arith.subf %40, %41 : f32
      %43 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %44 = memref.load %arg13[%20] : memref<?xf32>
      %45 = arith.addf %43, %44 : f32
      %46 = memref.load %reinterpret_cast_12[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %47 = arith.addf %45, %46 : f32
      %48 = memref.load %arg13[%28] : memref<?xf32>
      %49 = arith.addf %47, %48 : f32
      %50 = arith.divf %42, %49 : f32
      %51 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %52 = memref.load %arg8[%20] : memref<?xf32>
      %53 = arith.subf %51, %52 : f32
      %54 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %55 = memref.load %arg12[%20] : memref<?xf32>
      %56 = arith.addf %54, %55 : f32
      %57 = memref.load %reinterpret_cast_11[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %58 = arith.addf %56, %57 : f32
      %59 = memref.load %arg12[%28] : memref<?xf32>
      %60 = arith.addf %58, %59 : f32
      %61 = arith.divf %53, %60 : f32
      %62 = arith.addf %50, %61 : f32
      %63 = arith.mulf %39, %62 : f32
      memref.store %63, %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = memref.load %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %65 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %66 = arith.mulf %64, %65 : f32
      memref.store %66, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %67 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %68 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %69 = arith.subf %67, %68 : f32
      %70 = arith.mulf %69, %cst_0 : f32
      %71 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %72 = memref.load %arg12[%20] : memref<?xf32>
      %73 = arith.addf %71, %72 : f32
      %74 = memref.load %reinterpret_cast_11[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %75 = arith.addf %73, %74 : f32
      %76 = memref.load %arg12[%28] : memref<?xf32>
      %77 = arith.addf %75, %76 : f32
      %78 = arith.mulf %70, %77 : f32
      memref.store %78, %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_15 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %13 = arith.maxsi %2, %11 : index
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%13, %12) step (%c1, %c1) {
      %17 = arith.addi %arg19, %c-1 : index
      %18 = arith.cmpi sge, %17, %c0 : index
      %19 = arith.subi %11, %arg19 : index
      %20 = arith.addi %19, %c-1 : index
      %21 = arith.cmpi sge, %20, %c0 : index
      %22 = arith.andi %18, %21 : i1
      %23 = arith.addi %arg20, %c-1 : index
      %24 = arith.cmpi sge, %23, %c0 : index
      %25 = arith.andi %22, %24 : i1
      %26 = arith.subi %8, %arg20 : index
      %27 = arith.addi %26, %c-1 : index
      %28 = arith.cmpi sge, %27, %c0 : index
      %29 = arith.andi %25, %28 : i1
      scf.if %29 {
        %37 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.muli %arg19, %5 overflow<nsw> : index
        %39 = arith.addi %arg20, %38 : index
        %40 = arith.addi %39, %c-1 : index
        %41 = memref.load %arg3[%40] : memref<?xf32>
        %42 = arith.subf %37, %41 : f32
        %43 = arith.addi %arg19, %c1 : index
        %44 = memref.load %reinterpret_cast_16[%43, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %45 = arith.addf %42, %44 : f32
        %46 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %47 = arith.subf %45, %46 : f32
        memref.store %47, %reinterpret_cast_17[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      %30 = arith.subi %2, %arg19 : index
      %31 = arith.addi %30, %c-1 : index
      %32 = arith.cmpi sge, %31, %c0 : index
      %33 = arith.subi %5, %arg20 : index
      %34 = arith.addi %33, %c-1 : index
      %35 = arith.cmpi sge, %34, %c0 : index
      %36 = arith.andi %32, %35 : i1
      scf.if %36 {
        memref.store %cst_3, %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    %reinterpret_cast_19 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%13, %5) step (%c1, %c1) {
      %17 = arith.subi %2, %arg19 : index
      %18 = arith.addi %17, %c-1 : index
      %19 = arith.cmpi sge, %18, %c0 : index
      scf.if %19 {
        %23 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %24 = arith.muli %arg19, %5 overflow<nsw> : index
        %25 = arith.addi %arg20, %24 : index
        %26 = arith.addi %25, %c-1 : index
        %27 = memref.load %arg11[%26] : memref<?xf32>
        %28 = arith.addf %23, %27 : f32
        %29 = memref.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %30 = arith.mulf %28, %29 : f32
        %31 = arith.addi %arg19, %c-1 : index
        %32 = memref.load %reinterpret_cast_4[%31, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %33 = arith.muli %31, %5 overflow<nsw> : index
        %34 = arith.addi %arg20, %33 : index
        %35 = arith.addi %34, %c-1 : index
        %36 = memref.load %arg11[%35] : memref<?xf32>
        %37 = arith.addf %32, %36 : f32
        %38 = memref.load %reinterpret_cast_5[%31, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %39 = arith.mulf %37, %38 : f32
        %40 = arith.addf %30, %39 : f32
        %41 = arith.mulf %40, %cst_2 : f32
        %42 = memref.load %arg6[%26] : memref<?xf32>
        %43 = memref.load %reinterpret_cast_7[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %44 = arith.addf %42, %43 : f32
        %45 = arith.mulf %41, %44 : f32
        memref.store %45, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      %20 = arith.subi %11, %arg19 : index
      %21 = arith.addi %20, %c-1 : index
      %22 = arith.cmpi sge, %21, %c0 : index
      scf.if %22 {
        %23 = arith.addi %arg19, %c1 : index
        %24 = memref.load %reinterpret_cast_19[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %25 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %26 = arith.addf %24, %25 : f32
        %27 = memref.load %reinterpret_cast_20[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %28 = arith.mulf %26, %27 : f32
        %29 = arith.addi %arg19, %c-1 : index
        %30 = memref.load %reinterpret_cast_19[%29, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %31 = arith.addf %25, %30 : f32
        %32 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %33 = arith.mulf %31, %32 : f32
        %34 = arith.addf %28, %33 : f32
        %35 = arith.mulf %34, %cst_2 : f32
        %36 = arith.addf %27, %32 : f32
        %37 = arith.mulf %35, %36 : f32
        memref.store %37, %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    %reinterpret_cast_21 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%11, %5) step (%c1, %c1) {
      %17 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %18 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %19 = arith.mulf %18, %cst_1 : f32
      %20 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %21 = arith.mulf %19, %20 : f32
      %22 = arith.addi %arg19, %c1 : index
      %23 = memref.load %reinterpret_cast_22[%22, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %24 = memref.load %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %25 = arith.subf %23, %24 : f32
      %26 = arith.mulf %21, %25 : f32
      %27 = memref.load %reinterpret_cast_23[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %28 = arith.divf %26, %27 : f32
      %29 = arith.subf %17, %28 : f32
      memref.store %29, %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %5) step (%c1, %c1) {
      %17 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %18 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %19 = arith.mulf %17, %18 : f32
      memref.store %19, %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %20 = memref.load %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %21 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %22 = arith.subf %20, %21 : f32
      %23 = arith.mulf %22, %cst_0 : f32
      %24 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %25 = arith.muli %arg19, %5 overflow<nsw> : index
      %26 = arith.addi %arg20, %25 : index
      %27 = arith.addi %26, %c-1 : index
      %28 = memref.load %arg13[%27] : memref<?xf32>
      %29 = arith.addf %24, %28 : f32
      %30 = arith.addi %arg19, %c-1 : index
      %31 = memref.load %reinterpret_cast_12[%30, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.addf %29, %31 : f32
      %33 = arith.muli %30, %5 overflow<nsw> : index
      %34 = arith.addi %arg20, %33 : index
      %35 = arith.addi %34, %c-1 : index
      %36 = memref.load %arg13[%35] : memref<?xf32>
      %37 = arith.addf %32, %36 : f32
      %38 = arith.mulf %23, %37 : f32
      memref.store %38, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_24 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%11, %8) step (%c1, %c1) {
      %17 = arith.muli %arg19, %5 overflow<nsw> : index
      %18 = arith.addi %arg20, %17 : index
      %19 = arith.addi %18, %c1 : index
      %20 = memref.load %arg3[%19] : memref<?xf32>
      %21 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %22 = arith.subf %20, %21 : f32
      %23 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %24 = arith.addf %22, %23 : f32
      %25 = arith.addi %arg19, %c-1 : index
      %26 = memref.load %reinterpret_cast_16[%25, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %27 = arith.subf %24, %26 : f32
      memref.store %27, %reinterpret_cast_24[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %14 = memref.get_global @mode : memref<1xi32>
    %15 = memref.load %14[%c0] : memref<1xi32>
    %16 = arith.cmpi eq, %15, %c2_i32 : i32
    scf.if %16 {
      %17 = memref.load %9[%c0] : memref<1xi32>
      %18 = arith.index_cast %17 : i32 to index
      %19 = memref.load %6[%c0] : memref<1xi32>
      %20 = memref.load %3[%c0] : memref<1xi32>
      %21 = arith.index_cast %19 : i32 to index
      %22 = arith.index_cast %20 : i32 to index
      scf.for %arg19 = %c1 to %18 step %c1 {
        %47 = arith.muli %arg19, %22 : index
        %48 = arith.addi %arg19, %c1 : index
        %49 = arith.muli %48, %22 : index
        scf.for %arg20 = %c1 to %21 step %c1 {
          %50 = arith.addi %arg20, %47 : index
          %51 = memref.load %arg18[%50] : memref<?xf32>
          %52 = arith.addi %arg20, %c-1 : index
          %53 = arith.addi %52, %47 : index
          %54 = memref.load %arg18[%53] : memref<?xf32>
          %55 = arith.addf %51, %54 : f32
          %56 = arith.mulf %55, %cst : f32
          %57 = memref.load %arg7[%50] : memref<?xf32>
          %58 = arith.mulf %57, %57 : f32
          %59 = memref.load %arg8[%50] : memref<?xf32>
          %60 = arith.addi %arg20, %49 : index
          %61 = memref.load %arg8[%60] : memref<?xf32>
          %62 = arith.addf %59, %61 : f32
          %63 = memref.load %arg8[%53] : memref<?xf32>
          %64 = arith.addf %62, %63 : f32
          %65 = arith.addi %52, %49 : index
          %66 = memref.load %arg8[%65] : memref<?xf32>
          %67 = arith.addf %64, %66 : f32
          %68 = arith.mulf %67, %cst_0 : f32
          %69 = arith.mulf %68, %68 : f32
          %70 = arith.addf %58, %69 : f32
          %71 = math.sqrt %70 : f32
          %72 = arith.mulf %56, %71 : f32
          %73 = arith.mulf %72, %57 : f32
          memref.store %73, %arg9[%50] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %23 = memref.load %9[%c0] : memref<1xi32>
      %24 = arith.index_cast %23 : i32 to index
      %25 = memref.load %6[%c0] : memref<1xi32>
      %26 = memref.load %3[%c0] : memref<1xi32>
      %27 = arith.index_cast %25 : i32 to index
      %28 = arith.index_cast %26 : i32 to index
      scf.for %arg19 = %c1 to %24 step %c1 {
        %47 = arith.muli %arg19, %28 : index
        %48 = arith.addi %arg19, %c-1 : index
        %49 = arith.muli %48, %28 : index
        scf.for %arg20 = %c1 to %27 step %c1 {
          %50 = arith.addi %arg20, %47 : index
          %51 = memref.load %arg18[%50] : memref<?xf32>
          %52 = arith.addi %arg20, %49 : index
          %53 = memref.load %arg18[%52] : memref<?xf32>
          %54 = arith.addf %51, %53 : f32
          %55 = arith.mulf %54, %cst : f32
          %56 = memref.load %arg8[%50] : memref<?xf32>
          %57 = arith.mulf %56, %56 : f32
          %58 = memref.load %arg7[%50] : memref<?xf32>
          %59 = arith.addi %arg20, %c1 : index
          %60 = arith.addi %59, %47 : index
          %61 = memref.load %arg7[%60] : memref<?xf32>
          %62 = arith.addf %58, %61 : f32
          %63 = memref.load %arg7[%52] : memref<?xf32>
          %64 = arith.addf %62, %63 : f32
          %65 = arith.addi %59, %49 : index
          %66 = memref.load %arg7[%65] : memref<?xf32>
          %67 = arith.addf %64, %66 : f32
          %68 = arith.mulf %67, %cst_0 : f32
          %69 = arith.mulf %68, %68 : f32
          %70 = arith.addf %57, %69 : f32
          %71 = math.sqrt %70 : f32
          %72 = arith.mulf %55, %71 : f32
          %73 = arith.mulf %72, %56 : f32
          memref.store %73, %arg10[%50] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %29 = memref.load %9[%c0] : memref<1xi32>
      %30 = arith.index_cast %29 : i32 to index
      %31 = memref.load %6[%c0] : memref<1xi32>
      %32 = memref.load %3[%c0] : memref<1xi32>
      %33 = arith.index_cast %31 : i32 to index
      %34 = arith.index_cast %32 : i32 to index
      scf.for %arg19 = %c1 to %30 step %c1 {
        %47 = arith.muli %arg19, %34 : index
        %48 = arith.addi %arg19, %c1 : index
        %49 = arith.muli %48, %34 : index
        %50 = arith.addi %arg19, %c-1 : index
        %51 = arith.muli %50, %34 : index
        scf.for %arg20 = %c1 to %33 step %c1 {
          %52 = arith.addi %arg20, %47 : index
          %53 = arith.addi %arg20, %49 : index
          %54 = memref.load %arg6[%53] : memref<?xf32>
          %55 = memref.load %arg6[%52] : memref<?xf32>
          %56 = arith.addf %54, %55 : f32
          %57 = arith.addi %arg20, %c1 : index
          %58 = arith.addi %57, %47 : index
          %59 = memref.load %arg13[%58] : memref<?xf32>
          %60 = arith.addi %arg20, %c-1 : index
          %61 = arith.addi %60, %47 : index
          %62 = memref.load %arg13[%61] : memref<?xf32>
          %63 = arith.subf %59, %62 : f32
          %64 = arith.mulf %56, %63 : f32
          %65 = memref.load %arg5[%58] : memref<?xf32>
          %66 = memref.load %arg5[%52] : memref<?xf32>
          %67 = arith.addf %65, %66 : f32
          %68 = memref.load %arg12[%53] : memref<?xf32>
          %69 = arith.addi %arg20, %51 : index
          %70 = memref.load %arg12[%69] : memref<?xf32>
          %71 = arith.subf %68, %70 : f32
          %72 = arith.mulf %67, %71 : f32
          %73 = arith.subf %64, %72 : f32
          %74 = arith.mulf %73, %cst_0 : f32
          %75 = memref.load %arg12[%52] : memref<?xf32>
          %76 = memref.load %arg13[%52] : memref<?xf32>
          %77 = arith.mulf %75, %76 : f32
          %78 = arith.divf %74, %77 : f32
          memref.store %78, %arg0[%52] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %35 = memref.load %9[%c0] : memref<1xi32>
      %36 = arith.index_cast %35 : i32 to index
      %37 = memref.load %6[%c0] : memref<1xi32>
      %38 = memref.load %3[%c0] : memref<1xi32>
      %39 = arith.index_cast %37 : i32 to index
      %40 = arith.index_cast %38 : i32 to index
      scf.for %arg19 = %c1 to %36 step %c1 {
        %47 = arith.muli %arg19, %40 : index
        %48 = arith.addi %arg19, %c1 : index
        %49 = arith.muli %48, %40 : index
        scf.for %arg20 = %c2 to %39 step %c1 {
          %50 = arith.addi %arg20, %47 : index
          %51 = memref.load %arg1[%50] : memref<?xf32>
          %52 = memref.load %arg14[%50] : memref<?xf32>
          %53 = arith.mulf %52, %cst_0 : f32
          %54 = memref.load %arg0[%50] : memref<?xf32>
          %55 = memref.load %arg11[%50] : memref<?xf32>
          %56 = arith.mulf %54, %55 : f32
          %57 = arith.addi %arg20, %49 : index
          %58 = memref.load %arg6[%57] : memref<?xf32>
          %59 = memref.load %arg6[%50] : memref<?xf32>
          %60 = arith.addf %58, %59 : f32
          %61 = arith.mulf %56, %60 : f32
          %62 = arith.addi %arg20, %c-1 : index
          %63 = arith.addi %62, %47 : index
          %64 = memref.load %arg0[%63] : memref<?xf32>
          %65 = memref.load %arg11[%63] : memref<?xf32>
          %66 = arith.mulf %64, %65 : f32
          %67 = arith.addi %62, %49 : index
          %68 = memref.load %arg6[%67] : memref<?xf32>
          %69 = memref.load %arg6[%63] : memref<?xf32>
          %70 = arith.addf %68, %69 : f32
          %71 = arith.mulf %66, %70 : f32
          %72 = arith.addf %61, %71 : f32
          %73 = arith.mulf %53, %72 : f32
          %74 = arith.subf %51, %73 : f32
          memref.store %74, %arg1[%50] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %41 = memref.load %9[%c0] : memref<1xi32>
      %42 = arith.index_cast %41 : i32 to index
      %43 = memref.load %6[%c0] : memref<1xi32>
      %44 = memref.load %3[%c0] : memref<1xi32>
      %45 = arith.index_cast %43 : i32 to index
      %46 = arith.index_cast %44 : i32 to index
      scf.for %arg19 = %c2 to %42 step %c1 {
        %47 = arith.muli %arg19, %46 : index
        %48 = arith.addi %arg19, %c-1 : index
        %49 = arith.muli %48, %46 : index
        scf.for %arg20 = %c1 to %45 step %c1 {
          %50 = arith.addi %arg20, %47 : index
          %51 = memref.load %arg2[%50] : memref<?xf32>
          %52 = memref.load %arg15[%50] : memref<?xf32>
          %53 = arith.mulf %52, %cst_0 : f32
          %54 = memref.load %arg0[%50] : memref<?xf32>
          %55 = memref.load %arg11[%50] : memref<?xf32>
          %56 = arith.mulf %54, %55 : f32
          %57 = arith.addi %arg20, %c1 : index
          %58 = arith.addi %57, %47 : index
          %59 = memref.load %arg5[%58] : memref<?xf32>
          %60 = memref.load %arg5[%50] : memref<?xf32>
          %61 = arith.addf %59, %60 : f32
          %62 = arith.mulf %56, %61 : f32
          %63 = arith.addi %arg20, %49 : index
          %64 = memref.load %arg0[%63] : memref<?xf32>
          %65 = memref.load %arg11[%63] : memref<?xf32>
          %66 = arith.mulf %64, %65 : f32
          %67 = arith.addi %57, %49 : index
          %68 = memref.load %arg5[%67] : memref<?xf32>
          %69 = memref.load %arg5[%63] : memref<?xf32>
          %70 = arith.addf %68, %69 : f32
          %71 = arith.mulf %66, %70 : f32
          %72 = arith.addf %62, %71 : f32
          %73 = arith.mulf %53, %72 : f32
          %74 = arith.addf %51, %73 : f32
          memref.store %74, %arg2[%50] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    }
    return
  }
}


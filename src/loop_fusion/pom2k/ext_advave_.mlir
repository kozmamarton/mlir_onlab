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
    scf.parallel (%arg19) = (%c0) to (%2) step (%c1) {
      scf.parallel (%arg20) = (%c0) to (%5) step (%c1) {
        memref.store %cst_3, %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      }
      %15 = arith.addi %arg19, %c-1 : index
      %16 = arith.cmpi sge, %15, %c0 : index
      scf.if %16 {
        scf.parallel (%arg20) = (%c1) to (%8) step (%c1) {
          %17 = arith.muli %arg19, %5 overflow<nsw> : index
          %18 = arith.addi %arg20, %17 : index
          %19 = arith.addi %18, %c1 : index
          %20 = memref.load %arg11[%19] : memref<?xf32>
          %21 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %22 = arith.addf %20, %21 : f32
          %23 = memref.load %arg5[%19] : memref<?xf32>
          %24 = arith.mulf %22, %23 : f32
          %25 = arith.addi %18, %c-1 : index
          %26 = memref.load %arg11[%25] : memref<?xf32>
          %27 = arith.addf %21, %26 : f32
          %28 = memref.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %29 = arith.mulf %27, %28 : f32
          %30 = arith.addf %24, %29 : f32
          %31 = arith.mulf %30, %cst_2 : f32
          %32 = arith.addf %23, %28 : f32
          %33 = arith.mulf %31, %32 : f32
          memref.store %33, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          scf.reduce 
        }
      }
      scf.reduce 
    }
    %reinterpret_cast_7 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19) = (%c1) to (%2) step (%c1) {
      scf.parallel (%arg20) = (%c1) to (%5) step (%c1) {
        %15 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %16 = arith.addi %arg19, %c-1 : index
        %17 = memref.load %reinterpret_cast_4[%16, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %18 = arith.addf %15, %17 : f32
        %19 = memref.load %reinterpret_cast_7[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %20 = arith.mulf %18, %19 : f32
        %21 = arith.muli %arg19, %5 overflow<nsw> : index
        %22 = arith.addi %arg20, %21 : index
        %23 = arith.addi %22, %c-1 : index
        %24 = memref.load %arg11[%23] : memref<?xf32>
        %25 = arith.muli %16, %5 overflow<nsw> : index
        %26 = arith.addi %arg20, %25 : index
        %27 = arith.addi %26, %c-1 : index
        %28 = memref.load %arg11[%27] : memref<?xf32>
        %29 = arith.addf %24, %28 : f32
        %30 = memref.load %arg6[%23] : memref<?xf32>
        %31 = arith.mulf %29, %30 : f32
        %32 = arith.addf %20, %31 : f32
        %33 = arith.mulf %32, %cst_2 : f32
        %34 = memref.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %35 = memref.load %reinterpret_cast_5[%16, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %36 = arith.addf %34, %35 : f32
        %37 = arith.mulf %33, %36 : f32
        memref.store %37, %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      }
      scf.parallel (%arg20) = (%c1) to (%8) step (%c1) {
        %15 = memref.load %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %16 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %17 = arith.mulf %16, %cst_1 : f32
        %18 = memref.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %19 = arith.mulf %17, %18 : f32
        %20 = arith.muli %arg19, %5 overflow<nsw> : index
        %21 = arith.addi %arg20, %20 : index
        %22 = arith.addi %21, %c1 : index
        %23 = memref.load %arg7[%22] : memref<?xf32>
        %24 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %25 = arith.subf %23, %24 : f32
        %26 = arith.mulf %19, %25 : f32
        %27 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %28 = arith.divf %26, %27 : f32
        %29 = arith.subf %15, %28 : f32
        memref.store %29, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      }
      scf.reduce 
    }
    %reinterpret_cast_12 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %5) step (%c1, %c1) {
      %15 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %16 = arith.muli %arg19, %5 overflow<nsw> : index
      %17 = arith.addi %arg20, %16 : index
      %18 = arith.addi %17, %c-1 : index
      %19 = memref.load %arg11[%18] : memref<?xf32>
      %20 = arith.addf %15, %19 : f32
      %21 = arith.addi %arg19, %c-1 : index
      %22 = memref.load %reinterpret_cast_4[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %23 = arith.addf %20, %22 : f32
      %24 = arith.muli %21, %5 overflow<nsw> : index
      %25 = arith.addi %arg20, %24 : index
      %26 = arith.addi %25, %c-1 : index
      %27 = memref.load %arg11[%26] : memref<?xf32>
      %28 = arith.addf %23, %27 : f32
      %29 = arith.mulf %28, %cst_0 : f32
      %30 = memref.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %31 = memref.load %reinterpret_cast_9[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.addf %30, %31 : f32
      %33 = memref.load %arg16[%18] : memref<?xf32>
      %34 = arith.addf %32, %33 : f32
      %35 = memref.load %arg16[%26] : memref<?xf32>
      %36 = arith.addf %34, %35 : f32
      %37 = arith.mulf %29, %36 : f32
      %38 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %39 = memref.load %reinterpret_cast_10[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %40 = arith.subf %38, %39 : f32
      %41 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %42 = memref.load %arg13[%18] : memref<?xf32>
      %43 = arith.addf %41, %42 : f32
      %44 = memref.load %reinterpret_cast_12[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %45 = arith.addf %43, %44 : f32
      %46 = memref.load %arg13[%26] : memref<?xf32>
      %47 = arith.addf %45, %46 : f32
      %48 = arith.divf %40, %47 : f32
      %49 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %50 = memref.load %arg8[%18] : memref<?xf32>
      %51 = arith.subf %49, %50 : f32
      %52 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %53 = memref.load %arg12[%18] : memref<?xf32>
      %54 = arith.addf %52, %53 : f32
      %55 = memref.load %reinterpret_cast_11[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %56 = arith.addf %54, %55 : f32
      %57 = memref.load %arg12[%26] : memref<?xf32>
      %58 = arith.addf %56, %57 : f32
      %59 = arith.divf %51, %58 : f32
      %60 = arith.addf %48, %59 : f32
      %61 = arith.mulf %37, %60 : f32
      memref.store %61, %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %62 = memref.load %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %63 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = arith.mulf %62, %63 : f32
      memref.store %64, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %65 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %66 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %67 = arith.subf %65, %66 : f32
      %68 = arith.mulf %67, %cst_0 : f32
      %69 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %70 = memref.load %arg12[%18] : memref<?xf32>
      %71 = arith.addf %69, %70 : f32
      %72 = memref.load %reinterpret_cast_11[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %73 = arith.addf %71, %72 : f32
      %74 = memref.load %arg12[%26] : memref<?xf32>
      %75 = arith.addf %73, %74 : f32
      %76 = arith.mulf %68, %75 : f32
      memref.store %76, %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_15 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%11, %8) step (%c1, %c1) {
      %15 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %16 = arith.muli %arg19, %5 overflow<nsw> : index
      %17 = arith.addi %arg20, %16 : index
      %18 = arith.addi %17, %c-1 : index
      %19 = memref.load %arg3[%18] : memref<?xf32>
      %20 = arith.subf %15, %19 : f32
      %21 = arith.addi %arg19, %c1 : index
      %22 = memref.load %reinterpret_cast_16[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %23 = arith.addf %20, %22 : f32
      %24 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %25 = arith.subf %23, %24 : f32
      memref.store %25, %reinterpret_cast_17[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19) = (%c0) to (%2) step (%c1) {
      scf.parallel (%arg20) = (%c0) to (%5) step (%c1) {
        memref.store %cst_3, %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      }
      %15 = arith.addi %arg19, %c-1 : index
      %16 = arith.cmpi sge, %15, %c0 : index
      scf.if %16 {
        scf.parallel (%arg20) = (%c1) to (%5) step (%c1) {
          %17 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %18 = arith.muli %arg19, %5 overflow<nsw> : index
          %19 = arith.addi %arg20, %18 : index
          %20 = arith.addi %19, %c-1 : index
          %21 = memref.load %arg11[%20] : memref<?xf32>
          %22 = arith.addf %17, %21 : f32
          %23 = memref.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %24 = arith.mulf %22, %23 : f32
          %25 = memref.load %reinterpret_cast_4[%15, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %26 = arith.muli %15, %5 overflow<nsw> : index
          %27 = arith.addi %arg20, %26 : index
          %28 = arith.addi %27, %c-1 : index
          %29 = memref.load %arg11[%28] : memref<?xf32>
          %30 = arith.addf %25, %29 : f32
          %31 = memref.load %reinterpret_cast_5[%15, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %32 = arith.mulf %30, %31 : f32
          %33 = arith.addf %24, %32 : f32
          %34 = arith.mulf %33, %cst_2 : f32
          %35 = memref.load %arg6[%20] : memref<?xf32>
          %36 = memref.load %reinterpret_cast_7[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %37 = arith.addf %35, %36 : f32
          %38 = arith.mulf %34, %37 : f32
          memref.store %38, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          scf.reduce 
        }
      }
      scf.reduce 
    }
    %reinterpret_cast_19 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%11, %5) step (%c1, %c1) {
      %15 = arith.addi %arg19, %c1 : index
      %16 = memref.load %reinterpret_cast_19[%15, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %17 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %18 = arith.addf %16, %17 : f32
      %19 = memref.load %reinterpret_cast_20[%15, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %20 = arith.mulf %18, %19 : f32
      %21 = arith.addi %arg19, %c-1 : index
      %22 = memref.load %reinterpret_cast_19[%21, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %23 = arith.addf %17, %22 : f32
      %24 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %25 = arith.mulf %23, %24 : f32
      %26 = arith.addf %20, %25 : f32
      %27 = arith.mulf %26, %cst_2 : f32
      %28 = arith.addf %19, %24 : f32
      %29 = arith.mulf %27, %28 : f32
      memref.store %29, %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %30 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %31 = arith.mulf %30, %cst_1 : f32
      %32 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %33 = arith.mulf %31, %32 : f32
      %34 = memref.load %reinterpret_cast_22[%15, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %35 = memref.load %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %36 = arith.subf %34, %35 : f32
      %37 = arith.mulf %33, %36 : f32
      %38 = memref.load %reinterpret_cast_23[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.divf %37, %38 : f32
      %40 = arith.subf %29, %39 : f32
      memref.store %40, %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%2, %5) step (%c1, %c1) {
      %15 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %16 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %17 = arith.mulf %15, %16 : f32
      memref.store %17, %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %18 = memref.load %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %19 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %20 = arith.subf %18, %19 : f32
      %21 = arith.mulf %20, %cst_0 : f32
      %22 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %23 = arith.muli %arg19, %5 overflow<nsw> : index
      %24 = arith.addi %arg20, %23 : index
      %25 = arith.addi %24, %c-1 : index
      %26 = memref.load %arg13[%25] : memref<?xf32>
      %27 = arith.addf %22, %26 : f32
      %28 = arith.addi %arg19, %c-1 : index
      %29 = memref.load %reinterpret_cast_12[%28, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.addf %27, %29 : f32
      %31 = arith.muli %28, %5 overflow<nsw> : index
      %32 = arith.addi %arg20, %31 : index
      %33 = arith.addi %32, %c-1 : index
      %34 = memref.load %arg13[%33] : memref<?xf32>
      %35 = arith.addf %30, %34 : f32
      %36 = arith.mulf %21, %35 : f32
      memref.store %36, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_24 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%11, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%11, %8) step (%c1, %c1) {
      %15 = arith.muli %arg19, %5 overflow<nsw> : index
      %16 = arith.addi %arg20, %15 : index
      %17 = arith.addi %16, %c1 : index
      %18 = memref.load %arg3[%17] : memref<?xf32>
      %19 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %20 = arith.subf %18, %19 : f32
      %21 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %22 = arith.addf %20, %21 : f32
      %23 = arith.addi %arg19, %c-1 : index
      %24 = memref.load %reinterpret_cast_16[%23, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %25 = arith.subf %22, %24 : f32
      memref.store %25, %reinterpret_cast_24[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %12 = memref.get_global @mode : memref<1xi32>
    %13 = memref.load %12[%c0] : memref<1xi32>
    %14 = arith.cmpi eq, %13, %c2_i32 : i32
    scf.if %14 {
      %15 = memref.load %9[%c0] : memref<1xi32>
      %16 = arith.index_cast %15 : i32 to index
      %17 = memref.load %6[%c0] : memref<1xi32>
      %18 = memref.load %3[%c0] : memref<1xi32>
      %19 = arith.index_cast %17 : i32 to index
      %20 = arith.index_cast %18 : i32 to index
      scf.for %arg19 = %c1 to %16 step %c1 {
        %45 = arith.muli %arg19, %20 : index
        %46 = arith.addi %arg19, %c1 : index
        %47 = arith.muli %46, %20 : index
        scf.for %arg20 = %c1 to %19 step %c1 {
          %48 = arith.addi %arg20, %45 : index
          %49 = memref.load %arg18[%48] : memref<?xf32>
          %50 = arith.addi %arg20, %c-1 : index
          %51 = arith.addi %50, %45 : index
          %52 = memref.load %arg18[%51] : memref<?xf32>
          %53 = arith.addf %49, %52 : f32
          %54 = arith.mulf %53, %cst : f32
          %55 = memref.load %arg7[%48] : memref<?xf32>
          %56 = arith.mulf %55, %55 : f32
          %57 = memref.load %arg8[%48] : memref<?xf32>
          %58 = arith.addi %arg20, %47 : index
          %59 = memref.load %arg8[%58] : memref<?xf32>
          %60 = arith.addf %57, %59 : f32
          %61 = memref.load %arg8[%51] : memref<?xf32>
          %62 = arith.addf %60, %61 : f32
          %63 = arith.addi %50, %47 : index
          %64 = memref.load %arg8[%63] : memref<?xf32>
          %65 = arith.addf %62, %64 : f32
          %66 = arith.mulf %65, %cst_0 : f32
          %67 = arith.mulf %66, %66 : f32
          %68 = arith.addf %56, %67 : f32
          %69 = math.sqrt %68 : f32
          %70 = arith.mulf %54, %69 : f32
          %71 = arith.mulf %70, %55 : f32
          memref.store %71, %arg9[%48] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %21 = memref.load %9[%c0] : memref<1xi32>
      %22 = arith.index_cast %21 : i32 to index
      %23 = memref.load %6[%c0] : memref<1xi32>
      %24 = memref.load %3[%c0] : memref<1xi32>
      %25 = arith.index_cast %23 : i32 to index
      %26 = arith.index_cast %24 : i32 to index
      scf.for %arg19 = %c1 to %22 step %c1 {
        %45 = arith.muli %arg19, %26 : index
        %46 = arith.addi %arg19, %c-1 : index
        %47 = arith.muli %46, %26 : index
        scf.for %arg20 = %c1 to %25 step %c1 {
          %48 = arith.addi %arg20, %45 : index
          %49 = memref.load %arg18[%48] : memref<?xf32>
          %50 = arith.addi %arg20, %47 : index
          %51 = memref.load %arg18[%50] : memref<?xf32>
          %52 = arith.addf %49, %51 : f32
          %53 = arith.mulf %52, %cst : f32
          %54 = memref.load %arg8[%48] : memref<?xf32>
          %55 = arith.mulf %54, %54 : f32
          %56 = memref.load %arg7[%48] : memref<?xf32>
          %57 = arith.addi %arg20, %c1 : index
          %58 = arith.addi %57, %45 : index
          %59 = memref.load %arg7[%58] : memref<?xf32>
          %60 = arith.addf %56, %59 : f32
          %61 = memref.load %arg7[%50] : memref<?xf32>
          %62 = arith.addf %60, %61 : f32
          %63 = arith.addi %57, %47 : index
          %64 = memref.load %arg7[%63] : memref<?xf32>
          %65 = arith.addf %62, %64 : f32
          %66 = arith.mulf %65, %cst_0 : f32
          %67 = arith.mulf %66, %66 : f32
          %68 = arith.addf %55, %67 : f32
          %69 = math.sqrt %68 : f32
          %70 = arith.mulf %53, %69 : f32
          %71 = arith.mulf %70, %54 : f32
          memref.store %71, %arg10[%48] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %27 = memref.load %9[%c0] : memref<1xi32>
      %28 = arith.index_cast %27 : i32 to index
      %29 = memref.load %6[%c0] : memref<1xi32>
      %30 = memref.load %3[%c0] : memref<1xi32>
      %31 = arith.index_cast %29 : i32 to index
      %32 = arith.index_cast %30 : i32 to index
      scf.for %arg19 = %c1 to %28 step %c1 {
        %45 = arith.muli %arg19, %32 : index
        %46 = arith.addi %arg19, %c1 : index
        %47 = arith.muli %46, %32 : index
        %48 = arith.addi %arg19, %c-1 : index
        %49 = arith.muli %48, %32 : index
        scf.for %arg20 = %c1 to %31 step %c1 {
          %50 = arith.addi %arg20, %45 : index
          %51 = arith.addi %arg20, %47 : index
          %52 = memref.load %arg6[%51] : memref<?xf32>
          %53 = memref.load %arg6[%50] : memref<?xf32>
          %54 = arith.addf %52, %53 : f32
          %55 = arith.addi %arg20, %c1 : index
          %56 = arith.addi %55, %45 : index
          %57 = memref.load %arg13[%56] : memref<?xf32>
          %58 = arith.addi %arg20, %c-1 : index
          %59 = arith.addi %58, %45 : index
          %60 = memref.load %arg13[%59] : memref<?xf32>
          %61 = arith.subf %57, %60 : f32
          %62 = arith.mulf %54, %61 : f32
          %63 = memref.load %arg5[%56] : memref<?xf32>
          %64 = memref.load %arg5[%50] : memref<?xf32>
          %65 = arith.addf %63, %64 : f32
          %66 = memref.load %arg12[%51] : memref<?xf32>
          %67 = arith.addi %arg20, %49 : index
          %68 = memref.load %arg12[%67] : memref<?xf32>
          %69 = arith.subf %66, %68 : f32
          %70 = arith.mulf %65, %69 : f32
          %71 = arith.subf %62, %70 : f32
          %72 = arith.mulf %71, %cst_0 : f32
          %73 = memref.load %arg12[%50] : memref<?xf32>
          %74 = memref.load %arg13[%50] : memref<?xf32>
          %75 = arith.mulf %73, %74 : f32
          %76 = arith.divf %72, %75 : f32
          memref.store %76, %arg0[%50] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %33 = memref.load %9[%c0] : memref<1xi32>
      %34 = arith.index_cast %33 : i32 to index
      %35 = memref.load %6[%c0] : memref<1xi32>
      %36 = memref.load %3[%c0] : memref<1xi32>
      %37 = arith.index_cast %35 : i32 to index
      %38 = arith.index_cast %36 : i32 to index
      scf.for %arg19 = %c1 to %34 step %c1 {
        %45 = arith.muli %arg19, %38 : index
        %46 = arith.addi %arg19, %c1 : index
        %47 = arith.muli %46, %38 : index
        scf.for %arg20 = %c2 to %37 step %c1 {
          %48 = arith.addi %arg20, %45 : index
          %49 = memref.load %arg1[%48] : memref<?xf32>
          %50 = memref.load %arg14[%48] : memref<?xf32>
          %51 = arith.mulf %50, %cst_0 : f32
          %52 = memref.load %arg0[%48] : memref<?xf32>
          %53 = memref.load %arg11[%48] : memref<?xf32>
          %54 = arith.mulf %52, %53 : f32
          %55 = arith.addi %arg20, %47 : index
          %56 = memref.load %arg6[%55] : memref<?xf32>
          %57 = memref.load %arg6[%48] : memref<?xf32>
          %58 = arith.addf %56, %57 : f32
          %59 = arith.mulf %54, %58 : f32
          %60 = arith.addi %arg20, %c-1 : index
          %61 = arith.addi %60, %45 : index
          %62 = memref.load %arg0[%61] : memref<?xf32>
          %63 = memref.load %arg11[%61] : memref<?xf32>
          %64 = arith.mulf %62, %63 : f32
          %65 = arith.addi %60, %47 : index
          %66 = memref.load %arg6[%65] : memref<?xf32>
          %67 = memref.load %arg6[%61] : memref<?xf32>
          %68 = arith.addf %66, %67 : f32
          %69 = arith.mulf %64, %68 : f32
          %70 = arith.addf %59, %69 : f32
          %71 = arith.mulf %51, %70 : f32
          %72 = arith.subf %49, %71 : f32
          memref.store %72, %arg1[%48] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %39 = memref.load %9[%c0] : memref<1xi32>
      %40 = arith.index_cast %39 : i32 to index
      %41 = memref.load %6[%c0] : memref<1xi32>
      %42 = memref.load %3[%c0] : memref<1xi32>
      %43 = arith.index_cast %41 : i32 to index
      %44 = arith.index_cast %42 : i32 to index
      scf.for %arg19 = %c2 to %40 step %c1 {
        %45 = arith.muli %arg19, %44 : index
        %46 = arith.addi %arg19, %c-1 : index
        %47 = arith.muli %46, %44 : index
        scf.for %arg20 = %c1 to %43 step %c1 {
          %48 = arith.addi %arg20, %45 : index
          %49 = memref.load %arg2[%48] : memref<?xf32>
          %50 = memref.load %arg15[%48] : memref<?xf32>
          %51 = arith.mulf %50, %cst_0 : f32
          %52 = memref.load %arg0[%48] : memref<?xf32>
          %53 = memref.load %arg11[%48] : memref<?xf32>
          %54 = arith.mulf %52, %53 : f32
          %55 = arith.addi %arg20, %c1 : index
          %56 = arith.addi %55, %45 : index
          %57 = memref.load %arg5[%56] : memref<?xf32>
          %58 = memref.load %arg5[%48] : memref<?xf32>
          %59 = arith.addf %57, %58 : f32
          %60 = arith.mulf %54, %59 : f32
          %61 = arith.addi %arg20, %47 : index
          %62 = memref.load %arg0[%61] : memref<?xf32>
          %63 = memref.load %arg11[%61] : memref<?xf32>
          %64 = arith.mulf %62, %63 : f32
          %65 = arith.addi %55, %47 : index
          %66 = memref.load %arg5[%65] : memref<?xf32>
          %67 = memref.load %arg5[%61] : memref<?xf32>
          %68 = arith.addf %66, %67 : f32
          %69 = arith.mulf %64, %68 : f32
          %70 = arith.addf %60, %69 : f32
          %71 = arith.mulf %51, %70 : f32
          %72 = arith.addf %49, %71 : f32
          memref.store %72, %arg2[%48] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    }
    return
  }
}


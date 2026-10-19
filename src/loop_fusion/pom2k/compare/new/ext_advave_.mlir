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
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      memref.store %cst_3, %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %6 = memref.load %0[%c0] : memref<1xi32>
    %7 = arith.index_cast %6 : i32 to index
    %8 = memref.get_global @imm1 : memref<1xi32>
    %9 = memref.load %8[%c0] : memref<1xi32>
    %10 = memref.load %3[%c0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%7, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%7, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%7, %11) step (%c1, %c1) {
      %63 = arith.muli %arg19, %12 overflow<nsw> : index
      %64 = arith.addi %arg20, %63 : index
      %65 = arith.addi %64, %c1 : index
      %66 = memref.load %arg11[%65] : memref<?xf32>
      %67 = memref.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.addf %66, %67 : f32
      %69 = memref.load %arg5[%65] : memref<?xf32>
      %70 = arith.mulf %68, %69 : f32
      %71 = arith.addi %64, %c-1 : index
      %72 = memref.load %arg11[%71] : memref<?xf32>
      %73 = arith.addf %67, %72 : f32
      %74 = memref.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %75 = arith.mulf %73, %74 : f32
      %76 = arith.addf %70, %75 : f32
      %77 = arith.mulf %76, %cst_2 : f32
      %78 = arith.addf %69, %74 : f32
      %79 = arith.mulf %77, %78 : f32
      memref.store %79, %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %13 = memref.load %0[%c0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = memref.load %3[%c0] : memref<1xi32>
    %16 = arith.index_cast %15 : i32 to index
    %reinterpret_cast_7 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%14, %16], strides: [%16, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%14, %16], strides: [%16, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%14, %16], strides: [%16, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%14, %16], strides: [%16, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%14, %16) step (%c1, %c1) {
      %63 = memref.load %reinterpret_cast_7[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = arith.addi %arg19, %c-1 : index
      %65 = memref.load %reinterpret_cast_7[%64, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %66 = arith.addf %63, %65 : f32
      %67 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.mulf %66, %67 : f32
      %69 = arith.muli %arg19, %16 overflow<nsw> : index
      %70 = arith.addi %arg20, %69 : index
      %71 = arith.addi %70, %c-1 : index
      %72 = memref.load %arg11[%71] : memref<?xf32>
      %73 = arith.muli %64, %16 overflow<nsw> : index
      %74 = arith.addi %arg20, %73 : index
      %75 = arith.addi %74, %c-1 : index
      %76 = memref.load %arg11[%75] : memref<?xf32>
      %77 = arith.addf %72, %76 : f32
      %78 = memref.load %arg6[%71] : memref<?xf32>
      %79 = arith.mulf %77, %78 : f32
      %80 = arith.addf %68, %79 : f32
      %81 = arith.mulf %80, %cst_2 : f32
      %82 = memref.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %83 = memref.load %reinterpret_cast_9[%64, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %84 = arith.addf %82, %83 : f32
      %85 = arith.mulf %81, %84 : f32
      memref.store %85, %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %17 = memref.load %0[%c0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.load %8[%c0] : memref<1xi32>
    %20 = memref.load %3[%c0] : memref<1xi32>
    %21 = arith.index_cast %19 : i32 to index
    %22 = arith.index_cast %20 : i32 to index
    %reinterpret_cast_11 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%18, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%18, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%18, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%18, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%18, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%18, %21) step (%c1, %c1) {
      %63 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %65 = arith.mulf %64, %cst_1 : f32
      %66 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %67 = arith.mulf %65, %66 : f32
      %68 = arith.muli %arg19, %22 overflow<nsw> : index
      %69 = arith.addi %arg20, %68 : index
      %70 = arith.addi %69, %c1 : index
      %71 = memref.load %arg7[%70] : memref<?xf32>
      %72 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %73 = arith.subf %71, %72 : f32
      %74 = arith.mulf %67, %73 : f32
      %75 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %76 = arith.divf %74, %75 : f32
      %77 = arith.subf %63, %76 : f32
      memref.store %77, %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %23 = memref.load %0[%c0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = memref.load %3[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    %reinterpret_cast_16 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%24, %26], strides: [%26, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%24, %26) step (%c1, %c1) {
      %63 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = arith.muli %arg19, %26 overflow<nsw> : index
      %65 = arith.addi %arg20, %64 : index
      %66 = arith.addi %65, %c-1 : index
      %67 = memref.load %arg11[%66] : memref<?xf32>
      %68 = arith.addf %63, %67 : f32
      %69 = arith.addi %arg19, %c-1 : index
      %70 = memref.load %reinterpret_cast_16[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.addf %68, %70 : f32
      %72 = arith.muli %69, %26 overflow<nsw> : index
      %73 = arith.addi %arg20, %72 : index
      %74 = arith.addi %73, %c-1 : index
      %75 = memref.load %arg11[%74] : memref<?xf32>
      %76 = arith.addf %71, %75 : f32
      %77 = arith.mulf %76, %cst_0 : f32
      %78 = memref.load %reinterpret_cast_17[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %79 = memref.load %reinterpret_cast_17[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %80 = arith.addf %78, %79 : f32
      %81 = memref.load %arg16[%66] : memref<?xf32>
      %82 = arith.addf %80, %81 : f32
      %83 = memref.load %arg16[%74] : memref<?xf32>
      %84 = arith.addf %82, %83 : f32
      %85 = arith.mulf %77, %84 : f32
      %86 = memref.load %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %87 = memref.load %reinterpret_cast_18[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %88 = arith.subf %86, %87 : f32
      %89 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %90 = memref.load %arg13[%66] : memref<?xf32>
      %91 = arith.addf %89, %90 : f32
      %92 = memref.load %reinterpret_cast_19[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %93 = arith.addf %91, %92 : f32
      %94 = memref.load %arg13[%74] : memref<?xf32>
      %95 = arith.addf %93, %94 : f32
      %96 = arith.divf %88, %95 : f32
      %97 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %98 = memref.load %arg8[%66] : memref<?xf32>
      %99 = arith.subf %97, %98 : f32
      %100 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %101 = memref.load %arg12[%66] : memref<?xf32>
      %102 = arith.addf %100, %101 : f32
      %103 = memref.load %reinterpret_cast_21[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %104 = arith.addf %102, %103 : f32
      %105 = memref.load %arg12[%74] : memref<?xf32>
      %106 = arith.addf %104, %105 : f32
      %107 = arith.divf %99, %106 : f32
      %108 = arith.addf %96, %107 : f32
      %109 = arith.mulf %85, %108 : f32
      memref.store %109, %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %110 = memref.load %reinterpret_cast_23[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %111 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %112 = arith.mulf %110, %111 : f32
      memref.store %112, %reinterpret_cast_23[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %113 = memref.load %reinterpret_cast_24[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %114 = memref.load %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %115 = arith.subf %113, %114 : f32
      %116 = arith.mulf %115, %cst_0 : f32
      %117 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %118 = memref.load %arg12[%66] : memref<?xf32>
      %119 = arith.addf %117, %118 : f32
      %120 = memref.load %reinterpret_cast_21[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %121 = arith.addf %119, %120 : f32
      %122 = memref.load %arg12[%74] : memref<?xf32>
      %123 = arith.addf %121, %122 : f32
      %124 = arith.mulf %116, %123 : f32
      memref.store %124, %reinterpret_cast_24[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %27 = memref.get_global @jmm1 : memref<1xi32>
    %28 = memref.load %27[%c0] : memref<1xi32>
    %29 = arith.index_cast %28 : i32 to index
    %30 = memref.load %8[%c0] : memref<1xi32>
    %31 = memref.load %3[%c0] : memref<1xi32>
    %32 = arith.index_cast %30 : i32 to index
    %33 = arith.index_cast %31 : i32 to index
    %reinterpret_cast_25 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%29, %33], strides: [%33, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_26 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%29, %33], strides: [%33, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_27 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%29, %33], strides: [%33, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%29, %32) step (%c1, %c1) {
      %63 = memref.load %reinterpret_cast_25[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = arith.muli %arg19, %33 overflow<nsw> : index
      %65 = arith.addi %arg20, %64 : index
      %66 = arith.addi %65, %c-1 : index
      %67 = memref.load %arg3[%66] : memref<?xf32>
      %68 = arith.subf %63, %67 : f32
      %69 = arith.addi %arg19, %c1 : index
      %70 = memref.load %reinterpret_cast_26[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.addf %68, %70 : f32
      %72 = memref.load %reinterpret_cast_26[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %73 = arith.subf %71, %72 : f32
      memref.store %73, %reinterpret_cast_27[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %34 = memref.load %0[%c0] : memref<1xi32>
    %35 = arith.index_cast %34 : i32 to index
    %36 = memref.load %3[%c0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    %reinterpret_cast_28 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%35, %37], strides: [%37, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%35, %37) step (%c1, %c1) {
      memref.store %cst_3, %reinterpret_cast_28[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %38 = memref.load %0[%c0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = memref.load %3[%c0] : memref<1xi32>
    %41 = arith.index_cast %40 : i32 to index
    %reinterpret_cast_29 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_30 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_31 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_32 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%39, %41) step (%c1, %c1) {
      %63 = memref.load %reinterpret_cast_29[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = arith.muli %arg19, %41 overflow<nsw> : index
      %65 = arith.addi %arg20, %64 : index
      %66 = arith.addi %65, %c-1 : index
      %67 = memref.load %arg11[%66] : memref<?xf32>
      %68 = arith.addf %63, %67 : f32
      %69 = memref.load %reinterpret_cast_30[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %70 = arith.mulf %68, %69 : f32
      %71 = arith.addi %arg19, %c-1 : index
      %72 = memref.load %reinterpret_cast_29[%71, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %73 = arith.muli %71, %41 overflow<nsw> : index
      %74 = arith.addi %arg20, %73 : index
      %75 = arith.addi %74, %c-1 : index
      %76 = memref.load %arg11[%75] : memref<?xf32>
      %77 = arith.addf %72, %76 : f32
      %78 = memref.load %reinterpret_cast_30[%71, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %79 = arith.mulf %77, %78 : f32
      %80 = arith.addf %70, %79 : f32
      %81 = arith.mulf %80, %cst_2 : f32
      %82 = memref.load %arg6[%66] : memref<?xf32>
      %83 = memref.load %reinterpret_cast_31[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %84 = arith.addf %82, %83 : f32
      %85 = arith.mulf %81, %84 : f32
      memref.store %85, %reinterpret_cast_32[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %42 = memref.load %27[%c0] : memref<1xi32>
    %43 = arith.index_cast %42 : i32 to index
    %44 = memref.load %3[%c0] : memref<1xi32>
    %45 = arith.index_cast %44 : i32 to index
    %reinterpret_cast_33 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%43, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_34 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%43, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_35 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%43, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%43, %45) step (%c1, %c1) {
      %63 = arith.addi %arg19, %c1 : index
      %64 = memref.load %reinterpret_cast_33[%63, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %65 = memref.load %reinterpret_cast_33[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %66 = arith.addf %64, %65 : f32
      %67 = memref.load %reinterpret_cast_34[%63, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.mulf %66, %67 : f32
      %69 = arith.addi %arg19, %c-1 : index
      %70 = memref.load %reinterpret_cast_33[%69, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.addf %65, %70 : f32
      %72 = memref.load %reinterpret_cast_34[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %73 = arith.mulf %71, %72 : f32
      %74 = arith.addf %68, %73 : f32
      %75 = arith.mulf %74, %cst_2 : f32
      %76 = arith.addf %67, %72 : f32
      %77 = arith.mulf %75, %76 : f32
      memref.store %77, %reinterpret_cast_35[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %46 = memref.load %27[%c0] : memref<1xi32>
    %47 = arith.index_cast %46 : i32 to index
    %48 = memref.load %3[%c0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    %reinterpret_cast_36 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%47, %49], strides: [%49, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_37 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%47, %49], strides: [%49, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_38 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%47, %49], strides: [%49, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_39 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%47, %49], strides: [%49, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_40 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%47, %49], strides: [%49, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%47, %49) step (%c1, %c1) {
      %63 = memref.load %reinterpret_cast_36[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = memref.load %reinterpret_cast_37[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %65 = arith.mulf %64, %cst_1 : f32
      %66 = memref.load %reinterpret_cast_38[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %67 = arith.mulf %65, %66 : f32
      %68 = arith.addi %arg19, %c1 : index
      %69 = memref.load %reinterpret_cast_39[%68, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %70 = memref.load %reinterpret_cast_39[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.subf %69, %70 : f32
      %72 = arith.mulf %67, %71 : f32
      %73 = memref.load %reinterpret_cast_40[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %74 = arith.divf %72, %73 : f32
      %75 = arith.subf %63, %74 : f32
      memref.store %75, %reinterpret_cast_36[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %50 = memref.load %0[%c0] : memref<1xi32>
    %51 = arith.index_cast %50 : i32 to index
    %52 = memref.load %3[%c0] : memref<1xi32>
    %53 = arith.index_cast %52 : i32 to index
    %reinterpret_cast_41 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%51, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_42 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%51, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_43 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%51, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_44 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%51, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_45 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%51, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%51, %53) step (%c1, %c1) {
      %63 = memref.load %reinterpret_cast_41[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %64 = memref.load %reinterpret_cast_42[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %65 = arith.mulf %63, %64 : f32
      memref.store %65, %reinterpret_cast_41[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %66 = memref.load %reinterpret_cast_43[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %67 = memref.load %reinterpret_cast_44[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.subf %66, %67 : f32
      %69 = arith.mulf %68, %cst_0 : f32
      %70 = memref.load %reinterpret_cast_45[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.muli %arg19, %53 overflow<nsw> : index
      %72 = arith.addi %arg20, %71 : index
      %73 = arith.addi %72, %c-1 : index
      %74 = memref.load %arg13[%73] : memref<?xf32>
      %75 = arith.addf %70, %74 : f32
      %76 = arith.addi %arg19, %c-1 : index
      %77 = memref.load %reinterpret_cast_45[%76, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %78 = arith.addf %75, %77 : f32
      %79 = arith.muli %76, %53 overflow<nsw> : index
      %80 = arith.addi %arg20, %79 : index
      %81 = arith.addi %80, %c-1 : index
      %82 = memref.load %arg13[%81] : memref<?xf32>
      %83 = arith.addf %78, %82 : f32
      %84 = arith.mulf %69, %83 : f32
      memref.store %84, %reinterpret_cast_43[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %54 = memref.load %27[%c0] : memref<1xi32>
    %55 = arith.index_cast %54 : i32 to index
    %56 = memref.load %8[%c0] : memref<1xi32>
    %57 = memref.load %3[%c0] : memref<1xi32>
    %58 = arith.index_cast %56 : i32 to index
    %59 = arith.index_cast %57 : i32 to index
    %reinterpret_cast_46 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%55, %59], strides: [%59, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_47 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%55, %59], strides: [%59, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_48 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%55, %59], strides: [%59, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%55, %58) step (%c1, %c1) {
      %63 = arith.muli %arg19, %59 overflow<nsw> : index
      %64 = arith.addi %arg20, %63 : index
      %65 = arith.addi %64, %c1 : index
      %66 = memref.load %arg3[%65] : memref<?xf32>
      %67 = memref.load %reinterpret_cast_46[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.subf %66, %67 : f32
      %69 = memref.load %reinterpret_cast_47[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %70 = arith.addf %68, %69 : f32
      %71 = arith.addi %arg19, %c-1 : index
      %72 = memref.load %reinterpret_cast_47[%71, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %73 = arith.subf %70, %72 : f32
      memref.store %73, %reinterpret_cast_48[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %60 = memref.get_global @mode : memref<1xi32>
    %61 = memref.load %60[%c0] : memref<1xi32>
    %62 = arith.cmpi eq, %61, %c2_i32 : i32
    scf.if %62 {
      %63 = memref.load %27[%c0] : memref<1xi32>
      %64 = arith.index_cast %63 : i32 to index
      %65 = memref.load %8[%c0] : memref<1xi32>
      %66 = memref.load %3[%c0] : memref<1xi32>
      %67 = arith.index_cast %65 : i32 to index
      %68 = arith.index_cast %66 : i32 to index
      scf.for %arg19 = %c1 to %64 step %c1 {
        %93 = arith.muli %arg19, %68 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %68 : index
        scf.for %arg20 = %c1 to %67 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg18[%96] : memref<?xf32>
          %98 = arith.addi %arg20, %c-1 : index
          %99 = arith.addi %98, %93 : index
          %100 = memref.load %arg18[%99] : memref<?xf32>
          %101 = arith.addf %97, %100 : f32
          %102 = arith.mulf %101, %cst : f32
          %103 = memref.load %arg7[%96] : memref<?xf32>
          %104 = arith.mulf %103, %103 : f32
          %105 = memref.load %arg8[%96] : memref<?xf32>
          %106 = arith.addi %arg20, %95 : index
          %107 = memref.load %arg8[%106] : memref<?xf32>
          %108 = arith.addf %105, %107 : f32
          %109 = memref.load %arg8[%99] : memref<?xf32>
          %110 = arith.addf %108, %109 : f32
          %111 = arith.addi %98, %95 : index
          %112 = memref.load %arg8[%111] : memref<?xf32>
          %113 = arith.addf %110, %112 : f32
          %114 = arith.mulf %113, %cst_0 : f32
          %115 = arith.mulf %114, %114 : f32
          %116 = arith.addf %104, %115 : f32
          %117 = math.sqrt %116 : f32
          %118 = arith.mulf %102, %117 : f32
          %119 = arith.mulf %118, %103 : f32
          memref.store %119, %arg9[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %69 = memref.load %27[%c0] : memref<1xi32>
      %70 = arith.index_cast %69 : i32 to index
      %71 = memref.load %8[%c0] : memref<1xi32>
      %72 = memref.load %3[%c0] : memref<1xi32>
      %73 = arith.index_cast %71 : i32 to index
      %74 = arith.index_cast %72 : i32 to index
      scf.for %arg19 = %c1 to %70 step %c1 {
        %93 = arith.muli %arg19, %74 : index
        %94 = arith.addi %arg19, %c-1 : index
        %95 = arith.muli %94, %74 : index
        scf.for %arg20 = %c1 to %73 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg18[%96] : memref<?xf32>
          %98 = arith.addi %arg20, %95 : index
          %99 = memref.load %arg18[%98] : memref<?xf32>
          %100 = arith.addf %97, %99 : f32
          %101 = arith.mulf %100, %cst : f32
          %102 = memref.load %arg8[%96] : memref<?xf32>
          %103 = arith.mulf %102, %102 : f32
          %104 = memref.load %arg7[%96] : memref<?xf32>
          %105 = arith.addi %arg20, %c1 : index
          %106 = arith.addi %105, %93 : index
          %107 = memref.load %arg7[%106] : memref<?xf32>
          %108 = arith.addf %104, %107 : f32
          %109 = memref.load %arg7[%98] : memref<?xf32>
          %110 = arith.addf %108, %109 : f32
          %111 = arith.addi %105, %95 : index
          %112 = memref.load %arg7[%111] : memref<?xf32>
          %113 = arith.addf %110, %112 : f32
          %114 = arith.mulf %113, %cst_0 : f32
          %115 = arith.mulf %114, %114 : f32
          %116 = arith.addf %103, %115 : f32
          %117 = math.sqrt %116 : f32
          %118 = arith.mulf %101, %117 : f32
          %119 = arith.mulf %118, %102 : f32
          memref.store %119, %arg10[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %75 = memref.load %27[%c0] : memref<1xi32>
      %76 = arith.index_cast %75 : i32 to index
      %77 = memref.load %8[%c0] : memref<1xi32>
      %78 = memref.load %3[%c0] : memref<1xi32>
      %79 = arith.index_cast %77 : i32 to index
      %80 = arith.index_cast %78 : i32 to index
      scf.for %arg19 = %c1 to %76 step %c1 {
        %93 = arith.muli %arg19, %80 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %80 : index
        %96 = arith.addi %arg19, %c-1 : index
        %97 = arith.muli %96, %80 : index
        scf.for %arg20 = %c1 to %79 step %c1 {
          %98 = arith.addi %arg20, %93 : index
          %99 = arith.addi %arg20, %95 : index
          %100 = memref.load %arg6[%99] : memref<?xf32>
          %101 = memref.load %arg6[%98] : memref<?xf32>
          %102 = arith.addf %100, %101 : f32
          %103 = arith.addi %arg20, %c1 : index
          %104 = arith.addi %103, %93 : index
          %105 = memref.load %arg13[%104] : memref<?xf32>
          %106 = arith.addi %arg20, %c-1 : index
          %107 = arith.addi %106, %93 : index
          %108 = memref.load %arg13[%107] : memref<?xf32>
          %109 = arith.subf %105, %108 : f32
          %110 = arith.mulf %102, %109 : f32
          %111 = memref.load %arg5[%104] : memref<?xf32>
          %112 = memref.load %arg5[%98] : memref<?xf32>
          %113 = arith.addf %111, %112 : f32
          %114 = memref.load %arg12[%99] : memref<?xf32>
          %115 = arith.addi %arg20, %97 : index
          %116 = memref.load %arg12[%115] : memref<?xf32>
          %117 = arith.subf %114, %116 : f32
          %118 = arith.mulf %113, %117 : f32
          %119 = arith.subf %110, %118 : f32
          %120 = arith.mulf %119, %cst_0 : f32
          %121 = memref.load %arg12[%98] : memref<?xf32>
          %122 = memref.load %arg13[%98] : memref<?xf32>
          %123 = arith.mulf %121, %122 : f32
          %124 = arith.divf %120, %123 : f32
          memref.store %124, %arg0[%98] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %81 = memref.load %27[%c0] : memref<1xi32>
      %82 = arith.index_cast %81 : i32 to index
      %83 = memref.load %8[%c0] : memref<1xi32>
      %84 = memref.load %3[%c0] : memref<1xi32>
      %85 = arith.index_cast %83 : i32 to index
      %86 = arith.index_cast %84 : i32 to index
      scf.for %arg19 = %c1 to %82 step %c1 {
        %93 = arith.muli %arg19, %86 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %86 : index
        scf.for %arg20 = %c2 to %85 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg1[%96] : memref<?xf32>
          %98 = memref.load %arg14[%96] : memref<?xf32>
          %99 = arith.mulf %98, %cst_0 : f32
          %100 = memref.load %arg0[%96] : memref<?xf32>
          %101 = memref.load %arg11[%96] : memref<?xf32>
          %102 = arith.mulf %100, %101 : f32
          %103 = arith.addi %arg20, %95 : index
          %104 = memref.load %arg6[%103] : memref<?xf32>
          %105 = memref.load %arg6[%96] : memref<?xf32>
          %106 = arith.addf %104, %105 : f32
          %107 = arith.mulf %102, %106 : f32
          %108 = arith.addi %arg20, %c-1 : index
          %109 = arith.addi %108, %93 : index
          %110 = memref.load %arg0[%109] : memref<?xf32>
          %111 = memref.load %arg11[%109] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %108, %95 : index
          %114 = memref.load %arg6[%113] : memref<?xf32>
          %115 = memref.load %arg6[%109] : memref<?xf32>
          %116 = arith.addf %114, %115 : f32
          %117 = arith.mulf %112, %116 : f32
          %118 = arith.addf %107, %117 : f32
          %119 = arith.mulf %99, %118 : f32
          %120 = arith.subf %97, %119 : f32
          memref.store %120, %arg1[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %87 = memref.load %27[%c0] : memref<1xi32>
      %88 = arith.index_cast %87 : i32 to index
      %89 = memref.load %8[%c0] : memref<1xi32>
      %90 = memref.load %3[%c0] : memref<1xi32>
      %91 = arith.index_cast %89 : i32 to index
      %92 = arith.index_cast %90 : i32 to index
      scf.for %arg19 = %c2 to %88 step %c1 {
        %93 = arith.muli %arg19, %92 : index
        %94 = arith.addi %arg19, %c-1 : index
        %95 = arith.muli %94, %92 : index
        scf.for %arg20 = %c1 to %91 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg2[%96] : memref<?xf32>
          %98 = memref.load %arg15[%96] : memref<?xf32>
          %99 = arith.mulf %98, %cst_0 : f32
          %100 = memref.load %arg0[%96] : memref<?xf32>
          %101 = memref.load %arg11[%96] : memref<?xf32>
          %102 = arith.mulf %100, %101 : f32
          %103 = arith.addi %arg20, %c1 : index
          %104 = arith.addi %103, %93 : index
          %105 = memref.load %arg5[%104] : memref<?xf32>
          %106 = memref.load %arg5[%96] : memref<?xf32>
          %107 = arith.addf %105, %106 : f32
          %108 = arith.mulf %102, %107 : f32
          %109 = arith.addi %arg20, %95 : index
          %110 = memref.load %arg0[%109] : memref<?xf32>
          %111 = memref.load %arg11[%109] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %103, %95 : index
          %114 = memref.load %arg5[%113] : memref<?xf32>
          %115 = memref.load %arg5[%109] : memref<?xf32>
          %116 = arith.addf %114, %115 : f32
          %117 = arith.mulf %112, %116 : f32
          %118 = arith.addf %108, %117 : f32
          %119 = arith.mulf %99, %118 : f32
          %120 = arith.addf %97, %119 : f32
          memref.store %120, %arg2[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    }
    return
  }
}


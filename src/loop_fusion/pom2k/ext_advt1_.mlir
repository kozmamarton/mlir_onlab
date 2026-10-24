module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @tprni : memref<1xf32>
  memref.global @kb : memref<1xi32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advt1_(%arg0: memref<?xf32> {polygeist.name = "fb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fclim", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "zflux", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg19: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg20: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @kbm1 : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = arith.muli %8, %7 : index
    %10 = arith.muli %9, %2 : index
    %11 = arith.subi %8, %c1 : index
    %12 = arith.muli %11, %7 : index
    %13 = arith.muli %12, %2 : index
    %14 = memref.get_global @kb : memref<1xi32>
    %15 = memref.load %14[%c0] : memref<1xi32>
    %16 = arith.index_cast %15 : i32 to index
    scf.for %arg21 = %c0 to %2 step %c1 {
      scf.for %arg22 = %c0 to %7 step %c1 {
        %50 = arith.muli %arg21, %7 overflow<nsw> : index
        %51 = arith.addi %arg22, %50 : index
        %52 = arith.addi %51, %13 : index
        %53 = memref.load %arg1[%52] : memref<?xf32>
        %54 = arith.addi %51, %10 : index
        memref.store %53, %arg1[%54] : memref<?xf32>
        %55 = memref.load %arg0[%52] : memref<?xf32>
        memref.store %55, %arg0[%54] : memref<?xf32>
      }
    }
    %17 = arith.muli %7, %2 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%2, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%8, %2, %7) step (%c1, %c1, %c1) {
      %50 = memref.load %reinterpret_cast_6[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %51 = arith.muli %arg22, %7 overflow<nsw> : index
      %52 = arith.addi %arg23, %51 : index
      %53 = arith.addi %52, %c-1 : index
      %54 = memref.load %arg9[%53] : memref<?xf32>
      %55 = arith.addf %50, %54 : f32
      %56 = memref.load %reinterpret_cast[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %57 = arith.muli %arg21, %7 overflow<nsw> : index
      %58 = arith.muli %57, %2 overflow<nsw> : index
      %59 = arith.addi %52, %58 : index
      %60 = arith.addi %59, %c-1 : index
      %61 = memref.load %arg1[%60] : memref<?xf32>
      %62 = arith.addf %56, %61 : f32
      %63 = arith.mulf %55, %62 : f32
      %64 = memref.load %reinterpret_cast_2[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %65 = arith.mulf %63, %64 : f32
      %66 = arith.mulf %65, %cst_1 : f32
      memref.store %66, %reinterpret_cast_3[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %67 = memref.load %reinterpret_cast_6[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.addi %arg22, %c-1 : index
      %69 = memref.load %reinterpret_cast_6[%68, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %70 = arith.addf %67, %69 : f32
      %71 = memref.load %reinterpret_cast[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %72 = memref.load %reinterpret_cast[%arg21, %68, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %73 = arith.addf %71, %72 : f32
      %74 = arith.mulf %70, %73 : f32
      %75 = memref.load %reinterpret_cast_4[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %76 = arith.mulf %74, %75 : f32
      %77 = arith.mulf %76, %cst_1 : f32
      memref.store %77, %reinterpret_cast_5[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%16, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%16, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%16, %2, %7) step (%c1, %c1, %c1) {
      %50 = memref.load %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %51 = memref.load %reinterpret_cast_8[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %52 = arith.subf %50, %51 : f32
      memref.store %52, %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %18 = memref.load %4[%c0] : memref<1xi32>
    %19 = arith.index_cast %18 : i32 to index
    %20 = memref.get_global @tprni : memref<1xf32>
    %21 = memref.load %0[%c0] : memref<1xi32>
    %22 = memref.load %3[%c0] : memref<1xi32>
    %23 = memref.load %20[%c0] : memref<1xf32>
    %24 = arith.index_cast %21 : i32 to index
    %25 = arith.index_cast %22 : i32 to index
    %26 = memref.load %14[%c0] : memref<1xi32>
    %27 = arith.index_cast %26 : i32 to index
    %28 = memref.get_global @jmm1 : memref<1xi32>
    %29 = memref.load %28[%c0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = memref.get_global @imm1 : memref<1xi32>
    %32 = memref.load %31[%c0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %34 = arith.muli %19, %25 : index
    %35 = arith.muli %34, %24 : index
    %36 = arith.muli %25, %24 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%24, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%19, %24, %25) step (%c1, %c1, %c1) {
      %50 = memref.load %reinterpret_cast_9[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %51 = arith.muli %arg22, %25 overflow<nsw> : index
      %52 = arith.addi %arg23, %51 : index
      %53 = arith.muli %arg21, %25 overflow<nsw> : index
      %54 = arith.muli %53, %24 overflow<nsw> : index
      %55 = arith.addi %52, %54 : index
      %56 = arith.addi %55, %c-1 : index
      %57 = memref.load %arg10[%56] : memref<?xf32>
      %58 = arith.addf %50, %57 : f32
      %59 = arith.mulf %58, %cst_0 : f32
      %60 = memref.load %reinterpret_cast_13[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %61 = arith.addi %52, %c-1 : index
      %62 = memref.load %arg16[%61] : memref<?xf32>
      %63 = arith.addf %60, %62 : f32
      %64 = arith.mulf %59, %63 : f32
      %65 = arith.mulf %64, %23 : f32
      %66 = memref.load %reinterpret_cast_10[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %67 = memref.load %arg0[%56] : memref<?xf32>
      %68 = arith.subf %66, %67 : f32
      %69 = arith.mulf %65, %68 : f32
      %70 = memref.load %reinterpret_cast_14[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.mulf %69, %70 : f32
      %72 = memref.load %reinterpret_cast_15[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %73 = memref.load %arg13[%61] : memref<?xf32>
      %74 = arith.addf %72, %73 : f32
      %75 = arith.divf %71, %74 : f32
      %76 = memref.load %reinterpret_cast_11[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %77 = arith.subf %76, %75 : f32
      memref.store %77, %reinterpret_cast_11[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %78 = memref.load %reinterpret_cast_9[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %79 = arith.addi %arg22, %c-1 : index
      %80 = memref.load %reinterpret_cast_9[%arg21, %79, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %81 = arith.addf %78, %80 : f32
      %82 = arith.mulf %81, %cst_0 : f32
      %83 = memref.load %reinterpret_cast_13[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %84 = memref.load %reinterpret_cast_13[%79, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %85 = arith.addf %83, %84 : f32
      %86 = arith.mulf %82, %85 : f32
      %87 = arith.mulf %86, %23 : f32
      %88 = memref.load %reinterpret_cast_10[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %89 = memref.load %reinterpret_cast_10[%arg21, %79, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %90 = arith.subf %88, %89 : f32
      %91 = arith.mulf %87, %90 : f32
      %92 = memref.load %reinterpret_cast_16[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %93 = arith.mulf %91, %92 : f32
      %94 = memref.load %reinterpret_cast_17[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %95 = memref.load %reinterpret_cast_17[%79, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %96 = arith.addf %94, %95 : f32
      %97 = arith.divf %93, %96 : f32
      %98 = memref.load %reinterpret_cast_12[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %99 = arith.subf %98, %97 : f32
      memref.store %99, %reinterpret_cast_12[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %100 = memref.load %reinterpret_cast_17[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %101 = memref.load %arg14[%61] : memref<?xf32>
      %102 = arith.addf %100, %101 : f32
      %103 = arith.mulf %102, %cst_0 : f32
      %104 = memref.load %reinterpret_cast_11[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %105 = arith.mulf %103, %104 : f32
      memref.store %105, %reinterpret_cast_11[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %106 = memref.load %reinterpret_cast_15[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %107 = memref.load %reinterpret_cast_15[%79, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %108 = arith.addf %106, %107 : f32
      %109 = arith.mulf %108, %cst_0 : f32
      %110 = memref.load %reinterpret_cast_12[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %111 = arith.mulf %109, %110 : f32
      memref.store %111, %reinterpret_cast_12[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%27, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%27, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%27, %24, %25) step (%c1, %c1, %c1) {
      %50 = memref.load %reinterpret_cast_18[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %51 = memref.load %reinterpret_cast_19[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %52 = arith.addf %51, %50 : f32
      memref.store %52, %reinterpret_cast_19[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_20 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%30, %25], strides: [%25, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg21 = %c1 to %30 step %c1 {
      scf.for %arg22 = %c1 to %33 step %c1 {
        %50 = memref.load %reinterpret_cast_20[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %51 = memref.load %reinterpret_cast_21[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %52 = arith.mulf %50, %51 : f32
        %53 = memref.load %reinterpret_cast_22[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %54 = arith.mulf %52, %53 : f32
        memref.store %54, %reinterpret_cast_23[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %55 = arith.muli %arg21, %25 overflow<nsw> : index
        %56 = arith.addi %arg22, %55 : index
        %57 = arith.addi %56, %35 : index
        memref.store %cst, %arg6[%57] : memref<?xf32>
      }
    }
    %reinterpret_cast_24 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_26 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%19, %24, %25], strides: [%36, %25, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c1, %c1, %c1) to (%19, %30, %33) step (%c1, %c1, %c1) {
      %50 = arith.addi %arg21, %c-1 : index
      %51 = memref.load %reinterpret_cast_24[%50, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %52 = memref.load %reinterpret_cast_24[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %53 = arith.addf %51, %52 : f32
      %54 = arith.mulf %53, %cst_0 : f32
      %55 = memref.load %reinterpret_cast_25[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %56 = arith.mulf %54, %55 : f32
      %57 = memref.load %reinterpret_cast_22[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %58 = arith.mulf %56, %57 : f32
      memref.store %58, %reinterpret_cast_26[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %37 = memref.load %4[%c0] : memref<1xi32>
    %38 = arith.index_cast %37 : i32 to index
    %39 = memref.get_global @dti2 : memref<1xf32>
    %40 = memref.load %28[%c0] : memref<1xi32>
    %41 = memref.load %31[%c0] : memref<1xi32>
    %42 = memref.load %3[%c0] : memref<1xi32>
    %43 = memref.load %0[%c0] : memref<1xi32>
    %44 = memref.load %39[%c0] : memref<1xf32>
    %45 = arith.index_cast %40 : i32 to index
    %46 = arith.index_cast %41 : i32 to index
    %47 = arith.index_cast %42 : i32 to index
    %48 = arith.index_cast %43 : i32 to index
    %49 = arith.muli %47, %48 : index
    %reinterpret_cast_27 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_28 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_29 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_30 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_31 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%38, %48, %47], strides: [%49, %47, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_32 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_33 = memref.reinterpret_cast %arg19 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_34 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_35 = memref.reinterpret_cast %arg20 to offset: [0], sizes: [%45, %47], strides: [%47, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%38, %45, %46) step (%c1, %c1, %c1) {
      %50 = memref.load %arg15[%arg21] : memref<?xf32>
      %51 = arith.muli %arg22, %47 overflow<nsw> : index
      %52 = arith.addi %arg23, %51 : index
      %53 = arith.muli %arg21, %47 overflow<nsw> : index
      %54 = arith.muli %53, %48 overflow<nsw> : index
      %55 = arith.addi %52, %54 : index
      %56 = arith.addi %55, %c1 : index
      %57 = memref.load %arg4[%56] : memref<?xf32>
      %58 = memref.load %reinterpret_cast_27[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %59 = arith.subf %57, %58 : f32
      %60 = arith.addi %arg22, %c1 : index
      %61 = memref.load %reinterpret_cast_28[%arg21, %60, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %62 = arith.addf %59, %61 : f32
      %63 = memref.load %reinterpret_cast_28[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %64 = arith.subf %62, %63 : f32
      %65 = memref.load %reinterpret_cast_29[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %66 = arith.addi %arg21, %c1 : index
      %67 = memref.load %reinterpret_cast_29[%66, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %68 = arith.subf %65, %67 : f32
      %69 = arith.divf %68, %50 : f32
      %70 = arith.addf %64, %69 : f32
      memref.store %70, %reinterpret_cast_30[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %71 = memref.load %reinterpret_cast_31[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %72 = memref.load %reinterpret_cast_32[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %73 = memref.load %reinterpret_cast_33[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %74 = arith.addf %72, %73 : f32
      %75 = arith.mulf %71, %74 : f32
      %76 = memref.load %reinterpret_cast_34[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %77 = arith.mulf %75, %76 : f32
      %78 = arith.mulf %44, %70 : f32
      %79 = arith.subf %77, %78 : f32
      %80 = memref.load %reinterpret_cast_35[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %81 = arith.addf %72, %80 : f32
      %82 = arith.mulf %81, %76 : f32
      %83 = arith.divf %79, %82 : f32
      memref.store %83, %reinterpret_cast_30[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


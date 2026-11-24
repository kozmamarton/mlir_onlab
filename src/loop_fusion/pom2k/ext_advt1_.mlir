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
        %28 = arith.muli %arg21, %7 overflow<nsw> : index
        %29 = arith.addi %arg22, %28 : index
        %30 = arith.addi %29, %13 : index
        %31 = memref.load %arg1[%30] : memref<?xf32>
        %32 = arith.addi %29, %10 : index
        memref.store %31, %arg1[%32] : memref<?xf32>
        %33 = memref.load %arg0[%30] : memref<?xf32>
        memref.store %33, %arg0[%32] : memref<?xf32>
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
      %28 = memref.load %reinterpret_cast_6[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %29 = arith.muli %arg22, %7 overflow<nsw> : index
      %30 = arith.addi %arg23, %29 : index
      %31 = arith.addi %30, %c-1 : index
      %32 = memref.load %arg9[%31] : memref<?xf32>
      %33 = arith.addf %28, %32 : f32
      %34 = memref.load %reinterpret_cast[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %35 = arith.muli %arg21, %7 overflow<nsw> : index
      %36 = arith.muli %35, %2 overflow<nsw> : index
      %37 = arith.addi %30, %36 : index
      %38 = arith.addi %37, %c-1 : index
      %39 = memref.load %arg1[%38] : memref<?xf32>
      %40 = arith.addf %34, %39 : f32
      %41 = arith.mulf %33, %40 : f32
      %42 = memref.load %reinterpret_cast_2[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %43 = arith.mulf %41, %42 : f32
      %44 = arith.mulf %43, %cst_1 : f32
      memref.store %44, %reinterpret_cast_3[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %45 = arith.addi %arg22, %c-1 : index
      %46 = memref.load %reinterpret_cast_6[%45, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %47 = arith.addf %28, %46 : f32
      %48 = memref.load %reinterpret_cast[%arg21, %45, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %49 = arith.addf %34, %48 : f32
      %50 = arith.mulf %47, %49 : f32
      %51 = memref.load %reinterpret_cast_4[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %52 = arith.mulf %50, %51 : f32
      %53 = arith.mulf %52, %cst_1 : f32
      memref.store %53, %reinterpret_cast_5[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%16, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%16, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%16, %2, %7) step (%c1, %c1, %c1) {
      %28 = memref.load %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = memref.load %reinterpret_cast_8[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = arith.subf %28, %29 : f32
      memref.store %30, %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %18 = memref.get_global @tprni : memref<1xf32>
    %19 = memref.load %18[%c0] : memref<1xf32>
    %20 = memref.get_global @jmm1 : memref<1xi32>
    %21 = memref.load %20[%c0] : memref<1xi32>
    %22 = arith.index_cast %21 : i32 to index
    %23 = memref.get_global @imm1 : memref<1xi32>
    %24 = memref.load %23[%c0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%2, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%2, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%2, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%2, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%2, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%8, %2, %7) step (%c1, %c1, %c1) {
      %28 = memref.load %reinterpret_cast_9[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = arith.muli %arg22, %7 overflow<nsw> : index
      %30 = arith.addi %arg23, %29 : index
      %31 = arith.muli %arg21, %7 overflow<nsw> : index
      %32 = arith.muli %31, %2 overflow<nsw> : index
      %33 = arith.addi %30, %32 : index
      %34 = arith.addi %33, %c-1 : index
      %35 = memref.load %arg10[%34] : memref<?xf32>
      %36 = arith.addf %28, %35 : f32
      %37 = arith.mulf %36, %cst_0 : f32
      %38 = memref.load %reinterpret_cast_11[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.addi %30, %c-1 : index
      %40 = memref.load %arg16[%39] : memref<?xf32>
      %41 = arith.addf %38, %40 : f32
      %42 = arith.mulf %37, %41 : f32
      %43 = arith.mulf %42, %19 : f32
      %44 = memref.load %reinterpret_cast_10[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %45 = memref.load %arg0[%34] : memref<?xf32>
      %46 = arith.subf %44, %45 : f32
      %47 = arith.mulf %43, %46 : f32
      %48 = memref.load %reinterpret_cast_12[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %49 = arith.mulf %47, %48 : f32
      %50 = memref.load %reinterpret_cast_13[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %51 = memref.load %arg13[%39] : memref<?xf32>
      %52 = arith.addf %50, %51 : f32
      %53 = arith.divf %49, %52 : f32
      %54 = memref.load %reinterpret_cast_3[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %55 = arith.subf %54, %53 : f32
      %56 = arith.addi %arg22, %c-1 : index
      %57 = memref.load %reinterpret_cast_9[%arg21, %56, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %58 = arith.addf %28, %57 : f32
      %59 = arith.mulf %58, %cst_0 : f32
      %60 = memref.load %reinterpret_cast_11[%56, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %61 = arith.addf %38, %60 : f32
      %62 = arith.mulf %59, %61 : f32
      %63 = arith.mulf %62, %19 : f32
      %64 = memref.load %reinterpret_cast_10[%arg21, %56, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %65 = arith.subf %44, %64 : f32
      %66 = arith.mulf %63, %65 : f32
      %67 = memref.load %reinterpret_cast_14[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %68 = arith.mulf %66, %67 : f32
      %69 = memref.load %reinterpret_cast_15[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %70 = memref.load %reinterpret_cast_15[%56, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %71 = arith.addf %69, %70 : f32
      %72 = arith.divf %68, %71 : f32
      %73 = memref.load %reinterpret_cast_5[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %74 = arith.subf %73, %72 : f32
      %75 = memref.load %arg14[%39] : memref<?xf32>
      %76 = arith.addf %69, %75 : f32
      %77 = arith.mulf %76, %cst_0 : f32
      %78 = arith.mulf %77, %55 : f32
      memref.store %78, %reinterpret_cast_3[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %79 = memref.load %reinterpret_cast_13[%56, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %80 = arith.addf %50, %79 : f32
      %81 = arith.mulf %80, %cst_0 : f32
      %82 = arith.mulf %81, %74 : f32
      memref.store %82, %reinterpret_cast_5[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%16, %2, %7) step (%c1, %c1, %c1) {
      %28 = memref.load %reinterpret_cast_8[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = memref.load %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = arith.addf %29, %28 : f32
      memref.store %30, %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_16 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%22, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%22, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%22, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%22, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg21 = %c1 to %22 step %c1 {
      scf.for %arg22 = %c1 to %25 step %c1 {
        %28 = memref.load %reinterpret_cast_16[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %29 = memref.load %reinterpret_cast_17[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %30 = arith.mulf %28, %29 : f32
        %31 = memref.load %reinterpret_cast_18[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %32 = arith.mulf %30, %31 : f32
        memref.store %32, %reinterpret_cast_19[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %33 = arith.muli %arg21, %7 overflow<nsw> : index
        %34 = arith.addi %arg22, %33 : index
        %35 = arith.addi %34, %10 : index
        memref.store %cst, %arg6[%35] : memref<?xf32>
      }
    }
    %reinterpret_cast_20 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c1, %c1, %c1) to (%8, %22, %25) step (%c1, %c1, %c1) {
      %28 = arith.addi %arg21, %c-1 : index
      %29 = memref.load %reinterpret_cast[%28, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = memref.load %reinterpret_cast[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %31 = arith.addf %29, %30 : f32
      %32 = arith.mulf %31, %cst_0 : f32
      %33 = memref.load %reinterpret_cast_20[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %34 = arith.mulf %32, %33 : f32
      %35 = memref.load %reinterpret_cast_18[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %36 = arith.mulf %34, %35 : f32
      memref.store %36, %reinterpret_cast_21[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %26 = memref.get_global @dti2 : memref<1xf32>
    %27 = memref.load %26[%c0] : memref<1xf32>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%8, %2, %7], strides: [%17, %7, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%22, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg19 to offset: [0], sizes: [%22, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg20 to offset: [0], sizes: [%22, %7], strides: [%7, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%8, %22, %25) step (%c1, %c1, %c1) {
      %28 = memref.load %arg15[%arg21] : memref<?xf32>
      %29 = arith.muli %arg22, %7 overflow<nsw> : index
      %30 = arith.addi %arg23, %29 : index
      %31 = arith.muli %arg21, %7 overflow<nsw> : index
      %32 = arith.muli %31, %2 overflow<nsw> : index
      %33 = arith.addi %30, %32 : index
      %34 = arith.addi %33, %c1 : index
      %35 = memref.load %arg4[%34] : memref<?xf32>
      %36 = memref.load %reinterpret_cast_3[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %37 = arith.subf %35, %36 : f32
      %38 = arith.addi %arg22, %c1 : index
      %39 = memref.load %reinterpret_cast_5[%arg21, %38, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %40 = arith.addf %37, %39 : f32
      %41 = memref.load %reinterpret_cast_5[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %42 = arith.subf %40, %41 : f32
      %43 = memref.load %reinterpret_cast_21[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %44 = arith.addi %arg21, %c1 : index
      %45 = memref.load %reinterpret_cast_21[%44, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %46 = arith.subf %43, %45 : f32
      %47 = arith.divf %46, %28 : f32
      %48 = arith.addf %42, %47 : f32
      %49 = memref.load %reinterpret_cast_10[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %50 = memref.load %reinterpret_cast_23[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %51 = memref.load %reinterpret_cast_24[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %52 = arith.addf %50, %51 : f32
      %53 = arith.mulf %49, %52 : f32
      %54 = memref.load %reinterpret_cast_18[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %55 = arith.mulf %53, %54 : f32
      %56 = arith.mulf %27, %48 : f32
      %57 = arith.subf %55, %56 : f32
      %58 = memref.load %reinterpret_cast_25[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %59 = arith.addf %50, %58 : f32
      %60 = arith.mulf %59, %54 : f32
      %61 = arith.divf %57, %60 : f32
      memref.store %61, %reinterpret_cast_22[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


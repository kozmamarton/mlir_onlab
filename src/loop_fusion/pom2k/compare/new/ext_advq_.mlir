module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_advq_(%arg0: memref<?xf32> {polygeist.name = "qb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "qf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 5.000000e-01 : f32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 1.250000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
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
    %reinterpret_cast_2 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20, %arg21) = (%c1, %c1, %c1) to (%2, %7, %8) step (%c1, %c1, %c1) {
      %18 = memref.load %reinterpret_cast[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %19 = arith.muli %arg20, %8 overflow<nsw> : index
      %20 = arith.addi %arg21, %19 : index
      %21 = arith.muli %arg19, %8 overflow<nsw> : index
      %22 = arith.muli %21, %7 overflow<nsw> : index
      %23 = arith.addi %20, %22 : index
      %24 = arith.addi %23, %c-1 : index
      %25 = memref.load %arg1[%24] : memref<?xf32>
      %26 = arith.addf %18, %25 : f32
      %27 = arith.mulf %26, %cst_1 : f32
      %28 = memref.load %reinterpret_cast_8[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %29 = arith.addi %20, %c-1 : index
      %30 = memref.load %arg5[%29] : memref<?xf32>
      %31 = arith.addf %28, %30 : f32
      %32 = arith.mulf %27, %31 : f32
      %33 = memref.load %reinterpret_cast_2[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %34 = arith.addi %arg19, %c-1 : index
      %35 = memref.load %reinterpret_cast_2[%34, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %36 = arith.addf %33, %35 : f32
      %37 = arith.mulf %32, %36 : f32
      %38 = arith.addi %arg20, %c-1 : index
      %39 = memref.load %reinterpret_cast[%arg19, %38, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %40 = arith.addf %18, %39 : f32
      %41 = arith.mulf %40, %cst_1 : f32
      %42 = memref.load %reinterpret_cast_8[%38, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %43 = arith.addf %28, %42 : f32
      %44 = arith.mulf %41, %43 : f32
      %45 = memref.load %reinterpret_cast_4[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %46 = memref.load %reinterpret_cast_4[%34, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %47 = arith.addf %45, %46 : f32
      %48 = arith.mulf %44, %47 : f32
      %49 = memref.load %reinterpret_cast_9[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %50 = arith.mulf %49, %cst_0 : f32
      %51 = memref.load %reinterpret_cast_6[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %52 = memref.load %arg8[%24] : memref<?xf32>
      %53 = arith.addf %51, %52 : f32
      %54 = memref.load %reinterpret_cast_6[%34, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %55 = arith.addf %53, %54 : f32
      %56 = arith.muli %34, %8 overflow<nsw> : index
      %57 = arith.muli %56, %7 overflow<nsw> : index
      %58 = arith.addi %20, %57 : index
      %59 = arith.addi %58, %c-1 : index
      %60 = memref.load %arg8[%59] : memref<?xf32>
      %61 = arith.addf %55, %60 : f32
      %62 = arith.mulf %50, %61 : f32
      %63 = memref.load %reinterpret_cast_10[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %64 = memref.load %arg9[%29] : memref<?xf32>
      %65 = arith.addf %63, %64 : f32
      %66 = arith.mulf %62, %65 : f32
      %67 = memref.load %reinterpret_cast_7[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %68 = memref.load %arg0[%24] : memref<?xf32>
      %69 = arith.subf %67, %68 : f32
      %70 = arith.mulf %66, %69 : f32
      %71 = memref.load %reinterpret_cast_11[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %72 = memref.load %arg11[%29] : memref<?xf32>
      %73 = arith.addf %71, %72 : f32
      %74 = arith.divf %70, %73 : f32
      %75 = arith.subf %37, %74 : f32
      %76 = memref.load %reinterpret_cast_12[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %77 = arith.mulf %76, %cst_0 : f32
      %78 = memref.load %reinterpret_cast_6[%arg19, %38, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %79 = arith.addf %51, %78 : f32
      %80 = arith.addf %79, %54 : f32
      %81 = memref.load %reinterpret_cast_6[%34, %38, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %82 = arith.addf %80, %81 : f32
      %83 = arith.mulf %77, %82 : f32
      %84 = memref.load %reinterpret_cast_10[%38, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %85 = arith.addf %63, %84 : f32
      %86 = arith.mulf %83, %85 : f32
      %87 = memref.load %reinterpret_cast_7[%arg19, %38, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %88 = arith.subf %67, %87 : f32
      %89 = arith.mulf %86, %88 : f32
      %90 = memref.load %reinterpret_cast_13[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %91 = memref.load %reinterpret_cast_13[%38, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %92 = arith.addf %90, %91 : f32
      %93 = arith.divf %89, %92 : f32
      %94 = arith.subf %48, %93 : f32
      %95 = memref.load %arg13[%29] : memref<?xf32>
      %96 = arith.addf %90, %95 : f32
      %97 = arith.mulf %96, %cst : f32
      %98 = arith.mulf %75, %97 : f32
      memref.store %98, %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %99 = memref.load %reinterpret_cast_11[%38, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %100 = arith.addf %71, %99 : f32
      %101 = arith.mulf %100, %cst : f32
      %102 = arith.mulf %94, %101 : f32
      memref.store %102, %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.get_global @jmm1 : memref<1xi32>
    %11 = memref.get_global @imm1 : memref<1xi32>
    %12 = memref.get_global @dti2 : memref<1xf32>
    %13 = memref.load %10[%c0] : memref<1xi32>
    %14 = memref.load %11[%c0] : memref<1xi32>
    %15 = memref.load %12[%c0] : memref<1xf32>
    %16 = arith.index_cast %13 : i32 to index
    %17 = arith.index_cast %14 : i32 to index
    %reinterpret_cast_14 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%16, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%16, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%16, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%16, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20, %arg21) = (%c1, %c1, %c1) to (%2, %16, %17) step (%c1, %c1, %c1) {
      %18 = memref.load %arg15[%arg19] : memref<?xf32>
      %19 = arith.addi %arg19, %c-1 : index
      %20 = memref.load %arg15[%19] : memref<?xf32>
      %21 = arith.addf %18, %20 : f32
      %22 = memref.load %reinterpret_cast_14[%19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %23 = memref.load %reinterpret_cast[%19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %24 = arith.mulf %22, %23 : f32
      %25 = arith.addi %arg19, %c1 : index
      %26 = memref.load %reinterpret_cast_14[%25, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %27 = memref.load %reinterpret_cast[%25, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %28 = arith.mulf %26, %27 : f32
      %29 = arith.subf %24, %28 : f32
      %30 = memref.load %reinterpret_cast_16[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %31 = arith.mulf %29, %30 : f32
      %32 = arith.divf %31, %21 : f32
      %33 = arith.muli %arg20, %8 overflow<nsw> : index
      %34 = arith.addi %arg21, %33 : index
      %35 = arith.muli %arg19, %8 overflow<nsw> : index
      %36 = arith.muli %35, %7 overflow<nsw> : index
      %37 = arith.addi %34, %36 : index
      %38 = arith.addi %37, %c1 : index
      %39 = memref.load %arg3[%38] : memref<?xf32>
      %40 = arith.addf %32, %39 : f32
      %41 = memref.load %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %42 = arith.subf %40, %41 : f32
      %43 = arith.addi %arg20, %c1 : index
      %44 = memref.load %reinterpret_cast_5[%arg19, %43, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %45 = arith.addf %42, %44 : f32
      %46 = memref.load %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %47 = arith.subf %45, %46 : f32
      %48 = memref.load %reinterpret_cast_17[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %49 = memref.load %reinterpret_cast_18[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %50 = arith.addf %48, %49 : f32
      %51 = arith.mulf %50, %30 : f32
      %52 = memref.load %reinterpret_cast_7[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %53 = arith.mulf %51, %52 : f32
      %54 = arith.mulf %15, %47 : f32
      %55 = arith.subf %53, %54 : f32
      %56 = memref.load %reinterpret_cast_19[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %57 = arith.addf %48, %56 : f32
      %58 = arith.mulf %57, %30 : f32
      %59 = arith.divf %55, %58 : f32
      memref.store %59, %reinterpret_cast_15[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


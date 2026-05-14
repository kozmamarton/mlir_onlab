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
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg19, %arg20, %arg21) = (%c1, %c1, %c1) to (%2, %7, %8) step (%c1, %c1, %c1) {
      %32 = memref.load %reinterpret_cast[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %33 = arith.muli %arg20, %8 overflow<nsw> : index
      %34 = arith.addi %arg21, %33 : index
      %35 = arith.muli %arg19, %8 overflow<nsw> : index
      %36 = arith.muli %35, %7 overflow<nsw> : index
      %37 = arith.addi %34, %36 : index
      %38 = arith.addi %37, %c-1 : index
      %39 = memref.load %arg1[%38] : memref<?xf32>
      %40 = arith.addf %32, %39 : f32
      %41 = arith.mulf %40, %cst_1 : f32
      %42 = memref.load %reinterpret_cast_2[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %43 = arith.addi %34, %c-1 : index
      %44 = memref.load %arg5[%43] : memref<?xf32>
      %45 = arith.addf %42, %44 : f32
      %46 = arith.mulf %41, %45 : f32
      %47 = memref.load %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %48 = arith.addi %arg19, %c-1 : index
      %49 = memref.load %reinterpret_cast_3[%48, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %50 = arith.addf %47, %49 : f32
      %51 = arith.mulf %46, %50 : f32
      memref.store %51, %reinterpret_cast_4[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %52 = memref.load %reinterpret_cast[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %53 = arith.addi %arg20, %c-1 : index
      %54 = memref.load %reinterpret_cast[%arg19, %53, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %55 = arith.addf %52, %54 : f32
      %56 = arith.mulf %55, %cst_1 : f32
      %57 = memref.load %reinterpret_cast_2[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %58 = memref.load %reinterpret_cast_2[%53, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %59 = arith.addf %57, %58 : f32
      %60 = arith.mulf %56, %59 : f32
      %61 = memref.load %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %62 = memref.load %reinterpret_cast_5[%48, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %63 = arith.addf %61, %62 : f32
      %64 = arith.mulf %60, %63 : f32
      memref.store %64, %reinterpret_cast_6[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.load %0[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.load %3[%c0] : memref<1xi32>
    %13 = memref.load %4[%c0] : memref<1xi32>
    %14 = arith.index_cast %12 : i32 to index
    %15 = arith.index_cast %13 : i32 to index
    %reinterpret_cast_7 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%14, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %16 = arith.muli %15, %14 : index
    %reinterpret_cast_8 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%11, %14, %15], strides: [%16, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%14, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %14, %15], strides: [%16, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%14, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %14, %15], strides: [%16, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%14, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%14, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %14, %15], strides: [%16, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg19, %arg20, %arg21) = (%c1, %c1, %c1) to (%11, %14, %15) step (%c1, %c1, %c1) {
      %32 = memref.load %reinterpret_cast_7[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %33 = arith.mulf %32, %cst_0 : f32
      %34 = memref.load %reinterpret_cast_8[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %35 = arith.muli %arg20, %15 overflow<nsw> : index
      %36 = arith.addi %arg21, %35 : index
      %37 = arith.muli %arg19, %15 overflow<nsw> : index
      %38 = arith.muli %37, %14 overflow<nsw> : index
      %39 = arith.addi %36, %38 : index
      %40 = arith.addi %39, %c-1 : index
      %41 = memref.load %arg8[%40] : memref<?xf32>
      %42 = arith.addf %34, %41 : f32
      %43 = arith.addi %arg19, %c-1 : index
      %44 = memref.load %reinterpret_cast_8[%43, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %45 = arith.addf %42, %44 : f32
      %46 = arith.muli %43, %15 overflow<nsw> : index
      %47 = arith.muli %46, %14 overflow<nsw> : index
      %48 = arith.addi %36, %47 : index
      %49 = arith.addi %48, %c-1 : index
      %50 = memref.load %arg8[%49] : memref<?xf32>
      %51 = arith.addf %45, %50 : f32
      %52 = arith.mulf %33, %51 : f32
      %53 = memref.load %reinterpret_cast_9[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %54 = arith.addi %36, %c-1 : index
      %55 = memref.load %arg9[%54] : memref<?xf32>
      %56 = arith.addf %53, %55 : f32
      %57 = arith.mulf %52, %56 : f32
      %58 = memref.load %reinterpret_cast_10[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %59 = memref.load %arg0[%40] : memref<?xf32>
      %60 = arith.subf %58, %59 : f32
      %61 = arith.mulf %57, %60 : f32
      %62 = memref.load %reinterpret_cast_11[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %63 = memref.load %arg11[%54] : memref<?xf32>
      %64 = arith.addf %62, %63 : f32
      %65 = arith.divf %61, %64 : f32
      %66 = memref.load %reinterpret_cast_12[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %67 = arith.subf %66, %65 : f32
      memref.store %67, %reinterpret_cast_12[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %68 = memref.load %reinterpret_cast_13[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %69 = arith.mulf %68, %cst_0 : f32
      %70 = memref.load %reinterpret_cast_8[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %71 = arith.addi %arg20, %c-1 : index
      %72 = memref.load %reinterpret_cast_8[%arg19, %71, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %73 = arith.addf %70, %72 : f32
      %74 = memref.load %reinterpret_cast_8[%43, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %75 = arith.addf %73, %74 : f32
      %76 = memref.load %reinterpret_cast_8[%43, %71, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %77 = arith.addf %75, %76 : f32
      %78 = arith.mulf %69, %77 : f32
      %79 = memref.load %reinterpret_cast_9[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %80 = memref.load %reinterpret_cast_9[%71, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %81 = arith.addf %79, %80 : f32
      %82 = arith.mulf %78, %81 : f32
      %83 = memref.load %reinterpret_cast_10[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %84 = memref.load %reinterpret_cast_10[%arg19, %71, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %85 = arith.subf %83, %84 : f32
      %86 = arith.mulf %82, %85 : f32
      %87 = memref.load %reinterpret_cast_14[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %88 = memref.load %reinterpret_cast_14[%71, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %89 = arith.addf %87, %88 : f32
      %90 = arith.divf %86, %89 : f32
      %91 = memref.load %reinterpret_cast_15[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %92 = arith.subf %91, %90 : f32
      memref.store %92, %reinterpret_cast_15[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %93 = memref.load %reinterpret_cast_14[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %94 = memref.load %arg13[%54] : memref<?xf32>
      %95 = arith.addf %93, %94 : f32
      %96 = arith.mulf %95, %cst : f32
      %97 = memref.load %reinterpret_cast_12[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %98 = arith.mulf %97, %96 : f32
      memref.store %98, %reinterpret_cast_12[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %99 = memref.load %reinterpret_cast_11[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %100 = memref.load %reinterpret_cast_11[%71, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %101 = arith.addf %99, %100 : f32
      %102 = arith.mulf %101, %cst : f32
      %103 = memref.load %reinterpret_cast_15[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %104 = arith.mulf %103, %102 : f32
      memref.store %104, %reinterpret_cast_15[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %17 = memref.load %0[%c0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.get_global @jmm1 : memref<1xi32>
    %20 = memref.get_global @imm1 : memref<1xi32>
    %21 = memref.get_global @dti2 : memref<1xf32>
    %22 = memref.load %19[%c0] : memref<1xi32>
    %23 = memref.load %20[%c0] : memref<1xi32>
    %24 = memref.load %4[%c0] : memref<1xi32>
    %25 = memref.load %3[%c0] : memref<1xi32>
    %26 = memref.load %21[%c0] : memref<1xf32>
    %27 = arith.index_cast %22 : i32 to index
    %28 = arith.index_cast %23 : i32 to index
    %29 = arith.index_cast %24 : i32 to index
    %30 = arith.index_cast %25 : i32 to index
    %31 = arith.muli %29, %30 : index
    %reinterpret_cast_16 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%18, %30, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%18, %30, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%27, %29], strides: [%29, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%18, %30, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%18, %30, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%18, %30, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%27, %29], strides: [%29, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%27, %29], strides: [%29, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%18, %30, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%27, %29], strides: [%29, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19) = (%c1) to (%18) step (%c1) {
      %32 = memref.load %arg15[%arg19] : memref<?xf32>
      %33 = arith.addi %arg19, %c-1 : index
      %34 = memref.load %arg15[%33] : memref<?xf32>
      %35 = arith.addf %32, %34 : f32
      scf.parallel (%arg20, %arg21) = (%c1, %c1) to (%27, %28) step (%c1, %c1) {
        %36 = memref.load %reinterpret_cast_16[%33, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %37 = memref.load %reinterpret_cast_17[%33, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %38 = arith.mulf %36, %37 : f32
        %39 = arith.addi %arg19, %c1 : index
        %40 = memref.load %reinterpret_cast_16[%39, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = memref.load %reinterpret_cast_17[%39, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %42 = arith.mulf %40, %41 : f32
        %43 = arith.subf %38, %42 : f32
        %44 = memref.load %reinterpret_cast_18[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %45 = arith.mulf %43, %44 : f32
        %46 = arith.divf %45, %35 : f32
        %47 = arith.muli %arg20, %29 overflow<nsw> : index
        %48 = arith.addi %arg21, %47 : index
        %49 = arith.muli %arg19, %29 overflow<nsw> : index
        %50 = arith.muli %49, %30 overflow<nsw> : index
        %51 = arith.addi %48, %50 : index
        %52 = arith.addi %51, %c1 : index
        %53 = memref.load %arg3[%52] : memref<?xf32>
        %54 = arith.addf %46, %53 : f32
        %55 = memref.load %reinterpret_cast_19[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %56 = arith.subf %54, %55 : f32
        %57 = arith.addi %arg20, %c1 : index
        %58 = memref.load %reinterpret_cast_20[%arg19, %57, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %59 = arith.addf %56, %58 : f32
        %60 = memref.load %reinterpret_cast_20[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %61 = arith.subf %59, %60 : f32
        memref.store %61, %reinterpret_cast_21[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %62 = memref.load %reinterpret_cast_22[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %63 = memref.load %reinterpret_cast_23[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %64 = arith.addf %62, %63 : f32
        %65 = memref.load %reinterpret_cast_18[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %66 = arith.mulf %64, %65 : f32
        %67 = memref.load %reinterpret_cast_24[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %68 = arith.mulf %66, %67 : f32
        %69 = arith.mulf %26, %61 : f32
        %70 = arith.subf %68, %69 : f32
        %71 = memref.load %reinterpret_cast_25[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %72 = arith.addf %62, %71 : f32
        %73 = arith.mulf %72, %65 : f32
        %74 = arith.divf %70, %73 : f32
        memref.store %74, %reinterpret_cast_21[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
}


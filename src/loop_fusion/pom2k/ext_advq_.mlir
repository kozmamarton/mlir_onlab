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
      %25 = memref.load %reinterpret_cast[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %26 = arith.muli %arg20, %8 overflow<nsw> : index
      %27 = arith.addi %arg21, %26 : index
      %28 = arith.muli %arg19, %8 overflow<nsw> : index
      %29 = arith.muli %28, %7 overflow<nsw> : index
      %30 = arith.addi %27, %29 : index
      %31 = arith.addi %30, %c-1 : index
      %32 = memref.load %arg1[%31] : memref<?xf32>
      %33 = arith.addf %25, %32 : f32
      %34 = arith.mulf %33, %cst_1 : f32
      %35 = memref.load %reinterpret_cast_8[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %36 = arith.addi %27, %c-1 : index
      %37 = memref.load %arg5[%36] : memref<?xf32>
      %38 = arith.addf %35, %37 : f32
      %39 = arith.mulf %34, %38 : f32
      %40 = memref.load %reinterpret_cast_2[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %41 = arith.addi %arg19, %c-1 : index
      %42 = memref.load %reinterpret_cast_2[%41, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %43 = arith.addf %40, %42 : f32
      %44 = arith.mulf %39, %43 : f32
      memref.store %44, %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %45 = memref.load %reinterpret_cast[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %46 = arith.addi %arg20, %c-1 : index
      %47 = memref.load %reinterpret_cast[%arg19, %46, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %48 = arith.addf %45, %47 : f32
      %49 = arith.mulf %48, %cst_1 : f32
      %50 = memref.load %reinterpret_cast_8[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %51 = memref.load %reinterpret_cast_8[%46, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %52 = arith.addf %50, %51 : f32
      %53 = arith.mulf %49, %52 : f32
      %54 = memref.load %reinterpret_cast_4[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %55 = memref.load %reinterpret_cast_4[%41, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %56 = arith.addf %54, %55 : f32
      %57 = arith.mulf %53, %56 : f32
      memref.store %57, %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %58 = memref.load %reinterpret_cast_9[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %59 = arith.mulf %58, %cst_0 : f32
      %60 = memref.load %reinterpret_cast_6[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %61 = memref.load %arg8[%31] : memref<?xf32>
      %62 = arith.addf %60, %61 : f32
      %63 = memref.load %reinterpret_cast_6[%41, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %64 = arith.addf %62, %63 : f32
      %65 = arith.muli %41, %8 overflow<nsw> : index
      %66 = arith.muli %65, %7 overflow<nsw> : index
      %67 = arith.addi %27, %66 : index
      %68 = arith.addi %67, %c-1 : index
      %69 = memref.load %arg8[%68] : memref<?xf32>
      %70 = arith.addf %64, %69 : f32
      %71 = arith.mulf %59, %70 : f32
      %72 = memref.load %reinterpret_cast_10[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %73 = memref.load %arg9[%36] : memref<?xf32>
      %74 = arith.addf %72, %73 : f32
      %75 = arith.mulf %71, %74 : f32
      %76 = memref.load %reinterpret_cast_7[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %77 = memref.load %arg0[%31] : memref<?xf32>
      %78 = arith.subf %76, %77 : f32
      %79 = arith.mulf %75, %78 : f32
      %80 = memref.load %reinterpret_cast_11[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %81 = memref.load %arg11[%36] : memref<?xf32>
      %82 = arith.addf %80, %81 : f32
      %83 = arith.divf %79, %82 : f32
      %84 = memref.load %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %85 = arith.subf %84, %83 : f32
      memref.store %85, %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %86 = memref.load %reinterpret_cast_12[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %87 = arith.mulf %86, %cst_0 : f32
      %88 = memref.load %reinterpret_cast_6[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %89 = memref.load %reinterpret_cast_6[%arg19, %46, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %90 = arith.addf %88, %89 : f32
      %91 = memref.load %reinterpret_cast_6[%41, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %92 = arith.addf %90, %91 : f32
      %93 = memref.load %reinterpret_cast_6[%41, %46, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %94 = arith.addf %92, %93 : f32
      %95 = arith.mulf %87, %94 : f32
      %96 = memref.load %reinterpret_cast_10[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %97 = memref.load %reinterpret_cast_10[%46, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %98 = arith.addf %96, %97 : f32
      %99 = arith.mulf %95, %98 : f32
      %100 = memref.load %reinterpret_cast_7[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %101 = memref.load %reinterpret_cast_7[%arg19, %46, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %102 = arith.subf %100, %101 : f32
      %103 = arith.mulf %99, %102 : f32
      %104 = memref.load %reinterpret_cast_13[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %105 = memref.load %reinterpret_cast_13[%46, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %106 = arith.addf %104, %105 : f32
      %107 = arith.divf %103, %106 : f32
      %108 = memref.load %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %109 = arith.subf %108, %107 : f32
      memref.store %109, %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %110 = memref.load %reinterpret_cast_13[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %111 = memref.load %arg13[%36] : memref<?xf32>
      %112 = arith.addf %110, %111 : f32
      %113 = arith.mulf %112, %cst : f32
      %114 = memref.load %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %115 = arith.mulf %114, %113 : f32
      memref.store %115, %reinterpret_cast_3[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %116 = memref.load %reinterpret_cast_11[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %117 = memref.load %reinterpret_cast_11[%46, %arg21] : memref<?x?xf32, strided<[?, 1]>>
      %118 = arith.addf %116, %117 : f32
      %119 = arith.mulf %118, %cst : f32
      %120 = memref.load %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %121 = arith.mulf %120, %119 : f32
      memref.store %121, %reinterpret_cast_5[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.load %0[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @jmm1 : memref<1xi32>
    %13 = memref.get_global @imm1 : memref<1xi32>
    %14 = memref.get_global @dti2 : memref<1xf32>
    %15 = memref.load %12[%c0] : memref<1xi32>
    %16 = memref.load %13[%c0] : memref<1xi32>
    %17 = memref.load %4[%c0] : memref<1xi32>
    %18 = memref.load %3[%c0] : memref<1xi32>
    %19 = memref.load %14[%c0] : memref<1xf32>
    %20 = arith.index_cast %15 : i32 to index
    %21 = arith.index_cast %16 : i32 to index
    %22 = arith.index_cast %17 : i32 to index
    %23 = arith.index_cast %18 : i32 to index
    %24 = arith.muli %22, %23 : index
    %reinterpret_cast_14 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %23, %22], strides: [%24, %22, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%20, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19) = (%c1) to (%11) step (%c1) {
      %25 = memref.load %arg15[%arg19] : memref<?xf32>
      %26 = arith.addi %arg19, %c-1 : index
      %27 = memref.load %arg15[%26] : memref<?xf32>
      %28 = arith.addf %25, %27 : f32
      scf.parallel (%arg20, %arg21) = (%c1, %c1) to (%20, %21) step (%c1, %c1) {
        %29 = memref.load %reinterpret_cast_14[%26, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %30 = memref.load %reinterpret_cast_15[%26, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %31 = arith.mulf %29, %30 : f32
        %32 = arith.addi %arg19, %c1 : index
        %33 = memref.load %reinterpret_cast_14[%32, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %34 = memref.load %reinterpret_cast_15[%32, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %35 = arith.mulf %33, %34 : f32
        %36 = arith.subf %31, %35 : f32
        %37 = memref.load %reinterpret_cast_20[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.mulf %36, %37 : f32
        %39 = arith.divf %38, %28 : f32
        %40 = arith.muli %arg20, %22 overflow<nsw> : index
        %41 = arith.addi %arg21, %40 : index
        %42 = arith.muli %arg19, %22 overflow<nsw> : index
        %43 = arith.muli %42, %23 overflow<nsw> : index
        %44 = arith.addi %41, %43 : index
        %45 = arith.addi %44, %c1 : index
        %46 = memref.load %arg3[%45] : memref<?xf32>
        %47 = arith.addf %39, %46 : f32
        %48 = memref.load %reinterpret_cast_16[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %49 = arith.subf %47, %48 : f32
        %50 = arith.addi %arg20, %c1 : index
        %51 = memref.load %reinterpret_cast_17[%arg19, %50, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %52 = arith.addf %49, %51 : f32
        %53 = memref.load %reinterpret_cast_17[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %54 = arith.subf %52, %53 : f32
        memref.store %54, %reinterpret_cast_18[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %55 = memref.load %reinterpret_cast_21[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %56 = memref.load %reinterpret_cast_22[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %57 = arith.addf %55, %56 : f32
        %58 = memref.load %reinterpret_cast_20[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %59 = arith.mulf %57, %58 : f32
        %60 = memref.load %reinterpret_cast_19[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %61 = arith.mulf %59, %60 : f32
        %62 = arith.mulf %19, %54 : f32
        %63 = arith.subf %61, %62 : f32
        %64 = memref.load %reinterpret_cast_23[%arg20, %arg21] : memref<?x?xf32, strided<[?, 1]>>
        %65 = arith.addf %55, %64 : f32
        %66 = arith.mulf %65, %58 : f32
        %67 = arith.divf %63, %66 : f32
        memref.store %67, %reinterpret_cast_18[%arg19, %arg20, %arg21] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
}


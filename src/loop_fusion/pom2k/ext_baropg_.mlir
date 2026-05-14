module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_baropg_(%arg0: memref<?xf32> {polygeist.name = "rho", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "rmean", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "zz", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "ramp", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c1, %c1, %c1) {
      %103 = memref.load %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %104 = memref.load %reinterpret_cast_1[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %105 = arith.subf %103, %104 : f32
      memref.store %105, %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.get_global @jmm1 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @imm1 : memref<1xi32>
    %14 = memref.get_global @grav : memref<1xf32>
    %15 = memref.load %13[%c0] : memref<1xi32>
    %16 = memref.load %4[%c0] : memref<1xi32>
    %17 = memref.load %14[%c0] : memref<1xf32>
    %18 = memref.load %arg4[%c0] : memref<?xf32>
    %19 = arith.index_cast %15 : i32 to index
    %20 = arith.index_cast %16 : i32 to index
    %21 = arith.mulf %17, %cst_0 : f32
    %22 = arith.negf %18 : f32
    %23 = arith.mulf %21, %22 : f32
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%12, %20], strides: [%20, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%12, %20], strides: [%20, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%12, %20], strides: [%20, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%12, %19) step (%c1, %c1) {
      %103 = memref.load %reinterpret_cast_2[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %104 = arith.muli %arg11, %20 overflow<nsw> : index
      %105 = arith.addi %arg12, %104 : index
      %106 = arith.addi %105, %c-1 : index
      %107 = memref.load %arg5[%106] : memref<?xf32>
      %108 = arith.addf %103, %107 : f32
      %109 = arith.mulf %23, %108 : f32
      %110 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %111 = memref.load %arg0[%106] : memref<?xf32>
      %112 = arith.subf %110, %111 : f32
      %113 = arith.mulf %109, %112 : f32
      memref.store %113, %reinterpret_cast_4[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %24 = memref.get_global @kbm1 : memref<1xi32>
    %25 = memref.load %24[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    %27 = memref.load %10[%c0] : memref<1xi32>
    %28 = memref.load %13[%c0] : memref<1xi32>
    %29 = memref.load %4[%c0] : memref<1xi32>
    %30 = memref.load %3[%c0] : memref<1xi32>
    %31 = memref.load %14[%c0] : memref<1xf32>
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.index_cast %30 : i32 to index
    %36 = arith.mulf %31, %cst : f32
    %37 = arith.muli %34, %35 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%26, %35, %34], strides: [%37, %34, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%32, %34], strides: [%34, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%26, %35, %34], strides: [%37, %34, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg11 = %c1 to %26 step %c1 {
      %103 = arith.addi %arg11, %c-1 : index
      %104 = memref.load %arg4[%103] : memref<?xf32>
      %105 = memref.load %arg4[%arg11] : memref<?xf32>
      %106 = arith.subf %104, %105 : f32
      %107 = arith.mulf %36, %106 : f32
      %108 = arith.addf %104, %105 : f32
      %109 = arith.mulf %36, %108 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%32, %33) step (%c1, %c1) {
        %110 = memref.load %reinterpret_cast_5[%103, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %111 = memref.load %reinterpret_cast_6[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %112 = arith.muli %arg12, %34 overflow<nsw> : index
        %113 = arith.addi %arg13, %112 : index
        %114 = arith.addi %113, %c-1 : index
        %115 = memref.load %arg5[%114] : memref<?xf32>
        %116 = arith.addf %111, %115 : f32
        %117 = arith.mulf %107, %116 : f32
        %118 = memref.load %reinterpret_cast_7[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %119 = arith.muli %arg11, %34 overflow<nsw> : index
        %120 = arith.muli %119, %35 overflow<nsw> : index
        %121 = arith.addi %113, %120 : index
        %122 = arith.addi %121, %c-1 : index
        %123 = memref.load %arg0[%122] : memref<?xf32>
        %124 = arith.subf %118, %123 : f32
        %125 = memref.load %reinterpret_cast_7[%103, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %126 = arith.addf %124, %125 : f32
        %127 = arith.muli %103, %34 overflow<nsw> : index
        %128 = arith.muli %127, %35 overflow<nsw> : index
        %129 = arith.addi %113, %128 : index
        %130 = arith.addi %129, %c-1 : index
        %131 = memref.load %arg0[%130] : memref<?xf32>
        %132 = arith.subf %126, %131 : f32
        %133 = arith.mulf %117, %132 : f32
        %134 = arith.addf %110, %133 : f32
        %135 = arith.subf %111, %115 : f32
        %136 = arith.mulf %109, %135 : f32
        %137 = arith.addf %118, %123 : f32
        %138 = arith.subf %137, %125 : f32
        %139 = arith.subf %138, %131 : f32
        %140 = arith.mulf %136, %139 : f32
        %141 = arith.addf %134, %140 : f32
        memref.store %141, %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %38 = memref.load %24[%c0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = memref.load %10[%c0] : memref<1xi32>
    %41 = memref.load %13[%c0] : memref<1xi32>
    %42 = memref.load %4[%c0] : memref<1xi32>
    %43 = memref.load %3[%c0] : memref<1xi32>
    %44 = arith.index_cast %40 : i32 to index
    %45 = arith.index_cast %41 : i32 to index
    %46 = arith.index_cast %42 : i32 to index
    %47 = arith.index_cast %43 : i32 to index
    %reinterpret_cast_8 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%44, %46], strides: [%46, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %48 = arith.muli %46, %47 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%39, %47, %46], strides: [%48, %46, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%44, %46], strides: [%46, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%44, %46], strides: [%46, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%39, %44, %45) step (%c1, %c1, %c1) {
      %103 = memref.load %reinterpret_cast_8[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %104 = arith.muli %arg12, %46 overflow<nsw> : index
      %105 = arith.addi %arg13, %104 : index
      %106 = arith.addi %105, %c-1 : index
      %107 = memref.load %arg5[%106] : memref<?xf32>
      %108 = arith.addf %103, %107 : f32
      %109 = arith.mulf %108, %cst : f32
      %110 = memref.load %reinterpret_cast_9[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %111 = arith.mulf %109, %110 : f32
      %112 = memref.load %reinterpret_cast_10[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %113 = arith.mulf %111, %112 : f32
      %114 = memref.load %reinterpret_cast_11[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %115 = memref.load %arg9[%106] : memref<?xf32>
      %116 = arith.addf %114, %115 : f32
      %117 = arith.mulf %113, %116 : f32
      memref.store %117, %reinterpret_cast_9[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %49 = memref.load %10[%c0] : memref<1xi32>
    %50 = arith.index_cast %49 : i32 to index
    %51 = memref.load %13[%c0] : memref<1xi32>
    %52 = memref.load %4[%c0] : memref<1xi32>
    %53 = memref.load %14[%c0] : memref<1xf32>
    %54 = memref.load %arg4[%c0] : memref<?xf32>
    %55 = arith.index_cast %51 : i32 to index
    %56 = arith.index_cast %52 : i32 to index
    %57 = arith.mulf %53, %cst_0 : f32
    %58 = arith.negf %54 : f32
    %59 = arith.mulf %57, %58 : f32
    %reinterpret_cast_12 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%50, %56], strides: [%56, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%50, %56], strides: [%56, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%50, %56], strides: [%56, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%50, %55) step (%c1, %c1) {
      %103 = memref.load %reinterpret_cast_12[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %104 = arith.addi %arg11, %c-1 : index
      %105 = memref.load %reinterpret_cast_12[%104, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %106 = arith.addf %103, %105 : f32
      %107 = arith.mulf %59, %106 : f32
      %108 = memref.load %reinterpret_cast_13[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %109 = memref.load %reinterpret_cast_13[%104, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %110 = arith.subf %108, %109 : f32
      %111 = arith.mulf %107, %110 : f32
      memref.store %111, %reinterpret_cast_14[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %60 = memref.load %24[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    %62 = memref.load %10[%c0] : memref<1xi32>
    %63 = memref.load %13[%c0] : memref<1xi32>
    %64 = memref.load %4[%c0] : memref<1xi32>
    %65 = memref.load %3[%c0] : memref<1xi32>
    %66 = memref.load %14[%c0] : memref<1xf32>
    %67 = arith.index_cast %62 : i32 to index
    %68 = arith.index_cast %63 : i32 to index
    %69 = arith.index_cast %64 : i32 to index
    %70 = arith.index_cast %65 : i32 to index
    %71 = arith.mulf %66, %cst : f32
    %72 = arith.muli %69, %70 : index
    %reinterpret_cast_15 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%61, %70, %69], strides: [%72, %69, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%67, %69], strides: [%69, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%61, %70, %69], strides: [%72, %69, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg11 = %c1 to %61 step %c1 {
      %103 = arith.addi %arg11, %c-1 : index
      %104 = memref.load %arg4[%103] : memref<?xf32>
      %105 = memref.load %arg4[%arg11] : memref<?xf32>
      %106 = arith.subf %104, %105 : f32
      %107 = arith.mulf %71, %106 : f32
      %108 = arith.addf %104, %105 : f32
      %109 = arith.mulf %71, %108 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%67, %68) step (%c1, %c1) {
        %110 = memref.load %reinterpret_cast_15[%103, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %111 = memref.load %reinterpret_cast_16[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %112 = arith.addi %arg12, %c-1 : index
        %113 = memref.load %reinterpret_cast_16[%112, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %114 = arith.addf %111, %113 : f32
        %115 = arith.mulf %107, %114 : f32
        %116 = memref.load %reinterpret_cast_17[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %117 = memref.load %reinterpret_cast_17[%arg11, %112, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %118 = arith.subf %116, %117 : f32
        %119 = memref.load %reinterpret_cast_17[%103, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %120 = arith.addf %118, %119 : f32
        %121 = memref.load %reinterpret_cast_17[%103, %112, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %122 = arith.subf %120, %121 : f32
        %123 = arith.mulf %115, %122 : f32
        %124 = arith.addf %110, %123 : f32
        %125 = arith.subf %111, %113 : f32
        %126 = arith.mulf %109, %125 : f32
        %127 = arith.addf %116, %117 : f32
        %128 = arith.subf %127, %119 : f32
        %129 = arith.subf %128, %121 : f32
        %130 = arith.mulf %126, %129 : f32
        %131 = arith.addf %124, %130 : f32
        memref.store %131, %reinterpret_cast_15[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %73 = memref.load %24[%c0] : memref<1xi32>
    %74 = arith.index_cast %73 : i32 to index
    %75 = memref.load %10[%c0] : memref<1xi32>
    %76 = memref.load %13[%c0] : memref<1xi32>
    %77 = memref.load %4[%c0] : memref<1xi32>
    %78 = memref.load %3[%c0] : memref<1xi32>
    %79 = arith.index_cast %75 : i32 to index
    %80 = arith.index_cast %76 : i32 to index
    %81 = arith.index_cast %77 : i32 to index
    %82 = arith.index_cast %78 : i32 to index
    %reinterpret_cast_18 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%79, %81], strides: [%81, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %83 = arith.muli %81, %82 : index
    %reinterpret_cast_19 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%74, %82, %81], strides: [%83, %81, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%79, %81], strides: [%81, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%79, %81], strides: [%81, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%74, %79, %80) step (%c1, %c1, %c1) {
      %103 = memref.load %reinterpret_cast_18[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %104 = arith.addi %arg12, %c-1 : index
      %105 = memref.load %reinterpret_cast_18[%104, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %106 = arith.addf %103, %105 : f32
      %107 = arith.mulf %106, %cst : f32
      %108 = memref.load %reinterpret_cast_19[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %109 = arith.mulf %107, %108 : f32
      %110 = memref.load %reinterpret_cast_20[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %111 = arith.mulf %109, %110 : f32
      %112 = memref.load %reinterpret_cast_21[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %113 = memref.load %reinterpret_cast_21[%104, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %114 = arith.addf %112, %113 : f32
      %115 = arith.mulf %111, %114 : f32
      memref.store %115, %reinterpret_cast_19[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %84 = memref.load %0[%c0] : memref<1xi32>
    %85 = arith.index_cast %84 : i32 to index
    %86 = memref.load %10[%c0] : memref<1xi32>
    %87 = memref.load %13[%c0] : memref<1xi32>
    %88 = memref.load %4[%c0] : memref<1xi32>
    %89 = memref.load %3[%c0] : memref<1xi32>
    %90 = memref.load %arg10[%c0] : memref<?xf32>
    %91 = arith.index_cast %86 : i32 to index
    %92 = arith.index_cast %87 : i32 to index
    %93 = arith.index_cast %88 : i32 to index
    %94 = arith.index_cast %89 : i32 to index
    %95 = arith.muli %93, %94 : index
    %reinterpret_cast_22 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%85, %94, %93], strides: [%95, %93, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%85, %94, %93], strides: [%95, %93, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%85, %91, %92) step (%c1, %c1, %c1) {
      %103 = memref.load %reinterpret_cast_22[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %104 = arith.mulf %90, %103 : f32
      memref.store %104, %reinterpret_cast_22[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %105 = memref.load %reinterpret_cast_23[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %106 = arith.mulf %90, %105 : f32
      memref.store %106, %reinterpret_cast_23[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %96 = memref.load %0[%c0] : memref<1xi32>
    %97 = arith.index_cast %96 : i32 to index
    %98 = memref.load %3[%c0] : memref<1xi32>
    %99 = memref.load %4[%c0] : memref<1xi32>
    %100 = arith.index_cast %98 : i32 to index
    %101 = arith.index_cast %99 : i32 to index
    %102 = arith.muli %101, %100 : index
    %reinterpret_cast_24 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%97, %100, %101], strides: [%102, %101, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%97, %100, %101], strides: [%102, %101, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%97, %100, %101) step (%c1, %c1, %c1) {
      %103 = memref.load %reinterpret_cast_24[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %104 = memref.load %reinterpret_cast_25[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %105 = arith.addf %103, %104 : f32
      memref.store %105, %reinterpret_cast_24[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


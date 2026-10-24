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
      %76 = memref.load %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %77 = memref.load %reinterpret_cast_1[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %78 = arith.subf %76, %77 : f32
      memref.store %78, %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
      %76 = memref.load %reinterpret_cast_2[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %77 = arith.muli %arg11, %20 overflow<nsw> : index
      %78 = arith.addi %arg12, %77 : index
      %79 = arith.addi %78, %c-1 : index
      %80 = memref.load %arg5[%79] : memref<?xf32>
      %81 = arith.addf %76, %80 : f32
      %82 = arith.mulf %23, %81 : f32
      %83 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %84 = memref.load %arg0[%79] : memref<?xf32>
      %85 = arith.subf %83, %84 : f32
      %86 = arith.mulf %82, %85 : f32
      memref.store %86, %reinterpret_cast_4[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
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
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%26, %35, %34], strides: [%37, %34, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%32, %34], strides: [%34, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg11 = %c1 to %26 step %c1 {
      %76 = arith.addi %arg11, %c-1 : index
      %77 = memref.load %arg4[%76] : memref<?xf32>
      %78 = memref.load %arg4[%arg11] : memref<?xf32>
      %79 = arith.subf %77, %78 : f32
      %80 = arith.mulf %36, %79 : f32
      %81 = arith.addf %77, %78 : f32
      %82 = arith.mulf %36, %81 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%32, %33) step (%c1, %c1) {
        %83 = memref.load %reinterpret_cast_5[%76, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %84 = memref.load %reinterpret_cast_7[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %85 = arith.muli %arg12, %34 overflow<nsw> : index
        %86 = arith.addi %arg13, %85 : index
        %87 = arith.addi %86, %c-1 : index
        %88 = memref.load %arg5[%87] : memref<?xf32>
        %89 = arith.addf %84, %88 : f32
        %90 = arith.mulf %80, %89 : f32
        %91 = memref.load %reinterpret_cast_6[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %92 = arith.muli %arg11, %34 overflow<nsw> : index
        %93 = arith.muli %92, %35 overflow<nsw> : index
        %94 = arith.addi %86, %93 : index
        %95 = arith.addi %94, %c-1 : index
        %96 = memref.load %arg0[%95] : memref<?xf32>
        %97 = arith.subf %91, %96 : f32
        %98 = memref.load %reinterpret_cast_6[%76, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %99 = arith.addf %97, %98 : f32
        %100 = arith.muli %76, %34 overflow<nsw> : index
        %101 = arith.muli %100, %35 overflow<nsw> : index
        %102 = arith.addi %86, %101 : index
        %103 = arith.addi %102, %c-1 : index
        %104 = memref.load %arg0[%103] : memref<?xf32>
        %105 = arith.subf %99, %104 : f32
        %106 = arith.mulf %90, %105 : f32
        %107 = arith.addf %83, %106 : f32
        %108 = arith.subf %84, %88 : f32
        %109 = arith.mulf %82, %108 : f32
        %110 = arith.addf %91, %96 : f32
        %111 = arith.subf %110, %98 : f32
        %112 = arith.subf %111, %104 : f32
        %113 = arith.mulf %109, %112 : f32
        %114 = arith.addf %107, %113 : f32
        memref.store %114, %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %reinterpret_cast_8 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%32, %34], strides: [%34, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%32, %34], strides: [%34, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%26, %32, %33) step (%c1, %c1, %c1) {
      %76 = memref.load %reinterpret_cast_7[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %77 = arith.muli %arg12, %34 overflow<nsw> : index
      %78 = arith.addi %arg13, %77 : index
      %79 = arith.addi %78, %c-1 : index
      %80 = memref.load %arg5[%79] : memref<?xf32>
      %81 = arith.addf %76, %80 : f32
      %82 = arith.mulf %81, %cst : f32
      %83 = memref.load %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %84 = arith.mulf %82, %83 : f32
      %85 = memref.load %reinterpret_cast_8[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %86 = arith.mulf %84, %85 : f32
      %87 = memref.load %reinterpret_cast_9[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %88 = memref.load %arg9[%79] : memref<?xf32>
      %89 = arith.addf %87, %88 : f32
      %90 = arith.mulf %86, %89 : f32
      memref.store %90, %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %38 = memref.load %10[%c0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = memref.load %13[%c0] : memref<1xi32>
    %41 = memref.load %4[%c0] : memref<1xi32>
    %42 = memref.load %14[%c0] : memref<1xf32>
    %43 = memref.load %arg4[%c0] : memref<?xf32>
    %44 = arith.index_cast %40 : i32 to index
    %45 = arith.index_cast %41 : i32 to index
    %46 = arith.mulf %42, %cst_0 : f32
    %47 = arith.negf %43 : f32
    %48 = arith.mulf %46, %47 : f32
    %reinterpret_cast_10 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%39, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%39, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%39, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%39, %44) step (%c1, %c1) {
      %76 = memref.load %reinterpret_cast_10[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %77 = arith.addi %arg11, %c-1 : index
      %78 = memref.load %reinterpret_cast_10[%77, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %79 = arith.addf %76, %78 : f32
      %80 = arith.mulf %48, %79 : f32
      %81 = memref.load %reinterpret_cast_11[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %82 = memref.load %reinterpret_cast_11[%77, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %83 = arith.subf %81, %82 : f32
      %84 = arith.mulf %80, %83 : f32
      memref.store %84, %reinterpret_cast_12[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %49 = memref.load %24[%c0] : memref<1xi32>
    %50 = arith.index_cast %49 : i32 to index
    %51 = memref.load %10[%c0] : memref<1xi32>
    %52 = memref.load %13[%c0] : memref<1xi32>
    %53 = memref.load %4[%c0] : memref<1xi32>
    %54 = memref.load %3[%c0] : memref<1xi32>
    %55 = memref.load %14[%c0] : memref<1xf32>
    %56 = arith.index_cast %51 : i32 to index
    %57 = arith.index_cast %52 : i32 to index
    %58 = arith.index_cast %53 : i32 to index
    %59 = arith.index_cast %54 : i32 to index
    %60 = arith.mulf %55, %cst : f32
    %61 = arith.muli %58, %59 : index
    %reinterpret_cast_13 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%50, %59, %58], strides: [%61, %58, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%50, %59, %58], strides: [%61, %58, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%56, %58], strides: [%58, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg11 = %c1 to %50 step %c1 {
      %76 = arith.addi %arg11, %c-1 : index
      %77 = memref.load %arg4[%76] : memref<?xf32>
      %78 = memref.load %arg4[%arg11] : memref<?xf32>
      %79 = arith.subf %77, %78 : f32
      %80 = arith.mulf %60, %79 : f32
      %81 = arith.addf %77, %78 : f32
      %82 = arith.mulf %60, %81 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%56, %57) step (%c1, %c1) {
        %83 = memref.load %reinterpret_cast_13[%76, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %84 = memref.load %reinterpret_cast_15[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %85 = arith.addi %arg12, %c-1 : index
        %86 = memref.load %reinterpret_cast_15[%85, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %87 = arith.addf %84, %86 : f32
        %88 = arith.mulf %80, %87 : f32
        %89 = memref.load %reinterpret_cast_14[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %90 = memref.load %reinterpret_cast_14[%arg11, %85, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %91 = arith.subf %89, %90 : f32
        %92 = memref.load %reinterpret_cast_14[%76, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %93 = arith.addf %91, %92 : f32
        %94 = memref.load %reinterpret_cast_14[%76, %85, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %95 = arith.subf %93, %94 : f32
        %96 = arith.mulf %88, %95 : f32
        %97 = arith.addf %83, %96 : f32
        %98 = arith.subf %84, %86 : f32
        %99 = arith.mulf %82, %98 : f32
        %100 = arith.addf %89, %90 : f32
        %101 = arith.subf %100, %92 : f32
        %102 = arith.subf %101, %94 : f32
        %103 = arith.mulf %99, %102 : f32
        %104 = arith.addf %97, %103 : f32
        memref.store %104, %reinterpret_cast_13[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %reinterpret_cast_16 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%56, %58], strides: [%58, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%56, %58], strides: [%58, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%50, %56, %57) step (%c1, %c1, %c1) {
      %76 = memref.load %reinterpret_cast_15[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %77 = arith.addi %arg12, %c-1 : index
      %78 = memref.load %reinterpret_cast_15[%77, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %79 = arith.addf %76, %78 : f32
      %80 = arith.mulf %79, %cst : f32
      %81 = memref.load %reinterpret_cast_13[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %82 = arith.mulf %80, %81 : f32
      %83 = memref.load %reinterpret_cast_16[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %84 = arith.mulf %82, %83 : f32
      %85 = memref.load %reinterpret_cast_17[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %86 = memref.load %reinterpret_cast_17[%77, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %87 = arith.addf %85, %86 : f32
      %88 = arith.mulf %84, %87 : f32
      memref.store %88, %reinterpret_cast_13[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %62 = memref.load %0[%c0] : memref<1xi32>
    %63 = arith.index_cast %62 : i32 to index
    %64 = memref.load %10[%c0] : memref<1xi32>
    %65 = memref.load %13[%c0] : memref<1xi32>
    %66 = memref.load %4[%c0] : memref<1xi32>
    %67 = memref.load %3[%c0] : memref<1xi32>
    %68 = memref.load %arg10[%c0] : memref<?xf32>
    %69 = arith.index_cast %64 : i32 to index
    %70 = arith.index_cast %65 : i32 to index
    %71 = arith.index_cast %66 : i32 to index
    %72 = arith.index_cast %67 : i32 to index
    %73 = arith.muli %71, %72 : index
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%63, %72, %71], strides: [%73, %71, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%63, %72, %71], strides: [%73, %71, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%63, %72, %71], strides: [%73, %71, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%63, %72, %71], strides: [%73, %71, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %74 = arith.maxsi %72, %69 : index
    %75 = arith.maxsi %71, %70 : index
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%63, %74, %75) step (%c1, %c1, %c1) {
      %76 = arith.addi %arg12, %c-1 : index
      %77 = arith.cmpi sge, %76, %c0 : index
      %78 = arith.subi %69, %arg12 : index
      %79 = arith.addi %78, %c-1 : index
      %80 = arith.cmpi sge, %79, %c0 : index
      %81 = arith.andi %77, %80 : i1
      %82 = arith.addi %arg13, %c-1 : index
      %83 = arith.cmpi sge, %82, %c0 : index
      %84 = arith.andi %81, %83 : i1
      %85 = arith.subi %70, %arg13 : index
      %86 = arith.addi %85, %c-1 : index
      %87 = arith.cmpi sge, %86, %c0 : index
      %88 = arith.andi %84, %87 : i1
      scf.if %88 {
        %96 = memref.load %reinterpret_cast_18[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %97 = arith.mulf %68, %96 : f32
        memref.store %97, %reinterpret_cast_18[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %98 = memref.load %reinterpret_cast_19[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %99 = arith.mulf %68, %98 : f32
        memref.store %99, %reinterpret_cast_19[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      }
      %89 = arith.subi %72, %arg12 : index
      %90 = arith.addi %89, %c-1 : index
      %91 = arith.cmpi sge, %90, %c0 : index
      %92 = arith.subi %71, %arg13 : index
      %93 = arith.addi %92, %c-1 : index
      %94 = arith.cmpi sge, %93, %c0 : index
      %95 = arith.andi %91, %94 : i1
      scf.if %95 {
        %96 = memref.load %reinterpret_cast_20[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %97 = memref.load %reinterpret_cast_21[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %98 = arith.addf %96, %97 : f32
        memref.store %98, %reinterpret_cast_20[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      }
      scf.reduce 
    }
    return
  }
}


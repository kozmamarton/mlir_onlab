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
      %27 = memref.load %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %28 = memref.load %reinterpret_cast_1[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = arith.subf %27, %28 : f32
      memref.store %29, %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.get_global @jmm1 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @imm1 : memref<1xi32>
    %14 = memref.get_global @grav : memref<1xf32>
    %15 = memref.load %13[%c0] : memref<1xi32>
    %16 = memref.load %14[%c0] : memref<1xf32>
    %17 = memref.load %arg4[%c0] : memref<?xf32>
    %18 = arith.index_cast %15 : i32 to index
    %19 = arith.mulf %16, %cst_0 : f32
    %20 = arith.negf %17 : f32
    %21 = arith.mulf %19, %20 : f32
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%12, %18) step (%c1, %c1) {
      %27 = memref.load %reinterpret_cast_2[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %28 = arith.muli %arg11, %8 overflow<nsw> : index
      %29 = arith.addi %arg12, %28 : index
      %30 = arith.addi %29, %c-1 : index
      %31 = memref.load %arg5[%30] : memref<?xf32>
      %32 = arith.addf %27, %31 : f32
      %33 = arith.mulf %21, %32 : f32
      %34 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %35 = memref.load %arg0[%30] : memref<?xf32>
      %36 = arith.subf %34, %35 : f32
      %37 = arith.mulf %33, %36 : f32
      memref.store %37, %reinterpret_cast_4[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %22 = memref.get_global @kbm1 : memref<1xi32>
    %23 = memref.load %22[%c0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = arith.mulf %16, %cst : f32
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%24, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%24, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg11 = %c1 to %24 step %c1 {
      %27 = arith.addi %arg11, %c-1 : index
      %28 = memref.load %arg4[%27] : memref<?xf32>
      %29 = memref.load %arg4[%arg11] : memref<?xf32>
      %30 = arith.subf %28, %29 : f32
      %31 = arith.mulf %25, %30 : f32
      %32 = arith.addf %28, %29 : f32
      %33 = arith.mulf %25, %32 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%12, %18) step (%c1, %c1) {
        %34 = memref.load %reinterpret_cast_5[%27, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %35 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %36 = arith.muli %arg12, %8 overflow<nsw> : index
        %37 = arith.addi %arg13, %36 : index
        %38 = arith.addi %37, %c-1 : index
        %39 = memref.load %arg5[%38] : memref<?xf32>
        %40 = arith.addf %35, %39 : f32
        %41 = arith.mulf %31, %40 : f32
        %42 = memref.load %reinterpret_cast_6[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %43 = arith.muli %arg11, %8 overflow<nsw> : index
        %44 = arith.muli %43, %7 overflow<nsw> : index
        %45 = arith.addi %37, %44 : index
        %46 = arith.addi %45, %c-1 : index
        %47 = memref.load %arg0[%46] : memref<?xf32>
        %48 = arith.subf %42, %47 : f32
        %49 = memref.load %reinterpret_cast_6[%27, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %50 = arith.addf %48, %49 : f32
        %51 = arith.muli %27, %8 overflow<nsw> : index
        %52 = arith.muli %51, %7 overflow<nsw> : index
        %53 = arith.addi %37, %52 : index
        %54 = arith.addi %53, %c-1 : index
        %55 = memref.load %arg0[%54] : memref<?xf32>
        %56 = arith.subf %50, %55 : f32
        %57 = arith.mulf %41, %56 : f32
        %58 = arith.addf %34, %57 : f32
        %59 = arith.subf %35, %39 : f32
        %60 = arith.mulf %33, %59 : f32
        %61 = arith.addf %42, %47 : f32
        %62 = arith.subf %61, %49 : f32
        %63 = arith.subf %62, %55 : f32
        %64 = arith.mulf %60, %63 : f32
        %65 = arith.addf %58, %64 : f32
        memref.store %65, %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %reinterpret_cast_7 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%24, %12, %18) step (%c1, %c1, %c1) {
      %27 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %28 = arith.muli %arg12, %8 overflow<nsw> : index
      %29 = arith.addi %arg13, %28 : index
      %30 = arith.addi %29, %c-1 : index
      %31 = memref.load %arg5[%30] : memref<?xf32>
      %32 = arith.addf %27, %31 : f32
      %33 = arith.mulf %32, %cst : f32
      %34 = memref.load %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %35 = arith.mulf %33, %34 : f32
      %36 = memref.load %reinterpret_cast_7[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %37 = arith.mulf %35, %36 : f32
      %38 = memref.load %reinterpret_cast_8[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %39 = memref.load %arg9[%30] : memref<?xf32>
      %40 = arith.addf %38, %39 : f32
      %41 = arith.mulf %37, %40 : f32
      memref.store %41, %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_9 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%12, %18) step (%c1, %c1) {
      %27 = memref.load %reinterpret_cast_2[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %28 = arith.addi %arg11, %c-1 : index
      %29 = memref.load %reinterpret_cast_2[%28, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.addf %27, %29 : f32
      %31 = arith.mulf %21, %30 : f32
      %32 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %33 = memref.load %reinterpret_cast_3[%28, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %34 = arith.subf %32, %33 : f32
      %35 = arith.mulf %31, %34 : f32
      memref.store %35, %reinterpret_cast_9[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_10 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%24, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg11 = %c1 to %24 step %c1 {
      %27 = arith.addi %arg11, %c-1 : index
      %28 = memref.load %arg4[%27] : memref<?xf32>
      %29 = memref.load %arg4[%arg11] : memref<?xf32>
      %30 = arith.subf %28, %29 : f32
      %31 = arith.mulf %25, %30 : f32
      %32 = arith.addf %28, %29 : f32
      %33 = arith.mulf %25, %32 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%12, %18) step (%c1, %c1) {
        %34 = memref.load %reinterpret_cast_10[%27, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %35 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %36 = arith.addi %arg12, %c-1 : index
        %37 = memref.load %reinterpret_cast_2[%36, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.addf %35, %37 : f32
        %39 = arith.mulf %31, %38 : f32
        %40 = memref.load %reinterpret_cast_6[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = memref.load %reinterpret_cast_6[%arg11, %36, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %42 = arith.subf %40, %41 : f32
        %43 = memref.load %reinterpret_cast_6[%27, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %44 = arith.addf %42, %43 : f32
        %45 = memref.load %reinterpret_cast_6[%27, %36, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %46 = arith.subf %44, %45 : f32
        %47 = arith.mulf %39, %46 : f32
        %48 = arith.addf %34, %47 : f32
        %49 = arith.subf %35, %37 : f32
        %50 = arith.mulf %33, %49 : f32
        %51 = arith.addf %40, %41 : f32
        %52 = arith.subf %51, %43 : f32
        %53 = arith.subf %52, %45 : f32
        %54 = arith.mulf %50, %53 : f32
        %55 = arith.addf %48, %54 : f32
        memref.store %55, %reinterpret_cast_10[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %reinterpret_cast_11 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%24, %12, %18) step (%c1, %c1, %c1) {
      %27 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %28 = arith.addi %arg12, %c-1 : index
      %29 = memref.load %reinterpret_cast_2[%28, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.addf %27, %29 : f32
      %31 = arith.mulf %30, %cst : f32
      %32 = memref.load %reinterpret_cast_10[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %33 = arith.mulf %31, %32 : f32
      %34 = memref.load %reinterpret_cast_11[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %35 = arith.mulf %33, %34 : f32
      %36 = memref.load %reinterpret_cast_12[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %37 = memref.load %reinterpret_cast_12[%28, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %38 = arith.addf %36, %37 : f32
      %39 = arith.mulf %35, %38 : f32
      memref.store %39, %reinterpret_cast_10[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %26 = memref.load %arg10[%c0] : memref<?xf32>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%2, %12, %18) step (%c1, %c1, %c1) {
      %27 = memref.load %reinterpret_cast_13[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %28 = arith.mulf %26, %27 : f32
      memref.store %28, %reinterpret_cast_13[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = memref.load %reinterpret_cast_14[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = arith.mulf %26, %29 : f32
      memref.store %30, %reinterpret_cast_14[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c1, %c1, %c1) {
      %27 = memref.load %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %28 = memref.load %reinterpret_cast_1[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = arith.addf %27, %28 : f32
      memref.store %29, %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


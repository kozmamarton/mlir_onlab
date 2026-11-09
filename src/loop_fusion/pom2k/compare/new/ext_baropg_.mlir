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
      %29 = memref.load %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = memref.load %reinterpret_cast_1[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %31 = arith.subf %29, %30 : f32
      memref.store %31, %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
      %29 = memref.load %reinterpret_cast_2[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.muli %arg11, %8 overflow<nsw> : index
      %31 = arith.addi %arg12, %30 : index
      %32 = arith.addi %31, %c-1 : index
      %33 = memref.load %arg5[%32] : memref<?xf32>
      %34 = arith.addf %29, %33 : f32
      %35 = arith.mulf %21, %34 : f32
      %36 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %37 = memref.load %arg0[%32] : memref<?xf32>
      %38 = arith.subf %36, %37 : f32
      %39 = arith.mulf %35, %38 : f32
      memref.store %39, %reinterpret_cast_4[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %22 = memref.get_global @kbm1 : memref<1xi32>
    %23 = memref.load %22[%c0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = arith.mulf %16, %cst : f32
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%24, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%24, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg11 = %c1 to %24 step %c1 {
      %29 = arith.addi %arg11, %c-1 : index
      %30 = memref.load %arg4[%29] : memref<?xf32>
      %31 = memref.load %arg4[%arg11] : memref<?xf32>
      %32 = arith.subf %30, %31 : f32
      %33 = arith.mulf %25, %32 : f32
      %34 = arith.addf %30, %31 : f32
      %35 = arith.mulf %25, %34 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%12, %18) step (%c1, %c1) {
        %36 = memref.load %reinterpret_cast_5[%29, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %37 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.muli %arg12, %8 overflow<nsw> : index
        %39 = arith.addi %arg13, %38 : index
        %40 = arith.addi %39, %c-1 : index
        %41 = memref.load %arg5[%40] : memref<?xf32>
        %42 = arith.addf %37, %41 : f32
        %43 = arith.mulf %33, %42 : f32
        %44 = memref.load %reinterpret_cast_6[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %45 = arith.muli %arg11, %8 overflow<nsw> : index
        %46 = arith.muli %45, %7 overflow<nsw> : index
        %47 = arith.addi %39, %46 : index
        %48 = arith.addi %47, %c-1 : index
        %49 = memref.load %arg0[%48] : memref<?xf32>
        %50 = arith.subf %44, %49 : f32
        %51 = memref.load %reinterpret_cast_6[%29, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %52 = arith.addf %50, %51 : f32
        %53 = arith.muli %29, %8 overflow<nsw> : index
        %54 = arith.muli %53, %7 overflow<nsw> : index
        %55 = arith.addi %39, %54 : index
        %56 = arith.addi %55, %c-1 : index
        %57 = memref.load %arg0[%56] : memref<?xf32>
        %58 = arith.subf %52, %57 : f32
        %59 = arith.mulf %43, %58 : f32
        %60 = arith.addf %36, %59 : f32
        %61 = arith.subf %37, %41 : f32
        %62 = arith.mulf %35, %61 : f32
        %63 = arith.addf %44, %49 : f32
        %64 = arith.subf %63, %51 : f32
        %65 = arith.subf %64, %57 : f32
        %66 = arith.mulf %62, %65 : f32
        %67 = arith.addf %60, %66 : f32
        memref.store %67, %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %reinterpret_cast_7 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%24, %12, %18) step (%c1, %c1, %c1) {
      %29 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.muli %arg12, %8 overflow<nsw> : index
      %31 = arith.addi %arg13, %30 : index
      %32 = arith.addi %31, %c-1 : index
      %33 = memref.load %arg5[%32] : memref<?xf32>
      %34 = arith.addf %29, %33 : f32
      %35 = arith.mulf %34, %cst : f32
      %36 = memref.load %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %37 = arith.mulf %35, %36 : f32
      %38 = memref.load %reinterpret_cast_7[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.mulf %37, %38 : f32
      %40 = memref.load %reinterpret_cast_8[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %41 = memref.load %arg9[%32] : memref<?xf32>
      %42 = arith.addf %40, %41 : f32
      %43 = arith.mulf %39, %42 : f32
      memref.store %43, %reinterpret_cast_5[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_9 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%12, %18) step (%c1, %c1) {
      %29 = memref.load %reinterpret_cast_2[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.addi %arg11, %c-1 : index
      %31 = memref.load %reinterpret_cast_2[%30, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.addf %29, %31 : f32
      %33 = arith.mulf %21, %32 : f32
      %34 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %35 = memref.load %reinterpret_cast_3[%30, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %36 = arith.subf %34, %35 : f32
      %37 = arith.mulf %33, %36 : f32
      memref.store %37, %reinterpret_cast_9[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_10 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%24, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg11 = %c1 to %24 step %c1 {
      %29 = arith.addi %arg11, %c-1 : index
      %30 = memref.load %arg4[%29] : memref<?xf32>
      %31 = memref.load %arg4[%arg11] : memref<?xf32>
      %32 = arith.subf %30, %31 : f32
      %33 = arith.mulf %25, %32 : f32
      %34 = arith.addf %30, %31 : f32
      %35 = arith.mulf %25, %34 : f32
      scf.parallel (%arg12, %arg13) = (%c1, %c1) to (%12, %18) step (%c1, %c1) {
        %36 = memref.load %reinterpret_cast_10[%29, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %37 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.addi %arg12, %c-1 : index
        %39 = memref.load %reinterpret_cast_2[%38, %arg13] : memref<?x?xf32, strided<[?, 1]>>
        %40 = arith.addf %37, %39 : f32
        %41 = arith.mulf %33, %40 : f32
        %42 = memref.load %reinterpret_cast_6[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %43 = memref.load %reinterpret_cast_6[%arg11, %38, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %44 = arith.subf %42, %43 : f32
        %45 = memref.load %reinterpret_cast_6[%29, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %46 = arith.addf %44, %45 : f32
        %47 = memref.load %reinterpret_cast_6[%29, %38, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %48 = arith.subf %46, %47 : f32
        %49 = arith.mulf %41, %48 : f32
        %50 = arith.addf %36, %49 : f32
        %51 = arith.subf %37, %39 : f32
        %52 = arith.mulf %35, %51 : f32
        %53 = arith.addf %42, %43 : f32
        %54 = arith.subf %53, %45 : f32
        %55 = arith.subf %54, %47 : f32
        %56 = arith.mulf %52, %55 : f32
        %57 = arith.addf %50, %56 : f32
        memref.store %57, %reinterpret_cast_10[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %reinterpret_cast_11 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%12, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%24, %12, %18) step (%c1, %c1, %c1) {
      %29 = memref.load %reinterpret_cast_2[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %30 = arith.addi %arg12, %c-1 : index
      %31 = memref.load %reinterpret_cast_2[%30, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.addf %29, %31 : f32
      %33 = arith.mulf %32, %cst : f32
      %34 = memref.load %reinterpret_cast_10[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %35 = arith.mulf %33, %34 : f32
      %36 = memref.load %reinterpret_cast_11[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %37 = arith.mulf %35, %36 : f32
      %38 = memref.load %reinterpret_cast_12[%arg12, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %39 = memref.load %reinterpret_cast_12[%30, %arg13] : memref<?x?xf32, strided<[?, 1]>>
      %40 = arith.addf %38, %39 : f32
      %41 = arith.mulf %37, %40 : f32
      memref.store %41, %reinterpret_cast_10[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %26 = memref.load %arg10[%c0] : memref<?xf32>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %27 = arith.maxsi %7, %12 : index
    %28 = arith.maxsi %8, %18 : index
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%2, %27, %28) step (%c1, %c1, %c1) {
      %29 = arith.addi %arg12, %c-1 : index
      %30 = arith.cmpi sge, %29, %c0 : index
      %31 = arith.subi %12, %arg12 : index
      %32 = arith.addi %31, %c-1 : index
      %33 = arith.cmpi sge, %32, %c0 : index
      %34 = arith.andi %30, %33 : i1
      %35 = arith.addi %arg13, %c-1 : index
      %36 = arith.cmpi sge, %35, %c0 : index
      %37 = arith.andi %34, %36 : i1
      %38 = arith.subi %18, %arg13 : index
      %39 = arith.addi %38, %c-1 : index
      %40 = arith.cmpi sge, %39, %c0 : index
      %41 = arith.andi %37, %40 : i1
      scf.if %41 {
        %49 = memref.load %reinterpret_cast_13[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %50 = arith.mulf %26, %49 : f32
        memref.store %50, %reinterpret_cast_13[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %51 = memref.load %reinterpret_cast_14[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %52 = arith.mulf %26, %51 : f32
        memref.store %52, %reinterpret_cast_14[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      }
      %42 = arith.subi %7, %arg12 : index
      %43 = arith.addi %42, %c-1 : index
      %44 = arith.cmpi sge, %43, %c0 : index
      %45 = arith.subi %8, %arg13 : index
      %46 = arith.addi %45, %c-1 : index
      %47 = arith.cmpi sge, %46, %c0 : index
      %48 = arith.andi %44, %47 : i1
      scf.if %48 {
        %49 = memref.load %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %50 = memref.load %reinterpret_cast_1[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %51 = arith.addf %49, %50 : f32
        memref.store %51, %reinterpret_cast[%arg11, %arg12, %arg13] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      }
      scf.reduce 
    }
    return
  }
}


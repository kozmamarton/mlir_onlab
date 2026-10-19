module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_vertvl_(%arg0: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vfluxb", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dti2", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 5.000000e-01 : f32
    %cst_0 = arith.constant 2.500000e-01 : f32
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
    %reinterpret_cast = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg14, %arg15, %arg16) = (%c0, %c1, %c1) to (%2, %7, %8) step (%c1, %c1, %c1) {
      %38 = memref.load %reinterpret_cast_2[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.muli %arg15, %8 overflow<nsw> : index
      %40 = arith.addi %arg16, %39 : index
      %41 = arith.addi %40, %c-1 : index
      %42 = memref.load %arg3[%41] : memref<?xf32>
      %43 = arith.addf %38, %42 : f32
      %44 = arith.mulf %43, %cst_0 : f32
      %45 = memref.load %reinterpret_cast_3[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
      %46 = memref.load %arg4[%41] : memref<?xf32>
      %47 = arith.addf %45, %46 : f32
      %48 = arith.mulf %44, %47 : f32
      %49 = memref.load %reinterpret_cast[%arg14, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %50 = arith.mulf %48, %49 : f32
      memref.store %50, %reinterpret_cast_1[%arg14, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.load %0[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.load %3[%c0] : memref<1xi32>
    %13 = memref.load %4[%c0] : memref<1xi32>
    %14 = arith.index_cast %12 : i32 to index
    %15 = arith.index_cast %13 : i32 to index
    %16 = arith.muli %15, %14 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%11, %14, %15], strides: [%16, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %14, %15], strides: [%16, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%14, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%14, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg14, %arg15, %arg16) = (%c0, %c1, %c1) to (%11, %14, %15) step (%c1, %c1, %c1) {
      %38 = memref.load %reinterpret_cast_6[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.addi %arg15, %c-1 : index
      %40 = memref.load %reinterpret_cast_6[%39, %arg16] : memref<?x?xf32, strided<[?, 1]>>
      %41 = arith.addf %38, %40 : f32
      %42 = arith.mulf %41, %cst_0 : f32
      %43 = memref.load %reinterpret_cast_7[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
      %44 = memref.load %reinterpret_cast_7[%39, %arg16] : memref<?x?xf32, strided<[?, 1]>>
      %45 = arith.addf %43, %44 : f32
      %46 = arith.mulf %42, %45 : f32
      %47 = memref.load %reinterpret_cast_4[%arg14, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %48 = arith.mulf %46, %47 : f32
      memref.store %48, %reinterpret_cast_5[%arg14, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %17 = memref.get_global @jmm1 : memref<1xi32>
    %18 = memref.load %17[%c0] : memref<1xi32>
    %19 = arith.index_cast %18 : i32 to index
    %20 = memref.get_global @imm1 : memref<1xi32>
    %21 = memref.load %20[%c0] : memref<1xi32>
    %22 = memref.load %4[%c0] : memref<1xi32>
    %23 = arith.index_cast %21 : i32 to index
    %24 = arith.index_cast %22 : i32 to index
    %reinterpret_cast_8 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%19, %24], strides: [%24, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%19, %24], strides: [%24, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%19, %24], strides: [%24, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg14, %arg15) = (%c1, %c1) to (%19, %23) step (%c1, %c1) {
      %38 = memref.load %reinterpret_cast_8[%arg14, %arg15] : memref<?x?xf32, strided<[?, 1]>>
      %39 = memref.load %reinterpret_cast_9[%arg14, %arg15] : memref<?x?xf32, strided<[?, 1]>>
      %40 = arith.addf %38, %39 : f32
      %41 = arith.mulf %40, %cst : f32
      memref.store %41, %reinterpret_cast_10[%arg14, %arg15] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %25 = memref.get_global @kb : memref<1xi32>
    %26 = memref.load %25[%c0] : memref<1xi32>
    %27 = arith.index_cast %26 : i32 to index
    %28 = memref.load %17[%c0] : memref<1xi32>
    %29 = memref.load %20[%c0] : memref<1xi32>
    %30 = memref.load %4[%c0] : memref<1xi32>
    %31 = memref.load %3[%c0] : memref<1xi32>
    %32 = memref.load %arg13[%c0] : memref<?xf32>
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.index_cast %30 : i32 to index
    %36 = arith.index_cast %31 : i32 to index
    %37 = arith.muli %35, %36 : index
    %reinterpret_cast_11 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%27, %36, %35], strides: [%37, %35, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%27, %36, %35], strides: [%37, %35, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%27, %36, %35], strides: [%37, %35, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%33, %35], strides: [%35, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%33, %35], strides: [%35, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%33, %35], strides: [%35, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%33, %35], strides: [%35, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg14 = %c1 to %27 step %c1 {
      %38 = arith.addi %arg14, %c-1 : index
      %39 = memref.load %arg12[%38] : memref<?xf32>
      scf.parallel (%arg15, %arg16) = (%c1, %c1) to (%33, %34) step (%c1, %c1) {
        %40 = memref.load %reinterpret_cast_11[%38, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = arith.muli %arg15, %35 overflow<nsw> : index
        %42 = arith.addi %arg16, %41 : index
        %43 = arith.muli %38, %35 overflow<nsw> : index
        %44 = arith.muli %43, %36 overflow<nsw> : index
        %45 = arith.addi %42, %44 : index
        %46 = arith.addi %45, %c1 : index
        %47 = memref.load %arg0[%46] : memref<?xf32>
        %48 = memref.load %reinterpret_cast_12[%38, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %49 = arith.subf %47, %48 : f32
        %50 = arith.addi %arg15, %c1 : index
        %51 = memref.load %reinterpret_cast_13[%38, %50, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %52 = arith.addf %49, %51 : f32
        %53 = memref.load %reinterpret_cast_13[%38, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %54 = arith.subf %52, %53 : f32
        %55 = memref.load %reinterpret_cast_14[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
        %56 = memref.load %reinterpret_cast_15[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
        %57 = arith.mulf %55, %56 : f32
        %58 = arith.divf %54, %57 : f32
        %59 = memref.load %reinterpret_cast_16[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
        %60 = memref.load %reinterpret_cast_17[%arg15, %arg16] : memref<?x?xf32, strided<[?, 1]>>
        %61 = arith.subf %59, %60 : f32
        %62 = arith.divf %61, %32 : f32
        %63 = arith.addf %58, %62 : f32
        %64 = arith.mulf %39, %63 : f32
        %65 = arith.addf %40, %64 : f32
        memref.store %65, %reinterpret_cast_11[%arg14, %arg15, %arg16] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    return
  }
}


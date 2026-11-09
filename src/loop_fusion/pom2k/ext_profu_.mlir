module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_profu_(%arg0: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "km", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "dhloc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c-1 = arith.constant -1 : index
    %c-3_i32 = arith.constant -3 : i32
    %c-1_i32 = arith.constant -1 : i32
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %c1_i32 = arith.constant 1 : i32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %alloca = memref.alloca() : memref<i32>
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = memref.get_global @kb : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      memref.store %cst_1, %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%2, %5) step (%c1, %c1) {
      %37 = memref.load %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %38 = memref.load %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.addf %37, %38 : f32
      %40 = arith.muli %arg18, %5 overflow<nsw> : index
      %41 = arith.addi %arg19, %40 : index
      %42 = arith.addi %41, %c-1 : index
      %43 = memref.load %arg0[%42] : memref<?xf32>
      %44 = arith.addf %39, %43 : f32
      %45 = memref.load %arg1[%42] : memref<?xf32>
      %46 = arith.addf %44, %45 : f32
      %47 = arith.mulf %46, %cst_0 : f32
      memref.store %47, %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %9 = arith.muli %5, %2 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%8, %2, %5) step (%c1, %c1, %c1) {
      %37 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %38 = arith.muli %arg19, %5 overflow<nsw> : index
      %39 = arith.addi %arg20, %38 : index
      %40 = arith.muli %arg18, %5 overflow<nsw> : index
      %41 = arith.muli %40, %2 overflow<nsw> : index
      %42 = arith.addi %39, %41 : index
      %43 = arith.addi %42, %c-1 : index
      %44 = memref.load %arg3[%43] : memref<?xf32>
      %45 = arith.addf %37, %44 : f32
      %46 = arith.mulf %45, %cst_0 : f32
      memref.store %46, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.get_global @kbm2 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @dti2 : memref<1xf32>
    %14 = memref.get_global @umol : memref<1xf32>
    %15 = memref.load %13[%c0] : memref<1xf32>
    %16 = memref.load %14[%c0] : memref<1xf32>
    %17 = arith.negf %15 : f32
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%12, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%12, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%12, %2, %5) step (%c1, %c1, %c1) {
      %37 = memref.load %arg5[%arg18] : memref<?xf32>
      %38 = memref.load %arg6[%arg18] : memref<?xf32>
      %39 = arith.mulf %37, %38 : f32
      %40 = arith.addi %arg18, %c1 : index
      %41 = memref.load %reinterpret_cast_6[%40, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %42 = arith.addf %41, %16 : f32
      %43 = arith.mulf %17, %42 : f32
      %44 = memref.load %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %45 = arith.mulf %39, %44 : f32
      %46 = arith.mulf %45, %44 : f32
      %47 = arith.divf %43, %46 : f32
      memref.store %47, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %18 = memref.get_global @kbm1 : memref<1xi32>
    %19 = memref.load %18[%c0] : memref<1xi32>
    %20 = arith.index_cast %19 : i32 to index
    %reinterpret_cast_8 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%20, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c0, %c0) to (%20, %2, %5) step (%c1, %c1, %c1) {
      %37 = memref.load %arg5[%arg18] : memref<?xf32>
      %38 = arith.addi %arg18, %c-1 : index
      %39 = memref.load %arg6[%38] : memref<?xf32>
      %40 = arith.mulf %37, %39 : f32
      %41 = memref.load %reinterpret_cast_8[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %42 = arith.addf %41, %16 : f32
      %43 = arith.mulf %17, %42 : f32
      %44 = memref.load %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %45 = arith.mulf %40, %44 : f32
      %46 = arith.mulf %45, %44 : f32
      %47 = arith.divf %43, %46 : f32
      memref.store %47, %reinterpret_cast_8[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %21 = memref.load %arg5[%c0] : memref<?xf32>
    %22 = arith.negf %21 : f32
    %reinterpret_cast_9 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      %37 = memref.load %reinterpret_cast_9[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %38 = arith.subf %37, %cst_1 : f32
      %39 = arith.divf %37, %38 : f32
      memref.store %39, %reinterpret_cast_10[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %40 = memref.load %reinterpret_cast_11[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %41 = arith.mulf %17, %40 : f32
      %42 = memref.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %43 = arith.mulf %22, %42 : f32
      %44 = arith.divf %41, %43 : f32
      %45 = memref.load %reinterpret_cast_12[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %46 = arith.subf %44, %45 : f32
      %47 = arith.divf %46, %38 : f32
      memref.store %47, %reinterpret_cast_13[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_14 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%12, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%12, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%12, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      scf.for %arg20 = %c1 to %12 step %c1 {
        %37 = memref.load %reinterpret_cast_7[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %38 = memref.load %reinterpret_cast_6[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %39 = arith.addi %arg20, %c-1 : index
        %40 = memref.load %reinterpret_cast_14[%39, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = arith.subf %cst_1, %40 : f32
        %42 = arith.mulf %38, %41 : f32
        %43 = arith.addf %37, %42 : f32
        %44 = arith.subf %43, %cst_1 : f32
        %45 = arith.divf %cst_1, %44 : f32
        %46 = arith.mulf %37, %45 : f32
        memref.store %46, %reinterpret_cast_14[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %47 = memref.load %reinterpret_cast_15[%39, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %48 = arith.mulf %38, %47 : f32
        %49 = memref.load %reinterpret_cast_16[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %50 = arith.subf %48, %49 : f32
        %51 = arith.mulf %50, %45 : f32
        memref.store %51, %reinterpret_cast_15[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      }
      scf.reduce 
    }
    %23 = memref.get_global @jmm1 : memref<1xi32>
    %24 = memref.load %23[%c0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %26 = memref.get_global @imm1 : memref<1xi32>
    %27 = memref.load %26[%c0] : memref<1xi32>
    %28 = arith.index_cast %27 : i32 to index
    %29 = arith.muli %12, %5 : index
    %30 = arith.muli %29, %2 : index
    %31 = arith.addi %12, %c-1 : index
    %32 = arith.muli %31, %5 : index
    %33 = arith.muli %32, %2 : index
    %34 = memref.load %arg5[%12] : memref<?xf32>
    %35 = arith.negf %34 : f32
    %reinterpret_cast_17 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%25, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%25, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%25, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%25, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg18 = %c1 to %25 step %c1 {
      scf.for %arg19 = %c1 to %28 step %c1 {
        %37 = memref.load %reinterpret_cast_17[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.muli %arg18, %5 overflow<nsw> : index
        %39 = arith.addi %arg19, %38 : index
        %40 = arith.addi %39, %c-1 : index
        %41 = memref.load %arg12[%40] : memref<?xf32>
        %42 = arith.addf %37, %41 : f32
        %43 = arith.mulf %42, %cst_0 : f32
        %44 = arith.addi %39, %30 : index
        %45 = memref.load %arg13[%44] : memref<?xf32>
        %46 = arith.mulf %45, %45 : f32
        %47 = memref.load %arg14[%44] : memref<?xf32>
        %48 = arith.addi %arg19, %30 : index
        %49 = arith.addi %arg18, %c1 : index
        %50 = arith.muli %49, %5 overflow<nsw> : index
        %51 = arith.addi %48, %50 : index
        %52 = memref.load %arg14[%51] : memref<?xf32>
        %53 = arith.addf %47, %52 : f32
        %54 = arith.addi %44, %c-1 : index
        %55 = memref.load %arg14[%54] : memref<?xf32>
        %56 = arith.addf %53, %55 : f32
        %57 = arith.addi %51, %c-1 : index
        %58 = memref.load %arg14[%57] : memref<?xf32>
        %59 = arith.addf %56, %58 : f32
        %60 = arith.mulf %59, %cst : f32
        %61 = arith.mulf %60, %60 : f32
        %62 = arith.addf %46, %61 : f32
        %63 = math.sqrt %62 : f32
        %64 = arith.mulf %43, %63 : f32
        memref.store %64, %reinterpret_cast_18[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %65 = memref.load %arg2[%44] : memref<?xf32>
        %66 = arith.addi %39, %33 : index
        %67 = memref.load %arg8[%66] : memref<?xf32>
        %68 = arith.mulf %65, %67 : f32
        %69 = memref.load %arg10[%44] : memref<?xf32>
        %70 = arith.subf %68, %69 : f32
        %71 = arith.mulf %64, %15 : f32
        %72 = memref.load %reinterpret_cast_19[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %73 = arith.mulf %35, %72 : f32
        %74 = arith.divf %71, %73 : f32
        %75 = arith.subf %74, %cst_1 : f32
        %76 = memref.load %arg7[%66] : memref<?xf32>
        %77 = arith.subf %76, %cst_1 : f32
        %78 = arith.mulf %77, %65 : f32
        %79 = arith.subf %75, %78 : f32
        %80 = arith.divf %70, %79 : f32
        memref.store %80, %arg10[%44] : memref<?xf32>
        %81 = memref.load %arg10[%44] : memref<?xf32>
        %82 = memref.load %reinterpret_cast_20[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %83 = arith.mulf %81, %82 : f32
        memref.store %83, %arg10[%44] : memref<?xf32>
      }
    }
    %36 = arith.addi %7, %c-3_i32 : i32
    memref.store %36, %alloca[] : memref<i32>
    scf.while : () -> () {
      %37 = memref.load %alloca[] : memref<i32>
      %38 = arith.cmpi sge, %37, %c0_i32 : i32
      scf.condition(%38)
    } do {
      %37 = memref.load %alloca[] : memref<i32>
      %38 = arith.muli %37, %4 : i32
      %39 = arith.muli %38, %1 : i32
      %40 = arith.addi %37, %c1_i32 : i32
      %41 = arith.muli %40, %4 : i32
      %42 = arith.muli %41, %1 : i32
      scf.for %arg18 = %c1 to %25 step %c1 {
        %44 = arith.index_cast %arg18 : index to i32
        %45 = arith.muli %44, %4 : i32
        %46 = arith.muli %arg18, %5 : index
        scf.for %arg19 = %c1 to %28 step %c1 {
          %47 = arith.index_cast %arg19 : index to i32
          %48 = arith.addi %47, %45 : i32
          %49 = arith.addi %48, %39 : i32
          %50 = arith.index_cast %49 : i32 to index
          %51 = memref.load %arg7[%50] : memref<?xf32>
          %52 = arith.addi %48, %42 : i32
          %53 = arith.index_cast %52 : i32 to index
          %54 = memref.load %arg10[%53] : memref<?xf32>
          %55 = arith.mulf %51, %54 : f32
          %56 = memref.load %arg8[%50] : memref<?xf32>
          %57 = arith.addf %55, %56 : f32
          %58 = arith.addi %arg19, %46 : index
          %59 = memref.load %arg15[%58] : memref<?xf32>
          %60 = arith.mulf %57, %59 : f32
          memref.store %60, %arg10[%50] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %43 = arith.addi %37, %c-1_i32 : i32
      memref.store %43, %alloca[] : memref<i32>
      scf.yield
    }
    %reinterpret_cast_21 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%25, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%25, %28) step (%c1, %c1) {
      %37 = memref.load %reinterpret_cast_18[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %38 = arith.negf %37 : f32
      %39 = arith.muli %arg18, %5 overflow<nsw> : index
      %40 = arith.addi %arg19, %39 : index
      %41 = arith.addi %40, %30 : index
      %42 = memref.load %arg10[%41] : memref<?xf32>
      %43 = arith.mulf %38, %42 : f32
      memref.store %43, %reinterpret_cast_21[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


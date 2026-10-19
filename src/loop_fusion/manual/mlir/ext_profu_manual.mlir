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
    %c-4_i32 = arith.constant -4 : i32
    %0 = llvm.mlir.undef : i32
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
    memref.store %0, %alloca[] : memref<i32>
    %1 = memref.get_global @jm : memref<1xi32>
    %2 = memref.load %1[%c0] : memref<1xi32>
    %3 = arith.index_cast %2 : i32 to index
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %4[%c0] : memref<1xi32>
    %6 = arith.index_cast %5 : i32 to index
    %7 = memref.get_global @kb : memref<1xi32>
    %8 = memref.load %7[%c0] : memref<1xi32>
    %9 = arith.index_cast %8 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%3, %6) step (%c1, %c1) {
      %68 = arith.addi %arg18, %c-1 : index
      %69 = arith.cmpi sge, %68, %c0 : index
      %70 = arith.addi %arg19, %c-1 : index
      %71 = arith.cmpi sge, %70, %c0 : index
      %72 = arith.andi %69, %71 : i1
      scf.if %72 {
        %73 = memref.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %74 = memref.load %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %75 = arith.addf %73, %74 : f32
        %76 = arith.muli %arg18, %6 overflow<nsw> : index
        %77 = arith.addi %arg19, %76 : index
        %78 = arith.addi %77, %c-1 : index
        %79 = memref.load %arg0[%78] : memref<?xf32>
        %80 = arith.addf %75, %79 : f32
        %81 = memref.load %arg1[%78] : memref<?xf32>
        %82 = arith.addf %80, %81 : f32
        %83 = arith.mulf %82, %cst_0 : f32
        memref.store %83, %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      } else {
        memref.store %cst_1, %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      }
      scf.reduce 
    }
    %10 = arith.muli %6, %3 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%9, %3, %6], strides: [%10, %6, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%9, %3, %6], strides: [%10, %6, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%9, %3, %6) step (%c1, %c1, %c1) {
      %68 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %69 = arith.muli %arg19, %6 overflow<nsw> : index
      %70 = arith.addi %arg20, %69 : index
      %71 = arith.muli %arg18, %6 overflow<nsw> : index
      %72 = arith.muli %71, %3 overflow<nsw> : index
      %73 = arith.addi %70, %72 : index
      %74 = arith.addi %73, %c-1 : index
      %75 = memref.load %arg3[%74] : memref<?xf32>
      %76 = arith.addf %68, %75 : f32
      %77 = arith.mulf %76, %cst_0 : f32
      memref.store %77, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %11 = memref.get_global @kbm2 : memref<1xi32>
    %12 = memref.load %11[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.get_global @dti2 : memref<1xf32>
    %15 = memref.get_global @umol : memref<1xf32>
    %16 = memref.load %1[%c0] : memref<1xi32>
    %17 = memref.load %4[%c0] : memref<1xi32>
    %18 = memref.load %14[%c0] : memref<1xf32>
    %19 = memref.load %15[%c0] : memref<1xf32>
    %20 = arith.index_cast %16 : i32 to index
    %21 = arith.index_cast %17 : i32 to index
    %22 = arith.negf %18 : f32
    %23 = arith.muli %21, %20 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%13, %20, %21], strides: [%23, %21, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%13, %20, %21], strides: [%23, %21, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%20, %21], strides: [%21, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%13, %20, %21) step (%c1, %c1, %c1) {
      %68 = memref.load %arg5[%arg18] : memref<?xf32>
      %69 = memref.load %arg6[%arg18] : memref<?xf32>
      %70 = arith.mulf %68, %69 : f32
      %71 = arith.addi %arg18, %c1 : index
      %72 = memref.load %reinterpret_cast_6[%71, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %73 = arith.addf %72, %19 : f32
      %74 = arith.mulf %22, %73 : f32
      %75 = memref.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %76 = arith.mulf %70, %75 : f32
      %77 = arith.mulf %76, %75 : f32
      %78 = arith.divf %74, %77 : f32
      memref.store %78, %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %24 = memref.get_global @kbm1 : memref<1xi32>
    %25 = memref.load %24[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    %27 = memref.load %1[%c0] : memref<1xi32>
    %28 = memref.load %4[%c0] : memref<1xi32>
    %29 = memref.load %14[%c0] : memref<1xf32>
    %30 = memref.load %15[%c0] : memref<1xf32>
    %31 = arith.index_cast %27 : i32 to index
    %32 = arith.index_cast %28 : i32 to index
    %33 = arith.negf %29 : f32
    %34 = memref.load %11[%c0] : memref<1xi32>
    %35 = arith.index_cast %34 : i32 to index
    %36 = arith.muli %32, %31 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%26, %31, %32], strides: [%36, %32, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%31, %32], strides: [%32, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c0, %c0) to (%26, %31, %32) step (%c1, %c1, %c1) {
      %68 = memref.load %arg5[%arg18] : memref<?xf32>
      %69 = arith.addi %arg18, %c-1 : index
      %70 = memref.load %arg6[%69] : memref<?xf32>
      %71 = arith.mulf %68, %70 : f32
      %72 = memref.load %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %73 = arith.addf %72, %30 : f32
      %74 = arith.mulf %33, %73 : f32
      %75 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %76 = arith.mulf %71, %75 : f32
      %77 = arith.mulf %76, %75 : f32
      %78 = arith.divf %74, %77 : f32
      memref.store %78, %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_11 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%35, %31, %32], strides: [%36, %32, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%35, %31, %32], strides: [%36, %32, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%35, %31, %32], strides: [%36, %32, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%35, %31, %32], strides: [%36, %32, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%35, %31, %32], strides: [%36, %32, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg18 = %c1 to %35 step %c1 {
      %68 = arith.addi %arg18, %c-1 : index
      %69 = arith.cmpi eq, %68, %c0 : index
      scf.if %69 {
        %reinterpret_cast_18 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%31, %32], strides: [%32, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_19 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%31, %32], strides: [%32, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_20 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%31, %32], strides: [%32, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_21 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%31, %32], strides: [%32, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_22 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%31, %32], strides: [%32, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%31, %32) step (%c1, %c1) {
          %70 = memref.load %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %71 = arith.subf %70, %cst_1 : f32
          %72 = arith.divf %70, %71 : f32
          memref.store %72, %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %73 = memref.load %reinterpret_cast_20[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %74 = arith.mulf %22, %73 : f32
          %75 = memref.load %arg5[%c0] : memref<?xf32>
          %76 = arith.negf %75 : f32
          %77 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %78 = arith.mulf %76, %77 : f32
          %79 = arith.divf %74, %78 : f32
          %80 = memref.load %reinterpret_cast_21[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %81 = arith.subf %79, %80 : f32
          %82 = arith.divf %81, %71 : f32
          memref.store %82, %reinterpret_cast_22[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          scf.reduce 
        }
      }
      scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%31, %32) step (%c1, %c1) {
        %70 = memref.load %reinterpret_cast_11[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %71 = memref.load %reinterpret_cast_12[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %72 = memref.load %reinterpret_cast_13[%68, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %73 = arith.subf %cst_1, %72 : f32
        %74 = arith.mulf %71, %73 : f32
        %75 = arith.addf %70, %74 : f32
        %76 = arith.subf %75, %cst_1 : f32
        %77 = arith.divf %cst_1, %76 : f32
        memref.store %77, %reinterpret_cast_14[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %78 = memref.load %reinterpret_cast_11[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %79 = arith.mulf %78, %77 : f32
        memref.store %79, %reinterpret_cast_13[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %80 = memref.load %reinterpret_cast_12[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %81 = memref.load %reinterpret_cast_14[%68, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %82 = arith.mulf %80, %81 : f32
        %83 = memref.load %reinterpret_cast_15[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %84 = arith.subf %82, %83 : f32
        %85 = memref.load %reinterpret_cast_14[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %86 = arith.mulf %84, %85 : f32
        memref.store %86, %reinterpret_cast_14[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %37 = memref.get_global @jmm1 : memref<1xi32>
    %38 = memref.get_global @imm1 : memref<1xi32>
    %39 = memref.load %4[%c0] : memref<1xi32>
    %40 = memref.load %11[%c0] : memref<1xi32>
    %41 = memref.load %1[%c0] : memref<1xi32>
    %42 = memref.load %14[%c0] : memref<1xf32>
    %43 = arith.index_cast %39 : i32 to index
    %44 = arith.index_cast %40 : i32 to index
    %45 = arith.muli %44, %43 : index
    %46 = arith.index_cast %41 : i32 to index
    %47 = arith.muli %45, %46 : index
    %48 = arith.addi %44, %c-1 : index
    %49 = arith.muli %48, %43 : index
    %50 = arith.muli %49, %46 : index
    %51 = memref.load %arg5[%44] : memref<?xf32>
    %52 = arith.negf %51 : f32
    %53 = memref.load %7[%c0] : memref<1xi32>
    %54 = arith.addi %53, %c-3_i32 : i32
    %55 = arith.addi %53, %c-4_i32 : i32
    memref.store %54, %alloca[] : memref<i32>
    scf.while : () -> () {
      %68 = memref.load %alloca[] : memref<i32>
      %69 = arith.cmpi sge, %68, %c0_i32 : i32
      scf.condition(%69)
    } do {
      %68 = memref.load %37[%c0] : memref<1xi32>
      %69 = arith.index_cast %68 : i32 to index
      %70 = memref.load %38[%c0] : memref<1xi32>
      %71 = memref.load %4[%c0] : memref<1xi32>
      %72 = memref.load %alloca[] : memref<i32>
      %73 = memref.load %1[%c0] : memref<1xi32>
      %74 = arith.index_cast %70 : i32 to index
      %75 = arith.muli %72, %71 : i32
      %76 = arith.muli %75, %73 : i32
      %77 = arith.addi %72, %c1_i32 : i32
      %78 = arith.muli %77, %71 : i32
      %79 = arith.muli %78, %73 : i32
      %80 = arith.index_cast %71 : i32 to index
      %81 = arith.cmpi sgt, %72, %55 : i32
      scf.if %81 {
        scf.for %arg18 = %c1 to %69 step %c1 {
          %83 = arith.muli %arg18, %80 : index
          %84 = arith.addi %arg18, %c1 : index
          %85 = arith.muli %84, %80 : index
          scf.for %arg19 = %c1 to %74 step %c1 {
            %86 = arith.addi %arg19, %83 : index
            %87 = arith.addi %86, %47 : index
            %88 = arith.addi %86, %50 : index
            %89 = arith.addi %86, %c-1 : index
            %90 = arith.addi %arg19, %85 : index
            %91 = arith.addi %90, %47 : index
            %92 = arith.addi %91, %c-1 : index
            %93 = arith.addi %87, %c-1 : index
            %94 = memref.load %arg12[%86] : memref<?xf32>
            %95 = memref.load %arg12[%89] : memref<?xf32>
            %96 = arith.addf %94, %95 : f32
            %97 = arith.mulf %96, %cst_0 : f32
            %98 = memref.load %arg13[%87] : memref<?xf32>
            %99 = arith.mulf %98, %98 : f32
            %100 = memref.load %arg14[%87] : memref<?xf32>
            %101 = memref.load %arg14[%91] : memref<?xf32>
            %102 = arith.addf %100, %101 : f32
            %103 = memref.load %arg14[%93] : memref<?xf32>
            %104 = arith.addf %102, %103 : f32
            %105 = memref.load %arg14[%92] : memref<?xf32>
            %106 = arith.addf %104, %105 : f32
            %107 = arith.mulf %106, %cst : f32
            %108 = arith.mulf %107, %107 : f32
            %109 = arith.addf %99, %108 : f32
            %110 = math.sqrt %109 : f32
            %111 = arith.mulf %97, %110 : f32
            memref.store %111, %arg11[%86] : memref<?xf32>
            %112 = memref.load %arg2[%87] : memref<?xf32>
            %113 = memref.load %arg8[%88] : memref<?xf32>
            %114 = arith.mulf %112, %113 : f32
            %115 = memref.load %arg10[%87] : memref<?xf32>
            %116 = arith.subf %114, %115 : f32
            %117 = memref.load %arg11[%86] : memref<?xf32>
            %118 = arith.mulf %117, %42 : f32
            %119 = memref.load %arg17[%86] : memref<?xf32>
            %120 = arith.mulf %52, %119 : f32
            %121 = arith.divf %118, %120 : f32
            %122 = arith.subf %121, %cst_1 : f32
            %123 = memref.load %arg7[%88] : memref<?xf32>
            %124 = arith.subf %123, %cst_1 : f32
            %125 = arith.mulf %124, %112 : f32
            %126 = arith.subf %122, %125 : f32
            %127 = arith.divf %116, %126 : f32
            memref.store %127, %arg10[%87] : memref<?xf32>
            %128 = memref.load %arg10[%87] : memref<?xf32>
            %129 = memref.load %arg15[%86] : memref<?xf32>
            %130 = arith.mulf %128, %129 : f32
            memref.store %130, %arg10[%87] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      }
      scf.for %arg18 = %c1 to %69 step %c1 {
        %83 = arith.index_cast %arg18 : index to i32
        %84 = arith.muli %83, %71 : i32
        %85 = arith.muli %arg18, %80 : index
        scf.for %arg19 = %c1 to %74 step %c1 {
          %86 = arith.index_cast %arg19 : index to i32
          %87 = arith.addi %86, %84 : i32
          %88 = arith.addi %87, %76 : i32
          %89 = arith.index_cast %88 : i32 to index
          %90 = memref.load %arg7[%89] : memref<?xf32>
          %91 = arith.addi %87, %79 : i32
          %92 = arith.index_cast %91 : i32 to index
          %93 = memref.load %arg10[%92] : memref<?xf32>
          %94 = arith.mulf %90, %93 : f32
          %95 = memref.load %arg8[%89] : memref<?xf32>
          %96 = arith.addf %94, %95 : f32
          %97 = arith.addi %arg19, %85 : index
          %98 = memref.load %arg15[%97] : memref<?xf32>
          %99 = arith.mulf %96, %98 : f32
          memref.store %99, %arg10[%89] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %82 = arith.addi %72, %c-1_i32 : i32
      memref.store %82, %alloca[] : memref<i32>
      scf.yield
    }
    %56 = memref.load %37[%c0] : memref<1xi32>
    %57 = arith.index_cast %56 : i32 to index
    %58 = memref.load %38[%c0] : memref<1xi32>
    %59 = memref.load %4[%c0] : memref<1xi32>
    %60 = memref.load %11[%c0] : memref<1xi32>
    %61 = memref.load %1[%c0] : memref<1xi32>
    %62 = arith.index_cast %58 : i32 to index
    %63 = arith.index_cast %59 : i32 to index
    %64 = arith.index_cast %60 : i32 to index
    %65 = arith.muli %64, %63 : index
    %66 = arith.index_cast %61 : i32 to index
    %67 = arith.muli %65, %66 : index
    %reinterpret_cast_16 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%57, %63], strides: [%63, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%57, %63], strides: [%63, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%57, %62) step (%c1, %c1) {
      %68 = memref.load %reinterpret_cast_16[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %69 = arith.negf %68 : f32
      %70 = arith.muli %arg18, %63 overflow<nsw> : index
      %71 = arith.addi %arg19, %70 : index
      %72 = arith.addi %71, %67 : index
      %73 = memref.load %arg10[%72] : memref<?xf32>
      %74 = arith.mulf %69, %73 : f32
      memref.store %74, %reinterpret_cast_17[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


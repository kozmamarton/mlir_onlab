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
    %reinterpret_cast = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%3, %6) step (%c1, %c1) {
      memref.store %cst_1, %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %7 = memref.load %1[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %4[%c0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%8, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%8, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%8, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%8, %10) step (%c1, %c1) {
      %92 = memref.load %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %93 = memref.load %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %94 = arith.addf %92, %93 : f32
      %95 = arith.muli %arg18, %10 overflow<nsw> : index
      %96 = arith.addi %arg19, %95 : index
      %97 = arith.addi %96, %c-1 : index
      %98 = memref.load %arg0[%97] : memref<?xf32>
      %99 = arith.addf %94, %98 : f32
      %100 = memref.load %arg1[%97] : memref<?xf32>
      %101 = arith.addf %99, %100 : f32
      %102 = arith.mulf %101, %cst_0 : f32
      memref.store %102, %reinterpret_cast_4[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %11 = memref.get_global @kb : memref<1xi32>
    %12 = memref.load %11[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.load %1[%c0] : memref<1xi32>
    %15 = memref.load %4[%c0] : memref<1xi32>
    %16 = arith.index_cast %14 : i32 to index
    %17 = arith.index_cast %15 : i32 to index
    %18 = arith.muli %17, %16 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%13, %16, %17], strides: [%18, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%13, %16, %17], strides: [%18, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c1, %c1) to (%13, %16, %17) step (%c1, %c1, %c1) {
      %92 = memref.load %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %93 = arith.muli %arg19, %17 overflow<nsw> : index
      %94 = arith.addi %arg20, %93 : index
      %95 = arith.muli %arg18, %17 overflow<nsw> : index
      %96 = arith.muli %95, %16 overflow<nsw> : index
      %97 = arith.addi %94, %96 : index
      %98 = arith.addi %97, %c-1 : index
      %99 = memref.load %arg3[%98] : memref<?xf32>
      %100 = arith.addf %92, %99 : f32
      %101 = arith.mulf %100, %cst_0 : f32
      memref.store %101, %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %19 = memref.get_global @kbm2 : memref<1xi32>
    %20 = memref.load %19[%c0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.get_global @dti2 : memref<1xf32>
    %23 = memref.get_global @umol : memref<1xf32>
    %24 = memref.load %1[%c0] : memref<1xi32>
    %25 = memref.load %4[%c0] : memref<1xi32>
    %26 = memref.load %22[%c0] : memref<1xf32>
    %27 = memref.load %23[%c0] : memref<1xf32>
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.index_cast %25 : i32 to index
    %30 = arith.negf %26 : f32
    %31 = arith.muli %29, %28 : index
    %reinterpret_cast_7 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%21, %28, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%21, %28, %29], strides: [%31, %29, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%28, %29], strides: [%29, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>

      
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%21, %28, %29) step (%c1, %c1, %c1) {
      %92 = memref.load %arg5[%arg18] : memref<?xf32>
      %93 = memref.load %arg6[%arg18] : memref<?xf32>
      %94 = arith.mulf %92, %93 : f32
      %95 = arith.addi %arg18, %c1 : index
      %96 = memref.load %reinterpret_cast_7[%95, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %97 = arith.addf %96, %27 : f32
      %98 = arith.mulf %30, %97 : f32
      %99 = memref.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %100 = arith.mulf %94, %99 : f32
      %101 = arith.mulf %100, %99 : f32
      %102 = arith.divf %98, %101 : f32
      memref.store %102, %reinterpret_cast_8[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }

    %32 = memref.get_global @kbm1 : memref<1xi32>
    %33 = memref.load %32[%c0] : memref<1xi32>
    %34 = arith.index_cast %33 : i32 to index
    %35 = memref.load %1[%c0] : memref<1xi32>
    %36 = memref.load %4[%c0] : memref<1xi32>
    %37 = memref.load %22[%c0] : memref<1xf32>
    %38 = memref.load %23[%c0] : memref<1xf32>
    %39 = arith.index_cast %35 : i32 to index
    %40 = arith.index_cast %36 : i32 to index
    %41 = arith.negf %37 : f32
    %42 = arith.muli %40, %39 : index
    %reinterpret_cast_10 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%34, %39, %40], strides: [%42, %40, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%39, %40], strides: [%40, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>

     
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%34, %39, %40) step (%c1, %c1, %c1) {
      %92 = memref.load %arg5[%arg18] : memref<?xf32>
      %93 = arith.addi %arg18, %c-1 : index
      %94 = memref.load %arg6[%93] : memref<?xf32>
      %95 = arith.mulf %92, %94 : f32
      %96 = memref.load %reinterpret_cast_10[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %97 = arith.addf %96, %38 : f32
      %98 = arith.mulf %41, %97 : f32
      %99 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %100 = arith.mulf %95, %99 : f32
      %101 = arith.mulf %100, %99 : f32
      %102 = arith.divf %98, %101 : f32
      memref.store %102, %reinterpret_cast_10[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %43 = memref.load %1[%c0] : memref<1xi32>
    %44 = arith.index_cast %43 : i32 to index
    %45 = memref.load %4[%c0] : memref<1xi32>
    %46 = memref.load %22[%c0] : memref<1xf32>
    %47 = memref.load %arg5[%c0] : memref<?xf32>
    %48 = arith.index_cast %45 : i32 to index
    %49 = arith.negf %46 : f32
    %50 = arith.negf %47 : f32
    %reinterpret_cast_12 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%44, %48], strides: [%48, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%44, %48], strides: [%48, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%44, %48], strides: [%48, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%44, %48], strides: [%48, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%44, %48], strides: [%48, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%44, %48], strides: [%48, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%44, %48) step (%c1, %c1) {
      %92 = memref.load %reinterpret_cast_12[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %93 = arith.subf %92, %cst_1 : f32
      %94 = arith.divf %92, %93 : f32
      memref.store %94, %reinterpret_cast_13[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %95 = memref.load %reinterpret_cast_14[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %96 = arith.mulf %49, %95 : f32
      %97 = memref.load %reinterpret_cast_15[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %98 = arith.mulf %50, %97 : f32
      %99 = arith.divf %96, %98 : f32
      %100 = memref.load %reinterpret_cast_16[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %101 = arith.subf %99, %100 : f32
      %102 = memref.load %reinterpret_cast_12[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %103 = arith.subf %102, %cst_1 : f32
      %104 = arith.divf %101, %103 : f32
      memref.store %104, %reinterpret_cast_17[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %51 = memref.load %19[%c0] : memref<1xi32>
    %52 = arith.index_cast %51 : i32 to index
    %53 = memref.load %1[%c0] : memref<1xi32>
    %54 = memref.load %4[%c0] : memref<1xi32>
    %55 = arith.index_cast %53 : i32 to index
    %56 = arith.index_cast %54 : i32 to index
    %57 = arith.muli %56, %55 : index
    %reinterpret_cast_18 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%52, %55, %56], strides: [%57, %56, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%52, %55, %56], strides: [%57, %56, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%52, %55, %56], strides: [%57, %56, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%52, %55, %56], strides: [%57, %56, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%52, %55, %56], strides: [%57, %56, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%55, %56) step (%c1, %c1) {
      scf.for %arg20 = %c1 to %52 step %c1 {
        %92 = memref.load %reinterpret_cast_18[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %93 = memref.load %reinterpret_cast_19[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %94 = arith.addi %arg20, %c-1 : index
        %95 = memref.load %reinterpret_cast_20[%94, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %96 = arith.subf %cst_1, %95 : f32
        %97 = arith.mulf %93, %96 : f32
        %98 = arith.addf %92, %97 : f32
        %99 = arith.subf %98, %cst_1 : f32
        %100 = arith.divf %cst_1, %99 : f32
        memref.store %100, %reinterpret_cast_21[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %101 = memref.load %reinterpret_cast_18[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %102 = arith.mulf %101, %100 : f32
        memref.store %102, %reinterpret_cast_20[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %103 = memref.load %reinterpret_cast_19[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %104 = memref.load %reinterpret_cast_21[%94, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %105 = arith.mulf %103, %104 : f32
        %106 = memref.load %reinterpret_cast_22[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %107 = arith.subf %105, %106 : f32
        %108 = memref.load %reinterpret_cast_21[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %109 = arith.mulf %107, %108 : f32
        memref.store %109, %reinterpret_cast_21[%arg20, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      }
      scf.reduce 
    }
    %58 = memref.get_global @jmm1 : memref<1xi32>
    %59 = memref.load %58[%c0] : memref<1xi32>
    %60 = arith.index_cast %59 : i32 to index
    %61 = memref.get_global @imm1 : memref<1xi32>
    %62 = memref.load %61[%c0] : memref<1xi32>
    %63 = memref.load %4[%c0] : memref<1xi32>
    %64 = memref.load %19[%c0] : memref<1xi32>
    %65 = memref.load %1[%c0] : memref<1xi32>
    %66 = memref.load %22[%c0] : memref<1xf32>
    %67 = arith.index_cast %62 : i32 to index
    %68 = arith.index_cast %63 : i32 to index
    %69 = arith.index_cast %64 : i32 to index
    %70 = arith.muli %69, %68 : index
    %71 = arith.index_cast %65 : i32 to index
    %72 = arith.muli %70, %71 : index
    %73 = arith.addi %69, %c-1 : index
    %74 = arith.muli %73, %68 : index
    %75 = arith.muli %74, %71 : index
    %76 = memref.load %arg5[%69] : memref<?xf32>
    %77 = arith.negf %76 : f32
    %reinterpret_cast_23 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%60, %68], strides: [%68, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%60, %68], strides: [%68, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%60, %68], strides: [%68, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_26 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%60, %68], strides: [%68, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg18 = %c1 to %60 step %c1 {
      scf.for %arg19 = %c1 to %67 step %c1 {
        %92 = memref.load %reinterpret_cast_23[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %93 = arith.muli %arg18, %68 overflow<nsw> : index
        %94 = arith.addi %arg19, %93 : index
        %95 = arith.addi %94, %c-1 : index
        %96 = memref.load %arg12[%95] : memref<?xf32>
        %97 = arith.addf %92, %96 : f32
        %98 = arith.mulf %97, %cst_0 : f32
        %99 = arith.addi %94, %72 : index
        %100 = memref.load %arg13[%99] : memref<?xf32>
        %101 = arith.mulf %100, %100 : f32
        %102 = memref.load %arg14[%99] : memref<?xf32>
        %103 = arith.addi %arg19, %72 : index
        %104 = arith.addi %arg18, %c1 : index
        %105 = arith.muli %104, %68 overflow<nsw> : index
        %106 = arith.addi %103, %105 : index
        %107 = memref.load %arg14[%106] : memref<?xf32>
        %108 = arith.addf %102, %107 : f32
        %109 = arith.addi %99, %c-1 : index
        %110 = memref.load %arg14[%109] : memref<?xf32>
        %111 = arith.addf %108, %110 : f32
        %112 = arith.addi %106, %c-1 : index
        %113 = memref.load %arg14[%112] : memref<?xf32>
        %114 = arith.addf %111, %113 : f32
        %115 = arith.mulf %114, %cst : f32
        %116 = arith.mulf %115, %115 : f32
        %117 = arith.addf %101, %116 : f32
        %118 = math.sqrt %117 : f32
        %119 = arith.mulf %98, %118 : f32
        memref.store %119, %reinterpret_cast_24[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %120 = memref.load %arg2[%99] : memref<?xf32>
        %121 = arith.addi %94, %75 : index
        %122 = memref.load %arg8[%121] : memref<?xf32>
        %123 = arith.mulf %120, %122 : f32
        %124 = memref.load %arg10[%99] : memref<?xf32>
        %125 = arith.subf %123, %124 : f32
        %126 = arith.mulf %119, %66 : f32
        %127 = memref.load %reinterpret_cast_25[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %128 = arith.mulf %77, %127 : f32
        %129 = arith.divf %126, %128 : f32
        %130 = arith.subf %129, %cst_1 : f32
        %131 = memref.load %arg7[%121] : memref<?xf32>
        %132 = arith.subf %131, %cst_1 : f32
        %133 = arith.mulf %132, %120 : f32
        %134 = arith.subf %130, %133 : f32
        %135 = arith.divf %125, %134 : f32
        memref.store %135, %arg10[%99] : memref<?xf32>
        %136 = memref.load %arg10[%99] : memref<?xf32>
        %137 = memref.load %reinterpret_cast_26[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %138 = arith.mulf %136, %137 : f32
        memref.store %138, %arg10[%99] : memref<?xf32>
      }
    }
    %78 = memref.load %11[%c0] : memref<1xi32>
    %79 = arith.addi %78, %c-3_i32 : i32
    memref.store %79, %alloca[] : memref<i32>
    scf.while : () -> () {
      %92 = memref.load %alloca[] : memref<i32>
      %93 = arith.cmpi sge, %92, %c0_i32 : i32
      scf.condition(%93)
    } do {
      %92 = memref.load %58[%c0] : memref<1xi32>
      %93 = arith.index_cast %92 : i32 to index
      %94 = memref.load %61[%c0] : memref<1xi32>
      %95 = memref.load %4[%c0] : memref<1xi32>
      %96 = memref.load %alloca[] : memref<i32>
      %97 = memref.load %1[%c0] : memref<1xi32>
      %98 = arith.index_cast %94 : i32 to index
      %99 = arith.muli %96, %95 : i32
      %100 = arith.muli %99, %97 : i32
      %101 = arith.addi %96, %c1_i32 : i32
      %102 = arith.muli %101, %95 : i32
      %103 = arith.muli %102, %97 : i32
      %104 = arith.index_cast %95 : i32 to index
      scf.for %arg18 = %c1 to %93 step %c1 {
        %106 = arith.index_cast %arg18 : index to i32
        %107 = arith.muli %106, %95 : i32
        %108 = arith.muli %arg18, %104 : index
        scf.for %arg19 = %c1 to %98 step %c1 {
          %109 = arith.index_cast %arg19 : index to i32
          %110 = arith.addi %109, %107 : i32
          %111 = arith.addi %110, %100 : i32
          %112 = arith.index_cast %111 : i32 to index
          %113 = memref.load %arg7[%112] : memref<?xf32>
          %114 = arith.addi %110, %103 : i32
          %115 = arith.index_cast %114 : i32 to index
          %116 = memref.load %arg10[%115] : memref<?xf32>
          %117 = arith.mulf %113, %116 : f32
          %118 = memref.load %arg8[%112] : memref<?xf32>
          %119 = arith.addf %117, %118 : f32
          %120 = arith.addi %arg19, %108 : index
          %121 = memref.load %arg15[%120] : memref<?xf32>
          %122 = arith.mulf %119, %121 : f32
          memref.store %122, %arg10[%112] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %105 = arith.addi %96, %c-1_i32 : i32
      memref.store %105, %alloca[] : memref<i32>
      scf.yield
    }
    %80 = memref.load %58[%c0] : memref<1xi32>
    %81 = arith.index_cast %80 : i32 to index
    %82 = memref.load %61[%c0] : memref<1xi32>
    %83 = memref.load %4[%c0] : memref<1xi32>
    %84 = memref.load %19[%c0] : memref<1xi32>
    %85 = memref.load %1[%c0] : memref<1xi32>
    %86 = arith.index_cast %82 : i32 to index
    %87 = arith.index_cast %83 : i32 to index
    %88 = arith.index_cast %84 : i32 to index
    %89 = arith.muli %88, %87 : index
    %90 = arith.index_cast %85 : i32 to index
    %91 = arith.muli %89, %90 : index
    %reinterpret_cast_27 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%81, %87], strides: [%87, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_28 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%81, %87], strides: [%87, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg18, %arg19) = (%c1, %c1) to (%81, %86) step (%c1, %c1) {
      %92 = memref.load %reinterpret_cast_27[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %93 = arith.negf %92 : f32
      %94 = arith.muli %arg18, %87 overflow<nsw> : index
      %95 = arith.addi %arg19, %94 : index
      %96 = arith.addi %95, %91 : index
      %97 = memref.load %arg10[%96] : memref<?xf32>
      %98 = arith.mulf %93, %97 : f32
      memref.store %98, %reinterpret_cast_28[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


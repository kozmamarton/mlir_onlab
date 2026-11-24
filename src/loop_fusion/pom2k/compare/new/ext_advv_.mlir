module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advv_(%arg0: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advy", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 1.250000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %cst_2 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c1, %c1, %c1) {
      memref.store %cst_2, %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg18, %arg19, %arg20) = (%c1, %c1, %c0) to (%11, %7, %8) step (%c1, %c1, %c1) {
      %25 = memref.load %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %26 = arith.addi %arg19, %c-1 : index
      %27 = memref.load %reinterpret_cast_3[%arg18, %26, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %28 = arith.addf %25, %27 : f32
      %29 = arith.mulf %28, %cst_1 : f32
      %30 = memref.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %31 = arith.addi %arg18, %c-1 : index
      %32 = memref.load %reinterpret_cast_4[%31, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %33 = arith.addf %30, %32 : f32
      %34 = arith.mulf %29, %33 : f32
      memref.store %34, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %13 = memref.get_global @jmm1 : memref<1xi32>
    %14 = memref.get_global @imm1 : memref<1xi32>
    %15 = memref.get_global @grav : memref<1xf32>
    %16 = memref.load %13[%c0] : memref<1xi32>
    %17 = memref.load %14[%c0] : memref<1xi32>
    %18 = memref.load %15[%c0] : memref<1xf32>
    %19 = arith.index_cast %16 : i32 to index
    %20 = arith.index_cast %17 : i32 to index
    %21 = arith.mulf %18, %cst_0 : f32
    %reinterpret_cast_6 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %22 = memref.get_global @dti2 : memref<1xf32>
    %23 = memref.load %22[%c0] : memref<1xf32>
    %24 = arith.mulf %23, %cst : f32
    %reinterpret_cast_9 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%11, %7, %8], strides: [%12, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%19, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg18 = %c0 to %11 step %c1 {
      %25 = memref.load %arg8[%arg18] : memref<?xf32>
      scf.parallel (%arg19, %arg20) = (%c1, %c1) to (%19, %20) step (%c1, %c1) {
        %26 = memref.load %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %27 = memref.load %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %28 = arith.addi %arg18, %c1 : index
        %29 = memref.load %reinterpret_cast_5[%28, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %30 = arith.subf %27, %29 : f32
        %31 = memref.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %32 = arith.mulf %30, %31 : f32
        %33 = arith.divf %32, %25 : f32
        %34 = arith.addf %26, %33 : f32
        %35 = arith.mulf %31, %cst_1 : f32
        %36 = memref.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %37 = memref.load %reinterpret_cast_12[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.mulf %36, %37 : f32
        %39 = arith.muli %arg19, %8 overflow<nsw> : index
        %40 = arith.addi %arg20, %39 : index
        %41 = arith.muli %arg18, %8 overflow<nsw> : index
        %42 = arith.muli %41, %7 overflow<nsw> : index
        %43 = arith.addi %40, %42 : index
        %44 = arith.addi %43, %c1 : index
        %45 = memref.load %arg3[%44] : memref<?xf32>
        %46 = memref.load %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %47 = arith.addf %45, %46 : f32
        %48 = arith.mulf %38, %47 : f32
        %49 = arith.addi %arg19, %c-1 : index
        %50 = memref.load %reinterpret_cast_11[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %51 = memref.load %reinterpret_cast_12[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %52 = arith.mulf %50, %51 : f32
        %53 = arith.muli %49, %8 overflow<nsw> : index
        %54 = arith.addi %arg20, %53 : index
        %55 = arith.addi %54, %42 : index
        %56 = arith.addi %55, %c1 : index
        %57 = memref.load %arg3[%56] : memref<?xf32>
        %58 = memref.load %reinterpret_cast_7[%arg18, %49, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %59 = arith.addf %57, %58 : f32
        %60 = arith.mulf %52, %59 : f32
        %61 = arith.addf %48, %60 : f32
        %62 = arith.mulf %35, %61 : f32
        %63 = arith.addf %34, %62 : f32
        %64 = arith.addf %37, %51 : f32
        %65 = arith.mulf %21, %64 : f32
        %66 = memref.load %reinterpret_cast_13[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %67 = memref.load %reinterpret_cast_13[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %68 = arith.subf %66, %67 : f32
        %69 = memref.load %reinterpret_cast_14[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %70 = arith.addf %68, %69 : f32
        %71 = memref.load %reinterpret_cast_14[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %72 = arith.subf %70, %71 : f32
        %73 = memref.load %reinterpret_cast_15[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %74 = memref.load %reinterpret_cast_15[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %75 = arith.subf %73, %74 : f32
        %76 = arith.mulf %75, %cst : f32
        %77 = arith.addf %72, %76 : f32
        %78 = arith.mulf %65, %77 : f32
        %79 = memref.load %reinterpret_cast_16[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %80 = memref.load %reinterpret_cast_16[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %81 = arith.addf %79, %80 : f32
        %82 = arith.mulf %78, %81 : f32
        %83 = arith.addf %63, %82 : f32
        %84 = memref.load %reinterpret_cast_8[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %85 = arith.addf %83, %84 : f32
        %86 = memref.load %reinterpret_cast_17[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %87 = memref.load %reinterpret_cast_18[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %88 = arith.addf %86, %87 : f32
        %89 = memref.load %reinterpret_cast_17[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %90 = arith.addf %88, %89 : f32
        %91 = memref.load %reinterpret_cast_18[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %92 = arith.addf %90, %91 : f32
        %93 = arith.mulf %92, %31 : f32
        %94 = memref.load %reinterpret_cast_9[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %95 = arith.mulf %93, %94 : f32
        %96 = arith.mulf %24, %85 : f32
        %97 = arith.subf %95, %96 : f32
        %98 = memref.load %reinterpret_cast_19[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %99 = arith.addf %86, %98 : f32
        %100 = arith.addf %99, %89 : f32
        %101 = memref.load %reinterpret_cast_19[%49, %arg20] : memref<?x?xf32, strided<[?, 1]>>
        %102 = arith.addf %100, %101 : f32
        %103 = arith.mulf %102, %31 : f32
        %104 = arith.divf %97, %103 : f32
        memref.store %104, %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    return
  }
}


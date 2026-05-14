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
    affine.store %0, %alloca[] : memref<i32>
    %1 = memref.get_global @jm : memref<1xi32>
    %2 = affine.load %1[0] : memref<1xi32>
    %3 = arith.index_cast %2 : i32 to index
    %4 = memref.get_global @im : memref<1xi32>
    %5 = affine.load %4[0] : memref<1xi32>
    %6 = arith.index_cast %5 : i32 to index
    affine.for %arg18 = 0 to %3 {
      affine.for %arg19 = 0 to %6 {
        %reinterpret_cast = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %cst_1, %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %7 = affine.load %1[0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = affine.load %4[0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    affine.for %arg18 = 1 to %8 {
      affine.for %arg19 = 1 to %10 {
        %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%8, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %88 = affine.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%8, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %89 = affine.load %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %90 = arith.addf %88, %89 : f32
        %91 = affine.load %arg0[%arg19 + %arg18 * symbol(%10) - 1] : memref<?xf32>
        %92 = arith.addf %90, %91 : f32
        %93 = affine.load %arg1[%arg19 + %arg18 * symbol(%10) - 1] : memref<?xf32>
        %94 = arith.addf %92, %93 : f32
        %95 = arith.mulf %94, %cst_0 : f32
        %reinterpret_cast_3 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%8, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %95, %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %11 = memref.get_global @kb : memref<1xi32>
    %12 = affine.load %11[0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = affine.load %1[0] : memref<1xi32>
    %15 = affine.load %4[0] : memref<1xi32>
    %16 = arith.index_cast %14 : i32 to index
    %17 = arith.index_cast %15 : i32 to index
    affine.for %arg18 = 0 to %13 {
      affine.for %arg19 = 1 to %16 {
        affine.for %arg20 = 1 to %17 {
          %88 = arith.muli %17, %16 : index
          %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%13, %16, %17], strides: [%88, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %89 = affine.load %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %90 = affine.load %arg3[%arg20 + %arg19 * symbol(%17) + (%arg18 * symbol(%17)) * symbol(%16) - 1] : memref<?xf32>
          %91 = arith.addf %89, %90 : f32
          %92 = arith.mulf %91, %cst_0 : f32
          %reinterpret_cast_2 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%13, %16, %17], strides: [%88, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          affine.store %92, %reinterpret_cast_2[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %18 = memref.get_global @kbm2 : memref<1xi32>
    %19 = affine.load %18[0] : memref<1xi32>
    %20 = arith.index_cast %19 : i32 to index
    %21 = memref.get_global @dti2 : memref<1xf32>
    %22 = memref.get_global @umol : memref<1xf32>
    %23 = affine.load %1[0] : memref<1xi32>
    %24 = affine.load %4[0] : memref<1xi32>
    %25 = affine.load %21[0] : memref<1xf32>
    %26 = affine.load %22[0] : memref<1xf32>
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.negf %25 : f32
    affine.for %arg18 = 0 to %20 {
      %88 = affine.load %arg5[%arg18] : memref<?xf32>
      %89 = affine.load %arg6[%arg18] : memref<?xf32>
      %90 = arith.mulf %88, %89 : f32
      affine.for %arg19 = 0 to %27 {
        affine.for %arg20 = 0 to %28 {
          %91 = arith.muli %28, %27 : index
          %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%20, %27, %28], strides: [%91, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %92 = affine.load %reinterpret_cast[%arg18 + 1, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %93 = arith.addf %92, %26 : f32
          %94 = arith.mulf %29, %93 : f32
          %reinterpret_cast_2 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%27, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %95 = affine.load %reinterpret_cast_2[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %96 = arith.mulf %90, %95 : f32
          %97 = arith.mulf %96, %95 : f32
          %98 = arith.divf %94, %97 : f32
          %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%20, %27, %28], strides: [%91, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          affine.store %98, %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm2"}
    %30 = memref.get_global @kbm1 : memref<1xi32>
    %31 = affine.load %30[0] : memref<1xi32>
    %32 = arith.index_cast %31 : i32 to index
    %33 = affine.load %1[0] : memref<1xi32>
    %34 = affine.load %4[0] : memref<1xi32>
    %35 = affine.load %21[0] : memref<1xf32>
    %36 = affine.load %22[0] : memref<1xf32>
    %37 = arith.index_cast %33 : i32 to index
    %38 = arith.index_cast %34 : i32 to index
    %39 = arith.negf %35 : f32
    affine.for %arg18 = 1 to %32 {
      %88 = affine.load %arg5[%arg18] : memref<?xf32>
      %89 = affine.load %arg6[%arg18 - 1] : memref<?xf32>
      %90 = arith.mulf %88, %89 : f32
      affine.for %arg19 = 0 to %37 {
        affine.for %arg20 = 0 to %38 {
          %91 = arith.muli %38, %37 : index
          %reinterpret_cast = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%32, %37, %38], strides: [%91, %38, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %92 = affine.load %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %93 = arith.addf %92, %36 : f32
          %94 = arith.mulf %39, %93 : f32
          %reinterpret_cast_2 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%37, %38], strides: [%38, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %95 = affine.load %reinterpret_cast_2[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %96 = arith.mulf %90, %95 : f32
          %97 = arith.mulf %96, %95 : f32
          %98 = arith.divf %94, %97 : f32
          affine.store %98, %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %40 = affine.load %1[0] : memref<1xi32>
    %41 = arith.index_cast %40 : i32 to index
    %42 = affine.load %4[0] : memref<1xi32>
    %43 = affine.load %21[0] : memref<1xf32>
    %44 = affine.load %arg5[0] : memref<?xf32>
    %45 = arith.index_cast %42 : i32 to index
    %46 = arith.negf %43 : f32
    %47 = arith.negf %44 : f32
    affine.for %arg18 = 0 to %41 {
      affine.for %arg19 = 0 to %45 {
        %reinterpret_cast = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%41, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %88 = affine.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %89 = arith.subf %88, %cst_1 : f32
        %90 = arith.divf %88, %89 : f32
        %reinterpret_cast_2 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%41, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %90, %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %reinterpret_cast_3 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%41, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %91 = affine.load %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %92 = arith.mulf %46, %91 : f32
        %reinterpret_cast_4 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%41, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %93 = affine.load %reinterpret_cast_4[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %94 = arith.mulf %47, %93 : f32
        %95 = arith.divf %92, %94 : f32
        %reinterpret_cast_5 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%41, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %96 = affine.load %reinterpret_cast_5[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %97 = arith.subf %95, %96 : f32
        %98 = affine.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %99 = arith.subf %98, %cst_1 : f32
        %100 = arith.divf %97, %99 : f32
        %reinterpret_cast_6 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%41, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %100, %reinterpret_cast_6[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %48 = affine.load %18[0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    %50 = affine.load %1[0] : memref<1xi32>
    %51 = affine.load %4[0] : memref<1xi32>
    %52 = arith.index_cast %50 : i32 to index
    %53 = arith.index_cast %51 : i32 to index
    affine.for %arg18 = 1 to %49 {
      affine.for %arg19 = 0 to %52 {
        affine.for %arg20 = 0 to %53 {
          %88 = arith.muli %53, %52 : index
          %reinterpret_cast = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%49, %52, %53], strides: [%88, %53, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %89 = affine.load %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %reinterpret_cast_2 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%49, %52, %53], strides: [%88, %53, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %90 = affine.load %reinterpret_cast_2[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %reinterpret_cast_3 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%49, %52, %53], strides: [%88, %53, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %91 = affine.load %reinterpret_cast_3[%arg18 - 1, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %92 = arith.subf %cst_1, %91 : f32
          %93 = arith.mulf %90, %92 : f32
          %94 = arith.addf %89, %93 : f32
          %95 = arith.subf %94, %cst_1 : f32
          %96 = arith.divf %cst_1, %95 : f32
          %reinterpret_cast_4 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%49, %52, %53], strides: [%88, %53, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          affine.store %96, %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %97 = affine.load %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %98 = arith.mulf %97, %96 : f32
          affine.store %98, %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %99 = affine.load %reinterpret_cast_2[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %100 = affine.load %reinterpret_cast_4[%arg18 - 1, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %101 = arith.mulf %99, %100 : f32
          %reinterpret_cast_5 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%49, %52, %53], strides: [%88, %53, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %102 = affine.load %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %103 = arith.subf %101, %102 : f32
          %104 = affine.load %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %105 = arith.mulf %103, %104 : f32
          affine.store %105, %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm2"}
    %54 = memref.get_global @jmm1 : memref<1xi32>
    %55 = affine.load %54[0] : memref<1xi32>
    %56 = arith.index_cast %55 : i32 to index
    %57 = memref.get_global @imm1 : memref<1xi32>
    %58 = affine.load %57[0] : memref<1xi32>
    %59 = affine.load %4[0] : memref<1xi32>
    %60 = affine.load %18[0] : memref<1xi32>
    %61 = affine.load %1[0] : memref<1xi32>
    %62 = affine.load %21[0] : memref<1xf32>
    %63 = arith.index_cast %58 : i32 to index
    %64 = arith.index_cast %59 : i32 to index
    %65 = arith.index_cast %60 : i32 to index
    %66 = arith.muli %65, %64 : index
    %67 = arith.index_cast %61 : i32 to index
    %68 = arith.muli %66, %67 : index
    %69 = arith.addi %65, %c-1 : index
    %70 = arith.muli %69, %64 : index
    %71 = arith.muli %70, %67 : index
    %72 = affine.load %arg5[symbol(%65)] : memref<?xf32>
    %73 = arith.negf %72 : f32
    affine.for %arg18 = 1 to %56 {
      affine.for %arg19 = 1 to %63 {
        %reinterpret_cast = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%56, %64], strides: [%64, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %88 = affine.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %89 = affine.load %arg12[%arg19 + %arg18 * symbol(%64) - 1] : memref<?xf32>
        %90 = arith.addf %88, %89 : f32
        %91 = arith.mulf %90, %cst_0 : f32
        %92 = affine.load %arg13[%arg19 + %arg18 * symbol(%64) + symbol(%68)] : memref<?xf32>
        %93 = arith.mulf %92, %92 : f32
        %94 = affine.load %arg14[%arg19 + %arg18 * symbol(%64) + symbol(%68)] : memref<?xf32>
        %95 = affine.load %arg14[%arg19 + symbol(%68) + (%arg18 + 1) * symbol(%64)] : memref<?xf32>
        %96 = arith.addf %94, %95 : f32
        %97 = affine.load %arg14[%arg19 + %arg18 * symbol(%64) + symbol(%68) - 1] : memref<?xf32>
        %98 = arith.addf %96, %97 : f32
        %99 = affine.load %arg14[%arg19 + symbol(%68) + (%arg18 + 1) * symbol(%64) - 1] : memref<?xf32>
        %100 = arith.addf %98, %99 : f32
        %101 = arith.mulf %100, %cst : f32
        %102 = arith.mulf %101, %101 : f32
        %103 = arith.addf %93, %102 : f32
        %104 = math.sqrt %103 : f32
        %105 = arith.mulf %91, %104 : f32
        %reinterpret_cast_2 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%56, %64], strides: [%64, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %105, %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %106 = affine.load %arg2[%arg19 + %arg18 * symbol(%64) + symbol(%68)] : memref<?xf32>
        %107 = affine.load %arg8[%arg19 + %arg18 * symbol(%64) + symbol(%71)] : memref<?xf32>
        %108 = arith.mulf %106, %107 : f32
        %109 = affine.load %arg10[%arg19 + %arg18 * symbol(%64) + symbol(%68)] : memref<?xf32>
        %110 = arith.subf %108, %109 : f32
        %111 = arith.mulf %105, %62 : f32
        %reinterpret_cast_3 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%56, %64], strides: [%64, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %112 = affine.load %reinterpret_cast_3[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %113 = arith.mulf %73, %112 : f32
        %114 = arith.divf %111, %113 : f32
        %115 = arith.subf %114, %cst_1 : f32
        %116 = affine.load %arg7[%arg19 + %arg18 * symbol(%64) + symbol(%71)] : memref<?xf32>
        %117 = arith.subf %116, %cst_1 : f32
        %118 = arith.mulf %117, %106 : f32
        %119 = arith.subf %115, %118 : f32
        %120 = arith.divf %110, %119 : f32
        affine.store %120, %arg10[%arg19 + %arg18 * symbol(%64) + symbol(%68)] : memref<?xf32>
        %121 = affine.load %arg10[%arg19 + %arg18 * symbol(%64) + symbol(%68)] : memref<?xf32>
        %reinterpret_cast_4 = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%56, %64], strides: [%64, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %122 = affine.load %reinterpret_cast_4[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %123 = arith.mulf %121, %122 : f32
        affine.store %123, %arg10[%arg19 + %arg18 * symbol(%64) + symbol(%68)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %74 = affine.load %11[0] : memref<1xi32>
    %75 = arith.addi %74, %c-3_i32 : i32
    affine.store %75, %alloca[] : memref<i32>
    scf.while : () -> () {
      %88 = affine.load %alloca[] : memref<i32>
      %89 = arith.cmpi sge, %88, %c0_i32 : i32
      scf.condition(%89)
    } do {
      %88 = affine.load %54[0] : memref<1xi32>
      %89 = arith.index_cast %88 : i32 to index
      %90 = affine.load %57[0] : memref<1xi32>
      %91 = affine.load %4[0] : memref<1xi32>
      %92 = affine.load %alloca[] : memref<i32>
      %93 = affine.load %1[0] : memref<1xi32>
      %94 = arith.index_cast %90 : i32 to index
      %95 = arith.muli %92, %91 : i32
      %96 = arith.muli %95, %93 : i32
      %97 = arith.addi %92, %c1_i32 : i32
      %98 = arith.muli %97, %91 : i32
      %99 = arith.muli %98, %93 : i32
      %100 = arith.index_cast %91 : i32 to index
      scf.for %arg18 = %c1 to %89 step %c1 {
        %102 = arith.index_cast %arg18 : index to i32
        %103 = arith.muli %102, %91 : i32
        %104 = arith.muli %arg18, %100 : index
        scf.for %arg19 = %c1 to %94 step %c1 {
          %105 = arith.index_cast %arg19 : index to i32
          %106 = arith.addi %105, %103 : i32
          %107 = arith.addi %106, %96 : i32
          %108 = arith.index_cast %107 : i32 to index
          %109 = memref.load %arg7[%108] : memref<?xf32>
          %110 = arith.addi %106, %99 : i32
          %111 = arith.index_cast %110 : i32 to index
          %112 = memref.load %arg10[%111] : memref<?xf32>
          %113 = arith.mulf %109, %112 : f32
          %114 = memref.load %arg8[%108] : memref<?xf32>
          %115 = arith.addf %113, %114 : f32
          %116 = arith.addi %arg19, %104 : index
          %117 = memref.load %arg15[%116] : memref<?xf32>
          %118 = arith.mulf %115, %117 : f32
          memref.store %118, %arg10[%108] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %101 = arith.addi %92, %c-1_i32 : i32
      affine.store %101, %alloca[] : memref<i32>
      scf.yield
    }
    %76 = affine.load %54[0] : memref<1xi32>
    %77 = arith.index_cast %76 : i32 to index
    %78 = affine.load %57[0] : memref<1xi32>
    %79 = affine.load %4[0] : memref<1xi32>
    %80 = affine.load %18[0] : memref<1xi32>
    %81 = affine.load %1[0] : memref<1xi32>
    %82 = arith.index_cast %78 : i32 to index
    %83 = arith.index_cast %79 : i32 to index
    %84 = arith.index_cast %80 : i32 to index
    %85 = arith.muli %84, %83 : index
    %86 = arith.index_cast %81 : i32 to index
    %87 = arith.muli %85, %86 : index
    affine.for %arg18 = 1 to %77 {
      affine.for %arg19 = 1 to %82 {
        %reinterpret_cast = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%77, %83], strides: [%83, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        %88 = affine.load %reinterpret_cast[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %89 = arith.negf %88 : f32
        %90 = affine.load %arg10[%arg19 + %arg18 * symbol(%83) + symbol(%87)] : memref<?xf32>
        %91 = arith.mulf %89, %90 : f32
        %reinterpret_cast_2 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%77, %83], strides: [%83, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
        affine.store %91, %reinterpret_cast_2[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    return
  }
}


module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advu_(%arg0: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advx", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 1.250000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %cst_2 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = affine.load %3[0] : memref<1xi32>
    %6 = affine.load %4[0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    affine.for %arg18 = 0 to %2 {
      affine.for %arg19 = 0 to %7 {
        affine.for %arg20 = 0 to %8 {
          %44 = arith.muli %8, %7 : index
          %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%44, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          affine.store %cst_2, %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = affine.load %9[0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = affine.load %3[0] : memref<1xi32>
    %13 = affine.load %4[0] : memref<1xi32>
    %14 = arith.index_cast %12 : i32 to index
    %15 = arith.index_cast %13 : i32 to index
    affine.for %arg18 = 1 to %11 {
      affine.for %arg19 = 0 to %14 {
        affine.for %arg20 = 1 to %15 {
          %44 = arith.muli %15, %14 : index
          %reinterpret_cast = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %14, %15], strides: [%44, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %45 = affine.load %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %46 = affine.load %arg4[%arg20 + %arg19 * symbol(%15) + (%arg18 * symbol(%15)) * symbol(%14) - 1] : memref<?xf32>
          %47 = arith.addf %45, %46 : f32
          %48 = arith.mulf %47, %cst_1 : f32
          %reinterpret_cast_3 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%11, %14, %15], strides: [%44, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %49 = affine.load %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %50 = affine.load %reinterpret_cast_3[%arg18 - 1, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %51 = arith.addf %49, %50 : f32
          %52 = arith.mulf %48, %51 : f32
          %reinterpret_cast_4 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%11, %14, %15], strides: [%44, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          affine.store %52, %reinterpret_cast_4[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %16 = affine.load %9[0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @jmm1 : memref<1xi32>
    %19 = memref.get_global @imm1 : memref<1xi32>
    %20 = memref.get_global @grav : memref<1xf32>
    %21 = affine.load %18[0] : memref<1xi32>
    %22 = affine.load %19[0] : memref<1xi32>
    %23 = affine.load %4[0] : memref<1xi32>
    %24 = affine.load %3[0] : memref<1xi32>
    %25 = affine.load %20[0] : memref<1xf32>
    %26 = arith.index_cast %21 : i32 to index
    %27 = arith.index_cast %22 : i32 to index
    %28 = arith.index_cast %23 : i32 to index
    %29 = arith.index_cast %24 : i32 to index
    %30 = arith.mulf %25, %cst_0 : f32
    affine.for %arg18 = 0 to %17 {
      %44 = affine.load %arg8[%arg18] : memref<?xf32>
      affine.for %arg19 = 1 to %26 {
        affine.for %arg20 = 1 to %27 {
          %45 = arith.muli %28, %29 : index
          %reinterpret_cast = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%17, %29, %28], strides: [%45, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %46 = affine.load %reinterpret_cast[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%17, %29, %28], strides: [%45, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %47 = affine.load %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %48 = affine.load %reinterpret_cast_3[%arg18 + 1, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %49 = arith.subf %47, %48 : f32
          %reinterpret_cast_4 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%26, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %50 = affine.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %51 = arith.mulf %49, %50 : f32
          %52 = arith.divf %51, %44 : f32
          %53 = arith.addf %46, %52 : f32
          %54 = arith.mulf %50, %cst_1 : f32
          %reinterpret_cast_5 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%26, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %55 = affine.load %reinterpret_cast_5[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %reinterpret_cast_6 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%26, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %56 = affine.load %reinterpret_cast_6[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %57 = arith.mulf %55, %56 : f32
          %reinterpret_cast_7 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%17, %29, %28], strides: [%45, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %58 = affine.load %reinterpret_cast_7[%arg18, %arg19 + 1, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %59 = affine.load %reinterpret_cast_7[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %60 = arith.addf %58, %59 : f32
          %61 = arith.mulf %57, %60 : f32
          %62 = affine.load %arg9[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %63 = affine.load %arg10[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %64 = arith.mulf %62, %63 : f32
          %65 = affine.load %arg3[%arg20 + (%arg19 + 1) * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29) - 1] : memref<?xf32>
          %66 = affine.load %arg3[%arg20 + %arg19 * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29) - 1] : memref<?xf32>
          %67 = arith.addf %65, %66 : f32
          %68 = arith.mulf %64, %67 : f32
          %69 = arith.addf %61, %68 : f32
          %70 = arith.mulf %54, %69 : f32
          %71 = arith.subf %53, %70 : f32
          %72 = arith.addf %56, %63 : f32
          %73 = arith.mulf %30, %72 : f32
          %reinterpret_cast_8 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%26, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %74 = affine.load %reinterpret_cast_8[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %75 = affine.load %arg11[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %76 = arith.subf %74, %75 : f32
          %reinterpret_cast_9 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%26, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %77 = affine.load %reinterpret_cast_9[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %78 = arith.addf %76, %77 : f32
          %79 = affine.load %arg12[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %80 = arith.subf %78, %79 : f32
          %reinterpret_cast_10 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%26, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %81 = affine.load %reinterpret_cast_10[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %82 = affine.load %arg13[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %83 = arith.subf %81, %82 : f32
          %84 = arith.mulf %83, %cst : f32
          %85 = arith.addf %80, %84 : f32
          %86 = arith.mulf %73, %85 : f32
          %reinterpret_cast_11 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%26, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %87 = affine.load %reinterpret_cast_11[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %88 = affine.load %arg7[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %89 = arith.addf %87, %88 : f32
          %90 = arith.mulf %86, %89 : f32
          %91 = arith.addf %71, %90 : f32
          %reinterpret_cast_12 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%17, %29, %28], strides: [%45, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %92 = affine.load %reinterpret_cast_12[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %93 = arith.addf %91, %92 : f32
          affine.store %93, %reinterpret_cast_3[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %31 = affine.load %9[0] : memref<1xi32>
    %32 = arith.index_cast %31 : i32 to index
    %33 = memref.get_global @dti2 : memref<1xf32>
    %34 = affine.load %18[0] : memref<1xi32>
    %35 = affine.load %19[0] : memref<1xi32>
    %36 = affine.load %4[0] : memref<1xi32>
    %37 = affine.load %3[0] : memref<1xi32>
    %38 = affine.load %33[0] : memref<1xf32>
    %39 = arith.index_cast %34 : i32 to index
    %40 = arith.index_cast %35 : i32 to index
    %41 = arith.index_cast %36 : i32 to index
    %42 = arith.index_cast %37 : i32 to index
    %43 = arith.mulf %38, %cst : f32
    affine.for %arg18 = 0 to %32 {
      affine.for %arg19 = 1 to %39 {
        affine.for %arg20 = 1 to %40 {
          %reinterpret_cast = memref.reinterpret_cast %arg15 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %44 = affine.load %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %reinterpret_cast_3 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %45 = affine.load %reinterpret_cast_3[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %46 = arith.addf %44, %45 : f32
          %47 = affine.load %arg15[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
          %48 = arith.addf %46, %47 : f32
          %49 = affine.load %arg17[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
          %50 = arith.addf %48, %49 : f32
          %reinterpret_cast_4 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %51 = affine.load %reinterpret_cast_4[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %52 = arith.mulf %50, %51 : f32
          %53 = arith.muli %41, %42 : index
          %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%32, %42, %41], strides: [%53, %41, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %54 = affine.load %reinterpret_cast_5[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %55 = arith.mulf %52, %54 : f32
          %reinterpret_cast_6 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%32, %42, %41], strides: [%53, %41, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %56 = affine.load %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %57 = arith.mulf %43, %56 : f32
          %58 = arith.subf %55, %57 : f32
          %reinterpret_cast_7 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%39, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %59 = affine.load %reinterpret_cast_7[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
          %60 = arith.addf %44, %59 : f32
          %61 = arith.addf %60, %47 : f32
          %62 = affine.load %arg16[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
          %63 = arith.addf %61, %62 : f32
          %64 = arith.mulf %63, %51 : f32
          %65 = arith.divf %58, %64 : f32
          affine.store %65, %reinterpret_cast_6[%arg18, %arg19, %arg20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}


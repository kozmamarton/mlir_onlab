module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
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
          affine.store %cst_2, %arg1[%arg20 + %arg19 * symbol(%8) + (%arg18 * symbol(%8)) * symbol(%7)] : memref<?xf32>
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
          %44 = affine.load %arg4[%arg20 + %arg19 * symbol(%15) + (%arg18 * symbol(%15)) * symbol(%14)] : memref<?xf32>
          %45 = affine.load %arg4[%arg20 + %arg19 * symbol(%15) + (%arg18 * symbol(%15)) * symbol(%14) - 1] : memref<?xf32>
          %46 = arith.addf %44, %45 : f32
          %47 = arith.mulf %46, %cst_1 : f32
          %48 = affine.load %arg0[%arg20 + %arg19 * symbol(%15) + (%arg18 * symbol(%15)) * symbol(%14)] : memref<?xf32>
          %49 = affine.load %arg0[%arg20 + %arg19 * symbol(%15) + ((%arg18 - 1) * symbol(%15)) * symbol(%14)] : memref<?xf32>
          %50 = arith.addf %48, %49 : f32
          %51 = arith.mulf %47, %50 : f32
          affine.store %51, %arg1[%arg20 + %arg19 * symbol(%15) + (%arg18 * symbol(%15)) * symbol(%14)] : memref<?xf32>
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
          %45 = affine.load %arg5[%arg20 + %arg19 * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29)] : memref<?xf32>
          %46 = affine.load %arg1[%arg20 + %arg19 * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29)] : memref<?xf32>
          %47 = affine.load %arg1[%arg20 + %arg19 * symbol(%28) + ((%arg18 + 1) * symbol(%28)) * symbol(%29)] : memref<?xf32>
          %48 = arith.subf %46, %47 : f32
          %49 = affine.load %arg6[%arg20 + %arg19 * symbol(%28)] : memref<?xf32>
          %50 = arith.mulf %48, %49 : f32
          %51 = arith.divf %50, %44 : f32
          %52 = arith.addf %45, %51 : f32
          %53 = arith.mulf %49, %cst_1 : f32
          %54 = affine.load %arg9[%arg20 + %arg19 * symbol(%28)] : memref<?xf32>
          %55 = affine.load %arg10[%arg20 + %arg19 * symbol(%28)] : memref<?xf32>
          %56 = arith.mulf %54, %55 : f32
          %57 = affine.load %arg3[%arg20 + (%arg19 + 1) * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29)] : memref<?xf32>
          %58 = affine.load %arg3[%arg20 + %arg19 * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29)] : memref<?xf32>
          %59 = arith.addf %57, %58 : f32
          %60 = arith.mulf %56, %59 : f32
          %61 = affine.load %arg9[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %62 = affine.load %arg10[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %63 = arith.mulf %61, %62 : f32
          %64 = affine.load %arg3[%arg20 + (%arg19 + 1) * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29) - 1] : memref<?xf32>
          %65 = affine.load %arg3[%arg20 + %arg19 * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29) - 1] : memref<?xf32>
          %66 = arith.addf %64, %65 : f32
          %67 = arith.mulf %63, %66 : f32
          %68 = arith.addf %60, %67 : f32
          %69 = arith.mulf %53, %68 : f32
          %70 = arith.subf %52, %69 : f32
          %71 = arith.addf %55, %62 : f32
          %72 = arith.mulf %30, %71 : f32
          %73 = affine.load %arg11[%arg20 + %arg19 * symbol(%28)] : memref<?xf32>
          %74 = affine.load %arg11[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %75 = arith.subf %73, %74 : f32
          %76 = affine.load %arg12[%arg20 + %arg19 * symbol(%28)] : memref<?xf32>
          %77 = arith.addf %75, %76 : f32
          %78 = affine.load %arg12[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %79 = arith.subf %77, %78 : f32
          %80 = affine.load %arg13[%arg20 + %arg19 * symbol(%28)] : memref<?xf32>
          %81 = affine.load %arg13[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %82 = arith.subf %80, %81 : f32
          %83 = arith.mulf %82, %cst : f32
          %84 = arith.addf %79, %83 : f32
          %85 = arith.mulf %72, %84 : f32
          %86 = affine.load %arg7[%arg20 + %arg19 * symbol(%28)] : memref<?xf32>
          %87 = affine.load %arg7[%arg20 + %arg19 * symbol(%28) - 1] : memref<?xf32>
          %88 = arith.addf %86, %87 : f32
          %89 = arith.mulf %85, %88 : f32
          %90 = arith.addf %70, %89 : f32
          %91 = affine.load %arg14[%arg20 + %arg19 * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29)] : memref<?xf32>
          %92 = arith.addf %90, %91 : f32
          affine.store %92, %arg1[%arg20 + %arg19 * symbol(%28) + (%arg18 * symbol(%28)) * symbol(%29)] : memref<?xf32>
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
          %44 = affine.load %arg15[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
          %45 = affine.load %arg17[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
          %46 = arith.addf %44, %45 : f32
          %47 = affine.load %arg15[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
          %48 = arith.addf %46, %47 : f32
          %49 = affine.load %arg17[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
          %50 = arith.addf %48, %49 : f32
          %51 = affine.load %arg6[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
          %52 = arith.mulf %50, %51 : f32
          %53 = affine.load %arg2[%arg20 + %arg19 * symbol(%41) + (%arg18 * symbol(%41)) * symbol(%42)] : memref<?xf32>
          %54 = arith.mulf %52, %53 : f32
          %55 = affine.load %arg1[%arg20 + %arg19 * symbol(%41) + (%arg18 * symbol(%41)) * symbol(%42)] : memref<?xf32>
          %56 = arith.mulf %43, %55 : f32
          %57 = arith.subf %54, %56 : f32
          %58 = affine.load %arg16[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
          %59 = arith.addf %44, %58 : f32
          %60 = arith.addf %59, %47 : f32
          %61 = affine.load %arg16[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
          %62 = arith.addf %60, %61 : f32
          %63 = arith.mulf %62, %51 : f32
          %64 = arith.divf %57, %63 : f32
          affine.store %64, %arg1[%arg20 + %arg19 * symbol(%41) + (%arg18 * symbol(%41)) * symbol(%42)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

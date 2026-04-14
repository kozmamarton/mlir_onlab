module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
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
    %c-1 = arith.constant -1 : index
    %c-3_i32 = arith.constant -3 : i32
    %c-1_i32 = arith.constant -1 : i32
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %c1_i32 = arith.constant 1 : i32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %0 = memref.alloca() : memref<i32>
    %1 = llvm.mlir.undef : i32
    affine.store %1, %0[] : memref<i32>
    %2 = memref.get_global @jm : memref<1xi32>
    %3 = affine.load %2[0] : memref<1xi32>
    %4 = arith.index_cast %3 : i32 to index
    %5 = memref.get_global @im : memref<1xi32>
    %6 = affine.load %5[0] : memref<1xi32>
    %7 = arith.index_cast %6 : i32 to index
    affine.for %arg18 = 0 to %4 {
      affine.for %arg19 = 0 to %7 {
        affine.store %cst_1, %arg17[%arg19 + %arg18 * symbol(%7)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %8 = affine.load %2[0] : memref<1xi32>
    %9 = arith.index_cast %8 : i32 to index
    %10 = affine.load %5[0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    affine.for %arg18 = 1 to %9 {
      affine.for %arg19 = 1 to %11 {
        %89 = affine.load %arg0[%arg19 + %arg18 * symbol(%11)] : memref<?xf32>
        %90 = affine.load %arg1[%arg19 + %arg18 * symbol(%11)] : memref<?xf32>
        %91 = arith.addf %89, %90 : f32
        %92 = affine.load %arg0[%arg19 + %arg18 * symbol(%11) - 1] : memref<?xf32>
        %93 = arith.addf %91, %92 : f32
        %94 = affine.load %arg1[%arg19 + %arg18 * symbol(%11) - 1] : memref<?xf32>
        %95 = arith.addf %93, %94 : f32
        %96 = arith.mulf %95, %cst_0 : f32
        affine.store %96, %arg17[%arg19 + %arg18 * symbol(%11)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %12 = memref.get_global @kb : memref<1xi32>
    %13 = affine.load %12[0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = affine.load %2[0] : memref<1xi32>
    %16 = affine.load %5[0] : memref<1xi32>
    %17 = arith.index_cast %15 : i32 to index
    %18 = arith.index_cast %16 : i32 to index
    affine.for %arg18 = 0 to %14 {
      affine.for %arg19 = 1 to %17 {
        affine.for %arg20 = 1 to %18 {
          %89 = affine.load %arg3[%arg20 + %arg19 * symbol(%18) + (%arg18 * symbol(%18)) * symbol(%17)] : memref<?xf32>
          %90 = affine.load %arg3[%arg20 + %arg19 * symbol(%18) + (%arg18 * symbol(%18)) * symbol(%17) - 1] : memref<?xf32>
          %91 = arith.addf %89, %90 : f32
          %92 = arith.mulf %91, %cst_0 : f32
          affine.store %92, %arg2[%arg20 + %arg19 * symbol(%18) + (%arg18 * symbol(%18)) * symbol(%17)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %19 = memref.get_global @kbm2 : memref<1xi32>
    %20 = affine.load %19[0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.get_global @dti2 : memref<1xf32>
    %23 = memref.get_global @umol : memref<1xf32>
    %24 = affine.load %2[0] : memref<1xi32>
    %25 = affine.load %5[0] : memref<1xi32>
    %26 = affine.load %22[0] : memref<1xf32>
    %27 = affine.load %23[0] : memref<1xf32>
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.index_cast %25 : i32 to index
    %30 = arith.negf %26 : f32
    affine.for %arg18 = 0 to %21 {
      %89 = affine.load %arg5[%arg18] : memref<?xf32>
      %90 = affine.load %arg6[%arg18] : memref<?xf32>
      %91 = arith.mulf %89, %90 : f32
      affine.for %arg19 = 0 to %28 {
        affine.for %arg20 = 0 to %29 {
          %92 = affine.load %arg2[%arg20 + %arg19 * symbol(%29) + ((%arg18 + 1) * symbol(%29)) * symbol(%28)] : memref<?xf32>
          %93 = arith.addf %92, %27 : f32
          %94 = arith.mulf %30, %93 : f32
          %95 = affine.load %arg17[%arg20 + %arg19 * symbol(%29)] : memref<?xf32>
          %96 = arith.mulf %91, %95 : f32
          %97 = arith.mulf %96, %95 : f32
          %98 = arith.divf %94, %97 : f32
          affine.store %98, %arg4[%arg20 + %arg19 * symbol(%29) + (%arg18 * symbol(%29)) * symbol(%28)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm2"}
    %31 = memref.get_global @kbm1 : memref<1xi32>
    %32 = affine.load %31[0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %34 = affine.load %2[0] : memref<1xi32>
    %35 = affine.load %5[0] : memref<1xi32>
    %36 = affine.load %22[0] : memref<1xf32>
    %37 = affine.load %23[0] : memref<1xf32>
    %38 = arith.index_cast %34 : i32 to index
    %39 = arith.index_cast %35 : i32 to index
    %40 = arith.negf %36 : f32
    affine.for %arg18 = 1 to %33 {
      %89 = affine.load %arg5[%arg18] : memref<?xf32>
      %90 = affine.load %arg6[%arg18 - 1] : memref<?xf32>
      %91 = arith.mulf %89, %90 : f32
      affine.for %arg19 = 0 to %38 {
        affine.for %arg20 = 0 to %39 {
          %92 = affine.load %arg2[%arg20 + %arg19 * symbol(%39) + (%arg18 * symbol(%39)) * symbol(%38)] : memref<?xf32>
          %93 = arith.addf %92, %37 : f32
          %94 = arith.mulf %40, %93 : f32
          %95 = affine.load %arg17[%arg20 + %arg19 * symbol(%39)] : memref<?xf32>
          %96 = arith.mulf %91, %95 : f32
          %97 = arith.mulf %96, %95 : f32
          %98 = arith.divf %94, %97 : f32
          affine.store %98, %arg2[%arg20 + %arg19 * symbol(%39) + (%arg18 * symbol(%39)) * symbol(%38)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %41 = affine.load %2[0] : memref<1xi32>
    %42 = arith.index_cast %41 : i32 to index
    %43 = affine.load %5[0] : memref<1xi32>
    %44 = affine.load %22[0] : memref<1xf32>
    %45 = affine.load %arg5[0] : memref<?xf32>
    %46 = arith.index_cast %43 : i32 to index
    %47 = arith.negf %44 : f32
    %48 = arith.negf %45 : f32
    affine.for %arg18 = 0 to %42 {
      affine.for %arg19 = 0 to %46 {
        %89 = affine.load %arg4[%arg19 + %arg18 * symbol(%46)] : memref<?xf32>
        %90 = arith.subf %89, %cst_1 : f32
        %91 = arith.divf %89, %90 : f32
        affine.store %91, %arg7[%arg19 + %arg18 * symbol(%46)] : memref<?xf32>
        %92 = affine.load %arg9[%arg19 + %arg18 * symbol(%46)] : memref<?xf32>
        %93 = arith.mulf %47, %92 : f32
        %94 = affine.load %arg17[%arg19 + %arg18 * symbol(%46)] : memref<?xf32>
        %95 = arith.mulf %48, %94 : f32
        %96 = arith.divf %93, %95 : f32
        %97 = affine.load %arg10[%arg19 + %arg18 * symbol(%46)] : memref<?xf32>
        %98 = arith.subf %96, %97 : f32
        %99 = affine.load %arg4[%arg19 + %arg18 * symbol(%46)] : memref<?xf32>
        %100 = arith.subf %99, %cst_1 : f32
        %101 = arith.divf %98, %100 : f32
        affine.store %101, %arg8[%arg19 + %arg18 * symbol(%46)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %49 = affine.load %19[0] : memref<1xi32>
    %50 = arith.index_cast %49 : i32 to index
    %51 = affine.load %2[0] : memref<1xi32>
    %52 = affine.load %5[0] : memref<1xi32>
    %53 = arith.index_cast %51 : i32 to index
    %54 = arith.index_cast %52 : i32 to index
    affine.for %arg18 = 1 to %50 {
      affine.for %arg19 = 0 to %53 {
        affine.for %arg20 = 0 to %54 {
          %89 = affine.load %arg4[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %90 = affine.load %arg2[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %91 = affine.load %arg7[%arg20 + %arg19 * symbol(%54) + ((%arg18 - 1) * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %92 = arith.subf %cst_1, %91 : f32
          %93 = arith.mulf %90, %92 : f32
          %94 = arith.addf %89, %93 : f32
          %95 = arith.subf %94, %cst_1 : f32
          %96 = arith.divf %cst_1, %95 : f32
          affine.store %96, %arg8[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %97 = affine.load %arg4[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %98 = affine.load %arg8[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %99 = arith.mulf %97, %98 : f32
          affine.store %99, %arg7[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %100 = affine.load %arg2[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %101 = affine.load %arg8[%arg20 + %arg19 * symbol(%54) + ((%arg18 - 1) * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %102 = arith.mulf %100, %101 : f32
          %103 = affine.load %arg10[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %104 = arith.subf %102, %103 : f32
          %105 = affine.load %arg8[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
          %106 = arith.mulf %104, %105 : f32
          affine.store %106, %arg8[%arg20 + %arg19 * symbol(%54) + (%arg18 * symbol(%54)) * symbol(%53)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm2"}
    %55 = memref.get_global @jmm1 : memref<1xi32>
    %56 = affine.load %55[0] : memref<1xi32>
    %57 = arith.index_cast %56 : i32 to index
    %58 = memref.get_global @imm1 : memref<1xi32>
    %59 = affine.load %58[0] : memref<1xi32>
    %60 = affine.load %5[0] : memref<1xi32>
    %61 = affine.load %19[0] : memref<1xi32>
    %62 = affine.load %2[0] : memref<1xi32>
    %63 = affine.load %22[0] : memref<1xf32>
    %64 = arith.index_cast %59 : i32 to index
    %65 = arith.index_cast %60 : i32 to index
    %66 = arith.index_cast %61 : i32 to index
    %67 = arith.muli %66, %65 : index
    %68 = arith.index_cast %62 : i32 to index
    %69 = arith.muli %67, %68 : index
    %70 = arith.addi %66, %c-1 : index
    %71 = arith.muli %70, %65 : index
    %72 = arith.muli %71, %68 : index
    %73 = affine.load %arg5[symbol(%66)] : memref<?xf32>
    %74 = arith.negf %73 : f32
    affine.for %arg18 = 1 to %57 {
      affine.for %arg19 = 1 to %64 {
        %89 = affine.load %arg12[%arg19 + %arg18 * symbol(%65)] : memref<?xf32>
        %90 = affine.load %arg12[%arg19 + %arg18 * symbol(%65) - 1] : memref<?xf32>
        %91 = arith.addf %89, %90 : f32
        %92 = arith.mulf %91, %cst_0 : f32
        %93 = affine.load %arg13[%arg19 + %arg18 * symbol(%65) + symbol(%69)] : memref<?xf32>
        %94 = arith.mulf %93, %93 : f32
        %95 = affine.load %arg14[%arg19 + %arg18 * symbol(%65) + symbol(%69)] : memref<?xf32>
        %96 = affine.load %arg14[%arg19 + symbol(%69) + (%arg18 + 1) * symbol(%65)] : memref<?xf32>
        %97 = arith.addf %95, %96 : f32
        %98 = affine.load %arg14[%arg19 + %arg18 * symbol(%65) + symbol(%69) - 1] : memref<?xf32>
        %99 = arith.addf %97, %98 : f32
        %100 = affine.load %arg14[%arg19 + symbol(%69) + (%arg18 + 1) * symbol(%65) - 1] : memref<?xf32>
        %101 = arith.addf %99, %100 : f32
        %102 = arith.mulf %101, %cst : f32
        %103 = arith.mulf %102, %102 : f32
        %104 = arith.addf %94, %103 : f32
        %105 = math.sqrt %104 : f32
        %106 = arith.mulf %92, %105 : f32
        affine.store %106, %arg11[%arg19 + %arg18 * symbol(%65)] : memref<?xf32>
        %107 = affine.load %arg2[%arg19 + %arg18 * symbol(%65) + symbol(%69)] : memref<?xf32>
        %108 = affine.load %arg8[%arg19 + %arg18 * symbol(%65) + symbol(%72)] : memref<?xf32>
        %109 = arith.mulf %107, %108 : f32
        %110 = affine.load %arg10[%arg19 + %arg18 * symbol(%65) + symbol(%69)] : memref<?xf32>
        %111 = arith.subf %109, %110 : f32
        %112 = affine.load %arg11[%arg19 + %arg18 * symbol(%65)] : memref<?xf32>
        %113 = arith.mulf %112, %63 : f32
        %114 = affine.load %arg17[%arg19 + %arg18 * symbol(%65)] : memref<?xf32>
        %115 = arith.mulf %74, %114 : f32
        %116 = arith.divf %113, %115 : f32
        %117 = arith.subf %116, %cst_1 : f32
        %118 = affine.load %arg7[%arg19 + %arg18 * symbol(%65) + symbol(%72)] : memref<?xf32>
        %119 = arith.subf %118, %cst_1 : f32
        %120 = arith.mulf %119, %107 : f32
        %121 = arith.subf %117, %120 : f32
        %122 = arith.divf %111, %121 : f32
        affine.store %122, %arg10[%arg19 + %arg18 * symbol(%65) + symbol(%69)] : memref<?xf32>
        %123 = affine.load %arg10[%arg19 + %arg18 * symbol(%65) + symbol(%69)] : memref<?xf32>
        %124 = affine.load %arg15[%arg19 + %arg18 * symbol(%65)] : memref<?xf32>
        %125 = arith.mulf %123, %124 : f32
        affine.store %125, %arg10[%arg19 + %arg18 * symbol(%65) + symbol(%69)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %75 = affine.load %12[0] : memref<1xi32>
    %76 = arith.addi %75, %c-3_i32 : i32
    affine.store %76, %0[] : memref<i32>
    scf.while : () -> () {
      %89 = affine.load %0[] : memref<i32>
      %90 = arith.cmpi sge, %89, %c0_i32 : i32
      scf.condition(%90)
    } do {
      %89 = affine.load %55[0] : memref<1xi32>
      %90 = arith.index_cast %89 : i32 to index
      %91 = affine.load %58[0] : memref<1xi32>
      %92 = affine.load %5[0] : memref<1xi32>
      %93 = affine.load %0[] : memref<i32>
      %94 = affine.load %2[0] : memref<1xi32>
      %95 = arith.index_cast %91 : i32 to index
      %96 = arith.muli %93, %92 : i32
      %97 = arith.muli %96, %94 : i32
      %98 = arith.addi %93, %c1_i32 : i32
      %99 = arith.muli %98, %92 : i32
      %100 = arith.muli %99, %94 : i32
      %101 = arith.index_cast %92 : i32 to index
      scf.for %arg18 = %c1 to %90 step %c1 {
        %104 = arith.index_cast %arg18 : index to i32
        %105 = arith.muli %104, %92 : i32
        %106 = arith.muli %arg18, %101 : index
        scf.for %arg19 = %c1 to %95 step %c1 {
          %107 = arith.index_cast %arg19 : index to i32
          %108 = arith.addi %107, %105 : i32
          %109 = arith.addi %108, %97 : i32
          %110 = arith.index_cast %109 : i32 to index
          %111 = memref.load %arg7[%110] : memref<?xf32>
          %112 = arith.addi %108, %100 : i32
          %113 = arith.index_cast %112 : i32 to index
          %114 = memref.load %arg10[%113] : memref<?xf32>
          %115 = arith.mulf %111, %114 : f32
          %116 = memref.load %arg8[%110] : memref<?xf32>
          %117 = arith.addf %115, %116 : f32
          %118 = arith.addi %arg19, %106 : index
          %119 = memref.load %arg15[%118] : memref<?xf32>
          %120 = arith.mulf %117, %119 : f32
          memref.store %120, %arg10[%110] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %102 = affine.load %0[] : memref<i32>
      %103 = arith.addi %102, %c-1_i32 : i32
      affine.store %103, %0[] : memref<i32>
      scf.yield
    }
    %77 = affine.load %55[0] : memref<1xi32>
    %78 = arith.index_cast %77 : i32 to index
    %79 = affine.load %58[0] : memref<1xi32>
    %80 = affine.load %5[0] : memref<1xi32>
    %81 = affine.load %19[0] : memref<1xi32>
    %82 = affine.load %2[0] : memref<1xi32>
    %83 = arith.index_cast %79 : i32 to index
    %84 = arith.index_cast %80 : i32 to index
    %85 = arith.index_cast %81 : i32 to index
    %86 = arith.muli %85, %84 : index
    %87 = arith.index_cast %82 : i32 to index
    %88 = arith.muli %86, %87 : index
    affine.for %arg18 = 1 to %78 {
      affine.for %arg19 = 1 to %83 {
        %89 = affine.load %arg11[%arg19 + %arg18 * symbol(%84)] : memref<?xf32>
        %90 = arith.negf %89 : f32
        %91 = affine.load %arg10[%arg19 + %arg18 * symbol(%84) + symbol(%88)] : memref<?xf32>
        %92 = arith.mulf %90, %91 : f32
        affine.store %92, %arg16[%arg19 + %arg18 * symbol(%84)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    return
  }
}

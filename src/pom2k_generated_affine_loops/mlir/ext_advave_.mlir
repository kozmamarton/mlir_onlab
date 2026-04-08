module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @mode : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advave_(%arg0: memref<?xf32> {polygeist.name = "curv2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "aam2d", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c2 = arith.constant 2 : index
    %cst = arith.constant -5.000000e-01 : f32
    %c2_i32 = arith.constant 2 : i32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 2.000000e+00 : f32
    %cst_2 = arith.constant 1.250000e-01 : f32
    %cst_3 = arith.constant 0.000000e+00 : f32
    %c1 = arith.constant 1 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    affine.for %arg19 = 0 to %2 {
      affine.for %arg20 = 0 to %5 {
        affine.store %cst_3, %arg1[%arg20 + %arg19 * symbol(%5)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %6 = affine.load %0[0] : memref<1xi32>
    %7 = arith.index_cast %6 : i32 to index
    %8 = memref.get_global @imm1 : memref<1xi32>
    %9 = affine.load %8[0] : memref<1xi32>
    %10 = affine.load %3[0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    affine.for %arg19 = 1 to %7 {
      affine.for %arg20 = 1 to %11 {
        %63 = affine.load %arg11[%arg20 + %arg19 * symbol(%12) + 1] : memref<?xf32>
        %64 = affine.load %arg11[%arg20 + %arg19 * symbol(%12)] : memref<?xf32>
        %65 = arith.addf %63, %64 : f32
        %66 = affine.load %arg5[%arg20 + %arg19 * symbol(%12) + 1] : memref<?xf32>
        %67 = arith.mulf %65, %66 : f32
        %68 = affine.load %arg11[%arg20 + %arg19 * symbol(%12) - 1] : memref<?xf32>
        %69 = arith.addf %64, %68 : f32
        %70 = affine.load %arg5[%arg20 + %arg19 * symbol(%12)] : memref<?xf32>
        %71 = arith.mulf %69, %70 : f32
        %72 = arith.addf %67, %71 : f32
        %73 = arith.mulf %72, %cst_2 : f32
        %74 = arith.addf %66, %70 : f32
        %75 = arith.mulf %73, %74 : f32
        affine.store %75, %arg3[%arg20 + %arg19 * symbol(%12)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %13 = affine.load %0[0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = affine.load %3[0] : memref<1xi32>
    %16 = arith.index_cast %15 : i32 to index
    affine.for %arg19 = 1 to %14 {
      affine.for %arg20 = 1 to %16 {
        %63 = affine.load %arg11[%arg20 + %arg19 * symbol(%16)] : memref<?xf32>
        %64 = affine.load %arg11[%arg20 + (%arg19 - 1) * symbol(%16)] : memref<?xf32>
        %65 = arith.addf %63, %64 : f32
        %66 = affine.load %arg6[%arg20 + %arg19 * symbol(%16)] : memref<?xf32>
        %67 = arith.mulf %65, %66 : f32
        %68 = affine.load %arg11[%arg20 + %arg19 * symbol(%16) - 1] : memref<?xf32>
        %69 = affine.load %arg11[%arg20 + (%arg19 - 1) * symbol(%16) - 1] : memref<?xf32>
        %70 = arith.addf %68, %69 : f32
        %71 = affine.load %arg6[%arg20 + %arg19 * symbol(%16) - 1] : memref<?xf32>
        %72 = arith.mulf %70, %71 : f32
        %73 = arith.addf %67, %72 : f32
        %74 = arith.mulf %73, %cst_2 : f32
        %75 = affine.load %arg5[%arg20 + %arg19 * symbol(%16)] : memref<?xf32>
        %76 = affine.load %arg5[%arg20 + (%arg19 - 1) * symbol(%16)] : memref<?xf32>
        %77 = arith.addf %75, %76 : f32
        %78 = arith.mulf %74, %77 : f32
        affine.store %78, %arg4[%arg20 + %arg19 * symbol(%16)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %17 = affine.load %0[0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = affine.load %8[0] : memref<1xi32>
    %20 = affine.load %3[0] : memref<1xi32>
    %21 = arith.index_cast %19 : i32 to index
    %22 = arith.index_cast %20 : i32 to index
    affine.for %arg19 = 1 to %18 {
      affine.for %arg20 = 1 to %21 {
        %63 = affine.load %arg3[%arg20 + %arg19 * symbol(%22)] : memref<?xf32>
        %64 = affine.load %arg11[%arg20 + %arg19 * symbol(%22)] : memref<?xf32>
        %65 = arith.mulf %64, %cst_1 : f32
        %66 = affine.load %arg16[%arg20 + %arg19 * symbol(%22)] : memref<?xf32>
        %67 = arith.mulf %65, %66 : f32
        %68 = affine.load %arg7[%arg20 + %arg19 * symbol(%22) + 1] : memref<?xf32>
        %69 = affine.load %arg7[%arg20 + %arg19 * symbol(%22)] : memref<?xf32>
        %70 = arith.subf %68, %69 : f32
        %71 = arith.mulf %67, %70 : f32
        %72 = affine.load %arg12[%arg20 + %arg19 * symbol(%22)] : memref<?xf32>
        %73 = arith.divf %71, %72 : f32
        %74 = arith.subf %63, %73 : f32
        affine.store %74, %arg3[%arg20 + %arg19 * symbol(%22)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %23 = affine.load %0[0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = affine.load %3[0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    affine.for %arg19 = 1 to %24 {
      affine.for %arg20 = 1 to %26 {
        %63 = affine.load %arg11[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %64 = affine.load %arg11[%arg20 + %arg19 * symbol(%26) - 1] : memref<?xf32>
        %65 = arith.addf %63, %64 : f32
        %66 = affine.load %arg11[%arg20 + (%arg19 - 1) * symbol(%26)] : memref<?xf32>
        %67 = arith.addf %65, %66 : f32
        %68 = affine.load %arg11[%arg20 + (%arg19 - 1) * symbol(%26) - 1] : memref<?xf32>
        %69 = arith.addf %67, %68 : f32
        %70 = arith.mulf %69, %cst_0 : f32
        %71 = affine.load %arg16[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %72 = affine.load %arg16[%arg20 + (%arg19 - 1) * symbol(%26)] : memref<?xf32>
        %73 = arith.addf %71, %72 : f32
        %74 = affine.load %arg16[%arg20 + %arg19 * symbol(%26) - 1] : memref<?xf32>
        %75 = arith.addf %73, %74 : f32
        %76 = affine.load %arg16[%arg20 + (%arg19 - 1) * symbol(%26) - 1] : memref<?xf32>
        %77 = arith.addf %75, %76 : f32
        %78 = arith.mulf %70, %77 : f32
        %79 = affine.load %arg7[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %80 = affine.load %arg7[%arg20 + (%arg19 - 1) * symbol(%26)] : memref<?xf32>
        %81 = arith.subf %79, %80 : f32
        %82 = affine.load %arg13[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %83 = affine.load %arg13[%arg20 + %arg19 * symbol(%26) - 1] : memref<?xf32>
        %84 = arith.addf %82, %83 : f32
        %85 = affine.load %arg13[%arg20 + (%arg19 - 1) * symbol(%26)] : memref<?xf32>
        %86 = arith.addf %84, %85 : f32
        %87 = affine.load %arg13[%arg20 + (%arg19 - 1) * symbol(%26) - 1] : memref<?xf32>
        %88 = arith.addf %86, %87 : f32
        %89 = arith.divf %81, %88 : f32
        %90 = affine.load %arg8[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %91 = affine.load %arg8[%arg20 + %arg19 * symbol(%26) - 1] : memref<?xf32>
        %92 = arith.subf %90, %91 : f32
        %93 = affine.load %arg12[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %94 = affine.load %arg12[%arg20 + %arg19 * symbol(%26) - 1] : memref<?xf32>
        %95 = arith.addf %93, %94 : f32
        %96 = affine.load %arg12[%arg20 + (%arg19 - 1) * symbol(%26)] : memref<?xf32>
        %97 = arith.addf %95, %96 : f32
        %98 = affine.load %arg12[%arg20 + (%arg19 - 1) * symbol(%26) - 1] : memref<?xf32>
        %99 = arith.addf %97, %98 : f32
        %100 = arith.divf %92, %99 : f32
        %101 = arith.addf %89, %100 : f32
        %102 = arith.mulf %78, %101 : f32
        affine.store %102, %arg17[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %103 = affine.load %arg3[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %104 = affine.load %arg13[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %105 = arith.mulf %103, %104 : f32
        affine.store %105, %arg3[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %106 = affine.load %arg4[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %107 = affine.load %arg17[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %108 = arith.subf %106, %107 : f32
        %109 = arith.mulf %108, %cst_0 : f32
        %110 = affine.load %arg12[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
        %111 = affine.load %arg12[%arg20 + %arg19 * symbol(%26) - 1] : memref<?xf32>
        %112 = arith.addf %110, %111 : f32
        %113 = affine.load %arg12[%arg20 + (%arg19 - 1) * symbol(%26)] : memref<?xf32>
        %114 = arith.addf %112, %113 : f32
        %115 = affine.load %arg12[%arg20 + (%arg19 - 1) * symbol(%26) - 1] : memref<?xf32>
        %116 = arith.addf %114, %115 : f32
        %117 = arith.mulf %109, %116 : f32
        affine.store %117, %arg4[%arg20 + %arg19 * symbol(%26)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %27 = memref.get_global @jmm1 : memref<1xi32>
    %28 = affine.load %27[0] : memref<1xi32>
    %29 = arith.index_cast %28 : i32 to index
    %30 = affine.load %8[0] : memref<1xi32>
    %31 = affine.load %3[0] : memref<1xi32>
    %32 = arith.index_cast %30 : i32 to index
    %33 = arith.index_cast %31 : i32 to index
    affine.for %arg19 = 1 to %29 {
      affine.for %arg20 = 1 to %32 {
        %63 = affine.load %arg3[%arg20 + %arg19 * symbol(%33)] : memref<?xf32>
        %64 = affine.load %arg3[%arg20 + %arg19 * symbol(%33) - 1] : memref<?xf32>
        %65 = arith.subf %63, %64 : f32
        %66 = affine.load %arg4[%arg20 + (%arg19 + 1) * symbol(%33)] : memref<?xf32>
        %67 = arith.addf %65, %66 : f32
        %68 = affine.load %arg4[%arg20 + %arg19 * symbol(%33)] : memref<?xf32>
        %69 = arith.subf %67, %68 : f32
        affine.store %69, %arg1[%arg20 + %arg19 * symbol(%33)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %34 = affine.load %0[0] : memref<1xi32>
    %35 = arith.index_cast %34 : i32 to index
    %36 = affine.load %3[0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    affine.for %arg19 = 0 to %35 {
      affine.for %arg20 = 0 to %37 {
        affine.store %cst_3, %arg2[%arg20 + %arg19 * symbol(%37)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %38 = affine.load %0[0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = affine.load %3[0] : memref<1xi32>
    %41 = arith.index_cast %40 : i32 to index
    affine.for %arg19 = 1 to %39 {
      affine.for %arg20 = 1 to %41 {
        %63 = affine.load %arg11[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
        %64 = affine.load %arg11[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
        %65 = arith.addf %63, %64 : f32
        %66 = affine.load %arg5[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
        %67 = arith.mulf %65, %66 : f32
        %68 = affine.load %arg11[%arg20 + (%arg19 - 1) * symbol(%41)] : memref<?xf32>
        %69 = affine.load %arg11[%arg20 + (%arg19 - 1) * symbol(%41) - 1] : memref<?xf32>
        %70 = arith.addf %68, %69 : f32
        %71 = affine.load %arg5[%arg20 + (%arg19 - 1) * symbol(%41)] : memref<?xf32>
        %72 = arith.mulf %70, %71 : f32
        %73 = arith.addf %67, %72 : f32
        %74 = arith.mulf %73, %cst_2 : f32
        %75 = affine.load %arg6[%arg20 + %arg19 * symbol(%41) - 1] : memref<?xf32>
        %76 = affine.load %arg6[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
        %77 = arith.addf %75, %76 : f32
        %78 = arith.mulf %74, %77 : f32
        affine.store %78, %arg3[%arg20 + %arg19 * symbol(%41)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %42 = affine.load %27[0] : memref<1xi32>
    %43 = arith.index_cast %42 : i32 to index
    %44 = affine.load %3[0] : memref<1xi32>
    %45 = arith.index_cast %44 : i32 to index
    affine.for %arg19 = 1 to %43 {
      affine.for %arg20 = 1 to %45 {
        %63 = affine.load %arg11[%arg20 + (%arg19 + 1) * symbol(%45)] : memref<?xf32>
        %64 = affine.load %arg11[%arg20 + %arg19 * symbol(%45)] : memref<?xf32>
        %65 = arith.addf %63, %64 : f32
        %66 = affine.load %arg6[%arg20 + (%arg19 + 1) * symbol(%45)] : memref<?xf32>
        %67 = arith.mulf %65, %66 : f32
        %68 = affine.load %arg11[%arg20 + (%arg19 - 1) * symbol(%45)] : memref<?xf32>
        %69 = arith.addf %64, %68 : f32
        %70 = affine.load %arg6[%arg20 + %arg19 * symbol(%45)] : memref<?xf32>
        %71 = arith.mulf %69, %70 : f32
        %72 = arith.addf %67, %71 : f32
        %73 = arith.mulf %72, %cst_2 : f32
        %74 = arith.addf %66, %70 : f32
        %75 = arith.mulf %73, %74 : f32
        affine.store %75, %arg4[%arg20 + %arg19 * symbol(%45)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %46 = affine.load %27[0] : memref<1xi32>
    %47 = arith.index_cast %46 : i32 to index
    %48 = affine.load %3[0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    affine.for %arg19 = 1 to %47 {
      affine.for %arg20 = 1 to %49 {
        %63 = affine.load %arg4[%arg20 + %arg19 * symbol(%49)] : memref<?xf32>
        %64 = affine.load %arg11[%arg20 + %arg19 * symbol(%49)] : memref<?xf32>
        %65 = arith.mulf %64, %cst_1 : f32
        %66 = affine.load %arg16[%arg20 + %arg19 * symbol(%49)] : memref<?xf32>
        %67 = arith.mulf %65, %66 : f32
        %68 = affine.load %arg8[%arg20 + (%arg19 + 1) * symbol(%49)] : memref<?xf32>
        %69 = affine.load %arg8[%arg20 + %arg19 * symbol(%49)] : memref<?xf32>
        %70 = arith.subf %68, %69 : f32
        %71 = arith.mulf %67, %70 : f32
        %72 = affine.load %arg13[%arg20 + %arg19 * symbol(%49)] : memref<?xf32>
        %73 = arith.divf %71, %72 : f32
        %74 = arith.subf %63, %73 : f32
        affine.store %74, %arg4[%arg20 + %arg19 * symbol(%49)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %50 = affine.load %0[0] : memref<1xi32>
    %51 = arith.index_cast %50 : i32 to index
    %52 = affine.load %3[0] : memref<1xi32>
    %53 = arith.index_cast %52 : i32 to index
    affine.for %arg19 = 1 to %51 {
      affine.for %arg20 = 1 to %53 {
        %63 = affine.load %arg4[%arg20 + %arg19 * symbol(%53)] : memref<?xf32>
        %64 = affine.load %arg12[%arg20 + %arg19 * symbol(%53)] : memref<?xf32>
        %65 = arith.mulf %63, %64 : f32
        affine.store %65, %arg4[%arg20 + %arg19 * symbol(%53)] : memref<?xf32>
        %66 = affine.load %arg3[%arg20 + %arg19 * symbol(%53)] : memref<?xf32>
        %67 = affine.load %arg17[%arg20 + %arg19 * symbol(%53)] : memref<?xf32>
        %68 = arith.subf %66, %67 : f32
        %69 = arith.mulf %68, %cst_0 : f32
        %70 = affine.load %arg13[%arg20 + %arg19 * symbol(%53)] : memref<?xf32>
        %71 = affine.load %arg13[%arg20 + %arg19 * symbol(%53) - 1] : memref<?xf32>
        %72 = arith.addf %70, %71 : f32
        %73 = affine.load %arg13[%arg20 + (%arg19 - 1) * symbol(%53)] : memref<?xf32>
        %74 = arith.addf %72, %73 : f32
        %75 = affine.load %arg13[%arg20 + (%arg19 - 1) * symbol(%53) - 1] : memref<?xf32>
        %76 = arith.addf %74, %75 : f32
        %77 = arith.mulf %69, %76 : f32
        affine.store %77, %arg3[%arg20 + %arg19 * symbol(%53)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %54 = affine.load %27[0] : memref<1xi32>
    %55 = arith.index_cast %54 : i32 to index
    %56 = affine.load %8[0] : memref<1xi32>
    %57 = affine.load %3[0] : memref<1xi32>
    %58 = arith.index_cast %56 : i32 to index
    %59 = arith.index_cast %57 : i32 to index
    affine.for %arg19 = 1 to %55 {
      affine.for %arg20 = 1 to %58 {
        %63 = affine.load %arg3[%arg20 + %arg19 * symbol(%59) + 1] : memref<?xf32>
        %64 = affine.load %arg3[%arg20 + %arg19 * symbol(%59)] : memref<?xf32>
        %65 = arith.subf %63, %64 : f32
        %66 = affine.load %arg4[%arg20 + %arg19 * symbol(%59)] : memref<?xf32>
        %67 = arith.addf %65, %66 : f32
        %68 = affine.load %arg4[%arg20 + (%arg19 - 1) * symbol(%59)] : memref<?xf32>
        %69 = arith.subf %67, %68 : f32
        affine.store %69, %arg2[%arg20 + %arg19 * symbol(%59)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %60 = memref.get_global @mode : memref<1xi32>
    %61 = affine.load %60[0] : memref<1xi32>
    %62 = arith.cmpi eq, %61, %c2_i32 : i32
    scf.if %62 {
      %63 = affine.load %27[0] : memref<1xi32>
      %64 = arith.index_cast %63 : i32 to index
      %65 = affine.load %8[0] : memref<1xi32>
      %66 = affine.load %3[0] : memref<1xi32>
      %67 = arith.index_cast %65 : i32 to index
      %68 = arith.index_cast %66 : i32 to index
      scf.for %arg19 = %c1 to %64 step %c1 {
        %93 = arith.muli %arg19, %68 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %68 : index
        scf.for %arg20 = %c1 to %67 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg18[%96] : memref<?xf32>
          %98 = arith.addi %arg20, %c-1 : index
          %99 = arith.addi %98, %93 : index
          %100 = memref.load %arg18[%99] : memref<?xf32>
          %101 = arith.addf %97, %100 : f32
          %102 = arith.mulf %101, %cst : f32
          %103 = memref.load %arg7[%96] : memref<?xf32>
          %104 = arith.mulf %103, %103 : f32
          %105 = memref.load %arg8[%96] : memref<?xf32>
          %106 = arith.addi %arg20, %95 : index
          %107 = memref.load %arg8[%106] : memref<?xf32>
          %108 = arith.addf %105, %107 : f32
          %109 = memref.load %arg8[%99] : memref<?xf32>
          %110 = arith.addf %108, %109 : f32
          %111 = arith.addi %98, %95 : index
          %112 = memref.load %arg8[%111] : memref<?xf32>
          %113 = arith.addf %110, %112 : f32
          %114 = arith.mulf %113, %cst_0 : f32
          %115 = arith.mulf %114, %114 : f32
          %116 = arith.addf %104, %115 : f32
          %117 = math.sqrt %116 : f32
          %118 = arith.mulf %102, %117 : f32
          %119 = arith.mulf %118, %103 : f32
          memref.store %119, %arg9[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %69 = affine.load %27[0] : memref<1xi32>
      %70 = arith.index_cast %69 : i32 to index
      %71 = affine.load %8[0] : memref<1xi32>
      %72 = affine.load %3[0] : memref<1xi32>
      %73 = arith.index_cast %71 : i32 to index
      %74 = arith.index_cast %72 : i32 to index
      scf.for %arg19 = %c1 to %70 step %c1 {
        %93 = arith.muli %arg19, %74 : index
        %94 = arith.addi %arg19, %c-1 : index
        %95 = arith.muli %94, %74 : index
        scf.for %arg20 = %c1 to %73 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg18[%96] : memref<?xf32>
          %98 = arith.addi %arg20, %95 : index
          %99 = memref.load %arg18[%98] : memref<?xf32>
          %100 = arith.addf %97, %99 : f32
          %101 = arith.mulf %100, %cst : f32
          %102 = memref.load %arg8[%96] : memref<?xf32>
          %103 = arith.mulf %102, %102 : f32
          %104 = memref.load %arg7[%96] : memref<?xf32>
          %105 = arith.addi %arg20, %c1 : index
          %106 = arith.addi %105, %93 : index
          %107 = memref.load %arg7[%106] : memref<?xf32>
          %108 = arith.addf %104, %107 : f32
          %109 = memref.load %arg7[%98] : memref<?xf32>
          %110 = arith.addf %108, %109 : f32
          %111 = arith.addi %105, %95 : index
          %112 = memref.load %arg7[%111] : memref<?xf32>
          %113 = arith.addf %110, %112 : f32
          %114 = arith.mulf %113, %cst_0 : f32
          %115 = arith.mulf %114, %114 : f32
          %116 = arith.addf %103, %115 : f32
          %117 = math.sqrt %116 : f32
          %118 = arith.mulf %101, %117 : f32
          %119 = arith.mulf %118, %102 : f32
          memref.store %119, %arg10[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %75 = affine.load %27[0] : memref<1xi32>
      %76 = arith.index_cast %75 : i32 to index
      %77 = affine.load %8[0] : memref<1xi32>
      %78 = affine.load %3[0] : memref<1xi32>
      %79 = arith.index_cast %77 : i32 to index
      %80 = arith.index_cast %78 : i32 to index
      scf.for %arg19 = %c1 to %76 step %c1 {
        %93 = arith.muli %arg19, %80 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %80 : index
        %96 = arith.addi %arg19, %c-1 : index
        %97 = arith.muli %96, %80 : index
        scf.for %arg20 = %c1 to %79 step %c1 {
          %98 = arith.addi %arg20, %93 : index
          %99 = arith.addi %arg20, %95 : index
          %100 = memref.load %arg6[%99] : memref<?xf32>
          %101 = memref.load %arg6[%98] : memref<?xf32>
          %102 = arith.addf %100, %101 : f32
          %103 = arith.addi %arg20, %c1 : index
          %104 = arith.addi %103, %93 : index
          %105 = memref.load %arg13[%104] : memref<?xf32>
          %106 = arith.addi %arg20, %c-1 : index
          %107 = arith.addi %106, %93 : index
          %108 = memref.load %arg13[%107] : memref<?xf32>
          %109 = arith.subf %105, %108 : f32
          %110 = arith.mulf %102, %109 : f32
          %111 = memref.load %arg5[%104] : memref<?xf32>
          %112 = memref.load %arg5[%98] : memref<?xf32>
          %113 = arith.addf %111, %112 : f32
          %114 = memref.load %arg12[%99] : memref<?xf32>
          %115 = arith.addi %arg20, %97 : index
          %116 = memref.load %arg12[%115] : memref<?xf32>
          %117 = arith.subf %114, %116 : f32
          %118 = arith.mulf %113, %117 : f32
          %119 = arith.subf %110, %118 : f32
          %120 = arith.mulf %119, %cst_0 : f32
          %121 = memref.load %arg12[%98] : memref<?xf32>
          %122 = memref.load %arg13[%98] : memref<?xf32>
          %123 = arith.mulf %121, %122 : f32
          %124 = arith.divf %120, %123 : f32
          memref.store %124, %arg0[%98] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %81 = affine.load %27[0] : memref<1xi32>
      %82 = arith.index_cast %81 : i32 to index
      %83 = affine.load %8[0] : memref<1xi32>
      %84 = affine.load %3[0] : memref<1xi32>
      %85 = arith.index_cast %83 : i32 to index
      %86 = arith.index_cast %84 : i32 to index
      scf.for %arg19 = %c1 to %82 step %c1 {
        %93 = arith.muli %arg19, %86 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %86 : index
        scf.for %arg20 = %c2 to %85 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg1[%96] : memref<?xf32>
          %98 = memref.load %arg14[%96] : memref<?xf32>
          %99 = arith.mulf %98, %cst_0 : f32
          %100 = memref.load %arg0[%96] : memref<?xf32>
          %101 = memref.load %arg11[%96] : memref<?xf32>
          %102 = arith.mulf %100, %101 : f32
          %103 = arith.addi %arg20, %95 : index
          %104 = memref.load %arg6[%103] : memref<?xf32>
          %105 = memref.load %arg6[%96] : memref<?xf32>
          %106 = arith.addf %104, %105 : f32
          %107 = arith.mulf %102, %106 : f32
          %108 = arith.addi %arg20, %c-1 : index
          %109 = arith.addi %108, %93 : index
          %110 = memref.load %arg0[%109] : memref<?xf32>
          %111 = memref.load %arg11[%109] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %108, %95 : index
          %114 = memref.load %arg6[%113] : memref<?xf32>
          %115 = memref.load %arg6[%109] : memref<?xf32>
          %116 = arith.addf %114, %115 : f32
          %117 = arith.mulf %112, %116 : f32
          %118 = arith.addf %107, %117 : f32
          %119 = arith.mulf %99, %118 : f32
          %120 = arith.subf %97, %119 : f32
          memref.store %120, %arg1[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %87 = affine.load %27[0] : memref<1xi32>
      %88 = arith.index_cast %87 : i32 to index
      %89 = affine.load %8[0] : memref<1xi32>
      %90 = affine.load %3[0] : memref<1xi32>
      %91 = arith.index_cast %89 : i32 to index
      %92 = arith.index_cast %90 : i32 to index
      scf.for %arg19 = %c2 to %88 step %c1 {
        %93 = arith.muli %arg19, %92 : index
        %94 = arith.addi %arg19, %c-1 : index
        %95 = arith.muli %94, %92 : index
        scf.for %arg20 = %c1 to %91 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg2[%96] : memref<?xf32>
          %98 = memref.load %arg15[%96] : memref<?xf32>
          %99 = arith.mulf %98, %cst_0 : f32
          %100 = memref.load %arg0[%96] : memref<?xf32>
          %101 = memref.load %arg11[%96] : memref<?xf32>
          %102 = arith.mulf %100, %101 : f32
          %103 = arith.addi %arg20, %c1 : index
          %104 = arith.addi %103, %93 : index
          %105 = memref.load %arg5[%104] : memref<?xf32>
          %106 = memref.load %arg5[%96] : memref<?xf32>
          %107 = arith.addf %105, %106 : f32
          %108 = arith.mulf %102, %107 : f32
          %109 = arith.addi %arg20, %95 : index
          %110 = memref.load %arg0[%109] : memref<?xf32>
          %111 = memref.load %arg11[%109] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %103, %95 : index
          %114 = memref.load %arg5[%113] : memref<?xf32>
          %115 = memref.load %arg5[%109] : memref<?xf32>
          %116 = arith.addf %114, %115 : f32
          %117 = arith.mulf %112, %116 : f32
          %118 = arith.addf %108, %117 : f32
          %119 = arith.mulf %99, %118 : f32
          %120 = arith.addf %97, %119 : f32
          memref.store %120, %arg2[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    }
    return
  }
}

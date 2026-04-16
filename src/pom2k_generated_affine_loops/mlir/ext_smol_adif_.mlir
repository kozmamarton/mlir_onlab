module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @dti2 : memref<1xf32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_smol_adif_(%arg0: memref<?xf32> {polygeist.name = "xmassflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ymassflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "zwflux", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "sw", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %true = arith.constant true
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %cst_1 = arith.constant 9.99999982E-15 : f32
    %cst_2 = arith.constant 9.99999971E-10 : f32
    %0 = memref.alloca() : memref<f32>
    %1 = llvm.mlir.undef : f32
    affine.store %1, %0[] : memref<f32>
    %2 = memref.alloca() : memref<f32>
    affine.store %1, %2[] : memref<f32>
    %3 = memref.alloca() : memref<f32>
    affine.store %1, %3[] : memref<f32>
    %4 = memref.alloca() : memref<f32>
    affine.store %1, %4[] : memref<f32>
    %5 = memref.alloca() : memref<f32>
    affine.store %1, %5[] : memref<f32>
    %6 = memref.alloca() : memref<f32>
    affine.store %1, %6[] : memref<f32>
    %7 = memref.alloca() : memref<f32>
    affine.store %1, %7[] : memref<f32>
    %8 = memref.alloca() : memref<f32>
    affine.store %1, %8[] : memref<f32>
    %9 = memref.alloca() : memref<f32>
    affine.store %1, %9[] : memref<f32>
    %10 = memref.get_global @kb : memref<1xi32>
    %11 = affine.load %10[0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @jm : memref<1xi32>
    %14 = memref.get_global @im : memref<1xi32>
    %15 = affine.load %13[0] : memref<1xi32>
    %16 = affine.load %14[0] : memref<1xi32>
    %17 = arith.index_cast %15 : i32 to index
    %18 = arith.index_cast %16 : i32 to index
    affine.for %arg10 = 0 to %12 {
      affine.for %arg11 = 0 to %17 {
        affine.for %arg12 = 0 to %18 {
          %51 = affine.load %arg5[%arg12 + %arg11 * symbol(%18)] : memref<?xf32>
          %52 = affine.load %arg3[%arg12 + %arg11 * symbol(%18) + (%arg10 * symbol(%18)) * symbol(%17)] : memref<?xf32>
          %53 = arith.mulf %52, %51 : f32
          affine.store %53, %arg3[%arg12 + %arg11 * symbol(%18) + (%arg10 * symbol(%18)) * symbol(%17)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %19 = memref.get_global @kbm1 : memref<1xi32>
    %20 = affine.load %19[0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.get_global @jmm1 : memref<1xi32>
    %23 = affine.load %22[0] : memref<1xi32>
    %24 = affine.load %14[0] : memref<1xi32>
    %25 = affine.load %13[0] : memref<1xi32>
    %26 = affine.load %arg4[0] : memref<?xf32>
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.index_cast %25 : i32 to index
    affine.for %arg10 = 0 to %21 {
      affine.for %arg11 = 1 to %27 {
        affine.for %arg12 = 1 to %28 {
          %51 = affine.load %arg3[%arg12 + %arg11 * symbol(%28) + (%arg10 * symbol(%28)) * symbol(%29)] : memref<?xf32>
          %52 = arith.cmpf olt, %51, %cst_2 : f32
          %53 = scf.if %52 -> (i1) {
            scf.yield %true : i1
          } else {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.addi %arg12, %c-1 : index
            %57 = arith.index_cast %54 : i32 to index
            %58 = arith.muli %arg11, %57 : index
            %59 = arith.addi %56, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %55 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg3[%63] : memref<?xf32>
            %65 = arith.cmpf olt, %64, %cst_2 : f32
            scf.yield %65 : i1
          }
          scf.if %53 {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.index_cast %54 : i32 to index
            %57 = arith.muli %arg11, %56 : index
            %58 = arith.addi %arg12, %57 : index
            %59 = arith.muli %arg10, %56 : index
            %60 = arith.index_cast %55 : i32 to index
            %61 = arith.muli %59, %60 : index
            %62 = arith.addi %58, %61 : index
            memref.store %cst_0, %arg0[%62] : memref<?xf32>
          } else {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.index_cast %54 : i32 to index
            %57 = arith.muli %arg11, %56 : index
            %58 = arith.addi %arg12, %57 : index
            %59 = arith.muli %arg10, %56 : index
            %60 = arith.index_cast %55 : i32 to index
            %61 = arith.muli %59, %60 : index
            %62 = arith.addi %58, %61 : index
            %63 = memref.load %arg0[%62] : memref<?xf32>
            %64 = arith.extf %63 : f32 to f64
            %65 = math.absf %64 : f64
            %66 = arith.truncf %65 : f64 to f32
            affine.store %66, %9[] : memref<f32>
            %67 = memref.get_global @dti2 : memref<1xf32>
            %68 = affine.load %67[0] : memref<1xf32>
            %69 = affine.load %14[0] : memref<1xi32>
            %70 = affine.load %13[0] : memref<1xi32>
            %71 = arith.index_cast %69 : i32 to index
            %72 = arith.muli %arg11, %71 : index
            %73 = arith.addi %arg12, %72 : index
            %74 = arith.muli %arg10, %71 : index
            %75 = arith.index_cast %70 : i32 to index
            %76 = arith.muli %74, %75 : index
            %77 = arith.addi %73, %76 : index
            %78 = memref.load %arg0[%77] : memref<?xf32>
            %79 = arith.mulf %68, %78 : f32
            %80 = arith.mulf %79, %78 : f32
            %81 = arith.mulf %80, %cst : f32
            %82 = memref.load %arg6[%73] : memref<?xf32>
            %83 = arith.addi %arg12, %c-1 : index
            %84 = arith.addi %83, %72 : index
            %85 = memref.load %arg8[%84] : memref<?xf32>
            %86 = memref.load %arg8[%73] : memref<?xf32>
            %87 = arith.addf %85, %86 : f32
            %88 = arith.mulf %82, %87 : f32
            %89 = arith.divf %81, %88 : f32
            affine.store %89, %8[] : memref<f32>
            %90 = affine.load %14[0] : memref<1xi32>
            %91 = affine.load %13[0] : memref<1xi32>
            %92 = arith.index_cast %90 : i32 to index
            %93 = arith.muli %arg11, %92 : index
            %94 = arith.addi %arg12, %93 : index
            %95 = arith.muli %arg10, %92 : index
            %96 = arith.index_cast %91 : i32 to index
            %97 = arith.muli %95, %96 : index
            %98 = arith.addi %94, %97 : index
            %99 = memref.load %arg3[%98] : memref<?xf32>
            %100 = arith.addi %83, %93 : index
            %101 = arith.addi %100, %97 : index
            %102 = memref.load %arg3[%101] : memref<?xf32>
            %103 = arith.subf %99, %102 : f32
            %104 = arith.addf %102, %99 : f32
            %105 = arith.addf %104, %cst_1 : f32
            %106 = arith.divf %103, %105 : f32
            affine.store %106, %7[] : memref<f32>
            %107 = affine.load %14[0] : memref<1xi32>
            %108 = affine.load %13[0] : memref<1xi32>
            %109 = arith.index_cast %107 : i32 to index
            %110 = arith.muli %arg11, %109 : index
            %111 = arith.addi %arg12, %110 : index
            %112 = arith.muli %arg10, %109 : index
            %113 = arith.index_cast %108 : i32 to index
            %114 = arith.muli %112, %113 : index
            %115 = arith.addi %111, %114 : index
            %116 = affine.load %9[] : memref<f32>
            %117 = affine.load %8[] : memref<f32>
            %118 = arith.subf %116, %117 : f32
            %119 = affine.load %7[] : memref<f32>
            %120 = arith.mulf %118, %119 : f32
            %121 = arith.mulf %120, %26 : f32
            memref.store %121, %arg0[%115] : memref<?xf32>
            %122 = affine.load %9[] : memref<f32>
            %123 = arith.extf %122 : f32 to f64
            %124 = math.absf %123 : f64
            %125 = affine.load %8[] : memref<f32>
            %126 = arith.extf %125 : f32 to f64
            %127 = math.absf %126 : f64
            %128 = arith.cmpf olt, %124, %127 : f64
            scf.if %128 {
              %129 = affine.load %14[0] : memref<1xi32>
              %130 = affine.load %13[0] : memref<1xi32>
              %131 = arith.index_cast %129 : i32 to index
              %132 = arith.muli %arg11, %131 : index
              %133 = arith.addi %arg12, %132 : index
              %134 = arith.muli %arg10, %131 : index
              %135 = arith.index_cast %130 : i32 to index
              %136 = arith.muli %134, %135 : index
              %137 = arith.addi %133, %136 : index
              memref.store %cst_0, %arg0[%137] : memref<?xf32>
            }
          }
        } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "u2dt", non_scalar = false, type = "f32"}, {name = "udx", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "u2dt", non_scalar = false, type = "f32"}, {name = "udx", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "u2dt", non_scalar = false, type = "f32"}, {name = "udx", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %30 = affine.load %19[0] : memref<1xi32>
    %31 = arith.index_cast %30 : i32 to index
    %32 = memref.get_global @imm1 : memref<1xi32>
    %33 = affine.load %13[0] : memref<1xi32>
    %34 = affine.load %32[0] : memref<1xi32>
    %35 = affine.load %14[0] : memref<1xi32>
    %36 = affine.load %arg4[0] : memref<?xf32>
    %37 = arith.index_cast %33 : i32 to index
    %38 = arith.index_cast %34 : i32 to index
    %39 = arith.index_cast %35 : i32 to index
    affine.for %arg10 = 0 to %31 {
      affine.for %arg11 = 1 to %37 {
        affine.for %arg12 = 1 to %38 {
          %51 = affine.load %arg3[%arg12 + %arg11 * symbol(%39) + (%arg10 * symbol(%39)) * symbol(%37)] : memref<?xf32>
          %52 = arith.cmpf olt, %51, %cst_2 : f32
          %53 = scf.if %52 -> (i1) {
            scf.yield %true : i1
          } else {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.addi %arg11, %c-1 : index
            %57 = arith.index_cast %54 : i32 to index
            %58 = arith.muli %56, %57 : index
            %59 = arith.addi %arg12, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %55 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg3[%63] : memref<?xf32>
            %65 = arith.cmpf olt, %64, %cst_2 : f32
            scf.yield %65 : i1
          }
          scf.if %53 {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.index_cast %54 : i32 to index
            %57 = arith.muli %arg11, %56 : index
            %58 = arith.addi %arg12, %57 : index
            %59 = arith.muli %arg10, %56 : index
            %60 = arith.index_cast %55 : i32 to index
            %61 = arith.muli %59, %60 : index
            %62 = arith.addi %58, %61 : index
            memref.store %cst_0, %arg1[%62] : memref<?xf32>
          } else {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.index_cast %54 : i32 to index
            %57 = arith.muli %arg11, %56 : index
            %58 = arith.addi %arg12, %57 : index
            %59 = arith.muli %arg10, %56 : index
            %60 = arith.index_cast %55 : i32 to index
            %61 = arith.muli %59, %60 : index
            %62 = arith.addi %58, %61 : index
            %63 = memref.load %arg1[%62] : memref<?xf32>
            %64 = arith.extf %63 : f32 to f64
            %65 = math.absf %64 : f64
            %66 = arith.truncf %65 : f64 to f32
            affine.store %66, %6[] : memref<f32>
            %67 = memref.get_global @dti2 : memref<1xf32>
            %68 = affine.load %67[0] : memref<1xf32>
            %69 = affine.load %14[0] : memref<1xi32>
            %70 = affine.load %13[0] : memref<1xi32>
            %71 = arith.index_cast %69 : i32 to index
            %72 = arith.muli %arg11, %71 : index
            %73 = arith.addi %arg12, %72 : index
            %74 = arith.muli %arg10, %71 : index
            %75 = arith.index_cast %70 : i32 to index
            %76 = arith.muli %74, %75 : index
            %77 = arith.addi %73, %76 : index
            %78 = memref.load %arg1[%77] : memref<?xf32>
            %79 = arith.mulf %68, %78 : f32
            %80 = arith.mulf %79, %78 : f32
            %81 = arith.mulf %80, %cst : f32
            %82 = memref.load %arg7[%73] : memref<?xf32>
            %83 = arith.addi %arg11, %c-1 : index
            %84 = arith.muli %83, %71 : index
            %85 = arith.addi %arg12, %84 : index
            %86 = memref.load %arg8[%85] : memref<?xf32>
            %87 = memref.load %arg8[%73] : memref<?xf32>
            %88 = arith.addf %86, %87 : f32
            %89 = arith.mulf %82, %88 : f32
            %90 = arith.divf %81, %89 : f32
            affine.store %90, %5[] : memref<f32>
            %91 = affine.load %14[0] : memref<1xi32>
            %92 = affine.load %13[0] : memref<1xi32>
            %93 = arith.index_cast %91 : i32 to index
            %94 = arith.muli %arg11, %93 : index
            %95 = arith.addi %arg12, %94 : index
            %96 = arith.muli %arg10, %93 : index
            %97 = arith.index_cast %92 : i32 to index
            %98 = arith.muli %96, %97 : index
            %99 = arith.addi %95, %98 : index
            %100 = memref.load %arg3[%99] : memref<?xf32>
            %101 = arith.muli %83, %93 : index
            %102 = arith.addi %arg12, %101 : index
            %103 = arith.addi %102, %98 : index
            %104 = memref.load %arg3[%103] : memref<?xf32>
            %105 = arith.subf %100, %104 : f32
            %106 = arith.addf %104, %100 : f32
            %107 = arith.addf %106, %cst_1 : f32
            %108 = arith.divf %105, %107 : f32
            affine.store %108, %4[] : memref<f32>
            %109 = affine.load %14[0] : memref<1xi32>
            %110 = affine.load %13[0] : memref<1xi32>
            %111 = arith.index_cast %109 : i32 to index
            %112 = arith.muli %arg11, %111 : index
            %113 = arith.addi %arg12, %112 : index
            %114 = arith.muli %arg10, %111 : index
            %115 = arith.index_cast %110 : i32 to index
            %116 = arith.muli %114, %115 : index
            %117 = arith.addi %113, %116 : index
            %118 = affine.load %6[] : memref<f32>
            %119 = affine.load %5[] : memref<f32>
            %120 = arith.subf %118, %119 : f32
            %121 = affine.load %4[] : memref<f32>
            %122 = arith.mulf %120, %121 : f32
            %123 = arith.mulf %122, %36 : f32
            memref.store %123, %arg1[%117] : memref<?xf32>
            %124 = affine.load %6[] : memref<f32>
            %125 = arith.extf %124 : f32 to f64
            %126 = math.absf %125 : f64
            %127 = affine.load %5[] : memref<f32>
            %128 = arith.extf %127 : f32 to f64
            %129 = math.absf %128 : f64
            %130 = arith.cmpf olt, %126, %129 : f64
            scf.if %130 {
              %131 = affine.load %14[0] : memref<1xi32>
              %132 = affine.load %13[0] : memref<1xi32>
              %133 = arith.index_cast %131 : i32 to index
              %134 = arith.muli %arg11, %133 : index
              %135 = arith.addi %arg12, %134 : index
              %136 = arith.muli %arg10, %133 : index
              %137 = arith.index_cast %132 : i32 to index
              %138 = arith.muli %136, %137 : index
              %139 = arith.addi %135, %138 : index
              memref.store %cst_0, %arg1[%139] : memref<?xf32>
            }
          }
        } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "v2dt", non_scalar = false, type = "f32"}, {name = "vdy", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "v2dt", non_scalar = false, type = "f32"}, {name = "vdy", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "v2dt", non_scalar = false, type = "f32"}, {name = "vdy", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %40 = affine.load %19[0] : memref<1xi32>
    %41 = arith.index_cast %40 : i32 to index
    %42 = affine.load %22[0] : memref<1xi32>
    %43 = affine.load %32[0] : memref<1xi32>
    %44 = affine.load %14[0] : memref<1xi32>
    %45 = affine.load %13[0] : memref<1xi32>
    %46 = affine.load %arg4[0] : memref<?xf32>
    %47 = arith.index_cast %42 : i32 to index
    %48 = arith.index_cast %43 : i32 to index
    %49 = arith.index_cast %44 : i32 to index
    %50 = arith.index_cast %45 : i32 to index
    affine.for %arg10 = 1 to %41 {
      affine.for %arg11 = 1 to %47 {
        affine.for %arg12 = 1 to %48 {
          %51 = affine.load %arg3[%arg12 + %arg11 * symbol(%49) + (%arg10 * symbol(%49)) * symbol(%50)] : memref<?xf32>
          %52 = arith.cmpf olt, %51, %cst_2 : f32
          %53 = scf.if %52 -> (i1) {
            scf.yield %true : i1
          } else {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.index_cast %54 : i32 to index
            %57 = arith.muli %arg11, %56 : index
            %58 = arith.addi %arg12, %57 : index
            %59 = arith.addi %arg10, %c-1 : index
            %60 = arith.muli %59, %56 : index
            %61 = arith.index_cast %55 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %58, %62 : index
            %64 = memref.load %arg3[%63] : memref<?xf32>
            %65 = arith.cmpf olt, %64, %cst_2 : f32
            scf.yield %65 : i1
          }
          scf.if %53 {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.index_cast %54 : i32 to index
            %57 = arith.muli %arg11, %56 : index
            %58 = arith.addi %arg12, %57 : index
            %59 = arith.muli %arg10, %56 : index
            %60 = arith.index_cast %55 : i32 to index
            %61 = arith.muli %59, %60 : index
            %62 = arith.addi %58, %61 : index
            memref.store %cst_0, %arg2[%62] : memref<?xf32>
          } else {
            %54 = affine.load %14[0] : memref<1xi32>
            %55 = affine.load %13[0] : memref<1xi32>
            %56 = arith.index_cast %54 : i32 to index
            %57 = arith.muli %arg11, %56 : index
            %58 = arith.addi %arg12, %57 : index
            %59 = arith.muli %arg10, %56 : index
            %60 = arith.index_cast %55 : i32 to index
            %61 = arith.muli %59, %60 : index
            %62 = arith.addi %58, %61 : index
            %63 = memref.load %arg2[%62] : memref<?xf32>
            %64 = arith.extf %63 : f32 to f64
            %65 = math.absf %64 : f64
            %66 = arith.truncf %65 : f64 to f32
            affine.store %66, %3[] : memref<f32>
            %67 = memref.get_global @dti2 : memref<1xf32>
            %68 = affine.load %67[0] : memref<1xf32>
            %69 = affine.load %14[0] : memref<1xi32>
            %70 = affine.load %13[0] : memref<1xi32>
            %71 = arith.index_cast %69 : i32 to index
            %72 = arith.muli %arg11, %71 : index
            %73 = arith.addi %arg12, %72 : index
            %74 = arith.muli %arg10, %71 : index
            %75 = arith.index_cast %70 : i32 to index
            %76 = arith.muli %74, %75 : index
            %77 = arith.addi %73, %76 : index
            %78 = memref.load %arg2[%77] : memref<?xf32>
            %79 = arith.mulf %68, %78 : f32
            %80 = arith.mulf %79, %78 : f32
            %81 = affine.load %arg9[%arg10 - 1] : memref<?xf32>
            %82 = memref.load %arg8[%73] : memref<?xf32>
            %83 = arith.mulf %81, %82 : f32
            %84 = arith.divf %80, %83 : f32
            affine.store %84, %2[] : memref<f32>
            %85 = affine.load %14[0] : memref<1xi32>
            %86 = affine.load %13[0] : memref<1xi32>
            %87 = arith.index_cast %85 : i32 to index
            %88 = arith.muli %arg11, %87 : index
            %89 = arith.addi %arg12, %88 : index
            %90 = arith.addi %arg10, %c-1 : index
            %91 = arith.muli %90, %87 : index
            %92 = arith.index_cast %86 : i32 to index
            %93 = arith.muli %91, %92 : index
            %94 = arith.addi %89, %93 : index
            %95 = memref.load %arg3[%94] : memref<?xf32>
            %96 = arith.muli %arg10, %87 : index
            %97 = arith.muli %96, %92 : index
            %98 = arith.addi %89, %97 : index
            %99 = memref.load %arg3[%98] : memref<?xf32>
            %100 = arith.subf %95, %99 : f32
            %101 = arith.addf %99, %95 : f32
            %102 = arith.addf %101, %cst_1 : f32
            %103 = arith.divf %100, %102 : f32
            affine.store %103, %0[] : memref<f32>
            %104 = affine.load %14[0] : memref<1xi32>
            %105 = affine.load %13[0] : memref<1xi32>
            %106 = arith.index_cast %104 : i32 to index
            %107 = arith.muli %arg11, %106 : index
            %108 = arith.addi %arg12, %107 : index
            %109 = arith.muli %arg10, %106 : index
            %110 = arith.index_cast %105 : i32 to index
            %111 = arith.muli %109, %110 : index
            %112 = arith.addi %108, %111 : index
            %113 = affine.load %3[] : memref<f32>
            %114 = affine.load %2[] : memref<f32>
            %115 = arith.subf %113, %114 : f32
            %116 = affine.load %0[] : memref<f32>
            %117 = arith.mulf %115, %116 : f32
            %118 = arith.mulf %117, %46 : f32
            memref.store %118, %arg2[%112] : memref<?xf32>
            %119 = affine.load %3[] : memref<f32>
            %120 = arith.extf %119 : f32 to f64
            %121 = math.absf %120 : f64
            %122 = affine.load %2[] : memref<f32>
            %123 = arith.extf %122 : f32 to f64
            %124 = math.absf %123 : f64
            %125 = arith.cmpf olt, %121, %124 : f64
            scf.if %125 {
              %126 = affine.load %14[0] : memref<1xi32>
              %127 = affine.load %13[0] : memref<1xi32>
              %128 = arith.index_cast %126 : i32 to index
              %129 = arith.muli %arg11, %128 : index
              %130 = arith.addi %arg12, %129 : index
              %131 = arith.muli %arg10, %128 : index
              %132 = arith.index_cast %127 : i32 to index
              %133 = arith.muli %131, %132 : index
              %134 = arith.addi %130, %133 : index
              memref.store %cst_0, %arg2[%134] : memref<?xf32>
            }
          }
        } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "w2dt", non_scalar = false, type = "f32"}, {name = "wdz", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "w2dt", non_scalar = false, type = "f32"}, {name = "wdz", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [{name = "mol", non_scalar = false, type = "f32"}, {name = "w2dt", non_scalar = false, type = "f32"}, {name = "wdz", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

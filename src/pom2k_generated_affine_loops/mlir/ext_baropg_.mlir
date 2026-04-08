module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_baropg_(%arg0: memref<?xf32> {polygeist.name = "rho", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "rmean", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "zz", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "ramp", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = affine.load %3[0] : memref<1xi32>
    %6 = affine.load %4[0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    affine.for %arg11 = 0 to %2 {
      affine.for %arg12 = 0 to %7 {
        affine.for %arg13 = 0 to %8 {
          %96 = affine.load %arg0[%arg13 + %arg12 * symbol(%8) + (%arg11 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %97 = affine.load %arg1[%arg13 + %arg12 * symbol(%8) + (%arg11 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %98 = arith.subf %96, %97 : f32
          affine.store %98, %arg0[%arg13 + %arg12 * symbol(%8) + (%arg11 * symbol(%8)) * symbol(%7)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %9 = memref.get_global @jmm1 : memref<1xi32>
    %10 = affine.load %9[0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @imm1 : memref<1xi32>
    %13 = memref.get_global @grav : memref<1xf32>
    %14 = affine.load %12[0] : memref<1xi32>
    %15 = affine.load %4[0] : memref<1xi32>
    %16 = affine.load %13[0] : memref<1xf32>
    %17 = affine.load %arg4[0] : memref<?xf32>
    %18 = arith.index_cast %14 : i32 to index
    %19 = arith.index_cast %15 : i32 to index
    %20 = arith.mulf %16, %cst_0 : f32
    %21 = arith.negf %17 : f32
    %22 = arith.mulf %20, %21 : f32
    affine.for %arg11 = 1 to %11 {
      affine.for %arg12 = 1 to %18 {
        %96 = affine.load %arg5[%arg12 + %arg11 * symbol(%19)] : memref<?xf32>
        %97 = affine.load %arg5[%arg12 + %arg11 * symbol(%19) - 1] : memref<?xf32>
        %98 = arith.addf %96, %97 : f32
        %99 = arith.mulf %22, %98 : f32
        %100 = affine.load %arg0[%arg12 + %arg11 * symbol(%19)] : memref<?xf32>
        %101 = affine.load %arg0[%arg12 + %arg11 * symbol(%19) - 1] : memref<?xf32>
        %102 = arith.subf %100, %101 : f32
        %103 = arith.mulf %99, %102 : f32
        affine.store %103, %arg2[%arg12 + %arg11 * symbol(%19)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %23 = memref.get_global @kbm1 : memref<1xi32>
    %24 = affine.load %23[0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %26 = affine.load %9[0] : memref<1xi32>
    %27 = affine.load %12[0] : memref<1xi32>
    %28 = affine.load %4[0] : memref<1xi32>
    %29 = affine.load %3[0] : memref<1xi32>
    %30 = affine.load %13[0] : memref<1xf32>
    %31 = arith.index_cast %26 : i32 to index
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.mulf %30, %cst : f32
    affine.for %arg11 = 1 to %25 {
      %96 = affine.load %arg4[%arg11 - 1] : memref<?xf32>
      %97 = affine.load %arg4[%arg11] : memref<?xf32>
      %98 = arith.subf %96, %97 : f32
      %99 = arith.mulf %35, %98 : f32
      %100 = arith.addf %96, %97 : f32
      %101 = arith.mulf %35, %100 : f32
      affine.for %arg12 = 1 to %31 {
        affine.for %arg13 = 1 to %32 {
          %102 = affine.load %arg2[%arg13 + %arg12 * symbol(%33) + ((%arg11 - 1) * symbol(%33)) * symbol(%34)] : memref<?xf32>
          %103 = affine.load %arg5[%arg13 + %arg12 * symbol(%33)] : memref<?xf32>
          %104 = affine.load %arg5[%arg13 + %arg12 * symbol(%33) - 1] : memref<?xf32>
          %105 = arith.addf %103, %104 : f32
          %106 = arith.mulf %99, %105 : f32
          %107 = affine.load %arg0[%arg13 + %arg12 * symbol(%33) + (%arg11 * symbol(%33)) * symbol(%34)] : memref<?xf32>
          %108 = affine.load %arg0[%arg13 + %arg12 * symbol(%33) + (%arg11 * symbol(%33)) * symbol(%34) - 1] : memref<?xf32>
          %109 = arith.subf %107, %108 : f32
          %110 = affine.load %arg0[%arg13 + %arg12 * symbol(%33) + ((%arg11 - 1) * symbol(%33)) * symbol(%34)] : memref<?xf32>
          %111 = arith.addf %109, %110 : f32
          %112 = affine.load %arg0[%arg13 + %arg12 * symbol(%33) + ((%arg11 - 1) * symbol(%33)) * symbol(%34) - 1] : memref<?xf32>
          %113 = arith.subf %111, %112 : f32
          %114 = arith.mulf %106, %113 : f32
          %115 = arith.addf %102, %114 : f32
          %116 = arith.subf %103, %104 : f32
          %117 = arith.mulf %101, %116 : f32
          %118 = arith.addf %107, %108 : f32
          %119 = arith.subf %118, %110 : f32
          %120 = arith.subf %119, %112 : f32
          %121 = arith.mulf %117, %120 : f32
          %122 = arith.addf %115, %121 : f32
          affine.store %122, %arg2[%arg13 + %arg12 * symbol(%33) + (%arg11 * symbol(%33)) * symbol(%34)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %36 = affine.load %23[0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    %38 = affine.load %9[0] : memref<1xi32>
    %39 = affine.load %12[0] : memref<1xi32>
    %40 = affine.load %4[0] : memref<1xi32>
    %41 = affine.load %3[0] : memref<1xi32>
    %42 = arith.index_cast %38 : i32 to index
    %43 = arith.index_cast %39 : i32 to index
    %44 = arith.index_cast %40 : i32 to index
    %45 = arith.index_cast %41 : i32 to index
    affine.for %arg11 = 0 to %37 {
      affine.for %arg12 = 1 to %42 {
        affine.for %arg13 = 1 to %43 {
          %96 = affine.load %arg5[%arg13 + %arg12 * symbol(%44)] : memref<?xf32>
          %97 = affine.load %arg5[%arg13 + %arg12 * symbol(%44) - 1] : memref<?xf32>
          %98 = arith.addf %96, %97 : f32
          %99 = arith.mulf %98, %cst : f32
          %100 = affine.load %arg2[%arg13 + %arg12 * symbol(%44) + (%arg11 * symbol(%44)) * symbol(%45)] : memref<?xf32>
          %101 = arith.mulf %99, %100 : f32
          %102 = affine.load %arg6[%arg13 + %arg12 * symbol(%44)] : memref<?xf32>
          %103 = arith.mulf %101, %102 : f32
          %104 = affine.load %arg9[%arg13 + %arg12 * symbol(%44)] : memref<?xf32>
          %105 = affine.load %arg9[%arg13 + %arg12 * symbol(%44) - 1] : memref<?xf32>
          %106 = arith.addf %104, %105 : f32
          %107 = arith.mulf %103, %106 : f32
          affine.store %107, %arg2[%arg13 + %arg12 * symbol(%44) + (%arg11 * symbol(%44)) * symbol(%45)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %46 = affine.load %9[0] : memref<1xi32>
    %47 = arith.index_cast %46 : i32 to index
    %48 = affine.load %12[0] : memref<1xi32>
    %49 = affine.load %4[0] : memref<1xi32>
    %50 = affine.load %13[0] : memref<1xf32>
    %51 = affine.load %arg4[0] : memref<?xf32>
    %52 = arith.index_cast %48 : i32 to index
    %53 = arith.index_cast %49 : i32 to index
    %54 = arith.mulf %50, %cst_0 : f32
    %55 = arith.negf %51 : f32
    %56 = arith.mulf %54, %55 : f32
    affine.for %arg11 = 1 to %47 {
      affine.for %arg12 = 1 to %52 {
        %96 = affine.load %arg5[%arg12 + %arg11 * symbol(%53)] : memref<?xf32>
        %97 = affine.load %arg5[%arg12 + (%arg11 - 1) * symbol(%53)] : memref<?xf32>
        %98 = arith.addf %96, %97 : f32
        %99 = arith.mulf %56, %98 : f32
        %100 = affine.load %arg0[%arg12 + %arg11 * symbol(%53)] : memref<?xf32>
        %101 = affine.load %arg0[%arg12 + (%arg11 - 1) * symbol(%53)] : memref<?xf32>
        %102 = arith.subf %100, %101 : f32
        %103 = arith.mulf %99, %102 : f32
        affine.store %103, %arg3[%arg12 + %arg11 * symbol(%53)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %57 = affine.load %23[0] : memref<1xi32>
    %58 = arith.index_cast %57 : i32 to index
    %59 = affine.load %9[0] : memref<1xi32>
    %60 = affine.load %12[0] : memref<1xi32>
    %61 = affine.load %4[0] : memref<1xi32>
    %62 = affine.load %3[0] : memref<1xi32>
    %63 = affine.load %13[0] : memref<1xf32>
    %64 = arith.index_cast %59 : i32 to index
    %65 = arith.index_cast %60 : i32 to index
    %66 = arith.index_cast %61 : i32 to index
    %67 = arith.index_cast %62 : i32 to index
    %68 = arith.mulf %63, %cst : f32
    affine.for %arg11 = 1 to %58 {
      %96 = affine.load %arg4[%arg11 - 1] : memref<?xf32>
      %97 = affine.load %arg4[%arg11] : memref<?xf32>
      %98 = arith.subf %96, %97 : f32
      %99 = arith.mulf %68, %98 : f32
      %100 = arith.addf %96, %97 : f32
      %101 = arith.mulf %68, %100 : f32
      affine.for %arg12 = 1 to %64 {
        affine.for %arg13 = 1 to %65 {
          %102 = affine.load %arg3[%arg13 + %arg12 * symbol(%66) + ((%arg11 - 1) * symbol(%66)) * symbol(%67)] : memref<?xf32>
          %103 = affine.load %arg5[%arg13 + %arg12 * symbol(%66)] : memref<?xf32>
          %104 = affine.load %arg5[%arg13 + (%arg12 - 1) * symbol(%66)] : memref<?xf32>
          %105 = arith.addf %103, %104 : f32
          %106 = arith.mulf %99, %105 : f32
          %107 = affine.load %arg0[%arg13 + %arg12 * symbol(%66) + (%arg11 * symbol(%66)) * symbol(%67)] : memref<?xf32>
          %108 = affine.load %arg0[%arg13 + (%arg12 - 1) * symbol(%66) + (%arg11 * symbol(%66)) * symbol(%67)] : memref<?xf32>
          %109 = arith.subf %107, %108 : f32
          %110 = affine.load %arg0[%arg13 + %arg12 * symbol(%66) + ((%arg11 - 1) * symbol(%66)) * symbol(%67)] : memref<?xf32>
          %111 = arith.addf %109, %110 : f32
          %112 = affine.load %arg0[%arg13 + (%arg12 - 1) * symbol(%66) + ((%arg11 - 1) * symbol(%66)) * symbol(%67)] : memref<?xf32>
          %113 = arith.subf %111, %112 : f32
          %114 = arith.mulf %106, %113 : f32
          %115 = arith.addf %102, %114 : f32
          %116 = arith.subf %103, %104 : f32
          %117 = arith.mulf %101, %116 : f32
          %118 = arith.addf %107, %108 : f32
          %119 = arith.subf %118, %110 : f32
          %120 = arith.subf %119, %112 : f32
          %121 = arith.mulf %117, %120 : f32
          %122 = arith.addf %115, %121 : f32
          affine.store %122, %arg3[%arg13 + %arg12 * symbol(%66) + (%arg11 * symbol(%66)) * symbol(%67)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %69 = affine.load %23[0] : memref<1xi32>
    %70 = arith.index_cast %69 : i32 to index
    %71 = affine.load %9[0] : memref<1xi32>
    %72 = affine.load %12[0] : memref<1xi32>
    %73 = affine.load %4[0] : memref<1xi32>
    %74 = affine.load %3[0] : memref<1xi32>
    %75 = arith.index_cast %71 : i32 to index
    %76 = arith.index_cast %72 : i32 to index
    %77 = arith.index_cast %73 : i32 to index
    %78 = arith.index_cast %74 : i32 to index
    affine.for %arg11 = 0 to %70 {
      affine.for %arg12 = 1 to %75 {
        affine.for %arg13 = 1 to %76 {
          %96 = affine.load %arg5[%arg13 + %arg12 * symbol(%77)] : memref<?xf32>
          %97 = affine.load %arg5[%arg13 + (%arg12 - 1) * symbol(%77)] : memref<?xf32>
          %98 = arith.addf %96, %97 : f32
          %99 = arith.mulf %98, %cst : f32
          %100 = affine.load %arg3[%arg13 + %arg12 * symbol(%77) + (%arg11 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %101 = arith.mulf %99, %100 : f32
          %102 = affine.load %arg7[%arg13 + %arg12 * symbol(%77)] : memref<?xf32>
          %103 = arith.mulf %101, %102 : f32
          %104 = affine.load %arg8[%arg13 + %arg12 * symbol(%77)] : memref<?xf32>
          %105 = affine.load %arg8[%arg13 + (%arg12 - 1) * symbol(%77)] : memref<?xf32>
          %106 = arith.addf %104, %105 : f32
          %107 = arith.mulf %103, %106 : f32
          affine.store %107, %arg3[%arg13 + %arg12 * symbol(%77) + (%arg11 * symbol(%77)) * symbol(%78)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %79 = affine.load %0[0] : memref<1xi32>
    %80 = arith.index_cast %79 : i32 to index
    %81 = affine.load %9[0] : memref<1xi32>
    %82 = affine.load %12[0] : memref<1xi32>
    %83 = affine.load %4[0] : memref<1xi32>
    %84 = affine.load %3[0] : memref<1xi32>
    %85 = affine.load %arg10[0] : memref<?xf32>
    %86 = arith.index_cast %81 : i32 to index
    %87 = arith.index_cast %82 : i32 to index
    %88 = arith.index_cast %83 : i32 to index
    %89 = arith.index_cast %84 : i32 to index
    affine.for %arg11 = 0 to %80 {
      affine.for %arg12 = 1 to %86 {
        affine.for %arg13 = 1 to %87 {
          %96 = affine.load %arg2[%arg13 + %arg12 * symbol(%88) + (%arg11 * symbol(%88)) * symbol(%89)] : memref<?xf32>
          %97 = arith.mulf %85, %96 : f32
          affine.store %97, %arg2[%arg13 + %arg12 * symbol(%88) + (%arg11 * symbol(%88)) * symbol(%89)] : memref<?xf32>
          %98 = affine.load %arg3[%arg13 + %arg12 * symbol(%88) + (%arg11 * symbol(%88)) * symbol(%89)] : memref<?xf32>
          %99 = arith.mulf %85, %98 : f32
          affine.store %99, %arg3[%arg13 + %arg12 * symbol(%88) + (%arg11 * symbol(%88)) * symbol(%89)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %90 = affine.load %0[0] : memref<1xi32>
    %91 = arith.index_cast %90 : i32 to index
    %92 = affine.load %3[0] : memref<1xi32>
    %93 = affine.load %4[0] : memref<1xi32>
    %94 = arith.index_cast %92 : i32 to index
    %95 = arith.index_cast %93 : i32 to index
    affine.for %arg11 = 0 to %91 {
      affine.for %arg12 = 0 to %94 {
        affine.for %arg13 = 0 to %95 {
          %96 = affine.load %arg0[%arg13 + %arg12 * symbol(%95) + (%arg11 * symbol(%95)) * symbol(%94)] : memref<?xf32>
          %97 = affine.load %arg1[%arg13 + %arg12 * symbol(%95) + (%arg11 * symbol(%95)) * symbol(%94)] : memref<?xf32>
          %98 = arith.addf %96, %97 : f32
          affine.store %98, %arg0[%arg13 + %arg12 * symbol(%95) + (%arg11 * symbol(%95)) * symbol(%94)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    return
  }
}

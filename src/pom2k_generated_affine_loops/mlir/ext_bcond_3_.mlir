module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @jmm2 : memref<1xi32>
  memref.global @imm2 : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @hmax : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_bcond_3_(%arg0: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %cst_1 = arith.constant 5.000000e-01 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.alloca() : memref<f32>
    %1 = llvm.mlir.undef : f32
    affine.store %1, %0[] : memref<f32>
    %2 = memref.alloca() : memref<f32>
    affine.store %1, %2[] : memref<f32>
    %3 = memref.get_global @kbm1 : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = memref.get_global @jmm1 : memref<1xi32>
    %7 = memref.get_global @imm1 : memref<1xi32>
    %8 = memref.get_global @im : memref<1xi32>
    %9 = memref.get_global @hmax : memref<1xf32>
    %10 = memref.get_global @jm : memref<1xi32>
    %11 = memref.get_global @imm2 : memref<1xi32>
    %12 = affine.load %6[0] : memref<1xi32>
    %13 = affine.load %7[0] : memref<1xi32>
    %14 = affine.load %8[0] : memref<1xi32>
    %15 = affine.load %9[0] : memref<1xf32>
    %16 = affine.load %10[0] : memref<1xi32>
    %17 = affine.load %11[0] : memref<1xi32>
    %18 = arith.index_cast %12 : i32 to index
    %19 = arith.index_cast %13 : i32 to index
    %20 = arith.index_cast %14 : i32 to index
    %21 = arith.index_cast %16 : i32 to index
    %22 = arith.index_cast %17 : i32 to index
    affine.for %arg7 = 0 to %5 {
      affine.for %arg8 = 1 to %18 {
        %45 = affine.load %arg0[%arg8 * symbol(%20) + symbol(%19)] : memref<?xf32>
        %46 = arith.divf %45, %15 : f32
        %47 = math.sqrt %46 : f32
        affine.store %47, %2[] : memref<f32>
        %48 = affine.load %2[] : memref<f32>
        %49 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + symbol(%22) + (%arg8 - 1) * symbol(%20)] : memref<?xf32>
        %50 = arith.mulf %49, %cst_2 : f32
        %51 = affine.load %arg2[%arg8 * symbol(%20) + symbol(%22) + (%arg7 * symbol(%20)) * symbol(%21)] : memref<?xf32>
        %52 = arith.mulf %51, %cst_1 : f32
        %53 = arith.addf %50, %52 : f32
        %54 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + symbol(%22) + (%arg8 + 1) * symbol(%20)] : memref<?xf32>
        %55 = arith.mulf %54, %cst_2 : f32
        %56 = arith.addf %53, %55 : f32
        %57 = arith.mulf %48, %56 : f32
        %58 = arith.subf %cst_0, %48 : f32
        %59 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + symbol(%19) + (%arg8 - 1) * symbol(%20)] : memref<?xf32>
        %60 = arith.mulf %59, %cst_2 : f32
        %61 = affine.load %arg2[%arg8 * symbol(%20) + symbol(%19) + (%arg7 * symbol(%20)) * symbol(%21)] : memref<?xf32>
        %62 = arith.mulf %61, %cst_1 : f32
        %63 = arith.addf %60, %62 : f32
        %64 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + symbol(%19) + (%arg8 + 1) * symbol(%20)] : memref<?xf32>
        %65 = arith.mulf %64, %cst_2 : f32
        %66 = arith.addf %63, %65 : f32
        %67 = arith.mulf %58, %66 : f32
        %68 = arith.addf %57, %67 : f32
        affine.store %68, %arg1[%arg8 * symbol(%20) + symbol(%19) + (%arg7 * symbol(%20)) * symbol(%21)] : memref<?xf32>
        affine.store %cst, %arg3[%arg8 * symbol(%20) + symbol(%19) + (%arg7 * symbol(%20)) * symbol(%21)] : memref<?xf32>
        %69 = affine.load %arg0[%arg8 * symbol(%20)] : memref<?xf32>
        %70 = arith.divf %69, %15 : f32
        %71 = math.sqrt %70 : f32
        affine.store %71, %2[] : memref<f32>
        %72 = affine.load %2[] : memref<f32>
        %73 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + (%arg8 - 1) * symbol(%20) + 2] : memref<?xf32>
        %74 = arith.mulf %73, %cst_2 : f32
        %75 = affine.load %arg2[%arg8 * symbol(%20) + (%arg7 * symbol(%20)) * symbol(%21) + 2] : memref<?xf32>
        %76 = arith.mulf %75, %cst_1 : f32
        %77 = arith.addf %74, %76 : f32
        %78 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + (%arg8 + 1) * symbol(%20) + 2] : memref<?xf32>
        %79 = arith.mulf %78, %cst_2 : f32
        %80 = arith.addf %77, %79 : f32
        %81 = arith.mulf %72, %80 : f32
        %82 = arith.subf %cst_0, %72 : f32
        %83 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + (%arg8 - 1) * symbol(%20) + 1] : memref<?xf32>
        %84 = arith.mulf %83, %cst_2 : f32
        %85 = affine.load %arg2[%arg8 * symbol(%20) + (%arg7 * symbol(%20)) * symbol(%21) + 1] : memref<?xf32>
        %86 = arith.mulf %85, %cst_1 : f32
        %87 = arith.addf %84, %86 : f32
        %88 = affine.load %arg2[(%arg7 * symbol(%20)) * symbol(%21) + (%arg8 + 1) * symbol(%20) + 1] : memref<?xf32>
        %89 = arith.mulf %88, %cst_2 : f32
        %90 = arith.addf %87, %89 : f32
        %91 = arith.mulf %82, %90 : f32
        %92 = arith.addf %81, %91 : f32
        affine.store %92, %arg1[%arg8 * symbol(%20) + (%arg7 * symbol(%20)) * symbol(%21) + 1] : memref<?xf32>
        %93 = affine.load %arg1[%arg8 * symbol(%20) + (%arg7 * symbol(%20)) * symbol(%21) + 1] : memref<?xf32>
        affine.store %93, %arg1[%arg8 * symbol(%20) + (%arg7 * symbol(%20)) * symbol(%21)] : memref<?xf32>
        affine.store %cst, %arg3[%arg8 * symbol(%20) + (%arg7 * symbol(%20)) * symbol(%21)] : memref<?xf32>
      } {constants = [], locals = [{name = "ga", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [{name = "ga", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %23 = affine.load %3[0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = memref.get_global @jmm2 : memref<1xi32>
    %26 = affine.load %7[0] : memref<1xi32>
    %27 = affine.load %6[0] : memref<1xi32>
    %28 = affine.load %8[0] : memref<1xi32>
    %29 = affine.load %9[0] : memref<1xf32>
    %30 = affine.load %10[0] : memref<1xi32>
    %31 = affine.load %25[0] : memref<1xi32>
    %32 = arith.index_cast %26 : i32 to index
    %33 = arith.index_cast %27 : i32 to index
    %34 = arith.index_cast %28 : i32 to index
    %35 = arith.muli %33, %34 : index
    %36 = arith.index_cast %30 : i32 to index
    %37 = arith.index_cast %31 : i32 to index
    %38 = arith.muli %37, %34 : index
    affine.for %arg7 = 0 to %24 {
      affine.for %arg8 = 1 to %32 {
        %45 = affine.load %arg0[%arg8 + symbol(%35)] : memref<?xf32>
        %46 = arith.divf %45, %29 : f32
        %47 = math.sqrt %46 : f32
        affine.store %47, %0[] : memref<f32>
        %48 = affine.load %0[] : memref<f32>
        %49 = affine.load %arg4[%arg8 + symbol(%38) + (%arg7 * symbol(%34)) * symbol(%36) - 1] : memref<?xf32>
        %50 = arith.mulf %49, %cst_2 : f32
        %51 = affine.load %arg4[%arg8 + symbol(%38) + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        %52 = arith.mulf %51, %cst_1 : f32
        %53 = arith.addf %50, %52 : f32
        %54 = affine.load %arg4[%arg8 + symbol(%38) + (%arg7 * symbol(%34)) * symbol(%36) + 1] : memref<?xf32>
        %55 = arith.mulf %54, %cst_2 : f32
        %56 = arith.addf %53, %55 : f32
        %57 = arith.mulf %48, %56 : f32
        %58 = arith.subf %cst_0, %48 : f32
        %59 = affine.load %arg4[%arg8 + symbol(%35) + (%arg7 * symbol(%34)) * symbol(%36) - 1] : memref<?xf32>
        %60 = arith.mulf %59, %cst_2 : f32
        %61 = affine.load %arg4[%arg8 + symbol(%35) + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        %62 = arith.mulf %61, %cst_1 : f32
        %63 = arith.addf %60, %62 : f32
        %64 = affine.load %arg4[%arg8 + symbol(%35) + (%arg7 * symbol(%34)) * symbol(%36) + 1] : memref<?xf32>
        %65 = arith.mulf %64, %cst_2 : f32
        %66 = arith.addf %63, %65 : f32
        %67 = arith.mulf %58, %66 : f32
        %68 = arith.addf %57, %67 : f32
        affine.store %68, %arg3[%arg8 + symbol(%35) + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        affine.store %cst, %arg1[%arg8 + symbol(%35) + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        %69 = affine.load %arg0[%arg8] : memref<?xf32>
        %70 = arith.divf %69, %29 : f32
        %71 = math.sqrt %70 : f32
        affine.store %71, %0[] : memref<f32>
        %72 = affine.load %0[] : memref<f32>
        %73 = affine.load %arg4[%arg8 + symbol(%34) * 2 + (%arg7 * symbol(%34)) * symbol(%36) - 1] : memref<?xf32>
        %74 = arith.mulf %73, %cst_2 : f32
        %75 = affine.load %arg4[%arg8 + symbol(%34) * 2 + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        %76 = arith.mulf %75, %cst_1 : f32
        %77 = arith.addf %74, %76 : f32
        %78 = affine.load %arg4[%arg8 + symbol(%34) * 2 + (%arg7 * symbol(%34)) * symbol(%36) + 1] : memref<?xf32>
        %79 = arith.mulf %78, %cst_2 : f32
        %80 = arith.addf %77, %79 : f32
        %81 = arith.mulf %72, %80 : f32
        %82 = arith.subf %cst_0, %72 : f32
        %83 = affine.load %arg4[%arg8 + symbol(%34) + (%arg7 * symbol(%34)) * symbol(%36) - 1] : memref<?xf32>
        %84 = arith.mulf %83, %cst_2 : f32
        %85 = affine.load %arg4[%arg8 + symbol(%34) + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        %86 = arith.mulf %85, %cst_1 : f32
        %87 = arith.addf %84, %86 : f32
        %88 = affine.load %arg4[%arg8 + symbol(%34) + (%arg7 * symbol(%34)) * symbol(%36) + 1] : memref<?xf32>
        %89 = arith.mulf %88, %cst_2 : f32
        %90 = arith.addf %87, %89 : f32
        %91 = arith.mulf %82, %90 : f32
        %92 = arith.addf %81, %91 : f32
        affine.store %92, %arg3[%arg8 + symbol(%34) + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        %93 = affine.load %arg3[%arg8 + symbol(%34) + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        affine.store %93, %arg3[%arg8 + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
        affine.store %cst, %arg1[%arg8 + (%arg7 * symbol(%34)) * symbol(%36)] : memref<?xf32>
      } {constants = [], locals = [{name = "ga", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [{name = "ga", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %39 = affine.load %3[0] : memref<1xi32>
    %40 = arith.index_cast %39 : i32 to index
    %41 = affine.load %10[0] : memref<1xi32>
    %42 = affine.load %8[0] : memref<1xi32>
    %43 = arith.index_cast %41 : i32 to index
    %44 = arith.index_cast %42 : i32 to index
    affine.for %arg7 = 0 to %40 {
      affine.for %arg8 = 0 to %43 {
        affine.for %arg9 = 0 to %44 {
          %45 = affine.load %arg1[%arg9 + %arg8 * symbol(%44) + (%arg7 * symbol(%44)) * symbol(%43)] : memref<?xf32>
          %46 = affine.load %arg5[%arg9 + %arg8 * symbol(%44)] : memref<?xf32>
          %47 = arith.mulf %45, %46 : f32
          affine.store %47, %arg1[%arg9 + %arg8 * symbol(%44) + (%arg7 * symbol(%44)) * symbol(%43)] : memref<?xf32>
          %48 = affine.load %arg3[%arg9 + %arg8 * symbol(%44) + (%arg7 * symbol(%44)) * symbol(%43)] : memref<?xf32>
          %49 = affine.load %arg6[%arg9 + %arg8 * symbol(%44)] : memref<?xf32>
          %50 = arith.mulf %48, %49 : f32
          affine.store %50, %arg3[%arg9 + %arg8 * symbol(%44) + (%arg7 * symbol(%44)) * symbol(%43)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

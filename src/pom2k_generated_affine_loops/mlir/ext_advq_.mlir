module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_advq_(%arg0: memref<?xf32> {polygeist.name = "qb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "qf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 5.000000e-01 : f32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 1.250000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = affine.load %3[0] : memref<1xi32>
    %6 = affine.load %4[0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    affine.for %arg19 = 1 to %2 {
      affine.for %arg20 = 1 to %7 {
        affine.for %arg21 = 1 to %8 {
          %29 = affine.load %arg1[%arg21 + %arg20 * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %30 = affine.load %arg1[%arg21 + %arg20 * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7) - 1] : memref<?xf32>
          %31 = arith.addf %29, %30 : f32
          %32 = arith.mulf %31, %cst_1 : f32
          %33 = affine.load %arg5[%arg21 + %arg20 * symbol(%8)] : memref<?xf32>
          %34 = affine.load %arg5[%arg21 + %arg20 * symbol(%8) - 1] : memref<?xf32>
          %35 = arith.addf %33, %34 : f32
          %36 = arith.mulf %32, %35 : f32
          %37 = affine.load %arg6[%arg21 + %arg20 * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %38 = affine.load %arg6[%arg21 + %arg20 * symbol(%8) + ((%arg19 - 1) * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %39 = arith.addf %37, %38 : f32
          %40 = arith.mulf %36, %39 : f32
          affine.store %40, %arg3[%arg21 + %arg20 * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %41 = affine.load %arg1[%arg21 + %arg20 * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %42 = affine.load %arg1[%arg21 + (%arg20 - 1) * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %43 = arith.addf %41, %42 : f32
          %44 = arith.mulf %43, %cst_1 : f32
          %45 = affine.load %arg5[%arg21 + %arg20 * symbol(%8)] : memref<?xf32>
          %46 = affine.load %arg5[%arg21 + (%arg20 - 1) * symbol(%8)] : memref<?xf32>
          %47 = arith.addf %45, %46 : f32
          %48 = arith.mulf %44, %47 : f32
          %49 = affine.load %arg7[%arg21 + %arg20 * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %50 = affine.load %arg7[%arg21 + %arg20 * symbol(%8) + ((%arg19 - 1) * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %51 = arith.addf %49, %50 : f32
          %52 = arith.mulf %48, %51 : f32
          affine.store %52, %arg4[%arg21 + %arg20 * symbol(%8) + (%arg19 * symbol(%8)) * symbol(%7)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %9 = affine.load %0[0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    %11 = affine.load %3[0] : memref<1xi32>
    %12 = affine.load %4[0] : memref<1xi32>
    %13 = arith.index_cast %11 : i32 to index
    %14 = arith.index_cast %12 : i32 to index
    affine.for %arg19 = 1 to %10 {
      affine.for %arg20 = 1 to %13 {
        affine.for %arg21 = 1 to %14 {
          %29 = affine.load %arg10[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %30 = arith.mulf %29, %cst_0 : f32
          %31 = affine.load %arg8[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %32 = affine.load %arg8[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13) - 1] : memref<?xf32>
          %33 = arith.addf %31, %32 : f32
          %34 = affine.load %arg8[%arg21 + %arg20 * symbol(%14) + ((%arg19 - 1) * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %35 = arith.addf %33, %34 : f32
          %36 = affine.load %arg8[%arg21 + %arg20 * symbol(%14) + ((%arg19 - 1) * symbol(%14)) * symbol(%13) - 1] : memref<?xf32>
          %37 = arith.addf %35, %36 : f32
          %38 = arith.mulf %30, %37 : f32
          %39 = affine.load %arg9[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %40 = affine.load %arg9[%arg21 + %arg20 * symbol(%14) - 1] : memref<?xf32>
          %41 = arith.addf %39, %40 : f32
          %42 = arith.mulf %38, %41 : f32
          %43 = affine.load %arg0[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %44 = affine.load %arg0[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13) - 1] : memref<?xf32>
          %45 = arith.subf %43, %44 : f32
          %46 = arith.mulf %42, %45 : f32
          %47 = affine.load %arg11[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %48 = affine.load %arg11[%arg21 + %arg20 * symbol(%14) - 1] : memref<?xf32>
          %49 = arith.addf %47, %48 : f32
          %50 = arith.divf %46, %49 : f32
          %51 = affine.load %arg3[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %52 = arith.subf %51, %50 : f32
          affine.store %52, %arg3[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %53 = affine.load %arg12[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %54 = arith.mulf %53, %cst_0 : f32
          %55 = affine.load %arg8[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %56 = affine.load %arg8[%arg21 + (%arg20 - 1) * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %57 = arith.addf %55, %56 : f32
          %58 = affine.load %arg8[%arg21 + %arg20 * symbol(%14) + ((%arg19 - 1) * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %59 = arith.addf %57, %58 : f32
          %60 = affine.load %arg8[%arg21 + (%arg20 - 1) * symbol(%14) + ((%arg19 - 1) * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %61 = arith.addf %59, %60 : f32
          %62 = arith.mulf %54, %61 : f32
          %63 = affine.load %arg9[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %64 = affine.load %arg9[%arg21 + (%arg20 - 1) * symbol(%14)] : memref<?xf32>
          %65 = arith.addf %63, %64 : f32
          %66 = arith.mulf %62, %65 : f32
          %67 = affine.load %arg0[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %68 = affine.load %arg0[%arg21 + (%arg20 - 1) * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %69 = arith.subf %67, %68 : f32
          %70 = arith.mulf %66, %69 : f32
          %71 = affine.load %arg13[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %72 = affine.load %arg13[%arg21 + (%arg20 - 1) * symbol(%14)] : memref<?xf32>
          %73 = arith.addf %71, %72 : f32
          %74 = arith.divf %70, %73 : f32
          %75 = affine.load %arg4[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %76 = arith.subf %75, %74 : f32
          affine.store %76, %arg4[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %77 = affine.load %arg13[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %78 = affine.load %arg13[%arg21 + %arg20 * symbol(%14) - 1] : memref<?xf32>
          %79 = arith.addf %77, %78 : f32
          %80 = arith.mulf %79, %cst : f32
          %81 = affine.load %arg3[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %82 = arith.mulf %81, %80 : f32
          affine.store %82, %arg3[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %83 = affine.load %arg11[%arg21 + %arg20 * symbol(%14)] : memref<?xf32>
          %84 = affine.load %arg11[%arg21 + (%arg20 - 1) * symbol(%14)] : memref<?xf32>
          %85 = arith.addf %83, %84 : f32
          %86 = arith.mulf %85, %cst : f32
          %87 = affine.load %arg4[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %88 = arith.mulf %87, %86 : f32
          affine.store %88, %arg4[%arg21 + %arg20 * symbol(%14) + (%arg19 * symbol(%14)) * symbol(%13)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %15 = affine.load %0[0] : memref<1xi32>
    %16 = arith.index_cast %15 : i32 to index
    %17 = memref.get_global @jmm1 : memref<1xi32>
    %18 = memref.get_global @imm1 : memref<1xi32>
    %19 = memref.get_global @dti2 : memref<1xf32>
    %20 = affine.load %17[0] : memref<1xi32>
    %21 = affine.load %18[0] : memref<1xi32>
    %22 = affine.load %4[0] : memref<1xi32>
    %23 = affine.load %3[0] : memref<1xi32>
    %24 = affine.load %19[0] : memref<1xf32>
    %25 = arith.index_cast %20 : i32 to index
    %26 = arith.index_cast %21 : i32 to index
    %27 = arith.index_cast %22 : i32 to index
    %28 = arith.index_cast %23 : i32 to index
    affine.for %arg19 = 1 to %16 {
      %29 = affine.load %arg15[%arg19] : memref<?xf32>
      %30 = affine.load %arg15[%arg19 - 1] : memref<?xf32>
      %31 = arith.addf %29, %30 : f32
      affine.for %arg20 = 1 to %25 {
        affine.for %arg21 = 1 to %26 {
          %32 = affine.load %arg14[%arg21 + %arg20 * symbol(%27) + ((%arg19 - 1) * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %33 = affine.load %arg1[%arg21 + %arg20 * symbol(%27) + ((%arg19 - 1) * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %34 = arith.mulf %32, %33 : f32
          %35 = affine.load %arg14[%arg21 + %arg20 * symbol(%27) + ((%arg19 + 1) * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %36 = affine.load %arg1[%arg21 + %arg20 * symbol(%27) + ((%arg19 + 1) * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %37 = arith.mulf %35, %36 : f32
          %38 = arith.subf %34, %37 : f32
          %39 = affine.load %arg16[%arg21 + %arg20 * symbol(%27)] : memref<?xf32>
          %40 = arith.mulf %38, %39 : f32
          %41 = arith.divf %40, %31 : f32
          %42 = affine.load %arg3[%arg21 + %arg20 * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28) + 1] : memref<?xf32>
          %43 = arith.addf %41, %42 : f32
          %44 = affine.load %arg3[%arg21 + %arg20 * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %45 = arith.subf %43, %44 : f32
          %46 = affine.load %arg4[%arg21 + (%arg20 + 1) * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %47 = arith.addf %45, %46 : f32
          %48 = affine.load %arg4[%arg21 + %arg20 * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %49 = arith.subf %47, %48 : f32
          affine.store %49, %arg2[%arg21 + %arg20 * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %50 = affine.load %arg9[%arg21 + %arg20 * symbol(%27)] : memref<?xf32>
          %51 = affine.load %arg17[%arg21 + %arg20 * symbol(%27)] : memref<?xf32>
          %52 = arith.addf %50, %51 : f32
          %53 = affine.load %arg16[%arg21 + %arg20 * symbol(%27)] : memref<?xf32>
          %54 = arith.mulf %52, %53 : f32
          %55 = affine.load %arg0[%arg21 + %arg20 * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %56 = arith.mulf %54, %55 : f32
          %57 = affine.load %arg2[%arg21 + %arg20 * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28)] : memref<?xf32>
          %58 = arith.mulf %24, %57 : f32
          %59 = arith.subf %56, %58 : f32
          %60 = affine.load %arg18[%arg21 + %arg20 * symbol(%27)] : memref<?xf32>
          %61 = arith.addf %50, %60 : f32
          %62 = arith.mulf %61, %53 : f32
          %63 = arith.divf %59, %62 : f32
          affine.store %63, %arg2[%arg21 + %arg20 * symbol(%27) + (%arg19 * symbol(%27)) * symbol(%28)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

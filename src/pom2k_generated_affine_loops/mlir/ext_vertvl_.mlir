module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_vertvl_(%arg0: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vfluxb", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dti2", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 5.000000e-01 : f32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = affine.load %3[0] : memref<1xi32>
    %6 = affine.load %4[0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    affine.for %arg14 = 0 to %2 {
      affine.for %arg15 = 1 to %7 {
        affine.for %arg16 = 1 to %8 {
          %35 = affine.load %arg3[%arg16 + %arg15 * symbol(%8)] : memref<?xf32>
          %36 = affine.load %arg3[%arg16 + %arg15 * symbol(%8) - 1] : memref<?xf32>
          %37 = arith.addf %35, %36 : f32
          %38 = arith.mulf %37, %cst_0 : f32
          %39 = affine.load %arg4[%arg16 + %arg15 * symbol(%8)] : memref<?xf32>
          %40 = affine.load %arg4[%arg16 + %arg15 * symbol(%8) - 1] : memref<?xf32>
          %41 = arith.addf %39, %40 : f32
          %42 = arith.mulf %38, %41 : f32
          %43 = affine.load %arg5[%arg16 + %arg15 * symbol(%8) + (%arg14 * symbol(%8)) * symbol(%7)] : memref<?xf32>
          %44 = arith.mulf %42, %43 : f32
          affine.store %44, %arg0[%arg16 + %arg15 * symbol(%8) + (%arg14 * symbol(%8)) * symbol(%7)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %9 = affine.load %0[0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    %11 = affine.load %3[0] : memref<1xi32>
    %12 = affine.load %4[0] : memref<1xi32>
    %13 = arith.index_cast %11 : i32 to index
    %14 = arith.index_cast %12 : i32 to index
    affine.for %arg14 = 0 to %10 {
      affine.for %arg15 = 1 to %13 {
        affine.for %arg16 = 1 to %14 {
          %35 = affine.load %arg2[%arg16 + %arg15 * symbol(%14)] : memref<?xf32>
          %36 = affine.load %arg2[%arg16 + (%arg15 - 1) * symbol(%14)] : memref<?xf32>
          %37 = arith.addf %35, %36 : f32
          %38 = arith.mulf %37, %cst_0 : f32
          %39 = affine.load %arg4[%arg16 + %arg15 * symbol(%14)] : memref<?xf32>
          %40 = affine.load %arg4[%arg16 + (%arg15 - 1) * symbol(%14)] : memref<?xf32>
          %41 = arith.addf %39, %40 : f32
          %42 = arith.mulf %38, %41 : f32
          %43 = affine.load %arg6[%arg16 + %arg15 * symbol(%14) + (%arg14 * symbol(%14)) * symbol(%13)] : memref<?xf32>
          %44 = arith.mulf %42, %43 : f32
          affine.store %44, %arg1[%arg16 + %arg15 * symbol(%14) + (%arg14 * symbol(%14)) * symbol(%13)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %15 = memref.get_global @jmm1 : memref<1xi32>
    %16 = affine.load %15[0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @imm1 : memref<1xi32>
    %19 = affine.load %18[0] : memref<1xi32>
    %20 = affine.load %4[0] : memref<1xi32>
    %21 = arith.index_cast %19 : i32 to index
    %22 = arith.index_cast %20 : i32 to index
    affine.for %arg14 = 1 to %17 {
      affine.for %arg15 = 1 to %21 {
        %35 = affine.load %arg8[%arg15 + %arg14 * symbol(%22)] : memref<?xf32>
        %36 = affine.load %arg9[%arg15 + %arg14 * symbol(%22)] : memref<?xf32>
        %37 = arith.addf %35, %36 : f32
        %38 = arith.mulf %37, %cst : f32
        affine.store %38, %arg7[%arg15 + %arg14 * symbol(%22)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %23 = memref.get_global @kb : memref<1xi32>
    %24 = affine.load %23[0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %26 = affine.load %15[0] : memref<1xi32>
    %27 = affine.load %18[0] : memref<1xi32>
    %28 = affine.load %4[0] : memref<1xi32>
    %29 = affine.load %3[0] : memref<1xi32>
    %30 = affine.load %arg13[0] : memref<?xf32>
    %31 = arith.index_cast %26 : i32 to index
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    affine.for %arg14 = 1 to %25 {
      %35 = affine.load %arg12[%arg14 - 1] : memref<?xf32>
      affine.for %arg15 = 1 to %31 {
        affine.for %arg16 = 1 to %32 {
          %36 = affine.load %arg7[%arg16 + %arg15 * symbol(%33) + ((%arg14 - 1) * symbol(%33)) * symbol(%34)] : memref<?xf32>
          %37 = affine.load %arg0[%arg16 + %arg15 * symbol(%33) + ((%arg14 - 1) * symbol(%33)) * symbol(%34) + 1] : memref<?xf32>
          %38 = affine.load %arg0[%arg16 + %arg15 * symbol(%33) + ((%arg14 - 1) * symbol(%33)) * symbol(%34)] : memref<?xf32>
          %39 = arith.subf %37, %38 : f32
          %40 = affine.load %arg1[%arg16 + (%arg15 + 1) * symbol(%33) + ((%arg14 - 1) * symbol(%33)) * symbol(%34)] : memref<?xf32>
          %41 = arith.addf %39, %40 : f32
          %42 = affine.load %arg1[%arg16 + %arg15 * symbol(%33) + ((%arg14 - 1) * symbol(%33)) * symbol(%34)] : memref<?xf32>
          %43 = arith.subf %41, %42 : f32
          %44 = affine.load %arg2[%arg16 + %arg15 * symbol(%33)] : memref<?xf32>
          %45 = affine.load %arg3[%arg16 + %arg15 * symbol(%33)] : memref<?xf32>
          %46 = arith.mulf %44, %45 : f32
          %47 = arith.divf %43, %46 : f32
          %48 = affine.load %arg10[%arg16 + %arg15 * symbol(%33)] : memref<?xf32>
          %49 = affine.load %arg11[%arg16 + %arg15 * symbol(%33)] : memref<?xf32>
          %50 = arith.subf %48, %49 : f32
          %51 = arith.divf %50, %30 : f32
          %52 = arith.addf %47, %51 : f32
          %53 = arith.mulf %35, %52 : f32
          %54 = arith.addf %36, %53 : f32
          affine.store %54, %arg7[%arg16 + %arg15 * symbol(%33) + (%arg14 * symbol(%33)) * symbol(%34)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    return
  }
}

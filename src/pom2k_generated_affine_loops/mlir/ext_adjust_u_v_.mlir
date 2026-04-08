module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_adjust_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "utb", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vtb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = affine.load %3[0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    affine.for %arg9 = 0 to %2 {
      affine.for %arg10 = 0 to %5 {
        affine.store %cst, %arg0[%arg10 + %arg9 * symbol(%5)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = affine.load %6[0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = affine.load %0[0] : memref<1xi32>
    %10 = affine.load %3[0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    affine.for %arg9 = 0 to %8 {
      %35 = affine.load %arg3[%arg9] : memref<?xf32>
      affine.for %arg10 = 0 to %11 {
        affine.for %arg11 = 0 to %12 {
          %36 = affine.load %arg0[%arg11 + %arg10 * symbol(%12)] : memref<?xf32>
          %37 = affine.load %arg1[%arg11 + %arg10 * symbol(%12) + (%arg9 * symbol(%12)) * symbol(%11)] : memref<?xf32>
          %38 = arith.mulf %37, %35 : f32
          %39 = arith.addf %36, %38 : f32
          affine.store %39, %arg0[%arg11 + %arg10 * symbol(%12)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %13 = affine.load %6[0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = affine.load %0[0] : memref<1xi32>
    %16 = affine.load %3[0] : memref<1xi32>
    %17 = arith.index_cast %15 : i32 to index
    %18 = arith.index_cast %16 : i32 to index
    affine.for %arg9 = 0 to %14 {
      affine.for %arg10 = 0 to %17 {
        affine.for %arg11 = 1 to %18 {
          %35 = affine.load %arg1[%arg11 + %arg10 * symbol(%18) + (%arg9 * symbol(%18)) * symbol(%17)] : memref<?xf32>
          %36 = affine.load %arg0[%arg11 + %arg10 * symbol(%18)] : memref<?xf32>
          %37 = arith.subf %35, %36 : f32
          %38 = affine.load %arg4[%arg11 + %arg10 * symbol(%18)] : memref<?xf32>
          %39 = affine.load %arg5[%arg11 + %arg10 * symbol(%18)] : memref<?xf32>
          %40 = arith.addf %38, %39 : f32
          %41 = affine.load %arg8[%arg11 + %arg10 * symbol(%18)] : memref<?xf32>
          %42 = affine.load %arg8[%arg11 + %arg10 * symbol(%18) - 1] : memref<?xf32>
          %43 = arith.addf %41, %42 : f32
          %44 = arith.divf %40, %43 : f32
          %45 = arith.addf %37, %44 : f32
          affine.store %45, %arg1[%arg11 + %arg10 * symbol(%18) + (%arg9 * symbol(%18)) * symbol(%17)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %19 = affine.load %0[0] : memref<1xi32>
    %20 = arith.index_cast %19 : i32 to index
    %21 = affine.load %3[0] : memref<1xi32>
    %22 = arith.index_cast %21 : i32 to index
    affine.for %arg9 = 0 to %20 {
      affine.for %arg10 = 0 to %22 {
        affine.store %cst, %arg0[%arg10 + %arg9 * symbol(%22)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %23 = affine.load %6[0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = affine.load %0[0] : memref<1xi32>
    %26 = affine.load %3[0] : memref<1xi32>
    %27 = arith.index_cast %25 : i32 to index
    %28 = arith.index_cast %26 : i32 to index
    affine.for %arg9 = 0 to %24 {
      %35 = affine.load %arg3[%arg9] : memref<?xf32>
      affine.for %arg10 = 0 to %27 {
        affine.for %arg11 = 0 to %28 {
          %36 = affine.load %arg0[%arg11 + %arg10 * symbol(%28)] : memref<?xf32>
          %37 = affine.load %arg2[%arg11 + %arg10 * symbol(%28) + (%arg9 * symbol(%28)) * symbol(%27)] : memref<?xf32>
          %38 = arith.mulf %37, %35 : f32
          %39 = arith.addf %36, %38 : f32
          affine.store %39, %arg0[%arg11 + %arg10 * symbol(%28)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %29 = affine.load %6[0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = affine.load %0[0] : memref<1xi32>
    %32 = affine.load %3[0] : memref<1xi32>
    %33 = arith.index_cast %31 : i32 to index
    %34 = arith.index_cast %32 : i32 to index
    affine.for %arg9 = 0 to %30 {
      affine.for %arg10 = 1 to %33 {
        affine.for %arg11 = 0 to %34 {
          %35 = affine.load %arg2[%arg11 + %arg10 * symbol(%34) + (%arg9 * symbol(%34)) * symbol(%33)] : memref<?xf32>
          %36 = affine.load %arg0[%arg11 + %arg10 * symbol(%34)] : memref<?xf32>
          %37 = arith.subf %35, %36 : f32
          %38 = affine.load %arg6[%arg11 + %arg10 * symbol(%34)] : memref<?xf32>
          %39 = affine.load %arg7[%arg11 + %arg10 * symbol(%34)] : memref<?xf32>
          %40 = arith.addf %38, %39 : f32
          %41 = affine.load %arg8[%arg11 + %arg10 * symbol(%34)] : memref<?xf32>
          %42 = affine.load %arg8[%arg11 + (%arg10 - 1) * symbol(%34)] : memref<?xf32>
          %43 = arith.addf %41, %42 : f32
          %44 = arith.divf %40, %43 : f32
          %45 = arith.addf %37, %44 : f32
          affine.store %45, %arg2[%arg11 + %arg10 * symbol(%34) + (%arg9 * symbol(%34)) * symbol(%33)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

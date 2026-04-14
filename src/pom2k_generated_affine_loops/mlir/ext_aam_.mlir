module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @horcon : memref<1xf32>
  memref.global @jm : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_aam_(%arg0: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jmm1 : memref<1xi32>
    %4 = memref.get_global @imm1 : memref<1xi32>
    %5 = memref.get_global @im : memref<1xi32>
    %6 = memref.get_global @jm : memref<1xi32>
    %7 = memref.get_global @horcon : memref<1xf32>
    %8 = affine.load %3[0] : memref<1xi32>
    %9 = affine.load %4[0] : memref<1xi32>
    %10 = affine.load %5[0] : memref<1xi32>
    %11 = affine.load %6[0] : memref<1xi32>
    %12 = affine.load %7[0] : memref<1xf32>
    %13 = arith.index_cast %8 : i32 to index
    %14 = arith.index_cast %9 : i32 to index
    %15 = arith.index_cast %10 : i32 to index
    %16 = arith.index_cast %11 : i32 to index
    affine.for %arg5 = 0 to %2 {
      affine.for %arg6 = 1 to %13 {
        affine.for %arg7 = 1 to %14 {
          %17 = affine.load %arg1[%arg7 + %arg6 * symbol(%15)] : memref<?xf32>
          %18 = arith.mulf %12, %17 : f32
          %19 = affine.load %arg2[%arg7 + %arg6 * symbol(%15)] : memref<?xf32>
          %20 = arith.mulf %18, %19 : f32
          %21 = affine.load %arg3[%arg7 + %arg6 * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16) + 1] : memref<?xf32>
          %22 = affine.load %arg3[%arg7 + %arg6 * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16)] : memref<?xf32>
          %23 = arith.subf %21, %22 : f32
          %24 = arith.divf %23, %17 : f32
          %25 = arith.mulf %24, %24 : f32
          %26 = affine.load %arg4[%arg7 + (%arg6 + 1) * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16)] : memref<?xf32>
          %27 = affine.load %arg4[%arg7 + %arg6 * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16)] : memref<?xf32>
          %28 = arith.subf %26, %27 : f32
          %29 = arith.divf %28, %19 : f32
          %30 = arith.mulf %29, %29 : f32
          %31 = arith.addf %25, %30 : f32
          %32 = affine.load %arg3[%arg7 + (%arg6 + 1) * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16)] : memref<?xf32>
          %33 = affine.load %arg3[%arg7 + (%arg6 + 1) * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16) + 1] : memref<?xf32>
          %34 = arith.addf %32, %33 : f32
          %35 = affine.load %arg3[%arg7 + (%arg6 - 1) * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16)] : memref<?xf32>
          %36 = arith.subf %34, %35 : f32
          %37 = affine.load %arg3[%arg7 + (%arg6 - 1) * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16) + 1] : memref<?xf32>
          %38 = arith.subf %36, %37 : f32
          %39 = arith.mulf %38, %cst : f32
          %40 = arith.divf %39, %19 : f32
          %41 = affine.load %arg4[%arg7 + %arg6 * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16) + 1] : memref<?xf32>
          %42 = affine.load %arg4[%arg7 + (%arg6 + 1) * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16) + 1] : memref<?xf32>
          %43 = arith.addf %41, %42 : f32
          %44 = affine.load %arg4[%arg7 + %arg6 * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16) - 1] : memref<?xf32>
          %45 = arith.subf %43, %44 : f32
          %46 = affine.load %arg4[%arg7 + (%arg6 + 1) * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16) - 1] : memref<?xf32>
          %47 = arith.subf %45, %46 : f32
          %48 = arith.mulf %47, %cst : f32
          %49 = arith.divf %48, %17 : f32
          %50 = arith.addf %40, %49 : f32
          %51 = arith.mulf %50, %cst_0 : f32
          %52 = arith.mulf %51, %50 : f32
          %53 = arith.addf %31, %52 : f32
          %54 = math.sqrt %53 : f32
          %55 = arith.mulf %20, %54 : f32
          affine.store %55, %arg0[%arg7 + %arg6 * symbol(%15) + (%arg5 * symbol(%15)) * symbol(%16)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

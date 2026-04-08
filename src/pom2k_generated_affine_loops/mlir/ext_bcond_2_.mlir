module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @jm : memref<1xi32>
  memref.global @jmm2 : memref<1xi32>
  memref.global @imm2 : memref<1xi32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_bcond_2_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "uabe", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "uabw", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "vabn", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vabs", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "ele", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elw", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "eln", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "els", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "ramp", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "rfe", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "rfw", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "rfn", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "rfs", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @imm2 : memref<1xi32>
    %7 = affine.load %3[0] : memref<1xi32>
    %8 = affine.load %4[0] : memref<1xi32>
    %9 = affine.load %arg15[0] : memref<?xf32>
    %10 = affine.load %5[0] : memref<1xf32>
    %11 = affine.load %6[0] : memref<1xi32>
    %12 = affine.load %arg14[0] : memref<?xf32>
    %13 = affine.load %arg16[0] : memref<?xf32>
    %14 = arith.index_cast %7 : i32 to index
    %15 = arith.index_cast %8 : i32 to index
    %16 = arith.index_cast %11 : i32 to index
    affine.for %arg19 = 1 to %2 {
      %37 = affine.load %arg2[%arg19] : memref<?xf32>
      %38 = affine.load %arg6[%arg19 * symbol(%15) + symbol(%16)] : memref<?xf32>
      %39 = arith.divf %10, %38 : f32
      %40 = math.sqrt %39 : f32
      %41 = arith.mulf %9, %40 : f32
      %42 = affine.load %arg7[%arg19 * symbol(%15) + symbol(%16)] : memref<?xf32>
      %43 = affine.load %arg8[%arg19] : memref<?xf32>
      %44 = arith.subf %42, %43 : f32
      %45 = arith.mulf %41, %44 : f32
      %46 = arith.addf %37, %45 : f32
      affine.store %46, %arg0[%arg19 * symbol(%15) + symbol(%14)] : memref<?xf32>
      %47 = affine.load %arg0[%arg19 * symbol(%15) + symbol(%14)] : memref<?xf32>
      %48 = arith.mulf %12, %47 : f32
      affine.store %48, %arg0[%arg19 * symbol(%15) + symbol(%14)] : memref<?xf32>
      affine.store %cst, %arg1[%arg19 * symbol(%15) + symbol(%14)] : memref<?xf32>
      %49 = affine.load %arg3[%arg19] : memref<?xf32>
      %50 = affine.load %arg6[%arg19 * symbol(%15) + 1] : memref<?xf32>
      %51 = arith.divf %10, %50 : f32
      %52 = math.sqrt %51 : f32
      %53 = arith.mulf %13, %52 : f32
      %54 = affine.load %arg7[%arg19 * symbol(%15) + 1] : memref<?xf32>
      %55 = affine.load %arg9[%arg19] : memref<?xf32>
      %56 = arith.subf %54, %55 : f32
      %57 = arith.mulf %53, %56 : f32
      %58 = arith.subf %49, %57 : f32
      affine.store %58, %arg0[%arg19 * symbol(%15) + 1] : memref<?xf32>
      %59 = affine.load %arg0[%arg19 * symbol(%15) + 1] : memref<?xf32>
      %60 = arith.mulf %12, %59 : f32
      affine.store %60, %arg0[%arg19 * symbol(%15) + 1] : memref<?xf32>
      %61 = affine.load %arg0[%arg19 * symbol(%15) + 1] : memref<?xf32>
      affine.store %61, %arg0[%arg19 * symbol(%15)] : memref<?xf32>
      affine.store %cst, %arg1[%arg19 * symbol(%15)] : memref<?xf32>
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %17 = affine.load %3[0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.get_global @jmm2 : memref<1xi32>
    %20 = affine.load %0[0] : memref<1xi32>
    %21 = affine.load %4[0] : memref<1xi32>
    %22 = affine.load %arg17[0] : memref<?xf32>
    %23 = affine.load %5[0] : memref<1xf32>
    %24 = affine.load %19[0] : memref<1xi32>
    %25 = affine.load %arg14[0] : memref<?xf32>
    %26 = affine.load %arg18[0] : memref<?xf32>
    %27 = arith.index_cast %20 : i32 to index
    %28 = arith.index_cast %21 : i32 to index
    %29 = arith.muli %27, %28 : index
    %30 = arith.index_cast %24 : i32 to index
    %31 = arith.muli %30, %28 : index
    affine.for %arg19 = 1 to %18 {
      %37 = affine.load %arg4[%arg19] : memref<?xf32>
      %38 = affine.load %arg6[%arg19 + symbol(%31)] : memref<?xf32>
      %39 = arith.divf %23, %38 : f32
      %40 = math.sqrt %39 : f32
      %41 = arith.mulf %22, %40 : f32
      %42 = affine.load %arg7[%arg19 + symbol(%31)] : memref<?xf32>
      %43 = affine.load %arg10[%arg19] : memref<?xf32>
      %44 = arith.subf %42, %43 : f32
      %45 = arith.mulf %41, %44 : f32
      %46 = arith.addf %37, %45 : f32
      affine.store %46, %arg1[%arg19 + symbol(%29)] : memref<?xf32>
      %47 = affine.load %arg1[%arg19 + symbol(%29)] : memref<?xf32>
      %48 = arith.mulf %25, %47 : f32
      affine.store %48, %arg1[%arg19 + symbol(%29)] : memref<?xf32>
      affine.store %cst, %arg0[%arg19 + symbol(%29)] : memref<?xf32>
      %49 = affine.load %arg5[%arg19] : memref<?xf32>
      %50 = affine.load %arg6[%arg19 + symbol(%28)] : memref<?xf32>
      %51 = arith.divf %23, %50 : f32
      %52 = math.sqrt %51 : f32
      %53 = arith.mulf %26, %52 : f32
      %54 = affine.load %arg7[%arg19 + symbol(%28)] : memref<?xf32>
      %55 = affine.load %arg11[%arg19] : memref<?xf32>
      %56 = arith.subf %54, %55 : f32
      %57 = arith.mulf %53, %56 : f32
      %58 = arith.subf %49, %57 : f32
      affine.store %58, %arg1[%arg19 + symbol(%28)] : memref<?xf32>
      %59 = affine.load %arg1[%arg19 + symbol(%28)] : memref<?xf32>
      %60 = arith.mulf %25, %59 : f32
      affine.store %60, %arg1[%arg19 + symbol(%28)] : memref<?xf32>
      %61 = affine.load %arg1[%arg19 + symbol(%28)] : memref<?xf32>
      affine.store %61, %arg1[%arg19] : memref<?xf32>
      affine.store %cst, %arg0[%arg19] : memref<?xf32>
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    %32 = memref.get_global @jm : memref<1xi32>
    %33 = affine.load %32[0] : memref<1xi32>
    %34 = arith.index_cast %33 : i32 to index
    %35 = affine.load %4[0] : memref<1xi32>
    %36 = arith.index_cast %35 : i32 to index
    affine.for %arg19 = 0 to %34 {
      affine.for %arg20 = 0 to %36 {
        %37 = affine.load %arg0[%arg20 + %arg19 * symbol(%36)] : memref<?xf32>
        %38 = affine.load %arg12[%arg20 + %arg19 * symbol(%36)] : memref<?xf32>
        %39 = arith.mulf %37, %38 : f32
        affine.store %39, %arg0[%arg20 + %arg19 * symbol(%36)] : memref<?xf32>
        %40 = affine.load %arg1[%arg20 + %arg19 * symbol(%36)] : memref<?xf32>
        %41 = affine.load %arg13[%arg20 + %arg19 * symbol(%36)] : memref<?xf32>
        %42 = arith.mulf %40, %41 : f32
        affine.store %42, %arg1[%arg20 + %arg19 * symbol(%36)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    return
  }
}

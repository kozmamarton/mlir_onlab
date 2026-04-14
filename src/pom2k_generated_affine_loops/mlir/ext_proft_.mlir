module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @ntp : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_proft_(%arg0: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "wfsurf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fsurf", polygeist.type = "float *"}, %arg3: memref<?xi32> {polygeist.name = "nbc", polygeist.type = "int *"}, %arg4: memref<?xf32> {polygeist.name = "dh", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "kh", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "z", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "swrad", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "rad2", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %true = arith.constant true
    %c-1 = arith.constant -1 : index
    %c-3_i32 = arith.constant -3 : i32
    %c-1_i32 = arith.constant -1 : i32
    %c3_i32 = arith.constant 3 : i32
    %cst = arith.constant 7.900000e+00 : f32
    %cst_0 = arith.constant 1.400000e+01 : f32
    %cst_1 = arith.constant 1.700000e+01 : f32
    %cst_2 = arith.constant 2.000000e+01 : f32
    %cst_3 = arith.constant 2.300000e+01 : f32
    %cst_4 = arith.constant 1.400000e+00 : f32
    %cst_5 = arith.constant 1.500000e+00 : f32
    %cst_6 = arith.constant 1.000000e+00 : f32
    %cst_7 = arith.constant 6.000000e-01 : f32
    %cst_8 = arith.constant 3.500000e-01 : f32
    %cst_9 = arith.constant 7.800000e-01 : f32
    %cst_10 = arith.constant 0.76999998 : f32
    %cst_11 = arith.constant 6.700000e-01 : f32
    %cst_12 = arith.constant 6.200000e-01 : f32
    %cst_13 = arith.constant 5.800000e-01 : f32
    %c4_i32 = arith.constant 4 : i32
    %c2_i32 = arith.constant 2 : i32
    %cst_14 = arith.constant 0.000000e+00 : f32
    %c1_i32 = arith.constant 1 : i32
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.alloca() : memref<i32>
    %1 = llvm.mlir.undef : i32
    affine.store %1, %0[] : memref<i32>
    %2 = memref.alloca() {polygeist.name = "ad2"} : memref<5xf32>
    %3 = memref.alloca() {polygeist.name = "ad1"} : memref<5xf32>
    %4 = memref.alloca() {polygeist.name = "r"} : memref<5xf32>
    %5 = memref.get_global @jm : memref<1xi32>
    %6 = affine.load %5[0] : memref<1xi32>
    %7 = arith.index_cast %6 : i32 to index
    %8 = memref.get_global @im : memref<1xi32>
    %9 = affine.load %8[0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    affine.for %arg17 = 0 to %7 {
      affine.for %arg18 = 0 to %10 {
        %72 = affine.load %arg5[%arg18 + %arg17 * symbol(%10)] : memref<?xf32>
        %73 = affine.load %arg6[%arg18 + %arg17 * symbol(%10)] : memref<?xf32>
        %74 = arith.addf %72, %73 : f32
        affine.store %74, %arg4[%arg18 + %arg17 * symbol(%10)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %11 = memref.get_global @kbm2 : memref<1xi32>
    %12 = affine.load %11[0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.get_global @dti2 : memref<1xf32>
    %15 = memref.get_global @umol : memref<1xf32>
    %16 = affine.load %5[0] : memref<1xi32>
    %17 = affine.load %8[0] : memref<1xi32>
    %18 = affine.load %14[0] : memref<1xf32>
    %19 = affine.load %15[0] : memref<1xf32>
    %20 = arith.index_cast %16 : i32 to index
    %21 = arith.index_cast %17 : i32 to index
    %22 = arith.negf %18 : f32
    affine.for %arg17 = 0 to %13 {
      %72 = affine.load %arg14[%arg17] : memref<?xf32>
      %73 = affine.load %arg15[%arg17] : memref<?xf32>
      %74 = arith.mulf %72, %73 : f32
      affine.for %arg18 = 0 to %20 {
        affine.for %arg19 = 0 to %21 {
          %75 = affine.load %arg8[%arg19 + %arg18 * symbol(%21) + ((%arg17 + 1) * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %76 = arith.addf %75, %19 : f32
          %77 = arith.mulf %22, %76 : f32
          %78 = affine.load %arg4[%arg19 + %arg18 * symbol(%21)] : memref<?xf32>
          %79 = arith.mulf %74, %78 : f32
          %80 = arith.mulf %79, %78 : f32
          %81 = arith.divf %77, %80 : f32
          affine.store %81, %arg7[%arg19 + %arg18 * symbol(%21) + (%arg17 * symbol(%21)) * symbol(%20)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm2"}
    %23 = memref.get_global @kbm1 : memref<1xi32>
    %24 = affine.load %23[0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %26 = affine.load %5[0] : memref<1xi32>
    %27 = affine.load %8[0] : memref<1xi32>
    %28 = affine.load %14[0] : memref<1xf32>
    %29 = affine.load %15[0] : memref<1xf32>
    %30 = arith.index_cast %26 : i32 to index
    %31 = arith.index_cast %27 : i32 to index
    %32 = arith.negf %28 : f32
    affine.for %arg17 = 1 to %25 {
      %72 = affine.load %arg14[%arg17] : memref<?xf32>
      %73 = affine.load %arg15[%arg17 - 1] : memref<?xf32>
      %74 = arith.mulf %72, %73 : f32
      affine.for %arg18 = 0 to %30 {
        affine.for %arg19 = 0 to %31 {
          %75 = affine.load %arg8[%arg19 + %arg18 * symbol(%31) + (%arg17 * symbol(%31)) * symbol(%30)] : memref<?xf32>
          %76 = arith.addf %75, %29 : f32
          %77 = arith.mulf %32, %76 : f32
          %78 = affine.load %arg4[%arg19 + %arg18 * symbol(%31)] : memref<?xf32>
          %79 = arith.mulf %74, %78 : f32
          %80 = arith.mulf %79, %78 : f32
          %81 = arith.divf %77, %80 : f32
          affine.store %81, %arg9[%arg19 + %arg18 * symbol(%31) + (%arg17 * symbol(%31)) * symbol(%30)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %33 = memref.get_global @kb : memref<1xi32>
    %34 = affine.load %33[0] : memref<1xi32>
    %35 = arith.index_cast %34 : i32 to index
    %36 = affine.load %5[0] : memref<1xi32>
    %37 = affine.load %8[0] : memref<1xi32>
    %38 = arith.index_cast %36 : i32 to index
    %39 = arith.index_cast %37 : i32 to index
    affine.for %arg17 = 0 to %35 {
      affine.for %arg18 = 0 to %38 {
        affine.for %arg19 = 0 to %39 {
          affine.store %cst_14, %arg16[%arg19 + %arg18 * symbol(%39) + (%arg17 * symbol(%39)) * symbol(%38)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %40 = affine.load %arg3[0] : memref<?xi32>
    %41 = arith.cmpi eq, %40, %c2_i32 : i32
    %42 = scf.if %41 -> (i1) {
      scf.yield %true : i1
    } else {
      %72 = affine.load %arg3[0] : memref<?xi32>
      %73 = arith.cmpi eq, %72, %c4_i32 : i32
      scf.yield %73 : i1
    }
    scf.if %42 {
      affine.store %cst_13, %4[0] : memref<5xf32>
      affine.store %cst_12, %4[1] : memref<5xf32>
      affine.store %cst_11, %4[2] : memref<5xf32>
      affine.store %cst_10, %4[3] : memref<5xf32>
      affine.store %cst_9, %4[4] : memref<5xf32>
      affine.store %cst_8, %3[0] : memref<5xf32>
      affine.store %cst_7, %3[1] : memref<5xf32>
      affine.store %cst_6, %3[2] : memref<5xf32>
      affine.store %cst_5, %3[3] : memref<5xf32>
      affine.store %cst_4, %3[4] : memref<5xf32>
      affine.store %cst_3, %2[0] : memref<5xf32>
      affine.store %cst_2, %2[1] : memref<5xf32>
      affine.store %cst_1, %2[2] : memref<5xf32>
      affine.store %cst_0, %2[3] : memref<5xf32>
      affine.store %cst, %2[4] : memref<5xf32>
      %72 = affine.load %23[0] : memref<1xi32>
      %73 = arith.index_cast %72 : i32 to index
      %74 = memref.get_global @ntp : memref<1xi32>
      %75 = affine.load %5[0] : memref<1xi32>
      %76 = affine.load %8[0] : memref<1xi32>
      %77 = affine.load %74[0] : memref<1xi32>
      %78 = arith.index_cast %75 : i32 to index
      %79 = arith.index_cast %76 : i32 to index
      %80 = arith.index_cast %77 : i32 to index
      %81 = arith.addi %80, %c-1 : index
      %82 = memref.load %4[%81] : memref<5xf32>
      %83 = memref.load %3[%81] : memref<5xf32>
      %84 = memref.load %2[%81] : memref<5xf32>
      scf.for %arg17 = %c0 to %73 step %c1 {
        %85 = memref.load %arg10[%arg17] : memref<?xf32>
        %86 = arith.muli %arg17, %79 : index
        %87 = arith.muli %86, %78 : index
        scf.for %arg18 = %c0 to %78 step %c1 {
          %88 = arith.muli %arg18, %79 : index
          scf.for %arg19 = %c0 to %79 step %c1 {
            %89 = arith.addi %arg19, %88 : index
            %90 = arith.addi %89, %87 : index
            %91 = memref.load %arg11[%89] : memref<?xf32>
            %92 = memref.load %arg4[%89] : memref<?xf32>
            %93 = arith.mulf %85, %92 : f32
            %94 = arith.divf %93, %83 : f32
            %95 = math.exp %94 : f32
            %96 = arith.mulf %82, %95 : f32
            %97 = arith.subf %cst_6, %82 : f32
            %98 = arith.divf %93, %84 : f32
            %99 = math.exp %98 : f32
            %100 = arith.mulf %97, %99 : f32
            %101 = arith.addf %96, %100 : f32
            %102 = arith.mulf %91, %101 : f32
            memref.store %102, %arg16[%90] : memref<?xf32>
          } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    }
    %43 = affine.load %arg3[0] : memref<?xi32>
    %44 = arith.cmpi eq, %43, %c1_i32 : i32
    scf.if %44 {
      %72 = affine.load %5[0] : memref<1xi32>
      %73 = arith.index_cast %72 : i32 to index
      %74 = affine.load %8[0] : memref<1xi32>
      %75 = affine.load %14[0] : memref<1xf32>
      %76 = affine.load %arg14[0] : memref<?xf32>
      %77 = arith.index_cast %74 : i32 to index
      %78 = arith.negf %75 : f32
      %79 = arith.negf %76 : f32
      scf.for %arg17 = %c0 to %73 step %c1 {
        %80 = arith.muli %arg17, %77 : index
        scf.for %arg18 = %c0 to %77 step %c1 {
          %81 = arith.addi %arg18, %80 : index
          %82 = memref.load %arg7[%81] : memref<?xf32>
          %83 = arith.subf %82, %cst_6 : f32
          %84 = arith.divf %82, %83 : f32
          memref.store %84, %arg12[%81] : memref<?xf32>
          %85 = memref.load %arg1[%81] : memref<?xf32>
          %86 = arith.mulf %78, %85 : f32
          %87 = memref.load %arg4[%81] : memref<?xf32>
          %88 = arith.mulf %79, %87 : f32
          %89 = arith.divf %86, %88 : f32
          %90 = memref.load %arg0[%81] : memref<?xf32>
          %91 = arith.subf %89, %90 : f32
          memref.store %91, %arg13[%81] : memref<?xf32>
          %92 = memref.load %arg13[%81] : memref<?xf32>
          %93 = memref.load %arg7[%81] : memref<?xf32>
          %94 = arith.subf %93, %cst_6 : f32
          %95 = arith.divf %92, %94 : f32
          memref.store %95, %arg13[%81] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } else {
      %72 = affine.load %arg3[0] : memref<?xi32>
      %73 = arith.cmpi eq, %72, %c2_i32 : i32
      scf.if %73 {
        %74 = affine.load %5[0] : memref<1xi32>
        %75 = arith.index_cast %74 : i32 to index
        %76 = affine.load %8[0] : memref<1xi32>
        %77 = affine.load %14[0] : memref<1xf32>
        %78 = affine.load %arg14[0] : memref<?xf32>
        %79 = arith.index_cast %76 : i32 to index
        %80 = arith.muli %79, %75 : index
        scf.for %arg17 = %c0 to %75 step %c1 {
          %81 = arith.muli %arg17, %79 : index
          scf.for %arg18 = %c0 to %79 step %c1 {
            %82 = arith.addi %arg18, %81 : index
            %83 = memref.load %arg7[%82] : memref<?xf32>
            %84 = arith.subf %83, %cst_6 : f32
            %85 = arith.divf %83, %84 : f32
            memref.store %85, %arg12[%82] : memref<?xf32>
            %86 = memref.load %arg1[%82] : memref<?xf32>
            %87 = memref.load %arg16[%82] : memref<?xf32>
            %88 = arith.addf %86, %87 : f32
            %89 = arith.addi %82, %80 : index
            %90 = memref.load %arg16[%89] : memref<?xf32>
            %91 = arith.subf %88, %90 : f32
            %92 = arith.mulf %77, %91 : f32
            %93 = memref.load %arg4[%82] : memref<?xf32>
            %94 = arith.mulf %78, %93 : f32
            %95 = arith.divf %92, %94 : f32
            %96 = memref.load %arg0[%82] : memref<?xf32>
            %97 = arith.subf %95, %96 : f32
            memref.store %97, %arg13[%82] : memref<?xf32>
            %98 = memref.load %arg13[%82] : memref<?xf32>
            %99 = memref.load %arg7[%82] : memref<?xf32>
            %100 = arith.subf %99, %cst_6 : f32
            %101 = arith.divf %98, %100 : f32
            memref.store %101, %arg13[%82] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } else {
        %74 = affine.load %arg3[0] : memref<?xi32>
        %75 = arith.cmpi eq, %74, %c3_i32 : i32
        %76 = scf.if %75 -> (i1) {
          scf.yield %true : i1
        } else {
          %77 = affine.load %arg3[0] : memref<?xi32>
          %78 = arith.cmpi eq, %77, %c4_i32 : i32
          scf.yield %78 : i1
        }
        scf.if %76 {
          %77 = affine.load %5[0] : memref<1xi32>
          %78 = arith.index_cast %77 : i32 to index
          %79 = affine.load %8[0] : memref<1xi32>
          %80 = arith.index_cast %79 : i32 to index
          scf.for %arg17 = %c0 to %78 step %c1 {
            %81 = arith.muli %arg17, %80 : index
            scf.for %arg18 = %c0 to %80 step %c1 {
              %82 = arith.addi %arg18, %81 : index
              memref.store %cst_14, %arg12[%82] : memref<?xf32>
              %83 = memref.load %arg2[%82] : memref<?xf32>
              memref.store %83, %arg13[%82] : memref<?xf32>
            } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        }
      }
    }
    %45 = affine.load %11[0] : memref<1xi32>
    %46 = arith.index_cast %45 : i32 to index
    %47 = affine.load %5[0] : memref<1xi32>
    %48 = affine.load %8[0] : memref<1xi32>
    %49 = affine.load %14[0] : memref<1xf32>
    %50 = arith.index_cast %47 : i32 to index
    %51 = arith.index_cast %48 : i32 to index
    affine.for %arg17 = 1 to %46 {
      %72 = affine.load %arg14[%arg17] : memref<?xf32>
      affine.for %arg18 = 0 to %50 {
        affine.for %arg19 = 0 to %51 {
          %73 = affine.load %arg7[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %74 = affine.load %arg9[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %75 = affine.load %arg12[%arg19 + %arg18 * symbol(%51) + ((%arg17 - 1) * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %76 = arith.subf %cst_6, %75 : f32
          %77 = arith.mulf %74, %76 : f32
          %78 = arith.addf %73, %77 : f32
          %79 = arith.subf %78, %cst_6 : f32
          %80 = arith.divf %cst_6, %79 : f32
          affine.store %80, %arg13[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %81 = affine.load %arg7[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %82 = affine.load %arg13[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %83 = arith.mulf %81, %82 : f32
          affine.store %83, %arg12[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %84 = affine.load %arg9[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %85 = affine.load %arg13[%arg19 + %arg18 * symbol(%51) + ((%arg17 - 1) * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %86 = arith.mulf %84, %85 : f32
          %87 = affine.load %arg0[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %88 = arith.subf %86, %87 : f32
          %89 = affine.load %arg16[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %90 = affine.load %arg16[%arg19 + %arg18 * symbol(%51) + ((%arg17 + 1) * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %91 = arith.subf %89, %90 : f32
          %92 = arith.mulf %49, %91 : f32
          %93 = affine.load %arg4[%arg19 + %arg18 * symbol(%51)] : memref<?xf32>
          %94 = arith.mulf %93, %72 : f32
          %95 = arith.divf %92, %94 : f32
          %96 = arith.addf %88, %95 : f32
          %97 = affine.load %arg13[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
          %98 = arith.mulf %96, %97 : f32
          affine.store %98, %arg13[%arg19 + %arg18 * symbol(%51) + (%arg17 * symbol(%51)) * symbol(%50)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm2"}
    %52 = affine.load %5[0] : memref<1xi32>
    %53 = arith.index_cast %52 : i32 to index
    %54 = affine.load %8[0] : memref<1xi32>
    %55 = affine.load %11[0] : memref<1xi32>
    %56 = affine.load %14[0] : memref<1xf32>
    %57 = affine.load %33[0] : memref<1xi32>
    %58 = arith.index_cast %54 : i32 to index
    %59 = arith.index_cast %55 : i32 to index
    %60 = arith.muli %59, %58 : index
    %61 = arith.muli %60, %53 : index
    %62 = arith.addi %59, %c-1 : index
    %63 = arith.muli %62, %58 : index
    %64 = arith.muli %63, %53 : index
    %65 = arith.index_cast %57 : i32 to index
    %66 = arith.addi %65, %c-1 : index
    %67 = arith.muli %66, %58 : index
    %68 = arith.muli %67, %53 : index
    %69 = affine.load %arg14[symbol(%59)] : memref<?xf32>
    affine.for %arg17 = 0 to %53 {
      affine.for %arg18 = 0 to %58 {
        %72 = affine.load %arg9[%arg18 + %arg17 * symbol(%58) + symbol(%61)] : memref<?xf32>
        %73 = affine.load %arg13[%arg18 + %arg17 * symbol(%58) + symbol(%64)] : memref<?xf32>
        %74 = arith.mulf %72, %73 : f32
        %75 = affine.load %arg0[%arg18 + %arg17 * symbol(%58) + symbol(%61)] : memref<?xf32>
        %76 = arith.subf %74, %75 : f32
        %77 = affine.load %arg16[%arg18 + %arg17 * symbol(%58) + symbol(%61)] : memref<?xf32>
        %78 = affine.load %arg16[%arg18 + %arg17 * symbol(%58) + symbol(%68)] : memref<?xf32>
        %79 = arith.subf %77, %78 : f32
        %80 = arith.mulf %56, %79 : f32
        %81 = affine.load %arg4[%arg18 + %arg17 * symbol(%58)] : memref<?xf32>
        %82 = arith.mulf %81, %69 : f32
        %83 = arith.divf %80, %82 : f32
        %84 = arith.addf %76, %83 : f32
        %85 = affine.load %arg12[%arg18 + %arg17 * symbol(%58) + symbol(%64)] : memref<?xf32>
        %86 = arith.subf %cst_6, %85 : f32
        %87 = arith.mulf %72, %86 : f32
        %88 = arith.subf %87, %cst_6 : f32
        %89 = arith.divf %84, %88 : f32
        affine.store %89, %arg0[%arg18 + %arg17 * symbol(%58) + symbol(%61)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %70 = affine.load %33[0] : memref<1xi32>
    %71 = arith.addi %70, %c-3_i32 : i32
    affine.store %71, %0[] : memref<i32>
    scf.while : () -> () {
      %72 = affine.load %0[] : memref<i32>
      %73 = arith.cmpi sge, %72, %c0_i32 : i32
      scf.condition(%73)
    } do {
      %72 = affine.load %5[0] : memref<1xi32>
      %73 = arith.index_cast %72 : i32 to index
      %74 = affine.load %8[0] : memref<1xi32>
      %75 = affine.load %0[] : memref<i32>
      %76 = arith.index_cast %74 : i32 to index
      %77 = arith.muli %75, %74 : i32
      %78 = arith.muli %77, %72 : i32
      %79 = arith.addi %75, %c1_i32 : i32
      %80 = arith.muli %79, %74 : i32
      %81 = arith.muli %80, %72 : i32
      scf.for %arg17 = %c0 to %73 step %c1 {
        %84 = arith.index_cast %arg17 : index to i32
        %85 = arith.muli %84, %74 : i32
        scf.for %arg18 = %c0 to %76 step %c1 {
          %86 = arith.index_cast %arg18 : index to i32
          %87 = arith.addi %86, %85 : i32
          %88 = arith.addi %87, %78 : i32
          %89 = arith.index_cast %88 : i32 to index
          %90 = memref.load %arg12[%89] : memref<?xf32>
          %91 = arith.addi %87, %81 : i32
          %92 = arith.index_cast %91 : i32 to index
          %93 = memref.load %arg0[%92] : memref<?xf32>
          %94 = arith.mulf %90, %93 : f32
          %95 = memref.load %arg13[%89] : memref<?xf32>
          %96 = arith.addf %94, %95 : f32
          memref.store %96, %arg0[%89] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      %82 = affine.load %0[] : memref<i32>
      %83 = arith.addi %82, %c-1_i32 : i32
      affine.store %83, %0[] : memref<i32>
      scf.yield
    }
    return
  }
}

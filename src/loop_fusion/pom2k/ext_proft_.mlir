module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @ntp : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_proft_(%arg0: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "wfsurf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fsurf", polygeist.type = "float *"}, %arg3: memref<?xi32> {polygeist.name = "nbc", polygeist.type = "int *"}, %arg4: memref<?xf32> {polygeist.name = "dh", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "kh", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "z", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "swrad", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "rad2", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c4 = arith.constant 4 : index
    %c3 = arith.constant 3 : index
    %c2 = arith.constant 2 : index
    %0 = llvm.mlir.undef : i32
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
    %alloca = memref.alloca() : memref<i32>
    memref.store %0, %alloca[] : memref<i32>
    %alloca_15 = memref.alloca() {polygeist.name = "ad2"} : memref<5xf32>
    %alloca_16 = memref.alloca() {polygeist.name = "ad1"} : memref<5xf32>
    %alloca_17 = memref.alloca() {polygeist.name = "r"} : memref<5xf32>
    %1 = memref.get_global @jm : memref<1xi32>
    %2 = memref.load %1[%c0] : memref<1xi32>
    %3 = arith.index_cast %2 : i32 to index
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %4[%c0] : memref<1xi32>
    %6 = arith.index_cast %5 : i32 to index
    scf.for %arg17 = %c0 to %3 step %c1 {
      scf.for %arg18 = %c0 to %6 step %c1 {
        %68 = arith.muli %arg17, %6 overflow<nsw> : index
        %69 = arith.addi %arg18, %68 : index
        %70 = memref.load %arg5[%69] : memref<?xf32>
        %71 = memref.load %arg6[%69] : memref<?xf32>
        %72 = arith.addf %70, %71 : f32
        memref.store %72, %arg4[%69] : memref<?xf32>
      }
    }
    %7 = memref.get_global @kbm2 : memref<1xi32>
    %8 = memref.load %7[%c0] : memref<1xi32>
    %9 = arith.index_cast %8 : i32 to index
    %10 = memref.get_global @dti2 : memref<1xf32>
    %11 = memref.get_global @umol : memref<1xf32>
    %12 = memref.load %1[%c0] : memref<1xi32>
    %13 = memref.load %4[%c0] : memref<1xi32>
    %14 = memref.load %10[%c0] : memref<1xf32>
    %15 = memref.load %11[%c0] : memref<1xf32>
    %16 = arith.index_cast %12 : i32 to index
    %17 = arith.index_cast %13 : i32 to index
    %18 = arith.negf %14 : f32
    scf.for %arg17 = %c0 to %9 step %c1 {
      %68 = memref.load %arg14[%arg17] : memref<?xf32>
      %69 = memref.load %arg15[%arg17] : memref<?xf32>
      %70 = arith.mulf %68, %69 : f32
      scf.for %arg18 = %c0 to %16 step %c1 {
        scf.for %arg19 = %c0 to %17 step %c1 {
          %71 = arith.muli %arg18, %17 overflow<nsw> : index
          %72 = arith.addi %arg19, %71 : index
          %73 = arith.addi %arg17, %c1 : index
          %74 = arith.muli %73, %17 overflow<nsw> : index
          %75 = arith.muli %74, %16 overflow<nsw> : index
          %76 = arith.addi %72, %75 : index
          %77 = memref.load %arg8[%76] : memref<?xf32>
          %78 = arith.addf %77, %15 : f32
          %79 = arith.mulf %18, %78 : f32
          %80 = memref.load %arg4[%72] : memref<?xf32>
          %81 = arith.mulf %70, %80 : f32
          %82 = arith.mulf %81, %80 : f32
          %83 = arith.divf %79, %82 : f32
          %84 = arith.muli %arg17, %17 overflow<nsw> : index
          %85 = arith.muli %84, %16 overflow<nsw> : index
          %86 = arith.addi %72, %85 : index
          memref.store %83, %arg7[%86] : memref<?xf32>
        }
      }
    }
    %19 = memref.get_global @kbm1 : memref<1xi32>
    %20 = memref.load %19[%c0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.load %1[%c0] : memref<1xi32>
    %23 = memref.load %4[%c0] : memref<1xi32>
    %24 = memref.load %10[%c0] : memref<1xf32>
    %25 = memref.load %11[%c0] : memref<1xf32>
    %26 = arith.index_cast %22 : i32 to index
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.negf %24 : f32
    scf.for %arg17 = %c1 to %21 step %c1 {
      %68 = memref.load %arg14[%arg17] : memref<?xf32>
      %69 = arith.addi %arg17, %c-1 : index
      %70 = memref.load %arg15[%69] : memref<?xf32>
      %71 = arith.mulf %68, %70 : f32
      scf.for %arg18 = %c0 to %26 step %c1 {
        scf.for %arg19 = %c0 to %27 step %c1 {
          %72 = arith.muli %arg18, %27 overflow<nsw> : index
          %73 = arith.addi %arg19, %72 : index
          %74 = arith.muli %arg17, %27 overflow<nsw> : index
          %75 = arith.muli %74, %26 overflow<nsw> : index
          %76 = arith.addi %73, %75 : index
          %77 = memref.load %arg8[%76] : memref<?xf32>
          %78 = arith.addf %77, %25 : f32
          %79 = arith.mulf %28, %78 : f32
          %80 = memref.load %arg4[%73] : memref<?xf32>
          %81 = arith.mulf %71, %80 : f32
          %82 = arith.mulf %81, %80 : f32
          %83 = arith.divf %79, %82 : f32
          memref.store %83, %arg9[%76] : memref<?xf32>
        }
      }
    }
    %29 = memref.get_global @kb : memref<1xi32>
    %30 = memref.load %29[%c0] : memref<1xi32>
    %31 = arith.index_cast %30 : i32 to index
    %32 = memref.load %1[%c0] : memref<1xi32>
    %33 = memref.load %4[%c0] : memref<1xi32>
    %34 = arith.index_cast %32 : i32 to index
    %35 = arith.index_cast %33 : i32 to index
    scf.for %arg17 = %c0 to %31 step %c1 {
      scf.for %arg18 = %c0 to %34 step %c1 {
        scf.for %arg19 = %c0 to %35 step %c1 {
          %68 = arith.muli %arg18, %35 overflow<nsw> : index
          %69 = arith.addi %arg19, %68 : index
          %70 = arith.muli %arg17, %35 overflow<nsw> : index
          %71 = arith.muli %70, %34 overflow<nsw> : index
          %72 = arith.addi %69, %71 : index
          memref.store %cst_14, %arg16[%72] : memref<?xf32>
        }
      }
    }
    %36 = memref.load %arg3[%c0] : memref<?xi32>
    %37 = arith.cmpi eq, %36, %c2_i32 : i32
    %38 = scf.if %37 -> (i1) {
      scf.yield %true : i1
    } else {
      %68 = arith.cmpi eq, %36, %c4_i32 : i32
      scf.yield %68 : i1
    }
    scf.if %38 {
      memref.store %cst_13, %alloca_17[%c0] : memref<5xf32>
      memref.store %cst_12, %alloca_17[%c1] : memref<5xf32>
      memref.store %cst_11, %alloca_17[%c2] : memref<5xf32>
      memref.store %cst_10, %alloca_17[%c3] : memref<5xf32>
      memref.store %cst_9, %alloca_17[%c4] : memref<5xf32>
      memref.store %cst_8, %alloca_16[%c0] : memref<5xf32>
      memref.store %cst_7, %alloca_16[%c1] : memref<5xf32>
      memref.store %cst_6, %alloca_16[%c2] : memref<5xf32>
      memref.store %cst_5, %alloca_16[%c3] : memref<5xf32>
      memref.store %cst_4, %alloca_16[%c4] : memref<5xf32>
      memref.store %cst_3, %alloca_15[%c0] : memref<5xf32>
      memref.store %cst_2, %alloca_15[%c1] : memref<5xf32>
      memref.store %cst_1, %alloca_15[%c2] : memref<5xf32>
      memref.store %cst_0, %alloca_15[%c3] : memref<5xf32>
      memref.store %cst, %alloca_15[%c4] : memref<5xf32>
      %68 = memref.load %19[%c0] : memref<1xi32>
      %69 = arith.index_cast %68 : i32 to index
      %70 = memref.get_global @ntp : memref<1xi32>
      %71 = memref.load %1[%c0] : memref<1xi32>
      %72 = memref.load %4[%c0] : memref<1xi32>
      %73 = memref.load %70[%c0] : memref<1xi32>
      %74 = arith.index_cast %71 : i32 to index
      %75 = arith.index_cast %72 : i32 to index
      %76 = arith.index_cast %73 : i32 to index
      %77 = arith.addi %76, %c-1 : index
      %78 = memref.load %alloca_17[%77] : memref<5xf32>
      %79 = memref.load %alloca_16[%77] : memref<5xf32>
      %80 = memref.load %alloca_15[%77] : memref<5xf32>
      %81 = arith.subf %cst_6, %78 : f32
      scf.for %arg17 = %c0 to %69 step %c1 {
        %82 = memref.load %arg10[%arg17] : memref<?xf32>
        %83 = arith.muli %arg17, %75 : index
        %84 = arith.muli %83, %74 : index
        scf.for %arg18 = %c0 to %74 step %c1 {
          %85 = arith.muli %arg18, %75 : index
          scf.for %arg19 = %c0 to %75 step %c1 {
            %86 = arith.addi %arg19, %85 : index
            %87 = arith.addi %86, %84 : index
            %88 = memref.load %arg11[%86] : memref<?xf32>
            %89 = memref.load %arg4[%86] : memref<?xf32>
            %90 = arith.mulf %82, %89 : f32
            %91 = arith.divf %90, %79 : f32
            %92 = math.exp %91 : f32
            %93 = arith.mulf %78, %92 : f32
            %94 = arith.divf %90, %80 : f32
            %95 = math.exp %94 : f32
            %96 = arith.mulf %81, %95 : f32
            %97 = arith.addf %93, %96 : f32
            %98 = arith.mulf %88, %97 : f32
            memref.store %98, %arg16[%87] : memref<?xf32>
          } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    }
    %39 = memref.load %arg3[%c0] : memref<?xi32>
    %40 = arith.cmpi eq, %39, %c1_i32 : i32
    scf.if %40 {
      %68 = memref.load %1[%c0] : memref<1xi32>
      %69 = arith.index_cast %68 : i32 to index
      %70 = memref.load %4[%c0] : memref<1xi32>
      %71 = memref.load %10[%c0] : memref<1xf32>
      %72 = memref.load %arg14[%c0] : memref<?xf32>
      %73 = arith.index_cast %70 : i32 to index
      %74 = arith.negf %71 : f32
      %75 = arith.negf %72 : f32
      scf.for %arg17 = %c0 to %69 step %c1 {
        %76 = arith.muli %arg17, %73 : index
        scf.for %arg18 = %c0 to %73 step %c1 {
          %77 = arith.addi %arg18, %76 : index
          %78 = memref.load %arg7[%77] : memref<?xf32>
          %79 = arith.subf %78, %cst_6 : f32
          %80 = arith.divf %78, %79 : f32
          memref.store %80, %arg12[%77] : memref<?xf32>
          %81 = memref.load %arg1[%77] : memref<?xf32>
          %82 = arith.mulf %74, %81 : f32
          %83 = memref.load %arg4[%77] : memref<?xf32>
          %84 = arith.mulf %75, %83 : f32
          %85 = arith.divf %82, %84 : f32
          %86 = memref.load %arg0[%77] : memref<?xf32>
          %87 = arith.subf %85, %86 : f32
          memref.store %87, %arg13[%77] : memref<?xf32>
          %88 = memref.load %arg13[%77] : memref<?xf32>
          %89 = memref.load %arg7[%77] : memref<?xf32>
          %90 = arith.subf %89, %cst_6 : f32
          %91 = arith.divf %88, %90 : f32
          memref.store %91, %arg13[%77] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } else {
      %68 = memref.load %arg3[%c0] : memref<?xi32>
      %69 = arith.cmpi eq, %68, %c2_i32 : i32
      scf.if %69 {
        %70 = memref.load %1[%c0] : memref<1xi32>
        %71 = arith.index_cast %70 : i32 to index
        %72 = memref.load %4[%c0] : memref<1xi32>
        %73 = memref.load %10[%c0] : memref<1xf32>
        %74 = memref.load %arg14[%c0] : memref<?xf32>
        %75 = arith.index_cast %72 : i32 to index
        %76 = arith.muli %75, %71 : index
        scf.for %arg17 = %c0 to %71 step %c1 {
          %77 = arith.muli %arg17, %75 : index
          scf.for %arg18 = %c0 to %75 step %c1 {
            %78 = arith.addi %arg18, %77 : index
            %79 = memref.load %arg7[%78] : memref<?xf32>
            %80 = arith.subf %79, %cst_6 : f32
            %81 = arith.divf %79, %80 : f32
            memref.store %81, %arg12[%78] : memref<?xf32>
            %82 = memref.load %arg1[%78] : memref<?xf32>
            %83 = memref.load %arg16[%78] : memref<?xf32>
            %84 = arith.addf %82, %83 : f32
            %85 = arith.addi %78, %76 : index
            %86 = memref.load %arg16[%85] : memref<?xf32>
            %87 = arith.subf %84, %86 : f32
            %88 = arith.mulf %73, %87 : f32
            %89 = memref.load %arg4[%78] : memref<?xf32>
            %90 = arith.mulf %74, %89 : f32
            %91 = arith.divf %88, %90 : f32
            %92 = memref.load %arg0[%78] : memref<?xf32>
            %93 = arith.subf %91, %92 : f32
            memref.store %93, %arg13[%78] : memref<?xf32>
            %94 = memref.load %arg13[%78] : memref<?xf32>
            %95 = memref.load %arg7[%78] : memref<?xf32>
            %96 = arith.subf %95, %cst_6 : f32
            %97 = arith.divf %94, %96 : f32
            memref.store %97, %arg13[%78] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } else {
        %70 = memref.load %arg3[%c0] : memref<?xi32>
        %71 = arith.cmpi eq, %70, %c3_i32 : i32
        %72 = scf.if %71 -> (i1) {
          scf.yield %true : i1
        } else {
          %73 = arith.cmpi eq, %70, %c4_i32 : i32
          scf.yield %73 : i1
        }
        scf.if %72 {
          %73 = memref.load %1[%c0] : memref<1xi32>
          %74 = arith.index_cast %73 : i32 to index
          %75 = memref.load %4[%c0] : memref<1xi32>
          %76 = arith.index_cast %75 : i32 to index
          scf.for %arg17 = %c0 to %74 step %c1 {
            %77 = arith.muli %arg17, %76 : index
            scf.for %arg18 = %c0 to %76 step %c1 {
              %78 = arith.addi %arg18, %77 : index
              memref.store %cst_14, %arg12[%78] : memref<?xf32>
              %79 = memref.load %arg2[%78] : memref<?xf32>
              memref.store %79, %arg13[%78] : memref<?xf32>
            } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        }
      }
    }
    %41 = memref.load %7[%c0] : memref<1xi32>
    %42 = arith.index_cast %41 : i32 to index
    %43 = memref.load %1[%c0] : memref<1xi32>
    %44 = memref.load %4[%c0] : memref<1xi32>
    %45 = memref.load %10[%c0] : memref<1xf32>
    %46 = arith.index_cast %43 : i32 to index
    %47 = arith.index_cast %44 : i32 to index
    scf.for %arg17 = %c1 to %42 step %c1 {
      %68 = memref.load %arg14[%arg17] : memref<?xf32>
      scf.for %arg18 = %c0 to %46 step %c1 {
        scf.for %arg19 = %c0 to %47 step %c1 {
          %69 = arith.muli %arg18, %47 overflow<nsw> : index
          %70 = arith.addi %arg19, %69 : index
          %71 = arith.muli %arg17, %47 overflow<nsw> : index
          %72 = arith.muli %71, %46 overflow<nsw> : index
          %73 = arith.addi %70, %72 : index
          %74 = memref.load %arg7[%73] : memref<?xf32>
          %75 = memref.load %arg9[%73] : memref<?xf32>
          %76 = arith.addi %arg17, %c-1 : index
          %77 = arith.muli %76, %47 overflow<nsw> : index
          %78 = arith.muli %77, %46 overflow<nsw> : index
          %79 = arith.addi %70, %78 : index
          %80 = memref.load %arg12[%79] : memref<?xf32>
          %81 = arith.subf %cst_6, %80 : f32
          %82 = arith.mulf %75, %81 : f32
          %83 = arith.addf %74, %82 : f32
          %84 = arith.subf %83, %cst_6 : f32
          %85 = arith.divf %cst_6, %84 : f32
          memref.store %85, %arg13[%73] : memref<?xf32>
          %86 = memref.load %arg7[%73] : memref<?xf32>
          %87 = memref.load %arg13[%73] : memref<?xf32>
          %88 = arith.mulf %86, %87 : f32
          memref.store %88, %arg12[%73] : memref<?xf32>
          %89 = memref.load %arg9[%73] : memref<?xf32>
          %90 = memref.load %arg13[%79] : memref<?xf32>
          %91 = arith.mulf %89, %90 : f32
          %92 = memref.load %arg0[%73] : memref<?xf32>
          %93 = arith.subf %91, %92 : f32
          %94 = memref.load %arg16[%73] : memref<?xf32>
          %95 = arith.addi %arg17, %c1 : index
          %96 = arith.muli %95, %47 overflow<nsw> : index
          %97 = arith.muli %96, %46 overflow<nsw> : index
          %98 = arith.addi %70, %97 : index
          %99 = memref.load %arg16[%98] : memref<?xf32>
          %100 = arith.subf %94, %99 : f32
          %101 = arith.mulf %45, %100 : f32
          %102 = memref.load %arg4[%70] : memref<?xf32>
          %103 = arith.mulf %102, %68 : f32
          %104 = arith.divf %101, %103 : f32
          %105 = arith.addf %93, %104 : f32
          %106 = memref.load %arg13[%73] : memref<?xf32>
          %107 = arith.mulf %105, %106 : f32
          memref.store %107, %arg13[%73] : memref<?xf32>
        }
      }
    }
    %48 = memref.load %1[%c0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    %50 = memref.load %4[%c0] : memref<1xi32>
    %51 = memref.load %7[%c0] : memref<1xi32>
    %52 = memref.load %10[%c0] : memref<1xf32>
    %53 = memref.load %29[%c0] : memref<1xi32>
    %54 = arith.index_cast %50 : i32 to index
    %55 = arith.index_cast %51 : i32 to index
    %56 = arith.muli %55, %54 : index
    %57 = arith.muli %56, %49 : index
    %58 = arith.addi %55, %c-1 : index
    %59 = arith.muli %58, %54 : index
    %60 = arith.muli %59, %49 : index
    %61 = arith.index_cast %53 : i32 to index
    %62 = arith.addi %61, %c-1 : index
    %63 = arith.muli %62, %54 : index
    %64 = arith.muli %63, %49 : index
    %65 = memref.load %arg14[%55] : memref<?xf32>
    scf.for %arg17 = %c0 to %49 step %c1 {
      scf.for %arg18 = %c0 to %54 step %c1 {
        %68 = arith.muli %arg17, %54 overflow<nsw> : index
        %69 = arith.addi %arg18, %68 : index
        %70 = arith.addi %69, %57 : index
        %71 = memref.load %arg9[%70] : memref<?xf32>
        %72 = arith.addi %69, %60 : index
        %73 = memref.load %arg13[%72] : memref<?xf32>
        %74 = arith.mulf %71, %73 : f32
        %75 = memref.load %arg0[%70] : memref<?xf32>
        %76 = arith.subf %74, %75 : f32
        %77 = memref.load %arg16[%70] : memref<?xf32>
        %78 = arith.addi %69, %64 : index
        %79 = memref.load %arg16[%78] : memref<?xf32>
        %80 = arith.subf %77, %79 : f32
        %81 = arith.mulf %52, %80 : f32
        %82 = memref.load %arg4[%69] : memref<?xf32>
        %83 = arith.mulf %82, %65 : f32
        %84 = arith.divf %81, %83 : f32
        %85 = arith.addf %76, %84 : f32
        %86 = memref.load %arg12[%72] : memref<?xf32>
        %87 = arith.subf %cst_6, %86 : f32
        %88 = arith.mulf %71, %87 : f32
        %89 = arith.subf %88, %cst_6 : f32
        %90 = arith.divf %85, %89 : f32
        memref.store %90, %arg0[%70] : memref<?xf32>
      }
    }
    %66 = memref.load %29[%c0] : memref<1xi32>
    %67 = arith.addi %66, %c-3_i32 : i32
    memref.store %67, %alloca[] : memref<i32>
    scf.while : () -> () {
      %68 = memref.load %alloca[] : memref<i32>
      %69 = arith.cmpi sge, %68, %c0_i32 : i32
      scf.condition(%69)
    } do {
      %68 = memref.load %1[%c0] : memref<1xi32>
      %69 = arith.index_cast %68 : i32 to index
      %70 = memref.load %4[%c0] : memref<1xi32>
      %71 = memref.load %alloca[] : memref<i32>
      %72 = arith.index_cast %70 : i32 to index
      %73 = arith.muli %71, %70 : i32
      %74 = arith.muli %73, %68 : i32
      %75 = arith.addi %71, %c1_i32 : i32
      %76 = arith.muli %75, %70 : i32
      %77 = arith.muli %76, %68 : i32
      scf.for %arg17 = %c0 to %69 step %c1 {
        %79 = arith.index_cast %arg17 : index to i32
        %80 = arith.muli %79, %70 : i32
        scf.for %arg18 = %c0 to %72 step %c1 {
          %81 = arith.index_cast %arg18 : index to i32
          %82 = arith.addi %81, %80 : i32
          %83 = arith.addi %82, %74 : i32
          %84 = arith.index_cast %83 : i32 to index
          %85 = memref.load %arg12[%84] : memref<?xf32>
          %86 = arith.addi %82, %77 : i32
          %87 = arith.index_cast %86 : i32 to index
          %88 = memref.load %arg0[%87] : memref<?xf32>
          %89 = arith.mulf %85, %88 : f32
          %90 = memref.load %arg13[%84] : memref<?xf32>
          %91 = arith.addf %89, %90 : f32
          memref.store %91, %arg0[%84] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      %78 = arith.addi %71, %c-1_i32 : i32
      memref.store %78, %alloca[] : memref<i32>
      scf.yield
    }
    return
  }
}


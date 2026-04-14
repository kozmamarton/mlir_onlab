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
        %70 = arith.muli %arg17, %6 overflow<nsw> : index
        %71 = arith.addi %arg18, %70 : index
        %72 = memref.load %arg5[%71] : memref<?xf32>
        %73 = memref.load %arg6[%71] : memref<?xf32>
        %74 = arith.addf %72, %73 : f32
        memref.store %74, %arg4[%71] : memref<?xf32>
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
      %70 = memref.load %arg14[%arg17] : memref<?xf32>
      %71 = memref.load %arg15[%arg17] : memref<?xf32>
      %72 = arith.mulf %70, %71 : f32
      scf.for %arg18 = %c0 to %16 step %c1 {
        scf.for %arg19 = %c0 to %17 step %c1 {
          %73 = arith.muli %arg18, %17 overflow<nsw> : index
          %74 = arith.addi %arg19, %73 : index
          %75 = arith.addi %arg17, %c1 : index
          %76 = arith.muli %75, %17 overflow<nsw> : index
          %77 = arith.muli %76, %16 overflow<nsw> : index
          %78 = arith.addi %74, %77 : index
          %79 = memref.load %arg8[%78] : memref<?xf32>
          %80 = arith.addf %79, %15 : f32
          %81 = arith.mulf %18, %80 : f32
          %82 = memref.load %arg4[%74] : memref<?xf32>
          %83 = arith.mulf %72, %82 : f32
          %84 = arith.mulf %83, %82 : f32
          %85 = arith.divf %81, %84 : f32
          %86 = arith.muli %arg17, %17 overflow<nsw> : index
          %87 = arith.muli %86, %16 overflow<nsw> : index
          %88 = arith.addi %74, %87 : index
          memref.store %85, %arg7[%88] : memref<?xf32>
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
    %29 = arith.addi %21, %c-1 : index
    scf.for %arg17 = %c0 to %29 step %c1 {
      %70 = arith.addi %arg17, %c1 : index
      %71 = memref.load %arg14[%70] : memref<?xf32>
      %72 = memref.load %arg15[%arg17] : memref<?xf32>
      %73 = arith.mulf %71, %72 : f32
      scf.for %arg18 = %c0 to %26 step %c1 {
        scf.for %arg19 = %c0 to %27 step %c1 {
          %74 = arith.muli %arg18, %27 overflow<nsw> : index
          %75 = arith.addi %arg19, %74 : index
          %76 = arith.muli %70, %27 overflow<nsw> : index
          %77 = arith.muli %76, %26 overflow<nsw> : index
          %78 = arith.addi %75, %77 : index
          %79 = memref.load %arg8[%78] : memref<?xf32>
          %80 = arith.addf %79, %25 : f32
          %81 = arith.mulf %28, %80 : f32
          %82 = memref.load %arg4[%75] : memref<?xf32>
          %83 = arith.mulf %73, %82 : f32
          %84 = arith.mulf %83, %82 : f32
          %85 = arith.divf %81, %84 : f32
          memref.store %85, %arg9[%78] : memref<?xf32>
        }
      }
    }
    %30 = memref.get_global @kb : memref<1xi32>
    %31 = memref.load %30[%c0] : memref<1xi32>
    %32 = arith.index_cast %31 : i32 to index
    %33 = memref.load %1[%c0] : memref<1xi32>
    %34 = memref.load %4[%c0] : memref<1xi32>
    %35 = arith.index_cast %33 : i32 to index
    %36 = arith.index_cast %34 : i32 to index
    scf.for %arg17 = %c0 to %32 step %c1 {
      scf.for %arg18 = %c0 to %35 step %c1 {
        scf.for %arg19 = %c0 to %36 step %c1 {
          %70 = arith.muli %arg18, %36 overflow<nsw> : index
          %71 = arith.addi %arg19, %70 : index
          %72 = arith.muli %arg17, %36 overflow<nsw> : index
          %73 = arith.muli %72, %35 overflow<nsw> : index
          %74 = arith.addi %71, %73 : index
          memref.store %cst_14, %arg16[%74] : memref<?xf32>
        }
      }
    }
    %37 = memref.load %arg3[%c0] : memref<?xi32>
    %38 = arith.cmpi eq, %37, %c2_i32 : i32
    %39 = scf.if %38 -> (i1) {
      scf.yield %true : i1
    } else {
      %70 = arith.cmpi eq, %37, %c4_i32 : i32
      scf.yield %70 : i1
    }
    scf.if %39 {
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
      %70 = memref.load %19[%c0] : memref<1xi32>
      %71 = arith.index_cast %70 : i32 to index
      %72 = memref.get_global @ntp : memref<1xi32>
      %73 = memref.load %1[%c0] : memref<1xi32>
      %74 = memref.load %4[%c0] : memref<1xi32>
      %75 = memref.load %72[%c0] : memref<1xi32>
      %76 = arith.index_cast %73 : i32 to index
      %77 = arith.index_cast %74 : i32 to index
      %78 = arith.index_cast %75 : i32 to index
      %79 = arith.addi %78, %c-1 : index
      %80 = memref.load %alloca_17[%79] : memref<5xf32>
      %81 = memref.load %alloca_16[%79] : memref<5xf32>
      %82 = memref.load %alloca_15[%79] : memref<5xf32>
      %83 = arith.subf %cst_6, %80 : f32
      scf.for %arg17 = %c0 to %71 step %c1 {
        %84 = memref.load %arg10[%arg17] : memref<?xf32>
        %85 = arith.muli %arg17, %77 : index
        %86 = arith.muli %85, %76 : index
        scf.for %arg18 = %c0 to %76 step %c1 {
          %87 = arith.muli %arg18, %77 : index
          scf.for %arg19 = %c0 to %77 step %c1 {
            %88 = arith.addi %arg19, %87 : index
            %89 = arith.addi %88, %86 : index
            %90 = memref.load %arg11[%88] : memref<?xf32>
            %91 = memref.load %arg4[%88] : memref<?xf32>
            %92 = arith.mulf %84, %91 : f32
            %93 = arith.divf %92, %81 : f32
            %94 = math.exp %93 : f32
            %95 = arith.mulf %80, %94 : f32
            %96 = arith.divf %92, %82 : f32
            %97 = math.exp %96 : f32
            %98 = arith.mulf %83, %97 : f32
            %99 = arith.addf %95, %98 : f32
            %100 = arith.mulf %90, %99 : f32
            memref.store %100, %arg16[%89] : memref<?xf32>
          } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    }
    %40 = memref.load %arg3[%c0] : memref<?xi32>
    %41 = arith.cmpi eq, %40, %c1_i32 : i32
    scf.if %41 {
      %70 = memref.load %1[%c0] : memref<1xi32>
      %71 = arith.index_cast %70 : i32 to index
      %72 = memref.load %4[%c0] : memref<1xi32>
      %73 = memref.load %10[%c0] : memref<1xf32>
      %74 = memref.load %arg14[%c0] : memref<?xf32>
      %75 = arith.index_cast %72 : i32 to index
      %76 = arith.negf %73 : f32
      %77 = arith.negf %74 : f32
      scf.for %arg17 = %c0 to %71 step %c1 {
        %78 = arith.muli %arg17, %75 : index
        scf.for %arg18 = %c0 to %75 step %c1 {
          %79 = arith.addi %arg18, %78 : index
          %80 = memref.load %arg7[%79] : memref<?xf32>
          %81 = arith.subf %80, %cst_6 : f32
          %82 = arith.divf %80, %81 : f32
          memref.store %82, %arg12[%79] : memref<?xf32>
          %83 = memref.load %arg1[%79] : memref<?xf32>
          %84 = arith.mulf %76, %83 : f32
          %85 = memref.load %arg4[%79] : memref<?xf32>
          %86 = arith.mulf %77, %85 : f32
          %87 = arith.divf %84, %86 : f32
          %88 = memref.load %arg0[%79] : memref<?xf32>
          %89 = arith.subf %87, %88 : f32
          memref.store %89, %arg13[%79] : memref<?xf32>
          %90 = memref.load %arg13[%79] : memref<?xf32>
          %91 = memref.load %arg7[%79] : memref<?xf32>
          %92 = arith.subf %91, %cst_6 : f32
          %93 = arith.divf %90, %92 : f32
          memref.store %93, %arg13[%79] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } else {
      %70 = memref.load %arg3[%c0] : memref<?xi32>
      %71 = arith.cmpi eq, %70, %c2_i32 : i32
      scf.if %71 {
        %72 = memref.load %1[%c0] : memref<1xi32>
        %73 = arith.index_cast %72 : i32 to index
        %74 = memref.load %4[%c0] : memref<1xi32>
        %75 = memref.load %10[%c0] : memref<1xf32>
        %76 = memref.load %arg14[%c0] : memref<?xf32>
        %77 = arith.index_cast %74 : i32 to index
        %78 = arith.muli %77, %73 : index
        scf.for %arg17 = %c0 to %73 step %c1 {
          %79 = arith.muli %arg17, %77 : index
          scf.for %arg18 = %c0 to %77 step %c1 {
            %80 = arith.addi %arg18, %79 : index
            %81 = memref.load %arg7[%80] : memref<?xf32>
            %82 = arith.subf %81, %cst_6 : f32
            %83 = arith.divf %81, %82 : f32
            memref.store %83, %arg12[%80] : memref<?xf32>
            %84 = memref.load %arg1[%80] : memref<?xf32>
            %85 = memref.load %arg16[%80] : memref<?xf32>
            %86 = arith.addf %84, %85 : f32
            %87 = arith.addi %80, %78 : index
            %88 = memref.load %arg16[%87] : memref<?xf32>
            %89 = arith.subf %86, %88 : f32
            %90 = arith.mulf %75, %89 : f32
            %91 = memref.load %arg4[%80] : memref<?xf32>
            %92 = arith.mulf %76, %91 : f32
            %93 = arith.divf %90, %92 : f32
            %94 = memref.load %arg0[%80] : memref<?xf32>
            %95 = arith.subf %93, %94 : f32
            memref.store %95, %arg13[%80] : memref<?xf32>
            %96 = memref.load %arg13[%80] : memref<?xf32>
            %97 = memref.load %arg7[%80] : memref<?xf32>
            %98 = arith.subf %97, %cst_6 : f32
            %99 = arith.divf %96, %98 : f32
            memref.store %99, %arg13[%80] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } else {
        %72 = memref.load %arg3[%c0] : memref<?xi32>
        %73 = arith.cmpi eq, %72, %c3_i32 : i32
        %74 = scf.if %73 -> (i1) {
          scf.yield %true : i1
        } else {
          %75 = arith.cmpi eq, %72, %c4_i32 : i32
          scf.yield %75 : i1
        }
        scf.if %74 {
          %75 = memref.load %1[%c0] : memref<1xi32>
          %76 = arith.index_cast %75 : i32 to index
          %77 = memref.load %4[%c0] : memref<1xi32>
          %78 = arith.index_cast %77 : i32 to index
          scf.for %arg17 = %c0 to %76 step %c1 {
            %79 = arith.muli %arg17, %78 : index
            scf.for %arg18 = %c0 to %78 step %c1 {
              %80 = arith.addi %arg18, %79 : index
              memref.store %cst_14, %arg12[%80] : memref<?xf32>
              %81 = memref.load %arg2[%80] : memref<?xf32>
              memref.store %81, %arg13[%80] : memref<?xf32>
            } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        }
      }
    }
    %42 = memref.load %7[%c0] : memref<1xi32>
    %43 = arith.index_cast %42 : i32 to index
    %44 = memref.load %1[%c0] : memref<1xi32>
    %45 = memref.load %4[%c0] : memref<1xi32>
    %46 = memref.load %10[%c0] : memref<1xf32>
    %47 = arith.index_cast %44 : i32 to index
    %48 = arith.index_cast %45 : i32 to index
    %49 = arith.addi %43, %c-1 : index
    scf.for %arg17 = %c0 to %49 step %c1 {
      %70 = arith.addi %arg17, %c1 : index
      %71 = memref.load %arg14[%70] : memref<?xf32>
      scf.for %arg18 = %c0 to %47 step %c1 {
        scf.for %arg19 = %c0 to %48 step %c1 {
          %72 = arith.muli %arg18, %48 overflow<nsw> : index
          %73 = arith.addi %arg19, %72 : index
          %74 = arith.muli %70, %48 overflow<nsw> : index
          %75 = arith.muli %74, %47 overflow<nsw> : index
          %76 = arith.addi %73, %75 : index
          %77 = memref.load %arg7[%76] : memref<?xf32>
          %78 = memref.load %arg9[%76] : memref<?xf32>
          %79 = arith.muli %arg17, %48 overflow<nsw> : index
          %80 = arith.muli %79, %47 overflow<nsw> : index
          %81 = arith.addi %73, %80 : index
          %82 = memref.load %arg12[%81] : memref<?xf32>
          %83 = arith.subf %cst_6, %82 : f32
          %84 = arith.mulf %78, %83 : f32
          %85 = arith.addf %77, %84 : f32
          %86 = arith.subf %85, %cst_6 : f32
          %87 = arith.divf %cst_6, %86 : f32
          memref.store %87, %arg13[%76] : memref<?xf32>
          %88 = memref.load %arg7[%76] : memref<?xf32>
          %89 = memref.load %arg13[%76] : memref<?xf32>
          %90 = arith.mulf %88, %89 : f32
          memref.store %90, %arg12[%76] : memref<?xf32>
          %91 = memref.load %arg9[%76] : memref<?xf32>
          %92 = memref.load %arg13[%81] : memref<?xf32>
          %93 = arith.mulf %91, %92 : f32
          %94 = memref.load %arg0[%76] : memref<?xf32>
          %95 = arith.subf %93, %94 : f32
          %96 = memref.load %arg16[%76] : memref<?xf32>
          %97 = arith.addi %arg17, %c2 : index
          %98 = arith.muli %97, %48 overflow<nsw> : index
          %99 = arith.muli %98, %47 overflow<nsw> : index
          %100 = arith.addi %73, %99 : index
          %101 = memref.load %arg16[%100] : memref<?xf32>
          %102 = arith.subf %96, %101 : f32
          %103 = arith.mulf %46, %102 : f32
          %104 = memref.load %arg4[%73] : memref<?xf32>
          %105 = arith.mulf %104, %71 : f32
          %106 = arith.divf %103, %105 : f32
          %107 = arith.addf %95, %106 : f32
          %108 = memref.load %arg13[%76] : memref<?xf32>
          %109 = arith.mulf %107, %108 : f32
          memref.store %109, %arg13[%76] : memref<?xf32>
        }
      }
    }
    %50 = memref.load %1[%c0] : memref<1xi32>
    %51 = arith.index_cast %50 : i32 to index
    %52 = memref.load %4[%c0] : memref<1xi32>
    %53 = memref.load %7[%c0] : memref<1xi32>
    %54 = memref.load %10[%c0] : memref<1xf32>
    %55 = memref.load %30[%c0] : memref<1xi32>
    %56 = arith.index_cast %52 : i32 to index
    %57 = arith.index_cast %53 : i32 to index
    %58 = arith.muli %57, %56 : index
    %59 = arith.muli %58, %51 : index
    %60 = arith.addi %57, %c-1 : index
    %61 = arith.muli %60, %56 : index
    %62 = arith.muli %61, %51 : index
    %63 = arith.index_cast %55 : i32 to index
    %64 = arith.addi %63, %c-1 : index
    %65 = arith.muli %64, %56 : index
    %66 = arith.muli %65, %51 : index
    %67 = memref.load %arg14[%57] : memref<?xf32>
    scf.for %arg17 = %c0 to %51 step %c1 {
      scf.for %arg18 = %c0 to %56 step %c1 {
        %70 = arith.muli %arg17, %56 overflow<nsw> : index
        %71 = arith.addi %arg18, %70 : index
        %72 = arith.addi %71, %59 : index
        %73 = memref.load %arg9[%72] : memref<?xf32>
        %74 = arith.addi %71, %62 : index
        %75 = memref.load %arg13[%74] : memref<?xf32>
        %76 = arith.mulf %73, %75 : f32
        %77 = memref.load %arg0[%72] : memref<?xf32>
        %78 = arith.subf %76, %77 : f32
        %79 = memref.load %arg16[%72] : memref<?xf32>
        %80 = arith.addi %71, %66 : index
        %81 = memref.load %arg16[%80] : memref<?xf32>
        %82 = arith.subf %79, %81 : f32
        %83 = arith.mulf %54, %82 : f32
        %84 = memref.load %arg4[%71] : memref<?xf32>
        %85 = arith.mulf %84, %67 : f32
        %86 = arith.divf %83, %85 : f32
        %87 = arith.addf %78, %86 : f32
        %88 = memref.load %arg12[%74] : memref<?xf32>
        %89 = arith.subf %cst_6, %88 : f32
        %90 = arith.mulf %73, %89 : f32
        %91 = arith.subf %90, %cst_6 : f32
        %92 = arith.divf %87, %91 : f32
        memref.store %92, %arg0[%72] : memref<?xf32>
      }
    }
    %68 = memref.load %30[%c0] : memref<1xi32>
    %69 = arith.addi %68, %c-3_i32 : i32
    memref.store %69, %alloca[] : memref<i32>
    scf.while : () -> () {
      %70 = memref.load %alloca[] : memref<i32>
      %71 = arith.cmpi sge, %70, %c0_i32 : i32
      scf.condition(%71)
    } do {
      %70 = memref.load %1[%c0] : memref<1xi32>
      %71 = arith.index_cast %70 : i32 to index
      %72 = memref.load %4[%c0] : memref<1xi32>
      %73 = memref.load %alloca[] : memref<i32>
      %74 = arith.index_cast %72 : i32 to index
      %75 = arith.muli %73, %72 : i32
      %76 = arith.muli %75, %70 : i32
      %77 = arith.addi %73, %c1_i32 : i32
      %78 = arith.muli %77, %72 : i32
      %79 = arith.muli %78, %70 : i32
      scf.for %arg17 = %c0 to %71 step %c1 {
        %81 = arith.index_cast %arg17 : index to i32
        %82 = arith.muli %81, %72 : i32
        scf.for %arg18 = %c0 to %74 step %c1 {
          %83 = arith.index_cast %arg18 : index to i32
          %84 = arith.addi %83, %82 : i32
          %85 = arith.addi %84, %76 : i32
          %86 = arith.index_cast %85 : i32 to index
          %87 = memref.load %arg12[%86] : memref<?xf32>
          %88 = arith.addi %84, %79 : i32
          %89 = arith.index_cast %88 : i32 to index
          %90 = memref.load %arg0[%89] : memref<?xf32>
          %91 = arith.mulf %87, %90 : f32
          %92 = memref.load %arg13[%86] : memref<?xf32>
          %93 = arith.addf %91, %92 : f32
          memref.store %93, %arg0[%86] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      %80 = arith.addi %73, %c-1_i32 : i32
      memref.store %80, %alloca[] : memref<i32>
      scf.yield
    }
    return
  }
}


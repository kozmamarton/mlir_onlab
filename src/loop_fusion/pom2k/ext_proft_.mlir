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
    %reinterpret_cast = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%3, %6], strides: [%6, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%3, %6) step (%c1, %c1) {
      %67 = memref.load %reinterpret_cast[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %68 = memref.load %reinterpret_cast_18[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %69 = arith.addf %67, %68 : f32
      memref.store %69, %reinterpret_cast_19[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
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
    %19 = arith.muli %17, %16 : index
    %reinterpret_cast_20 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%9, %16, %17], strides: [%19, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%16, %17], strides: [%17, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%9, %16, %17], strides: [%19, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg17) = (%c0) to (%9) step (%c1) {
      %67 = memref.load %arg14[%arg17] : memref<?xf32>
      %68 = memref.load %arg15[%arg17] : memref<?xf32>
      %69 = arith.mulf %67, %68 : f32
      scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%16, %17) step (%c1, %c1) {
        %70 = arith.addi %arg17, %c1 : index
        %71 = memref.load %reinterpret_cast_20[%70, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %72 = arith.addf %71, %15 : f32
        %73 = arith.mulf %18, %72 : f32
        %74 = memref.load %reinterpret_cast_21[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %75 = arith.mulf %69, %74 : f32
        %76 = arith.mulf %75, %74 : f32
        %77 = arith.divf %73, %76 : f32
        memref.store %77, %reinterpret_cast_22[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
      scf.reduce 
    }
    %20 = memref.get_global @kbm1 : memref<1xi32>
    %21 = memref.load %20[%c0] : memref<1xi32>
    %22 = arith.index_cast %21 : i32 to index
    %23 = memref.load %1[%c0] : memref<1xi32>
    %24 = memref.load %4[%c0] : memref<1xi32>
    %25 = memref.load %10[%c0] : memref<1xf32>
    %26 = memref.load %11[%c0] : memref<1xf32>
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.negf %25 : f32
    %30 = arith.muli %28, %27 : index
    %reinterpret_cast_23 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%22, %27, %28], strides: [%30, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_24 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%27, %28], strides: [%28, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%22, %27, %28], strides: [%30, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %31 = memref.get_global @kb : memref<1xi32>
    %32 = memref.load %31[%c0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %reinterpret_cast_26 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%33, %27, %28], strides: [%30, %28, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg17, %arg18, %arg19) = (%c0, %c0, %c0) to (%33, %27, %28) step (%c1, %c1, %c1) {
      memref.store %cst_14, %reinterpret_cast_26[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %34 = memref.load %arg3[%c0] : memref<?xi32>
    %35 = arith.cmpi eq, %34, %c2_i32 : i32
    %36 = scf.if %35 -> (i1) {
      scf.yield %true : i1
    } else {
      %67 = arith.cmpi eq, %34, %c4_i32 : i32
      scf.yield %67 : i1
    }
    scf.if %36 {
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
      %67 = memref.load %20[%c0] : memref<1xi32>
      %68 = arith.index_cast %67 : i32 to index
      %69 = memref.get_global @ntp : memref<1xi32>
      %70 = memref.load %1[%c0] : memref<1xi32>
      %71 = memref.load %4[%c0] : memref<1xi32>
      %72 = memref.load %69[%c0] : memref<1xi32>
      %73 = arith.index_cast %70 : i32 to index
      %74 = arith.index_cast %71 : i32 to index
      %75 = arith.index_cast %72 : i32 to index
      %76 = arith.addi %75, %c-1 : index
      %77 = memref.load %alloca_17[%76] : memref<5xf32>
      %78 = memref.load %alloca_16[%76] : memref<5xf32>
      %79 = memref.load %alloca_15[%76] : memref<5xf32>
      %80 = arith.subf %cst_6, %77 : f32
      scf.for %arg17 = %c0 to %68 step %c1 {
        %81 = memref.load %arg10[%arg17] : memref<?xf32>
        %82 = arith.muli %arg17, %74 : index
        %83 = arith.muli %82, %73 : index
        scf.for %arg18 = %c0 to %73 step %c1 {
          %84 = arith.muli %arg18, %74 : index
          scf.for %arg19 = %c0 to %74 step %c1 {
            %85 = arith.addi %arg19, %84 : index
            %86 = arith.addi %85, %83 : index
            %87 = memref.load %arg11[%85] : memref<?xf32>
            %88 = memref.load %arg4[%85] : memref<?xf32>
            %89 = arith.mulf %81, %88 : f32
            %90 = arith.divf %89, %78 : f32
            %91 = math.exp %90 : f32
            %92 = arith.mulf %77, %91 : f32
            %93 = arith.divf %89, %79 : f32
            %94 = math.exp %93 : f32
            %95 = arith.mulf %80, %94 : f32
            %96 = arith.addf %92, %95 : f32
            %97 = arith.mulf %87, %96 : f32
            memref.store %97, %arg16[%86] : memref<?xf32>
          } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    }
    %37 = memref.load %arg3[%c0] : memref<?xi32>
    %38 = arith.cmpi eq, %37, %c1_i32 : i32
    scf.if %38 {
      %67 = memref.load %1[%c0] : memref<1xi32>
      %68 = arith.index_cast %67 : i32 to index
      %69 = memref.load %4[%c0] : memref<1xi32>
      %70 = memref.load %10[%c0] : memref<1xf32>
      %71 = memref.load %arg14[%c0] : memref<?xf32>
      %72 = arith.index_cast %69 : i32 to index
      %73 = arith.negf %70 : f32
      %74 = arith.negf %71 : f32
      scf.for %arg17 = %c0 to %68 step %c1 {
        %75 = arith.muli %arg17, %72 : index
        scf.for %arg18 = %c0 to %72 step %c1 {
          %76 = arith.addi %arg18, %75 : index
          %77 = memref.load %arg7[%76] : memref<?xf32>
          %78 = arith.subf %77, %cst_6 : f32
          %79 = arith.divf %77, %78 : f32
          memref.store %79, %arg12[%76] : memref<?xf32>
          %80 = memref.load %arg1[%76] : memref<?xf32>
          %81 = arith.mulf %73, %80 : f32
          %82 = memref.load %arg4[%76] : memref<?xf32>
          %83 = arith.mulf %74, %82 : f32
          %84 = arith.divf %81, %83 : f32
          %85 = memref.load %arg0[%76] : memref<?xf32>
          %86 = arith.subf %84, %85 : f32
          memref.store %86, %arg13[%76] : memref<?xf32>
          %87 = memref.load %arg13[%76] : memref<?xf32>
          %88 = memref.load %arg7[%76] : memref<?xf32>
          %89 = arith.subf %88, %cst_6 : f32
          %90 = arith.divf %87, %89 : f32
          memref.store %90, %arg13[%76] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } else {
      %67 = memref.load %arg3[%c0] : memref<?xi32>
      %68 = arith.cmpi eq, %67, %c2_i32 : i32
      scf.if %68 {
        %69 = memref.load %1[%c0] : memref<1xi32>
        %70 = arith.index_cast %69 : i32 to index
        %71 = memref.load %4[%c0] : memref<1xi32>
        %72 = memref.load %10[%c0] : memref<1xf32>
        %73 = memref.load %arg14[%c0] : memref<?xf32>
        %74 = arith.index_cast %71 : i32 to index
        %75 = arith.muli %74, %70 : index
        scf.for %arg17 = %c0 to %70 step %c1 {
          %76 = arith.muli %arg17, %74 : index
          scf.for %arg18 = %c0 to %74 step %c1 {
            %77 = arith.addi %arg18, %76 : index
            %78 = memref.load %arg7[%77] : memref<?xf32>
            %79 = arith.subf %78, %cst_6 : f32
            %80 = arith.divf %78, %79 : f32
            memref.store %80, %arg12[%77] : memref<?xf32>
            %81 = memref.load %arg1[%77] : memref<?xf32>
            %82 = memref.load %arg16[%77] : memref<?xf32>
            %83 = arith.addf %81, %82 : f32
            %84 = arith.addi %77, %75 : index
            %85 = memref.load %arg16[%84] : memref<?xf32>
            %86 = arith.subf %83, %85 : f32
            %87 = arith.mulf %72, %86 : f32
            %88 = memref.load %arg4[%77] : memref<?xf32>
            %89 = arith.mulf %73, %88 : f32
            %90 = arith.divf %87, %89 : f32
            %91 = memref.load %arg0[%77] : memref<?xf32>
            %92 = arith.subf %90, %91 : f32
            memref.store %92, %arg13[%77] : memref<?xf32>
            %93 = memref.load %arg13[%77] : memref<?xf32>
            %94 = memref.load %arg7[%77] : memref<?xf32>
            %95 = arith.subf %94, %cst_6 : f32
            %96 = arith.divf %93, %95 : f32
            memref.store %96, %arg13[%77] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } else {
        %69 = memref.load %arg3[%c0] : memref<?xi32>
        %70 = arith.cmpi eq, %69, %c3_i32 : i32
        %71 = scf.if %70 -> (i1) {
          scf.yield %true : i1
        } else {
          %72 = arith.cmpi eq, %69, %c4_i32 : i32
          scf.yield %72 : i1
        }
        scf.if %71 {
          %72 = memref.load %1[%c0] : memref<1xi32>
          %73 = arith.index_cast %72 : i32 to index
          %74 = memref.load %4[%c0] : memref<1xi32>
          %75 = arith.index_cast %74 : i32 to index
          scf.for %arg17 = %c0 to %73 step %c1 {
            %76 = arith.muli %arg17, %75 : index
            scf.for %arg18 = %c0 to %75 step %c1 {
              %77 = arith.addi %arg18, %76 : index
              memref.store %cst_14, %arg12[%77] : memref<?xf32>
              %78 = memref.load %arg2[%77] : memref<?xf32>
              memref.store %78, %arg13[%77] : memref<?xf32>
            } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        }
      }
    }
    %39 = memref.load %7[%c0] : memref<1xi32>
    %40 = arith.index_cast %39 : i32 to index
    %41 = memref.load %1[%c0] : memref<1xi32>
    %42 = memref.load %4[%c0] : memref<1xi32>
    %43 = memref.load %10[%c0] : memref<1xf32>
    %44 = arith.index_cast %41 : i32 to index
    %45 = arith.index_cast %42 : i32 to index
    %46 = arith.muli %45, %44 : index
    %reinterpret_cast_27 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%40, %44, %45], strides: [%46, %45, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_28 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%40, %44, %45], strides: [%46, %45, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_29 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%40, %44, %45], strides: [%46, %45, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_30 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%40, %44, %45], strides: [%46, %45, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_31 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%40, %44, %45], strides: [%46, %45, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_32 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%40, %44, %45], strides: [%46, %45, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_33 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%44, %45], strides: [%45, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg17 = %c1 to %40 step %c1 {
      %67 = memref.load %arg14[%arg17] : memref<?xf32>
      %68 = arith.addi %arg17, %c-1 : index
      %69 = memref.load %arg15[%68] : memref<?xf32>
      %70 = arith.mulf %67, %69 : f32
      scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%27, %28) step (%c1, %c1) {
        %72 = memref.load %reinterpret_cast_23[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %73 = arith.addf %72, %26 : f32
        %74 = arith.mulf %29, %73 : f32
        %75 = memref.load %reinterpret_cast_24[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %76 = arith.mulf %70, %75 : f32
        %77 = arith.mulf %76, %75 : f32
        %78 = arith.divf %74, %77 : f32
        memref.store %78, %reinterpret_cast_25[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
      %71 = memref.load %arg14[%arg17] : memref<?xf32>
      scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%44, %45) step (%c1, %c1) {
        %72 = memref.load %reinterpret_cast_27[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %73 = memref.load %reinterpret_cast_28[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %74 = memref.load %reinterpret_cast_29[%68, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %75 = arith.subf %cst_6, %74 : f32
        %76 = arith.mulf %73, %75 : f32
        %77 = arith.addf %72, %76 : f32
        %78 = arith.subf %77, %cst_6 : f32
        %79 = arith.divf %cst_6, %78 : f32
        memref.store %79, %reinterpret_cast_30[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %80 = memref.load %reinterpret_cast_27[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %81 = arith.mulf %80, %79 : f32
        memref.store %81, %reinterpret_cast_29[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %82 = memref.load %reinterpret_cast_28[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %83 = memref.load %reinterpret_cast_30[%68, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %84 = arith.mulf %82, %83 : f32
        %85 = memref.load %reinterpret_cast_31[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %86 = arith.subf %84, %85 : f32
        %87 = memref.load %reinterpret_cast_32[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %88 = arith.addi %arg17, %c1 : index
        %89 = memref.load %reinterpret_cast_32[%88, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %90 = arith.subf %87, %89 : f32
        %91 = arith.mulf %43, %90 : f32
        %92 = memref.load %reinterpret_cast_33[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %93 = arith.mulf %92, %71 : f32
        %94 = arith.divf %91, %93 : f32
        %95 = arith.addf %86, %94 : f32
        %96 = memref.load %reinterpret_cast_30[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %97 = arith.mulf %95, %96 : f32
        memref.store %97, %reinterpret_cast_30[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %47 = memref.load %1[%c0] : memref<1xi32>
    %48 = arith.index_cast %47 : i32 to index
    %49 = memref.load %4[%c0] : memref<1xi32>
    %50 = memref.load %7[%c0] : memref<1xi32>
    %51 = memref.load %10[%c0] : memref<1xf32>
    %52 = memref.load %31[%c0] : memref<1xi32>
    %53 = arith.index_cast %49 : i32 to index
    %54 = arith.index_cast %50 : i32 to index
    %55 = arith.muli %54, %53 : index
    %56 = arith.muli %55, %48 : index
    %57 = arith.addi %54, %c-1 : index
    %58 = arith.muli %57, %53 : index
    %59 = arith.muli %58, %48 : index
    %60 = arith.index_cast %52 : i32 to index
    %61 = arith.addi %60, %c-1 : index
    %62 = arith.muli %61, %53 : index
    %63 = arith.muli %62, %48 : index
    %64 = memref.load %arg14[%54] : memref<?xf32>
    %reinterpret_cast_34 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%48, %53], strides: [%53, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg17 = %c0 to %48 step %c1 {
      scf.for %arg18 = %c0 to %53 step %c1 {
        %67 = arith.muli %arg17, %53 overflow<nsw> : index
        %68 = arith.addi %arg18, %67 : index
        %69 = arith.addi %68, %56 : index
        %70 = memref.load %arg9[%69] : memref<?xf32>
        %71 = arith.addi %68, %59 : index
        %72 = memref.load %arg13[%71] : memref<?xf32>
        %73 = arith.mulf %70, %72 : f32
        %74 = memref.load %arg0[%69] : memref<?xf32>
        %75 = arith.subf %73, %74 : f32
        %76 = memref.load %arg16[%69] : memref<?xf32>
        %77 = arith.addi %68, %63 : index
        %78 = memref.load %arg16[%77] : memref<?xf32>
        %79 = arith.subf %76, %78 : f32
        %80 = arith.mulf %51, %79 : f32
        %81 = memref.load %reinterpret_cast_34[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
        %82 = arith.mulf %81, %64 : f32
        %83 = arith.divf %80, %82 : f32
        %84 = arith.addf %75, %83 : f32
        %85 = memref.load %arg12[%71] : memref<?xf32>
        %86 = arith.subf %cst_6, %85 : f32
        %87 = arith.mulf %70, %86 : f32
        %88 = arith.subf %87, %cst_6 : f32
        %89 = arith.divf %84, %88 : f32
        memref.store %89, %arg0[%69] : memref<?xf32>
      }
    }
    %65 = memref.load %31[%c0] : memref<1xi32>
    %66 = arith.addi %65, %c-3_i32 : i32
    memref.store %66, %alloca[] : memref<i32>
    scf.while : () -> () {
      %67 = memref.load %alloca[] : memref<i32>
      %68 = arith.cmpi sge, %67, %c0_i32 : i32
      scf.condition(%68)
    } do {
      %67 = memref.load %1[%c0] : memref<1xi32>
      %68 = arith.index_cast %67 : i32 to index
      %69 = memref.load %4[%c0] : memref<1xi32>
      %70 = memref.load %alloca[] : memref<i32>
      %71 = arith.index_cast %69 : i32 to index
      %72 = arith.muli %70, %69 : i32
      %73 = arith.muli %72, %67 : i32
      %74 = arith.addi %70, %c1_i32 : i32
      %75 = arith.muli %74, %69 : i32
      %76 = arith.muli %75, %67 : i32
      scf.for %arg17 = %c0 to %68 step %c1 {
        %78 = arith.index_cast %arg17 : index to i32
        %79 = arith.muli %78, %69 : i32
        scf.for %arg18 = %c0 to %71 step %c1 {
          %80 = arith.index_cast %arg18 : index to i32
          %81 = arith.addi %80, %79 : i32
          %82 = arith.addi %81, %73 : i32
          %83 = arith.index_cast %82 : i32 to index
          %84 = memref.load %arg12[%83] : memref<?xf32>
          %85 = arith.addi %81, %76 : i32
          %86 = arith.index_cast %85 : i32 to index
          %87 = memref.load %arg0[%86] : memref<?xf32>
          %88 = arith.mulf %84, %87 : f32
          %89 = memref.load %arg13[%83] : memref<?xf32>
          %90 = arith.addf %88, %89 : f32
          memref.store %90, %arg0[%83] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      %77 = arith.addi %70, %c-1_i32 : i32
      memref.store %77, %alloca[] : memref<i32>
      scf.yield
    }
    return
  }
}


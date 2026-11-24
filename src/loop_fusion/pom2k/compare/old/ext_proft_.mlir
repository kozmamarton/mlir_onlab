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
    %alloca_15 = memref.alloca() {polygeist.name = "ad2"} : memref<5xf32>
    %alloca_16 = memref.alloca() {polygeist.name = "ad1"} : memref<5xf32>
    %alloca_17 = memref.alloca() {polygeist.name = "r"} : memref<5xf32>
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_18 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg17, %arg18) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      %35 = memref.load %reinterpret_cast[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %36 = memref.load %reinterpret_cast_18[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      %37 = arith.addf %35, %36 : f32
      memref.store %37, %reinterpret_cast_19[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %6 = memref.get_global @kbm2 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.get_global @dti2 : memref<1xf32>
    %10 = memref.get_global @umol : memref<1xf32>
    %11 = memref.load %9[%c0] : memref<1xf32>
    %12 = memref.load %10[%c0] : memref<1xf32>
    %13 = arith.negf %11 : f32
    %14 = arith.muli %5, %2 : index
    %reinterpret_cast_20 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg17, %arg18, %arg19) = (%c0, %c0, %c0) to (%8, %2, %5) step (%c1, %c1, %c1) {
      %35 = memref.load %arg14[%arg17] : memref<?xf32>
      %36 = memref.load %arg15[%arg17] : memref<?xf32>
      %37 = arith.mulf %35, %36 : f32
      %38 = arith.addi %arg17, %c1 : index
      %39 = memref.load %reinterpret_cast_20[%38, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %40 = arith.addf %39, %12 : f32
      %41 = arith.mulf %13, %40 : f32
      %42 = memref.load %reinterpret_cast_19[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %43 = arith.mulf %37, %42 : f32
      %44 = arith.mulf %43, %42 : f32
      %45 = arith.divf %41, %44 : f32
      memref.store %45, %reinterpret_cast_21[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %15 = memref.get_global @kbm1 : memref<1xi32>
    %16 = memref.load %15[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @kb : memref<1xi32>
    %19 = memref.load %18[%c0] : memref<1xi32>
    %20 = arith.index_cast %19 : i32 to index
    %reinterpret_cast_22 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%17, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%17, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg17, %arg18, %arg19) = (%c1, %c0, %c0) to (%17, %2, %5) step (%c1, %c1, %c1) {
      %35 = memref.load %arg14[%arg17] : memref<?xf32>
      %36 = arith.addi %arg17, %c-1 : index
      %37 = memref.load %arg15[%36] : memref<?xf32>
      %38 = arith.mulf %35, %37 : f32
      %39 = memref.load %reinterpret_cast_22[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %40 = arith.addf %39, %12 : f32
      %41 = arith.mulf %13, %40 : f32
      %42 = memref.load %reinterpret_cast_19[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
      %43 = arith.mulf %38, %42 : f32
      %44 = arith.mulf %43, %42 : f32
      %45 = arith.divf %41, %44 : f32
      memref.store %45, %reinterpret_cast_23[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %reinterpret_cast_24 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%20, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg17, %arg18, %arg19) = (%c0, %c0, %c0) to (%20, %2, %5) step (%c1, %c1, %c1) {
      memref.store %cst_14, %reinterpret_cast_24[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %21 = memref.load %arg3[%c0] : memref<?xi32>
    %22 = arith.cmpi eq, %21, %c2_i32 : i32
    %23 = scf.if %22 -> (i1) {
      scf.yield %true : i1
    } else {
      %35 = arith.cmpi eq, %21, %c4_i32 : i32
      scf.yield %35 : i1
    }
    scf.if %23 {
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
      %35 = memref.get_global @ntp : memref<1xi32>
      %36 = memref.load %35[%c0] : memref<1xi32>
      %37 = arith.index_cast %36 : i32 to index
      %38 = arith.addi %37, %c-1 : index
      %39 = memref.load %alloca_17[%38] : memref<5xf32>
      %40 = memref.load %alloca_16[%38] : memref<5xf32>
      %41 = memref.load %alloca_15[%38] : memref<5xf32>
      %42 = arith.subf %cst_6, %39 : f32
      scf.for %arg17 = %c0 to %17 step %c1 {
        %43 = memref.load %arg10[%arg17] : memref<?xf32>
        %44 = arith.muli %arg17, %5 : index
        %45 = arith.muli %44, %2 : index
        scf.for %arg18 = %c0 to %2 step %c1 {
          %46 = arith.muli %arg18, %5 : index
          scf.for %arg19 = %c0 to %5 step %c1 {
            %47 = arith.addi %arg19, %46 : index
            %48 = arith.addi %47, %45 : index
            %49 = memref.load %arg11[%47] : memref<?xf32>
            %50 = memref.load %arg4[%47] : memref<?xf32>
            %51 = arith.mulf %43, %50 : f32
            %52 = arith.divf %51, %40 : f32
            %53 = math.exp %52 : f32
            %54 = arith.mulf %39, %53 : f32
            %55 = arith.divf %51, %41 : f32
            %56 = math.exp %55 : f32
            %57 = arith.mulf %42, %56 : f32
            %58 = arith.addf %54, %57 : f32
            %59 = arith.mulf %49, %58 : f32
            memref.store %59, %arg16[%48] : memref<?xf32>
          } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } {constants = [{name = "ad1", non_scalar = false, type = "f32"}, {name = "ad2", non_scalar = false, type = "f32"}, {name = "r", non_scalar = false, type = "f32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    }
    %24 = arith.cmpi eq, %21, %c1_i32 : i32
    scf.if %24 {
      %35 = memref.load %arg14[%c0] : memref<?xf32>
      %36 = arith.negf %35 : f32
      scf.for %arg17 = %c0 to %2 step %c1 {
        %37 = arith.muli %arg17, %5 : index
        scf.for %arg18 = %c0 to %5 step %c1 {
          %38 = arith.addi %arg18, %37 : index
          %39 = memref.load %arg7[%38] : memref<?xf32>
          %40 = arith.subf %39, %cst_6 : f32
          %41 = arith.divf %39, %40 : f32
          memref.store %41, %arg12[%38] : memref<?xf32>
          %42 = memref.load %arg1[%38] : memref<?xf32>
          %43 = arith.mulf %13, %42 : f32
          %44 = memref.load %arg4[%38] : memref<?xf32>
          %45 = arith.mulf %36, %44 : f32
          %46 = arith.divf %43, %45 : f32
          %47 = memref.load %arg0[%38] : memref<?xf32>
          %48 = arith.subf %46, %47 : f32
          memref.store %48, %arg13[%38] : memref<?xf32>
          %49 = memref.load %arg13[%38] : memref<?xf32>
          %50 = memref.load %arg7[%38] : memref<?xf32>
          %51 = arith.subf %50, %cst_6 : f32
          %52 = arith.divf %49, %51 : f32
          memref.store %52, %arg13[%38] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } else {
      scf.if %22 {
        %35 = memref.load %arg14[%c0] : memref<?xf32>
        scf.for %arg17 = %c0 to %2 step %c1 {
          %36 = arith.muli %arg17, %5 : index
          scf.for %arg18 = %c0 to %5 step %c1 {
            %37 = arith.addi %arg18, %36 : index
            %38 = memref.load %arg7[%37] : memref<?xf32>
            %39 = arith.subf %38, %cst_6 : f32
            %40 = arith.divf %38, %39 : f32
            memref.store %40, %arg12[%37] : memref<?xf32>
            %41 = memref.load %arg1[%37] : memref<?xf32>
            %42 = memref.load %arg16[%37] : memref<?xf32>
            %43 = arith.addf %41, %42 : f32
            %44 = arith.addi %37, %14 : index
            %45 = memref.load %arg16[%44] : memref<?xf32>
            %46 = arith.subf %43, %45 : f32
            %47 = arith.mulf %11, %46 : f32
            %48 = memref.load %arg4[%37] : memref<?xf32>
            %49 = arith.mulf %35, %48 : f32
            %50 = arith.divf %47, %49 : f32
            %51 = memref.load %arg0[%37] : memref<?xf32>
            %52 = arith.subf %50, %51 : f32
            memref.store %52, %arg13[%37] : memref<?xf32>
            %53 = memref.load %arg13[%37] : memref<?xf32>
            %54 = memref.load %arg7[%37] : memref<?xf32>
            %55 = arith.subf %54, %cst_6 : f32
            %56 = arith.divf %53, %55 : f32
            memref.store %56, %arg13[%37] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } else {
        %35 = arith.cmpi eq, %21, %c3_i32 : i32
        %36 = scf.if %35 -> (i1) {
          scf.yield %true : i1
        } else {
          %37 = arith.cmpi eq, %21, %c4_i32 : i32
          scf.yield %37 : i1
        }
        scf.if %36 {
          scf.for %arg17 = %c0 to %2 step %c1 {
            %37 = arith.muli %arg17, %5 : index
            scf.for %arg18 = %c0 to %5 step %c1 {
              %38 = arith.addi %arg18, %37 : index
              memref.store %cst_14, %arg12[%38] : memref<?xf32>
              %39 = memref.load %arg2[%38] : memref<?xf32>
              memref.store %39, %arg13[%38] : memref<?xf32>
            } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        }
      }
    }
    %reinterpret_cast_25 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_26 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_27 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_28 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_29 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%8, %2, %5], strides: [%14, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg17 = %c1 to %8 step %c1 {
      %35 = memref.load %arg14[%arg17] : memref<?xf32>
      scf.parallel (%arg18, %arg19) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
        %36 = memref.load %reinterpret_cast_21[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %37 = memref.load %reinterpret_cast_25[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %38 = arith.addi %arg17, %c-1 : index
        %39 = memref.load %reinterpret_cast_26[%38, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %40 = arith.subf %cst_6, %39 : f32
        %41 = arith.mulf %37, %40 : f32
        %42 = arith.addf %36, %41 : f32
        %43 = arith.subf %42, %cst_6 : f32
        %44 = arith.divf %cst_6, %43 : f32
        %45 = arith.mulf %36, %44 : f32
        memref.store %45, %reinterpret_cast_26[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %46 = memref.load %reinterpret_cast_27[%38, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %47 = arith.mulf %37, %46 : f32
        %48 = memref.load %reinterpret_cast_28[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %49 = arith.subf %47, %48 : f32
        %50 = memref.load %reinterpret_cast_29[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %51 = arith.addi %arg17, %c1 : index
        %52 = memref.load %reinterpret_cast_29[%51, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %53 = arith.subf %50, %52 : f32
        %54 = arith.mulf %11, %53 : f32
        %55 = memref.load %reinterpret_cast_19[%arg18, %arg19] : memref<?x?xf32, strided<[?, 1]>>
        %56 = arith.mulf %55, %35 : f32
        %57 = arith.divf %54, %56 : f32
        %58 = arith.addf %49, %57 : f32
        %59 = arith.mulf %58, %44 : f32
        memref.store %59, %reinterpret_cast_27[%arg17, %arg18, %arg19] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
    }
    %25 = arith.muli %8, %5 : index
    %26 = arith.muli %25, %2 : index
    %27 = arith.addi %8, %c-1 : index
    %28 = arith.muli %27, %5 : index
    %29 = arith.muli %28, %2 : index
    %30 = arith.addi %20, %c-1 : index
    %31 = arith.muli %30, %5 : index
    %32 = arith.muli %31, %2 : index
    %33 = memref.load %arg14[%8] : memref<?xf32>
    scf.for %arg17 = %c0 to %2 step %c1 {
      scf.for %arg18 = %c0 to %5 step %c1 {
        %35 = arith.muli %arg17, %5 overflow<nsw> : index
        %36 = arith.addi %arg18, %35 : index
        %37 = arith.addi %36, %26 : index
        %38 = memref.load %arg9[%37] : memref<?xf32>
        %39 = arith.addi %36, %29 : index
        %40 = memref.load %arg13[%39] : memref<?xf32>
        %41 = arith.mulf %38, %40 : f32
        %42 = memref.load %arg0[%37] : memref<?xf32>
        %43 = arith.subf %41, %42 : f32
        %44 = memref.load %arg16[%37] : memref<?xf32>
        %45 = arith.addi %36, %32 : index
        %46 = memref.load %arg16[%45] : memref<?xf32>
        %47 = arith.subf %44, %46 : f32
        %48 = arith.mulf %11, %47 : f32
        %49 = memref.load %reinterpret_cast_19[%arg17, %arg18] : memref<?x?xf32, strided<[?, 1]>>
        %50 = arith.mulf %49, %33 : f32
        %51 = arith.divf %48, %50 : f32
        %52 = arith.addf %43, %51 : f32
        %53 = memref.load %arg12[%39] : memref<?xf32>
        %54 = arith.subf %cst_6, %53 : f32
        %55 = arith.mulf %38, %54 : f32
        %56 = arith.subf %55, %cst_6 : f32
        %57 = arith.divf %52, %56 : f32
        memref.store %57, %arg0[%37] : memref<?xf32>
      }
    }
    %34 = arith.addi %19, %c-3_i32 : i32
    memref.store %34, %alloca[] : memref<i32>
    scf.while : () -> () {
      %35 = memref.load %alloca[] : memref<i32>
      %36 = arith.cmpi sge, %35, %c0_i32 : i32
      scf.condition(%36)
    } do {
      %35 = memref.load %alloca[] : memref<i32>
      %36 = arith.muli %35, %4 : i32
      %37 = arith.muli %36, %1 : i32
      %38 = arith.addi %35, %c1_i32 : i32
      %39 = arith.muli %38, %4 : i32
      %40 = arith.muli %39, %1 : i32
      scf.for %arg17 = %c0 to %2 step %c1 {
        %42 = arith.index_cast %arg17 : index to i32
        %43 = arith.muli %42, %4 : i32
        scf.for %arg18 = %c0 to %5 step %c1 {
          %44 = arith.index_cast %arg18 : index to i32
          %45 = arith.addi %44, %43 : i32
          %46 = arith.addi %45, %37 : i32
          %47 = arith.index_cast %46 : i32 to index
          %48 = memref.load %arg12[%47] : memref<?xf32>
          %49 = arith.addi %45, %40 : i32
          %50 = arith.index_cast %49 : i32 to index
          %51 = memref.load %arg0[%50] : memref<?xf32>
          %52 = arith.mulf %48, %51 : f32
          %53 = memref.load %arg13[%47] : memref<?xf32>
          %54 = arith.addf %52, %53 : f32
          memref.store %54, %arg0[%47] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      %41 = arith.addi %35, %c-1_i32 : i32
      memref.store %41, %alloca[] : memref<i32>
      scf.yield
    }
    return
  }
}


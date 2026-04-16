module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi64>>, #dlti.dl_entry<i128, dense<128> : vector<2xi64>>, #dlti.dl_entry<i1, dense<8> : vector<2xi64>>, #dlti.dl_entry<i8, dense<8> : vector<2xi64>>, #dlti.dl_entry<i16, dense<16> : vector<2xi64>>, #dlti.dl_entry<i32, dense<32> : vector<2xi64>>, #dlti.dl_entry<f16, dense<16> : vector<2xi64>>, #dlti.dl_entry<f64, dense<64> : vector<2xi64>>, #dlti.dl_entry<f128, dense<128> : vector<2xi64>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @tprni : memref<1xf32>
  memref.global @kb : memref<1xi32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advt1_(%arg0: memref<?xf32> {polygeist.name = "fb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fclim", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "zflux", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg19: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg20: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @kbm1 : memref<1xi32>
    %5 = memref.get_global @kbm2 : memref<1xi32>
    %6 = affine.load %3[0] : memref<1xi32>
    %7 = affine.load %4[0] : memref<1xi32>
    %8 = affine.load %5[0] : memref<1xi32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    %11 = arith.muli %10, %9 : index
    %12 = arith.muli %11, %2 : index
    %13 = arith.index_cast %8 : i32 to index
    %14 = arith.muli %13, %9 : index
    %15 = arith.muli %14, %2 : index
    affine.for %arg21 = 0 to %2 {
      affine.for %arg22 = 0 to %9 {
        %79 = affine.load %arg1[%arg22 + %arg21 * symbol(%9) + symbol(%15)] : memref<?xf32>
        affine.store %79, %arg1[%arg22 + %arg21 * symbol(%9) + symbol(%12)] : memref<?xf32>
        %80 = affine.load %arg0[%arg22 + %arg21 * symbol(%9) + symbol(%15)] : memref<?xf32>
        affine.store %80, %arg0[%arg22 + %arg21 * symbol(%9) + symbol(%12)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    %16 = affine.load %4[0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = affine.load %0[0] : memref<1xi32>
    %19 = affine.load %3[0] : memref<1xi32>
    %20 = arith.index_cast %18 : i32 to index
    %21 = arith.index_cast %19 : i32 to index
    affine.for %arg21 = 0 to %17 {
      affine.for %arg22 = 1 to %20 {
        affine.for %arg23 = 1 to %21 {
          %79 = affine.load %arg9[%arg23 + %arg22 * symbol(%21)] : memref<?xf32>
          %80 = affine.load %arg9[%arg23 + %arg22 * symbol(%21) - 1] : memref<?xf32>
          %81 = arith.addf %79, %80 : f32
          %82 = affine.load %arg1[%arg23 + %arg22 * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %83 = affine.load %arg1[%arg23 + %arg22 * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20) - 1] : memref<?xf32>
          %84 = arith.addf %82, %83 : f32
          %85 = arith.mulf %81, %84 : f32
          %86 = affine.load %arg7[%arg23 + %arg22 * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %87 = arith.mulf %85, %86 : f32
          %88 = arith.mulf %87, %cst_1 : f32
          affine.store %88, %arg4[%arg23 + %arg22 * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %89 = affine.load %arg9[%arg23 + %arg22 * symbol(%21)] : memref<?xf32>
          %90 = affine.load %arg9[%arg23 + (%arg22 - 1) * symbol(%21)] : memref<?xf32>
          %91 = arith.addf %89, %90 : f32
          %92 = affine.load %arg1[%arg23 + %arg22 * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %93 = affine.load %arg1[%arg23 + (%arg22 - 1) * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %94 = arith.addf %92, %93 : f32
          %95 = arith.mulf %91, %94 : f32
          %96 = affine.load %arg8[%arg23 + %arg22 * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20)] : memref<?xf32>
          %97 = arith.mulf %95, %96 : f32
          %98 = arith.mulf %97, %cst_1 : f32
          affine.store %98, %arg5[%arg23 + %arg22 * symbol(%21) + (%arg21 * symbol(%21)) * symbol(%20)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %22 = memref.get_global @kb : memref<1xi32>
    %23 = affine.load %22[0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = affine.load %0[0] : memref<1xi32>
    %26 = affine.load %3[0] : memref<1xi32>
    %27 = arith.index_cast %25 : i32 to index
    %28 = arith.index_cast %26 : i32 to index
    affine.for %arg21 = 0 to %24 {
      affine.for %arg22 = 0 to %27 {
        affine.for %arg23 = 0 to %28 {
          %79 = affine.load %arg0[%arg23 + %arg22 * symbol(%28) + (%arg21 * symbol(%28)) * symbol(%27)] : memref<?xf32>
          %80 = affine.load %arg2[%arg23 + %arg22 * symbol(%28) + (%arg21 * symbol(%28)) * symbol(%27)] : memref<?xf32>
          %81 = arith.subf %79, %80 : f32
          affine.store %81, %arg0[%arg23 + %arg22 * symbol(%28) + (%arg21 * symbol(%28)) * symbol(%27)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %29 = affine.load %4[0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = memref.get_global @tprni : memref<1xf32>
    %32 = affine.load %0[0] : memref<1xi32>
    %33 = affine.load %3[0] : memref<1xi32>
    %34 = affine.load %31[0] : memref<1xf32>
    %35 = arith.index_cast %32 : i32 to index
    %36 = arith.index_cast %33 : i32 to index
    affine.for %arg21 = 0 to %30 {
      affine.for %arg22 = 1 to %35 {
        affine.for %arg23 = 1 to %36 {
          %79 = affine.load %arg10[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %80 = affine.load %arg10[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35) - 1] : memref<?xf32>
          %81 = arith.addf %79, %80 : f32
          %82 = arith.mulf %81, %cst_0 : f32
          %83 = affine.load %arg16[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %84 = affine.load %arg16[%arg23 + %arg22 * symbol(%36) - 1] : memref<?xf32>
          %85 = arith.addf %83, %84 : f32
          %86 = arith.mulf %82, %85 : f32
          %87 = arith.mulf %86, %34 : f32
          %88 = affine.load %arg0[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %89 = affine.load %arg0[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35) - 1] : memref<?xf32>
          %90 = arith.subf %88, %89 : f32
          %91 = arith.mulf %87, %90 : f32
          %92 = affine.load %arg11[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %93 = arith.mulf %91, %92 : f32
          %94 = affine.load %arg13[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %95 = affine.load %arg13[%arg23 + %arg22 * symbol(%36) - 1] : memref<?xf32>
          %96 = arith.addf %94, %95 : f32
          %97 = arith.divf %93, %96 : f32
          %98 = affine.load %arg4[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %99 = arith.subf %98, %97 : f32
          affine.store %99, %arg4[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %100 = affine.load %arg10[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %101 = affine.load %arg10[%arg23 + (%arg22 - 1) * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %102 = arith.addf %100, %101 : f32
          %103 = arith.mulf %102, %cst_0 : f32
          %104 = affine.load %arg16[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %105 = affine.load %arg16[%arg23 + (%arg22 - 1) * symbol(%36)] : memref<?xf32>
          %106 = arith.addf %104, %105 : f32
          %107 = arith.mulf %103, %106 : f32
          %108 = arith.mulf %107, %34 : f32
          %109 = affine.load %arg0[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %110 = affine.load %arg0[%arg23 + (%arg22 - 1) * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %111 = arith.subf %109, %110 : f32
          %112 = arith.mulf %108, %111 : f32
          %113 = affine.load %arg12[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %114 = arith.mulf %112, %113 : f32
          %115 = affine.load %arg14[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %116 = affine.load %arg14[%arg23 + (%arg22 - 1) * symbol(%36)] : memref<?xf32>
          %117 = arith.addf %115, %116 : f32
          %118 = arith.divf %114, %117 : f32
          %119 = affine.load %arg5[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %120 = arith.subf %119, %118 : f32
          affine.store %120, %arg5[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %121 = affine.load %arg14[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %122 = affine.load %arg14[%arg23 + %arg22 * symbol(%36) - 1] : memref<?xf32>
          %123 = arith.addf %121, %122 : f32
          %124 = arith.mulf %123, %cst_0 : f32
          %125 = affine.load %arg4[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %126 = arith.mulf %124, %125 : f32
          affine.store %126, %arg4[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %127 = affine.load %arg13[%arg23 + %arg22 * symbol(%36)] : memref<?xf32>
          %128 = affine.load %arg13[%arg23 + (%arg22 - 1) * symbol(%36)] : memref<?xf32>
          %129 = arith.addf %127, %128 : f32
          %130 = arith.mulf %129, %cst_0 : f32
          %131 = affine.load %arg5[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
          %132 = arith.mulf %130, %131 : f32
          affine.store %132, %arg5[%arg23 + %arg22 * symbol(%36) + (%arg21 * symbol(%36)) * symbol(%35)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %37 = affine.load %22[0] : memref<1xi32>
    %38 = arith.index_cast %37 : i32 to index
    %39 = affine.load %0[0] : memref<1xi32>
    %40 = affine.load %3[0] : memref<1xi32>
    %41 = arith.index_cast %39 : i32 to index
    %42 = arith.index_cast %40 : i32 to index
    affine.for %arg21 = 0 to %38 {
      affine.for %arg22 = 0 to %41 {
        affine.for %arg23 = 0 to %42 {
          %79 = affine.load %arg2[%arg23 + %arg22 * symbol(%42) + (%arg21 * symbol(%42)) * symbol(%41)] : memref<?xf32>
          %80 = affine.load %arg0[%arg23 + %arg22 * symbol(%42) + (%arg21 * symbol(%42)) * symbol(%41)] : memref<?xf32>
          %81 = arith.addf %80, %79 : f32
          affine.store %81, %arg0[%arg23 + %arg22 * symbol(%42) + (%arg21 * symbol(%42)) * symbol(%41)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kb"}
    %43 = memref.get_global @jmm1 : memref<1xi32>
    %44 = affine.load %43[0] : memref<1xi32>
    %45 = arith.index_cast %44 : i32 to index
    %46 = memref.get_global @imm1 : memref<1xi32>
    %47 = affine.load %46[0] : memref<1xi32>
    %48 = affine.load %3[0] : memref<1xi32>
    %49 = affine.load %4[0] : memref<1xi32>
    %50 = affine.load %0[0] : memref<1xi32>
    %51 = arith.index_cast %47 : i32 to index
    %52 = arith.index_cast %48 : i32 to index
    %53 = arith.index_cast %49 : i32 to index
    %54 = arith.muli %53, %52 : index
    %55 = arith.index_cast %50 : i32 to index
    %56 = arith.muli %54, %55 : index
    affine.for %arg21 = 1 to %45 {
      affine.for %arg22 = 1 to %51 {
        %79 = affine.load %arg1[%arg22 + %arg21 * symbol(%52)] : memref<?xf32>
        %80 = affine.load %arg17[%arg22 + %arg21 * symbol(%52)] : memref<?xf32>
        %81 = arith.mulf %79, %80 : f32
        %82 = affine.load %arg18[%arg22 + %arg21 * symbol(%52)] : memref<?xf32>
        %83 = arith.mulf %81, %82 : f32
        affine.store %83, %arg6[%arg22 + %arg21 * symbol(%52)] : memref<?xf32>
        affine.store %cst, %arg6[%arg22 + %arg21 * symbol(%52) + symbol(%56)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    %57 = affine.load %4[0] : memref<1xi32>
    %58 = arith.index_cast %57 : i32 to index
    %59 = affine.load %43[0] : memref<1xi32>
    %60 = affine.load %46[0] : memref<1xi32>
    %61 = affine.load %3[0] : memref<1xi32>
    %62 = affine.load %0[0] : memref<1xi32>
    %63 = arith.index_cast %59 : i32 to index
    %64 = arith.index_cast %60 : i32 to index
    %65 = arith.index_cast %61 : i32 to index
    %66 = arith.index_cast %62 : i32 to index
    affine.for %arg21 = 1 to %58 {
      affine.for %arg22 = 1 to %63 {
        affine.for %arg23 = 1 to %64 {
          %79 = affine.load %arg1[%arg23 + %arg22 * symbol(%65) + ((%arg21 - 1) * symbol(%65)) * symbol(%66)] : memref<?xf32>
          %80 = affine.load %arg1[%arg23 + %arg22 * symbol(%65) + (%arg21 * symbol(%65)) * symbol(%66)] : memref<?xf32>
          %81 = arith.addf %79, %80 : f32
          %82 = arith.mulf %81, %cst_0 : f32
          %83 = affine.load %arg17[%arg23 + %arg22 * symbol(%65) + (%arg21 * symbol(%65)) * symbol(%66)] : memref<?xf32>
          %84 = arith.mulf %82, %83 : f32
          %85 = affine.load %arg18[%arg23 + %arg22 * symbol(%65)] : memref<?xf32>
          %86 = arith.mulf %84, %85 : f32
          affine.store %86, %arg6[%arg23 + %arg22 * symbol(%65) + (%arg21 * symbol(%65)) * symbol(%66)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    %67 = affine.load %4[0] : memref<1xi32>
    %68 = arith.index_cast %67 : i32 to index
    %69 = memref.get_global @dti2 : memref<1xf32>
    %70 = affine.load %43[0] : memref<1xi32>
    %71 = affine.load %46[0] : memref<1xi32>
    %72 = affine.load %3[0] : memref<1xi32>
    %73 = affine.load %0[0] : memref<1xi32>
    %74 = affine.load %69[0] : memref<1xf32>
    %75 = arith.index_cast %70 : i32 to index
    %76 = arith.index_cast %71 : i32 to index
    %77 = arith.index_cast %72 : i32 to index
    %78 = arith.index_cast %73 : i32 to index
    affine.for %arg21 = 0 to %68 {
      %79 = affine.load %arg15[%arg21] : memref<?xf32>
      affine.for %arg22 = 1 to %75 {
        affine.for %arg23 = 1 to %76 {
          %80 = affine.load %arg4[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78) + 1] : memref<?xf32>
          %81 = affine.load %arg4[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %82 = arith.subf %80, %81 : f32
          %83 = affine.load %arg5[%arg23 + (%arg22 + 1) * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %84 = arith.addf %82, %83 : f32
          %85 = affine.load %arg5[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %86 = arith.subf %84, %85 : f32
          %87 = affine.load %arg6[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %88 = affine.load %arg6[%arg23 + %arg22 * symbol(%77) + ((%arg21 + 1) * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %89 = arith.subf %87, %88 : f32
          %90 = arith.divf %89, %79 : f32
          %91 = arith.addf %86, %90 : f32
          affine.store %91, %arg3[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %92 = affine.load %arg0[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %93 = affine.load %arg16[%arg23 + %arg22 * symbol(%77)] : memref<?xf32>
          %94 = affine.load %arg19[%arg23 + %arg22 * symbol(%77)] : memref<?xf32>
          %95 = arith.addf %93, %94 : f32
          %96 = arith.mulf %92, %95 : f32
          %97 = affine.load %arg18[%arg23 + %arg22 * symbol(%77)] : memref<?xf32>
          %98 = arith.mulf %96, %97 : f32
          %99 = affine.load %arg3[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
          %100 = arith.mulf %74, %99 : f32
          %101 = arith.subf %98, %100 : f32
          %102 = affine.load %arg20[%arg23 + %arg22 * symbol(%77)] : memref<?xf32>
          %103 = arith.addf %93, %102 : f32
          %104 = arith.mulf %103, %97 : f32
          %105 = arith.divf %101, %104 : f32
          affine.store %105, %arg3[%arg23 + %arg22 * symbol(%77) + (%arg21 * symbol(%77)) * symbol(%78)] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

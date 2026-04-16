module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @mode : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advave_(%arg0: memref<?xf32> {polygeist.name = "curv2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "aam2d", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c0 = arith.constant 0 : index
    %c-1 = arith.constant -1 : index
    %c2 = arith.constant 2 : index
    %cst = arith.constant -5.000000e-01 : f32
    %c2_i32 = arith.constant 2 : i32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 2.000000e+00 : f32
    %cst_2 = arith.constant 1.250000e-01 : f32
    %cst_3 = arith.constant 0.000000e+00 : f32
    %c1 = arith.constant 1 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    scf.for %arg19 = %c0 to %2 step %c1 {
      scf.for %arg20 = %c0 to %5 step %c1 {
        %73 = arith.muli %arg19, %5 overflow<nsw> : index
        %74 = arith.addi %arg20, %73 : index
        memref.store %cst_3, %arg1[%74] : memref<?xf32>
      }
    }
    %6 = memref.load %0[%c0] : memref<1xi32>
    %7 = arith.index_cast %6 : i32 to index
    %8 = memref.get_global @imm1 : memref<1xi32>
    %9 = memref.load %8[%c0] : memref<1xi32>
    %10 = memref.load %3[%c0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    %13 = arith.addi %7, %c-1 : index
    scf.for %arg19 = %c0 to %13 step %c1 {
      %73 = arith.addi %11, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %12 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c2 : index
        %78 = memref.load %arg11[%77] : memref<?xf32>
        %79 = arith.addi %76, %c1 : index
        %80 = memref.load %arg11[%79] : memref<?xf32>
        %81 = arith.addf %78, %80 : f32
        %82 = memref.load %arg5[%77] : memref<?xf32>
        %83 = arith.mulf %81, %82 : f32
        %84 = memref.load %arg11[%76] : memref<?xf32>
        %85 = arith.addf %80, %84 : f32
        %86 = memref.load %arg5[%79] : memref<?xf32>
        %87 = arith.mulf %85, %86 : f32
        %88 = arith.addf %83, %87 : f32
        %89 = arith.mulf %88, %cst_2 : f32
        %90 = arith.addf %82, %86 : f32
        %91 = arith.mulf %89, %90 : f32
        memref.store %91, %arg3[%79] : memref<?xf32>
      }
    }
    %14 = memref.load %0[%c0] : memref<1xi32>
    %15 = arith.index_cast %14 : i32 to index
    %16 = memref.load %3[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = arith.addi %15, %c-1 : index
    scf.for %arg19 = %c0 to %18 step %c1 {
      %73 = arith.addi %17, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %17 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg11[%77] : memref<?xf32>
        %79 = arith.muli %arg19, %17 overflow<nsw> : index
        %80 = arith.addi %arg20, %79 : index
        %81 = arith.addi %80, %c1 : index
        %82 = memref.load %arg11[%81] : memref<?xf32>
        %83 = arith.addf %78, %82 : f32
        %84 = memref.load %arg6[%77] : memref<?xf32>
        %85 = arith.mulf %83, %84 : f32
        %86 = memref.load %arg11[%76] : memref<?xf32>
        %87 = memref.load %arg11[%80] : memref<?xf32>
        %88 = arith.addf %86, %87 : f32
        %89 = memref.load %arg6[%76] : memref<?xf32>
        %90 = arith.mulf %88, %89 : f32
        %91 = arith.addf %85, %90 : f32
        %92 = arith.mulf %91, %cst_2 : f32
        %93 = memref.load %arg5[%77] : memref<?xf32>
        %94 = memref.load %arg5[%81] : memref<?xf32>
        %95 = arith.addf %93, %94 : f32
        %96 = arith.mulf %92, %95 : f32
        memref.store %96, %arg4[%77] : memref<?xf32>
      }
    }
    %19 = memref.load %0[%c0] : memref<1xi32>
    %20 = arith.index_cast %19 : i32 to index
    %21 = memref.load %8[%c0] : memref<1xi32>
    %22 = memref.load %3[%c0] : memref<1xi32>
    %23 = arith.index_cast %21 : i32 to index
    %24 = arith.index_cast %22 : i32 to index
    %25 = arith.addi %20, %c-1 : index
    scf.for %arg19 = %c0 to %25 step %c1 {
      %73 = arith.addi %23, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %24 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg3[%77] : memref<?xf32>
        %79 = memref.load %arg11[%77] : memref<?xf32>
        %80 = arith.mulf %79, %cst_1 : f32
        %81 = memref.load %arg16[%77] : memref<?xf32>
        %82 = arith.mulf %80, %81 : f32
        %83 = arith.addi %76, %c2 : index
        %84 = memref.load %arg7[%83] : memref<?xf32>
        %85 = memref.load %arg7[%77] : memref<?xf32>
        %86 = arith.subf %84, %85 : f32
        %87 = arith.mulf %82, %86 : f32
        %88 = memref.load %arg12[%77] : memref<?xf32>
        %89 = arith.divf %87, %88 : f32
        %90 = arith.subf %78, %89 : f32
        memref.store %90, %arg3[%77] : memref<?xf32>
      }
    }
    %26 = memref.load %0[%c0] : memref<1xi32>
    %27 = arith.index_cast %26 : i32 to index
    %28 = memref.load %3[%c0] : memref<1xi32>
    %29 = arith.index_cast %28 : i32 to index
    %30 = arith.addi %27, %c-1 : index
    scf.for %arg19 = %c0 to %30 step %c1 {
      %73 = arith.addi %29, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %29 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg11[%77] : memref<?xf32>
        %79 = memref.load %arg11[%76] : memref<?xf32>
        %80 = arith.addf %78, %79 : f32
        %81 = arith.muli %arg19, %29 overflow<nsw> : index
        %82 = arith.addi %arg20, %81 : index
        %83 = arith.addi %82, %c1 : index
        %84 = memref.load %arg11[%83] : memref<?xf32>
        %85 = arith.addf %80, %84 : f32
        %86 = memref.load %arg11[%82] : memref<?xf32>
        %87 = arith.addf %85, %86 : f32
        %88 = arith.mulf %87, %cst_0 : f32
        %89 = memref.load %arg16[%77] : memref<?xf32>
        %90 = memref.load %arg16[%83] : memref<?xf32>
        %91 = arith.addf %89, %90 : f32
        %92 = memref.load %arg16[%76] : memref<?xf32>
        %93 = arith.addf %91, %92 : f32
        %94 = memref.load %arg16[%82] : memref<?xf32>
        %95 = arith.addf %93, %94 : f32
        %96 = arith.mulf %88, %95 : f32
        %97 = memref.load %arg7[%77] : memref<?xf32>
        %98 = memref.load %arg7[%83] : memref<?xf32>
        %99 = arith.subf %97, %98 : f32
        %100 = memref.load %arg13[%77] : memref<?xf32>
        %101 = memref.load %arg13[%76] : memref<?xf32>
        %102 = arith.addf %100, %101 : f32
        %103 = memref.load %arg13[%83] : memref<?xf32>
        %104 = arith.addf %102, %103 : f32
        %105 = memref.load %arg13[%82] : memref<?xf32>
        %106 = arith.addf %104, %105 : f32
        %107 = arith.divf %99, %106 : f32
        %108 = memref.load %arg8[%77] : memref<?xf32>
        %109 = memref.load %arg8[%76] : memref<?xf32>
        %110 = arith.subf %108, %109 : f32
        %111 = memref.load %arg12[%77] : memref<?xf32>
        %112 = memref.load %arg12[%76] : memref<?xf32>
        %113 = arith.addf %111, %112 : f32
        %114 = memref.load %arg12[%83] : memref<?xf32>
        %115 = arith.addf %113, %114 : f32
        %116 = memref.load %arg12[%82] : memref<?xf32>
        %117 = arith.addf %115, %116 : f32
        %118 = arith.divf %110, %117 : f32
        %119 = arith.addf %107, %118 : f32
        %120 = arith.mulf %96, %119 : f32
        memref.store %120, %arg17[%77] : memref<?xf32>
        %121 = memref.load %arg3[%77] : memref<?xf32>
        %122 = memref.load %arg13[%77] : memref<?xf32>
        %123 = arith.mulf %121, %122 : f32
        memref.store %123, %arg3[%77] : memref<?xf32>
        %124 = memref.load %arg4[%77] : memref<?xf32>
        %125 = memref.load %arg17[%77] : memref<?xf32>
        %126 = arith.subf %124, %125 : f32
        %127 = arith.mulf %126, %cst_0 : f32
        %128 = memref.load %arg12[%77] : memref<?xf32>
        %129 = memref.load %arg12[%76] : memref<?xf32>
        %130 = arith.addf %128, %129 : f32
        %131 = memref.load %arg12[%83] : memref<?xf32>
        %132 = arith.addf %130, %131 : f32
        %133 = memref.load %arg12[%82] : memref<?xf32>
        %134 = arith.addf %132, %133 : f32
        %135 = arith.mulf %127, %134 : f32
        memref.store %135, %arg4[%77] : memref<?xf32>
      }
    }
    %31 = memref.get_global @jmm1 : memref<1xi32>
    %32 = memref.load %31[%c0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %34 = memref.load %8[%c0] : memref<1xi32>
    %35 = memref.load %3[%c0] : memref<1xi32>
    %36 = arith.index_cast %34 : i32 to index
    %37 = arith.index_cast %35 : i32 to index
    %38 = arith.addi %33, %c-1 : index
    scf.for %arg19 = %c0 to %38 step %c1 {
      %73 = arith.addi %36, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %37 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg3[%77] : memref<?xf32>
        %79 = memref.load %arg3[%76] : memref<?xf32>
        %80 = arith.subf %78, %79 : f32
        %81 = arith.addi %arg19, %c2 : index
        %82 = arith.muli %81, %37 overflow<nsw> : index
        %83 = arith.addi %arg20, %82 : index
        %84 = arith.addi %83, %c1 : index
        %85 = memref.load %arg4[%84] : memref<?xf32>
        %86 = arith.addf %80, %85 : f32
        %87 = memref.load %arg4[%77] : memref<?xf32>
        %88 = arith.subf %86, %87 : f32
        memref.store %88, %arg1[%77] : memref<?xf32>
      }
    }
    %39 = memref.load %0[%c0] : memref<1xi32>
    %40 = arith.index_cast %39 : i32 to index
    %41 = memref.load %3[%c0] : memref<1xi32>
    %42 = arith.index_cast %41 : i32 to index
    scf.for %arg19 = %c0 to %40 step %c1 {
      scf.for %arg20 = %c0 to %42 step %c1 {
        %73 = arith.muli %arg19, %42 overflow<nsw> : index
        %74 = arith.addi %arg20, %73 : index
        memref.store %cst_3, %arg2[%74] : memref<?xf32>
      }
    }
    %43 = memref.load %0[%c0] : memref<1xi32>
    %44 = arith.index_cast %43 : i32 to index
    %45 = memref.load %3[%c0] : memref<1xi32>
    %46 = arith.index_cast %45 : i32 to index
    %47 = arith.addi %44, %c-1 : index
    scf.for %arg19 = %c0 to %47 step %c1 {
      %73 = arith.addi %46, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %46 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg11[%77] : memref<?xf32>
        %79 = memref.load %arg11[%76] : memref<?xf32>
        %80 = arith.addf %78, %79 : f32
        %81 = memref.load %arg5[%77] : memref<?xf32>
        %82 = arith.mulf %80, %81 : f32
        %83 = arith.muli %arg19, %46 overflow<nsw> : index
        %84 = arith.addi %arg20, %83 : index
        %85 = arith.addi %84, %c1 : index
        %86 = memref.load %arg11[%85] : memref<?xf32>
        %87 = memref.load %arg11[%84] : memref<?xf32>
        %88 = arith.addf %86, %87 : f32
        %89 = memref.load %arg5[%85] : memref<?xf32>
        %90 = arith.mulf %88, %89 : f32
        %91 = arith.addf %82, %90 : f32
        %92 = arith.mulf %91, %cst_2 : f32
        %93 = memref.load %arg6[%76] : memref<?xf32>
        %94 = memref.load %arg6[%77] : memref<?xf32>
        %95 = arith.addf %93, %94 : f32
        %96 = arith.mulf %92, %95 : f32
        memref.store %96, %arg3[%77] : memref<?xf32>
      }
    }
    %48 = memref.load %31[%c0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    %50 = memref.load %3[%c0] : memref<1xi32>
    %51 = arith.index_cast %50 : i32 to index
    %52 = arith.addi %49, %c-1 : index
    scf.for %arg19 = %c0 to %52 step %c1 {
      %73 = arith.addi %51, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c2 : index
        %75 = arith.muli %74, %51 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg11[%77] : memref<?xf32>
        %79 = arith.addi %arg19, %c1 : index
        %80 = arith.muli %79, %51 overflow<nsw> : index
        %81 = arith.addi %arg20, %80 : index
        %82 = arith.addi %81, %c1 : index
        %83 = memref.load %arg11[%82] : memref<?xf32>
        %84 = arith.addf %78, %83 : f32
        %85 = memref.load %arg6[%77] : memref<?xf32>
        %86 = arith.mulf %84, %85 : f32
        %87 = arith.muli %arg19, %51 overflow<nsw> : index
        %88 = arith.addi %arg20, %87 : index
        %89 = arith.addi %88, %c1 : index
        %90 = memref.load %arg11[%89] : memref<?xf32>
        %91 = arith.addf %83, %90 : f32
        %92 = memref.load %arg6[%82] : memref<?xf32>
        %93 = arith.mulf %91, %92 : f32
        %94 = arith.addf %86, %93 : f32
        %95 = arith.mulf %94, %cst_2 : f32
        %96 = arith.addf %85, %92 : f32
        %97 = arith.mulf %95, %96 : f32
        memref.store %97, %arg4[%82] : memref<?xf32>
      }
    }
    %53 = memref.load %31[%c0] : memref<1xi32>
    %54 = arith.index_cast %53 : i32 to index
    %55 = memref.load %3[%c0] : memref<1xi32>
    %56 = arith.index_cast %55 : i32 to index
    %57 = arith.addi %54, %c-1 : index
    scf.for %arg19 = %c0 to %57 step %c1 {
      %73 = arith.addi %56, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %56 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg4[%77] : memref<?xf32>
        %79 = memref.load %arg11[%77] : memref<?xf32>
        %80 = arith.mulf %79, %cst_1 : f32
        %81 = memref.load %arg16[%77] : memref<?xf32>
        %82 = arith.mulf %80, %81 : f32
        %83 = arith.addi %arg19, %c2 : index
        %84 = arith.muli %83, %56 overflow<nsw> : index
        %85 = arith.addi %arg20, %84 : index
        %86 = arith.addi %85, %c1 : index
        %87 = memref.load %arg8[%86] : memref<?xf32>
        %88 = memref.load %arg8[%77] : memref<?xf32>
        %89 = arith.subf %87, %88 : f32
        %90 = arith.mulf %82, %89 : f32
        %91 = memref.load %arg13[%77] : memref<?xf32>
        %92 = arith.divf %90, %91 : f32
        %93 = arith.subf %78, %92 : f32
        memref.store %93, %arg4[%77] : memref<?xf32>
      }
    }
    %58 = memref.load %0[%c0] : memref<1xi32>
    %59 = arith.index_cast %58 : i32 to index
    %60 = memref.load %3[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    %62 = arith.addi %59, %c-1 : index
    scf.for %arg19 = %c0 to %62 step %c1 {
      %73 = arith.addi %61, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %61 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c1 : index
        %78 = memref.load %arg4[%77] : memref<?xf32>
        %79 = memref.load %arg12[%77] : memref<?xf32>
        %80 = arith.mulf %78, %79 : f32
        memref.store %80, %arg4[%77] : memref<?xf32>
        %81 = memref.load %arg3[%77] : memref<?xf32>
        %82 = memref.load %arg17[%77] : memref<?xf32>
        %83 = arith.subf %81, %82 : f32
        %84 = arith.mulf %83, %cst_0 : f32
        %85 = memref.load %arg13[%77] : memref<?xf32>
        %86 = memref.load %arg13[%76] : memref<?xf32>
        %87 = arith.addf %85, %86 : f32
        %88 = arith.muli %arg19, %61 overflow<nsw> : index
        %89 = arith.addi %arg20, %88 : index
        %90 = arith.addi %89, %c1 : index
        %91 = memref.load %arg13[%90] : memref<?xf32>
        %92 = arith.addf %87, %91 : f32
        %93 = memref.load %arg13[%89] : memref<?xf32>
        %94 = arith.addf %92, %93 : f32
        %95 = arith.mulf %84, %94 : f32
        memref.store %95, %arg3[%77] : memref<?xf32>
      }
    }
    %63 = memref.load %31[%c0] : memref<1xi32>
    %64 = arith.index_cast %63 : i32 to index
    %65 = memref.load %8[%c0] : memref<1xi32>
    %66 = memref.load %3[%c0] : memref<1xi32>
    %67 = arith.index_cast %65 : i32 to index
    %68 = arith.index_cast %66 : i32 to index
    %69 = arith.addi %64, %c-1 : index
    scf.for %arg19 = %c0 to %69 step %c1 {
      %73 = arith.addi %67, %c-1 : index
      scf.for %arg20 = %c0 to %73 step %c1 {
        %74 = arith.addi %arg19, %c1 : index
        %75 = arith.muli %74, %68 overflow<nsw> : index
        %76 = arith.addi %arg20, %75 : index
        %77 = arith.addi %76, %c2 : index
        %78 = memref.load %arg3[%77] : memref<?xf32>
        %79 = arith.addi %76, %c1 : index
        %80 = memref.load %arg3[%79] : memref<?xf32>
        %81 = arith.subf %78, %80 : f32
        %82 = memref.load %arg4[%79] : memref<?xf32>
        %83 = arith.addf %81, %82 : f32
        %84 = arith.muli %arg19, %68 overflow<nsw> : index
        %85 = arith.addi %arg20, %84 : index
        %86 = arith.addi %85, %c1 : index
        %87 = memref.load %arg4[%86] : memref<?xf32>
        %88 = arith.subf %83, %87 : f32
        memref.store %88, %arg2[%79] : memref<?xf32>
      }
    }
    %70 = memref.get_global @mode : memref<1xi32>
    %71 = memref.load %70[%c0] : memref<1xi32>
    %72 = arith.cmpi eq, %71, %c2_i32 : i32
    scf.if %72 {
      %73 = memref.load %31[%c0] : memref<1xi32>
      %74 = arith.index_cast %73 : i32 to index
      %75 = memref.load %8[%c0] : memref<1xi32>
      %76 = memref.load %3[%c0] : memref<1xi32>
      %77 = arith.index_cast %75 : i32 to index
      %78 = arith.index_cast %76 : i32 to index
      scf.for %arg19 = %c1 to %74 step %c1 {
        %103 = arith.muli %arg19, %78 : index
        %104 = arith.addi %arg19, %c1 : index
        %105 = arith.muli %104, %78 : index
        scf.for %arg20 = %c1 to %77 step %c1 {
          %106 = arith.addi %arg20, %103 : index
          %107 = memref.load %arg18[%106] : memref<?xf32>
          %108 = arith.addi %arg20, %c-1 : index
          %109 = arith.addi %108, %103 : index
          %110 = memref.load %arg18[%109] : memref<?xf32>
          %111 = arith.addf %107, %110 : f32
          %112 = arith.mulf %111, %cst : f32
          %113 = memref.load %arg7[%106] : memref<?xf32>
          %114 = arith.mulf %113, %113 : f32
          %115 = memref.load %arg8[%106] : memref<?xf32>
          %116 = arith.addi %arg20, %105 : index
          %117 = memref.load %arg8[%116] : memref<?xf32>
          %118 = arith.addf %115, %117 : f32
          %119 = memref.load %arg8[%109] : memref<?xf32>
          %120 = arith.addf %118, %119 : f32
          %121 = arith.addi %108, %105 : index
          %122 = memref.load %arg8[%121] : memref<?xf32>
          %123 = arith.addf %120, %122 : f32
          %124 = arith.mulf %123, %cst_0 : f32
          %125 = arith.mulf %124, %124 : f32
          %126 = arith.addf %114, %125 : f32
          %127 = math.sqrt %126 : f32
          %128 = arith.mulf %112, %127 : f32
          %129 = arith.mulf %128, %113 : f32
          memref.store %129, %arg9[%106] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %79 = memref.load %31[%c0] : memref<1xi32>
      %80 = arith.index_cast %79 : i32 to index
      %81 = memref.load %8[%c0] : memref<1xi32>
      %82 = memref.load %3[%c0] : memref<1xi32>
      %83 = arith.index_cast %81 : i32 to index
      %84 = arith.index_cast %82 : i32 to index
      scf.for %arg19 = %c1 to %80 step %c1 {
        %103 = arith.muli %arg19, %84 : index
        %104 = arith.addi %arg19, %c-1 : index
        %105 = arith.muli %104, %84 : index
        scf.for %arg20 = %c1 to %83 step %c1 {
          %106 = arith.addi %arg20, %103 : index
          %107 = memref.load %arg18[%106] : memref<?xf32>
          %108 = arith.addi %arg20, %105 : index
          %109 = memref.load %arg18[%108] : memref<?xf32>
          %110 = arith.addf %107, %109 : f32
          %111 = arith.mulf %110, %cst : f32
          %112 = memref.load %arg8[%106] : memref<?xf32>
          %113 = arith.mulf %112, %112 : f32
          %114 = memref.load %arg7[%106] : memref<?xf32>
          %115 = arith.addi %arg20, %c1 : index
          %116 = arith.addi %115, %103 : index
          %117 = memref.load %arg7[%116] : memref<?xf32>
          %118 = arith.addf %114, %117 : f32
          %119 = memref.load %arg7[%108] : memref<?xf32>
          %120 = arith.addf %118, %119 : f32
          %121 = arith.addi %115, %105 : index
          %122 = memref.load %arg7[%121] : memref<?xf32>
          %123 = arith.addf %120, %122 : f32
          %124 = arith.mulf %123, %cst_0 : f32
          %125 = arith.mulf %124, %124 : f32
          %126 = arith.addf %113, %125 : f32
          %127 = math.sqrt %126 : f32
          %128 = arith.mulf %111, %127 : f32
          %129 = arith.mulf %128, %112 : f32
          memref.store %129, %arg10[%106] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %85 = memref.load %31[%c0] : memref<1xi32>
      %86 = arith.index_cast %85 : i32 to index
      %87 = memref.load %8[%c0] : memref<1xi32>
      %88 = memref.load %3[%c0] : memref<1xi32>
      %89 = arith.index_cast %87 : i32 to index
      %90 = arith.index_cast %88 : i32 to index
      scf.for %arg19 = %c1 to %86 step %c1 {
        %103 = arith.muli %arg19, %90 : index
        %104 = arith.addi %arg19, %c1 : index
        %105 = arith.muli %104, %90 : index
        %106 = arith.addi %arg19, %c-1 : index
        %107 = arith.muli %106, %90 : index
        scf.for %arg20 = %c1 to %89 step %c1 {
          %108 = arith.addi %arg20, %103 : index
          %109 = arith.addi %arg20, %105 : index
          %110 = memref.load %arg6[%109] : memref<?xf32>
          %111 = memref.load %arg6[%108] : memref<?xf32>
          %112 = arith.addf %110, %111 : f32
          %113 = arith.addi %arg20, %c1 : index
          %114 = arith.addi %113, %103 : index
          %115 = memref.load %arg13[%114] : memref<?xf32>
          %116 = arith.addi %arg20, %c-1 : index
          %117 = arith.addi %116, %103 : index
          %118 = memref.load %arg13[%117] : memref<?xf32>
          %119 = arith.subf %115, %118 : f32
          %120 = arith.mulf %112, %119 : f32
          %121 = memref.load %arg5[%114] : memref<?xf32>
          %122 = memref.load %arg5[%108] : memref<?xf32>
          %123 = arith.addf %121, %122 : f32
          %124 = memref.load %arg12[%109] : memref<?xf32>
          %125 = arith.addi %arg20, %107 : index
          %126 = memref.load %arg12[%125] : memref<?xf32>
          %127 = arith.subf %124, %126 : f32
          %128 = arith.mulf %123, %127 : f32
          %129 = arith.subf %120, %128 : f32
          %130 = arith.mulf %129, %cst_0 : f32
          %131 = memref.load %arg12[%108] : memref<?xf32>
          %132 = memref.load %arg13[%108] : memref<?xf32>
          %133 = arith.mulf %131, %132 : f32
          %134 = arith.divf %130, %133 : f32
          memref.store %134, %arg0[%108] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %91 = memref.load %31[%c0] : memref<1xi32>
      %92 = arith.index_cast %91 : i32 to index
      %93 = memref.load %8[%c0] : memref<1xi32>
      %94 = memref.load %3[%c0] : memref<1xi32>
      %95 = arith.index_cast %93 : i32 to index
      %96 = arith.index_cast %94 : i32 to index
      scf.for %arg19 = %c1 to %92 step %c1 {
        %103 = arith.muli %arg19, %96 : index
        %104 = arith.addi %arg19, %c1 : index
        %105 = arith.muli %104, %96 : index
        scf.for %arg20 = %c2 to %95 step %c1 {
          %106 = arith.addi %arg20, %103 : index
          %107 = memref.load %arg1[%106] : memref<?xf32>
          %108 = memref.load %arg14[%106] : memref<?xf32>
          %109 = arith.mulf %108, %cst_0 : f32
          %110 = memref.load %arg0[%106] : memref<?xf32>
          %111 = memref.load %arg11[%106] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %arg20, %105 : index
          %114 = memref.load %arg6[%113] : memref<?xf32>
          %115 = memref.load %arg6[%106] : memref<?xf32>
          %116 = arith.addf %114, %115 : f32
          %117 = arith.mulf %112, %116 : f32
          %118 = arith.addi %arg20, %c-1 : index
          %119 = arith.addi %118, %103 : index
          %120 = memref.load %arg0[%119] : memref<?xf32>
          %121 = memref.load %arg11[%119] : memref<?xf32>
          %122 = arith.mulf %120, %121 : f32
          %123 = arith.addi %118, %105 : index
          %124 = memref.load %arg6[%123] : memref<?xf32>
          %125 = memref.load %arg6[%119] : memref<?xf32>
          %126 = arith.addf %124, %125 : f32
          %127 = arith.mulf %122, %126 : f32
          %128 = arith.addf %117, %127 : f32
          %129 = arith.mulf %109, %128 : f32
          %130 = arith.subf %107, %129 : f32
          memref.store %130, %arg1[%106] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %97 = memref.load %31[%c0] : memref<1xi32>
      %98 = arith.index_cast %97 : i32 to index
      %99 = memref.load %8[%c0] : memref<1xi32>
      %100 = memref.load %3[%c0] : memref<1xi32>
      %101 = arith.index_cast %99 : i32 to index
      %102 = arith.index_cast %100 : i32 to index
      scf.for %arg19 = %c2 to %98 step %c1 {
        %103 = arith.muli %arg19, %102 : index
        %104 = arith.addi %arg19, %c-1 : index
        %105 = arith.muli %104, %102 : index
        scf.for %arg20 = %c1 to %101 step %c1 {
          %106 = arith.addi %arg20, %103 : index
          %107 = memref.load %arg2[%106] : memref<?xf32>
          %108 = memref.load %arg15[%106] : memref<?xf32>
          %109 = arith.mulf %108, %cst_0 : f32
          %110 = memref.load %arg0[%106] : memref<?xf32>
          %111 = memref.load %arg11[%106] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %arg20, %c1 : index
          %114 = arith.addi %113, %103 : index
          %115 = memref.load %arg5[%114] : memref<?xf32>
          %116 = memref.load %arg5[%106] : memref<?xf32>
          %117 = arith.addf %115, %116 : f32
          %118 = arith.mulf %112, %117 : f32
          %119 = arith.addi %arg20, %105 : index
          %120 = memref.load %arg0[%119] : memref<?xf32>
          %121 = memref.load %arg11[%119] : memref<?xf32>
          %122 = arith.mulf %120, %121 : f32
          %123 = arith.addi %113, %105 : index
          %124 = memref.load %arg5[%123] : memref<?xf32>
          %125 = memref.load %arg5[%119] : memref<?xf32>
          %126 = arith.addf %124, %125 : f32
          %127 = arith.mulf %122, %126 : f32
          %128 = arith.addf %118, %127 : f32
          %129 = arith.mulf %109, %128 : f32
          %130 = arith.addf %107, %129 : f32
          memref.store %130, %arg2[%106] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    }
    return
  }
}


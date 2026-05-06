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
        %63 = arith.muli %arg19, %5 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        memref.store %cst_3, %arg1[%64] : memref<?xf32>
      }
    }
    %6 = memref.load %0[%c0] : memref<1xi32>
    %7 = arith.index_cast %6 : i32 to index
    %8 = memref.get_global @imm1 : memref<1xi32>
    %9 = memref.load %8[%c0] : memref<1xi32>
    %10 = memref.load %3[%c0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    scf.for %arg19 = %c1 to %7 step %c1 {
      scf.for %arg20 = %c1 to %11 step %c1 {
        %63 = arith.muli %arg19, %12 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = arith.addi %64, %c1 : index
        %66 = memref.load %arg11[%65] : memref<?xf32>
        %67 = memref.load %arg11[%64] : memref<?xf32>
        %68 = arith.addf %66, %67 : f32
        %69 = memref.load %arg5[%65] : memref<?xf32>
        %70 = arith.mulf %68, %69 : f32
        %71 = arith.addi %64, %c-1 : index
        %72 = memref.load %arg11[%71] : memref<?xf32>
        %73 = arith.addf %67, %72 : f32
        %74 = memref.load %arg5[%64] : memref<?xf32>
        %75 = arith.mulf %73, %74 : f32
        %76 = arith.addf %70, %75 : f32
        %77 = arith.mulf %76, %cst_2 : f32
        %78 = arith.addf %69, %74 : f32
        %79 = arith.mulf %77, %78 : f32
        memref.store %79, %arg3[%64] : memref<?xf32>
      }
    }
    %13 = memref.load %0[%c0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = memref.load %3[%c0] : memref<1xi32>
    %16 = arith.index_cast %15 : i32 to index
    scf.for %arg19 = %c1 to %14 step %c1 {
      scf.for %arg20 = %c1 to %16 step %c1 {
        %63 = arith.muli %arg19, %16 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = memref.load %arg11[%64] : memref<?xf32>
        %66 = arith.addi %arg19, %c-1 : index
        %67 = arith.muli %66, %16 overflow<nsw> : index
        %68 = arith.addi %arg20, %67 : index
        %69 = memref.load %arg11[%68] : memref<?xf32>
        %70 = arith.addf %65, %69 : f32
        %71 = memref.load %arg6[%64] : memref<?xf32>
        %72 = arith.mulf %70, %71 : f32
        %73 = arith.addi %64, %c-1 : index
        %74 = memref.load %arg11[%73] : memref<?xf32>
        %75 = arith.addi %68, %c-1 : index
        %76 = memref.load %arg11[%75] : memref<?xf32>
        %77 = arith.addf %74, %76 : f32
        %78 = memref.load %arg6[%73] : memref<?xf32>
        %79 = arith.mulf %77, %78 : f32
        %80 = arith.addf %72, %79 : f32
        %81 = arith.mulf %80, %cst_2 : f32
        %82 = memref.load %arg5[%64] : memref<?xf32>
        %83 = memref.load %arg5[%68] : memref<?xf32>
        %84 = arith.addf %82, %83 : f32
        %85 = arith.mulf %81, %84 : f32
        memref.store %85, %arg4[%64] : memref<?xf32>
      }
    }
    %17 = memref.load %0[%c0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.load %8[%c0] : memref<1xi32>
    %20 = memref.load %3[%c0] : memref<1xi32>
    %21 = arith.index_cast %19 : i32 to index
    %22 = arith.index_cast %20 : i32 to index
    scf.for %arg19 = %c1 to %18 step %c1 {
      scf.for %arg20 = %c1 to %21 step %c1 {
        %63 = arith.muli %arg19, %22 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = memref.load %arg3[%64] : memref<?xf32>
        %66 = memref.load %arg11[%64] : memref<?xf32>
        %67 = arith.mulf %66, %cst_1 : f32
        %68 = memref.load %arg16[%64] : memref<?xf32>
        %69 = arith.mulf %67, %68 : f32
        %70 = arith.addi %64, %c1 : index
        %71 = memref.load %arg7[%70] : memref<?xf32>
        %72 = memref.load %arg7[%64] : memref<?xf32>
        %73 = arith.subf %71, %72 : f32
        %74 = arith.mulf %69, %73 : f32
        %75 = memref.load %arg12[%64] : memref<?xf32>
        %76 = arith.divf %74, %75 : f32
        %77 = arith.subf %65, %76 : f32
        memref.store %77, %arg3[%64] : memref<?xf32>
      }
    }
    %23 = memref.load %0[%c0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = memref.load %3[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    scf.for %arg19 = %c1 to %24 step %c1 {
      scf.for %arg20 = %c1 to %26 step %c1 {
        %63 = arith.muli %arg19, %26 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = memref.load %arg11[%64] : memref<?xf32>
        %66 = arith.addi %64, %c-1 : index
        %67 = memref.load %arg11[%66] : memref<?xf32>
        %68 = arith.addf %65, %67 : f32
        %69 = arith.addi %arg19, %c-1 : index
        %70 = arith.muli %69, %26 overflow<nsw> : index
        %71 = arith.addi %arg20, %70 : index
        %72 = memref.load %arg11[%71] : memref<?xf32>
        %73 = arith.addf %68, %72 : f32
        %74 = arith.addi %71, %c-1 : index
        %75 = memref.load %arg11[%74] : memref<?xf32>
        %76 = arith.addf %73, %75 : f32
        %77 = arith.mulf %76, %cst_0 : f32
        %78 = memref.load %arg16[%64] : memref<?xf32>
        %79 = memref.load %arg16[%71] : memref<?xf32>
        %80 = arith.addf %78, %79 : f32
        %81 = memref.load %arg16[%66] : memref<?xf32>
        %82 = arith.addf %80, %81 : f32
        %83 = memref.load %arg16[%74] : memref<?xf32>
        %84 = arith.addf %82, %83 : f32
        %85 = arith.mulf %77, %84 : f32
        %86 = memref.load %arg7[%64] : memref<?xf32>
        %87 = memref.load %arg7[%71] : memref<?xf32>
        %88 = arith.subf %86, %87 : f32
        %89 = memref.load %arg13[%64] : memref<?xf32>
        %90 = memref.load %arg13[%66] : memref<?xf32>
        %91 = arith.addf %89, %90 : f32
        %92 = memref.load %arg13[%71] : memref<?xf32>
        %93 = arith.addf %91, %92 : f32
        %94 = memref.load %arg13[%74] : memref<?xf32>
        %95 = arith.addf %93, %94 : f32
        %96 = arith.divf %88, %95 : f32
        %97 = memref.load %arg8[%64] : memref<?xf32>
        %98 = memref.load %arg8[%66] : memref<?xf32>
        %99 = arith.subf %97, %98 : f32
        %100 = memref.load %arg12[%64] : memref<?xf32>
        %101 = memref.load %arg12[%66] : memref<?xf32>
        %102 = arith.addf %100, %101 : f32
        %103 = memref.load %arg12[%71] : memref<?xf32>
        %104 = arith.addf %102, %103 : f32
        %105 = memref.load %arg12[%74] : memref<?xf32>
        %106 = arith.addf %104, %105 : f32
        %107 = arith.divf %99, %106 : f32
        %108 = arith.addf %96, %107 : f32
        %109 = arith.mulf %85, %108 : f32
        memref.store %109, %arg17[%64] : memref<?xf32>
        %110 = memref.load %arg3[%64] : memref<?xf32>
        %111 = memref.load %arg13[%64] : memref<?xf32>
        %112 = arith.mulf %110, %111 : f32
        memref.store %112, %arg3[%64] : memref<?xf32>
        %113 = memref.load %arg4[%64] : memref<?xf32>
        %114 = memref.load %arg17[%64] : memref<?xf32>
        %115 = arith.subf %113, %114 : f32
        %116 = arith.mulf %115, %cst_0 : f32
        %117 = memref.load %arg12[%64] : memref<?xf32>
        %118 = memref.load %arg12[%66] : memref<?xf32>
        %119 = arith.addf %117, %118 : f32
        %120 = memref.load %arg12[%71] : memref<?xf32>
        %121 = arith.addf %119, %120 : f32
        %122 = memref.load %arg12[%74] : memref<?xf32>
        %123 = arith.addf %121, %122 : f32
        %124 = arith.mulf %116, %123 : f32
        memref.store %124, %arg4[%64] : memref<?xf32>
      }
    }
    %27 = memref.get_global @jmm1 : memref<1xi32>
    %28 = memref.load %27[%c0] : memref<1xi32>
    %29 = arith.index_cast %28 : i32 to index
    %30 = memref.load %8[%c0] : memref<1xi32>
    %31 = memref.load %3[%c0] : memref<1xi32>
    %32 = arith.index_cast %30 : i32 to index
    %33 = arith.index_cast %31 : i32 to index
    scf.for %arg19 = %c1 to %29 step %c1 {
      scf.for %arg20 = %c1 to %32 step %c1 {
        %63 = arith.muli %arg19, %33 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = memref.load %arg3[%64] : memref<?xf32>
        %66 = arith.addi %64, %c-1 : index
        %67 = memref.load %arg3[%66] : memref<?xf32>
        %68 = arith.subf %65, %67 : f32
        %69 = arith.addi %arg19, %c1 : index
        %70 = arith.muli %69, %33 overflow<nsw> : index
        %71 = arith.addi %arg20, %70 : index
        %72 = memref.load %arg4[%71] : memref<?xf32>
        %73 = arith.addf %68, %72 : f32
        %74 = memref.load %arg4[%64] : memref<?xf32>
        %75 = arith.subf %73, %74 : f32
        memref.store %75, %arg1[%64] : memref<?xf32>
      }
    }
    %34 = memref.load %0[%c0] : memref<1xi32>
    %35 = arith.index_cast %34 : i32 to index
    %36 = memref.load %3[%c0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    scf.for %arg19 = %c0 to %35 step %c1 {
      scf.for %arg20 = %c0 to %37 step %c1 {
        %63 = arith.muli %arg19, %37 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        memref.store %cst_3, %arg2[%64] : memref<?xf32>
      }
    }
    %38 = memref.load %0[%c0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = memref.load %3[%c0] : memref<1xi32>
    %41 = arith.index_cast %40 : i32 to index
    scf.for %arg19 = %c1 to %39 step %c1 {
      scf.for %arg20 = %c1 to %41 step %c1 {
        %63 = arith.muli %arg19, %41 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = memref.load %arg11[%64] : memref<?xf32>
        %66 = arith.addi %64, %c-1 : index
        %67 = memref.load %arg11[%66] : memref<?xf32>
        %68 = arith.addf %65, %67 : f32
        %69 = memref.load %arg5[%64] : memref<?xf32>
        %70 = arith.mulf %68, %69 : f32
        %71 = arith.addi %arg19, %c-1 : index
        %72 = arith.muli %71, %41 overflow<nsw> : index
        %73 = arith.addi %arg20, %72 : index
        %74 = memref.load %arg11[%73] : memref<?xf32>
        %75 = arith.addi %73, %c-1 : index
        %76 = memref.load %arg11[%75] : memref<?xf32>
        %77 = arith.addf %74, %76 : f32
        %78 = memref.load %arg5[%73] : memref<?xf32>
        %79 = arith.mulf %77, %78 : f32
        %80 = arith.addf %70, %79 : f32
        %81 = arith.mulf %80, %cst_2 : f32
        %82 = memref.load %arg6[%66] : memref<?xf32>
        %83 = memref.load %arg6[%64] : memref<?xf32>
        %84 = arith.addf %82, %83 : f32
        %85 = arith.mulf %81, %84 : f32
        memref.store %85, %arg3[%64] : memref<?xf32>
      }
    }
    %42 = memref.load %27[%c0] : memref<1xi32>
    %43 = arith.index_cast %42 : i32 to index
    %44 = memref.load %3[%c0] : memref<1xi32>
    %45 = arith.index_cast %44 : i32 to index
    scf.for %arg19 = %c1 to %43 step %c1 {
      scf.for %arg20 = %c1 to %45 step %c1 {
        %63 = arith.addi %arg19, %c1 : index
        %64 = arith.muli %63, %45 overflow<nsw> : index
        %65 = arith.addi %arg20, %64 : index
        %66 = memref.load %arg11[%65] : memref<?xf32>
        %67 = arith.muli %arg19, %45 overflow<nsw> : index
        %68 = arith.addi %arg20, %67 : index
        %69 = memref.load %arg11[%68] : memref<?xf32>
        %70 = arith.addf %66, %69 : f32
        %71 = memref.load %arg6[%65] : memref<?xf32>
        %72 = arith.mulf %70, %71 : f32
        %73 = arith.addi %arg19, %c-1 : index
        %74 = arith.muli %73, %45 overflow<nsw> : index
        %75 = arith.addi %arg20, %74 : index
        %76 = memref.load %arg11[%75] : memref<?xf32>
        %77 = arith.addf %69, %76 : f32
        %78 = memref.load %arg6[%68] : memref<?xf32>
        %79 = arith.mulf %77, %78 : f32
        %80 = arith.addf %72, %79 : f32
        %81 = arith.mulf %80, %cst_2 : f32
        %82 = arith.addf %71, %78 : f32
        %83 = arith.mulf %81, %82 : f32
        memref.store %83, %arg4[%68] : memref<?xf32>
      }
    }
    %46 = memref.load %27[%c0] : memref<1xi32>
    %47 = arith.index_cast %46 : i32 to index
    %48 = memref.load %3[%c0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    scf.for %arg19 = %c1 to %47 step %c1 {
      scf.for %arg20 = %c1 to %49 step %c1 {
        %63 = arith.muli %arg19, %49 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = memref.load %arg4[%64] : memref<?xf32>
        %66 = memref.load %arg11[%64] : memref<?xf32>
        %67 = arith.mulf %66, %cst_1 : f32
        %68 = memref.load %arg16[%64] : memref<?xf32>
        %69 = arith.mulf %67, %68 : f32
        %70 = arith.addi %arg19, %c1 : index
        %71 = arith.muli %70, %49 overflow<nsw> : index
        %72 = arith.addi %arg20, %71 : index
        %73 = memref.load %arg8[%72] : memref<?xf32>
        %74 = memref.load %arg8[%64] : memref<?xf32>
        %75 = arith.subf %73, %74 : f32
        %76 = arith.mulf %69, %75 : f32
        %77 = memref.load %arg13[%64] : memref<?xf32>
        %78 = arith.divf %76, %77 : f32
        %79 = arith.subf %65, %78 : f32
        memref.store %79, %arg4[%64] : memref<?xf32>
      }
    }
    %50 = memref.load %0[%c0] : memref<1xi32>
    %51 = arith.index_cast %50 : i32 to index
    %52 = memref.load %3[%c0] : memref<1xi32>
    %53 = arith.index_cast %52 : i32 to index
    scf.for %arg19 = %c1 to %51 step %c1 {
      scf.for %arg20 = %c1 to %53 step %c1 {
        %63 = arith.muli %arg19, %53 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = memref.load %arg4[%64] : memref<?xf32>
        %66 = memref.load %arg12[%64] : memref<?xf32>
        %67 = arith.mulf %65, %66 : f32
        memref.store %67, %arg4[%64] : memref<?xf32>
        %68 = memref.load %arg3[%64] : memref<?xf32>
        %69 = memref.load %arg17[%64] : memref<?xf32>
        %70 = arith.subf %68, %69 : f32
        %71 = arith.mulf %70, %cst_0 : f32
        %72 = memref.load %arg13[%64] : memref<?xf32>
        %73 = arith.addi %64, %c-1 : index
        %74 = memref.load %arg13[%73] : memref<?xf32>
        %75 = arith.addf %72, %74 : f32
        %76 = arith.addi %arg19, %c-1 : index
        %77 = arith.muli %76, %53 overflow<nsw> : index
        %78 = arith.addi %arg20, %77 : index
        %79 = memref.load %arg13[%78] : memref<?xf32>
        %80 = arith.addf %75, %79 : f32
        %81 = arith.addi %78, %c-1 : index
        %82 = memref.load %arg13[%81] : memref<?xf32>
        %83 = arith.addf %80, %82 : f32
        %84 = arith.mulf %71, %83 : f32
        memref.store %84, %arg3[%64] : memref<?xf32>
      }
    }
    %54 = memref.load %27[%c0] : memref<1xi32>
    %55 = arith.index_cast %54 : i32 to index
    %56 = memref.load %8[%c0] : memref<1xi32>
    %57 = memref.load %3[%c0] : memref<1xi32>
    %58 = arith.index_cast %56 : i32 to index
    %59 = arith.index_cast %57 : i32 to index
    scf.for %arg19 = %c1 to %55 step %c1 {
      scf.for %arg20 = %c1 to %58 step %c1 {
        %63 = arith.muli %arg19, %59 overflow<nsw> : index
        %64 = arith.addi %arg20, %63 : index
        %65 = arith.addi %64, %c1 : index
        %66 = memref.load %arg3[%65] : memref<?xf32>
        %67 = memref.load %arg3[%64] : memref<?xf32>
        %68 = arith.subf %66, %67 : f32
        %69 = memref.load %arg4[%64] : memref<?xf32>
        %70 = arith.addf %68, %69 : f32
        %71 = arith.addi %arg19, %c-1 : index
        %72 = arith.muli %71, %59 overflow<nsw> : index
        %73 = arith.addi %arg20, %72 : index
        %74 = memref.load %arg4[%73] : memref<?xf32>
        %75 = arith.subf %70, %74 : f32
        memref.store %75, %arg2[%64] : memref<?xf32>
      }
    }
    %60 = memref.get_global @mode : memref<1xi32>
    %61 = memref.load %60[%c0] : memref<1xi32>
    %62 = arith.cmpi eq, %61, %c2_i32 : i32
    scf.if %62 {
      %63 = memref.load %27[%c0] : memref<1xi32>
      %64 = arith.index_cast %63 : i32 to index
      %65 = memref.load %8[%c0] : memref<1xi32>
      %66 = memref.load %3[%c0] : memref<1xi32>
      %67 = arith.index_cast %65 : i32 to index
      %68 = arith.index_cast %66 : i32 to index
      scf.for %arg19 = %c1 to %64 step %c1 {
        %93 = arith.muli %arg19, %68 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %68 : index
        scf.for %arg20 = %c1 to %67 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg18[%96] : memref<?xf32>
          %98 = arith.addi %arg20, %c-1 : index
          %99 = arith.addi %98, %93 : index
          %100 = memref.load %arg18[%99] : memref<?xf32>
          %101 = arith.addf %97, %100 : f32
          %102 = arith.mulf %101, %cst : f32
          %103 = memref.load %arg7[%96] : memref<?xf32>
          %104 = arith.mulf %103, %103 : f32
          %105 = memref.load %arg8[%96] : memref<?xf32>
          %106 = arith.addi %arg20, %95 : index
          %107 = memref.load %arg8[%106] : memref<?xf32>
          %108 = arith.addf %105, %107 : f32
          %109 = memref.load %arg8[%99] : memref<?xf32>
          %110 = arith.addf %108, %109 : f32
          %111 = arith.addi %98, %95 : index
          %112 = memref.load %arg8[%111] : memref<?xf32>
          %113 = arith.addf %110, %112 : f32
          %114 = arith.mulf %113, %cst_0 : f32
          %115 = arith.mulf %114, %114 : f32
          %116 = arith.addf %104, %115 : f32
          %117 = math.sqrt %116 : f32
          %118 = arith.mulf %102, %117 : f32
          %119 = arith.mulf %118, %103 : f32
          memref.store %119, %arg9[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %69 = memref.load %27[%c0] : memref<1xi32>
      %70 = arith.index_cast %69 : i32 to index
      %71 = memref.load %8[%c0] : memref<1xi32>
      %72 = memref.load %3[%c0] : memref<1xi32>
      %73 = arith.index_cast %71 : i32 to index
      %74 = arith.index_cast %72 : i32 to index
      scf.for %arg19 = %c1 to %70 step %c1 {
        %93 = arith.muli %arg19, %74 : index
        %94 = arith.addi %arg19, %c-1 : index
        %95 = arith.muli %94, %74 : index
        scf.for %arg20 = %c1 to %73 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg18[%96] : memref<?xf32>
          %98 = arith.addi %arg20, %95 : index
          %99 = memref.load %arg18[%98] : memref<?xf32>
          %100 = arith.addf %97, %99 : f32
          %101 = arith.mulf %100, %cst : f32
          %102 = memref.load %arg8[%96] : memref<?xf32>
          %103 = arith.mulf %102, %102 : f32
          %104 = memref.load %arg7[%96] : memref<?xf32>
          %105 = arith.addi %arg20, %c1 : index
          %106 = arith.addi %105, %93 : index
          %107 = memref.load %arg7[%106] : memref<?xf32>
          %108 = arith.addf %104, %107 : f32
          %109 = memref.load %arg7[%98] : memref<?xf32>
          %110 = arith.addf %108, %109 : f32
          %111 = arith.addi %105, %95 : index
          %112 = memref.load %arg7[%111] : memref<?xf32>
          %113 = arith.addf %110, %112 : f32
          %114 = arith.mulf %113, %cst_0 : f32
          %115 = arith.mulf %114, %114 : f32
          %116 = arith.addf %103, %115 : f32
          %117 = math.sqrt %116 : f32
          %118 = arith.mulf %101, %117 : f32
          %119 = arith.mulf %118, %102 : f32
          memref.store %119, %arg10[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %75 = memref.load %27[%c0] : memref<1xi32>
      %76 = arith.index_cast %75 : i32 to index
      %77 = memref.load %8[%c0] : memref<1xi32>
      %78 = memref.load %3[%c0] : memref<1xi32>
      %79 = arith.index_cast %77 : i32 to index
      %80 = arith.index_cast %78 : i32 to index
      scf.for %arg19 = %c1 to %76 step %c1 {
        %93 = arith.muli %arg19, %80 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %80 : index
        %96 = arith.addi %arg19, %c-1 : index
        %97 = arith.muli %96, %80 : index
        scf.for %arg20 = %c1 to %79 step %c1 {
          %98 = arith.addi %arg20, %93 : index
          %99 = arith.addi %arg20, %95 : index
          %100 = memref.load %arg6[%99] : memref<?xf32>
          %101 = memref.load %arg6[%98] : memref<?xf32>
          %102 = arith.addf %100, %101 : f32
          %103 = arith.addi %arg20, %c1 : index
          %104 = arith.addi %103, %93 : index
          %105 = memref.load %arg13[%104] : memref<?xf32>
          %106 = arith.addi %arg20, %c-1 : index
          %107 = arith.addi %106, %93 : index
          %108 = memref.load %arg13[%107] : memref<?xf32>
          %109 = arith.subf %105, %108 : f32
          %110 = arith.mulf %102, %109 : f32
          %111 = memref.load %arg5[%104] : memref<?xf32>
          %112 = memref.load %arg5[%98] : memref<?xf32>
          %113 = arith.addf %111, %112 : f32
          %114 = memref.load %arg12[%99] : memref<?xf32>
          %115 = arith.addi %arg20, %97 : index
          %116 = memref.load %arg12[%115] : memref<?xf32>
          %117 = arith.subf %114, %116 : f32
          %118 = arith.mulf %113, %117 : f32
          %119 = arith.subf %110, %118 : f32
          %120 = arith.mulf %119, %cst_0 : f32
          %121 = memref.load %arg12[%98] : memref<?xf32>
          %122 = memref.load %arg13[%98] : memref<?xf32>
          %123 = arith.mulf %121, %122 : f32
          %124 = arith.divf %120, %123 : f32
          memref.store %124, %arg0[%98] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %81 = memref.load %27[%c0] : memref<1xi32>
      %82 = arith.index_cast %81 : i32 to index
      %83 = memref.load %8[%c0] : memref<1xi32>
      %84 = memref.load %3[%c0] : memref<1xi32>
      %85 = arith.index_cast %83 : i32 to index
      %86 = arith.index_cast %84 : i32 to index
      scf.for %arg19 = %c1 to %82 step %c1 {
        %93 = arith.muli %arg19, %86 : index
        %94 = arith.addi %arg19, %c1 : index
        %95 = arith.muli %94, %86 : index
        scf.for %arg20 = %c2 to %85 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg1[%96] : memref<?xf32>
          %98 = memref.load %arg14[%96] : memref<?xf32>
          %99 = arith.mulf %98, %cst_0 : f32
          %100 = memref.load %arg0[%96] : memref<?xf32>
          %101 = memref.load %arg11[%96] : memref<?xf32>
          %102 = arith.mulf %100, %101 : f32
          %103 = arith.addi %arg20, %95 : index
          %104 = memref.load %arg6[%103] : memref<?xf32>
          %105 = memref.load %arg6[%96] : memref<?xf32>
          %106 = arith.addf %104, %105 : f32
          %107 = arith.mulf %102, %106 : f32
          %108 = arith.addi %arg20, %c-1 : index
          %109 = arith.addi %108, %93 : index
          %110 = memref.load %arg0[%109] : memref<?xf32>
          %111 = memref.load %arg11[%109] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %108, %95 : index
          %114 = memref.load %arg6[%113] : memref<?xf32>
          %115 = memref.load %arg6[%109] : memref<?xf32>
          %116 = arith.addf %114, %115 : f32
          %117 = arith.mulf %112, %116 : f32
          %118 = arith.addf %107, %117 : f32
          %119 = arith.mulf %99, %118 : f32
          %120 = arith.subf %97, %119 : f32
          memref.store %120, %arg1[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %87 = memref.load %27[%c0] : memref<1xi32>
      %88 = arith.index_cast %87 : i32 to index
      %89 = memref.load %8[%c0] : memref<1xi32>
      %90 = memref.load %3[%c0] : memref<1xi32>
      %91 = arith.index_cast %89 : i32 to index
      %92 = arith.index_cast %90 : i32 to index
      scf.for %arg19 = %c2 to %88 step %c1 {
        %93 = arith.muli %arg19, %92 : index
        %94 = arith.addi %arg19, %c-1 : index
        %95 = arith.muli %94, %92 : index
        scf.for %arg20 = %c1 to %91 step %c1 {
          %96 = arith.addi %arg20, %93 : index
          %97 = memref.load %arg2[%96] : memref<?xf32>
          %98 = memref.load %arg15[%96] : memref<?xf32>
          %99 = arith.mulf %98, %cst_0 : f32
          %100 = memref.load %arg0[%96] : memref<?xf32>
          %101 = memref.load %arg11[%96] : memref<?xf32>
          %102 = arith.mulf %100, %101 : f32
          %103 = arith.addi %arg20, %c1 : index
          %104 = arith.addi %103, %93 : index
          %105 = memref.load %arg5[%104] : memref<?xf32>
          %106 = memref.load %arg5[%96] : memref<?xf32>
          %107 = arith.addf %105, %106 : f32
          %108 = arith.mulf %102, %107 : f32
          %109 = arith.addi %arg20, %95 : index
          %110 = memref.load %arg0[%109] : memref<?xf32>
          %111 = memref.load %arg11[%109] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = arith.addi %103, %95 : index
          %114 = memref.load %arg5[%113] : memref<?xf32>
          %115 = memref.load %arg5[%109] : memref<?xf32>
          %116 = arith.addf %114, %115 : f32
          %117 = arith.mulf %112, %116 : f32
          %118 = arith.addf %108, %117 : f32
          %119 = arith.mulf %99, %118 : f32
          %120 = arith.addf %97, %119 : f32
          memref.store %120, %arg2[%96] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "2", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    }
    return
  }
}


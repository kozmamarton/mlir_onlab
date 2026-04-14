module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @umol : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kb : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_profv_(%arg0: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "km", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "dhloc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c0 = arith.constant 0 : index
    %0 = llvm.mlir.undef : i32
    %c-1 = arith.constant -1 : index
    %c-3_i32 = arith.constant -3 : i32
    %c-1_i32 = arith.constant -1 : i32
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %c1_i32 = arith.constant 1 : i32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %c0_i32 = arith.constant 0 : i32
    %c1 = arith.constant 1 : index
    %alloca = memref.alloca() : memref<i32>
    memref.store %0, %alloca[] : memref<i32>
    %1 = memref.get_global @jm : memref<1xi32>
    %2 = memref.load %1[%c0] : memref<1xi32>
    %3 = arith.index_cast %2 : i32 to index
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %4[%c0] : memref<1xi32>
    %6 = arith.index_cast %5 : i32 to index
    scf.for %arg18 = %c0 to %3 step %c1 {
      scf.for %arg19 = %c0 to %6 step %c1 {
        %93 = arith.muli %arg18, %6 overflow<nsw> : index
        %94 = arith.addi %arg19, %93 : index
        memref.store %cst_1, %arg17[%94] : memref<?xf32>
      }
    }
    %7 = memref.load %1[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %4[%c0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    %11 = arith.addi %8, %c-1 : index
    scf.for %arg18 = %c0 to %11 step %c1 {
      %93 = arith.addi %10, %c-1 : index
      scf.for %arg19 = %c0 to %93 step %c1 {
        %94 = arith.addi %arg18, %c1 : index
        %95 = arith.muli %94, %10 overflow<nsw> : index
        %96 = arith.addi %arg19, %95 : index
        %97 = arith.addi %96, %c1 : index
        %98 = memref.load %arg1[%97] : memref<?xf32>
        %99 = memref.load %arg0[%97] : memref<?xf32>
        %100 = arith.addf %98, %99 : f32
        %101 = arith.muli %arg18, %10 overflow<nsw> : index
        %102 = arith.addi %arg19, %101 : index
        %103 = arith.addi %102, %c1 : index
        %104 = memref.load %arg1[%103] : memref<?xf32>
        %105 = arith.addf %100, %104 : f32
        %106 = memref.load %arg0[%103] : memref<?xf32>
        %107 = arith.addf %105, %106 : f32
        %108 = arith.mulf %107, %cst_0 : f32
        memref.store %108, %arg17[%97] : memref<?xf32>
      }
    }
    %12 = memref.get_global @kb : memref<1xi32>
    %13 = memref.load %12[%c0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = memref.load %1[%c0] : memref<1xi32>
    %16 = memref.load %4[%c0] : memref<1xi32>
    %17 = arith.index_cast %15 : i32 to index
    %18 = arith.index_cast %16 : i32 to index
    scf.for %arg18 = %c0 to %14 step %c1 {
      %93 = arith.addi %17, %c-1 : index
      scf.for %arg19 = %c0 to %93 step %c1 {
        %94 = arith.addi %18, %c-1 : index
        scf.for %arg20 = %c0 to %94 step %c1 {
          %95 = arith.addi %arg19, %c1 : index
          %96 = arith.muli %95, %18 overflow<nsw> : index
          %97 = arith.addi %arg20, %96 : index
          %98 = arith.muli %arg18, %18 overflow<nsw> : index
          %99 = arith.muli %98, %17 overflow<nsw> : index
          %100 = arith.addi %97, %99 : index
          %101 = arith.addi %100, %c1 : index
          %102 = memref.load %arg3[%101] : memref<?xf32>
          %103 = arith.muli %arg19, %18 overflow<nsw> : index
          %104 = arith.addi %arg20, %103 : index
          %105 = arith.addi %104, %99 : index
          %106 = arith.addi %105, %c1 : index
          %107 = memref.load %arg3[%106] : memref<?xf32>
          %108 = arith.addf %102, %107 : f32
          %109 = arith.mulf %108, %cst_0 : f32
          memref.store %109, %arg2[%101] : memref<?xf32>
        }
      }
    }
    %19 = memref.get_global @kbm2 : memref<1xi32>
    %20 = memref.load %19[%c0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.get_global @dti2 : memref<1xf32>
    %23 = memref.get_global @umol : memref<1xf32>
    %24 = memref.load %1[%c0] : memref<1xi32>
    %25 = memref.load %4[%c0] : memref<1xi32>
    %26 = memref.load %22[%c0] : memref<1xf32>
    %27 = memref.load %23[%c0] : memref<1xf32>
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.index_cast %25 : i32 to index
    %30 = arith.negf %26 : f32
    scf.for %arg18 = %c0 to %21 step %c1 {
      %93 = memref.load %arg5[%arg18] : memref<?xf32>
      %94 = memref.load %arg6[%arg18] : memref<?xf32>
      %95 = arith.mulf %93, %94 : f32
      scf.for %arg19 = %c0 to %28 step %c1 {
        scf.for %arg20 = %c0 to %29 step %c1 {
          %96 = arith.muli %arg19, %29 overflow<nsw> : index
          %97 = arith.addi %arg20, %96 : index
          %98 = arith.addi %arg18, %c1 : index
          %99 = arith.muli %98, %29 overflow<nsw> : index
          %100 = arith.muli %99, %28 overflow<nsw> : index
          %101 = arith.addi %97, %100 : index
          %102 = memref.load %arg2[%101] : memref<?xf32>
          %103 = arith.addf %102, %27 : f32
          %104 = arith.mulf %30, %103 : f32
          %105 = memref.load %arg17[%97] : memref<?xf32>
          %106 = arith.mulf %95, %105 : f32
          %107 = arith.mulf %106, %105 : f32
          %108 = arith.divf %104, %107 : f32
          %109 = arith.muli %arg18, %29 overflow<nsw> : index
          %110 = arith.muli %109, %28 overflow<nsw> : index
          %111 = arith.addi %97, %110 : index
          memref.store %108, %arg4[%111] : memref<?xf32>
        }
      }
    }
    %31 = memref.get_global @kbm1 : memref<1xi32>
    %32 = memref.load %31[%c0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %34 = memref.load %1[%c0] : memref<1xi32>
    %35 = memref.load %4[%c0] : memref<1xi32>
    %36 = memref.load %22[%c0] : memref<1xf32>
    %37 = memref.load %23[%c0] : memref<1xf32>
    %38 = arith.index_cast %34 : i32 to index
    %39 = arith.index_cast %35 : i32 to index
    %40 = arith.negf %36 : f32
    %41 = arith.addi %33, %c-1 : index
    scf.for %arg18 = %c0 to %41 step %c1 {
      %93 = arith.addi %arg18, %c1 : index
      %94 = memref.load %arg5[%93] : memref<?xf32>
      %95 = memref.load %arg6[%arg18] : memref<?xf32>
      %96 = arith.mulf %94, %95 : f32
      scf.for %arg19 = %c0 to %38 step %c1 {
        scf.for %arg20 = %c0 to %39 step %c1 {
          %97 = arith.muli %arg19, %39 overflow<nsw> : index
          %98 = arith.addi %arg20, %97 : index
          %99 = arith.muli %93, %39 overflow<nsw> : index
          %100 = arith.muli %99, %38 overflow<nsw> : index
          %101 = arith.addi %98, %100 : index
          %102 = memref.load %arg2[%101] : memref<?xf32>
          %103 = arith.addf %102, %37 : f32
          %104 = arith.mulf %40, %103 : f32
          %105 = memref.load %arg17[%98] : memref<?xf32>
          %106 = arith.mulf %96, %105 : f32
          %107 = arith.mulf %106, %105 : f32
          %108 = arith.divf %104, %107 : f32
          memref.store %108, %arg2[%101] : memref<?xf32>
        }
      }
    }
    %42 = memref.load %1[%c0] : memref<1xi32>
    %43 = arith.index_cast %42 : i32 to index
    %44 = memref.load %4[%c0] : memref<1xi32>
    %45 = memref.load %22[%c0] : memref<1xf32>
    %46 = memref.load %arg5[%c0] : memref<?xf32>
    %47 = arith.index_cast %44 : i32 to index
    %48 = arith.negf %45 : f32
    %49 = arith.negf %46 : f32
    scf.for %arg18 = %c0 to %43 step %c1 {
      scf.for %arg19 = %c0 to %47 step %c1 {
        %93 = arith.muli %arg18, %47 overflow<nsw> : index
        %94 = arith.addi %arg19, %93 : index
        %95 = memref.load %arg4[%94] : memref<?xf32>
        %96 = arith.subf %95, %cst_1 : f32
        %97 = arith.divf %95, %96 : f32
        memref.store %97, %arg7[%94] : memref<?xf32>
        %98 = memref.load %arg9[%94] : memref<?xf32>
        %99 = arith.mulf %48, %98 : f32
        %100 = memref.load %arg17[%94] : memref<?xf32>
        %101 = arith.mulf %49, %100 : f32
        %102 = arith.divf %99, %101 : f32
        %103 = memref.load %arg10[%94] : memref<?xf32>
        %104 = arith.subf %102, %103 : f32
        %105 = memref.load %arg4[%94] : memref<?xf32>
        %106 = arith.subf %105, %cst_1 : f32
        %107 = arith.divf %104, %106 : f32
        memref.store %107, %arg8[%94] : memref<?xf32>
      }
    }
    %50 = memref.load %19[%c0] : memref<1xi32>
    %51 = arith.index_cast %50 : i32 to index
    %52 = memref.load %1[%c0] : memref<1xi32>
    %53 = memref.load %4[%c0] : memref<1xi32>
    %54 = arith.index_cast %52 : i32 to index
    %55 = arith.index_cast %53 : i32 to index
    %56 = arith.addi %51, %c-1 : index
    scf.for %arg18 = %c0 to %56 step %c1 {
      scf.for %arg19 = %c0 to %54 step %c1 {
        scf.for %arg20 = %c0 to %55 step %c1 {
          %93 = arith.muli %arg19, %55 overflow<nsw> : index
          %94 = arith.addi %arg20, %93 : index
          %95 = arith.addi %arg18, %c1 : index
          %96 = arith.muli %95, %55 overflow<nsw> : index
          %97 = arith.muli %96, %54 overflow<nsw> : index
          %98 = arith.addi %94, %97 : index
          %99 = memref.load %arg4[%98] : memref<?xf32>
          %100 = memref.load %arg2[%98] : memref<?xf32>
          %101 = arith.muli %arg18, %55 overflow<nsw> : index
          %102 = arith.muli %101, %54 overflow<nsw> : index
          %103 = arith.addi %94, %102 : index
          %104 = memref.load %arg7[%103] : memref<?xf32>
          %105 = arith.subf %cst_1, %104 : f32
          %106 = arith.mulf %100, %105 : f32
          %107 = arith.addf %99, %106 : f32
          %108 = arith.subf %107, %cst_1 : f32
          %109 = arith.divf %cst_1, %108 : f32
          memref.store %109, %arg8[%98] : memref<?xf32>
          %110 = memref.load %arg4[%98] : memref<?xf32>
          %111 = memref.load %arg8[%98] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          memref.store %112, %arg7[%98] : memref<?xf32>
          %113 = memref.load %arg2[%98] : memref<?xf32>
          %114 = memref.load %arg8[%103] : memref<?xf32>
          %115 = arith.mulf %113, %114 : f32
          %116 = memref.load %arg10[%98] : memref<?xf32>
          %117 = arith.subf %115, %116 : f32
          %118 = memref.load %arg8[%98] : memref<?xf32>
          %119 = arith.mulf %117, %118 : f32
          memref.store %119, %arg8[%98] : memref<?xf32>
        }
      }
    }
    %57 = memref.get_global @jmm1 : memref<1xi32>
    %58 = memref.load %57[%c0] : memref<1xi32>
    %59 = arith.index_cast %58 : i32 to index
    %60 = memref.get_global @imm1 : memref<1xi32>
    %61 = memref.load %60[%c0] : memref<1xi32>
    %62 = memref.load %4[%c0] : memref<1xi32>
    %63 = memref.load %19[%c0] : memref<1xi32>
    %64 = memref.load %1[%c0] : memref<1xi32>
    %65 = memref.load %22[%c0] : memref<1xf32>
    %66 = arith.index_cast %61 : i32 to index
    %67 = arith.index_cast %62 : i32 to index
    %68 = arith.index_cast %63 : i32 to index
    %69 = arith.muli %68, %67 : index
    %70 = arith.index_cast %64 : i32 to index
    %71 = arith.muli %69, %70 : index
    %72 = arith.addi %68, %c-1 : index
    %73 = arith.muli %72, %67 : index
    %74 = arith.muli %73, %70 : index
    %75 = memref.load %arg5[%68] : memref<?xf32>
    %76 = arith.negf %75 : f32
    %77 = arith.addi %59, %c-1 : index
    scf.for %arg18 = %c0 to %77 step %c1 {
      %93 = arith.addi %66, %c-1 : index
      scf.for %arg19 = %c0 to %93 step %c1 {
        %94 = arith.addi %arg18, %c1 : index
        %95 = arith.muli %94, %67 overflow<nsw> : index
        %96 = arith.addi %arg19, %95 : index
        %97 = arith.addi %96, %c1 : index
        %98 = memref.load %arg12[%97] : memref<?xf32>
        %99 = arith.muli %arg18, %67 overflow<nsw> : index
        %100 = arith.addi %arg19, %99 : index
        %101 = arith.addi %100, %c1 : index
        %102 = memref.load %arg12[%101] : memref<?xf32>
        %103 = arith.addf %98, %102 : f32
        %104 = arith.mulf %103, %cst_0 : f32
        %105 = arith.addi %arg19, %71 : index
        %106 = arith.addi %105, %95 : index
        %107 = arith.addi %106, %c1 : index
        %108 = memref.load %arg13[%107] : memref<?xf32>
        %109 = arith.addi %106, %c2 : index
        %110 = memref.load %arg13[%109] : memref<?xf32>
        %111 = arith.addf %108, %110 : f32
        %112 = arith.addi %105, %99 : index
        %113 = arith.addi %112, %c1 : index
        %114 = memref.load %arg13[%113] : memref<?xf32>
        %115 = arith.addf %111, %114 : f32
        %116 = arith.addi %112, %c2 : index
        %117 = memref.load %arg13[%116] : memref<?xf32>
        %118 = arith.addf %115, %117 : f32
        %119 = arith.mulf %118, %cst : f32
        %120 = arith.mulf %119, %119 : f32
        %121 = memref.load %arg14[%107] : memref<?xf32>
        %122 = arith.mulf %121, %121 : f32
        %123 = arith.addf %120, %122 : f32
        %124 = math.sqrt %123 : f32
        %125 = arith.mulf %104, %124 : f32
        memref.store %125, %arg11[%97] : memref<?xf32>
        %126 = memref.load %arg2[%107] : memref<?xf32>
        %127 = arith.addi %arg19, %74 : index
        %128 = arith.addi %127, %95 : index
        %129 = arith.addi %128, %c1 : index
        %130 = memref.load %arg8[%129] : memref<?xf32>
        %131 = arith.mulf %126, %130 : f32
        %132 = memref.load %arg10[%107] : memref<?xf32>
        %133 = arith.subf %131, %132 : f32
        %134 = memref.load %arg11[%97] : memref<?xf32>
        %135 = arith.mulf %134, %65 : f32
        %136 = memref.load %arg17[%97] : memref<?xf32>
        %137 = arith.mulf %76, %136 : f32
        %138 = arith.divf %135, %137 : f32
        %139 = arith.subf %138, %cst_1 : f32
        %140 = memref.load %arg7[%129] : memref<?xf32>
        %141 = arith.subf %140, %cst_1 : f32
        %142 = arith.mulf %141, %126 : f32
        %143 = arith.subf %139, %142 : f32
        %144 = arith.divf %133, %143 : f32
        memref.store %144, %arg10[%107] : memref<?xf32>
        %145 = memref.load %arg10[%107] : memref<?xf32>
        %146 = memref.load %arg15[%97] : memref<?xf32>
        %147 = arith.mulf %145, %146 : f32
        memref.store %147, %arg10[%107] : memref<?xf32>
      }
    }
    %78 = memref.load %12[%c0] : memref<1xi32>
    %79 = arith.addi %78, %c-3_i32 : i32
    memref.store %79, %alloca[] : memref<i32>
    scf.while : () -> () {
      %93 = memref.load %alloca[] : memref<i32>
      %94 = arith.cmpi sge, %93, %c0_i32 : i32
      scf.condition(%94)
    } do {
      %93 = memref.load %57[%c0] : memref<1xi32>
      %94 = arith.index_cast %93 : i32 to index
      %95 = memref.load %60[%c0] : memref<1xi32>
      %96 = memref.load %4[%c0] : memref<1xi32>
      %97 = memref.load %alloca[] : memref<i32>
      %98 = memref.load %1[%c0] : memref<1xi32>
      %99 = arith.index_cast %95 : i32 to index
      %100 = arith.muli %97, %96 : i32
      %101 = arith.muli %100, %98 : i32
      %102 = arith.addi %97, %c1_i32 : i32
      %103 = arith.muli %102, %96 : i32
      %104 = arith.muli %103, %98 : i32
      %105 = arith.index_cast %96 : i32 to index
      scf.for %arg18 = %c1 to %94 step %c1 {
        %107 = arith.index_cast %arg18 : index to i32
        %108 = arith.muli %107, %96 : i32
        %109 = arith.muli %arg18, %105 : index
        scf.for %arg19 = %c1 to %99 step %c1 {
          %110 = arith.index_cast %arg19 : index to i32
          %111 = arith.addi %110, %108 : i32
          %112 = arith.addi %111, %101 : i32
          %113 = arith.index_cast %112 : i32 to index
          %114 = memref.load %arg7[%113] : memref<?xf32>
          %115 = arith.addi %111, %104 : i32
          %116 = arith.index_cast %115 : i32 to index
          %117 = memref.load %arg10[%116] : memref<?xf32>
          %118 = arith.mulf %114, %117 : f32
          %119 = memref.load %arg8[%113] : memref<?xf32>
          %120 = arith.addf %118, %119 : f32
          %121 = arith.addi %arg19, %109 : index
          %122 = memref.load %arg15[%121] : memref<?xf32>
          %123 = arith.mulf %120, %122 : f32
          memref.store %123, %arg10[%113] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %106 = arith.addi %97, %c-1_i32 : i32
      memref.store %106, %alloca[] : memref<i32>
      scf.yield
    }
    %80 = memref.load %57[%c0] : memref<1xi32>
    %81 = arith.index_cast %80 : i32 to index
    %82 = memref.load %60[%c0] : memref<1xi32>
    %83 = memref.load %4[%c0] : memref<1xi32>
    %84 = memref.load %19[%c0] : memref<1xi32>
    %85 = memref.load %1[%c0] : memref<1xi32>
    %86 = arith.index_cast %82 : i32 to index
    %87 = arith.index_cast %83 : i32 to index
    %88 = arith.index_cast %84 : i32 to index
    %89 = arith.muli %88, %87 : index
    %90 = arith.index_cast %85 : i32 to index
    %91 = arith.muli %89, %90 : index
    %92 = arith.addi %81, %c-1 : index
    scf.for %arg18 = %c0 to %92 step %c1 {
      %93 = arith.addi %86, %c-1 : index
      scf.for %arg19 = %c0 to %93 step %c1 {
        %94 = arith.addi %arg18, %c1 : index
        %95 = arith.muli %94, %87 overflow<nsw> : index
        %96 = arith.addi %arg19, %95 : index
        %97 = arith.addi %96, %c1 : index
        %98 = memref.load %arg11[%97] : memref<?xf32>
        %99 = arith.negf %98 : f32
        %100 = arith.addi %arg19, %91 : index
        %101 = arith.addi %100, %95 : index
        %102 = arith.addi %101, %c1 : index
        %103 = memref.load %arg10[%102] : memref<?xf32>
        %104 = arith.mulf %99, %103 : f32
        memref.store %104, %arg16[%97] : memref<?xf32>
      }
    }
    return
  }
}


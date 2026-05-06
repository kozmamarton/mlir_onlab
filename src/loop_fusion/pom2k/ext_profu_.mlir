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
  func.func @ext_profu_(%arg0: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "c", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "km", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "a", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ee", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "gg", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "cbc", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "dhloc", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
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
        %88 = arith.muli %arg18, %6 overflow<nsw> : index
        %89 = arith.addi %arg19, %88 : index
        memref.store %cst_1, %arg17[%89] : memref<?xf32>
      }
    }
    %7 = memref.load %1[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %4[%c0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    scf.for %arg18 = %c1 to %8 step %c1 {
      scf.for %arg19 = %c1 to %10 step %c1 {
        %88 = arith.muli %arg18, %10 overflow<nsw> : index
        %89 = arith.addi %arg19, %88 : index
        %90 = memref.load %arg0[%89] : memref<?xf32>
        %91 = memref.load %arg1[%89] : memref<?xf32>
        %92 = arith.addf %90, %91 : f32
        %93 = arith.addi %89, %c-1 : index
        %94 = memref.load %arg0[%93] : memref<?xf32>
        %95 = arith.addf %92, %94 : f32
        %96 = memref.load %arg1[%93] : memref<?xf32>
        %97 = arith.addf %95, %96 : f32
        %98 = arith.mulf %97, %cst_0 : f32
        memref.store %98, %arg17[%89] : memref<?xf32>
      }
    }
    %11 = memref.get_global @kb : memref<1xi32>
    %12 = memref.load %11[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.load %1[%c0] : memref<1xi32>
    %15 = memref.load %4[%c0] : memref<1xi32>
    %16 = arith.index_cast %14 : i32 to index
    %17 = arith.index_cast %15 : i32 to index
    scf.for %arg18 = %c0 to %13 step %c1 {
      scf.for %arg19 = %c1 to %16 step %c1 {
        scf.for %arg20 = %c1 to %17 step %c1 {
          %88 = arith.muli %arg19, %17 overflow<nsw> : index
          %89 = arith.addi %arg20, %88 : index
          %90 = arith.muli %arg18, %17 overflow<nsw> : index
          %91 = arith.muli %90, %16 overflow<nsw> : index
          %92 = arith.addi %89, %91 : index
          %93 = memref.load %arg3[%92] : memref<?xf32>
          %94 = arith.addi %92, %c-1 : index
          %95 = memref.load %arg3[%94] : memref<?xf32>
          %96 = arith.addf %93, %95 : f32
          %97 = arith.mulf %96, %cst_0 : f32
          memref.store %97, %arg2[%92] : memref<?xf32>
        }
      }
    }
    %18 = memref.get_global @kbm2 : memref<1xi32>
    %19 = memref.load %18[%c0] : memref<1xi32>
    %20 = arith.index_cast %19 : i32 to index
    %21 = memref.get_global @dti2 : memref<1xf32>
    %22 = memref.get_global @umol : memref<1xf32>
    %23 = memref.load %1[%c0] : memref<1xi32>
    %24 = memref.load %4[%c0] : memref<1xi32>
    %25 = memref.load %21[%c0] : memref<1xf32>
    %26 = memref.load %22[%c0] : memref<1xf32>
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.negf %25 : f32
    scf.for %arg18 = %c0 to %20 step %c1 {
      %88 = memref.load %arg5[%arg18] : memref<?xf32>
      %89 = memref.load %arg6[%arg18] : memref<?xf32>
      %90 = arith.mulf %88, %89 : f32
      scf.for %arg19 = %c0 to %27 step %c1 {
        scf.for %arg20 = %c0 to %28 step %c1 {
          %91 = arith.muli %arg19, %28 overflow<nsw> : index
          %92 = arith.addi %arg20, %91 : index
          %93 = arith.addi %arg18, %c1 : index
          %94 = arith.muli %93, %28 overflow<nsw> : index
          %95 = arith.muli %94, %27 overflow<nsw> : index
          %96 = arith.addi %92, %95 : index
          %97 = memref.load %arg2[%96] : memref<?xf32>
          %98 = arith.addf %97, %26 : f32
          %99 = arith.mulf %29, %98 : f32
          %100 = memref.load %arg17[%92] : memref<?xf32>
          %101 = arith.mulf %90, %100 : f32
          %102 = arith.mulf %101, %100 : f32
          %103 = arith.divf %99, %102 : f32
          %104 = arith.muli %arg18, %28 overflow<nsw> : index
          %105 = arith.muli %104, %27 overflow<nsw> : index
          %106 = arith.addi %92, %105 : index
          memref.store %103, %arg4[%106] : memref<?xf32>
        }
      }
    }
    %30 = memref.get_global @kbm1 : memref<1xi32>
    %31 = memref.load %30[%c0] : memref<1xi32>
    %32 = arith.index_cast %31 : i32 to index
    %33 = memref.load %1[%c0] : memref<1xi32>
    %34 = memref.load %4[%c0] : memref<1xi32>
    %35 = memref.load %21[%c0] : memref<1xf32>
    %36 = memref.load %22[%c0] : memref<1xf32>
    %37 = arith.index_cast %33 : i32 to index
    %38 = arith.index_cast %34 : i32 to index
    %39 = arith.negf %35 : f32
    scf.for %arg18 = %c1 to %32 step %c1 {
      %88 = memref.load %arg5[%arg18] : memref<?xf32>
      %89 = arith.addi %arg18, %c-1 : index
      %90 = memref.load %arg6[%89] : memref<?xf32>
      %91 = arith.mulf %88, %90 : f32
      scf.for %arg19 = %c0 to %37 step %c1 {
        scf.for %arg20 = %c0 to %38 step %c1 {
          %92 = arith.muli %arg19, %38 overflow<nsw> : index
          %93 = arith.addi %arg20, %92 : index
          %94 = arith.muli %arg18, %38 overflow<nsw> : index
          %95 = arith.muli %94, %37 overflow<nsw> : index
          %96 = arith.addi %93, %95 : index
          %97 = memref.load %arg2[%96] : memref<?xf32>
          %98 = arith.addf %97, %36 : f32
          %99 = arith.mulf %39, %98 : f32
          %100 = memref.load %arg17[%93] : memref<?xf32>
          %101 = arith.mulf %91, %100 : f32
          %102 = arith.mulf %101, %100 : f32
          %103 = arith.divf %99, %102 : f32
          memref.store %103, %arg2[%96] : memref<?xf32>
        }
      }
    }
    %40 = memref.load %1[%c0] : memref<1xi32>
    %41 = arith.index_cast %40 : i32 to index
    %42 = memref.load %4[%c0] : memref<1xi32>
    %43 = memref.load %21[%c0] : memref<1xf32>
    %44 = memref.load %arg5[%c0] : memref<?xf32>
    %45 = arith.index_cast %42 : i32 to index
    %46 = arith.negf %43 : f32
    %47 = arith.negf %44 : f32
    scf.for %arg18 = %c0 to %41 step %c1 {
      scf.for %arg19 = %c0 to %45 step %c1 {
        %88 = arith.muli %arg18, %45 overflow<nsw> : index
        %89 = arith.addi %arg19, %88 : index
        %90 = memref.load %arg4[%89] : memref<?xf32>
        %91 = arith.subf %90, %cst_1 : f32
        %92 = arith.divf %90, %91 : f32
        memref.store %92, %arg7[%89] : memref<?xf32>
        %93 = memref.load %arg9[%89] : memref<?xf32>
        %94 = arith.mulf %46, %93 : f32
        %95 = memref.load %arg17[%89] : memref<?xf32>
        %96 = arith.mulf %47, %95 : f32
        %97 = arith.divf %94, %96 : f32
        %98 = memref.load %arg10[%89] : memref<?xf32>
        %99 = arith.subf %97, %98 : f32
        %100 = memref.load %arg4[%89] : memref<?xf32>
        %101 = arith.subf %100, %cst_1 : f32
        %102 = arith.divf %99, %101 : f32
        memref.store %102, %arg8[%89] : memref<?xf32>
      }
    }
    %48 = memref.load %18[%c0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    %50 = memref.load %1[%c0] : memref<1xi32>
    %51 = memref.load %4[%c0] : memref<1xi32>
    %52 = arith.index_cast %50 : i32 to index
    %53 = arith.index_cast %51 : i32 to index
    scf.for %arg18 = %c1 to %49 step %c1 {
      scf.for %arg19 = %c0 to %52 step %c1 {
        scf.for %arg20 = %c0 to %53 step %c1 {
          %88 = arith.muli %arg19, %53 overflow<nsw> : index
          %89 = arith.addi %arg20, %88 : index
          %90 = arith.muli %arg18, %53 overflow<nsw> : index
          %91 = arith.muli %90, %52 overflow<nsw> : index
          %92 = arith.addi %89, %91 : index
          %93 = memref.load %arg4[%92] : memref<?xf32>
          %94 = memref.load %arg2[%92] : memref<?xf32>
          %95 = arith.addi %arg18, %c-1 : index
          %96 = arith.muli %95, %53 overflow<nsw> : index
          %97 = arith.muli %96, %52 overflow<nsw> : index
          %98 = arith.addi %89, %97 : index
          %99 = memref.load %arg7[%98] : memref<?xf32>
          %100 = arith.subf %cst_1, %99 : f32
          %101 = arith.mulf %94, %100 : f32
          %102 = arith.addf %93, %101 : f32
          %103 = arith.subf %102, %cst_1 : f32
          %104 = arith.divf %cst_1, %103 : f32
          memref.store %104, %arg8[%92] : memref<?xf32>
          %105 = memref.load %arg4[%92] : memref<?xf32>
          %106 = memref.load %arg8[%92] : memref<?xf32>
          %107 = arith.mulf %105, %106 : f32
          memref.store %107, %arg7[%92] : memref<?xf32>
          %108 = memref.load %arg2[%92] : memref<?xf32>
          %109 = memref.load %arg8[%98] : memref<?xf32>
          %110 = arith.mulf %108, %109 : f32
          %111 = memref.load %arg10[%92] : memref<?xf32>
          %112 = arith.subf %110, %111 : f32
          %113 = memref.load %arg8[%92] : memref<?xf32>
          %114 = arith.mulf %112, %113 : f32
          memref.store %114, %arg8[%92] : memref<?xf32>
        }
      }
    }
    %54 = memref.get_global @jmm1 : memref<1xi32>
    %55 = memref.load %54[%c0] : memref<1xi32>
    %56 = arith.index_cast %55 : i32 to index
    %57 = memref.get_global @imm1 : memref<1xi32>
    %58 = memref.load %57[%c0] : memref<1xi32>
    %59 = memref.load %4[%c0] : memref<1xi32>
    %60 = memref.load %18[%c0] : memref<1xi32>
    %61 = memref.load %1[%c0] : memref<1xi32>
    %62 = memref.load %21[%c0] : memref<1xf32>
    %63 = arith.index_cast %58 : i32 to index
    %64 = arith.index_cast %59 : i32 to index
    %65 = arith.index_cast %60 : i32 to index
    %66 = arith.muli %65, %64 : index
    %67 = arith.index_cast %61 : i32 to index
    %68 = arith.muli %66, %67 : index
    %69 = arith.addi %65, %c-1 : index
    %70 = arith.muli %69, %64 : index
    %71 = arith.muli %70, %67 : index
    %72 = memref.load %arg5[%65] : memref<?xf32>
    %73 = arith.negf %72 : f32
    scf.for %arg18 = %c1 to %56 step %c1 {
      scf.for %arg19 = %c1 to %63 step %c1 {
        %88 = arith.muli %arg18, %64 overflow<nsw> : index
        %89 = arith.addi %arg19, %88 : index
        %90 = memref.load %arg12[%89] : memref<?xf32>
        %91 = arith.addi %89, %c-1 : index
        %92 = memref.load %arg12[%91] : memref<?xf32>
        %93 = arith.addf %90, %92 : f32
        %94 = arith.mulf %93, %cst_0 : f32
        %95 = arith.addi %89, %68 : index
        %96 = memref.load %arg13[%95] : memref<?xf32>
        %97 = arith.mulf %96, %96 : f32
        %98 = memref.load %arg14[%95] : memref<?xf32>
        %99 = arith.addi %arg19, %68 : index
        %100 = arith.addi %arg18, %c1 : index
        %101 = arith.muli %100, %64 overflow<nsw> : index
        %102 = arith.addi %99, %101 : index
        %103 = memref.load %arg14[%102] : memref<?xf32>
        %104 = arith.addf %98, %103 : f32
        %105 = arith.addi %95, %c-1 : index
        %106 = memref.load %arg14[%105] : memref<?xf32>
        %107 = arith.addf %104, %106 : f32
        %108 = arith.addi %102, %c-1 : index
        %109 = memref.load %arg14[%108] : memref<?xf32>
        %110 = arith.addf %107, %109 : f32
        %111 = arith.mulf %110, %cst : f32
        %112 = arith.mulf %111, %111 : f32
        %113 = arith.addf %97, %112 : f32
        %114 = math.sqrt %113 : f32
        %115 = arith.mulf %94, %114 : f32
        memref.store %115, %arg11[%89] : memref<?xf32>
        %116 = memref.load %arg2[%95] : memref<?xf32>
        %117 = arith.addi %89, %71 : index
        %118 = memref.load %arg8[%117] : memref<?xf32>
        %119 = arith.mulf %116, %118 : f32
        %120 = memref.load %arg10[%95] : memref<?xf32>
        %121 = arith.subf %119, %120 : f32
        %122 = memref.load %arg11[%89] : memref<?xf32>
        %123 = arith.mulf %122, %62 : f32
        %124 = memref.load %arg17[%89] : memref<?xf32>
        %125 = arith.mulf %73, %124 : f32
        %126 = arith.divf %123, %125 : f32
        %127 = arith.subf %126, %cst_1 : f32
        %128 = memref.load %arg7[%117] : memref<?xf32>
        %129 = arith.subf %128, %cst_1 : f32
        %130 = arith.mulf %129, %116 : f32
        %131 = arith.subf %127, %130 : f32
        %132 = arith.divf %121, %131 : f32
        memref.store %132, %arg10[%95] : memref<?xf32>
        %133 = memref.load %arg10[%95] : memref<?xf32>
        %134 = memref.load %arg15[%89] : memref<?xf32>
        %135 = arith.mulf %133, %134 : f32
        memref.store %135, %arg10[%95] : memref<?xf32>
      }
    }
    %74 = memref.load %11[%c0] : memref<1xi32>
    %75 = arith.addi %74, %c-3_i32 : i32
    memref.store %75, %alloca[] : memref<i32>
    scf.while : () -> () {
      %88 = memref.load %alloca[] : memref<i32>
      %89 = arith.cmpi sge, %88, %c0_i32 : i32
      scf.condition(%89)
    } do {
      %88 = memref.load %54[%c0] : memref<1xi32>
      %89 = arith.index_cast %88 : i32 to index
      %90 = memref.load %57[%c0] : memref<1xi32>
      %91 = memref.load %4[%c0] : memref<1xi32>
      %92 = memref.load %alloca[] : memref<i32>
      %93 = memref.load %1[%c0] : memref<1xi32>
      %94 = arith.index_cast %90 : i32 to index
      %95 = arith.muli %92, %91 : i32
      %96 = arith.muli %95, %93 : i32
      %97 = arith.addi %92, %c1_i32 : i32
      %98 = arith.muli %97, %91 : i32
      %99 = arith.muli %98, %93 : i32
      %100 = arith.index_cast %91 : i32 to index
      scf.for %arg18 = %c1 to %89 step %c1 {
        %102 = arith.index_cast %arg18 : index to i32
        %103 = arith.muli %102, %91 : i32
        %104 = arith.muli %arg18, %100 : index
        scf.for %arg19 = %c1 to %94 step %c1 {
          %105 = arith.index_cast %arg19 : index to i32
          %106 = arith.addi %105, %103 : i32
          %107 = arith.addi %106, %96 : i32
          %108 = arith.index_cast %107 : i32 to index
          %109 = memref.load %arg7[%108] : memref<?xf32>
          %110 = arith.addi %106, %99 : i32
          %111 = arith.index_cast %110 : i32 to index
          %112 = memref.load %arg10[%111] : memref<?xf32>
          %113 = arith.mulf %109, %112 : f32
          %114 = memref.load %arg8[%108] : memref<?xf32>
          %115 = arith.addf %113, %114 : f32
          %116 = arith.addi %arg19, %104 : index
          %117 = memref.load %arg15[%116] : memref<?xf32>
          %118 = arith.mulf %115, %117 : f32
          memref.store %118, %arg10[%108] : memref<?xf32>
        } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
      } {constants = [{name = "k", non_scalar = false, type = "i32"}], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      %101 = arith.addi %92, %c-1_i32 : i32
      memref.store %101, %alloca[] : memref<i32>
      scf.yield
    }
    %76 = memref.load %54[%c0] : memref<1xi32>
    %77 = arith.index_cast %76 : i32 to index
    %78 = memref.load %57[%c0] : memref<1xi32>
    %79 = memref.load %4[%c0] : memref<1xi32>
    %80 = memref.load %18[%c0] : memref<1xi32>
    %81 = memref.load %1[%c0] : memref<1xi32>
    %82 = arith.index_cast %78 : i32 to index
    %83 = arith.index_cast %79 : i32 to index
    %84 = arith.index_cast %80 : i32 to index
    %85 = arith.muli %84, %83 : index
    %86 = arith.index_cast %81 : i32 to index
    %87 = arith.muli %85, %86 : index
    scf.for %arg18 = %c1 to %77 step %c1 {
      scf.for %arg19 = %c1 to %82 step %c1 {
        %88 = arith.muli %arg18, %83 overflow<nsw> : index
        %89 = arith.addi %arg19, %88 : index
        %90 = memref.load %arg11[%89] : memref<?xf32>
        %91 = arith.negf %90 : f32
        %92 = arith.addi %89, %87 : index
        %93 = memref.load %arg10[%92] : memref<?xf32>
        %94 = arith.mulf %91, %93 : f32
        memref.store %94, %arg16[%89] : memref<?xf32>
      }
    }
    return
  }
}


module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
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
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @kbm1 : memref<1xi32>
    %5 = memref.get_global @kbm2 : memref<1xi32>
    %6 = memref.load %3[%c0] : memref<1xi32>
    %7 = memref.load %4[%c0] : memref<1xi32>
    %8 = memref.load %5[%c0] : memref<1xi32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    %11 = arith.muli %10, %9 : index
    %12 = arith.muli %11, %2 : index
    %13 = arith.index_cast %8 : i32 to index
    %14 = arith.muli %13, %9 : index
    %15 = arith.muli %14, %2 : index
    scf.for %arg21 = %c0 to %2 step %c1 {
      scf.for %arg22 = %c0 to %9 step %c1 {
        %79 = arith.muli %arg21, %9 overflow<nsw> : index
        %80 = arith.addi %arg22, %79 : index
        %81 = arith.addi %80, %15 : index
        %82 = memref.load %arg1[%81] : memref<?xf32>
        %83 = arith.addi %80, %12 : index
        memref.store %82, %arg1[%83] : memref<?xf32>
        %84 = memref.load %arg0[%81] : memref<?xf32>
        memref.store %84, %arg0[%83] : memref<?xf32>
      }
    }
    %16 = memref.load %4[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.load %0[%c0] : memref<1xi32>
    %19 = memref.load %3[%c0] : memref<1xi32>
    %20 = arith.index_cast %18 : i32 to index
    %21 = arith.index_cast %19 : i32 to index
    scf.for %arg21 = %c0 to %17 step %c1 {
      scf.for %arg22 = %c1 to %20 step %c1 {
        scf.for %arg23 = %c1 to %21 step %c1 {
          %79 = arith.muli %arg22, %21 overflow<nsw> : index
          %80 = arith.addi %arg23, %79 : index
          %81 = memref.load %arg9[%80] : memref<?xf32>
          %82 = arith.addi %80, %c-1 : index
          %83 = memref.load %arg9[%82] : memref<?xf32>
          %84 = arith.addf %81, %83 : f32
          %85 = arith.muli %arg21, %21 overflow<nsw> : index
          %86 = arith.muli %85, %20 overflow<nsw> : index
          %87 = arith.addi %80, %86 : index
          %88 = memref.load %arg1[%87] : memref<?xf32>
          %89 = arith.addi %87, %c-1 : index
          %90 = memref.load %arg1[%89] : memref<?xf32>
          %91 = arith.addf %88, %90 : f32
          %92 = arith.mulf %84, %91 : f32
          %93 = memref.load %arg7[%87] : memref<?xf32>
          %94 = arith.mulf %92, %93 : f32
          %95 = arith.mulf %94, %cst_1 : f32
          memref.store %95, %arg4[%87] : memref<?xf32>
          %96 = memref.load %arg9[%80] : memref<?xf32>
          %97 = arith.addi %arg22, %c-1 : index
          %98 = arith.muli %97, %21 overflow<nsw> : index
          %99 = arith.addi %arg23, %98 : index
          %100 = memref.load %arg9[%99] : memref<?xf32>
          %101 = arith.addf %96, %100 : f32
          %102 = memref.load %arg1[%87] : memref<?xf32>
          %103 = arith.addi %99, %86 : index
          %104 = memref.load %arg1[%103] : memref<?xf32>
          %105 = arith.addf %102, %104 : f32
          %106 = arith.mulf %101, %105 : f32
          %107 = memref.load %arg8[%87] : memref<?xf32>
          %108 = arith.mulf %106, %107 : f32
          %109 = arith.mulf %108, %cst_1 : f32
          memref.store %109, %arg5[%87] : memref<?xf32>
        }
      }
    }
    %22 = memref.get_global @kb : memref<1xi32>
    %23 = memref.load %22[%c0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    %25 = memref.load %0[%c0] : memref<1xi32>
    %26 = memref.load %3[%c0] : memref<1xi32>
    %27 = arith.index_cast %25 : i32 to index
    %28 = arith.index_cast %26 : i32 to index
    scf.for %arg21 = %c0 to %24 step %c1 {
      scf.for %arg22 = %c0 to %27 step %c1 {
        scf.for %arg23 = %c0 to %28 step %c1 {
          %79 = arith.muli %arg22, %28 overflow<nsw> : index
          %80 = arith.addi %arg23, %79 : index
          %81 = arith.muli %arg21, %28 overflow<nsw> : index
          %82 = arith.muli %81, %27 overflow<nsw> : index
          %83 = arith.addi %80, %82 : index
          %84 = memref.load %arg0[%83] : memref<?xf32>
          %85 = memref.load %arg2[%83] : memref<?xf32>
          %86 = arith.subf %84, %85 : f32
          memref.store %86, %arg0[%83] : memref<?xf32>
        }
      }
    }
    %29 = memref.load %4[%c0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = memref.get_global @tprni : memref<1xf32>
    %32 = memref.load %0[%c0] : memref<1xi32>
    %33 = memref.load %3[%c0] : memref<1xi32>
    %34 = memref.load %31[%c0] : memref<1xf32>
    %35 = arith.index_cast %32 : i32 to index
    %36 = arith.index_cast %33 : i32 to index
    scf.for %arg21 = %c0 to %30 step %c1 {
      scf.for %arg22 = %c1 to %35 step %c1 {
        scf.for %arg23 = %c1 to %36 step %c1 {
          %79 = arith.muli %arg22, %36 overflow<nsw> : index
          %80 = arith.addi %arg23, %79 : index
          %81 = arith.muli %arg21, %36 overflow<nsw> : index
          %82 = arith.muli %81, %35 overflow<nsw> : index
          %83 = arith.addi %80, %82 : index
          %84 = memref.load %arg10[%83] : memref<?xf32>
          %85 = arith.addi %83, %c-1 : index
          %86 = memref.load %arg10[%85] : memref<?xf32>
          %87 = arith.addf %84, %86 : f32
          %88 = arith.mulf %87, %cst_0 : f32
          %89 = memref.load %arg16[%80] : memref<?xf32>
          %90 = arith.addi %80, %c-1 : index
          %91 = memref.load %arg16[%90] : memref<?xf32>
          %92 = arith.addf %89, %91 : f32
          %93 = arith.mulf %88, %92 : f32
          %94 = arith.mulf %93, %34 : f32
          %95 = memref.load %arg0[%83] : memref<?xf32>
          %96 = memref.load %arg0[%85] : memref<?xf32>
          %97 = arith.subf %95, %96 : f32
          %98 = arith.mulf %94, %97 : f32
          %99 = memref.load %arg11[%80] : memref<?xf32>
          %100 = arith.mulf %98, %99 : f32
          %101 = memref.load %arg13[%80] : memref<?xf32>
          %102 = memref.load %arg13[%90] : memref<?xf32>
          %103 = arith.addf %101, %102 : f32
          %104 = arith.divf %100, %103 : f32
          %105 = memref.load %arg4[%83] : memref<?xf32>
          %106 = arith.subf %105, %104 : f32
          memref.store %106, %arg4[%83] : memref<?xf32>
          %107 = memref.load %arg10[%83] : memref<?xf32>
          %108 = arith.addi %arg22, %c-1 : index
          %109 = arith.muli %108, %36 overflow<nsw> : index
          %110 = arith.addi %arg23, %109 : index
          %111 = arith.addi %110, %82 : index
          %112 = memref.load %arg10[%111] : memref<?xf32>
          %113 = arith.addf %107, %112 : f32
          %114 = arith.mulf %113, %cst_0 : f32
          %115 = memref.load %arg16[%80] : memref<?xf32>
          %116 = memref.load %arg16[%110] : memref<?xf32>
          %117 = arith.addf %115, %116 : f32
          %118 = arith.mulf %114, %117 : f32
          %119 = arith.mulf %118, %34 : f32
          %120 = memref.load %arg0[%83] : memref<?xf32>
          %121 = memref.load %arg0[%111] : memref<?xf32>
          %122 = arith.subf %120, %121 : f32
          %123 = arith.mulf %119, %122 : f32
          %124 = memref.load %arg12[%80] : memref<?xf32>
          %125 = arith.mulf %123, %124 : f32
          %126 = memref.load %arg14[%80] : memref<?xf32>
          %127 = memref.load %arg14[%110] : memref<?xf32>
          %128 = arith.addf %126, %127 : f32
          %129 = arith.divf %125, %128 : f32
          %130 = memref.load %arg5[%83] : memref<?xf32>
          %131 = arith.subf %130, %129 : f32
          memref.store %131, %arg5[%83] : memref<?xf32>
          %132 = memref.load %arg14[%80] : memref<?xf32>
          %133 = memref.load %arg14[%90] : memref<?xf32>
          %134 = arith.addf %132, %133 : f32
          %135 = arith.mulf %134, %cst_0 : f32
          %136 = memref.load %arg4[%83] : memref<?xf32>
          %137 = arith.mulf %135, %136 : f32
          memref.store %137, %arg4[%83] : memref<?xf32>
          %138 = memref.load %arg13[%80] : memref<?xf32>
          %139 = memref.load %arg13[%110] : memref<?xf32>
          %140 = arith.addf %138, %139 : f32
          %141 = arith.mulf %140, %cst_0 : f32
          %142 = memref.load %arg5[%83] : memref<?xf32>
          %143 = arith.mulf %141, %142 : f32
          memref.store %143, %arg5[%83] : memref<?xf32>
        }
      }
    }
    %37 = memref.load %22[%c0] : memref<1xi32>
    %38 = arith.index_cast %37 : i32 to index
    %39 = memref.load %0[%c0] : memref<1xi32>
    %40 = memref.load %3[%c0] : memref<1xi32>
    %41 = arith.index_cast %39 : i32 to index
    %42 = arith.index_cast %40 : i32 to index
    scf.for %arg21 = %c0 to %38 step %c1 {
      scf.for %arg22 = %c0 to %41 step %c1 {
        scf.for %arg23 = %c0 to %42 step %c1 {
          %79 = arith.muli %arg22, %42 overflow<nsw> : index
          %80 = arith.addi %arg23, %79 : index
          %81 = arith.muli %arg21, %42 overflow<nsw> : index
          %82 = arith.muli %81, %41 overflow<nsw> : index
          %83 = arith.addi %80, %82 : index
          %84 = memref.load %arg2[%83] : memref<?xf32>
          %85 = memref.load %arg0[%83] : memref<?xf32>
          %86 = arith.addf %85, %84 : f32
          memref.store %86, %arg0[%83] : memref<?xf32>
        }
      }
    }
    %43 = memref.get_global @jmm1 : memref<1xi32>
    %44 = memref.load %43[%c0] : memref<1xi32>
    %45 = arith.index_cast %44 : i32 to index
    %46 = memref.get_global @imm1 : memref<1xi32>
    %47 = memref.load %46[%c0] : memref<1xi32>
    %48 = memref.load %3[%c0] : memref<1xi32>
    %49 = memref.load %4[%c0] : memref<1xi32>
    %50 = memref.load %0[%c0] : memref<1xi32>
    %51 = arith.index_cast %47 : i32 to index
    %52 = arith.index_cast %48 : i32 to index
    %53 = arith.index_cast %49 : i32 to index
    %54 = arith.muli %53, %52 : index
    %55 = arith.index_cast %50 : i32 to index
    %56 = arith.muli %54, %55 : index
    scf.for %arg21 = %c1 to %45 step %c1 {
      scf.for %arg22 = %c1 to %51 step %c1 {
        %79 = arith.muli %arg21, %52 overflow<nsw> : index
        %80 = arith.addi %arg22, %79 : index
        %81 = memref.load %arg1[%80] : memref<?xf32>
        %82 = memref.load %arg17[%80] : memref<?xf32>
        %83 = arith.mulf %81, %82 : f32
        %84 = memref.load %arg18[%80] : memref<?xf32>
        %85 = arith.mulf %83, %84 : f32
        memref.store %85, %arg6[%80] : memref<?xf32>
        %86 = arith.addi %80, %56 : index
        memref.store %cst, %arg6[%86] : memref<?xf32>
      }
    }
    %57 = memref.load %4[%c0] : memref<1xi32>
    %58 = arith.index_cast %57 : i32 to index
    %59 = memref.load %43[%c0] : memref<1xi32>
    %60 = memref.load %46[%c0] : memref<1xi32>
    %61 = memref.load %3[%c0] : memref<1xi32>
    %62 = memref.load %0[%c0] : memref<1xi32>
    %63 = arith.index_cast %59 : i32 to index
    %64 = arith.index_cast %60 : i32 to index
    %65 = arith.index_cast %61 : i32 to index
    %66 = arith.index_cast %62 : i32 to index
    scf.for %arg21 = %c1 to %58 step %c1 {
      scf.for %arg22 = %c1 to %63 step %c1 {
        scf.for %arg23 = %c1 to %64 step %c1 {
          %79 = arith.muli %arg22, %65 overflow<nsw> : index
          %80 = arith.addi %arg23, %79 : index
          %81 = arith.addi %arg21, %c-1 : index
          %82 = arith.muli %81, %65 overflow<nsw> : index
          %83 = arith.muli %82, %66 overflow<nsw> : index
          %84 = arith.addi %80, %83 : index
          %85 = memref.load %arg1[%84] : memref<?xf32>
          %86 = arith.muli %arg21, %65 overflow<nsw> : index
          %87 = arith.muli %86, %66 overflow<nsw> : index
          %88 = arith.addi %80, %87 : index
          %89 = memref.load %arg1[%88] : memref<?xf32>
          %90 = arith.addf %85, %89 : f32
          %91 = arith.mulf %90, %cst_0 : f32
          %92 = memref.load %arg17[%88] : memref<?xf32>
          %93 = arith.mulf %91, %92 : f32
          %94 = memref.load %arg18[%80] : memref<?xf32>
          %95 = arith.mulf %93, %94 : f32
          memref.store %95, %arg6[%88] : memref<?xf32>
        }
      }
    }
    %67 = memref.load %4[%c0] : memref<1xi32>
    %68 = arith.index_cast %67 : i32 to index
    %69 = memref.get_global @dti2 : memref<1xf32>
    %70 = memref.load %43[%c0] : memref<1xi32>
    %71 = memref.load %46[%c0] : memref<1xi32>
    %72 = memref.load %3[%c0] : memref<1xi32>
    %73 = memref.load %0[%c0] : memref<1xi32>
    %74 = memref.load %69[%c0] : memref<1xf32>
    %75 = arith.index_cast %70 : i32 to index
    %76 = arith.index_cast %71 : i32 to index
    %77 = arith.index_cast %72 : i32 to index
    %78 = arith.index_cast %73 : i32 to index
    scf.for %arg21 = %c0 to %68 step %c1 {
      %79 = memref.load %arg15[%arg21] : memref<?xf32>
      scf.for %arg22 = %c1 to %75 step %c1 {
        scf.for %arg23 = %c1 to %76 step %c1 {
          %80 = arith.muli %arg22, %77 overflow<nsw> : index
          %81 = arith.addi %arg23, %80 : index
          %82 = arith.muli %arg21, %77 overflow<nsw> : index
          %83 = arith.muli %82, %78 overflow<nsw> : index
          %84 = arith.addi %81, %83 : index
          %85 = arith.addi %84, %c1 : index
          %86 = memref.load %arg4[%85] : memref<?xf32>
          %87 = memref.load %arg4[%84] : memref<?xf32>
          %88 = arith.subf %86, %87 : f32
          %89 = arith.addi %arg22, %c1 : index
          %90 = arith.muli %89, %77 overflow<nsw> : index
          %91 = arith.addi %arg23, %90 : index
          %92 = arith.addi %91, %83 : index
          %93 = memref.load %arg5[%92] : memref<?xf32>
          %94 = arith.addf %88, %93 : f32
          %95 = memref.load %arg5[%84] : memref<?xf32>
          %96 = arith.subf %94, %95 : f32
          %97 = memref.load %arg6[%84] : memref<?xf32>
          %98 = arith.addi %arg21, %c1 : index
          %99 = arith.muli %98, %77 overflow<nsw> : index
          %100 = arith.muli %99, %78 overflow<nsw> : index
          %101 = arith.addi %81, %100 : index
          %102 = memref.load %arg6[%101] : memref<?xf32>
          %103 = arith.subf %97, %102 : f32
          %104 = arith.divf %103, %79 : f32
          %105 = arith.addf %96, %104 : f32
          memref.store %105, %arg3[%84] : memref<?xf32>
          %106 = memref.load %arg0[%84] : memref<?xf32>
          %107 = memref.load %arg16[%81] : memref<?xf32>
          %108 = memref.load %arg19[%81] : memref<?xf32>
          %109 = arith.addf %107, %108 : f32
          %110 = arith.mulf %106, %109 : f32
          %111 = memref.load %arg18[%81] : memref<?xf32>
          %112 = arith.mulf %110, %111 : f32
          %113 = memref.load %arg3[%84] : memref<?xf32>
          %114 = arith.mulf %74, %113 : f32
          %115 = arith.subf %112, %114 : f32
          %116 = memref.load %arg20[%81] : memref<?xf32>
          %117 = arith.addf %107, %116 : f32
          %118 = arith.mulf %117, %111 : f32
          %119 = arith.divf %115, %118 : f32
          memref.store %119, %arg3[%84] : memref<?xf32>
        }
      }
    }
    return
  }
}


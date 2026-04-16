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
    %c2 = arith.constant 2 : index
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
        %81 = arith.muli %arg21, %9 overflow<nsw> : index
        %82 = arith.addi %arg22, %81 : index
        %83 = arith.addi %82, %15 : index
        %84 = memref.load %arg1[%83] : memref<?xf32>
        %85 = arith.addi %82, %12 : index
        memref.store %84, %arg1[%85] : memref<?xf32>
        %86 = memref.load %arg0[%83] : memref<?xf32>
        memref.store %86, %arg0[%85] : memref<?xf32>
      }
    }
    %16 = memref.load %4[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.load %0[%c0] : memref<1xi32>
    %19 = memref.load %3[%c0] : memref<1xi32>
    %20 = arith.index_cast %18 : i32 to index
    %21 = arith.index_cast %19 : i32 to index
    scf.for %arg21 = %c0 to %17 step %c1 {
      %81 = arith.addi %20, %c-1 : index
      scf.for %arg22 = %c0 to %81 step %c1 {
        %82 = arith.addi %21, %c-1 : index
        scf.for %arg23 = %c0 to %82 step %c1 {
          %83 = arith.addi %arg22, %c1 : index
          %84 = arith.muli %83, %21 overflow<nsw> : index
          %85 = arith.addi %arg23, %84 : index
          %86 = arith.addi %85, %c1 : index
          %87 = memref.load %arg9[%86] : memref<?xf32>
          %88 = memref.load %arg9[%85] : memref<?xf32>
          %89 = arith.addf %87, %88 : f32
          %90 = arith.muli %arg21, %21 overflow<nsw> : index
          %91 = arith.muli %90, %20 overflow<nsw> : index
          %92 = arith.addi %85, %91 : index
          %93 = arith.addi %92, %c1 : index
          %94 = memref.load %arg1[%93] : memref<?xf32>
          %95 = memref.load %arg1[%92] : memref<?xf32>
          %96 = arith.addf %94, %95 : f32
          %97 = arith.mulf %89, %96 : f32
          %98 = memref.load %arg7[%93] : memref<?xf32>
          %99 = arith.mulf %97, %98 : f32
          %100 = arith.mulf %99, %cst_1 : f32
          memref.store %100, %arg4[%93] : memref<?xf32>
          %101 = memref.load %arg9[%86] : memref<?xf32>
          %102 = arith.muli %arg22, %21 overflow<nsw> : index
          %103 = arith.addi %arg23, %102 : index
          %104 = arith.addi %103, %c1 : index
          %105 = memref.load %arg9[%104] : memref<?xf32>
          %106 = arith.addf %101, %105 : f32
          %107 = memref.load %arg1[%93] : memref<?xf32>
          %108 = arith.addi %103, %91 : index
          %109 = arith.addi %108, %c1 : index
          %110 = memref.load %arg1[%109] : memref<?xf32>
          %111 = arith.addf %107, %110 : f32
          %112 = arith.mulf %106, %111 : f32
          %113 = memref.load %arg8[%93] : memref<?xf32>
          %114 = arith.mulf %112, %113 : f32
          %115 = arith.mulf %114, %cst_1 : f32
          memref.store %115, %arg5[%93] : memref<?xf32>
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
          %81 = arith.muli %arg22, %28 overflow<nsw> : index
          %82 = arith.addi %arg23, %81 : index
          %83 = arith.muli %arg21, %28 overflow<nsw> : index
          %84 = arith.muli %83, %27 overflow<nsw> : index
          %85 = arith.addi %82, %84 : index
          %86 = memref.load %arg0[%85] : memref<?xf32>
          %87 = memref.load %arg2[%85] : memref<?xf32>
          %88 = arith.subf %86, %87 : f32
          memref.store %88, %arg0[%85] : memref<?xf32>
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
      %81 = arith.addi %35, %c-1 : index
      scf.for %arg22 = %c0 to %81 step %c1 {
        %82 = arith.addi %36, %c-1 : index
        scf.for %arg23 = %c0 to %82 step %c1 {
          %83 = arith.addi %arg22, %c1 : index
          %84 = arith.muli %83, %36 overflow<nsw> : index
          %85 = arith.addi %arg23, %84 : index
          %86 = arith.muli %arg21, %36 overflow<nsw> : index
          %87 = arith.muli %86, %35 overflow<nsw> : index
          %88 = arith.addi %85, %87 : index
          %89 = arith.addi %88, %c1 : index
          %90 = memref.load %arg10[%89] : memref<?xf32>
          %91 = memref.load %arg10[%88] : memref<?xf32>
          %92 = arith.addf %90, %91 : f32
          %93 = arith.mulf %92, %cst_0 : f32
          %94 = arith.addi %85, %c1 : index
          %95 = memref.load %arg16[%94] : memref<?xf32>
          %96 = memref.load %arg16[%85] : memref<?xf32>
          %97 = arith.addf %95, %96 : f32
          %98 = arith.mulf %93, %97 : f32
          %99 = arith.mulf %98, %34 : f32
          %100 = memref.load %arg0[%89] : memref<?xf32>
          %101 = memref.load %arg0[%88] : memref<?xf32>
          %102 = arith.subf %100, %101 : f32
          %103 = arith.mulf %99, %102 : f32
          %104 = memref.load %arg11[%94] : memref<?xf32>
          %105 = arith.mulf %103, %104 : f32
          %106 = memref.load %arg13[%94] : memref<?xf32>
          %107 = memref.load %arg13[%85] : memref<?xf32>
          %108 = arith.addf %106, %107 : f32
          %109 = arith.divf %105, %108 : f32
          %110 = memref.load %arg4[%89] : memref<?xf32>
          %111 = arith.subf %110, %109 : f32
          memref.store %111, %arg4[%89] : memref<?xf32>
          %112 = memref.load %arg10[%89] : memref<?xf32>
          %113 = arith.muli %arg22, %36 overflow<nsw> : index
          %114 = arith.addi %arg23, %113 : index
          %115 = arith.addi %114, %87 : index
          %116 = arith.addi %115, %c1 : index
          %117 = memref.load %arg10[%116] : memref<?xf32>
          %118 = arith.addf %112, %117 : f32
          %119 = arith.mulf %118, %cst_0 : f32
          %120 = memref.load %arg16[%94] : memref<?xf32>
          %121 = arith.addi %114, %c1 : index
          %122 = memref.load %arg16[%121] : memref<?xf32>
          %123 = arith.addf %120, %122 : f32
          %124 = arith.mulf %119, %123 : f32
          %125 = arith.mulf %124, %34 : f32
          %126 = memref.load %arg0[%89] : memref<?xf32>
          %127 = memref.load %arg0[%116] : memref<?xf32>
          %128 = arith.subf %126, %127 : f32
          %129 = arith.mulf %125, %128 : f32
          %130 = memref.load %arg12[%94] : memref<?xf32>
          %131 = arith.mulf %129, %130 : f32
          %132 = memref.load %arg14[%94] : memref<?xf32>
          %133 = memref.load %arg14[%121] : memref<?xf32>
          %134 = arith.addf %132, %133 : f32
          %135 = arith.divf %131, %134 : f32
          %136 = memref.load %arg5[%89] : memref<?xf32>
          %137 = arith.subf %136, %135 : f32
          memref.store %137, %arg5[%89] : memref<?xf32>
          %138 = memref.load %arg14[%94] : memref<?xf32>
          %139 = memref.load %arg14[%85] : memref<?xf32>
          %140 = arith.addf %138, %139 : f32
          %141 = arith.mulf %140, %cst_0 : f32
          %142 = memref.load %arg4[%89] : memref<?xf32>
          %143 = arith.mulf %141, %142 : f32
          memref.store %143, %arg4[%89] : memref<?xf32>
          %144 = memref.load %arg13[%94] : memref<?xf32>
          %145 = memref.load %arg13[%121] : memref<?xf32>
          %146 = arith.addf %144, %145 : f32
          %147 = arith.mulf %146, %cst_0 : f32
          %148 = memref.load %arg5[%89] : memref<?xf32>
          %149 = arith.mulf %147, %148 : f32
          memref.store %149, %arg5[%89] : memref<?xf32>
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
          %81 = arith.muli %arg22, %42 overflow<nsw> : index
          %82 = arith.addi %arg23, %81 : index
          %83 = arith.muli %arg21, %42 overflow<nsw> : index
          %84 = arith.muli %83, %41 overflow<nsw> : index
          %85 = arith.addi %82, %84 : index
          %86 = memref.load %arg2[%85] : memref<?xf32>
          %87 = memref.load %arg0[%85] : memref<?xf32>
          %88 = arith.addf %87, %86 : f32
          memref.store %88, %arg0[%85] : memref<?xf32>
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
    %57 = arith.addi %45, %c-1 : index
    scf.for %arg21 = %c0 to %57 step %c1 {
      %81 = arith.addi %51, %c-1 : index
      scf.for %arg22 = %c0 to %81 step %c1 {
        %82 = arith.addi %arg21, %c1 : index
        %83 = arith.muli %82, %52 overflow<nsw> : index
        %84 = arith.addi %arg22, %83 : index
        %85 = arith.addi %84, %c1 : index
        %86 = memref.load %arg1[%85] : memref<?xf32>
        %87 = memref.load %arg17[%85] : memref<?xf32>
        %88 = arith.mulf %86, %87 : f32
        %89 = memref.load %arg18[%85] : memref<?xf32>
        %90 = arith.mulf %88, %89 : f32
        memref.store %90, %arg6[%85] : memref<?xf32>
        %91 = arith.addi %arg22, %56 : index
        %92 = arith.addi %91, %83 : index
        %93 = arith.addi %92, %c1 : index
        memref.store %cst, %arg6[%93] : memref<?xf32>
      }
    }
    %58 = memref.load %4[%c0] : memref<1xi32>
    %59 = arith.index_cast %58 : i32 to index
    %60 = memref.load %43[%c0] : memref<1xi32>
    %61 = memref.load %46[%c0] : memref<1xi32>
    %62 = memref.load %3[%c0] : memref<1xi32>
    %63 = memref.load %0[%c0] : memref<1xi32>
    %64 = arith.index_cast %60 : i32 to index
    %65 = arith.index_cast %61 : i32 to index
    %66 = arith.index_cast %62 : i32 to index
    %67 = arith.index_cast %63 : i32 to index
    %68 = arith.addi %59, %c-1 : index
    scf.for %arg21 = %c0 to %68 step %c1 {
      %81 = arith.addi %64, %c-1 : index
      scf.for %arg22 = %c0 to %81 step %c1 {
        %82 = arith.addi %65, %c-1 : index
        scf.for %arg23 = %c0 to %82 step %c1 {
          %83 = arith.addi %arg22, %c1 : index
          %84 = arith.muli %83, %66 overflow<nsw> : index
          %85 = arith.addi %arg23, %84 : index
          %86 = arith.muli %arg21, %66 overflow<nsw> : index
          %87 = arith.muli %86, %67 overflow<nsw> : index
          %88 = arith.addi %85, %87 : index
          %89 = arith.addi %88, %c1 : index
          %90 = memref.load %arg1[%89] : memref<?xf32>
          %91 = arith.addi %arg21, %c1 : index
          %92 = arith.muli %91, %66 overflow<nsw> : index
          %93 = arith.muli %92, %67 overflow<nsw> : index
          %94 = arith.addi %85, %93 : index
          %95 = arith.addi %94, %c1 : index
          %96 = memref.load %arg1[%95] : memref<?xf32>
          %97 = arith.addf %90, %96 : f32
          %98 = arith.mulf %97, %cst_0 : f32
          %99 = memref.load %arg17[%95] : memref<?xf32>
          %100 = arith.mulf %98, %99 : f32
          %101 = arith.addi %85, %c1 : index
          %102 = memref.load %arg18[%101] : memref<?xf32>
          %103 = arith.mulf %100, %102 : f32
          memref.store %103, %arg6[%95] : memref<?xf32>
        }
      }
    }
    %69 = memref.load %4[%c0] : memref<1xi32>
    %70 = arith.index_cast %69 : i32 to index
    %71 = memref.get_global @dti2 : memref<1xf32>
    %72 = memref.load %43[%c0] : memref<1xi32>
    %73 = memref.load %46[%c0] : memref<1xi32>
    %74 = memref.load %3[%c0] : memref<1xi32>
    %75 = memref.load %0[%c0] : memref<1xi32>
    %76 = memref.load %71[%c0] : memref<1xf32>
    %77 = arith.index_cast %72 : i32 to index
    %78 = arith.index_cast %73 : i32 to index
    %79 = arith.index_cast %74 : i32 to index
    %80 = arith.index_cast %75 : i32 to index
    scf.for %arg21 = %c0 to %70 step %c1 {
      %81 = memref.load %arg15[%arg21] : memref<?xf32>
      %82 = arith.addi %77, %c-1 : index
      scf.for %arg22 = %c0 to %82 step %c1 {
        %83 = arith.addi %78, %c-1 : index
        scf.for %arg23 = %c0 to %83 step %c1 {
          %84 = arith.addi %arg22, %c1 : index
          %85 = arith.muli %84, %79 overflow<nsw> : index
          %86 = arith.addi %arg23, %85 : index
          %87 = arith.muli %arg21, %79 overflow<nsw> : index
          %88 = arith.muli %87, %80 overflow<nsw> : index
          %89 = arith.addi %86, %88 : index
          %90 = arith.addi %89, %c2 : index
          %91 = memref.load %arg4[%90] : memref<?xf32>
          %92 = arith.addi %89, %c1 : index
          %93 = memref.load %arg4[%92] : memref<?xf32>
          %94 = arith.subf %91, %93 : f32
          %95 = arith.addi %arg22, %c2 : index
          %96 = arith.muli %95, %79 overflow<nsw> : index
          %97 = arith.addi %arg23, %96 : index
          %98 = arith.addi %97, %88 : index
          %99 = arith.addi %98, %c1 : index
          %100 = memref.load %arg5[%99] : memref<?xf32>
          %101 = arith.addf %94, %100 : f32
          %102 = memref.load %arg5[%92] : memref<?xf32>
          %103 = arith.subf %101, %102 : f32
          %104 = memref.load %arg6[%92] : memref<?xf32>
          %105 = arith.addi %arg21, %c1 : index
          %106 = arith.muli %105, %79 overflow<nsw> : index
          %107 = arith.muli %106, %80 overflow<nsw> : index
          %108 = arith.addi %86, %107 : index
          %109 = arith.addi %108, %c1 : index
          %110 = memref.load %arg6[%109] : memref<?xf32>
          %111 = arith.subf %104, %110 : f32
          %112 = arith.divf %111, %81 : f32
          %113 = arith.addf %103, %112 : f32
          memref.store %113, %arg3[%92] : memref<?xf32>
          %114 = memref.load %arg0[%92] : memref<?xf32>
          %115 = arith.addi %86, %c1 : index
          %116 = memref.load %arg16[%115] : memref<?xf32>
          %117 = memref.load %arg19[%115] : memref<?xf32>
          %118 = arith.addf %116, %117 : f32
          %119 = arith.mulf %114, %118 : f32
          %120 = memref.load %arg18[%115] : memref<?xf32>
          %121 = arith.mulf %119, %120 : f32
          %122 = memref.load %arg3[%92] : memref<?xf32>
          %123 = arith.mulf %76, %122 : f32
          %124 = arith.subf %121, %123 : f32
          %125 = memref.load %arg20[%115] : memref<?xf32>
          %126 = arith.addf %116, %125 : f32
          %127 = arith.mulf %126, %120 : f32
          %128 = arith.divf %124, %127 : f32
          memref.store %128, %arg3[%92] : memref<?xf32>
        }
      }
    }
    return
  }
}


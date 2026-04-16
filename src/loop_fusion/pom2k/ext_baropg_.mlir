module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_baropg_(%arg0: memref<?xf32> {polygeist.name = "rho", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "rmean", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "zz", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "ramp", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    scf.for %arg11 = %c0 to %2 step %c1 {
      scf.for %arg12 = %c0 to %7 step %c1 {
        scf.for %arg13 = %c0 to %8 step %c1 {
          %100 = arith.muli %arg12, %8 overflow<nsw> : index
          %101 = arith.addi %arg13, %100 : index
          %102 = arith.muli %arg11, %8 overflow<nsw> : index
          %103 = arith.muli %102, %7 overflow<nsw> : index
          %104 = arith.addi %101, %103 : index
          %105 = memref.load %arg0[%104] : memref<?xf32>
          %106 = memref.load %arg1[%104] : memref<?xf32>
          %107 = arith.subf %105, %106 : f32
          memref.store %107, %arg0[%104] : memref<?xf32>
        }
      }
    }
    %9 = memref.get_global @jmm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @imm1 : memref<1xi32>
    %13 = memref.get_global @grav : memref<1xf32>
    %14 = memref.load %12[%c0] : memref<1xi32>
    %15 = memref.load %4[%c0] : memref<1xi32>
    %16 = memref.load %13[%c0] : memref<1xf32>
    %17 = memref.load %arg4[%c0] : memref<?xf32>
    %18 = arith.index_cast %14 : i32 to index
    %19 = arith.index_cast %15 : i32 to index
    %20 = arith.mulf %16, %cst_0 : f32
    %21 = arith.negf %17 : f32
    %22 = arith.mulf %20, %21 : f32
    %23 = arith.addi %11, %c-1 : index
    scf.for %arg11 = %c0 to %23 step %c1 {
      %100 = arith.addi %18, %c-1 : index
      scf.for %arg12 = %c0 to %100 step %c1 {
        %101 = arith.addi %arg11, %c1 : index
        %102 = arith.muli %101, %19 overflow<nsw> : index
        %103 = arith.addi %arg12, %102 : index
        %104 = arith.addi %103, %c1 : index
        %105 = memref.load %arg5[%104] : memref<?xf32>
        %106 = memref.load %arg5[%103] : memref<?xf32>
        %107 = arith.addf %105, %106 : f32
        %108 = arith.mulf %22, %107 : f32
        %109 = memref.load %arg0[%104] : memref<?xf32>
        %110 = memref.load %arg0[%103] : memref<?xf32>
        %111 = arith.subf %109, %110 : f32
        %112 = arith.mulf %108, %111 : f32
        memref.store %112, %arg2[%104] : memref<?xf32>
      }
    }
    %24 = memref.get_global @kbm1 : memref<1xi32>
    %25 = memref.load %24[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    %27 = memref.load %9[%c0] : memref<1xi32>
    %28 = memref.load %12[%c0] : memref<1xi32>
    %29 = memref.load %4[%c0] : memref<1xi32>
    %30 = memref.load %3[%c0] : memref<1xi32>
    %31 = memref.load %13[%c0] : memref<1xf32>
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.index_cast %30 : i32 to index
    %36 = arith.mulf %31, %cst : f32
    %37 = arith.addi %26, %c-1 : index
    scf.for %arg11 = %c0 to %37 step %c1 {
      %100 = memref.load %arg4[%arg11] : memref<?xf32>
      %101 = arith.addi %arg11, %c1 : index
      %102 = memref.load %arg4[%101] : memref<?xf32>
      %103 = arith.subf %100, %102 : f32
      %104 = arith.mulf %36, %103 : f32
      %105 = arith.addf %100, %102 : f32
      %106 = arith.mulf %36, %105 : f32
      %107 = arith.addi %32, %c-1 : index
      scf.for %arg12 = %c0 to %107 step %c1 {
        %108 = arith.addi %33, %c-1 : index
        scf.for %arg13 = %c0 to %108 step %c1 {
          %109 = arith.addi %arg12, %c1 : index
          %110 = arith.muli %109, %34 overflow<nsw> : index
          %111 = arith.addi %arg13, %110 : index
          %112 = arith.muli %arg11, %34 overflow<nsw> : index
          %113 = arith.muli %112, %35 overflow<nsw> : index
          %114 = arith.addi %111, %113 : index
          %115 = arith.addi %114, %c1 : index
          %116 = memref.load %arg2[%115] : memref<?xf32>
          %117 = arith.addi %111, %c1 : index
          %118 = memref.load %arg5[%117] : memref<?xf32>
          %119 = memref.load %arg5[%111] : memref<?xf32>
          %120 = arith.addf %118, %119 : f32
          %121 = arith.mulf %104, %120 : f32
          %122 = arith.muli %101, %34 overflow<nsw> : index
          %123 = arith.muli %122, %35 overflow<nsw> : index
          %124 = arith.addi %111, %123 : index
          %125 = arith.addi %124, %c1 : index
          %126 = memref.load %arg0[%125] : memref<?xf32>
          %127 = memref.load %arg0[%124] : memref<?xf32>
          %128 = arith.subf %126, %127 : f32
          %129 = memref.load %arg0[%115] : memref<?xf32>
          %130 = arith.addf %128, %129 : f32
          %131 = memref.load %arg0[%114] : memref<?xf32>
          %132 = arith.subf %130, %131 : f32
          %133 = arith.mulf %121, %132 : f32
          %134 = arith.addf %116, %133 : f32
          %135 = arith.subf %118, %119 : f32
          %136 = arith.mulf %106, %135 : f32
          %137 = arith.addf %126, %127 : f32
          %138 = arith.subf %137, %129 : f32
          %139 = arith.subf %138, %131 : f32
          %140 = arith.mulf %136, %139 : f32
          %141 = arith.addf %134, %140 : f32
          memref.store %141, %arg2[%125] : memref<?xf32>
        }
      }
    }
    %38 = memref.load %24[%c0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = memref.load %9[%c0] : memref<1xi32>
    %41 = memref.load %12[%c0] : memref<1xi32>
    %42 = memref.load %4[%c0] : memref<1xi32>
    %43 = memref.load %3[%c0] : memref<1xi32>
    %44 = arith.index_cast %40 : i32 to index
    %45 = arith.index_cast %41 : i32 to index
    %46 = arith.index_cast %42 : i32 to index
    %47 = arith.index_cast %43 : i32 to index
    scf.for %arg11 = %c0 to %39 step %c1 {
      %100 = arith.addi %44, %c-1 : index
      scf.for %arg12 = %c0 to %100 step %c1 {
        %101 = arith.addi %45, %c-1 : index
        scf.for %arg13 = %c0 to %101 step %c1 {
          %102 = arith.addi %arg12, %c1 : index
          %103 = arith.muli %102, %46 overflow<nsw> : index
          %104 = arith.addi %arg13, %103 : index
          %105 = arith.addi %104, %c1 : index
          %106 = memref.load %arg5[%105] : memref<?xf32>
          %107 = memref.load %arg5[%104] : memref<?xf32>
          %108 = arith.addf %106, %107 : f32
          %109 = arith.mulf %108, %cst : f32
          %110 = arith.muli %arg11, %46 overflow<nsw> : index
          %111 = arith.muli %110, %47 overflow<nsw> : index
          %112 = arith.addi %104, %111 : index
          %113 = arith.addi %112, %c1 : index
          %114 = memref.load %arg2[%113] : memref<?xf32>
          %115 = arith.mulf %109, %114 : f32
          %116 = memref.load %arg6[%105] : memref<?xf32>
          %117 = arith.mulf %115, %116 : f32
          %118 = memref.load %arg9[%105] : memref<?xf32>
          %119 = memref.load %arg9[%104] : memref<?xf32>
          %120 = arith.addf %118, %119 : f32
          %121 = arith.mulf %117, %120 : f32
          memref.store %121, %arg2[%113] : memref<?xf32>
        }
      }
    }
    %48 = memref.load %9[%c0] : memref<1xi32>
    %49 = arith.index_cast %48 : i32 to index
    %50 = memref.load %12[%c0] : memref<1xi32>
    %51 = memref.load %4[%c0] : memref<1xi32>
    %52 = memref.load %13[%c0] : memref<1xf32>
    %53 = memref.load %arg4[%c0] : memref<?xf32>
    %54 = arith.index_cast %50 : i32 to index
    %55 = arith.index_cast %51 : i32 to index
    %56 = arith.mulf %52, %cst_0 : f32
    %57 = arith.negf %53 : f32
    %58 = arith.mulf %56, %57 : f32
    %59 = arith.addi %49, %c-1 : index
    scf.for %arg11 = %c0 to %59 step %c1 {
      %100 = arith.addi %54, %c-1 : index
      scf.for %arg12 = %c0 to %100 step %c1 {
        %101 = arith.addi %arg11, %c1 : index
        %102 = arith.muli %101, %55 overflow<nsw> : index
        %103 = arith.addi %arg12, %102 : index
        %104 = arith.addi %103, %c1 : index
        %105 = memref.load %arg5[%104] : memref<?xf32>
        %106 = arith.muli %arg11, %55 overflow<nsw> : index
        %107 = arith.addi %arg12, %106 : index
        %108 = arith.addi %107, %c1 : index
        %109 = memref.load %arg5[%108] : memref<?xf32>
        %110 = arith.addf %105, %109 : f32
        %111 = arith.mulf %58, %110 : f32
        %112 = memref.load %arg0[%104] : memref<?xf32>
        %113 = memref.load %arg0[%108] : memref<?xf32>
        %114 = arith.subf %112, %113 : f32
        %115 = arith.mulf %111, %114 : f32
        memref.store %115, %arg3[%104] : memref<?xf32>
      }
    }
    %60 = memref.load %24[%c0] : memref<1xi32>
    %61 = arith.index_cast %60 : i32 to index
    %62 = memref.load %9[%c0] : memref<1xi32>
    %63 = memref.load %12[%c0] : memref<1xi32>
    %64 = memref.load %4[%c0] : memref<1xi32>
    %65 = memref.load %3[%c0] : memref<1xi32>
    %66 = memref.load %13[%c0] : memref<1xf32>
    %67 = arith.index_cast %62 : i32 to index
    %68 = arith.index_cast %63 : i32 to index
    %69 = arith.index_cast %64 : i32 to index
    %70 = arith.index_cast %65 : i32 to index
    %71 = arith.mulf %66, %cst : f32
    %72 = arith.addi %61, %c-1 : index
    scf.for %arg11 = %c0 to %72 step %c1 {
      %100 = memref.load %arg4[%arg11] : memref<?xf32>
      %101 = arith.addi %arg11, %c1 : index
      %102 = memref.load %arg4[%101] : memref<?xf32>
      %103 = arith.subf %100, %102 : f32
      %104 = arith.mulf %71, %103 : f32
      %105 = arith.addf %100, %102 : f32
      %106 = arith.mulf %71, %105 : f32
      %107 = arith.addi %67, %c-1 : index
      scf.for %arg12 = %c0 to %107 step %c1 {
        %108 = arith.addi %68, %c-1 : index
        scf.for %arg13 = %c0 to %108 step %c1 {
          %109 = arith.addi %arg12, %c1 : index
          %110 = arith.muli %109, %69 overflow<nsw> : index
          %111 = arith.addi %arg13, %110 : index
          %112 = arith.muli %arg11, %69 overflow<nsw> : index
          %113 = arith.muli %112, %70 overflow<nsw> : index
          %114 = arith.addi %111, %113 : index
          %115 = arith.addi %114, %c1 : index
          %116 = memref.load %arg3[%115] : memref<?xf32>
          %117 = arith.addi %111, %c1 : index
          %118 = memref.load %arg5[%117] : memref<?xf32>
          %119 = arith.muli %arg12, %69 overflow<nsw> : index
          %120 = arith.addi %arg13, %119 : index
          %121 = arith.addi %120, %c1 : index
          %122 = memref.load %arg5[%121] : memref<?xf32>
          %123 = arith.addf %118, %122 : f32
          %124 = arith.mulf %104, %123 : f32
          %125 = arith.muli %101, %69 overflow<nsw> : index
          %126 = arith.muli %125, %70 overflow<nsw> : index
          %127 = arith.addi %111, %126 : index
          %128 = arith.addi %127, %c1 : index
          %129 = memref.load %arg0[%128] : memref<?xf32>
          %130 = arith.addi %120, %126 : index
          %131 = arith.addi %130, %c1 : index
          %132 = memref.load %arg0[%131] : memref<?xf32>
          %133 = arith.subf %129, %132 : f32
          %134 = memref.load %arg0[%115] : memref<?xf32>
          %135 = arith.addf %133, %134 : f32
          %136 = arith.addi %120, %113 : index
          %137 = arith.addi %136, %c1 : index
          %138 = memref.load %arg0[%137] : memref<?xf32>
          %139 = arith.subf %135, %138 : f32
          %140 = arith.mulf %124, %139 : f32
          %141 = arith.addf %116, %140 : f32
          %142 = arith.subf %118, %122 : f32
          %143 = arith.mulf %106, %142 : f32
          %144 = arith.addf %129, %132 : f32
          %145 = arith.subf %144, %134 : f32
          %146 = arith.subf %145, %138 : f32
          %147 = arith.mulf %143, %146 : f32
          %148 = arith.addf %141, %147 : f32
          memref.store %148, %arg3[%128] : memref<?xf32>
        }
      }
    }
    %73 = memref.load %24[%c0] : memref<1xi32>
    %74 = arith.index_cast %73 : i32 to index
    %75 = memref.load %9[%c0] : memref<1xi32>
    %76 = memref.load %12[%c0] : memref<1xi32>
    %77 = memref.load %4[%c0] : memref<1xi32>
    %78 = memref.load %3[%c0] : memref<1xi32>
    %79 = arith.index_cast %75 : i32 to index
    %80 = arith.index_cast %76 : i32 to index
    %81 = arith.index_cast %77 : i32 to index
    %82 = arith.index_cast %78 : i32 to index
    scf.for %arg11 = %c0 to %74 step %c1 {
      %100 = arith.addi %79, %c-1 : index
      scf.for %arg12 = %c0 to %100 step %c1 {
        %101 = arith.addi %80, %c-1 : index
        scf.for %arg13 = %c0 to %101 step %c1 {
          %102 = arith.addi %arg12, %c1 : index
          %103 = arith.muli %102, %81 overflow<nsw> : index
          %104 = arith.addi %arg13, %103 : index
          %105 = arith.addi %104, %c1 : index
          %106 = memref.load %arg5[%105] : memref<?xf32>
          %107 = arith.muli %arg12, %81 overflow<nsw> : index
          %108 = arith.addi %arg13, %107 : index
          %109 = arith.addi %108, %c1 : index
          %110 = memref.load %arg5[%109] : memref<?xf32>
          %111 = arith.addf %106, %110 : f32
          %112 = arith.mulf %111, %cst : f32
          %113 = arith.muli %arg11, %81 overflow<nsw> : index
          %114 = arith.muli %113, %82 overflow<nsw> : index
          %115 = arith.addi %104, %114 : index
          %116 = arith.addi %115, %c1 : index
          %117 = memref.load %arg3[%116] : memref<?xf32>
          %118 = arith.mulf %112, %117 : f32
          %119 = memref.load %arg7[%105] : memref<?xf32>
          %120 = arith.mulf %118, %119 : f32
          %121 = memref.load %arg8[%105] : memref<?xf32>
          %122 = memref.load %arg8[%109] : memref<?xf32>
          %123 = arith.addf %121, %122 : f32
          %124 = arith.mulf %120, %123 : f32
          memref.store %124, %arg3[%116] : memref<?xf32>
        }
      }
    }
    %83 = memref.load %0[%c0] : memref<1xi32>
    %84 = arith.index_cast %83 : i32 to index
    %85 = memref.load %9[%c0] : memref<1xi32>
    %86 = memref.load %12[%c0] : memref<1xi32>
    %87 = memref.load %4[%c0] : memref<1xi32>
    %88 = memref.load %3[%c0] : memref<1xi32>
    %89 = memref.load %arg10[%c0] : memref<?xf32>
    %90 = arith.index_cast %85 : i32 to index
    %91 = arith.index_cast %86 : i32 to index
    %92 = arith.index_cast %87 : i32 to index
    %93 = arith.index_cast %88 : i32 to index
    scf.for %arg11 = %c0 to %84 step %c1 {
      %100 = arith.addi %90, %c-1 : index
      scf.for %arg12 = %c0 to %100 step %c1 {
        %101 = arith.addi %91, %c-1 : index
        scf.for %arg13 = %c0 to %101 step %c1 {
          %102 = arith.addi %arg12, %c1 : index
          %103 = arith.muli %102, %92 overflow<nsw> : index
          %104 = arith.addi %arg13, %103 : index
          %105 = arith.muli %arg11, %92 overflow<nsw> : index
          %106 = arith.muli %105, %93 overflow<nsw> : index
          %107 = arith.addi %104, %106 : index
          %108 = arith.addi %107, %c1 : index
          %109 = memref.load %arg2[%108] : memref<?xf32>
          %110 = arith.mulf %89, %109 : f32
          memref.store %110, %arg2[%108] : memref<?xf32>
          %111 = memref.load %arg3[%108] : memref<?xf32>
          %112 = arith.mulf %89, %111 : f32
          memref.store %112, %arg3[%108] : memref<?xf32>
        }
      }
    }
    %94 = memref.load %0[%c0] : memref<1xi32>
    %95 = arith.index_cast %94 : i32 to index
    %96 = memref.load %3[%c0] : memref<1xi32>
    %97 = memref.load %4[%c0] : memref<1xi32>
    %98 = arith.index_cast %96 : i32 to index
    %99 = arith.index_cast %97 : i32 to index
    scf.for %arg11 = %c0 to %95 step %c1 {
      scf.for %arg12 = %c0 to %98 step %c1 {
        scf.for %arg13 = %c0 to %99 step %c1 {
          %100 = arith.muli %arg12, %99 overflow<nsw> : index
          %101 = arith.addi %arg13, %100 : index
          %102 = arith.muli %arg11, %99 overflow<nsw> : index
          %103 = arith.muli %102, %98 overflow<nsw> : index
          %104 = arith.addi %101, %103 : index
          %105 = memref.load %arg0[%104] : memref<?xf32>
          %106 = memref.load %arg1[%104] : memref<?xf32>
          %107 = arith.addf %105, %106 : f32
          memref.store %107, %arg0[%104] : memref<?xf32>
        }
      }
    }
    return
  }
}


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
          %96 = arith.muli %arg12, %8 overflow<nsw> : index
          %97 = arith.addi %arg13, %96 : index
          %98 = arith.muli %arg11, %8 overflow<nsw> : index
          %99 = arith.muli %98, %7 overflow<nsw> : index
          %100 = arith.addi %97, %99 : index
          %101 = memref.load %arg0[%100] : memref<?xf32>
          %102 = memref.load %arg1[%100] : memref<?xf32>
          %103 = arith.subf %101, %102 : f32
          memref.store %103, %arg0[%100] : memref<?xf32>
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
    scf.for %arg11 = %c1 to %11 step %c1 {
      scf.for %arg12 = %c1 to %18 step %c1 {
        %96 = arith.muli %arg11, %19 overflow<nsw> : index
        %97 = arith.addi %arg12, %96 : index
        %98 = memref.load %arg5[%97] : memref<?xf32>
        %99 = arith.addi %97, %c-1 : index
        %100 = memref.load %arg5[%99] : memref<?xf32>
        %101 = arith.addf %98, %100 : f32
        %102 = arith.mulf %22, %101 : f32
        %103 = memref.load %arg0[%97] : memref<?xf32>
        %104 = memref.load %arg0[%99] : memref<?xf32>
        %105 = arith.subf %103, %104 : f32
        %106 = arith.mulf %102, %105 : f32
        memref.store %106, %arg2[%97] : memref<?xf32>
      }
    }
    %23 = memref.get_global @kbm1 : memref<1xi32>
    %24 = memref.load %23[%c0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %26 = memref.load %9[%c0] : memref<1xi32>
    %27 = memref.load %12[%c0] : memref<1xi32>
    %28 = memref.load %4[%c0] : memref<1xi32>
    %29 = memref.load %3[%c0] : memref<1xi32>
    %30 = memref.load %13[%c0] : memref<1xf32>
    %31 = arith.index_cast %26 : i32 to index
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.mulf %30, %cst : f32
    scf.for %arg11 = %c1 to %25 step %c1 {
      %96 = arith.addi %arg11, %c-1 : index
      %97 = memref.load %arg4[%96] : memref<?xf32>
      %98 = memref.load %arg4[%arg11] : memref<?xf32>
      %99 = arith.subf %97, %98 : f32
      %100 = arith.mulf %35, %99 : f32
      %101 = arith.addf %97, %98 : f32
      %102 = arith.mulf %35, %101 : f32
      scf.for %arg12 = %c1 to %31 step %c1 {
        scf.for %arg13 = %c1 to %32 step %c1 {
          %103 = arith.muli %arg12, %33 overflow<nsw> : index
          %104 = arith.addi %arg13, %103 : index
          %105 = arith.muli %96, %33 overflow<nsw> : index
          %106 = arith.muli %105, %34 overflow<nsw> : index
          %107 = arith.addi %104, %106 : index
          %108 = memref.load %arg2[%107] : memref<?xf32>
          %109 = memref.load %arg5[%104] : memref<?xf32>
          %110 = arith.addi %104, %c-1 : index
          %111 = memref.load %arg5[%110] : memref<?xf32>
          %112 = arith.addf %109, %111 : f32
          %113 = arith.mulf %100, %112 : f32
          %114 = arith.muli %arg11, %33 overflow<nsw> : index
          %115 = arith.muli %114, %34 overflow<nsw> : index
          %116 = arith.addi %104, %115 : index
          %117 = memref.load %arg0[%116] : memref<?xf32>
          %118 = arith.addi %116, %c-1 : index
          %119 = memref.load %arg0[%118] : memref<?xf32>
          %120 = arith.subf %117, %119 : f32
          %121 = memref.load %arg0[%107] : memref<?xf32>
          %122 = arith.addf %120, %121 : f32
          %123 = arith.addi %107, %c-1 : index
          %124 = memref.load %arg0[%123] : memref<?xf32>
          %125 = arith.subf %122, %124 : f32
          %126 = arith.mulf %113, %125 : f32
          %127 = arith.addf %108, %126 : f32
          %128 = arith.subf %109, %111 : f32
          %129 = arith.mulf %102, %128 : f32
          %130 = arith.addf %117, %119 : f32
          %131 = arith.subf %130, %121 : f32
          %132 = arith.subf %131, %124 : f32
          %133 = arith.mulf %129, %132 : f32
          %134 = arith.addf %127, %133 : f32
          memref.store %134, %arg2[%116] : memref<?xf32>
        }
      }
    }
    %36 = memref.load %23[%c0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    %38 = memref.load %9[%c0] : memref<1xi32>
    %39 = memref.load %12[%c0] : memref<1xi32>
    %40 = memref.load %4[%c0] : memref<1xi32>
    %41 = memref.load %3[%c0] : memref<1xi32>
    %42 = arith.index_cast %38 : i32 to index
    %43 = arith.index_cast %39 : i32 to index
    %44 = arith.index_cast %40 : i32 to index
    %45 = arith.index_cast %41 : i32 to index
    scf.for %arg11 = %c0 to %37 step %c1 {
      scf.for %arg12 = %c1 to %42 step %c1 {
        scf.for %arg13 = %c1 to %43 step %c1 {
          %96 = arith.muli %arg12, %44 overflow<nsw> : index
          %97 = arith.addi %arg13, %96 : index
          %98 = memref.load %arg5[%97] : memref<?xf32>
          %99 = arith.addi %97, %c-1 : index
          %100 = memref.load %arg5[%99] : memref<?xf32>
          %101 = arith.addf %98, %100 : f32
          %102 = arith.mulf %101, %cst : f32
          %103 = arith.muli %arg11, %44 overflow<nsw> : index
          %104 = arith.muli %103, %45 overflow<nsw> : index
          %105 = arith.addi %97, %104 : index
          %106 = memref.load %arg2[%105] : memref<?xf32>
          %107 = arith.mulf %102, %106 : f32
          %108 = memref.load %arg6[%97] : memref<?xf32>
          %109 = arith.mulf %107, %108 : f32
          %110 = memref.load %arg9[%97] : memref<?xf32>
          %111 = memref.load %arg9[%99] : memref<?xf32>
          %112 = arith.addf %110, %111 : f32
          %113 = arith.mulf %109, %112 : f32
          memref.store %113, %arg2[%105] : memref<?xf32>
        }
      }
    }
    %46 = memref.load %9[%c0] : memref<1xi32>
    %47 = arith.index_cast %46 : i32 to index
    %48 = memref.load %12[%c0] : memref<1xi32>
    %49 = memref.load %4[%c0] : memref<1xi32>
    %50 = memref.load %13[%c0] : memref<1xf32>
    %51 = memref.load %arg4[%c0] : memref<?xf32>
    %52 = arith.index_cast %48 : i32 to index
    %53 = arith.index_cast %49 : i32 to index
    %54 = arith.mulf %50, %cst_0 : f32
    %55 = arith.negf %51 : f32
    %56 = arith.mulf %54, %55 : f32
    scf.for %arg11 = %c1 to %47 step %c1 {
      scf.for %arg12 = %c1 to %52 step %c1 {
        %96 = arith.muli %arg11, %53 overflow<nsw> : index
        %97 = arith.addi %arg12, %96 : index
        %98 = memref.load %arg5[%97] : memref<?xf32>
        %99 = arith.addi %arg11, %c-1 : index
        %100 = arith.muli %99, %53 overflow<nsw> : index
        %101 = arith.addi %arg12, %100 : index
        %102 = memref.load %arg5[%101] : memref<?xf32>
        %103 = arith.addf %98, %102 : f32
        %104 = arith.mulf %56, %103 : f32
        %105 = memref.load %arg0[%97] : memref<?xf32>
        %106 = memref.load %arg0[%101] : memref<?xf32>
        %107 = arith.subf %105, %106 : f32
        %108 = arith.mulf %104, %107 : f32
        memref.store %108, %arg3[%97] : memref<?xf32>
      }
    }
    %57 = memref.load %23[%c0] : memref<1xi32>
    %58 = arith.index_cast %57 : i32 to index
    %59 = memref.load %9[%c0] : memref<1xi32>
    %60 = memref.load %12[%c0] : memref<1xi32>
    %61 = memref.load %4[%c0] : memref<1xi32>
    %62 = memref.load %3[%c0] : memref<1xi32>
    %63 = memref.load %13[%c0] : memref<1xf32>
    %64 = arith.index_cast %59 : i32 to index
    %65 = arith.index_cast %60 : i32 to index
    %66 = arith.index_cast %61 : i32 to index
    %67 = arith.index_cast %62 : i32 to index
    %68 = arith.mulf %63, %cst : f32
    scf.for %arg11 = %c1 to %58 step %c1 {
      %96 = arith.addi %arg11, %c-1 : index
      %97 = memref.load %arg4[%96] : memref<?xf32>
      %98 = memref.load %arg4[%arg11] : memref<?xf32>
      %99 = arith.subf %97, %98 : f32
      %100 = arith.mulf %68, %99 : f32
      %101 = arith.addf %97, %98 : f32
      %102 = arith.mulf %68, %101 : f32
      scf.for %arg12 = %c1 to %64 step %c1 {
        scf.for %arg13 = %c1 to %65 step %c1 {
          %103 = arith.muli %arg12, %66 overflow<nsw> : index
          %104 = arith.addi %arg13, %103 : index
          %105 = arith.muli %96, %66 overflow<nsw> : index
          %106 = arith.muli %105, %67 overflow<nsw> : index
          %107 = arith.addi %104, %106 : index
          %108 = memref.load %arg3[%107] : memref<?xf32>
          %109 = memref.load %arg5[%104] : memref<?xf32>
          %110 = arith.addi %arg12, %c-1 : index
          %111 = arith.muli %110, %66 overflow<nsw> : index
          %112 = arith.addi %arg13, %111 : index
          %113 = memref.load %arg5[%112] : memref<?xf32>
          %114 = arith.addf %109, %113 : f32
          %115 = arith.mulf %100, %114 : f32
          %116 = arith.muli %arg11, %66 overflow<nsw> : index
          %117 = arith.muli %116, %67 overflow<nsw> : index
          %118 = arith.addi %104, %117 : index
          %119 = memref.load %arg0[%118] : memref<?xf32>
          %120 = arith.addi %112, %117 : index
          %121 = memref.load %arg0[%120] : memref<?xf32>
          %122 = arith.subf %119, %121 : f32
          %123 = memref.load %arg0[%107] : memref<?xf32>
          %124 = arith.addf %122, %123 : f32
          %125 = arith.addi %112, %106 : index
          %126 = memref.load %arg0[%125] : memref<?xf32>
          %127 = arith.subf %124, %126 : f32
          %128 = arith.mulf %115, %127 : f32
          %129 = arith.addf %108, %128 : f32
          %130 = arith.subf %109, %113 : f32
          %131 = arith.mulf %102, %130 : f32
          %132 = arith.addf %119, %121 : f32
          %133 = arith.subf %132, %123 : f32
          %134 = arith.subf %133, %126 : f32
          %135 = arith.mulf %131, %134 : f32
          %136 = arith.addf %129, %135 : f32
          memref.store %136, %arg3[%118] : memref<?xf32>
        }
      }
    }
    %69 = memref.load %23[%c0] : memref<1xi32>
    %70 = arith.index_cast %69 : i32 to index
    %71 = memref.load %9[%c0] : memref<1xi32>
    %72 = memref.load %12[%c0] : memref<1xi32>
    %73 = memref.load %4[%c0] : memref<1xi32>
    %74 = memref.load %3[%c0] : memref<1xi32>
    %75 = arith.index_cast %71 : i32 to index
    %76 = arith.index_cast %72 : i32 to index
    %77 = arith.index_cast %73 : i32 to index
    %78 = arith.index_cast %74 : i32 to index
    scf.for %arg11 = %c0 to %70 step %c1 {
      scf.for %arg12 = %c1 to %75 step %c1 {
        scf.for %arg13 = %c1 to %76 step %c1 {
          %96 = arith.muli %arg12, %77 overflow<nsw> : index
          %97 = arith.addi %arg13, %96 : index
          %98 = memref.load %arg5[%97] : memref<?xf32>
          %99 = arith.addi %arg12, %c-1 : index
          %100 = arith.muli %99, %77 overflow<nsw> : index
          %101 = arith.addi %arg13, %100 : index
          %102 = memref.load %arg5[%101] : memref<?xf32>
          %103 = arith.addf %98, %102 : f32
          %104 = arith.mulf %103, %cst : f32
          %105 = arith.muli %arg11, %77 overflow<nsw> : index
          %106 = arith.muli %105, %78 overflow<nsw> : index
          %107 = arith.addi %97, %106 : index
          %108 = memref.load %arg3[%107] : memref<?xf32>
          %109 = arith.mulf %104, %108 : f32
          %110 = memref.load %arg7[%97] : memref<?xf32>
          %111 = arith.mulf %109, %110 : f32
          %112 = memref.load %arg8[%97] : memref<?xf32>
          %113 = memref.load %arg8[%101] : memref<?xf32>
          %114 = arith.addf %112, %113 : f32
          %115 = arith.mulf %111, %114 : f32
          memref.store %115, %arg3[%107] : memref<?xf32>
        }
      }
    }
    %79 = memref.load %0[%c0] : memref<1xi32>
    %80 = arith.index_cast %79 : i32 to index
    %81 = memref.load %9[%c0] : memref<1xi32>
    %82 = memref.load %12[%c0] : memref<1xi32>
    %83 = memref.load %4[%c0] : memref<1xi32>
    %84 = memref.load %3[%c0] : memref<1xi32>
    %85 = memref.load %arg10[%c0] : memref<?xf32>
    %86 = arith.index_cast %81 : i32 to index
    %87 = arith.index_cast %82 : i32 to index
    %88 = arith.index_cast %83 : i32 to index
    %89 = arith.index_cast %84 : i32 to index
    scf.for %arg11 = %c0 to %80 step %c1 {
      scf.for %arg12 = %c1 to %86 step %c1 {
        scf.for %arg13 = %c1 to %87 step %c1 {
          %96 = arith.muli %arg12, %88 overflow<nsw> : index
          %97 = arith.addi %arg13, %96 : index
          %98 = arith.muli %arg11, %88 overflow<nsw> : index
          %99 = arith.muli %98, %89 overflow<nsw> : index
          %100 = arith.addi %97, %99 : index
          %101 = memref.load %arg2[%100] : memref<?xf32>
          %102 = arith.mulf %85, %101 : f32
          memref.store %102, %arg2[%100] : memref<?xf32>
          %103 = memref.load %arg3[%100] : memref<?xf32>
          %104 = arith.mulf %85, %103 : f32
          memref.store %104, %arg3[%100] : memref<?xf32>
        }
      }
    }
    %90 = memref.load %0[%c0] : memref<1xi32>
    %91 = arith.index_cast %90 : i32 to index
    %92 = memref.load %3[%c0] : memref<1xi32>
    %93 = memref.load %4[%c0] : memref<1xi32>
    %94 = arith.index_cast %92 : i32 to index
    %95 = arith.index_cast %93 : i32 to index
    scf.for %arg11 = %c0 to %91 step %c1 {
      scf.for %arg12 = %c0 to %94 step %c1 {
        scf.for %arg13 = %c0 to %95 step %c1 {
          %96 = arith.muli %arg12, %95 overflow<nsw> : index
          %97 = arith.addi %arg13, %96 : index
          %98 = arith.muli %arg11, %95 overflow<nsw> : index
          %99 = arith.muli %98, %94 overflow<nsw> : index
          %100 = arith.addi %97, %99 : index
          %101 = memref.load %arg0[%100] : memref<?xf32>
          %102 = memref.load %arg1[%100] : memref<?xf32>
          %103 = arith.addf %101, %102 : f32
          memref.store %103, %arg0[%100] : memref<?xf32>
        }
      }
    }
    return
  }
}


module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advv_(%arg0: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advy", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 1.250000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %cst_2 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    scf.for %arg18 = %c0 to %2 step %c1 {
      scf.for %arg19 = %c0 to %7 step %c1 {
        scf.for %arg20 = %c0 to %8 step %c1 {
          %44 = arith.muli %arg19, %8 overflow<nsw> : index
          %45 = arith.addi %arg20, %44 : index
          %46 = arith.muli %arg18, %8 overflow<nsw> : index
          %47 = arith.muli %46, %7 overflow<nsw> : index
          %48 = arith.addi %45, %47 : index
          memref.store %cst_2, %arg1[%48] : memref<?xf32>
        }
      }
    }
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.load %3[%c0] : memref<1xi32>
    %13 = memref.load %4[%c0] : memref<1xi32>
    %14 = arith.index_cast %12 : i32 to index
    %15 = arith.index_cast %13 : i32 to index
    scf.for %arg18 = %c1 to %11 step %c1 {
      scf.for %arg19 = %c1 to %14 step %c1 {
        scf.for %arg20 = %c0 to %15 step %c1 {
          %44 = arith.muli %arg19, %15 overflow<nsw> : index
          %45 = arith.addi %arg20, %44 : index
          %46 = arith.muli %arg18, %15 overflow<nsw> : index
          %47 = arith.muli %46, %14 overflow<nsw> : index
          %48 = arith.addi %45, %47 : index
          %49 = memref.load %arg4[%48] : memref<?xf32>
          %50 = arith.addi %arg19, %c-1 : index
          %51 = arith.muli %50, %15 overflow<nsw> : index
          %52 = arith.addi %arg20, %51 : index
          %53 = arith.addi %52, %47 : index
          %54 = memref.load %arg4[%53] : memref<?xf32>
          %55 = arith.addf %49, %54 : f32
          %56 = arith.mulf %55, %cst_1 : f32
          %57 = memref.load %arg0[%48] : memref<?xf32>
          %58 = arith.addi %arg18, %c-1 : index
          %59 = arith.muli %58, %15 overflow<nsw> : index
          %60 = arith.muli %59, %14 overflow<nsw> : index
          %61 = arith.addi %45, %60 : index
          %62 = memref.load %arg0[%61] : memref<?xf32>
          %63 = arith.addf %57, %62 : f32
          %64 = arith.mulf %56, %63 : f32
          memref.store %64, %arg1[%48] : memref<?xf32>
        }
      }
    }
    %16 = memref.load %9[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @jmm1 : memref<1xi32>
    %19 = memref.get_global @imm1 : memref<1xi32>
    %20 = memref.get_global @grav : memref<1xf32>
    %21 = memref.load %18[%c0] : memref<1xi32>
    %22 = memref.load %19[%c0] : memref<1xi32>
    %23 = memref.load %4[%c0] : memref<1xi32>
    %24 = memref.load %3[%c0] : memref<1xi32>
    %25 = memref.load %20[%c0] : memref<1xf32>
    %26 = arith.index_cast %21 : i32 to index
    %27 = arith.index_cast %22 : i32 to index
    %28 = arith.index_cast %23 : i32 to index
    %29 = arith.index_cast %24 : i32 to index
    %30 = arith.mulf %25, %cst_0 : f32
    scf.for %arg18 = %c0 to %17 step %c1 {
      %44 = memref.load %arg8[%arg18] : memref<?xf32>
      scf.for %arg19 = %c1 to %26 step %c1 {
        scf.for %arg20 = %c1 to %27 step %c1 {
          %45 = arith.muli %arg19, %28 overflow<nsw> : index
          %46 = arith.addi %arg20, %45 : index
          %47 = arith.muli %arg18, %28 overflow<nsw> : index
          %48 = arith.muli %47, %29 overflow<nsw> : index
          %49 = arith.addi %46, %48 : index
          %50 = memref.load %arg5[%49] : memref<?xf32>
          %51 = memref.load %arg1[%49] : memref<?xf32>
          %52 = arith.addi %arg18, %c1 : index
          %53 = arith.muli %52, %28 overflow<nsw> : index
          %54 = arith.muli %53, %29 overflow<nsw> : index
          %55 = arith.addi %46, %54 : index
          %56 = memref.load %arg1[%55] : memref<?xf32>
          %57 = arith.subf %51, %56 : f32
          %58 = memref.load %arg6[%46] : memref<?xf32>
          %59 = arith.mulf %57, %58 : f32
          %60 = arith.divf %59, %44 : f32
          %61 = arith.addf %50, %60 : f32
          %62 = arith.mulf %58, %cst_1 : f32
          %63 = memref.load %arg9[%46] : memref<?xf32>
          %64 = memref.load %arg10[%46] : memref<?xf32>
          %65 = arith.mulf %63, %64 : f32
          %66 = arith.addi %49, %c1 : index
          %67 = memref.load %arg3[%66] : memref<?xf32>
          %68 = memref.load %arg3[%49] : memref<?xf32>
          %69 = arith.addf %67, %68 : f32
          %70 = arith.mulf %65, %69 : f32
          %71 = arith.addi %arg19, %c-1 : index
          %72 = arith.muli %71, %28 overflow<nsw> : index
          %73 = arith.addi %arg20, %72 : index
          %74 = memref.load %arg9[%73] : memref<?xf32>
          %75 = memref.load %arg10[%73] : memref<?xf32>
          %76 = arith.mulf %74, %75 : f32
          %77 = arith.addi %73, %48 : index
          %78 = arith.addi %77, %c1 : index
          %79 = memref.load %arg3[%78] : memref<?xf32>
          %80 = memref.load %arg3[%77] : memref<?xf32>
          %81 = arith.addf %79, %80 : f32
          %82 = arith.mulf %76, %81 : f32
          %83 = arith.addf %70, %82 : f32
          %84 = arith.mulf %62, %83 : f32
          %85 = arith.addf %61, %84 : f32
          %86 = arith.addf %64, %75 : f32
          %87 = arith.mulf %30, %86 : f32
          %88 = memref.load %arg11[%46] : memref<?xf32>
          %89 = memref.load %arg11[%73] : memref<?xf32>
          %90 = arith.subf %88, %89 : f32
          %91 = memref.load %arg12[%46] : memref<?xf32>
          %92 = arith.addf %90, %91 : f32
          %93 = memref.load %arg12[%73] : memref<?xf32>
          %94 = arith.subf %92, %93 : f32
          %95 = memref.load %arg13[%46] : memref<?xf32>
          %96 = memref.load %arg13[%73] : memref<?xf32>
          %97 = arith.subf %95, %96 : f32
          %98 = arith.mulf %97, %cst : f32
          %99 = arith.addf %94, %98 : f32
          %100 = arith.mulf %87, %99 : f32
          %101 = memref.load %arg7[%46] : memref<?xf32>
          %102 = memref.load %arg7[%73] : memref<?xf32>
          %103 = arith.addf %101, %102 : f32
          %104 = arith.mulf %100, %103 : f32
          %105 = arith.addf %85, %104 : f32
          %106 = memref.load %arg14[%49] : memref<?xf32>
          %107 = arith.addf %105, %106 : f32
          memref.store %107, %arg1[%49] : memref<?xf32>
        }
      }
    }
    %31 = memref.load %9[%c0] : memref<1xi32>
    %32 = arith.index_cast %31 : i32 to index
    %33 = memref.get_global @dti2 : memref<1xf32>
    %34 = memref.load %18[%c0] : memref<1xi32>
    %35 = memref.load %19[%c0] : memref<1xi32>
    %36 = memref.load %4[%c0] : memref<1xi32>
    %37 = memref.load %3[%c0] : memref<1xi32>
    %38 = memref.load %33[%c0] : memref<1xf32>
    %39 = arith.index_cast %34 : i32 to index
    %40 = arith.index_cast %35 : i32 to index
    %41 = arith.index_cast %36 : i32 to index
    %42 = arith.index_cast %37 : i32 to index
    %43 = arith.mulf %38, %cst : f32
    scf.for %arg18 = %c0 to %32 step %c1 {
      scf.for %arg19 = %c1 to %39 step %c1 {
        scf.for %arg20 = %c1 to %40 step %c1 {
          %44 = arith.muli %arg19, %41 overflow<nsw> : index
          %45 = arith.addi %arg20, %44 : index
          %46 = memref.load %arg15[%45] : memref<?xf32>
          %47 = memref.load %arg17[%45] : memref<?xf32>
          %48 = arith.addf %46, %47 : f32
          %49 = arith.addi %arg19, %c-1 : index
          %50 = arith.muli %49, %41 overflow<nsw> : index
          %51 = arith.addi %arg20, %50 : index
          %52 = memref.load %arg15[%51] : memref<?xf32>
          %53 = arith.addf %48, %52 : f32
          %54 = memref.load %arg17[%51] : memref<?xf32>
          %55 = arith.addf %53, %54 : f32
          %56 = memref.load %arg6[%45] : memref<?xf32>
          %57 = arith.mulf %55, %56 : f32
          %58 = arith.muli %arg18, %41 overflow<nsw> : index
          %59 = arith.muli %58, %42 overflow<nsw> : index
          %60 = arith.addi %45, %59 : index
          %61 = memref.load %arg2[%60] : memref<?xf32>
          %62 = arith.mulf %57, %61 : f32
          %63 = memref.load %arg1[%60] : memref<?xf32>
          %64 = arith.mulf %43, %63 : f32
          %65 = arith.subf %62, %64 : f32
          %66 = memref.load %arg16[%45] : memref<?xf32>
          %67 = arith.addf %46, %66 : f32
          %68 = arith.addf %67, %52 : f32
          %69 = memref.load %arg16[%51] : memref<?xf32>
          %70 = arith.addf %68, %69 : f32
          %71 = arith.mulf %70, %56 : f32
          %72 = arith.divf %65, %71 : f32
          memref.store %72, %arg1[%60] : memref<?xf32>
        }
      }
    }
    return
  }
}


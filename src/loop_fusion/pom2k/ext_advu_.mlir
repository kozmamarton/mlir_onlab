module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advu_(%arg0: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advx", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "egb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
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
          %45 = arith.muli %arg19, %8 overflow<nsw> : index
          %46 = arith.addi %arg20, %45 : index
          %47 = arith.muli %arg18, %8 overflow<nsw> : index
          %48 = arith.muli %47, %7 overflow<nsw> : index
          %49 = arith.addi %46, %48 : index
          memref.store %cst_2, %arg1[%49] : memref<?xf32>
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
    %16 = arith.addi %11, %c-1 : index
    scf.for %arg18 = %c0 to %16 step %c1 {
      scf.for %arg19 = %c0 to %14 step %c1 {
        %45 = arith.addi %15, %c-1 : index
        scf.for %arg20 = %c0 to %45 step %c1 {
          %46 = arith.muli %arg19, %15 overflow<nsw> : index
          %47 = arith.addi %arg20, %46 : index
          %48 = arith.addi %arg18, %c1 : index
          %49 = arith.muli %48, %15 overflow<nsw> : index
          %50 = arith.muli %49, %14 overflow<nsw> : index
          %51 = arith.addi %47, %50 : index
          %52 = arith.addi %51, %c1 : index
          %53 = memref.load %arg4[%52] : memref<?xf32>
          %54 = memref.load %arg4[%51] : memref<?xf32>
          %55 = arith.addf %53, %54 : f32
          %56 = arith.mulf %55, %cst_1 : f32
          %57 = memref.load %arg0[%52] : memref<?xf32>
          %58 = arith.muli %arg18, %15 overflow<nsw> : index
          %59 = arith.muli %58, %14 overflow<nsw> : index
          %60 = arith.addi %47, %59 : index
          %61 = arith.addi %60, %c1 : index
          %62 = memref.load %arg0[%61] : memref<?xf32>
          %63 = arith.addf %57, %62 : f32
          %64 = arith.mulf %56, %63 : f32
          memref.store %64, %arg1[%52] : memref<?xf32>
        }
      }
    }
    %17 = memref.load %9[%c0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.get_global @jmm1 : memref<1xi32>
    %20 = memref.get_global @imm1 : memref<1xi32>
    %21 = memref.get_global @grav : memref<1xf32>
    %22 = memref.load %19[%c0] : memref<1xi32>
    %23 = memref.load %20[%c0] : memref<1xi32>
    %24 = memref.load %4[%c0] : memref<1xi32>
    %25 = memref.load %3[%c0] : memref<1xi32>
    %26 = memref.load %21[%c0] : memref<1xf32>
    %27 = arith.index_cast %22 : i32 to index
    %28 = arith.index_cast %23 : i32 to index
    %29 = arith.index_cast %24 : i32 to index
    %30 = arith.index_cast %25 : i32 to index
    %31 = arith.mulf %26, %cst_0 : f32
    scf.for %arg18 = %c0 to %18 step %c1 {
      %45 = memref.load %arg8[%arg18] : memref<?xf32>
      %46 = arith.addi %27, %c-1 : index
      scf.for %arg19 = %c0 to %46 step %c1 {
        %47 = arith.addi %28, %c-1 : index
        scf.for %arg20 = %c0 to %47 step %c1 {
          %48 = arith.addi %arg19, %c1 : index
          %49 = arith.muli %48, %29 overflow<nsw> : index
          %50 = arith.addi %arg20, %49 : index
          %51 = arith.muli %arg18, %29 overflow<nsw> : index
          %52 = arith.muli %51, %30 overflow<nsw> : index
          %53 = arith.addi %50, %52 : index
          %54 = arith.addi %53, %c1 : index
          %55 = memref.load %arg5[%54] : memref<?xf32>
          %56 = memref.load %arg1[%54] : memref<?xf32>
          %57 = arith.addi %arg18, %c1 : index
          %58 = arith.muli %57, %29 overflow<nsw> : index
          %59 = arith.muli %58, %30 overflow<nsw> : index
          %60 = arith.addi %50, %59 : index
          %61 = arith.addi %60, %c1 : index
          %62 = memref.load %arg1[%61] : memref<?xf32>
          %63 = arith.subf %56, %62 : f32
          %64 = arith.addi %50, %c1 : index
          %65 = memref.load %arg6[%64] : memref<?xf32>
          %66 = arith.mulf %63, %65 : f32
          %67 = arith.divf %66, %45 : f32
          %68 = arith.addf %55, %67 : f32
          %69 = arith.mulf %65, %cst_1 : f32
          %70 = memref.load %arg9[%64] : memref<?xf32>
          %71 = memref.load %arg10[%64] : memref<?xf32>
          %72 = arith.mulf %70, %71 : f32
          %73 = arith.addi %arg19, %c2 : index
          %74 = arith.muli %73, %29 overflow<nsw> : index
          %75 = arith.addi %arg20, %74 : index
          %76 = arith.addi %75, %52 : index
          %77 = arith.addi %76, %c1 : index
          %78 = memref.load %arg3[%77] : memref<?xf32>
          %79 = memref.load %arg3[%54] : memref<?xf32>
          %80 = arith.addf %78, %79 : f32
          %81 = arith.mulf %72, %80 : f32
          %82 = memref.load %arg9[%50] : memref<?xf32>
          %83 = memref.load %arg10[%50] : memref<?xf32>
          %84 = arith.mulf %82, %83 : f32
          %85 = memref.load %arg3[%76] : memref<?xf32>
          %86 = memref.load %arg3[%53] : memref<?xf32>
          %87 = arith.addf %85, %86 : f32
          %88 = arith.mulf %84, %87 : f32
          %89 = arith.addf %81, %88 : f32
          %90 = arith.mulf %69, %89 : f32
          %91 = arith.subf %68, %90 : f32
          %92 = arith.addf %71, %83 : f32
          %93 = arith.mulf %31, %92 : f32
          %94 = memref.load %arg11[%64] : memref<?xf32>
          %95 = memref.load %arg11[%50] : memref<?xf32>
          %96 = arith.subf %94, %95 : f32
          %97 = memref.load %arg12[%64] : memref<?xf32>
          %98 = arith.addf %96, %97 : f32
          %99 = memref.load %arg12[%50] : memref<?xf32>
          %100 = arith.subf %98, %99 : f32
          %101 = memref.load %arg13[%64] : memref<?xf32>
          %102 = memref.load %arg13[%50] : memref<?xf32>
          %103 = arith.subf %101, %102 : f32
          %104 = arith.mulf %103, %cst : f32
          %105 = arith.addf %100, %104 : f32
          %106 = arith.mulf %93, %105 : f32
          %107 = memref.load %arg7[%64] : memref<?xf32>
          %108 = memref.load %arg7[%50] : memref<?xf32>
          %109 = arith.addf %107, %108 : f32
          %110 = arith.mulf %106, %109 : f32
          %111 = arith.addf %91, %110 : f32
          %112 = memref.load %arg14[%54] : memref<?xf32>
          %113 = arith.addf %111, %112 : f32
          memref.store %113, %arg1[%54] : memref<?xf32>
        }
      }
    }
    %32 = memref.load %9[%c0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %34 = memref.get_global @dti2 : memref<1xf32>
    %35 = memref.load %19[%c0] : memref<1xi32>
    %36 = memref.load %20[%c0] : memref<1xi32>
    %37 = memref.load %4[%c0] : memref<1xi32>
    %38 = memref.load %3[%c0] : memref<1xi32>
    %39 = memref.load %34[%c0] : memref<1xf32>
    %40 = arith.index_cast %35 : i32 to index
    %41 = arith.index_cast %36 : i32 to index
    %42 = arith.index_cast %37 : i32 to index
    %43 = arith.index_cast %38 : i32 to index
    %44 = arith.mulf %39, %cst : f32
    scf.for %arg18 = %c0 to %33 step %c1 {
      %45 = arith.addi %40, %c-1 : index
      scf.for %arg19 = %c0 to %45 step %c1 {
        %46 = arith.addi %41, %c-1 : index
        scf.for %arg20 = %c0 to %46 step %c1 {
          %47 = arith.addi %arg19, %c1 : index
          %48 = arith.muli %47, %42 overflow<nsw> : index
          %49 = arith.addi %arg20, %48 : index
          %50 = arith.addi %49, %c1 : index
          %51 = memref.load %arg15[%50] : memref<?xf32>
          %52 = memref.load %arg17[%50] : memref<?xf32>
          %53 = arith.addf %51, %52 : f32
          %54 = memref.load %arg15[%49] : memref<?xf32>
          %55 = arith.addf %53, %54 : f32
          %56 = memref.load %arg17[%49] : memref<?xf32>
          %57 = arith.addf %55, %56 : f32
          %58 = memref.load %arg6[%50] : memref<?xf32>
          %59 = arith.mulf %57, %58 : f32
          %60 = arith.muli %arg18, %42 overflow<nsw> : index
          %61 = arith.muli %60, %43 overflow<nsw> : index
          %62 = arith.addi %49, %61 : index
          %63 = arith.addi %62, %c1 : index
          %64 = memref.load %arg2[%63] : memref<?xf32>
          %65 = arith.mulf %59, %64 : f32
          %66 = memref.load %arg1[%63] : memref<?xf32>
          %67 = arith.mulf %44, %66 : f32
          %68 = arith.subf %65, %67 : f32
          %69 = memref.load %arg16[%50] : memref<?xf32>
          %70 = arith.addf %51, %69 : f32
          %71 = arith.addf %70, %54 : f32
          %72 = memref.load %arg16[%49] : memref<?xf32>
          %73 = arith.addf %71, %72 : f32
          %74 = arith.mulf %73, %58 : f32
          %75 = arith.divf %68, %74 : f32
          memref.store %75, %arg1[%63] : memref<?xf32>
        }
      }
    }
    return
  }
}


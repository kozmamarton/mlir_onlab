module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_advq_(%arg0: memref<?xf32> {polygeist.name = "qb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "qf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 5.000000e-01 : f32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %cst_1 = arith.constant 1.250000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    scf.for %arg19 = %c1 to %2 step %c1 {
      scf.for %arg20 = %c1 to %7 step %c1 {
        scf.for %arg21 = %c1 to %8 step %c1 {
          %29 = arith.muli %arg20, %8 overflow<nsw> : index
          %30 = arith.addi %arg21, %29 : index
          %31 = arith.muli %arg19, %8 overflow<nsw> : index
          %32 = arith.muli %31, %7 overflow<nsw> : index
          %33 = arith.addi %30, %32 : index
          %34 = memref.load %arg1[%33] : memref<?xf32>
          %35 = arith.addi %33, %c-1 : index
          %36 = memref.load %arg1[%35] : memref<?xf32>
          %37 = arith.addf %34, %36 : f32
          %38 = arith.mulf %37, %cst_1 : f32
          %39 = memref.load %arg5[%30] : memref<?xf32>
          %40 = arith.addi %30, %c-1 : index
          %41 = memref.load %arg5[%40] : memref<?xf32>
          %42 = arith.addf %39, %41 : f32
          %43 = arith.mulf %38, %42 : f32
          %44 = memref.load %arg6[%33] : memref<?xf32>
          %45 = arith.addi %arg19, %c-1 : index
          %46 = arith.muli %45, %8 overflow<nsw> : index
          %47 = arith.muli %46, %7 overflow<nsw> : index
          %48 = arith.addi %30, %47 : index
          %49 = memref.load %arg6[%48] : memref<?xf32>
          %50 = arith.addf %44, %49 : f32
          %51 = arith.mulf %43, %50 : f32
          memref.store %51, %arg3[%33] : memref<?xf32>
          %52 = memref.load %arg1[%33] : memref<?xf32>
          %53 = arith.addi %arg20, %c-1 : index
          %54 = arith.muli %53, %8 overflow<nsw> : index
          %55 = arith.addi %arg21, %54 : index
          %56 = arith.addi %55, %32 : index
          %57 = memref.load %arg1[%56] : memref<?xf32>
          %58 = arith.addf %52, %57 : f32
          %59 = arith.mulf %58, %cst_1 : f32
          %60 = memref.load %arg5[%30] : memref<?xf32>
          %61 = memref.load %arg5[%55] : memref<?xf32>
          %62 = arith.addf %60, %61 : f32
          %63 = arith.mulf %59, %62 : f32
          %64 = memref.load %arg7[%33] : memref<?xf32>
          %65 = memref.load %arg7[%48] : memref<?xf32>
          %66 = arith.addf %64, %65 : f32
          %67 = arith.mulf %63, %66 : f32
          memref.store %67, %arg4[%33] : memref<?xf32>
        }
      }
    }
    %9 = memref.load %0[%c0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    %11 = memref.load %3[%c0] : memref<1xi32>
    %12 = memref.load %4[%c0] : memref<1xi32>
    %13 = arith.index_cast %11 : i32 to index
    %14 = arith.index_cast %12 : i32 to index
    scf.for %arg19 = %c1 to %10 step %c1 {
      scf.for %arg20 = %c1 to %13 step %c1 {
        scf.for %arg21 = %c1 to %14 step %c1 {
          %29 = arith.muli %arg20, %14 overflow<nsw> : index
          %30 = arith.addi %arg21, %29 : index
          %31 = memref.load %arg10[%30] : memref<?xf32>
          %32 = arith.mulf %31, %cst_0 : f32
          %33 = arith.muli %arg19, %14 overflow<nsw> : index
          %34 = arith.muli %33, %13 overflow<nsw> : index
          %35 = arith.addi %30, %34 : index
          %36 = memref.load %arg8[%35] : memref<?xf32>
          %37 = arith.addi %35, %c-1 : index
          %38 = memref.load %arg8[%37] : memref<?xf32>
          %39 = arith.addf %36, %38 : f32
          %40 = arith.addi %arg19, %c-1 : index
          %41 = arith.muli %40, %14 overflow<nsw> : index
          %42 = arith.muli %41, %13 overflow<nsw> : index
          %43 = arith.addi %30, %42 : index
          %44 = memref.load %arg8[%43] : memref<?xf32>
          %45 = arith.addf %39, %44 : f32
          %46 = arith.addi %43, %c-1 : index
          %47 = memref.load %arg8[%46] : memref<?xf32>
          %48 = arith.addf %45, %47 : f32
          %49 = arith.mulf %32, %48 : f32
          %50 = memref.load %arg9[%30] : memref<?xf32>
          %51 = arith.addi %30, %c-1 : index
          %52 = memref.load %arg9[%51] : memref<?xf32>
          %53 = arith.addf %50, %52 : f32
          %54 = arith.mulf %49, %53 : f32
          %55 = memref.load %arg0[%35] : memref<?xf32>
          %56 = memref.load %arg0[%37] : memref<?xf32>
          %57 = arith.subf %55, %56 : f32
          %58 = arith.mulf %54, %57 : f32
          %59 = memref.load %arg11[%30] : memref<?xf32>
          %60 = memref.load %arg11[%51] : memref<?xf32>
          %61 = arith.addf %59, %60 : f32
          %62 = arith.divf %58, %61 : f32
          %63 = memref.load %arg3[%35] : memref<?xf32>
          %64 = arith.subf %63, %62 : f32
          memref.store %64, %arg3[%35] : memref<?xf32>
          %65 = memref.load %arg12[%30] : memref<?xf32>
          %66 = arith.mulf %65, %cst_0 : f32
          %67 = memref.load %arg8[%35] : memref<?xf32>
          %68 = arith.addi %arg20, %c-1 : index
          %69 = arith.muli %68, %14 overflow<nsw> : index
          %70 = arith.addi %arg21, %69 : index
          %71 = arith.addi %70, %34 : index
          %72 = memref.load %arg8[%71] : memref<?xf32>
          %73 = arith.addf %67, %72 : f32
          %74 = memref.load %arg8[%43] : memref<?xf32>
          %75 = arith.addf %73, %74 : f32
          %76 = arith.addi %70, %42 : index
          %77 = memref.load %arg8[%76] : memref<?xf32>
          %78 = arith.addf %75, %77 : f32
          %79 = arith.mulf %66, %78 : f32
          %80 = memref.load %arg9[%30] : memref<?xf32>
          %81 = memref.load %arg9[%70] : memref<?xf32>
          %82 = arith.addf %80, %81 : f32
          %83 = arith.mulf %79, %82 : f32
          %84 = memref.load %arg0[%35] : memref<?xf32>
          %85 = memref.load %arg0[%71] : memref<?xf32>
          %86 = arith.subf %84, %85 : f32
          %87 = arith.mulf %83, %86 : f32
          %88 = memref.load %arg13[%30] : memref<?xf32>
          %89 = memref.load %arg13[%70] : memref<?xf32>
          %90 = arith.addf %88, %89 : f32
          %91 = arith.divf %87, %90 : f32
          %92 = memref.load %arg4[%35] : memref<?xf32>
          %93 = arith.subf %92, %91 : f32
          memref.store %93, %arg4[%35] : memref<?xf32>
          %94 = memref.load %arg13[%30] : memref<?xf32>
          %95 = memref.load %arg13[%51] : memref<?xf32>
          %96 = arith.addf %94, %95 : f32
          %97 = arith.mulf %96, %cst : f32
          %98 = memref.load %arg3[%35] : memref<?xf32>
          %99 = arith.mulf %98, %97 : f32
          memref.store %99, %arg3[%35] : memref<?xf32>
          %100 = memref.load %arg11[%30] : memref<?xf32>
          %101 = memref.load %arg11[%70] : memref<?xf32>
          %102 = arith.addf %100, %101 : f32
          %103 = arith.mulf %102, %cst : f32
          %104 = memref.load %arg4[%35] : memref<?xf32>
          %105 = arith.mulf %104, %103 : f32
          memref.store %105, %arg4[%35] : memref<?xf32>
        }
      }
    }
    %15 = memref.load %0[%c0] : memref<1xi32>
    %16 = arith.index_cast %15 : i32 to index
    %17 = memref.get_global @jmm1 : memref<1xi32>
    %18 = memref.get_global @imm1 : memref<1xi32>
    %19 = memref.get_global @dti2 : memref<1xf32>
    %20 = memref.load %17[%c0] : memref<1xi32>
    %21 = memref.load %18[%c0] : memref<1xi32>
    %22 = memref.load %4[%c0] : memref<1xi32>
    %23 = memref.load %3[%c0] : memref<1xi32>
    %24 = memref.load %19[%c0] : memref<1xf32>
    %25 = arith.index_cast %20 : i32 to index
    %26 = arith.index_cast %21 : i32 to index
    %27 = arith.index_cast %22 : i32 to index
    %28 = arith.index_cast %23 : i32 to index
    scf.for %arg19 = %c1 to %16 step %c1 {
      %29 = memref.load %arg15[%arg19] : memref<?xf32>
      %30 = arith.addi %arg19, %c-1 : index
      %31 = memref.load %arg15[%30] : memref<?xf32>
      %32 = arith.addf %29, %31 : f32
      scf.for %arg20 = %c1 to %25 step %c1 {
        scf.for %arg21 = %c1 to %26 step %c1 {
          %33 = arith.muli %arg20, %27 overflow<nsw> : index
          %34 = arith.addi %arg21, %33 : index
          %35 = arith.muli %30, %27 overflow<nsw> : index
          %36 = arith.muli %35, %28 overflow<nsw> : index
          %37 = arith.addi %34, %36 : index
          %38 = memref.load %arg14[%37] : memref<?xf32>
          %39 = memref.load %arg1[%37] : memref<?xf32>
          %40 = arith.mulf %38, %39 : f32
          %41 = arith.addi %arg19, %c1 : index
          %42 = arith.muli %41, %27 overflow<nsw> : index
          %43 = arith.muli %42, %28 overflow<nsw> : index
          %44 = arith.addi %34, %43 : index
          %45 = memref.load %arg14[%44] : memref<?xf32>
          %46 = memref.load %arg1[%44] : memref<?xf32>
          %47 = arith.mulf %45, %46 : f32
          %48 = arith.subf %40, %47 : f32
          %49 = memref.load %arg16[%34] : memref<?xf32>
          %50 = arith.mulf %48, %49 : f32
          %51 = arith.divf %50, %32 : f32
          %52 = arith.muli %arg19, %27 overflow<nsw> : index
          %53 = arith.muli %52, %28 overflow<nsw> : index
          %54 = arith.addi %34, %53 : index
          %55 = arith.addi %54, %c1 : index
          %56 = memref.load %arg3[%55] : memref<?xf32>
          %57 = arith.addf %51, %56 : f32
          %58 = memref.load %arg3[%54] : memref<?xf32>
          %59 = arith.subf %57, %58 : f32
          %60 = arith.addi %arg20, %c1 : index
          %61 = arith.muli %60, %27 overflow<nsw> : index
          %62 = arith.addi %arg21, %61 : index
          %63 = arith.addi %62, %53 : index
          %64 = memref.load %arg4[%63] : memref<?xf32>
          %65 = arith.addf %59, %64 : f32
          %66 = memref.load %arg4[%54] : memref<?xf32>
          %67 = arith.subf %65, %66 : f32
          memref.store %67, %arg2[%54] : memref<?xf32>
          %68 = memref.load %arg9[%34] : memref<?xf32>
          %69 = memref.load %arg17[%34] : memref<?xf32>
          %70 = arith.addf %68, %69 : f32
          %71 = memref.load %arg16[%34] : memref<?xf32>
          %72 = arith.mulf %70, %71 : f32
          %73 = memref.load %arg0[%54] : memref<?xf32>
          %74 = arith.mulf %72, %73 : f32
          %75 = memref.load %arg2[%54] : memref<?xf32>
          %76 = arith.mulf %24, %75 : f32
          %77 = arith.subf %74, %76 : f32
          %78 = memref.load %arg18[%34] : memref<?xf32>
          %79 = arith.addf %68, %78 : f32
          %80 = arith.mulf %79, %71 : f32
          %81 = arith.divf %77, %80 : f32
          memref.store %81, %arg2[%54] : memref<?xf32>
        }
      }
    }
    return
  }
}


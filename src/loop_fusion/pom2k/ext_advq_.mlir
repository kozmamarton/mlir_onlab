module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_advq_(%arg0: memref<?xf32> {polygeist.name = "qb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "qf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c-1 = arith.constant -1 : index
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
    %9 = arith.addi %2, %c-1 : index
    scf.for %arg19 = %c0 to %9 step %c1 {
      %32 = arith.addi %7, %c-1 : index
      scf.for %arg20 = %c0 to %32 step %c1 {
        %33 = arith.addi %8, %c-1 : index
        scf.for %arg21 = %c0 to %33 step %c1 {
          %34 = arith.addi %arg20, %c1 : index
          %35 = arith.muli %34, %8 overflow<nsw> : index
          %36 = arith.addi %arg21, %35 : index
          %37 = arith.addi %arg19, %c1 : index
          %38 = arith.muli %37, %8 overflow<nsw> : index
          %39 = arith.muli %38, %7 overflow<nsw> : index
          %40 = arith.addi %36, %39 : index
          %41 = arith.addi %40, %c1 : index
          %42 = memref.load %arg1[%41] : memref<?xf32>
          %43 = memref.load %arg1[%40] : memref<?xf32>
          %44 = arith.addf %42, %43 : f32
          %45 = arith.mulf %44, %cst_1 : f32
          %46 = arith.addi %36, %c1 : index
          %47 = memref.load %arg5[%46] : memref<?xf32>
          %48 = memref.load %arg5[%36] : memref<?xf32>
          %49 = arith.addf %47, %48 : f32
          %50 = arith.mulf %45, %49 : f32
          %51 = memref.load %arg6[%41] : memref<?xf32>
          %52 = arith.muli %arg19, %8 overflow<nsw> : index
          %53 = arith.muli %52, %7 overflow<nsw> : index
          %54 = arith.addi %36, %53 : index
          %55 = arith.addi %54, %c1 : index
          %56 = memref.load %arg6[%55] : memref<?xf32>
          %57 = arith.addf %51, %56 : f32
          %58 = arith.mulf %50, %57 : f32
          memref.store %58, %arg3[%41] : memref<?xf32>
          %59 = memref.load %arg1[%41] : memref<?xf32>
          %60 = arith.muli %arg20, %8 overflow<nsw> : index
          %61 = arith.addi %arg21, %60 : index
          %62 = arith.addi %61, %39 : index
          %63 = arith.addi %62, %c1 : index
          %64 = memref.load %arg1[%63] : memref<?xf32>
          %65 = arith.addf %59, %64 : f32
          %66 = arith.mulf %65, %cst_1 : f32
          %67 = memref.load %arg5[%46] : memref<?xf32>
          %68 = arith.addi %61, %c1 : index
          %69 = memref.load %arg5[%68] : memref<?xf32>
          %70 = arith.addf %67, %69 : f32
          %71 = arith.mulf %66, %70 : f32
          %72 = memref.load %arg7[%41] : memref<?xf32>
          %73 = memref.load %arg7[%55] : memref<?xf32>
          %74 = arith.addf %72, %73 : f32
          %75 = arith.mulf %71, %74 : f32
          memref.store %75, %arg4[%41] : memref<?xf32>
        }
      }
    }
    %10 = memref.load %0[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.load %3[%c0] : memref<1xi32>
    %13 = memref.load %4[%c0] : memref<1xi32>
    %14 = arith.index_cast %12 : i32 to index
    %15 = arith.index_cast %13 : i32 to index
    %16 = arith.addi %11, %c-1 : index
    scf.for %arg19 = %c0 to %16 step %c1 {
      %32 = arith.addi %14, %c-1 : index
      scf.for %arg20 = %c0 to %32 step %c1 {
        %33 = arith.addi %15, %c-1 : index
        scf.for %arg21 = %c0 to %33 step %c1 {
          %34 = arith.addi %arg20, %c1 : index
          %35 = arith.muli %34, %15 overflow<nsw> : index
          %36 = arith.addi %arg21, %35 : index
          %37 = arith.addi %36, %c1 : index
          %38 = memref.load %arg10[%37] : memref<?xf32>
          %39 = arith.mulf %38, %cst_0 : f32
          %40 = arith.addi %arg19, %c1 : index
          %41 = arith.muli %40, %15 overflow<nsw> : index
          %42 = arith.muli %41, %14 overflow<nsw> : index
          %43 = arith.addi %36, %42 : index
          %44 = arith.addi %43, %c1 : index
          %45 = memref.load %arg8[%44] : memref<?xf32>
          %46 = memref.load %arg8[%43] : memref<?xf32>
          %47 = arith.addf %45, %46 : f32
          %48 = arith.muli %arg19, %15 overflow<nsw> : index
          %49 = arith.muli %48, %14 overflow<nsw> : index
          %50 = arith.addi %36, %49 : index
          %51 = arith.addi %50, %c1 : index
          %52 = memref.load %arg8[%51] : memref<?xf32>
          %53 = arith.addf %47, %52 : f32
          %54 = memref.load %arg8[%50] : memref<?xf32>
          %55 = arith.addf %53, %54 : f32
          %56 = arith.mulf %39, %55 : f32
          %57 = memref.load %arg9[%37] : memref<?xf32>
          %58 = memref.load %arg9[%36] : memref<?xf32>
          %59 = arith.addf %57, %58 : f32
          %60 = arith.mulf %56, %59 : f32
          %61 = memref.load %arg0[%44] : memref<?xf32>
          %62 = memref.load %arg0[%43] : memref<?xf32>
          %63 = arith.subf %61, %62 : f32
          %64 = arith.mulf %60, %63 : f32
          %65 = memref.load %arg11[%37] : memref<?xf32>
          %66 = memref.load %arg11[%36] : memref<?xf32>
          %67 = arith.addf %65, %66 : f32
          %68 = arith.divf %64, %67 : f32
          %69 = memref.load %arg3[%44] : memref<?xf32>
          %70 = arith.subf %69, %68 : f32
          memref.store %70, %arg3[%44] : memref<?xf32>
          %71 = memref.load %arg12[%37] : memref<?xf32>
          %72 = arith.mulf %71, %cst_0 : f32
          %73 = memref.load %arg8[%44] : memref<?xf32>
          %74 = arith.muli %arg20, %15 overflow<nsw> : index
          %75 = arith.addi %arg21, %74 : index
          %76 = arith.addi %75, %42 : index
          %77 = arith.addi %76, %c1 : index
          %78 = memref.load %arg8[%77] : memref<?xf32>
          %79 = arith.addf %73, %78 : f32
          %80 = memref.load %arg8[%51] : memref<?xf32>
          %81 = arith.addf %79, %80 : f32
          %82 = arith.addi %75, %49 : index
          %83 = arith.addi %82, %c1 : index
          %84 = memref.load %arg8[%83] : memref<?xf32>
          %85 = arith.addf %81, %84 : f32
          %86 = arith.mulf %72, %85 : f32
          %87 = memref.load %arg9[%37] : memref<?xf32>
          %88 = arith.addi %75, %c1 : index
          %89 = memref.load %arg9[%88] : memref<?xf32>
          %90 = arith.addf %87, %89 : f32
          %91 = arith.mulf %86, %90 : f32
          %92 = memref.load %arg0[%44] : memref<?xf32>
          %93 = memref.load %arg0[%77] : memref<?xf32>
          %94 = arith.subf %92, %93 : f32
          %95 = arith.mulf %91, %94 : f32
          %96 = memref.load %arg13[%37] : memref<?xf32>
          %97 = memref.load %arg13[%88] : memref<?xf32>
          %98 = arith.addf %96, %97 : f32
          %99 = arith.divf %95, %98 : f32
          %100 = memref.load %arg4[%44] : memref<?xf32>
          %101 = arith.subf %100, %99 : f32
          memref.store %101, %arg4[%44] : memref<?xf32>
          %102 = memref.load %arg13[%37] : memref<?xf32>
          %103 = memref.load %arg13[%36] : memref<?xf32>
          %104 = arith.addf %102, %103 : f32
          %105 = arith.mulf %104, %cst : f32
          %106 = memref.load %arg3[%44] : memref<?xf32>
          %107 = arith.mulf %106, %105 : f32
          memref.store %107, %arg3[%44] : memref<?xf32>
          %108 = memref.load %arg11[%37] : memref<?xf32>
          %109 = memref.load %arg11[%88] : memref<?xf32>
          %110 = arith.addf %108, %109 : f32
          %111 = arith.mulf %110, %cst : f32
          %112 = memref.load %arg4[%44] : memref<?xf32>
          %113 = arith.mulf %112, %111 : f32
          memref.store %113, %arg4[%44] : memref<?xf32>
        }
      }
    }
    %17 = memref.load %0[%c0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.get_global @jmm1 : memref<1xi32>
    %20 = memref.get_global @imm1 : memref<1xi32>
    %21 = memref.get_global @dti2 : memref<1xf32>
    %22 = memref.load %19[%c0] : memref<1xi32>
    %23 = memref.load %20[%c0] : memref<1xi32>
    %24 = memref.load %4[%c0] : memref<1xi32>
    %25 = memref.load %3[%c0] : memref<1xi32>
    %26 = memref.load %21[%c0] : memref<1xf32>
    %27 = arith.index_cast %22 : i32 to index
    %28 = arith.index_cast %23 : i32 to index
    %29 = arith.index_cast %24 : i32 to index
    %30 = arith.index_cast %25 : i32 to index
    %31 = arith.addi %18, %c-1 : index
    scf.for %arg19 = %c0 to %31 step %c1 {
      %32 = arith.addi %arg19, %c1 : index
      %33 = memref.load %arg15[%32] : memref<?xf32>
      %34 = memref.load %arg15[%arg19] : memref<?xf32>
      %35 = arith.addf %33, %34 : f32
      %36 = arith.addi %27, %c-1 : index
      scf.for %arg20 = %c0 to %36 step %c1 {
        %37 = arith.addi %28, %c-1 : index
        scf.for %arg21 = %c0 to %37 step %c1 {
          %38 = arith.addi %arg20, %c1 : index
          %39 = arith.muli %38, %29 overflow<nsw> : index
          %40 = arith.addi %arg21, %39 : index
          %41 = arith.muli %arg19, %29 overflow<nsw> : index
          %42 = arith.muli %41, %30 overflow<nsw> : index
          %43 = arith.addi %40, %42 : index
          %44 = arith.addi %43, %c1 : index
          %45 = memref.load %arg14[%44] : memref<?xf32>
          %46 = memref.load %arg1[%44] : memref<?xf32>
          %47 = arith.mulf %45, %46 : f32
          %48 = arith.addi %arg19, %c2 : index
          %49 = arith.muli %48, %29 overflow<nsw> : index
          %50 = arith.muli %49, %30 overflow<nsw> : index
          %51 = arith.addi %40, %50 : index
          %52 = arith.addi %51, %c1 : index
          %53 = memref.load %arg14[%52] : memref<?xf32>
          %54 = memref.load %arg1[%52] : memref<?xf32>
          %55 = arith.mulf %53, %54 : f32
          %56 = arith.subf %47, %55 : f32
          %57 = arith.addi %40, %c1 : index
          %58 = memref.load %arg16[%57] : memref<?xf32>
          %59 = arith.mulf %56, %58 : f32
          %60 = arith.divf %59, %35 : f32
          %61 = arith.muli %32, %29 overflow<nsw> : index
          %62 = arith.muli %61, %30 overflow<nsw> : index
          %63 = arith.addi %40, %62 : index
          %64 = arith.addi %63, %c2 : index
          %65 = memref.load %arg3[%64] : memref<?xf32>
          %66 = arith.addf %60, %65 : f32
          %67 = arith.addi %63, %c1 : index
          %68 = memref.load %arg3[%67] : memref<?xf32>
          %69 = arith.subf %66, %68 : f32
          %70 = arith.addi %arg20, %c2 : index
          %71 = arith.muli %70, %29 overflow<nsw> : index
          %72 = arith.addi %arg21, %71 : index
          %73 = arith.addi %72, %62 : index
          %74 = arith.addi %73, %c1 : index
          %75 = memref.load %arg4[%74] : memref<?xf32>
          %76 = arith.addf %69, %75 : f32
          %77 = memref.load %arg4[%67] : memref<?xf32>
          %78 = arith.subf %76, %77 : f32
          memref.store %78, %arg2[%67] : memref<?xf32>
          %79 = memref.load %arg9[%57] : memref<?xf32>
          %80 = memref.load %arg17[%57] : memref<?xf32>
          %81 = arith.addf %79, %80 : f32
          %82 = memref.load %arg16[%57] : memref<?xf32>
          %83 = arith.mulf %81, %82 : f32
          %84 = memref.load %arg0[%67] : memref<?xf32>
          %85 = arith.mulf %83, %84 : f32
          %86 = memref.load %arg2[%67] : memref<?xf32>
          %87 = arith.mulf %26, %86 : f32
          %88 = arith.subf %85, %87 : f32
          %89 = memref.load %arg18[%57] : memref<?xf32>
          %90 = arith.addf %79, %89 : f32
          %91 = arith.mulf %90, %82 : f32
          %92 = arith.divf %88, %91 : f32
          memref.store %92, %arg2[%67] : memref<?xf32>
        }
      }
    }
    return
  }
}


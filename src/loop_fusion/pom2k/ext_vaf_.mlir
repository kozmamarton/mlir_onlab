module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_vaf_(%arg0: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dry2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 4.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @alpha : memref<1xf32>
    %7 = memref.load %3[%c0] : memref<1xi32>
    %8 = memref.load %4[%c0] : memref<1xi32>
    %9 = memref.load %5[%c0] : memref<1xf32>
    %10 = memref.load %6[%c0] : memref<1xf32>
    %11 = arith.index_cast %7 : i32 to index
    %12 = arith.index_cast %8 : i32 to index
    %13 = arith.mulf %9, %cst_2 : f32
    %14 = arith.mulf %10, %cst_0 : f32
    %15 = arith.subf %cst_1, %14 : f32
    scf.for %arg17 = %c1 to %2 step %c1 {
      scf.for %arg18 = %c1 to %11 step %c1 {
        %25 = arith.muli %arg17, %12 overflow<nsw> : index
        %26 = arith.addi %arg18, %25 : index
        %27 = memref.load %arg1[%26] : memref<?xf32>
        %28 = memref.load %arg2[%26] : memref<?xf32>
        %29 = arith.addf %27, %28 : f32
        %30 = memref.load %arg3[%26] : memref<?xf32>
        %31 = arith.mulf %30, %cst_2 : f32
        %32 = memref.load %arg4[%26] : memref<?xf32>
        %33 = memref.load %arg5[%26] : memref<?xf32>
        %34 = arith.mulf %32, %33 : f32
        %35 = arith.addi %26, %c1 : index
        %36 = memref.load %arg6[%35] : memref<?xf32>
        %37 = memref.load %arg6[%26] : memref<?xf32>
        %38 = arith.addf %36, %37 : f32
        %39 = arith.mulf %34, %38 : f32
        %40 = arith.addi %arg17, %c-1 : index
        %41 = arith.muli %40, %12 overflow<nsw> : index
        %42 = arith.addi %arg18, %41 : index
        %43 = memref.load %arg4[%42] : memref<?xf32>
        %44 = memref.load %arg5[%42] : memref<?xf32>
        %45 = arith.mulf %43, %44 : f32
        %46 = arith.addi %42, %c1 : index
        %47 = memref.load %arg6[%46] : memref<?xf32>
        %48 = memref.load %arg6[%42] : memref<?xf32>
        %49 = arith.addf %47, %48 : f32
        %50 = arith.mulf %45, %49 : f32
        %51 = arith.addf %39, %50 : f32
        %52 = arith.mulf %31, %51 : f32
        %53 = arith.addf %29, %52 : f32
        %54 = memref.load %arg7[%26] : memref<?xf32>
        %55 = memref.load %arg7[%42] : memref<?xf32>
        %56 = arith.addf %54, %55 : f32
        %57 = arith.mulf %13, %56 : f32
        %58 = arith.addf %33, %44 : f32
        %59 = arith.mulf %57, %58 : f32
        %60 = memref.load %arg8[%26] : memref<?xf32>
        %61 = memref.load %arg8[%42] : memref<?xf32>
        %62 = arith.subf %60, %61 : f32
        %63 = arith.mulf %15, %62 : f32
        %64 = memref.load %arg9[%26] : memref<?xf32>
        %65 = memref.load %arg9[%42] : memref<?xf32>
        %66 = arith.subf %64, %65 : f32
        %67 = memref.load %arg10[%26] : memref<?xf32>
        %68 = arith.addf %66, %67 : f32
        %69 = memref.load %arg10[%42] : memref<?xf32>
        %70 = arith.subf %68, %69 : f32
        %71 = arith.mulf %10, %70 : f32
        %72 = arith.addf %63, %71 : f32
        %73 = memref.load %arg11[%26] : memref<?xf32>
        %74 = arith.addf %72, %73 : f32
        %75 = memref.load %arg11[%42] : memref<?xf32>
        %76 = arith.subf %74, %75 : f32
        %77 = arith.mulf %59, %76 : f32
        %78 = arith.addf %53, %77 : f32
        %79 = memref.load %arg12[%26] : memref<?xf32>
        %80 = arith.addf %78, %79 : f32
        %81 = memref.load %arg13[%26] : memref<?xf32>
        %82 = memref.load %arg14[%26] : memref<?xf32>
        %83 = arith.subf %81, %82 : f32
        %84 = arith.mulf %30, %83 : f32
        %85 = arith.addf %80, %84 : f32
        memref.store %85, %arg0[%26] : memref<?xf32>
      }
    }
    %16 = memref.load %0[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @dte : memref<1xf32>
    %19 = memref.load %3[%c0] : memref<1xi32>
    %20 = memref.load %4[%c0] : memref<1xi32>
    %21 = memref.load %18[%c0] : memref<1xf32>
    %22 = arith.index_cast %19 : i32 to index
    %23 = arith.index_cast %20 : i32 to index
    %24 = arith.mulf %21, %cst : f32
    scf.for %arg17 = %c1 to %17 step %c1 {
      scf.for %arg18 = %c1 to %22 step %c1 {
        %25 = arith.muli %arg17, %23 overflow<nsw> : index
        %26 = arith.addi %arg18, %25 : index
        %27 = memref.load %arg15[%26] : memref<?xf32>
        %28 = memref.load %arg9[%26] : memref<?xf32>
        %29 = arith.addf %27, %28 : f32
        %30 = arith.addi %arg17, %c-1 : index
        %31 = arith.muli %30, %23 overflow<nsw> : index
        %32 = arith.addi %arg18, %31 : index
        %33 = memref.load %arg15[%32] : memref<?xf32>
        %34 = arith.addf %29, %33 : f32
        %35 = memref.load %arg9[%32] : memref<?xf32>
        %36 = arith.addf %34, %35 : f32
        %37 = memref.load %arg16[%26] : memref<?xf32>
        %38 = arith.mulf %36, %37 : f32
        %39 = memref.load %arg3[%26] : memref<?xf32>
        %40 = arith.mulf %38, %39 : f32
        %41 = memref.load %arg0[%26] : memref<?xf32>
        %42 = arith.mulf %24, %41 : f32
        %43 = arith.subf %40, %42 : f32
        %44 = memref.load %arg10[%26] : memref<?xf32>
        %45 = arith.addf %27, %44 : f32
        %46 = arith.addf %45, %33 : f32
        %47 = memref.load %arg10[%32] : memref<?xf32>
        %48 = arith.addf %46, %47 : f32
        %49 = arith.mulf %48, %39 : f32
        %50 = arith.divf %43, %49 : f32
        memref.store %50, %arg0[%26] : memref<?xf32>
      }
    }
    return
  }
}


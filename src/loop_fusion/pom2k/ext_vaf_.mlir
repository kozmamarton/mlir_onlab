module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_vaf_(%arg0: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dry2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wvsurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wvbot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c-1 = arith.constant -1 : index
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
    %16 = arith.addi %2, %c-1 : index
    scf.for %arg17 = %c0 to %16 step %c1 {
      %27 = arith.addi %11, %c-1 : index
      scf.for %arg18 = %c0 to %27 step %c1 {
        %28 = arith.addi %arg17, %c1 : index
        %29 = arith.muli %28, %12 overflow<nsw> : index
        %30 = arith.addi %arg18, %29 : index
        %31 = arith.addi %30, %c1 : index
        %32 = memref.load %arg1[%31] : memref<?xf32>
        %33 = memref.load %arg2[%31] : memref<?xf32>
        %34 = arith.addf %32, %33 : f32
        %35 = memref.load %arg3[%31] : memref<?xf32>
        %36 = arith.mulf %35, %cst_2 : f32
        %37 = memref.load %arg4[%31] : memref<?xf32>
        %38 = memref.load %arg5[%31] : memref<?xf32>
        %39 = arith.mulf %37, %38 : f32
        %40 = arith.addi %30, %c2 : index
        %41 = memref.load %arg6[%40] : memref<?xf32>
        %42 = memref.load %arg6[%31] : memref<?xf32>
        %43 = arith.addf %41, %42 : f32
        %44 = arith.mulf %39, %43 : f32
        %45 = arith.muli %arg17, %12 overflow<nsw> : index
        %46 = arith.addi %arg18, %45 : index
        %47 = arith.addi %46, %c1 : index
        %48 = memref.load %arg4[%47] : memref<?xf32>
        %49 = memref.load %arg5[%47] : memref<?xf32>
        %50 = arith.mulf %48, %49 : f32
        %51 = arith.addi %46, %c2 : index
        %52 = memref.load %arg6[%51] : memref<?xf32>
        %53 = memref.load %arg6[%47] : memref<?xf32>
        %54 = arith.addf %52, %53 : f32
        %55 = arith.mulf %50, %54 : f32
        %56 = arith.addf %44, %55 : f32
        %57 = arith.mulf %36, %56 : f32
        %58 = arith.addf %34, %57 : f32
        %59 = memref.load %arg7[%31] : memref<?xf32>
        %60 = memref.load %arg7[%47] : memref<?xf32>
        %61 = arith.addf %59, %60 : f32
        %62 = arith.mulf %13, %61 : f32
        %63 = arith.addf %38, %49 : f32
        %64 = arith.mulf %62, %63 : f32
        %65 = memref.load %arg8[%31] : memref<?xf32>
        %66 = memref.load %arg8[%47] : memref<?xf32>
        %67 = arith.subf %65, %66 : f32
        %68 = arith.mulf %15, %67 : f32
        %69 = memref.load %arg9[%31] : memref<?xf32>
        %70 = memref.load %arg9[%47] : memref<?xf32>
        %71 = arith.subf %69, %70 : f32
        %72 = memref.load %arg10[%31] : memref<?xf32>
        %73 = arith.addf %71, %72 : f32
        %74 = memref.load %arg10[%47] : memref<?xf32>
        %75 = arith.subf %73, %74 : f32
        %76 = arith.mulf %10, %75 : f32
        %77 = arith.addf %68, %76 : f32
        %78 = memref.load %arg11[%31] : memref<?xf32>
        %79 = arith.addf %77, %78 : f32
        %80 = memref.load %arg11[%47] : memref<?xf32>
        %81 = arith.subf %79, %80 : f32
        %82 = arith.mulf %64, %81 : f32
        %83 = arith.addf %58, %82 : f32
        %84 = memref.load %arg12[%31] : memref<?xf32>
        %85 = arith.addf %83, %84 : f32
        %86 = memref.load %arg13[%31] : memref<?xf32>
        %87 = memref.load %arg14[%31] : memref<?xf32>
        %88 = arith.subf %86, %87 : f32
        %89 = arith.mulf %35, %88 : f32
        %90 = arith.addf %85, %89 : f32
        memref.store %90, %arg0[%31] : memref<?xf32>
      }
    }
    %17 = memref.load %0[%c0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.get_global @dte : memref<1xf32>
    %20 = memref.load %3[%c0] : memref<1xi32>
    %21 = memref.load %4[%c0] : memref<1xi32>
    %22 = memref.load %19[%c0] : memref<1xf32>
    %23 = arith.index_cast %20 : i32 to index
    %24 = arith.index_cast %21 : i32 to index
    %25 = arith.mulf %22, %cst : f32
    %26 = arith.addi %18, %c-1 : index
    scf.for %arg17 = %c0 to %26 step %c1 {
      %27 = arith.addi %23, %c-1 : index
      scf.for %arg18 = %c0 to %27 step %c1 {
        %28 = arith.addi %arg17, %c1 : index
        %29 = arith.muli %28, %24 overflow<nsw> : index
        %30 = arith.addi %arg18, %29 : index
        %31 = arith.addi %30, %c1 : index
        %32 = memref.load %arg15[%31] : memref<?xf32>
        %33 = memref.load %arg9[%31] : memref<?xf32>
        %34 = arith.addf %32, %33 : f32
        %35 = arith.muli %arg17, %24 overflow<nsw> : index
        %36 = arith.addi %arg18, %35 : index
        %37 = arith.addi %36, %c1 : index
        %38 = memref.load %arg15[%37] : memref<?xf32>
        %39 = arith.addf %34, %38 : f32
        %40 = memref.load %arg9[%37] : memref<?xf32>
        %41 = arith.addf %39, %40 : f32
        %42 = memref.load %arg16[%31] : memref<?xf32>
        %43 = arith.mulf %41, %42 : f32
        %44 = memref.load %arg3[%31] : memref<?xf32>
        %45 = arith.mulf %43, %44 : f32
        %46 = memref.load %arg0[%31] : memref<?xf32>
        %47 = arith.mulf %25, %46 : f32
        %48 = arith.subf %45, %47 : f32
        %49 = memref.load %arg10[%31] : memref<?xf32>
        %50 = arith.addf %32, %49 : f32
        %51 = arith.addf %50, %38 : f32
        %52 = memref.load %arg10[%37] : memref<?xf32>
        %53 = arith.addf %51, %52 : f32
        %54 = arith.mulf %53, %44 : f32
        %55 = arith.divf %48, %54 : f32
        memref.store %55, %arg0[%31] : memref<?xf32>
      }
    }
    return
  }
}


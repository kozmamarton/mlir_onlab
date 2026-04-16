module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_uaf_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "drx2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c-1 = arith.constant -1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 4.000000e+00 : f32
    %cst_0 = arith.constant 2.000000e+00 : f32
    %cst_1 = arith.constant 1.000000e+00 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @grav : memref<1xf32>
    %5 = memref.get_global @alpha : memref<1xf32>
    %6 = memref.load %3[%c0] : memref<1xi32>
    %7 = memref.load %4[%c0] : memref<1xf32>
    %8 = memref.load %5[%c0] : memref<1xf32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.mulf %7, %cst_2 : f32
    %11 = arith.mulf %8, %cst_0 : f32
    %12 = arith.subf %cst_1, %11 : f32
    %13 = arith.addi %2, %c-1 : index
    scf.for %arg17 = %c0 to %13 step %c1 {
      %22 = arith.addi %9, %c-1 : index
      scf.for %arg18 = %c0 to %22 step %c1 {
        %23 = arith.addi %arg17, %c1 : index
        %24 = arith.muli %23, %9 overflow<nsw> : index
        %25 = arith.addi %arg18, %24 : index
        %26 = arith.addi %25, %c1 : index
        %27 = memref.load %arg1[%26] : memref<?xf32>
        %28 = memref.load %arg2[%26] : memref<?xf32>
        %29 = arith.addf %27, %28 : f32
        %30 = memref.load %arg3[%26] : memref<?xf32>
        %31 = arith.mulf %30, %cst_2 : f32
        %32 = memref.load %arg4[%26] : memref<?xf32>
        %33 = memref.load %arg5[%26] : memref<?xf32>
        %34 = arith.mulf %32, %33 : f32
        %35 = arith.addi %arg17, %c2 : index
        %36 = arith.muli %35, %9 overflow<nsw> : index
        %37 = arith.addi %arg18, %36 : index
        %38 = arith.addi %37, %c1 : index
        %39 = memref.load %arg6[%38] : memref<?xf32>
        %40 = memref.load %arg6[%26] : memref<?xf32>
        %41 = arith.addf %39, %40 : f32
        %42 = arith.mulf %34, %41 : f32
        %43 = memref.load %arg4[%25] : memref<?xf32>
        %44 = memref.load %arg5[%25] : memref<?xf32>
        %45 = arith.mulf %43, %44 : f32
        %46 = memref.load %arg6[%37] : memref<?xf32>
        %47 = memref.load %arg6[%25] : memref<?xf32>
        %48 = arith.addf %46, %47 : f32
        %49 = arith.mulf %45, %48 : f32
        %50 = arith.addf %42, %49 : f32
        %51 = arith.mulf %31, %50 : f32
        %52 = arith.subf %29, %51 : f32
        %53 = memref.load %arg7[%26] : memref<?xf32>
        %54 = memref.load %arg7[%25] : memref<?xf32>
        %55 = arith.addf %53, %54 : f32
        %56 = arith.mulf %10, %55 : f32
        %57 = arith.addf %33, %44 : f32
        %58 = arith.mulf %56, %57 : f32
        %59 = memref.load %arg8[%26] : memref<?xf32>
        %60 = memref.load %arg8[%25] : memref<?xf32>
        %61 = arith.subf %59, %60 : f32
        %62 = arith.mulf %12, %61 : f32
        %63 = memref.load %arg9[%26] : memref<?xf32>
        %64 = memref.load %arg9[%25] : memref<?xf32>
        %65 = arith.subf %63, %64 : f32
        %66 = memref.load %arg10[%26] : memref<?xf32>
        %67 = arith.addf %65, %66 : f32
        %68 = memref.load %arg10[%25] : memref<?xf32>
        %69 = arith.subf %67, %68 : f32
        %70 = arith.mulf %8, %69 : f32
        %71 = arith.addf %62, %70 : f32
        %72 = memref.load %arg11[%26] : memref<?xf32>
        %73 = arith.addf %71, %72 : f32
        %74 = memref.load %arg11[%25] : memref<?xf32>
        %75 = arith.subf %73, %74 : f32
        %76 = arith.mulf %58, %75 : f32
        %77 = arith.addf %52, %76 : f32
        %78 = memref.load %arg12[%26] : memref<?xf32>
        %79 = arith.addf %77, %78 : f32
        %80 = memref.load %arg13[%26] : memref<?xf32>
        %81 = memref.load %arg14[%26] : memref<?xf32>
        %82 = arith.subf %80, %81 : f32
        %83 = arith.mulf %30, %82 : f32
        %84 = arith.addf %79, %83 : f32
        memref.store %84, %arg0[%26] : memref<?xf32>
      }
    }
    %14 = memref.load %0[%c0] : memref<1xi32>
    %15 = arith.index_cast %14 : i32 to index
    %16 = memref.get_global @dte : memref<1xf32>
    %17 = memref.load %3[%c0] : memref<1xi32>
    %18 = memref.load %16[%c0] : memref<1xf32>
    %19 = arith.index_cast %17 : i32 to index
    %20 = arith.mulf %18, %cst : f32
    %21 = arith.addi %15, %c-1 : index
    scf.for %arg17 = %c0 to %21 step %c1 {
      %22 = arith.addi %19, %c-1 : index
      scf.for %arg18 = %c0 to %22 step %c1 {
        %23 = arith.addi %arg17, %c1 : index
        %24 = arith.muli %23, %19 overflow<nsw> : index
        %25 = arith.addi %arg18, %24 : index
        %26 = arith.addi %25, %c1 : index
        %27 = memref.load %arg15[%26] : memref<?xf32>
        %28 = memref.load %arg9[%26] : memref<?xf32>
        %29 = arith.addf %27, %28 : f32
        %30 = memref.load %arg15[%25] : memref<?xf32>
        %31 = arith.addf %29, %30 : f32
        %32 = memref.load %arg9[%25] : memref<?xf32>
        %33 = arith.addf %31, %32 : f32
        %34 = memref.load %arg3[%26] : memref<?xf32>
        %35 = arith.mulf %33, %34 : f32
        %36 = memref.load %arg16[%26] : memref<?xf32>
        %37 = arith.mulf %35, %36 : f32
        %38 = memref.load %arg0[%26] : memref<?xf32>
        %39 = arith.mulf %20, %38 : f32
        %40 = arith.subf %37, %39 : f32
        %41 = memref.load %arg10[%26] : memref<?xf32>
        %42 = arith.addf %27, %41 : f32
        %43 = arith.addf %42, %30 : f32
        %44 = memref.load %arg10[%25] : memref<?xf32>
        %45 = arith.addf %43, %44 : f32
        %46 = arith.mulf %45, %34 : f32
        %47 = arith.divf %40, %46 : f32
        memref.store %47, %arg0[%26] : memref<?xf32>
      }
    }
    return
  }
}


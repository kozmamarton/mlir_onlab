module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte : memref<1xf32>
  memref.global @alpha : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_uaf_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "cor", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "e_atmos", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "drx2d", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "wusurf", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "wubot", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
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
    scf.for %arg17 = %c1 to %2 step %c1 {
      scf.for %arg18 = %c1 to %9 step %c1 {
        %20 = arith.muli %arg17, %9 overflow<nsw> : index
        %21 = arith.addi %arg18, %20 : index
        %22 = memref.load %arg1[%21] : memref<?xf32>
        %23 = memref.load %arg2[%21] : memref<?xf32>
        %24 = arith.addf %22, %23 : f32
        %25 = memref.load %arg3[%21] : memref<?xf32>
        %26 = arith.mulf %25, %cst_2 : f32
        %27 = memref.load %arg4[%21] : memref<?xf32>
        %28 = memref.load %arg5[%21] : memref<?xf32>
        %29 = arith.mulf %27, %28 : f32
        %30 = arith.addi %arg17, %c1 : index
        %31 = arith.muli %30, %9 overflow<nsw> : index
        %32 = arith.addi %arg18, %31 : index
        %33 = memref.load %arg6[%32] : memref<?xf32>
        %34 = memref.load %arg6[%21] : memref<?xf32>
        %35 = arith.addf %33, %34 : f32
        %36 = arith.mulf %29, %35 : f32
        %37 = arith.addi %21, %c-1 : index
        %38 = memref.load %arg4[%37] : memref<?xf32>
        %39 = memref.load %arg5[%37] : memref<?xf32>
        %40 = arith.mulf %38, %39 : f32
        %41 = arith.addi %32, %c-1 : index
        %42 = memref.load %arg6[%41] : memref<?xf32>
        %43 = memref.load %arg6[%37] : memref<?xf32>
        %44 = arith.addf %42, %43 : f32
        %45 = arith.mulf %40, %44 : f32
        %46 = arith.addf %36, %45 : f32
        %47 = arith.mulf %26, %46 : f32
        %48 = arith.subf %24, %47 : f32
        %49 = memref.load %arg7[%21] : memref<?xf32>
        %50 = memref.load %arg7[%37] : memref<?xf32>
        %51 = arith.addf %49, %50 : f32
        %52 = arith.mulf %10, %51 : f32
        %53 = arith.addf %28, %39 : f32
        %54 = arith.mulf %52, %53 : f32
        %55 = memref.load %arg8[%21] : memref<?xf32>
        %56 = memref.load %arg8[%37] : memref<?xf32>
        %57 = arith.subf %55, %56 : f32
        %58 = arith.mulf %12, %57 : f32
        %59 = memref.load %arg9[%21] : memref<?xf32>
        %60 = memref.load %arg9[%37] : memref<?xf32>
        %61 = arith.subf %59, %60 : f32
        %62 = memref.load %arg10[%21] : memref<?xf32>
        %63 = arith.addf %61, %62 : f32
        %64 = memref.load %arg10[%37] : memref<?xf32>
        %65 = arith.subf %63, %64 : f32
        %66 = arith.mulf %8, %65 : f32
        %67 = arith.addf %58, %66 : f32
        %68 = memref.load %arg11[%21] : memref<?xf32>
        %69 = arith.addf %67, %68 : f32
        %70 = memref.load %arg11[%37] : memref<?xf32>
        %71 = arith.subf %69, %70 : f32
        %72 = arith.mulf %54, %71 : f32
        %73 = arith.addf %48, %72 : f32
        %74 = memref.load %arg12[%21] : memref<?xf32>
        %75 = arith.addf %73, %74 : f32
        %76 = memref.load %arg13[%21] : memref<?xf32>
        %77 = memref.load %arg14[%21] : memref<?xf32>
        %78 = arith.subf %76, %77 : f32
        %79 = arith.mulf %25, %78 : f32
        %80 = arith.addf %75, %79 : f32
        memref.store %80, %arg0[%21] : memref<?xf32>
      }
    }
    %13 = memref.load %0[%c0] : memref<1xi32>
    %14 = arith.index_cast %13 : i32 to index
    %15 = memref.get_global @dte : memref<1xf32>
    %16 = memref.load %3[%c0] : memref<1xi32>
    %17 = memref.load %15[%c0] : memref<1xf32>
    %18 = arith.index_cast %16 : i32 to index
    %19 = arith.mulf %17, %cst : f32
    scf.for %arg17 = %c1 to %14 step %c1 {
      scf.for %arg18 = %c1 to %18 step %c1 {
        %20 = arith.muli %arg17, %18 overflow<nsw> : index
        %21 = arith.addi %arg18, %20 : index
        %22 = memref.load %arg15[%21] : memref<?xf32>
        %23 = memref.load %arg9[%21] : memref<?xf32>
        %24 = arith.addf %22, %23 : f32
        %25 = arith.addi %21, %c-1 : index
        %26 = memref.load %arg15[%25] : memref<?xf32>
        %27 = arith.addf %24, %26 : f32
        %28 = memref.load %arg9[%25] : memref<?xf32>
        %29 = arith.addf %27, %28 : f32
        %30 = memref.load %arg3[%21] : memref<?xf32>
        %31 = arith.mulf %29, %30 : f32
        %32 = memref.load %arg16[%21] : memref<?xf32>
        %33 = arith.mulf %31, %32 : f32
        %34 = memref.load %arg0[%21] : memref<?xf32>
        %35 = arith.mulf %19, %34 : f32
        %36 = arith.subf %33, %35 : f32
        %37 = memref.load %arg10[%21] : memref<?xf32>
        %38 = arith.addf %22, %37 : f32
        %39 = arith.addf %38, %26 : f32
        %40 = memref.load %arg10[%25] : memref<?xf32>
        %41 = arith.addf %39, %40 : f32
        %42 = arith.mulf %41, %30 : f32
        %43 = arith.divf %36, %42 : f32
        memref.store %43, %arg0[%21] : memref<?xf32>
      }
    }
    return
  }
}


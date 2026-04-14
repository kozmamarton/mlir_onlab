module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @jm : memref<1xi32>
  memref.global @jmm2 : memref<1xi32>
  memref.global @imm2 : memref<1xi32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_bcond_2_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "uabe", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "uabw", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "vabn", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vabs", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "ele", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elw", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "eln", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "els", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "ramp", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "rfe", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "rfw", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "rfn", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "rfs", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c-1 = arith.constant -1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @imm2 : memref<1xi32>
    %7 = memref.load %3[%c0] : memref<1xi32>
    %8 = memref.load %4[%c0] : memref<1xi32>
    %9 = memref.load %arg15[%c0] : memref<?xf32>
    %10 = memref.load %5[%c0] : memref<1xf32>
    %11 = memref.load %6[%c0] : memref<1xi32>
    %12 = memref.load %arg14[%c0] : memref<?xf32>
    %13 = memref.load %arg16[%c0] : memref<?xf32>
    %14 = arith.index_cast %7 : i32 to index
    %15 = arith.index_cast %8 : i32 to index
    %16 = arith.index_cast %11 : i32 to index
    %17 = arith.addi %2, %c-1 : index
    scf.for %arg19 = %c0 to %17 step %c1 {
      %39 = arith.addi %arg19, %c1 : index
      %40 = memref.load %arg2[%39] : memref<?xf32>
      %41 = arith.muli %39, %15 overflow<nsw> : index
      %42 = arith.addi %41, %16 : index
      %43 = memref.load %arg6[%42] : memref<?xf32>
      %44 = arith.divf %10, %43 : f32
      %45 = math.sqrt %44 : f32
      %46 = arith.mulf %9, %45 : f32
      %47 = memref.load %arg7[%42] : memref<?xf32>
      %48 = memref.load %arg8[%39] : memref<?xf32>
      %49 = arith.subf %47, %48 : f32
      %50 = arith.mulf %46, %49 : f32
      %51 = arith.addf %40, %50 : f32
      %52 = arith.addi %41, %14 : index
      memref.store %51, %arg0[%52] : memref<?xf32>
      %53 = memref.load %arg0[%52] : memref<?xf32>
      %54 = arith.mulf %12, %53 : f32
      memref.store %54, %arg0[%52] : memref<?xf32>
      memref.store %cst, %arg1[%52] : memref<?xf32>
      %55 = memref.load %arg3[%39] : memref<?xf32>
      %56 = arith.addi %41, %c1 : index
      %57 = memref.load %arg6[%56] : memref<?xf32>
      %58 = arith.divf %10, %57 : f32
      %59 = math.sqrt %58 : f32
      %60 = arith.mulf %13, %59 : f32
      %61 = memref.load %arg7[%56] : memref<?xf32>
      %62 = memref.load %arg9[%39] : memref<?xf32>
      %63 = arith.subf %61, %62 : f32
      %64 = arith.mulf %60, %63 : f32
      %65 = arith.subf %55, %64 : f32
      memref.store %65, %arg0[%56] : memref<?xf32>
      %66 = memref.load %arg0[%56] : memref<?xf32>
      %67 = arith.mulf %12, %66 : f32
      memref.store %67, %arg0[%56] : memref<?xf32>
      %68 = memref.load %arg0[%56] : memref<?xf32>
      memref.store %68, %arg0[%41] : memref<?xf32>
      memref.store %cst, %arg1[%41] : memref<?xf32>
    }
    %18 = memref.load %3[%c0] : memref<1xi32>
    %19 = arith.index_cast %18 : i32 to index
    %20 = memref.get_global @jmm2 : memref<1xi32>
    %21 = memref.load %0[%c0] : memref<1xi32>
    %22 = memref.load %4[%c0] : memref<1xi32>
    %23 = memref.load %arg17[%c0] : memref<?xf32>
    %24 = memref.load %5[%c0] : memref<1xf32>
    %25 = memref.load %20[%c0] : memref<1xi32>
    %26 = memref.load %arg14[%c0] : memref<?xf32>
    %27 = memref.load %arg18[%c0] : memref<?xf32>
    %28 = arith.index_cast %21 : i32 to index
    %29 = arith.index_cast %22 : i32 to index
    %30 = arith.muli %28, %29 : index
    %31 = arith.index_cast %25 : i32 to index
    %32 = arith.muli %31, %29 : index
    %33 = arith.addi %19, %c-1 : index
    scf.for %arg19 = %c0 to %33 step %c1 {
      %39 = arith.addi %arg19, %c1 : index
      %40 = memref.load %arg4[%39] : memref<?xf32>
      %41 = arith.addi %arg19, %32 : index
      %42 = arith.addi %41, %c1 : index
      %43 = memref.load %arg6[%42] : memref<?xf32>
      %44 = arith.divf %24, %43 : f32
      %45 = math.sqrt %44 : f32
      %46 = arith.mulf %23, %45 : f32
      %47 = memref.load %arg7[%42] : memref<?xf32>
      %48 = memref.load %arg10[%39] : memref<?xf32>
      %49 = arith.subf %47, %48 : f32
      %50 = arith.mulf %46, %49 : f32
      %51 = arith.addf %40, %50 : f32
      %52 = arith.mulf %26, %51 : f32
      %53 = arith.addi %arg19, %30 : index
      %54 = arith.addi %53, %c1 : index
      memref.store %52, %arg1[%54] : memref<?xf32>
      memref.store %cst, %arg0[%54] : memref<?xf32>
      %55 = memref.load %arg5[%39] : memref<?xf32>
      %56 = arith.addi %arg19, %29 : index
      %57 = arith.addi %56, %c1 : index
      %58 = memref.load %arg6[%57] : memref<?xf32>
      %59 = arith.divf %24, %58 : f32
      %60 = math.sqrt %59 : f32
      %61 = arith.mulf %27, %60 : f32
      %62 = memref.load %arg7[%57] : memref<?xf32>
      %63 = memref.load %arg11[%39] : memref<?xf32>
      %64 = arith.subf %62, %63 : f32
      %65 = arith.mulf %61, %64 : f32
      %66 = arith.subf %55, %65 : f32
      %67 = arith.mulf %26, %66 : f32
      memref.store %67, %arg1[%57] : memref<?xf32>
      memref.store %67, %arg1[%39] : memref<?xf32>
      memref.store %cst, %arg0[%39] : memref<?xf32>
    }
    %34 = memref.get_global @jm : memref<1xi32>
    %35 = memref.load %34[%c0] : memref<1xi32>
    %36 = arith.index_cast %35 : i32 to index
    %37 = memref.load %4[%c0] : memref<1xi32>
    %38 = arith.index_cast %37 : i32 to index
    scf.for %arg19 = %c0 to %36 step %c1 {
      scf.for %arg20 = %c0 to %38 step %c1 {
        %39 = arith.muli %arg19, %38 overflow<nsw> : index
        %40 = arith.addi %arg20, %39 : index
        %41 = memref.load %arg0[%40] : memref<?xf32>
        %42 = memref.load %arg12[%40] : memref<?xf32>
        %43 = arith.mulf %41, %42 : f32
        memref.store %43, %arg0[%40] : memref<?xf32>
        %44 = memref.load %arg1[%40] : memref<?xf32>
        %45 = memref.load %arg13[%40] : memref<?xf32>
        %46 = arith.mulf %44, %45 : f32
        memref.store %46, %arg1[%40] : memref<?xf32>
      }
    }
    return
  }
}


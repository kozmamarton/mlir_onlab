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
    scf.for %arg19 = %c1 to %2 step %c1 {
      %27 = memref.load %arg2[%arg19] : memref<?xf32>
      %28 = arith.muli %arg19, %15 overflow<nsw> : index
      %29 = arith.addi %28, %16 : index
      %30 = memref.load %arg6[%29] : memref<?xf32>
      %31 = arith.divf %10, %30 : f32
      %32 = math.sqrt %31 : f32
      %33 = arith.mulf %9, %32 : f32
      %34 = memref.load %arg7[%29] : memref<?xf32>
      %35 = memref.load %arg8[%arg19] : memref<?xf32>
      %36 = arith.subf %34, %35 : f32
      %37 = arith.mulf %33, %36 : f32
      %38 = arith.addf %27, %37 : f32
      %39 = arith.addi %28, %14 : index
      memref.store %38, %arg0[%39] : memref<?xf32>
      %40 = memref.load %arg0[%39] : memref<?xf32>
      %41 = arith.mulf %12, %40 : f32
      memref.store %41, %arg0[%39] : memref<?xf32>
      memref.store %cst, %arg1[%39] : memref<?xf32>
      %42 = memref.load %arg3[%arg19] : memref<?xf32>
      %43 = arith.addi %28, %c1 : index
      %44 = memref.load %arg6[%43] : memref<?xf32>
      %45 = arith.divf %10, %44 : f32
      %46 = math.sqrt %45 : f32
      %47 = arith.mulf %13, %46 : f32
      %48 = memref.load %arg7[%43] : memref<?xf32>
      %49 = memref.load %arg9[%arg19] : memref<?xf32>
      %50 = arith.subf %48, %49 : f32
      %51 = arith.mulf %47, %50 : f32
      %52 = arith.subf %42, %51 : f32
      memref.store %52, %arg0[%43] : memref<?xf32>
      %53 = memref.load %arg0[%43] : memref<?xf32>
      %54 = arith.mulf %12, %53 : f32
      memref.store %54, %arg0[%43] : memref<?xf32>
      %55 = memref.load %arg0[%43] : memref<?xf32>
      memref.store %55, %arg0[%28] : memref<?xf32>
      memref.store %cst, %arg1[%28] : memref<?xf32>
    }
    %17 = memref.get_global @jmm2 : memref<1xi32>
    %18 = memref.load %arg17[%c0] : memref<?xf32>
    %19 = memref.load %17[%c0] : memref<1xi32>
    %20 = memref.load %arg18[%c0] : memref<?xf32>
    %21 = arith.muli %2, %15 : index
    %22 = arith.index_cast %19 : i32 to index
    %23 = arith.muli %22, %15 : index
    %24 = memref.get_global @jm : memref<1xi32>
    %25 = memref.load %24[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    scf.for %arg19 = %c1 to %14 step %c1 {
      %27 = memref.load %arg4[%arg19] : memref<?xf32>
      %28 = arith.addi %arg19, %23 : index
      %29 = memref.load %arg6[%28] : memref<?xf32>
      %30 = arith.divf %10, %29 : f32
      %31 = math.sqrt %30 : f32
      %32 = arith.mulf %18, %31 : f32
      %33 = memref.load %arg7[%28] : memref<?xf32>
      %34 = memref.load %arg10[%arg19] : memref<?xf32>
      %35 = arith.subf %33, %34 : f32
      %36 = arith.mulf %32, %35 : f32
      %37 = arith.addf %27, %36 : f32
      %38 = arith.mulf %12, %37 : f32
      %39 = arith.addi %arg19, %21 : index
      memref.store %38, %arg1[%39] : memref<?xf32>
      memref.store %cst, %arg0[%39] : memref<?xf32>
      %40 = memref.load %arg5[%arg19] : memref<?xf32>
      %41 = arith.addi %arg19, %15 : index
      %42 = memref.load %arg6[%41] : memref<?xf32>
      %43 = arith.divf %10, %42 : f32
      %44 = math.sqrt %43 : f32
      %45 = arith.mulf %20, %44 : f32
      %46 = memref.load %arg7[%41] : memref<?xf32>
      %47 = memref.load %arg11[%arg19] : memref<?xf32>
      %48 = arith.subf %46, %47 : f32
      %49 = arith.mulf %45, %48 : f32
      %50 = arith.subf %40, %49 : f32
      %51 = arith.mulf %12, %50 : f32
      memref.store %51, %arg1[%41] : memref<?xf32>
      memref.store %51, %arg1[%arg19] : memref<?xf32>
      memref.store %cst, %arg0[%arg19] : memref<?xf32>
    }
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%26, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%26, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%26, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%26, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%26, %15) step (%c1, %c1) {
      %27 = memref.load %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %28 = memref.load %reinterpret_cast_0[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %29 = arith.mulf %27, %28 : f32
      memref.store %29, %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %30 = memref.load %reinterpret_cast_1[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %31 = memref.load %reinterpret_cast_2[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %32 = arith.mulf %30, %31 : f32
      memref.store %32, %reinterpret_cast_1[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


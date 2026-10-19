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
      %37 = memref.load %arg2[%arg19] : memref<?xf32>
      %38 = arith.muli %arg19, %15 overflow<nsw> : index
      %39 = arith.addi %38, %16 : index
      %40 = memref.load %arg6[%39] : memref<?xf32>
      %41 = arith.divf %10, %40 : f32
      %42 = math.sqrt %41 : f32
      %43 = arith.mulf %9, %42 : f32
      %44 = memref.load %arg7[%39] : memref<?xf32>
      %45 = memref.load %arg8[%arg19] : memref<?xf32>
      %46 = arith.subf %44, %45 : f32
      %47 = arith.mulf %43, %46 : f32
      %48 = arith.addf %37, %47 : f32
      %49 = arith.addi %38, %14 : index
      memref.store %48, %arg0[%49] : memref<?xf32>
      %50 = memref.load %arg0[%49] : memref<?xf32>
      %51 = arith.mulf %12, %50 : f32
      memref.store %51, %arg0[%49] : memref<?xf32>
      memref.store %cst, %arg1[%49] : memref<?xf32>
      %52 = memref.load %arg3[%arg19] : memref<?xf32>
      %53 = arith.addi %38, %c1 : index
      %54 = memref.load %arg6[%53] : memref<?xf32>
      %55 = arith.divf %10, %54 : f32
      %56 = math.sqrt %55 : f32
      %57 = arith.mulf %13, %56 : f32
      %58 = memref.load %arg7[%53] : memref<?xf32>
      %59 = memref.load %arg9[%arg19] : memref<?xf32>
      %60 = arith.subf %58, %59 : f32
      %61 = arith.mulf %57, %60 : f32
      %62 = arith.subf %52, %61 : f32
      memref.store %62, %arg0[%53] : memref<?xf32>
      %63 = memref.load %arg0[%53] : memref<?xf32>
      %64 = arith.mulf %12, %63 : f32
      memref.store %64, %arg0[%53] : memref<?xf32>
      %65 = memref.load %arg0[%53] : memref<?xf32>
      memref.store %65, %arg0[%38] : memref<?xf32>
      memref.store %cst, %arg1[%38] : memref<?xf32>
    }
    %17 = memref.load %3[%c0] : memref<1xi32>
    %18 = arith.index_cast %17 : i32 to index
    %19 = memref.get_global @jmm2 : memref<1xi32>
    %20 = memref.load %0[%c0] : memref<1xi32>
    %21 = memref.load %4[%c0] : memref<1xi32>
    %22 = memref.load %arg17[%c0] : memref<?xf32>
    %23 = memref.load %5[%c0] : memref<1xf32>
    %24 = memref.load %19[%c0] : memref<1xi32>
    %25 = memref.load %arg14[%c0] : memref<?xf32>
    %26 = memref.load %arg18[%c0] : memref<?xf32>
    %27 = arith.index_cast %20 : i32 to index
    %28 = arith.index_cast %21 : i32 to index
    %29 = arith.muli %27, %28 : index
    %30 = arith.index_cast %24 : i32 to index
    %31 = arith.muli %30, %28 : index
    scf.for %arg19 = %c1 to %18 step %c1 {
      %37 = memref.load %arg4[%arg19] : memref<?xf32>
      %38 = arith.addi %arg19, %31 : index
      %39 = memref.load %arg6[%38] : memref<?xf32>
      %40 = arith.divf %23, %39 : f32
      %41 = math.sqrt %40 : f32
      %42 = arith.mulf %22, %41 : f32
      %43 = memref.load %arg7[%38] : memref<?xf32>
      %44 = memref.load %arg10[%arg19] : memref<?xf32>
      %45 = arith.subf %43, %44 : f32
      %46 = arith.mulf %42, %45 : f32
      %47 = arith.addf %37, %46 : f32
      %48 = arith.mulf %25, %47 : f32
      %49 = arith.addi %arg19, %29 : index
      memref.store %48, %arg1[%49] : memref<?xf32>
      memref.store %cst, %arg0[%49] : memref<?xf32>
      %50 = memref.load %arg5[%arg19] : memref<?xf32>
      %51 = arith.addi %arg19, %28 : index
      %52 = memref.load %arg6[%51] : memref<?xf32>
      %53 = arith.divf %23, %52 : f32
      %54 = math.sqrt %53 : f32
      %55 = arith.mulf %26, %54 : f32
      %56 = memref.load %arg7[%51] : memref<?xf32>
      %57 = memref.load %arg11[%arg19] : memref<?xf32>
      %58 = arith.subf %56, %57 : f32
      %59 = arith.mulf %55, %58 : f32
      %60 = arith.subf %50, %59 : f32
      %61 = arith.mulf %25, %60 : f32
      memref.store %61, %arg1[%51] : memref<?xf32>
      memref.store %61, %arg1[%arg19] : memref<?xf32>
      memref.store %cst, %arg0[%arg19] : memref<?xf32>
    }
    %32 = memref.get_global @jm : memref<1xi32>
    %33 = memref.load %32[%c0] : memref<1xi32>
    %34 = arith.index_cast %33 : i32 to index
    %35 = memref.load %4[%c0] : memref<1xi32>
    %36 = arith.index_cast %35 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%34, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%34, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%34, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%34, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%34, %36) step (%c1, %c1) {
      %37 = memref.load %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %38 = memref.load %reinterpret_cast_0[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.mulf %37, %38 : f32
      memref.store %39, %reinterpret_cast[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %40 = memref.load %reinterpret_cast_1[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %41 = memref.load %reinterpret_cast_2[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      %42 = arith.mulf %40, %41 : f32
      memref.store %42, %reinterpret_cast_1[%arg19, %arg20] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    return
  }
}


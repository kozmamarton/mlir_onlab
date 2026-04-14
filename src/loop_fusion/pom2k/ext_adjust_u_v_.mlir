module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_adjust_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "utb", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vtb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = arith.muli %2, %5 : index
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%8, %2, %5], strides: [%9, %5, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%2, %5], strides: [%5, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%2, %5) step (%c1, %c1) {
      memref.store %cst, %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %10 = memref.load %6[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.load %0[%c0] : memref<1xi32>
    %13 = memref.load %3[%c0] : memref<1xi32>
    %14 = arith.index_cast %12 : i32 to index
    %15 = arith.index_cast %13 : i32 to index
    scf.for %arg9 = %c0 to %11 step %c1 {
      %38 = memref.load %arg3[%arg9] : memref<?xf32>
      scf.parallel (%arg10, %arg11) = (%c0, %c0) to (%14, %15) step (%c1, %c1) {
        %39 = memref.load %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %40 = memref.load %reinterpret_cast_0[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = arith.mulf %40, %38 : f32
        %42 = arith.addf %39, %41 : f32
        memref.store %42, %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      }
    }
    %16 = memref.load %6[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.load %0[%c0] : memref<1xi32>
    %19 = memref.load %3[%c0] : memref<1xi32>
    %20 = arith.index_cast %18 : i32 to index
    %21 = arith.index_cast %19 : i32 to index
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%17, %20) step (%c1, %c1) {
      %38 = arith.addi %21, %c-1 : index
      scf.parallel (%arg11) = (%c0) to (%38) step (%c1) {
        %39 = arith.addi %arg11, %c1 : index
        %40 = memref.load %reinterpret_cast_0[%arg9, %arg10, %39] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = memref.load %reinterpret_cast[%arg10, %39] : memref<?x?xf32, strided<[?, 1]>>
        %42 = arith.subf %40, %41 : f32
        %43 = memref.load %reinterpret_cast_2[%arg10, %39] : memref<?x?xf32, strided<[?, 1]>>
        %44 = memref.load %reinterpret_cast_3[%arg10, %39] : memref<?x?xf32, strided<[?, 1]>>
        %45 = arith.addf %43, %44 : f32
        %46 = memref.load %reinterpret_cast_6[%arg10, %39] : memref<?x?xf32, strided<[?, 1]>>
        %47 = memref.load %reinterpret_cast_6[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %48 = arith.addf %46, %47 : f32
        %49 = arith.divf %45, %48 : f32
        %50 = arith.addf %42, %49 : f32
        memref.store %50, %reinterpret_cast_0[%arg9, %arg10, %39] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
      scf.reduce 
    }
    %22 = memref.load %0[%c0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = memref.load %3[%c0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    scf.parallel (%arg9, %arg10) = (%c0, %c0) to (%23, %25) step (%c1, %c1) {
      memref.store %cst, %reinterpret_cast[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
      scf.reduce 
    }
    %26 = memref.load %6[%c0] : memref<1xi32>
    %27 = arith.index_cast %26 : i32 to index
    %28 = memref.load %0[%c0] : memref<1xi32>
    %29 = memref.load %3[%c0] : memref<1xi32>
    %30 = arith.index_cast %28 : i32 to index
    %31 = arith.index_cast %29 : i32 to index
    scf.for %arg9 = %c0 to %27 step %c1 {
      %38 = memref.load %arg3[%arg9] : memref<?xf32>
      scf.parallel (%arg10, %arg11) = (%c0, %c0) to (%30, %31) step (%c1, %c1) {
        %39 = memref.load %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %40 = memref.load %reinterpret_cast_1[%arg9, %arg10, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = arith.mulf %40, %38 : f32
        %42 = arith.addf %39, %41 : f32
        memref.store %42, %reinterpret_cast[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      }
    }
    %32 = memref.load %6[%c0] : memref<1xi32>
    %33 = arith.index_cast %32 : i32 to index
    %34 = memref.load %0[%c0] : memref<1xi32>
    %35 = memref.load %3[%c0] : memref<1xi32>
    %36 = arith.index_cast %34 : i32 to index
    %37 = arith.index_cast %35 : i32 to index
    scf.parallel (%arg9) = (%c0) to (%33) step (%c1) {
      %38 = arith.addi %36, %c-1 : index
      scf.parallel (%arg10, %arg11) = (%c0, %c0) to (%38, %37) step (%c1, %c1) {
        %39 = arith.addi %arg10, %c1 : index
        %40 = memref.load %reinterpret_cast_1[%arg9, %39, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = memref.load %reinterpret_cast[%39, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %42 = arith.subf %40, %41 : f32
        %43 = memref.load %reinterpret_cast_4[%39, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %44 = memref.load %reinterpret_cast_5[%39, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %45 = arith.addf %43, %44 : f32
        %46 = memref.load %reinterpret_cast_6[%39, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %47 = memref.load %reinterpret_cast_6[%arg10, %arg11] : memref<?x?xf32, strided<[?, 1]>>
        %48 = arith.addf %46, %47 : f32
        %49 = arith.divf %45, %48 : f32
        %50 = arith.addf %42, %49 : f32
        memref.store %50, %reinterpret_cast_1[%arg9, %39, %arg11] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
}


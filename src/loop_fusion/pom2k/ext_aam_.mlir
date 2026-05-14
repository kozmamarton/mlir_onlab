module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @horcon : memref<1xf32>
  memref.global @jm : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_aam_(%arg0: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jmm1 : memref<1xi32>
    %4 = memref.get_global @imm1 : memref<1xi32>
    %5 = memref.get_global @im : memref<1xi32>
    %6 = memref.get_global @jm : memref<1xi32>
    %7 = memref.get_global @horcon : memref<1xf32>
    %8 = memref.load %3[%c0] : memref<1xi32>
    %9 = memref.load %4[%c0] : memref<1xi32>
    %10 = memref.load %5[%c0] : memref<1xi32>
    %11 = memref.load %6[%c0] : memref<1xi32>
    %12 = memref.load %7[%c0] : memref<1xf32>
    %13 = arith.index_cast %8 : i32 to index
    %14 = arith.index_cast %9 : i32 to index
    %15 = arith.index_cast %10 : i32 to index
    %16 = arith.index_cast %11 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%13, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%13, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %17 = arith.muli %15, %16 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %16, %15], strides: [%17, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %16, %15], strides: [%17, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %16, %15], strides: [%17, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg5, %arg6, %arg7) = (%c0, %c1, %c1) to (%2, %13, %14) step (%c1, %c1, %c1) {
      %18 = memref.load %reinterpret_cast[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %19 = arith.mulf %12, %18 : f32
      %20 = memref.load %reinterpret_cast_1[%arg6, %arg7] : memref<?x?xf32, strided<[?, 1]>>
      %21 = arith.mulf %19, %20 : f32
      %22 = arith.muli %arg6, %15 overflow<nsw> : index
      %23 = arith.addi %arg7, %22 : index
      %24 = arith.muli %arg5, %15 overflow<nsw> : index
      %25 = arith.muli %24, %16 overflow<nsw> : index
      %26 = arith.addi %23, %25 : index
      %27 = arith.addi %26, %c1 : index
      %28 = memref.load %arg3[%27] : memref<?xf32>
      %29 = memref.load %reinterpret_cast_2[%arg5, %arg6, %arg7] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = arith.subf %28, %29 : f32
      %31 = arith.divf %30, %18 : f32
      %32 = arith.mulf %31, %31 : f32
      %33 = arith.addi %arg6, %c1 : index
      %34 = memref.load %reinterpret_cast_3[%arg5, %33, %arg7] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %35 = memref.load %reinterpret_cast_3[%arg5, %arg6, %arg7] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %36 = arith.subf %34, %35 : f32
      %37 = arith.divf %36, %20 : f32
      %38 = arith.mulf %37, %37 : f32
      %39 = arith.addf %32, %38 : f32
      %40 = memref.load %reinterpret_cast_2[%arg5, %33, %arg7] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %41 = arith.muli %33, %15 overflow<nsw> : index
      %42 = arith.addi %arg7, %41 : index
      %43 = arith.addi %42, %25 : index
      %44 = arith.addi %43, %c1 : index
      %45 = memref.load %arg3[%44] : memref<?xf32>
      %46 = arith.addf %40, %45 : f32
      %47 = arith.addi %arg6, %c-1 : index
      %48 = memref.load %reinterpret_cast_2[%arg5, %47, %arg7] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %49 = arith.subf %46, %48 : f32
      %50 = arith.muli %47, %15 overflow<nsw> : index
      %51 = arith.addi %arg7, %50 : index
      %52 = arith.addi %51, %25 : index
      %53 = arith.addi %52, %c1 : index
      %54 = memref.load %arg3[%53] : memref<?xf32>
      %55 = arith.subf %49, %54 : f32
      %56 = arith.mulf %55, %cst : f32
      %57 = arith.divf %56, %20 : f32
      %58 = memref.load %arg4[%27] : memref<?xf32>
      %59 = memref.load %arg4[%44] : memref<?xf32>
      %60 = arith.addf %58, %59 : f32
      %61 = arith.addi %26, %c-1 : index
      %62 = memref.load %arg4[%61] : memref<?xf32>
      %63 = arith.subf %60, %62 : f32
      %64 = arith.addi %43, %c-1 : index
      %65 = memref.load %arg4[%64] : memref<?xf32>
      %66 = arith.subf %63, %65 : f32
      %67 = arith.mulf %66, %cst : f32
      %68 = arith.divf %67, %18 : f32
      %69 = arith.addf %57, %68 : f32
      %70 = arith.mulf %69, %cst_0 : f32
      %71 = arith.mulf %70, %69 : f32
      %72 = arith.addf %39, %71 : f32
      %73 = math.sqrt %72 : f32
      %74 = arith.mulf %21, %73 : f32
      memref.store %74, %reinterpret_cast_4[%arg5, %arg6, %arg7] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


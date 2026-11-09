module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @jmm2 : memref<1xi32>
  memref.global @imm2 : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @hmax : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_bcond_3_(%arg0: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %cst_1 = arith.constant 5.000000e-01 : f32
    %cst_2 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jmm1 : memref<1xi32>
    %4 = memref.get_global @imm1 : memref<1xi32>
    %5 = memref.get_global @im : memref<1xi32>
    %6 = memref.get_global @hmax : memref<1xf32>
    %7 = memref.get_global @jm : memref<1xi32>
    %8 = memref.get_global @imm2 : memref<1xi32>
    %9 = memref.load %3[%c0] : memref<1xi32>
    %10 = memref.load %4[%c0] : memref<1xi32>
    %11 = memref.load %5[%c0] : memref<1xi32>
    %12 = memref.load %6[%c0] : memref<1xf32>
    %13 = memref.load %7[%c0] : memref<1xi32>
    %14 = memref.load %8[%c0] : memref<1xi32>
    %15 = arith.index_cast %9 : i32 to index
    %16 = arith.index_cast %10 : i32 to index
    %17 = arith.index_cast %11 : i32 to index
    %18 = arith.index_cast %13 : i32 to index
    %19 = arith.index_cast %14 : i32 to index
    scf.for %arg7 = %c0 to %2 step %c1 {
      scf.for %arg8 = %c1 to %15 step %c1 {
        %26 = arith.muli %arg8, %17 overflow<nsw> : index
        %27 = arith.addi %26, %16 : index
        %28 = memref.load %arg0[%27] : memref<?xf32>
        %29 = arith.divf %28, %12 : f32
        %30 = math.sqrt %29 : f32
        %31 = arith.muli %arg7, %17 overflow<nsw> : index
        %32 = arith.muli %31, %18 overflow<nsw> : index
        %33 = arith.addi %32, %19 : index
        %34 = arith.addi %arg8, %c-1 : index
        %35 = arith.muli %34, %17 overflow<nsw> : index
        %36 = arith.addi %33, %35 : index
        %37 = memref.load %arg2[%36] : memref<?xf32>
        %38 = arith.mulf %37, %cst_2 : f32
        %39 = arith.addi %26, %19 : index
        %40 = arith.addi %39, %32 : index
        %41 = memref.load %arg2[%40] : memref<?xf32>
        %42 = arith.mulf %41, %cst_1 : f32
        %43 = arith.addf %38, %42 : f32
        %44 = arith.addi %arg8, %c1 : index
        %45 = arith.muli %44, %17 overflow<nsw> : index
        %46 = arith.addi %33, %45 : index
        %47 = memref.load %arg2[%46] : memref<?xf32>
        %48 = arith.mulf %47, %cst_2 : f32
        %49 = arith.addf %43, %48 : f32
        %50 = arith.mulf %30, %49 : f32
        %51 = arith.subf %cst_0, %30 : f32
        %52 = arith.addi %32, %16 : index
        %53 = arith.addi %52, %35 : index
        %54 = memref.load %arg2[%53] : memref<?xf32>
        %55 = arith.mulf %54, %cst_2 : f32
        %56 = arith.addi %27, %32 : index
        %57 = memref.load %arg2[%56] : memref<?xf32>
        %58 = arith.mulf %57, %cst_1 : f32
        %59 = arith.addf %55, %58 : f32
        %60 = arith.addi %52, %45 : index
        %61 = memref.load %arg2[%60] : memref<?xf32>
        %62 = arith.mulf %61, %cst_2 : f32
        %63 = arith.addf %59, %62 : f32
        %64 = arith.mulf %51, %63 : f32
        %65 = arith.addf %50, %64 : f32
        memref.store %65, %arg1[%56] : memref<?xf32>
        memref.store %cst, %arg3[%56] : memref<?xf32>
        %66 = memref.load %arg0[%26] : memref<?xf32>
        %67 = arith.divf %66, %12 : f32
        %68 = math.sqrt %67 : f32
        %69 = arith.addi %32, %35 : index
        %70 = arith.addi %69, %c2 : index
        %71 = memref.load %arg2[%70] : memref<?xf32>
        %72 = arith.mulf %71, %cst_2 : f32
        %73 = arith.addi %26, %32 : index
        %74 = arith.addi %73, %c2 : index
        %75 = memref.load %arg2[%74] : memref<?xf32>
        %76 = arith.mulf %75, %cst_1 : f32
        %77 = arith.addf %72, %76 : f32
        %78 = arith.addi %32, %45 : index
        %79 = arith.addi %78, %c2 : index
        %80 = memref.load %arg2[%79] : memref<?xf32>
        %81 = arith.mulf %80, %cst_2 : f32
        %82 = arith.addf %77, %81 : f32
        %83 = arith.mulf %68, %82 : f32
        %84 = arith.subf %cst_0, %68 : f32
        %85 = arith.addi %69, %c1 : index
        %86 = memref.load %arg2[%85] : memref<?xf32>
        %87 = arith.mulf %86, %cst_2 : f32
        %88 = arith.addi %73, %c1 : index
        %89 = memref.load %arg2[%88] : memref<?xf32>
        %90 = arith.mulf %89, %cst_1 : f32
        %91 = arith.addf %87, %90 : f32
        %92 = arith.addi %78, %c1 : index
        %93 = memref.load %arg2[%92] : memref<?xf32>
        %94 = arith.mulf %93, %cst_2 : f32
        %95 = arith.addf %91, %94 : f32
        %96 = arith.mulf %84, %95 : f32
        %97 = arith.addf %83, %96 : f32
        memref.store %97, %arg1[%88] : memref<?xf32>
        %98 = memref.load %arg1[%88] : memref<?xf32>
        memref.store %98, %arg1[%73] : memref<?xf32>
        memref.store %cst, %arg3[%73] : memref<?xf32>
      }
    }
    %20 = memref.get_global @jmm2 : memref<1xi32>
    %21 = memref.load %20[%c0] : memref<1xi32>
    %22 = arith.muli %15, %17 : index
    %23 = arith.index_cast %21 : i32 to index
    %24 = arith.muli %23, %17 : index
    scf.for %arg7 = %c0 to %2 step %c1 {
      scf.for %arg8 = %c1 to %16 step %c1 {
        %26 = arith.addi %arg8, %22 : index
        %27 = memref.load %arg0[%26] : memref<?xf32>
        %28 = arith.divf %27, %12 : f32
        %29 = math.sqrt %28 : f32
        %30 = arith.addi %arg8, %24 : index
        %31 = arith.muli %arg7, %17 overflow<nsw> : index
        %32 = arith.muli %31, %18 overflow<nsw> : index
        %33 = arith.addi %30, %32 : index
        %34 = arith.addi %33, %c-1 : index
        %35 = memref.load %arg4[%34] : memref<?xf32>
        %36 = arith.mulf %35, %cst_2 : f32
        %37 = memref.load %arg4[%33] : memref<?xf32>
        %38 = arith.mulf %37, %cst_1 : f32
        %39 = arith.addf %36, %38 : f32
        %40 = arith.addi %33, %c1 : index
        %41 = memref.load %arg4[%40] : memref<?xf32>
        %42 = arith.mulf %41, %cst_2 : f32
        %43 = arith.addf %39, %42 : f32
        %44 = arith.mulf %29, %43 : f32
        %45 = arith.subf %cst_0, %29 : f32
        %46 = arith.addi %26, %32 : index
        %47 = arith.addi %46, %c-1 : index
        %48 = memref.load %arg4[%47] : memref<?xf32>
        %49 = arith.mulf %48, %cst_2 : f32
        %50 = memref.load %arg4[%46] : memref<?xf32>
        %51 = arith.mulf %50, %cst_1 : f32
        %52 = arith.addf %49, %51 : f32
        %53 = arith.addi %46, %c1 : index
        %54 = memref.load %arg4[%53] : memref<?xf32>
        %55 = arith.mulf %54, %cst_2 : f32
        %56 = arith.addf %52, %55 : f32
        %57 = arith.mulf %45, %56 : f32
        %58 = arith.addf %44, %57 : f32
        memref.store %58, %arg3[%46] : memref<?xf32>
        memref.store %cst, %arg1[%46] : memref<?xf32>
        %59 = memref.load %arg0[%arg8] : memref<?xf32>
        %60 = arith.divf %59, %12 : f32
        %61 = math.sqrt %60 : f32
        %62 = arith.muli %17, %c2 overflow<nsw> : index
        %63 = arith.addi %arg8, %62 : index
        %64 = arith.addi %63, %32 : index
        %65 = arith.addi %64, %c-1 : index
        %66 = memref.load %arg4[%65] : memref<?xf32>
        %67 = arith.mulf %66, %cst_2 : f32
        %68 = memref.load %arg4[%64] : memref<?xf32>
        %69 = arith.mulf %68, %cst_1 : f32
        %70 = arith.addf %67, %69 : f32
        %71 = arith.addi %64, %c1 : index
        %72 = memref.load %arg4[%71] : memref<?xf32>
        %73 = arith.mulf %72, %cst_2 : f32
        %74 = arith.addf %70, %73 : f32
        %75 = arith.mulf %61, %74 : f32
        %76 = arith.subf %cst_0, %61 : f32
        %77 = arith.addi %arg8, %17 : index
        %78 = arith.addi %77, %32 : index
        %79 = arith.addi %78, %c-1 : index
        %80 = memref.load %arg4[%79] : memref<?xf32>
        %81 = arith.mulf %80, %cst_2 : f32
        %82 = memref.load %arg4[%78] : memref<?xf32>
        %83 = arith.mulf %82, %cst_1 : f32
        %84 = arith.addf %81, %83 : f32
        %85 = arith.addi %78, %c1 : index
        %86 = memref.load %arg4[%85] : memref<?xf32>
        %87 = arith.mulf %86, %cst_2 : f32
        %88 = arith.addf %84, %87 : f32
        %89 = arith.mulf %76, %88 : f32
        %90 = arith.addf %75, %89 : f32
        memref.store %90, %arg3[%78] : memref<?xf32>
        %91 = memref.load %arg3[%78] : memref<?xf32>
        %92 = arith.addi %arg8, %32 : index
        memref.store %91, %arg3[%92] : memref<?xf32>
        memref.store %cst, %arg1[%92] : memref<?xf32>
      }
    }
    %25 = arith.muli %17, %18 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %18, %17], strides: [%25, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %18, %17], strides: [%25, %17, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%18, %17], strides: [%17, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%18, %17], strides: [%17, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg7, %arg8, %arg9) = (%c0, %c0, %c0) to (%2, %18, %17) step (%c1, %c1, %c1) {
      %26 = memref.load %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %27 = memref.load %reinterpret_cast_4[%arg8, %arg9] : memref<?x?xf32, strided<[?, 1]>>
      %28 = arith.mulf %26, %27 : f32
      memref.store %28, %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %29 = memref.load %reinterpret_cast_3[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %30 = memref.load %reinterpret_cast_5[%arg8, %arg9] : memref<?x?xf32, strided<[?, 1]>>
      %31 = arith.mulf %29, %30 : f32
      memref.store %31, %reinterpret_cast_3[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


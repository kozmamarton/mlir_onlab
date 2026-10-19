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
        %37 = arith.muli %arg8, %17 overflow<nsw> : index
        %38 = arith.addi %37, %16 : index
        %39 = memref.load %arg0[%38] : memref<?xf32>
        %40 = arith.divf %39, %12 : f32
        %41 = math.sqrt %40 : f32
        %42 = arith.muli %arg7, %17 overflow<nsw> : index
        %43 = arith.muli %42, %18 overflow<nsw> : index
        %44 = arith.addi %43, %19 : index
        %45 = arith.addi %arg8, %c-1 : index
        %46 = arith.muli %45, %17 overflow<nsw> : index
        %47 = arith.addi %44, %46 : index
        %48 = memref.load %arg2[%47] : memref<?xf32>
        %49 = arith.mulf %48, %cst_2 : f32
        %50 = arith.addi %37, %19 : index
        %51 = arith.addi %50, %43 : index
        %52 = memref.load %arg2[%51] : memref<?xf32>
        %53 = arith.mulf %52, %cst_1 : f32
        %54 = arith.addf %49, %53 : f32
        %55 = arith.addi %arg8, %c1 : index
        %56 = arith.muli %55, %17 overflow<nsw> : index
        %57 = arith.addi %44, %56 : index
        %58 = memref.load %arg2[%57] : memref<?xf32>
        %59 = arith.mulf %58, %cst_2 : f32
        %60 = arith.addf %54, %59 : f32
        %61 = arith.mulf %41, %60 : f32
        %62 = arith.subf %cst_0, %41 : f32
        %63 = arith.addi %43, %16 : index
        %64 = arith.addi %63, %46 : index
        %65 = memref.load %arg2[%64] : memref<?xf32>
        %66 = arith.mulf %65, %cst_2 : f32
        %67 = arith.addi %38, %43 : index
        %68 = memref.load %arg2[%67] : memref<?xf32>
        %69 = arith.mulf %68, %cst_1 : f32
        %70 = arith.addf %66, %69 : f32
        %71 = arith.addi %63, %56 : index
        %72 = memref.load %arg2[%71] : memref<?xf32>
        %73 = arith.mulf %72, %cst_2 : f32
        %74 = arith.addf %70, %73 : f32
        %75 = arith.mulf %62, %74 : f32
        %76 = arith.addf %61, %75 : f32
        memref.store %76, %arg1[%67] : memref<?xf32>
        memref.store %cst, %arg3[%67] : memref<?xf32>
        %77 = memref.load %arg0[%37] : memref<?xf32>
        %78 = arith.divf %77, %12 : f32
        %79 = math.sqrt %78 : f32
        %80 = arith.addi %43, %46 : index
        %81 = arith.addi %80, %c2 : index
        %82 = memref.load %arg2[%81] : memref<?xf32>
        %83 = arith.mulf %82, %cst_2 : f32
        %84 = arith.addi %37, %43 : index
        %85 = arith.addi %84, %c2 : index
        %86 = memref.load %arg2[%85] : memref<?xf32>
        %87 = arith.mulf %86, %cst_1 : f32
        %88 = arith.addf %83, %87 : f32
        %89 = arith.addi %43, %56 : index
        %90 = arith.addi %89, %c2 : index
        %91 = memref.load %arg2[%90] : memref<?xf32>
        %92 = arith.mulf %91, %cst_2 : f32
        %93 = arith.addf %88, %92 : f32
        %94 = arith.mulf %79, %93 : f32
        %95 = arith.subf %cst_0, %79 : f32
        %96 = arith.addi %80, %c1 : index
        %97 = memref.load %arg2[%96] : memref<?xf32>
        %98 = arith.mulf %97, %cst_2 : f32
        %99 = arith.addi %84, %c1 : index
        %100 = memref.load %arg2[%99] : memref<?xf32>
        %101 = arith.mulf %100, %cst_1 : f32
        %102 = arith.addf %98, %101 : f32
        %103 = arith.addi %89, %c1 : index
        %104 = memref.load %arg2[%103] : memref<?xf32>
        %105 = arith.mulf %104, %cst_2 : f32
        %106 = arith.addf %102, %105 : f32
        %107 = arith.mulf %95, %106 : f32
        %108 = arith.addf %94, %107 : f32
        memref.store %108, %arg1[%99] : memref<?xf32>
        %109 = memref.load %arg1[%99] : memref<?xf32>
        memref.store %109, %arg1[%84] : memref<?xf32>
        memref.store %cst, %arg3[%84] : memref<?xf32>
      }
    }
    %20 = memref.load %0[%c0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.get_global @jmm2 : memref<1xi32>
    %23 = memref.load %4[%c0] : memref<1xi32>
    %24 = memref.load %3[%c0] : memref<1xi32>
    %25 = memref.load %5[%c0] : memref<1xi32>
    %26 = memref.load %6[%c0] : memref<1xf32>
    %27 = memref.load %7[%c0] : memref<1xi32>
    %28 = memref.load %22[%c0] : memref<1xi32>
    %29 = arith.index_cast %23 : i32 to index
    %30 = arith.index_cast %24 : i32 to index
    %31 = arith.index_cast %25 : i32 to index
    %32 = arith.muli %30, %31 : index
    %33 = arith.index_cast %27 : i32 to index
    %34 = arith.index_cast %28 : i32 to index
    %35 = arith.muli %34, %31 : index
    scf.for %arg7 = %c0 to %21 step %c1 {
      scf.for %arg8 = %c1 to %29 step %c1 {
        %37 = arith.addi %arg8, %32 : index
        %38 = memref.load %arg0[%37] : memref<?xf32>
        %39 = arith.divf %38, %26 : f32
        %40 = math.sqrt %39 : f32
        %41 = arith.addi %arg8, %35 : index
        %42 = arith.muli %arg7, %31 overflow<nsw> : index
        %43 = arith.muli %42, %33 overflow<nsw> : index
        %44 = arith.addi %41, %43 : index
        %45 = arith.addi %44, %c-1 : index
        %46 = memref.load %arg4[%45] : memref<?xf32>
        %47 = arith.mulf %46, %cst_2 : f32
        %48 = memref.load %arg4[%44] : memref<?xf32>
        %49 = arith.mulf %48, %cst_1 : f32
        %50 = arith.addf %47, %49 : f32
        %51 = arith.addi %44, %c1 : index
        %52 = memref.load %arg4[%51] : memref<?xf32>
        %53 = arith.mulf %52, %cst_2 : f32
        %54 = arith.addf %50, %53 : f32
        %55 = arith.mulf %40, %54 : f32
        %56 = arith.subf %cst_0, %40 : f32
        %57 = arith.addi %37, %43 : index
        %58 = arith.addi %57, %c-1 : index
        %59 = memref.load %arg4[%58] : memref<?xf32>
        %60 = arith.mulf %59, %cst_2 : f32
        %61 = memref.load %arg4[%57] : memref<?xf32>
        %62 = arith.mulf %61, %cst_1 : f32
        %63 = arith.addf %60, %62 : f32
        %64 = arith.addi %57, %c1 : index
        %65 = memref.load %arg4[%64] : memref<?xf32>
        %66 = arith.mulf %65, %cst_2 : f32
        %67 = arith.addf %63, %66 : f32
        %68 = arith.mulf %56, %67 : f32
        %69 = arith.addf %55, %68 : f32
        memref.store %69, %arg3[%57] : memref<?xf32>
        memref.store %cst, %arg1[%57] : memref<?xf32>
        %70 = memref.load %arg0[%arg8] : memref<?xf32>
        %71 = arith.divf %70, %26 : f32
        %72 = math.sqrt %71 : f32
        %73 = arith.muli %31, %c2 overflow<nsw> : index
        %74 = arith.addi %arg8, %73 : index
        %75 = arith.addi %74, %43 : index
        %76 = arith.addi %75, %c-1 : index
        %77 = memref.load %arg4[%76] : memref<?xf32>
        %78 = arith.mulf %77, %cst_2 : f32
        %79 = memref.load %arg4[%75] : memref<?xf32>
        %80 = arith.mulf %79, %cst_1 : f32
        %81 = arith.addf %78, %80 : f32
        %82 = arith.addi %75, %c1 : index
        %83 = memref.load %arg4[%82] : memref<?xf32>
        %84 = arith.mulf %83, %cst_2 : f32
        %85 = arith.addf %81, %84 : f32
        %86 = arith.mulf %72, %85 : f32
        %87 = arith.subf %cst_0, %72 : f32
        %88 = arith.addi %arg8, %31 : index
        %89 = arith.addi %88, %43 : index
        %90 = arith.addi %89, %c-1 : index
        %91 = memref.load %arg4[%90] : memref<?xf32>
        %92 = arith.mulf %91, %cst_2 : f32
        %93 = memref.load %arg4[%89] : memref<?xf32>
        %94 = arith.mulf %93, %cst_1 : f32
        %95 = arith.addf %92, %94 : f32
        %96 = arith.addi %89, %c1 : index
        %97 = memref.load %arg4[%96] : memref<?xf32>
        %98 = arith.mulf %97, %cst_2 : f32
        %99 = arith.addf %95, %98 : f32
        %100 = arith.mulf %87, %99 : f32
        %101 = arith.addf %86, %100 : f32
        memref.store %101, %arg3[%89] : memref<?xf32>
        %102 = memref.load %arg3[%89] : memref<?xf32>
        %103 = arith.addi %arg8, %43 : index
        memref.store %102, %arg3[%103] : memref<?xf32>
        memref.store %cst, %arg1[%103] : memref<?xf32>
      }
    }
    %36 = arith.muli %31, %33 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%21, %33, %31], strides: [%36, %31, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%21, %33, %31], strides: [%36, %31, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%33, %31], strides: [%31, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%33, %31], strides: [%31, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg7, %arg8, %arg9) = (%c0, %c0, %c0) to (%21, %33, %31) step (%c1, %c1, %c1) {
      %37 = memref.load %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %38 = memref.load %reinterpret_cast_4[%arg8, %arg9] : memref<?x?xf32, strided<[?, 1]>>
      %39 = arith.mulf %37, %38 : f32
      memref.store %39, %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %40 = memref.load %reinterpret_cast_3[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %41 = memref.load %reinterpret_cast_5[%arg8, %arg9] : memref<?x?xf32, strided<[?, 1]>>
      %42 = arith.mulf %40, %41 : f32
      memref.store %42, %reinterpret_cast_3[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


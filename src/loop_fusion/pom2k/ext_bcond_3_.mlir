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
        %43 = arith.muli %arg8, %17 overflow<nsw> : index
        %44 = arith.addi %43, %16 : index
        %45 = memref.load %arg0[%44] : memref<?xf32>
        %46 = arith.divf %45, %12 : f32
        %47 = math.sqrt %46 : f32
        %48 = arith.muli %arg7, %17 overflow<nsw> : index
        %49 = arith.muli %48, %18 overflow<nsw> : index
        %50 = arith.addi %49, %19 : index
        %51 = arith.addi %arg8, %c-1 : index
        %52 = arith.muli %51, %17 overflow<nsw> : index
        %53 = arith.addi %50, %52 : index
        %54 = memref.load %arg2[%53] : memref<?xf32>
        %55 = arith.mulf %54, %cst_2 : f32
        %56 = arith.addi %43, %19 : index
        %57 = arith.addi %56, %49 : index
        %58 = memref.load %arg2[%57] : memref<?xf32>
        %59 = arith.mulf %58, %cst_1 : f32
        %60 = arith.addf %55, %59 : f32
        %61 = arith.addi %arg8, %c1 : index
        %62 = arith.muli %61, %17 overflow<nsw> : index
        %63 = arith.addi %50, %62 : index
        %64 = memref.load %arg2[%63] : memref<?xf32>
        %65 = arith.mulf %64, %cst_2 : f32
        %66 = arith.addf %60, %65 : f32
        %67 = arith.mulf %47, %66 : f32
        %68 = arith.subf %cst_0, %47 : f32
        %69 = arith.addi %49, %16 : index
        %70 = arith.addi %69, %52 : index
        %71 = memref.load %arg2[%70] : memref<?xf32>
        %72 = arith.mulf %71, %cst_2 : f32
        %73 = arith.addi %44, %49 : index
        %74 = memref.load %arg2[%73] : memref<?xf32>
        %75 = arith.mulf %74, %cst_1 : f32
        %76 = arith.addf %72, %75 : f32
        %77 = arith.addi %69, %62 : index
        %78 = memref.load %arg2[%77] : memref<?xf32>
        %79 = arith.mulf %78, %cst_2 : f32
        %80 = arith.addf %76, %79 : f32
        %81 = arith.mulf %68, %80 : f32
        %82 = arith.addf %67, %81 : f32
        memref.store %82, %arg1[%73] : memref<?xf32>
        memref.store %cst, %arg3[%73] : memref<?xf32>
        %83 = memref.load %arg0[%43] : memref<?xf32>
        %84 = arith.divf %83, %12 : f32
        %85 = math.sqrt %84 : f32
        %86 = arith.addi %49, %52 : index
        %87 = arith.addi %86, %c2 : index
        %88 = memref.load %arg2[%87] : memref<?xf32>
        %89 = arith.mulf %88, %cst_2 : f32
        %90 = arith.addi %43, %49 : index
        %91 = arith.addi %90, %c2 : index
        %92 = memref.load %arg2[%91] : memref<?xf32>
        %93 = arith.mulf %92, %cst_1 : f32
        %94 = arith.addf %89, %93 : f32
        %95 = arith.addi %49, %62 : index
        %96 = arith.addi %95, %c2 : index
        %97 = memref.load %arg2[%96] : memref<?xf32>
        %98 = arith.mulf %97, %cst_2 : f32
        %99 = arith.addf %94, %98 : f32
        %100 = arith.mulf %85, %99 : f32
        %101 = arith.subf %cst_0, %85 : f32
        %102 = arith.addi %86, %c1 : index
        %103 = memref.load %arg2[%102] : memref<?xf32>
        %104 = arith.mulf %103, %cst_2 : f32
        %105 = arith.addi %90, %c1 : index
        %106 = memref.load %arg2[%105] : memref<?xf32>
        %107 = arith.mulf %106, %cst_1 : f32
        %108 = arith.addf %104, %107 : f32
        %109 = arith.addi %95, %c1 : index
        %110 = memref.load %arg2[%109] : memref<?xf32>
        %111 = arith.mulf %110, %cst_2 : f32
        %112 = arith.addf %108, %111 : f32
        %113 = arith.mulf %101, %112 : f32
        %114 = arith.addf %100, %113 : f32
        memref.store %114, %arg1[%105] : memref<?xf32>
        %115 = memref.load %arg1[%105] : memref<?xf32>
        memref.store %115, %arg1[%90] : memref<?xf32>
        memref.store %cst, %arg3[%90] : memref<?xf32>
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
        %43 = arith.addi %arg8, %32 : index
        %44 = memref.load %arg0[%43] : memref<?xf32>
        %45 = arith.divf %44, %26 : f32
        %46 = math.sqrt %45 : f32
        %47 = arith.addi %arg8, %35 : index
        %48 = arith.muli %arg7, %31 overflow<nsw> : index
        %49 = arith.muli %48, %33 overflow<nsw> : index
        %50 = arith.addi %47, %49 : index
        %51 = arith.addi %50, %c-1 : index
        %52 = memref.load %arg4[%51] : memref<?xf32>
        %53 = arith.mulf %52, %cst_2 : f32
        %54 = memref.load %arg4[%50] : memref<?xf32>
        %55 = arith.mulf %54, %cst_1 : f32
        %56 = arith.addf %53, %55 : f32
        %57 = arith.addi %50, %c1 : index
        %58 = memref.load %arg4[%57] : memref<?xf32>
        %59 = arith.mulf %58, %cst_2 : f32
        %60 = arith.addf %56, %59 : f32
        %61 = arith.mulf %46, %60 : f32
        %62 = arith.subf %cst_0, %46 : f32
        %63 = arith.addi %43, %49 : index
        %64 = arith.addi %63, %c-1 : index
        %65 = memref.load %arg4[%64] : memref<?xf32>
        %66 = arith.mulf %65, %cst_2 : f32
        %67 = memref.load %arg4[%63] : memref<?xf32>
        %68 = arith.mulf %67, %cst_1 : f32
        %69 = arith.addf %66, %68 : f32
        %70 = arith.addi %63, %c1 : index
        %71 = memref.load %arg4[%70] : memref<?xf32>
        %72 = arith.mulf %71, %cst_2 : f32
        %73 = arith.addf %69, %72 : f32
        %74 = arith.mulf %62, %73 : f32
        %75 = arith.addf %61, %74 : f32
        memref.store %75, %arg3[%63] : memref<?xf32>
        memref.store %cst, %arg1[%63] : memref<?xf32>
        %76 = memref.load %arg0[%arg8] : memref<?xf32>
        %77 = arith.divf %76, %26 : f32
        %78 = math.sqrt %77 : f32
        %79 = arith.muli %31, %c2 overflow<nsw> : index
        %80 = arith.addi %arg8, %79 : index
        %81 = arith.addi %80, %49 : index
        %82 = arith.addi %81, %c-1 : index
        %83 = memref.load %arg4[%82] : memref<?xf32>
        %84 = arith.mulf %83, %cst_2 : f32
        %85 = memref.load %arg4[%81] : memref<?xf32>
        %86 = arith.mulf %85, %cst_1 : f32
        %87 = arith.addf %84, %86 : f32
        %88 = arith.addi %81, %c1 : index
        %89 = memref.load %arg4[%88] : memref<?xf32>
        %90 = arith.mulf %89, %cst_2 : f32
        %91 = arith.addf %87, %90 : f32
        %92 = arith.mulf %78, %91 : f32
        %93 = arith.subf %cst_0, %78 : f32
        %94 = arith.addi %arg8, %31 : index
        %95 = arith.addi %94, %49 : index
        %96 = arith.addi %95, %c-1 : index
        %97 = memref.load %arg4[%96] : memref<?xf32>
        %98 = arith.mulf %97, %cst_2 : f32
        %99 = memref.load %arg4[%95] : memref<?xf32>
        %100 = arith.mulf %99, %cst_1 : f32
        %101 = arith.addf %98, %100 : f32
        %102 = arith.addi %95, %c1 : index
        %103 = memref.load %arg4[%102] : memref<?xf32>
        %104 = arith.mulf %103, %cst_2 : f32
        %105 = arith.addf %101, %104 : f32
        %106 = arith.mulf %93, %105 : f32
        %107 = arith.addf %92, %106 : f32
        memref.store %107, %arg3[%95] : memref<?xf32>
        %108 = memref.load %arg3[%95] : memref<?xf32>
        %109 = arith.addi %arg8, %49 : index
        memref.store %108, %arg3[%109] : memref<?xf32>
        memref.store %cst, %arg1[%109] : memref<?xf32>
      }
    }
    %36 = memref.load %0[%c0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    %38 = memref.load %7[%c0] : memref<1xi32>
    %39 = memref.load %5[%c0] : memref<1xi32>
    %40 = arith.index_cast %38 : i32 to index
    %41 = arith.index_cast %39 : i32 to index
    %42 = arith.muli %41, %40 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%37, %40, %41], strides: [%42, %41, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%40, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%37, %40, %41], strides: [%42, %41, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%40, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg7, %arg8, %arg9) = (%c0, %c0, %c0) to (%37, %40, %41) step (%c1, %c1, %c1) {
      %43 = memref.load %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %44 = memref.load %reinterpret_cast_3[%arg8, %arg9] : memref<?x?xf32, strided<[?, 1]>>
      %45 = arith.mulf %43, %44 : f32
      memref.store %45, %reinterpret_cast[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %46 = memref.load %reinterpret_cast_4[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %47 = memref.load %reinterpret_cast_5[%arg8, %arg9] : memref<?x?xf32, strided<[?, 1]>>
      %48 = arith.mulf %46, %47 : f32
      memref.store %48, %reinterpret_cast_4[%arg7, %arg8, %arg9] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    return
  }
}


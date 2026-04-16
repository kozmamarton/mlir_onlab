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
      %42 = arith.addi %15, %c-1 : index
      scf.for %arg8 = %c0 to %42 step %c1 {
        %43 = arith.addi %arg8, %c1 : index
        %44 = arith.muli %43, %17 overflow<nsw> : index
        %45 = arith.addi %44, %16 : index
        %46 = memref.load %arg0[%45] : memref<?xf32>
        %47 = arith.divf %46, %12 : f32
        %48 = math.sqrt %47 : f32
        %49 = arith.muli %arg7, %17 overflow<nsw> : index
        %50 = arith.muli %49, %18 overflow<nsw> : index
        %51 = arith.addi %50, %19 : index
        %52 = arith.muli %arg8, %17 overflow<nsw> : index
        %53 = arith.addi %51, %52 : index
        %54 = memref.load %arg2[%53] : memref<?xf32>
        %55 = arith.mulf %54, %cst_2 : f32
        %56 = arith.addi %44, %19 : index
        %57 = arith.addi %56, %50 : index
        %58 = memref.load %arg2[%57] : memref<?xf32>
        %59 = arith.mulf %58, %cst_1 : f32
        %60 = arith.addf %55, %59 : f32
        %61 = arith.addi %arg8, %c2 : index
        %62 = arith.muli %61, %17 overflow<nsw> : index
        %63 = arith.addi %51, %62 : index
        %64 = memref.load %arg2[%63] : memref<?xf32>
        %65 = arith.mulf %64, %cst_2 : f32
        %66 = arith.addf %60, %65 : f32
        %67 = arith.mulf %48, %66 : f32
        %68 = arith.subf %cst_0, %48 : f32
        %69 = arith.addi %50, %16 : index
        %70 = arith.addi %69, %52 : index
        %71 = memref.load %arg2[%70] : memref<?xf32>
        %72 = arith.mulf %71, %cst_2 : f32
        %73 = arith.addi %45, %50 : index
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
        %83 = memref.load %arg0[%44] : memref<?xf32>
        %84 = arith.divf %83, %12 : f32
        %85 = math.sqrt %84 : f32
        %86 = arith.addi %50, %52 : index
        %87 = arith.addi %86, %c2 : index
        %88 = memref.load %arg2[%87] : memref<?xf32>
        %89 = arith.mulf %88, %cst_2 : f32
        %90 = arith.addi %44, %50 : index
        %91 = arith.addi %90, %c2 : index
        %92 = memref.load %arg2[%91] : memref<?xf32>
        %93 = arith.mulf %92, %cst_1 : f32
        %94 = arith.addf %89, %93 : f32
        %95 = arith.addi %50, %62 : index
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
      %42 = arith.addi %29, %c-1 : index
      scf.for %arg8 = %c0 to %42 step %c1 {
        %43 = arith.addi %arg8, %32 : index
        %44 = arith.addi %43, %c1 : index
        %45 = memref.load %arg0[%44] : memref<?xf32>
        %46 = arith.divf %45, %26 : f32
        %47 = math.sqrt %46 : f32
        %48 = arith.addi %arg8, %35 : index
        %49 = arith.muli %arg7, %31 overflow<nsw> : index
        %50 = arith.muli %49, %33 overflow<nsw> : index
        %51 = arith.addi %48, %50 : index
        %52 = memref.load %arg4[%51] : memref<?xf32>
        %53 = arith.mulf %52, %cst_2 : f32
        %54 = arith.addi %51, %c1 : index
        %55 = memref.load %arg4[%54] : memref<?xf32>
        %56 = arith.mulf %55, %cst_1 : f32
        %57 = arith.addf %53, %56 : f32
        %58 = arith.addi %51, %c2 : index
        %59 = memref.load %arg4[%58] : memref<?xf32>
        %60 = arith.mulf %59, %cst_2 : f32
        %61 = arith.addf %57, %60 : f32
        %62 = arith.mulf %47, %61 : f32
        %63 = arith.subf %cst_0, %47 : f32
        %64 = arith.addi %43, %50 : index
        %65 = memref.load %arg4[%64] : memref<?xf32>
        %66 = arith.mulf %65, %cst_2 : f32
        %67 = arith.addi %64, %c1 : index
        %68 = memref.load %arg4[%67] : memref<?xf32>
        %69 = arith.mulf %68, %cst_1 : f32
        %70 = arith.addf %66, %69 : f32
        %71 = arith.addi %64, %c2 : index
        %72 = memref.load %arg4[%71] : memref<?xf32>
        %73 = arith.mulf %72, %cst_2 : f32
        %74 = arith.addf %70, %73 : f32
        %75 = arith.mulf %63, %74 : f32
        %76 = arith.addf %62, %75 : f32
        memref.store %76, %arg3[%67] : memref<?xf32>
        memref.store %cst, %arg1[%67] : memref<?xf32>
        %77 = arith.addi %arg8, %c1 : index
        %78 = memref.load %arg0[%77] : memref<?xf32>
        %79 = arith.divf %78, %26 : f32
        %80 = math.sqrt %79 : f32
        %81 = arith.muli %31, %c2 overflow<nsw> : index
        %82 = arith.addi %arg8, %81 : index
        %83 = arith.addi %82, %50 : index
        %84 = memref.load %arg4[%83] : memref<?xf32>
        %85 = arith.mulf %84, %cst_2 : f32
        %86 = arith.addi %83, %c1 : index
        %87 = memref.load %arg4[%86] : memref<?xf32>
        %88 = arith.mulf %87, %cst_1 : f32
        %89 = arith.addf %85, %88 : f32
        %90 = arith.addi %83, %c2 : index
        %91 = memref.load %arg4[%90] : memref<?xf32>
        %92 = arith.mulf %91, %cst_2 : f32
        %93 = arith.addf %89, %92 : f32
        %94 = arith.mulf %80, %93 : f32
        %95 = arith.subf %cst_0, %80 : f32
        %96 = arith.addi %arg8, %31 : index
        %97 = arith.addi %96, %50 : index
        %98 = memref.load %arg4[%97] : memref<?xf32>
        %99 = arith.mulf %98, %cst_2 : f32
        %100 = arith.addi %97, %c1 : index
        %101 = memref.load %arg4[%100] : memref<?xf32>
        %102 = arith.mulf %101, %cst_1 : f32
        %103 = arith.addf %99, %102 : f32
        %104 = arith.addi %97, %c2 : index
        %105 = memref.load %arg4[%104] : memref<?xf32>
        %106 = arith.mulf %105, %cst_2 : f32
        %107 = arith.addf %103, %106 : f32
        %108 = arith.mulf %95, %107 : f32
        %109 = arith.addf %94, %108 : f32
        memref.store %109, %arg3[%100] : memref<?xf32>
        %110 = memref.load %arg3[%100] : memref<?xf32>
        %111 = arith.addi %arg8, %50 : index
        %112 = arith.addi %111, %c1 : index
        memref.store %110, %arg3[%112] : memref<?xf32>
        memref.store %cst, %arg1[%112] : memref<?xf32>
      }
    }
    %36 = memref.load %0[%c0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    %38 = memref.load %7[%c0] : memref<1xi32>
    %39 = memref.load %5[%c0] : memref<1xi32>
    %40 = arith.index_cast %38 : i32 to index
    %41 = arith.index_cast %39 : i32 to index
    scf.for %arg7 = %c0 to %37 step %c1 {
      scf.for %arg8 = %c0 to %40 step %c1 {
        scf.for %arg9 = %c0 to %41 step %c1 {
          %42 = arith.muli %arg8, %41 overflow<nsw> : index
          %43 = arith.addi %arg9, %42 : index
          %44 = arith.muli %arg7, %41 overflow<nsw> : index
          %45 = arith.muli %44, %40 overflow<nsw> : index
          %46 = arith.addi %43, %45 : index
          %47 = memref.load %arg1[%46] : memref<?xf32>
          %48 = memref.load %arg5[%43] : memref<?xf32>
          %49 = arith.mulf %47, %48 : f32
          memref.store %49, %arg1[%46] : memref<?xf32>
          %50 = memref.load %arg3[%46] : memref<?xf32>
          %51 = memref.load %arg6[%43] : memref<?xf32>
          %52 = arith.mulf %50, %51 : f32
          memref.store %52, %arg3[%46] : memref<?xf32>
        }
      }
    }
    return
  }
}


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
        %42 = arith.muli %arg8, %17 overflow<nsw> : index
        %43 = arith.addi %42, %16 : index
        %44 = memref.load %arg0[%43] : memref<?xf32>
        %45 = arith.divf %44, %12 : f32
        %46 = math.sqrt %45 : f32
        %47 = arith.muli %arg7, %17 overflow<nsw> : index
        %48 = arith.muli %47, %18 overflow<nsw> : index
        %49 = arith.addi %48, %19 : index
        %50 = arith.addi %arg8, %c-1 : index
        %51 = arith.muli %50, %17 overflow<nsw> : index
        %52 = arith.addi %49, %51 : index
        %53 = memref.load %arg2[%52] : memref<?xf32>
        %54 = arith.mulf %53, %cst_2 : f32
        %55 = arith.addi %42, %19 : index
        %56 = arith.addi %55, %48 : index
        %57 = memref.load %arg2[%56] : memref<?xf32>
        %58 = arith.mulf %57, %cst_1 : f32
        %59 = arith.addf %54, %58 : f32
        %60 = arith.addi %arg8, %c1 : index
        %61 = arith.muli %60, %17 overflow<nsw> : index
        %62 = arith.addi %49, %61 : index
        %63 = memref.load %arg2[%62] : memref<?xf32>
        %64 = arith.mulf %63, %cst_2 : f32
        %65 = arith.addf %59, %64 : f32
        %66 = arith.mulf %46, %65 : f32
        %67 = arith.subf %cst_0, %46 : f32
        %68 = arith.addi %48, %16 : index
        %69 = arith.addi %68, %51 : index
        %70 = memref.load %arg2[%69] : memref<?xf32>
        %71 = arith.mulf %70, %cst_2 : f32
        %72 = arith.addi %43, %48 : index
        %73 = memref.load %arg2[%72] : memref<?xf32>
        %74 = arith.mulf %73, %cst_1 : f32
        %75 = arith.addf %71, %74 : f32
        %76 = arith.addi %68, %61 : index
        %77 = memref.load %arg2[%76] : memref<?xf32>
        %78 = arith.mulf %77, %cst_2 : f32
        %79 = arith.addf %75, %78 : f32
        %80 = arith.mulf %67, %79 : f32
        %81 = arith.addf %66, %80 : f32
        memref.store %81, %arg1[%72] : memref<?xf32>
        memref.store %cst, %arg3[%72] : memref<?xf32>
        %82 = memref.load %arg0[%42] : memref<?xf32>
        %83 = arith.divf %82, %12 : f32
        %84 = math.sqrt %83 : f32
        %85 = arith.addi %48, %51 : index
        %86 = arith.addi %85, %c2 : index
        %87 = memref.load %arg2[%86] : memref<?xf32>
        %88 = arith.mulf %87, %cst_2 : f32
        %89 = arith.addi %42, %48 : index
        %90 = arith.addi %89, %c2 : index
        %91 = memref.load %arg2[%90] : memref<?xf32>
        %92 = arith.mulf %91, %cst_1 : f32
        %93 = arith.addf %88, %92 : f32
        %94 = arith.addi %48, %61 : index
        %95 = arith.addi %94, %c2 : index
        %96 = memref.load %arg2[%95] : memref<?xf32>
        %97 = arith.mulf %96, %cst_2 : f32
        %98 = arith.addf %93, %97 : f32
        %99 = arith.mulf %84, %98 : f32
        %100 = arith.subf %cst_0, %84 : f32
        %101 = arith.addi %85, %c1 : index
        %102 = memref.load %arg2[%101] : memref<?xf32>
        %103 = arith.mulf %102, %cst_2 : f32
        %104 = arith.addi %89, %c1 : index
        %105 = memref.load %arg2[%104] : memref<?xf32>
        %106 = arith.mulf %105, %cst_1 : f32
        %107 = arith.addf %103, %106 : f32
        %108 = arith.addi %94, %c1 : index
        %109 = memref.load %arg2[%108] : memref<?xf32>
        %110 = arith.mulf %109, %cst_2 : f32
        %111 = arith.addf %107, %110 : f32
        %112 = arith.mulf %100, %111 : f32
        %113 = arith.addf %99, %112 : f32
        memref.store %113, %arg1[%104] : memref<?xf32>
        %114 = memref.load %arg1[%104] : memref<?xf32>
        memref.store %114, %arg1[%89] : memref<?xf32>
        memref.store %cst, %arg3[%89] : memref<?xf32>
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
        %42 = arith.addi %arg8, %32 : index
        %43 = memref.load %arg0[%42] : memref<?xf32>
        %44 = arith.divf %43, %26 : f32
        %45 = math.sqrt %44 : f32
        %46 = arith.addi %arg8, %35 : index
        %47 = arith.muli %arg7, %31 overflow<nsw> : index
        %48 = arith.muli %47, %33 overflow<nsw> : index
        %49 = arith.addi %46, %48 : index
        %50 = arith.addi %49, %c-1 : index
        %51 = memref.load %arg4[%50] : memref<?xf32>
        %52 = arith.mulf %51, %cst_2 : f32
        %53 = memref.load %arg4[%49] : memref<?xf32>
        %54 = arith.mulf %53, %cst_1 : f32
        %55 = arith.addf %52, %54 : f32
        %56 = arith.addi %49, %c1 : index
        %57 = memref.load %arg4[%56] : memref<?xf32>
        %58 = arith.mulf %57, %cst_2 : f32
        %59 = arith.addf %55, %58 : f32
        %60 = arith.mulf %45, %59 : f32
        %61 = arith.subf %cst_0, %45 : f32
        %62 = arith.addi %42, %48 : index
        %63 = arith.addi %62, %c-1 : index
        %64 = memref.load %arg4[%63] : memref<?xf32>
        %65 = arith.mulf %64, %cst_2 : f32
        %66 = memref.load %arg4[%62] : memref<?xf32>
        %67 = arith.mulf %66, %cst_1 : f32
        %68 = arith.addf %65, %67 : f32
        %69 = arith.addi %62, %c1 : index
        %70 = memref.load %arg4[%69] : memref<?xf32>
        %71 = arith.mulf %70, %cst_2 : f32
        %72 = arith.addf %68, %71 : f32
        %73 = arith.mulf %61, %72 : f32
        %74 = arith.addf %60, %73 : f32
        memref.store %74, %arg3[%62] : memref<?xf32>
        memref.store %cst, %arg1[%62] : memref<?xf32>
        %75 = memref.load %arg0[%arg8] : memref<?xf32>
        %76 = arith.divf %75, %26 : f32
        %77 = math.sqrt %76 : f32
        %78 = arith.muli %31, %c2 overflow<nsw> : index
        %79 = arith.addi %arg8, %78 : index
        %80 = arith.addi %79, %48 : index
        %81 = arith.addi %80, %c-1 : index
        %82 = memref.load %arg4[%81] : memref<?xf32>
        %83 = arith.mulf %82, %cst_2 : f32
        %84 = memref.load %arg4[%80] : memref<?xf32>
        %85 = arith.mulf %84, %cst_1 : f32
        %86 = arith.addf %83, %85 : f32
        %87 = arith.addi %80, %c1 : index
        %88 = memref.load %arg4[%87] : memref<?xf32>
        %89 = arith.mulf %88, %cst_2 : f32
        %90 = arith.addf %86, %89 : f32
        %91 = arith.mulf %77, %90 : f32
        %92 = arith.subf %cst_0, %77 : f32
        %93 = arith.addi %arg8, %31 : index
        %94 = arith.addi %93, %48 : index
        %95 = arith.addi %94, %c-1 : index
        %96 = memref.load %arg4[%95] : memref<?xf32>
        %97 = arith.mulf %96, %cst_2 : f32
        %98 = memref.load %arg4[%94] : memref<?xf32>
        %99 = arith.mulf %98, %cst_1 : f32
        %100 = arith.addf %97, %99 : f32
        %101 = arith.addi %94, %c1 : index
        %102 = memref.load %arg4[%101] : memref<?xf32>
        %103 = arith.mulf %102, %cst_2 : f32
        %104 = arith.addf %100, %103 : f32
        %105 = arith.mulf %92, %104 : f32
        %106 = arith.addf %91, %105 : f32
        memref.store %106, %arg3[%94] : memref<?xf32>
        %107 = memref.load %arg3[%94] : memref<?xf32>
        %108 = arith.addi %arg8, %48 : index
        memref.store %107, %arg3[%108] : memref<?xf32>
        memref.store %cst, %arg1[%108] : memref<?xf32>
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


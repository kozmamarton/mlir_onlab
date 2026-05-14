module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @dti2 : memref<1xf32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_smol_adif_(%arg0: memref<?xf32> {polygeist.name = "xmassflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ymassflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "zwflux", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "sw", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %true = arith.constant true
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %cst_1 = arith.constant 9.99999982E-15 : f32
    %cst_2 = arith.constant 9.99999971E-10 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %9 = arith.muli %8, %7 : index
    %reinterpret_cast_3 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg10, %arg11, %arg12) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c1, %c1, %c1) {
      %45 = memref.load %reinterpret_cast[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %46 = memref.load %reinterpret_cast_3[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %47 = arith.mulf %46, %45 : f32
      memref.store %47, %reinterpret_cast_3[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.get_global @kbm1 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @jmm1 : memref<1xi32>
    %14 = memref.load %13[%c0] : memref<1xi32>
    %15 = memref.load %4[%c0] : memref<1xi32>
    %16 = memref.load %3[%c0] : memref<1xi32>
    %17 = memref.load %arg4[%c0] : memref<?xf32>
    %18 = arith.index_cast %14 : i32 to index
    %19 = arith.index_cast %15 : i32 to index
    %20 = arith.index_cast %16 : i32 to index
    %21 = arith.muli %19, %20 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%12, %20, %19], strides: [%21, %19, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg10 = %c0 to %12 step %c1 {
      scf.for %arg11 = %c1 to %18 step %c1 {
        scf.for %arg12 = %c1 to %19 step %c1 {
          %45 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %46 = arith.cmpf olt, %45, %cst_2 : f32
          %47 = scf.if %46 -> (i1) {
            scf.yield %true : i1
          } else {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.addi %arg12, %c-1 : index
            %51 = arith.index_cast %48 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %50, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %49 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg3[%57] : memref<?xf32>
            %59 = arith.cmpf olt, %58, %cst_2 : f32
            scf.yield %59 : i1
          }
          scf.if %47 {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.index_cast %48 : i32 to index
            %51 = arith.muli %arg11, %50 : index
            %52 = arith.addi %arg12, %51 : index
            %53 = arith.muli %arg10, %50 : index
            %54 = arith.index_cast %49 : i32 to index
            %55 = arith.muli %53, %54 : index
            %56 = arith.addi %52, %55 : index
            memref.store %cst_0, %arg0[%56] : memref<?xf32>
          } else {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.index_cast %48 : i32 to index
            %51 = arith.muli %arg11, %50 : index
            %52 = arith.addi %arg12, %51 : index
            %53 = arith.muli %arg10, %50 : index
            %54 = arith.index_cast %49 : i32 to index
            %55 = arith.muli %53, %54 : index
            %56 = arith.addi %52, %55 : index
            %57 = memref.load %arg0[%56] : memref<?xf32>
            %58 = arith.extf %57 : f32 to f64
            %59 = math.absf %58 : f64
            %60 = arith.truncf %59 : f64 to f32
            %61 = memref.get_global @dti2 : memref<1xf32>
            %62 = memref.load %61[%c0] : memref<1xf32>
            %63 = arith.mulf %62, %57 : f32
            %64 = arith.mulf %63, %57 : f32
            %65 = arith.mulf %64, %cst : f32
            %66 = memref.load %arg6[%52] : memref<?xf32>
            %67 = arith.addi %arg12, %c-1 : index
            %68 = arith.addi %67, %51 : index
            %69 = memref.load %arg8[%68] : memref<?xf32>
            %70 = memref.load %arg8[%52] : memref<?xf32>
            %71 = arith.addf %69, %70 : f32
            %72 = arith.mulf %66, %71 : f32
            %73 = arith.divf %65, %72 : f32
            %74 = memref.load %arg3[%56] : memref<?xf32>
            %75 = arith.addi %68, %55 : index
            %76 = memref.load %arg3[%75] : memref<?xf32>
            %77 = arith.subf %74, %76 : f32
            %78 = arith.addf %76, %74 : f32
            %79 = arith.addf %78, %cst_1 : f32
            %80 = arith.divf %77, %79 : f32
            %81 = arith.subf %60, %73 : f32
            %82 = arith.mulf %81, %80 : f32
            %83 = arith.mulf %82, %17 : f32
            memref.store %83, %arg0[%56] : memref<?xf32>
            %84 = arith.extf %60 : f32 to f64
            %85 = math.absf %84 : f64
            %86 = arith.extf %73 : f32 to f64
            %87 = math.absf %86 : f64
            %88 = arith.cmpf olt, %85, %87 : f64
            scf.if %88 {
              %89 = memref.load %4[%c0] : memref<1xi32>
              %90 = memref.load %3[%c0] : memref<1xi32>
              %91 = arith.index_cast %89 : i32 to index
              %92 = arith.muli %arg11, %91 : index
              %93 = arith.addi %arg12, %92 : index
              %94 = arith.muli %arg10, %91 : index
              %95 = arith.index_cast %90 : i32 to index
              %96 = arith.muli %94, %95 : index
              %97 = arith.addi %93, %96 : index
              memref.store %cst_0, %arg0[%97] : memref<?xf32>
            }
          }
        }
      }
    }
    %22 = memref.load %10[%c0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = memref.get_global @imm1 : memref<1xi32>
    %25 = memref.load %3[%c0] : memref<1xi32>
    %26 = memref.load %24[%c0] : memref<1xi32>
    %27 = memref.load %4[%c0] : memref<1xi32>
    %28 = memref.load %arg4[%c0] : memref<?xf32>
    %29 = arith.index_cast %25 : i32 to index
    %30 = arith.index_cast %26 : i32 to index
    %31 = arith.index_cast %27 : i32 to index
    %32 = arith.muli %31, %29 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%23, %29, %31], strides: [%32, %31, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg10 = %c0 to %23 step %c1 {
      scf.for %arg11 = %c1 to %29 step %c1 {
        scf.for %arg12 = %c1 to %30 step %c1 {
          %45 = memref.load %reinterpret_cast_5[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %46 = arith.cmpf olt, %45, %cst_2 : f32
          %47 = scf.if %46 -> (i1) {
            scf.yield %true : i1
          } else {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.addi %arg11, %c-1 : index
            %51 = arith.index_cast %48 : i32 to index
            %52 = arith.muli %50, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %49 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg3[%57] : memref<?xf32>
            %59 = arith.cmpf olt, %58, %cst_2 : f32
            scf.yield %59 : i1
          }
          scf.if %47 {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.index_cast %48 : i32 to index
            %51 = arith.muli %arg11, %50 : index
            %52 = arith.addi %arg12, %51 : index
            %53 = arith.muli %arg10, %50 : index
            %54 = arith.index_cast %49 : i32 to index
            %55 = arith.muli %53, %54 : index
            %56 = arith.addi %52, %55 : index
            memref.store %cst_0, %arg1[%56] : memref<?xf32>
          } else {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.index_cast %48 : i32 to index
            %51 = arith.muli %arg11, %50 : index
            %52 = arith.addi %arg12, %51 : index
            %53 = arith.muli %arg10, %50 : index
            %54 = arith.index_cast %49 : i32 to index
            %55 = arith.muli %53, %54 : index
            %56 = arith.addi %52, %55 : index
            %57 = memref.load %arg1[%56] : memref<?xf32>
            %58 = arith.extf %57 : f32 to f64
            %59 = math.absf %58 : f64
            %60 = arith.truncf %59 : f64 to f32
            %61 = memref.get_global @dti2 : memref<1xf32>
            %62 = memref.load %61[%c0] : memref<1xf32>
            %63 = arith.mulf %62, %57 : f32
            %64 = arith.mulf %63, %57 : f32
            %65 = arith.mulf %64, %cst : f32
            %66 = memref.load %arg7[%52] : memref<?xf32>
            %67 = arith.addi %arg11, %c-1 : index
            %68 = arith.muli %67, %50 : index
            %69 = arith.addi %arg12, %68 : index
            %70 = memref.load %arg8[%69] : memref<?xf32>
            %71 = memref.load %arg8[%52] : memref<?xf32>
            %72 = arith.addf %70, %71 : f32
            %73 = arith.mulf %66, %72 : f32
            %74 = arith.divf %65, %73 : f32
            %75 = memref.load %arg3[%56] : memref<?xf32>
            %76 = arith.addi %69, %55 : index
            %77 = memref.load %arg3[%76] : memref<?xf32>
            %78 = arith.subf %75, %77 : f32
            %79 = arith.addf %77, %75 : f32
            %80 = arith.addf %79, %cst_1 : f32
            %81 = arith.divf %78, %80 : f32
            %82 = arith.subf %60, %74 : f32
            %83 = arith.mulf %82, %81 : f32
            %84 = arith.mulf %83, %28 : f32
            memref.store %84, %arg1[%56] : memref<?xf32>
            %85 = arith.extf %60 : f32 to f64
            %86 = math.absf %85 : f64
            %87 = arith.extf %74 : f32 to f64
            %88 = math.absf %87 : f64
            %89 = arith.cmpf olt, %86, %88 : f64
            scf.if %89 {
              %90 = memref.load %4[%c0] : memref<1xi32>
              %91 = memref.load %3[%c0] : memref<1xi32>
              %92 = arith.index_cast %90 : i32 to index
              %93 = arith.muli %arg11, %92 : index
              %94 = arith.addi %arg12, %93 : index
              %95 = arith.muli %arg10, %92 : index
              %96 = arith.index_cast %91 : i32 to index
              %97 = arith.muli %95, %96 : index
              %98 = arith.addi %94, %97 : index
              memref.store %cst_0, %arg1[%98] : memref<?xf32>
            }
          }
        }
      }
    }
    %33 = memref.load %10[%c0] : memref<1xi32>
    %34 = arith.index_cast %33 : i32 to index
    %35 = memref.load %13[%c0] : memref<1xi32>
    %36 = memref.load %24[%c0] : memref<1xi32>
    %37 = memref.load %4[%c0] : memref<1xi32>
    %38 = memref.load %3[%c0] : memref<1xi32>
    %39 = memref.load %arg4[%c0] : memref<?xf32>
    %40 = arith.index_cast %35 : i32 to index
    %41 = arith.index_cast %36 : i32 to index
    %42 = arith.index_cast %37 : i32 to index
    %43 = arith.index_cast %38 : i32 to index
    %44 = arith.muli %42, %43 : index
    %reinterpret_cast_6 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%34, %43, %42], strides: [%44, %42, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg10 = %c1 to %34 step %c1 {
      scf.for %arg11 = %c1 to %40 step %c1 {
        scf.for %arg12 = %c1 to %41 step %c1 {
          %45 = memref.load %reinterpret_cast_6[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %46 = arith.cmpf olt, %45, %cst_2 : f32
          %47 = scf.if %46 -> (i1) {
            scf.yield %true : i1
          } else {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.index_cast %48 : i32 to index
            %51 = arith.muli %arg11, %50 : index
            %52 = arith.addi %arg12, %51 : index
            %53 = arith.addi %arg10, %c-1 : index
            %54 = arith.muli %53, %50 : index
            %55 = arith.index_cast %49 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %52, %56 : index
            %58 = memref.load %arg3[%57] : memref<?xf32>
            %59 = arith.cmpf olt, %58, %cst_2 : f32
            scf.yield %59 : i1
          }
          scf.if %47 {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.index_cast %48 : i32 to index
            %51 = arith.muli %arg11, %50 : index
            %52 = arith.addi %arg12, %51 : index
            %53 = arith.muli %arg10, %50 : index
            %54 = arith.index_cast %49 : i32 to index
            %55 = arith.muli %53, %54 : index
            %56 = arith.addi %52, %55 : index
            memref.store %cst_0, %arg2[%56] : memref<?xf32>
          } else {
            %48 = memref.load %4[%c0] : memref<1xi32>
            %49 = memref.load %3[%c0] : memref<1xi32>
            %50 = arith.index_cast %48 : i32 to index
            %51 = arith.muli %arg11, %50 : index
            %52 = arith.addi %arg12, %51 : index
            %53 = arith.muli %arg10, %50 : index
            %54 = arith.index_cast %49 : i32 to index
            %55 = arith.muli %53, %54 : index
            %56 = arith.addi %52, %55 : index
            %57 = memref.load %arg2[%56] : memref<?xf32>
            %58 = arith.extf %57 : f32 to f64
            %59 = math.absf %58 : f64
            %60 = arith.truncf %59 : f64 to f32
            %61 = memref.get_global @dti2 : memref<1xf32>
            %62 = memref.load %61[%c0] : memref<1xf32>
            %63 = arith.mulf %62, %57 : f32
            %64 = arith.mulf %63, %57 : f32
            %65 = arith.addi %arg10, %c-1 : index
            %66 = memref.load %arg9[%65] : memref<?xf32>
            %67 = memref.load %arg8[%52] : memref<?xf32>
            %68 = arith.mulf %66, %67 : f32
            %69 = arith.divf %64, %68 : f32
            %70 = arith.muli %65, %50 : index
            %71 = arith.muli %70, %54 : index
            %72 = arith.addi %52, %71 : index
            %73 = memref.load %arg3[%72] : memref<?xf32>
            %74 = memref.load %arg3[%56] : memref<?xf32>
            %75 = arith.subf %73, %74 : f32
            %76 = arith.addf %74, %73 : f32
            %77 = arith.addf %76, %cst_1 : f32
            %78 = arith.divf %75, %77 : f32
            %79 = arith.subf %60, %69 : f32
            %80 = arith.mulf %79, %78 : f32
            %81 = arith.mulf %80, %39 : f32
            memref.store %81, %arg2[%56] : memref<?xf32>
            %82 = arith.extf %60 : f32 to f64
            %83 = math.absf %82 : f64
            %84 = arith.extf %69 : f32 to f64
            %85 = math.absf %84 : f64
            %86 = arith.cmpf olt, %83, %85 : f64
            scf.if %86 {
              %87 = memref.load %4[%c0] : memref<1xi32>
              %88 = memref.load %3[%c0] : memref<1xi32>
              %89 = arith.index_cast %87 : i32 to index
              %90 = arith.muli %arg11, %89 : index
              %91 = arith.addi %arg12, %90 : index
              %92 = arith.muli %arg10, %89 : index
              %93 = arith.index_cast %88 : i32 to index
              %94 = arith.muli %92, %93 : index
              %95 = arith.addi %91, %94 : index
              memref.store %cst_0, %arg2[%95] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


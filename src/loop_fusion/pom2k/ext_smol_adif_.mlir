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
    %9 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg10, %arg11, %arg12) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c1, %c1, %c1) {
      %37 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %38 = memref.load %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %39 = arith.mulf %38, %37 : f32
      memref.store %39, %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
    %22 = memref.get_global @imm1 : memref<1xi32>
    %23 = memref.load %22[%c0] : memref<1xi32>
    %24 = arith.index_cast %23 : i32 to index
    scf.for %arg10 = %c0 to %12 step %c1 {
      scf.for %arg11 = %c1 to %18 step %c1 {
        scf.for %arg12 = %c1 to %19 step %c1 {
          %37 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %38 = arith.cmpf olt, %37, %cst_2 : f32
          %39 = scf.if %38 -> (i1) {
            scf.yield %true : i1
          } else {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.addi %arg12, %c-1 : index
            %43 = arith.index_cast %40 : i32 to index
            %44 = arith.muli %arg11, %43 : index
            %45 = arith.addi %42, %44 : index
            %46 = arith.muli %arg10, %43 : index
            %47 = arith.index_cast %41 : i32 to index
            %48 = arith.muli %46, %47 : index
            %49 = arith.addi %45, %48 : index
            %50 = memref.load %arg3[%49] : memref<?xf32>
            %51 = arith.cmpf olt, %50, %cst_2 : f32
            scf.yield %51 : i1
          }
          scf.if %39 {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.index_cast %40 : i32 to index
            %43 = arith.muli %arg11, %42 : index
            %44 = arith.addi %arg12, %43 : index
            %45 = arith.muli %arg10, %42 : index
            %46 = arith.index_cast %41 : i32 to index
            %47 = arith.muli %45, %46 : index
            %48 = arith.addi %44, %47 : index
            memref.store %cst_0, %arg0[%48] : memref<?xf32>
          } else {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.index_cast %40 : i32 to index
            %43 = arith.muli %arg11, %42 : index
            %44 = arith.addi %arg12, %43 : index
            %45 = arith.muli %arg10, %42 : index
            %46 = arith.index_cast %41 : i32 to index
            %47 = arith.muli %45, %46 : index
            %48 = arith.addi %44, %47 : index
            %49 = memref.load %arg0[%48] : memref<?xf32>
            %50 = arith.extf %49 : f32 to f64
            %51 = math.absf %50 : f64
            %52 = arith.truncf %51 : f64 to f32
            %53 = memref.get_global @dti2 : memref<1xf32>
            %54 = memref.load %53[%c0] : memref<1xf32>
            %55 = arith.mulf %54, %49 : f32
            %56 = arith.mulf %55, %49 : f32
            %57 = arith.mulf %56, %cst : f32
            %58 = memref.load %arg6[%44] : memref<?xf32>
            %59 = arith.addi %arg12, %c-1 : index
            %60 = arith.addi %59, %43 : index
            %61 = memref.load %arg8[%60] : memref<?xf32>
            %62 = memref.load %arg8[%44] : memref<?xf32>
            %63 = arith.addf %61, %62 : f32
            %64 = arith.mulf %58, %63 : f32
            %65 = arith.divf %57, %64 : f32
            %66 = memref.load %arg3[%48] : memref<?xf32>
            %67 = arith.addi %60, %47 : index
            %68 = memref.load %arg3[%67] : memref<?xf32>
            %69 = arith.subf %66, %68 : f32
            %70 = arith.addf %68, %66 : f32
            %71 = arith.addf %70, %cst_1 : f32
            %72 = arith.divf %69, %71 : f32
            %73 = arith.subf %52, %65 : f32
            %74 = arith.mulf %73, %72 : f32
            %75 = arith.mulf %74, %17 : f32
            memref.store %75, %arg0[%48] : memref<?xf32>
            %76 = arith.extf %52 : f32 to f64
            %77 = math.absf %76 : f64
            %78 = arith.extf %65 : f32 to f64
            %79 = math.absf %78 : f64
            %80 = arith.cmpf olt, %77, %79 : f64
            scf.if %80 {
              %81 = memref.load %4[%c0] : memref<1xi32>
              %82 = memref.load %3[%c0] : memref<1xi32>
              %83 = arith.index_cast %81 : i32 to index
              %84 = arith.muli %arg11, %83 : index
              %85 = arith.addi %arg12, %84 : index
              %86 = arith.muli %arg10, %83 : index
              %87 = arith.index_cast %82 : i32 to index
              %88 = arith.muli %86, %87 : index
              %89 = arith.addi %85, %88 : index
              memref.store %cst_0, %arg0[%89] : memref<?xf32>
            }
          }
        }
      }
      scf.for %arg11 = %c1 to %20 step %c1 {
        scf.for %arg12 = %c1 to %24 step %c1 {
          %37 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %38 = arith.cmpf olt, %37, %cst_2 : f32
          %39 = scf.if %38 -> (i1) {
            scf.yield %true : i1
          } else {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.addi %arg11, %c-1 : index
            %43 = arith.index_cast %40 : i32 to index
            %44 = arith.muli %42, %43 : index
            %45 = arith.addi %arg12, %44 : index
            %46 = arith.muli %arg10, %43 : index
            %47 = arith.index_cast %41 : i32 to index
            %48 = arith.muli %46, %47 : index
            %49 = arith.addi %45, %48 : index
            %50 = memref.load %arg3[%49] : memref<?xf32>
            %51 = arith.cmpf olt, %50, %cst_2 : f32
            scf.yield %51 : i1
          }
          scf.if %39 {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.index_cast %40 : i32 to index
            %43 = arith.muli %arg11, %42 : index
            %44 = arith.addi %arg12, %43 : index
            %45 = arith.muli %arg10, %42 : index
            %46 = arith.index_cast %41 : i32 to index
            %47 = arith.muli %45, %46 : index
            %48 = arith.addi %44, %47 : index
            memref.store %cst_0, %arg1[%48] : memref<?xf32>
          } else {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.index_cast %40 : i32 to index
            %43 = arith.muli %arg11, %42 : index
            %44 = arith.addi %arg12, %43 : index
            %45 = arith.muli %arg10, %42 : index
            %46 = arith.index_cast %41 : i32 to index
            %47 = arith.muli %45, %46 : index
            %48 = arith.addi %44, %47 : index
            %49 = memref.load %arg1[%48] : memref<?xf32>
            %50 = arith.extf %49 : f32 to f64
            %51 = math.absf %50 : f64
            %52 = arith.truncf %51 : f64 to f32
            %53 = memref.get_global @dti2 : memref<1xf32>
            %54 = memref.load %53[%c0] : memref<1xf32>
            %55 = arith.mulf %54, %49 : f32
            %56 = arith.mulf %55, %49 : f32
            %57 = arith.mulf %56, %cst : f32
            %58 = memref.load %arg7[%44] : memref<?xf32>
            %59 = arith.addi %arg11, %c-1 : index
            %60 = arith.muli %59, %42 : index
            %61 = arith.addi %arg12, %60 : index
            %62 = memref.load %arg8[%61] : memref<?xf32>
            %63 = memref.load %arg8[%44] : memref<?xf32>
            %64 = arith.addf %62, %63 : f32
            %65 = arith.mulf %58, %64 : f32
            %66 = arith.divf %57, %65 : f32
            %67 = memref.load %arg3[%48] : memref<?xf32>
            %68 = arith.addi %61, %47 : index
            %69 = memref.load %arg3[%68] : memref<?xf32>
            %70 = arith.subf %67, %69 : f32
            %71 = arith.addf %69, %67 : f32
            %72 = arith.addf %71, %cst_1 : f32
            %73 = arith.divf %70, %72 : f32
            %74 = arith.subf %52, %66 : f32
            %75 = arith.mulf %74, %73 : f32
            %76 = arith.mulf %75, %17 : f32
            memref.store %76, %arg1[%48] : memref<?xf32>
            %77 = arith.extf %52 : f32 to f64
            %78 = math.absf %77 : f64
            %79 = arith.extf %66 : f32 to f64
            %80 = math.absf %79 : f64
            %81 = arith.cmpf olt, %78, %80 : f64
            scf.if %81 {
              %82 = memref.load %4[%c0] : memref<1xi32>
              %83 = memref.load %3[%c0] : memref<1xi32>
              %84 = arith.index_cast %82 : i32 to index
              %85 = arith.muli %arg11, %84 : index
              %86 = arith.addi %arg12, %85 : index
              %87 = arith.muli %arg10, %84 : index
              %88 = arith.index_cast %83 : i32 to index
              %89 = arith.muli %87, %88 : index
              %90 = arith.addi %86, %89 : index
              memref.store %cst_0, %arg1[%90] : memref<?xf32>
            }
          }
        }
      }
    }
    %25 = memref.load %10[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    %27 = memref.load %13[%c0] : memref<1xi32>
    %28 = memref.load %22[%c0] : memref<1xi32>
    %29 = memref.load %4[%c0] : memref<1xi32>
    %30 = memref.load %3[%c0] : memref<1xi32>
    %31 = memref.load %arg4[%c0] : memref<?xf32>
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.index_cast %30 : i32 to index
    %36 = arith.muli %34, %35 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%26, %35, %34], strides: [%36, %34, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg10 = %c1 to %26 step %c1 {
      scf.for %arg11 = %c1 to %32 step %c1 {
        scf.for %arg12 = %c1 to %33 step %c1 {
          %37 = memref.load %reinterpret_cast_5[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %38 = arith.cmpf olt, %37, %cst_2 : f32
          %39 = scf.if %38 -> (i1) {
            scf.yield %true : i1
          } else {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.index_cast %40 : i32 to index
            %43 = arith.muli %arg11, %42 : index
            %44 = arith.addi %arg12, %43 : index
            %45 = arith.addi %arg10, %c-1 : index
            %46 = arith.muli %45, %42 : index
            %47 = arith.index_cast %41 : i32 to index
            %48 = arith.muli %46, %47 : index
            %49 = arith.addi %44, %48 : index
            %50 = memref.load %arg3[%49] : memref<?xf32>
            %51 = arith.cmpf olt, %50, %cst_2 : f32
            scf.yield %51 : i1
          }
          scf.if %39 {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.index_cast %40 : i32 to index
            %43 = arith.muli %arg11, %42 : index
            %44 = arith.addi %arg12, %43 : index
            %45 = arith.muli %arg10, %42 : index
            %46 = arith.index_cast %41 : i32 to index
            %47 = arith.muli %45, %46 : index
            %48 = arith.addi %44, %47 : index
            memref.store %cst_0, %arg2[%48] : memref<?xf32>
          } else {
            %40 = memref.load %4[%c0] : memref<1xi32>
            %41 = memref.load %3[%c0] : memref<1xi32>
            %42 = arith.index_cast %40 : i32 to index
            %43 = arith.muli %arg11, %42 : index
            %44 = arith.addi %arg12, %43 : index
            %45 = arith.muli %arg10, %42 : index
            %46 = arith.index_cast %41 : i32 to index
            %47 = arith.muli %45, %46 : index
            %48 = arith.addi %44, %47 : index
            %49 = memref.load %arg2[%48] : memref<?xf32>
            %50 = arith.extf %49 : f32 to f64
            %51 = math.absf %50 : f64
            %52 = arith.truncf %51 : f64 to f32
            %53 = memref.get_global @dti2 : memref<1xf32>
            %54 = memref.load %53[%c0] : memref<1xf32>
            %55 = arith.mulf %54, %49 : f32
            %56 = arith.mulf %55, %49 : f32
            %57 = arith.addi %arg10, %c-1 : index
            %58 = memref.load %arg9[%57] : memref<?xf32>
            %59 = memref.load %arg8[%44] : memref<?xf32>
            %60 = arith.mulf %58, %59 : f32
            %61 = arith.divf %56, %60 : f32
            %62 = arith.muli %57, %42 : index
            %63 = arith.muli %62, %46 : index
            %64 = arith.addi %44, %63 : index
            %65 = memref.load %arg3[%64] : memref<?xf32>
            %66 = memref.load %arg3[%48] : memref<?xf32>
            %67 = arith.subf %65, %66 : f32
            %68 = arith.addf %66, %65 : f32
            %69 = arith.addf %68, %cst_1 : f32
            %70 = arith.divf %67, %69 : f32
            %71 = arith.subf %52, %61 : f32
            %72 = arith.mulf %71, %70 : f32
            %73 = arith.mulf %72, %31 : f32
            memref.store %73, %arg2[%48] : memref<?xf32>
            %74 = arith.extf %52 : f32 to f64
            %75 = math.absf %74 : f64
            %76 = arith.extf %61 : f32 to f64
            %77 = math.absf %76 : f64
            %78 = arith.cmpf olt, %75, %77 : f64
            scf.if %78 {
              %79 = memref.load %4[%c0] : memref<1xi32>
              %80 = memref.load %3[%c0] : memref<1xi32>
              %81 = arith.index_cast %79 : i32 to index
              %82 = arith.muli %arg11, %81 : index
              %83 = arith.addi %arg12, %82 : index
              %84 = arith.muli %arg10, %81 : index
              %85 = arith.index_cast %80 : i32 to index
              %86 = arith.muli %84, %85 : index
              %87 = arith.addi %83, %86 : index
              memref.store %cst_0, %arg2[%87] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


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
      %39 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %40 = memref.load %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %41 = arith.mulf %40, %39 : f32
      memref.store %41, %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
    %25 = arith.maxsi %20, %18 : index
    %26 = arith.maxsi %24, %19 : index
    scf.for %arg10 = %c0 to %12 step %c1 {
      scf.for %arg11 = %c1 to %25 step %c1 {
        scf.for %arg12 = %c1 to %26 step %c1 {
          %39 = arith.subi %18, %arg11 : index
          %40 = arith.addi %39, %c-1 : index
          %41 = arith.cmpi sge, %40, %c0 : index
          %42 = arith.subi %19, %arg12 : index
          %43 = arith.addi %42, %c-1 : index
          %44 = arith.cmpi sge, %43, %c0 : index
          %45 = arith.andi %41, %44 : i1
          scf.if %45 {
            %53 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %54 = arith.cmpf olt, %53, %cst_2 : f32
            %55 = scf.if %54 -> (i1) {
              scf.yield %true : i1
            } else {
              %56 = memref.load %4[%c0] : memref<1xi32>
              %57 = memref.load %3[%c0] : memref<1xi32>
              %58 = arith.addi %arg12, %c-1 : index
              %59 = arith.index_cast %56 : i32 to index
              %60 = arith.muli %arg11, %59 : index
              %61 = arith.addi %58, %60 : index
              %62 = arith.muli %arg10, %59 : index
              %63 = arith.index_cast %57 : i32 to index
              %64 = arith.muli %62, %63 : index
              %65 = arith.addi %61, %64 : index
              %66 = memref.load %arg3[%65] : memref<?xf32>
              %67 = arith.cmpf olt, %66, %cst_2 : f32
              scf.yield %67 : i1
            }
            scf.if %55 {
              %56 = memref.load %4[%c0] : memref<1xi32>
              %57 = memref.load %3[%c0] : memref<1xi32>
              %58 = arith.index_cast %56 : i32 to index
              %59 = arith.muli %arg11, %58 : index
              %60 = arith.addi %arg12, %59 : index
              %61 = arith.muli %arg10, %58 : index
              %62 = arith.index_cast %57 : i32 to index
              %63 = arith.muli %61, %62 : index
              %64 = arith.addi %60, %63 : index
              memref.store %cst_0, %arg0[%64] : memref<?xf32>
            } else {
              %56 = memref.load %4[%c0] : memref<1xi32>
              %57 = memref.load %3[%c0] : memref<1xi32>
              %58 = arith.index_cast %56 : i32 to index
              %59 = arith.muli %arg11, %58 : index
              %60 = arith.addi %arg12, %59 : index
              %61 = arith.muli %arg10, %58 : index
              %62 = arith.index_cast %57 : i32 to index
              %63 = arith.muli %61, %62 : index
              %64 = arith.addi %60, %63 : index
              %65 = memref.load %arg0[%64] : memref<?xf32>
              %66 = arith.extf %65 : f32 to f64
              %67 = math.absf %66 : f64
              %68 = arith.truncf %67 : f64 to f32
              %69 = memref.get_global @dti2 : memref<1xf32>
              %70 = memref.load %69[%c0] : memref<1xf32>
              %71 = arith.mulf %70, %65 : f32
              %72 = arith.mulf %71, %65 : f32
              %73 = arith.mulf %72, %cst : f32
              %74 = memref.load %arg6[%60] : memref<?xf32>
              %75 = arith.addi %arg12, %c-1 : index
              %76 = arith.addi %75, %59 : index
              %77 = memref.load %arg8[%76] : memref<?xf32>
              %78 = memref.load %arg8[%60] : memref<?xf32>
              %79 = arith.addf %77, %78 : f32
              %80 = arith.mulf %74, %79 : f32
              %81 = arith.divf %73, %80 : f32
              %82 = memref.load %arg3[%64] : memref<?xf32>
              %83 = arith.addi %76, %63 : index
              %84 = memref.load %arg3[%83] : memref<?xf32>
              %85 = arith.subf %82, %84 : f32
              %86 = arith.addf %84, %82 : f32
              %87 = arith.addf %86, %cst_1 : f32
              %88 = arith.divf %85, %87 : f32
              %89 = arith.subf %68, %81 : f32
              %90 = arith.mulf %89, %88 : f32
              %91 = arith.mulf %90, %17 : f32
              memref.store %91, %arg0[%64] : memref<?xf32>
              %92 = arith.extf %68 : f32 to f64
              %93 = math.absf %92 : f64
              %94 = arith.extf %81 : f32 to f64
              %95 = math.absf %94 : f64
              %96 = arith.cmpf olt, %93, %95 : f64
              scf.if %96 {
                %97 = memref.load %4[%c0] : memref<1xi32>
                %98 = memref.load %3[%c0] : memref<1xi32>
                %99 = arith.index_cast %97 : i32 to index
                %100 = arith.muli %arg11, %99 : index
                %101 = arith.addi %arg12, %100 : index
                %102 = arith.muli %arg10, %99 : index
                %103 = arith.index_cast %98 : i32 to index
                %104 = arith.muli %102, %103 : index
                %105 = arith.addi %101, %104 : index
                memref.store %cst_0, %arg0[%105] : memref<?xf32>
              }
            }
          }
          %46 = arith.subi %20, %arg11 : index
          %47 = arith.addi %46, %c-1 : index
          %48 = arith.cmpi sge, %47, %c0 : index
          %49 = arith.subi %24, %arg12 : index
          %50 = arith.addi %49, %c-1 : index
          %51 = arith.cmpi sge, %50, %c0 : index
          %52 = arith.andi %48, %51 : i1
          scf.if %52 {
            %53 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %54 = arith.cmpf olt, %53, %cst_2 : f32
            %55 = scf.if %54 -> (i1) {
              scf.yield %true : i1
            } else {
              %56 = memref.load %4[%c0] : memref<1xi32>
              %57 = memref.load %3[%c0] : memref<1xi32>
              %58 = arith.addi %arg11, %c-1 : index
              %59 = arith.index_cast %56 : i32 to index
              %60 = arith.muli %58, %59 : index
              %61 = arith.addi %arg12, %60 : index
              %62 = arith.muli %arg10, %59 : index
              %63 = arith.index_cast %57 : i32 to index
              %64 = arith.muli %62, %63 : index
              %65 = arith.addi %61, %64 : index
              %66 = memref.load %arg3[%65] : memref<?xf32>
              %67 = arith.cmpf olt, %66, %cst_2 : f32
              scf.yield %67 : i1
            }
            scf.if %55 {
              %56 = memref.load %4[%c0] : memref<1xi32>
              %57 = memref.load %3[%c0] : memref<1xi32>
              %58 = arith.index_cast %56 : i32 to index
              %59 = arith.muli %arg11, %58 : index
              %60 = arith.addi %arg12, %59 : index
              %61 = arith.muli %arg10, %58 : index
              %62 = arith.index_cast %57 : i32 to index
              %63 = arith.muli %61, %62 : index
              %64 = arith.addi %60, %63 : index
              memref.store %cst_0, %arg1[%64] : memref<?xf32>
            } else {
              %56 = memref.load %4[%c0] : memref<1xi32>
              %57 = memref.load %3[%c0] : memref<1xi32>
              %58 = arith.index_cast %56 : i32 to index
              %59 = arith.muli %arg11, %58 : index
              %60 = arith.addi %arg12, %59 : index
              %61 = arith.muli %arg10, %58 : index
              %62 = arith.index_cast %57 : i32 to index
              %63 = arith.muli %61, %62 : index
              %64 = arith.addi %60, %63 : index
              %65 = memref.load %arg1[%64] : memref<?xf32>
              %66 = arith.extf %65 : f32 to f64
              %67 = math.absf %66 : f64
              %68 = arith.truncf %67 : f64 to f32
              %69 = memref.get_global @dti2 : memref<1xf32>
              %70 = memref.load %69[%c0] : memref<1xf32>
              %71 = arith.mulf %70, %65 : f32
              %72 = arith.mulf %71, %65 : f32
              %73 = arith.mulf %72, %cst : f32
              %74 = memref.load %arg7[%60] : memref<?xf32>
              %75 = arith.addi %arg11, %c-1 : index
              %76 = arith.muli %75, %58 : index
              %77 = arith.addi %arg12, %76 : index
              %78 = memref.load %arg8[%77] : memref<?xf32>
              %79 = memref.load %arg8[%60] : memref<?xf32>
              %80 = arith.addf %78, %79 : f32
              %81 = arith.mulf %74, %80 : f32
              %82 = arith.divf %73, %81 : f32
              %83 = memref.load %arg3[%64] : memref<?xf32>
              %84 = arith.addi %77, %63 : index
              %85 = memref.load %arg3[%84] : memref<?xf32>
              %86 = arith.subf %83, %85 : f32
              %87 = arith.addf %85, %83 : f32
              %88 = arith.addf %87, %cst_1 : f32
              %89 = arith.divf %86, %88 : f32
              %90 = arith.subf %68, %82 : f32
              %91 = arith.mulf %90, %89 : f32
              %92 = arith.mulf %91, %17 : f32
              memref.store %92, %arg1[%64] : memref<?xf32>
              %93 = arith.extf %68 : f32 to f64
              %94 = math.absf %93 : f64
              %95 = arith.extf %82 : f32 to f64
              %96 = math.absf %95 : f64
              %97 = arith.cmpf olt, %94, %96 : f64
              scf.if %97 {
                %98 = memref.load %4[%c0] : memref<1xi32>
                %99 = memref.load %3[%c0] : memref<1xi32>
                %100 = arith.index_cast %98 : i32 to index
                %101 = arith.muli %arg11, %100 : index
                %102 = arith.addi %arg12, %101 : index
                %103 = arith.muli %arg10, %100 : index
                %104 = arith.index_cast %99 : i32 to index
                %105 = arith.muli %103, %104 : index
                %106 = arith.addi %102, %105 : index
                memref.store %cst_0, %arg1[%106] : memref<?xf32>
              }
            }
          }
        }
      }
    }
    %27 = memref.load %10[%c0] : memref<1xi32>
    %28 = arith.index_cast %27 : i32 to index
    %29 = memref.load %13[%c0] : memref<1xi32>
    %30 = memref.load %22[%c0] : memref<1xi32>
    %31 = memref.load %4[%c0] : memref<1xi32>
    %32 = memref.load %3[%c0] : memref<1xi32>
    %33 = memref.load %arg4[%c0] : memref<?xf32>
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.index_cast %30 : i32 to index
    %36 = arith.index_cast %31 : i32 to index
    %37 = arith.index_cast %32 : i32 to index
    %38 = arith.muli %36, %37 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%28, %37, %36], strides: [%38, %36, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.for %arg10 = %c1 to %28 step %c1 {
      scf.for %arg11 = %c1 to %34 step %c1 {
        scf.for %arg12 = %c1 to %35 step %c1 {
          %39 = memref.load %reinterpret_cast_5[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %40 = arith.cmpf olt, %39, %cst_2 : f32
          %41 = scf.if %40 -> (i1) {
            scf.yield %true : i1
          } else {
            %42 = memref.load %4[%c0] : memref<1xi32>
            %43 = memref.load %3[%c0] : memref<1xi32>
            %44 = arith.index_cast %42 : i32 to index
            %45 = arith.muli %arg11, %44 : index
            %46 = arith.addi %arg12, %45 : index
            %47 = arith.addi %arg10, %c-1 : index
            %48 = arith.muli %47, %44 : index
            %49 = arith.index_cast %43 : i32 to index
            %50 = arith.muli %48, %49 : index
            %51 = arith.addi %46, %50 : index
            %52 = memref.load %arg3[%51] : memref<?xf32>
            %53 = arith.cmpf olt, %52, %cst_2 : f32
            scf.yield %53 : i1
          }
          scf.if %41 {
            %42 = memref.load %4[%c0] : memref<1xi32>
            %43 = memref.load %3[%c0] : memref<1xi32>
            %44 = arith.index_cast %42 : i32 to index
            %45 = arith.muli %arg11, %44 : index
            %46 = arith.addi %arg12, %45 : index
            %47 = arith.muli %arg10, %44 : index
            %48 = arith.index_cast %43 : i32 to index
            %49 = arith.muli %47, %48 : index
            %50 = arith.addi %46, %49 : index
            memref.store %cst_0, %arg2[%50] : memref<?xf32>
          } else {
            %42 = memref.load %4[%c0] : memref<1xi32>
            %43 = memref.load %3[%c0] : memref<1xi32>
            %44 = arith.index_cast %42 : i32 to index
            %45 = arith.muli %arg11, %44 : index
            %46 = arith.addi %arg12, %45 : index
            %47 = arith.muli %arg10, %44 : index
            %48 = arith.index_cast %43 : i32 to index
            %49 = arith.muli %47, %48 : index
            %50 = arith.addi %46, %49 : index
            %51 = memref.load %arg2[%50] : memref<?xf32>
            %52 = arith.extf %51 : f32 to f64
            %53 = math.absf %52 : f64
            %54 = arith.truncf %53 : f64 to f32
            %55 = memref.get_global @dti2 : memref<1xf32>
            %56 = memref.load %55[%c0] : memref<1xf32>
            %57 = arith.mulf %56, %51 : f32
            %58 = arith.mulf %57, %51 : f32
            %59 = arith.addi %arg10, %c-1 : index
            %60 = memref.load %arg9[%59] : memref<?xf32>
            %61 = memref.load %arg8[%46] : memref<?xf32>
            %62 = arith.mulf %60, %61 : f32
            %63 = arith.divf %58, %62 : f32
            %64 = arith.muli %59, %44 : index
            %65 = arith.muli %64, %48 : index
            %66 = arith.addi %46, %65 : index
            %67 = memref.load %arg3[%66] : memref<?xf32>
            %68 = memref.load %arg3[%50] : memref<?xf32>
            %69 = arith.subf %67, %68 : f32
            %70 = arith.addf %68, %67 : f32
            %71 = arith.addf %70, %cst_1 : f32
            %72 = arith.divf %69, %71 : f32
            %73 = arith.subf %54, %63 : f32
            %74 = arith.mulf %73, %72 : f32
            %75 = arith.mulf %74, %33 : f32
            memref.store %75, %arg2[%50] : memref<?xf32>
            %76 = arith.extf %54 : f32 to f64
            %77 = math.absf %76 : f64
            %78 = arith.extf %63 : f32 to f64
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
              memref.store %cst_0, %arg2[%89] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


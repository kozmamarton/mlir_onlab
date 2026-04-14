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
    scf.for %arg10 = %c0 to %2 step %c1 {
      scf.for %arg11 = %c0 to %7 step %c1 {
        scf.for %arg12 = %c0 to %8 step %c1 {
          %42 = arith.muli %arg11, %8 overflow<nsw> : index
          %43 = arith.addi %arg12, %42 : index
          %44 = memref.load %arg5[%43] : memref<?xf32>
          %45 = arith.muli %arg10, %8 overflow<nsw> : index
          %46 = arith.muli %45, %7 overflow<nsw> : index
          %47 = arith.addi %43, %46 : index
          %48 = memref.load %arg3[%47] : memref<?xf32>
          %49 = arith.mulf %48, %44 : f32
          memref.store %49, %arg3[%47] : memref<?xf32>
        }
      }
    }
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @jmm1 : memref<1xi32>
    %13 = memref.load %12[%c0] : memref<1xi32>
    %14 = memref.load %4[%c0] : memref<1xi32>
    %15 = memref.load %3[%c0] : memref<1xi32>
    %16 = memref.load %arg4[%c0] : memref<?xf32>
    %17 = arith.index_cast %13 : i32 to index
    %18 = arith.index_cast %14 : i32 to index
    %19 = arith.index_cast %15 : i32 to index
    scf.for %arg10 = %c0 to %11 step %c1 {
      %42 = arith.addi %17, %c-1 : index
      scf.for %arg11 = %c0 to %42 step %c1 {
        %43 = arith.addi %arg11, %c1 : index
        %44 = arith.addi %18, %c-1 : index
        scf.for %arg12 = %c0 to %44 step %c1 {
          %45 = arith.addi %arg12, %c1 : index
          %46 = arith.muli %43, %18 overflow<nsw> : index
          %47 = arith.addi %arg12, %46 : index
          %48 = arith.muli %arg10, %18 overflow<nsw> : index
          %49 = arith.muli %48, %19 overflow<nsw> : index
          %50 = arith.addi %47, %49 : index
          %51 = arith.addi %50, %c1 : index
          %52 = memref.load %arg3[%51] : memref<?xf32>
          %53 = arith.cmpf olt, %52, %cst_2 : f32
          %54 = scf.if %53 -> (i1) {
            scf.yield %true : i1
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %arg12, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg3[%63] : memref<?xf32>
            %65 = arith.cmpf olt, %64, %cst_2 : f32
            scf.yield %65 : i1
          }
          scf.if %54 {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            memref.store %cst_0, %arg0[%63] : memref<?xf32>
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg0[%63] : memref<?xf32>
            %65 = arith.extf %64 : f32 to f64
            %66 = math.absf %65 : f64
            %67 = arith.truncf %66 : f64 to f32
            %68 = memref.get_global @dti2 : memref<1xf32>
            %69 = memref.load %68[%c0] : memref<1xf32>
            %70 = arith.mulf %69, %64 : f32
            %71 = arith.mulf %70, %64 : f32
            %72 = arith.mulf %71, %cst : f32
            %73 = memref.load %arg6[%59] : memref<?xf32>
            %74 = arith.addi %arg12, %58 : index
            %75 = memref.load %arg8[%74] : memref<?xf32>
            %76 = memref.load %arg8[%59] : memref<?xf32>
            %77 = arith.addf %75, %76 : f32
            %78 = arith.mulf %73, %77 : f32
            %79 = arith.divf %72, %78 : f32
            %80 = memref.load %arg3[%63] : memref<?xf32>
            %81 = arith.addi %74, %62 : index
            %82 = memref.load %arg3[%81] : memref<?xf32>
            %83 = arith.subf %80, %82 : f32
            %84 = arith.addf %82, %80 : f32
            %85 = arith.addf %84, %cst_1 : f32
            %86 = arith.divf %83, %85 : f32
            %87 = arith.subf %67, %79 : f32
            %88 = arith.mulf %87, %86 : f32
            %89 = arith.mulf %88, %16 : f32
            memref.store %89, %arg0[%63] : memref<?xf32>
            %90 = arith.extf %67 : f32 to f64
            %91 = math.absf %90 : f64
            %92 = arith.extf %79 : f32 to f64
            %93 = math.absf %92 : f64
            %94 = arith.cmpf olt, %91, %93 : f64
            scf.if %94 {
              %95 = memref.load %4[%c0] : memref<1xi32>
              %96 = memref.load %3[%c0] : memref<1xi32>
              %97 = arith.index_cast %95 : i32 to index
              %98 = arith.muli %43, %97 : index
              %99 = arith.addi %45, %98 : index
              %100 = arith.muli %arg10, %97 : index
              %101 = arith.index_cast %96 : i32 to index
              %102 = arith.muli %100, %101 : index
              %103 = arith.addi %99, %102 : index
              memref.store %cst_0, %arg0[%103] : memref<?xf32>
            }
          }
        }
      }
    }
    %20 = memref.load %9[%c0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.get_global @imm1 : memref<1xi32>
    %23 = memref.load %3[%c0] : memref<1xi32>
    %24 = memref.load %22[%c0] : memref<1xi32>
    %25 = memref.load %4[%c0] : memref<1xi32>
    %26 = memref.load %arg4[%c0] : memref<?xf32>
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.index_cast %25 : i32 to index
    scf.for %arg10 = %c0 to %21 step %c1 {
      %42 = arith.addi %27, %c-1 : index
      scf.for %arg11 = %c0 to %42 step %c1 {
        %43 = arith.addi %arg11, %c1 : index
        %44 = arith.addi %28, %c-1 : index
        scf.for %arg12 = %c0 to %44 step %c1 {
          %45 = arith.addi %arg12, %c1 : index
          %46 = arith.muli %43, %29 overflow<nsw> : index
          %47 = arith.addi %arg12, %46 : index
          %48 = arith.muli %arg10, %29 overflow<nsw> : index
          %49 = arith.muli %48, %27 overflow<nsw> : index
          %50 = arith.addi %47, %49 : index
          %51 = arith.addi %50, %c1 : index
          %52 = memref.load %arg3[%51] : memref<?xf32>
          %53 = arith.cmpf olt, %52, %cst_2 : f32
          %54 = scf.if %53 -> (i1) {
            scf.yield %true : i1
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %arg11, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg3[%63] : memref<?xf32>
            %65 = arith.cmpf olt, %64, %cst_2 : f32
            scf.yield %65 : i1
          }
          scf.if %54 {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            memref.store %cst_0, %arg1[%63] : memref<?xf32>
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg1[%63] : memref<?xf32>
            %65 = arith.extf %64 : f32 to f64
            %66 = math.absf %65 : f64
            %67 = arith.truncf %66 : f64 to f32
            %68 = memref.get_global @dti2 : memref<1xf32>
            %69 = memref.load %68[%c0] : memref<1xf32>
            %70 = arith.mulf %69, %64 : f32
            %71 = arith.mulf %70, %64 : f32
            %72 = arith.mulf %71, %cst : f32
            %73 = memref.load %arg7[%59] : memref<?xf32>
            %74 = arith.muli %arg11, %57 : index
            %75 = arith.addi %45, %74 : index
            %76 = memref.load %arg8[%75] : memref<?xf32>
            %77 = memref.load %arg8[%59] : memref<?xf32>
            %78 = arith.addf %76, %77 : f32
            %79 = arith.mulf %73, %78 : f32
            %80 = arith.divf %72, %79 : f32
            %81 = memref.load %arg3[%63] : memref<?xf32>
            %82 = arith.addi %75, %62 : index
            %83 = memref.load %arg3[%82] : memref<?xf32>
            %84 = arith.subf %81, %83 : f32
            %85 = arith.addf %83, %81 : f32
            %86 = arith.addf %85, %cst_1 : f32
            %87 = arith.divf %84, %86 : f32
            %88 = arith.subf %67, %80 : f32
            %89 = arith.mulf %88, %87 : f32
            %90 = arith.mulf %89, %26 : f32
            memref.store %90, %arg1[%63] : memref<?xf32>
            %91 = arith.extf %67 : f32 to f64
            %92 = math.absf %91 : f64
            %93 = arith.extf %80 : f32 to f64
            %94 = math.absf %93 : f64
            %95 = arith.cmpf olt, %92, %94 : f64
            scf.if %95 {
              %96 = memref.load %4[%c0] : memref<1xi32>
              %97 = memref.load %3[%c0] : memref<1xi32>
              %98 = arith.index_cast %96 : i32 to index
              %99 = arith.muli %43, %98 : index
              %100 = arith.addi %45, %99 : index
              %101 = arith.muli %arg10, %98 : index
              %102 = arith.index_cast %97 : i32 to index
              %103 = arith.muli %101, %102 : index
              %104 = arith.addi %100, %103 : index
              memref.store %cst_0, %arg1[%104] : memref<?xf32>
            }
          }
        }
      }
    }
    %30 = memref.load %9[%c0] : memref<1xi32>
    %31 = arith.index_cast %30 : i32 to index
    %32 = memref.load %12[%c0] : memref<1xi32>
    %33 = memref.load %22[%c0] : memref<1xi32>
    %34 = memref.load %4[%c0] : memref<1xi32>
    %35 = memref.load %3[%c0] : memref<1xi32>
    %36 = memref.load %arg4[%c0] : memref<?xf32>
    %37 = arith.index_cast %32 : i32 to index
    %38 = arith.index_cast %33 : i32 to index
    %39 = arith.index_cast %34 : i32 to index
    %40 = arith.index_cast %35 : i32 to index
    %41 = arith.addi %31, %c-1 : index
    scf.for %arg10 = %c0 to %41 step %c1 {
      %42 = arith.addi %arg10, %c1 : index
      %43 = arith.addi %37, %c-1 : index
      scf.for %arg11 = %c0 to %43 step %c1 {
        %44 = arith.addi %arg11, %c1 : index
        %45 = arith.addi %38, %c-1 : index
        scf.for %arg12 = %c0 to %45 step %c1 {
          %46 = arith.addi %arg12, %c1 : index
          %47 = arith.muli %44, %39 overflow<nsw> : index
          %48 = arith.addi %arg12, %47 : index
          %49 = arith.muli %42, %39 overflow<nsw> : index
          %50 = arith.muli %49, %40 overflow<nsw> : index
          %51 = arith.addi %48, %50 : index
          %52 = arith.addi %51, %c1 : index
          %53 = memref.load %arg3[%52] : memref<?xf32>
          %54 = arith.cmpf olt, %53, %cst_2 : f32
          %55 = scf.if %54 -> (i1) {
            scf.yield %true : i1
          } else {
            %56 = memref.load %4[%c0] : memref<1xi32>
            %57 = memref.load %3[%c0] : memref<1xi32>
            %58 = arith.index_cast %56 : i32 to index
            %59 = arith.muli %44, %58 : index
            %60 = arith.addi %46, %59 : index
            %61 = arith.muli %arg10, %58 : index
            %62 = arith.index_cast %57 : i32 to index
            %63 = arith.muli %61, %62 : index
            %64 = arith.addi %60, %63 : index
            %65 = memref.load %arg3[%64] : memref<?xf32>
            %66 = arith.cmpf olt, %65, %cst_2 : f32
            scf.yield %66 : i1
          }
          scf.if %55 {
            %56 = memref.load %4[%c0] : memref<1xi32>
            %57 = memref.load %3[%c0] : memref<1xi32>
            %58 = arith.index_cast %56 : i32 to index
            %59 = arith.muli %44, %58 : index
            %60 = arith.addi %46, %59 : index
            %61 = arith.muli %42, %58 : index
            %62 = arith.index_cast %57 : i32 to index
            %63 = arith.muli %61, %62 : index
            %64 = arith.addi %60, %63 : index
            memref.store %cst_0, %arg2[%64] : memref<?xf32>
          } else {
            %56 = memref.load %4[%c0] : memref<1xi32>
            %57 = memref.load %3[%c0] : memref<1xi32>
            %58 = arith.index_cast %56 : i32 to index
            %59 = arith.muli %44, %58 : index
            %60 = arith.addi %46, %59 : index
            %61 = arith.muli %42, %58 : index
            %62 = arith.index_cast %57 : i32 to index
            %63 = arith.muli %61, %62 : index
            %64 = arith.addi %60, %63 : index
            %65 = memref.load %arg2[%64] : memref<?xf32>
            %66 = arith.extf %65 : f32 to f64
            %67 = math.absf %66 : f64
            %68 = arith.truncf %67 : f64 to f32
            %69 = memref.get_global @dti2 : memref<1xf32>
            %70 = memref.load %69[%c0] : memref<1xf32>
            %71 = arith.mulf %70, %65 : f32
            %72 = arith.mulf %71, %65 : f32
            %73 = memref.load %arg9[%arg10] : memref<?xf32>
            %74 = memref.load %arg8[%60] : memref<?xf32>
            %75 = arith.mulf %73, %74 : f32
            %76 = arith.divf %72, %75 : f32
            %77 = arith.muli %arg10, %58 : index
            %78 = arith.muli %77, %62 : index
            %79 = arith.addi %60, %78 : index
            %80 = memref.load %arg3[%79] : memref<?xf32>
            %81 = memref.load %arg3[%64] : memref<?xf32>
            %82 = arith.subf %80, %81 : f32
            %83 = arith.addf %81, %80 : f32
            %84 = arith.addf %83, %cst_1 : f32
            %85 = arith.divf %82, %84 : f32
            %86 = arith.subf %68, %76 : f32
            %87 = arith.mulf %86, %85 : f32
            %88 = arith.mulf %87, %36 : f32
            memref.store %88, %arg2[%64] : memref<?xf32>
            %89 = arith.extf %68 : f32 to f64
            %90 = math.absf %89 : f64
            %91 = arith.extf %76 : f32 to f64
            %92 = math.absf %91 : f64
            %93 = arith.cmpf olt, %90, %92 : f64
            scf.if %93 {
              %94 = memref.load %4[%c0] : memref<1xi32>
              %95 = memref.load %3[%c0] : memref<1xi32>
              %96 = arith.index_cast %94 : i32 to index
              %97 = arith.muli %44, %96 : index
              %98 = arith.addi %46, %97 : index
              %99 = arith.muli %42, %96 : index
              %100 = arith.index_cast %95 : i32 to index
              %101 = arith.muli %99, %100 : index
              %102 = arith.addi %98, %101 : index
              memref.store %cst_0, %arg2[%102] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


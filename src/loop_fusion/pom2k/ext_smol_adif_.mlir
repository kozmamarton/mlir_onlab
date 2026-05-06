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
          %41 = arith.muli %arg11, %8 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = memref.load %arg5[%42] : memref<?xf32>
          %44 = arith.muli %arg10, %8 overflow<nsw> : index
          %45 = arith.muli %44, %7 overflow<nsw> : index
          %46 = arith.addi %42, %45 : index
          %47 = memref.load %arg3[%46] : memref<?xf32>
          %48 = arith.mulf %47, %43 : f32
          memref.store %48, %arg3[%46] : memref<?xf32>
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
      scf.for %arg11 = %c1 to %17 step %c1 {
        scf.for %arg12 = %c1 to %18 step %c1 {
          %41 = arith.muli %arg11, %18 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = arith.muli %arg10, %18 overflow<nsw> : index
          %44 = arith.muli %43, %19 overflow<nsw> : index
          %45 = arith.addi %42, %44 : index
          %46 = memref.load %arg3[%45] : memref<?xf32>
          %47 = arith.cmpf olt, %46, %cst_2 : f32
          %48 = scf.if %47 -> (i1) {
            scf.yield %true : i1
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.addi %arg12, %c-1 : index
            %52 = arith.index_cast %49 : i32 to index
            %53 = arith.muli %arg11, %52 : index
            %54 = arith.addi %51, %53 : index
            %55 = arith.muli %arg10, %52 : index
            %56 = arith.index_cast %50 : i32 to index
            %57 = arith.muli %55, %56 : index
            %58 = arith.addi %54, %57 : index
            %59 = memref.load %arg3[%58] : memref<?xf32>
            %60 = arith.cmpf olt, %59, %cst_2 : f32
            scf.yield %60 : i1
          }
          scf.if %48 {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            memref.store %cst_0, %arg0[%57] : memref<?xf32>
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg0[%57] : memref<?xf32>
            %59 = arith.extf %58 : f32 to f64
            %60 = math.absf %59 : f64
            %61 = arith.truncf %60 : f64 to f32
            %62 = memref.get_global @dti2 : memref<1xf32>
            %63 = memref.load %62[%c0] : memref<1xf32>
            %64 = arith.mulf %63, %58 : f32
            %65 = arith.mulf %64, %58 : f32
            %66 = arith.mulf %65, %cst : f32
            %67 = memref.load %arg6[%53] : memref<?xf32>
            %68 = arith.addi %arg12, %c-1 : index
            %69 = arith.addi %68, %52 : index
            %70 = memref.load %arg8[%69] : memref<?xf32>
            %71 = memref.load %arg8[%53] : memref<?xf32>
            %72 = arith.addf %70, %71 : f32
            %73 = arith.mulf %67, %72 : f32
            %74 = arith.divf %66, %73 : f32
            %75 = memref.load %arg3[%57] : memref<?xf32>
            %76 = arith.addi %69, %56 : index
            %77 = memref.load %arg3[%76] : memref<?xf32>
            %78 = arith.subf %75, %77 : f32
            %79 = arith.addf %77, %75 : f32
            %80 = arith.addf %79, %cst_1 : f32
            %81 = arith.divf %78, %80 : f32
            %82 = arith.subf %61, %74 : f32
            %83 = arith.mulf %82, %81 : f32
            %84 = arith.mulf %83, %16 : f32
            memref.store %84, %arg0[%57] : memref<?xf32>
            %85 = arith.extf %61 : f32 to f64
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
              memref.store %cst_0, %arg0[%98] : memref<?xf32>
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
      scf.for %arg11 = %c1 to %27 step %c1 {
        scf.for %arg12 = %c1 to %28 step %c1 {
          %41 = arith.muli %arg11, %29 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = arith.muli %arg10, %29 overflow<nsw> : index
          %44 = arith.muli %43, %27 overflow<nsw> : index
          %45 = arith.addi %42, %44 : index
          %46 = memref.load %arg3[%45] : memref<?xf32>
          %47 = arith.cmpf olt, %46, %cst_2 : f32
          %48 = scf.if %47 -> (i1) {
            scf.yield %true : i1
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.addi %arg11, %c-1 : index
            %52 = arith.index_cast %49 : i32 to index
            %53 = arith.muli %51, %52 : index
            %54 = arith.addi %arg12, %53 : index
            %55 = arith.muli %arg10, %52 : index
            %56 = arith.index_cast %50 : i32 to index
            %57 = arith.muli %55, %56 : index
            %58 = arith.addi %54, %57 : index
            %59 = memref.load %arg3[%58] : memref<?xf32>
            %60 = arith.cmpf olt, %59, %cst_2 : f32
            scf.yield %60 : i1
          }
          scf.if %48 {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            memref.store %cst_0, %arg1[%57] : memref<?xf32>
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg1[%57] : memref<?xf32>
            %59 = arith.extf %58 : f32 to f64
            %60 = math.absf %59 : f64
            %61 = arith.truncf %60 : f64 to f32
            %62 = memref.get_global @dti2 : memref<1xf32>
            %63 = memref.load %62[%c0] : memref<1xf32>
            %64 = arith.mulf %63, %58 : f32
            %65 = arith.mulf %64, %58 : f32
            %66 = arith.mulf %65, %cst : f32
            %67 = memref.load %arg7[%53] : memref<?xf32>
            %68 = arith.addi %arg11, %c-1 : index
            %69 = arith.muli %68, %51 : index
            %70 = arith.addi %arg12, %69 : index
            %71 = memref.load %arg8[%70] : memref<?xf32>
            %72 = memref.load %arg8[%53] : memref<?xf32>
            %73 = arith.addf %71, %72 : f32
            %74 = arith.mulf %67, %73 : f32
            %75 = arith.divf %66, %74 : f32
            %76 = memref.load %arg3[%57] : memref<?xf32>
            %77 = arith.addi %70, %56 : index
            %78 = memref.load %arg3[%77] : memref<?xf32>
            %79 = arith.subf %76, %78 : f32
            %80 = arith.addf %78, %76 : f32
            %81 = arith.addf %80, %cst_1 : f32
            %82 = arith.divf %79, %81 : f32
            %83 = arith.subf %61, %75 : f32
            %84 = arith.mulf %83, %82 : f32
            %85 = arith.mulf %84, %26 : f32
            memref.store %85, %arg1[%57] : memref<?xf32>
            %86 = arith.extf %61 : f32 to f64
            %87 = math.absf %86 : f64
            %88 = arith.extf %75 : f32 to f64
            %89 = math.absf %88 : f64
            %90 = arith.cmpf olt, %87, %89 : f64
            scf.if %90 {
              %91 = memref.load %4[%c0] : memref<1xi32>
              %92 = memref.load %3[%c0] : memref<1xi32>
              %93 = arith.index_cast %91 : i32 to index
              %94 = arith.muli %arg11, %93 : index
              %95 = arith.addi %arg12, %94 : index
              %96 = arith.muli %arg10, %93 : index
              %97 = arith.index_cast %92 : i32 to index
              %98 = arith.muli %96, %97 : index
              %99 = arith.addi %95, %98 : index
              memref.store %cst_0, %arg1[%99] : memref<?xf32>
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
    scf.for %arg10 = %c1 to %31 step %c1 {
      scf.for %arg11 = %c1 to %37 step %c1 {
        scf.for %arg12 = %c1 to %38 step %c1 {
          %41 = arith.muli %arg11, %39 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = arith.muli %arg10, %39 overflow<nsw> : index
          %44 = arith.muli %43, %40 overflow<nsw> : index
          %45 = arith.addi %42, %44 : index
          %46 = memref.load %arg3[%45] : memref<?xf32>
          %47 = arith.cmpf olt, %46, %cst_2 : f32
          %48 = scf.if %47 -> (i1) {
            scf.yield %true : i1
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.addi %arg10, %c-1 : index
            %55 = arith.muli %54, %51 : index
            %56 = arith.index_cast %50 : i32 to index
            %57 = arith.muli %55, %56 : index
            %58 = arith.addi %53, %57 : index
            %59 = memref.load %arg3[%58] : memref<?xf32>
            %60 = arith.cmpf olt, %59, %cst_2 : f32
            scf.yield %60 : i1
          }
          scf.if %48 {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            memref.store %cst_0, %arg2[%57] : memref<?xf32>
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg2[%57] : memref<?xf32>
            %59 = arith.extf %58 : f32 to f64
            %60 = math.absf %59 : f64
            %61 = arith.truncf %60 : f64 to f32
            %62 = memref.get_global @dti2 : memref<1xf32>
            %63 = memref.load %62[%c0] : memref<1xf32>
            %64 = arith.mulf %63, %58 : f32
            %65 = arith.mulf %64, %58 : f32
            %66 = arith.addi %arg10, %c-1 : index
            %67 = memref.load %arg9[%66] : memref<?xf32>
            %68 = memref.load %arg8[%53] : memref<?xf32>
            %69 = arith.mulf %67, %68 : f32
            %70 = arith.divf %65, %69 : f32
            %71 = arith.muli %66, %51 : index
            %72 = arith.muli %71, %55 : index
            %73 = arith.addi %53, %72 : index
            %74 = memref.load %arg3[%73] : memref<?xf32>
            %75 = memref.load %arg3[%57] : memref<?xf32>
            %76 = arith.subf %74, %75 : f32
            %77 = arith.addf %75, %74 : f32
            %78 = arith.addf %77, %cst_1 : f32
            %79 = arith.divf %76, %78 : f32
            %80 = arith.subf %61, %70 : f32
            %81 = arith.mulf %80, %79 : f32
            %82 = arith.mulf %81, %36 : f32
            memref.store %82, %arg2[%57] : memref<?xf32>
            %83 = arith.extf %61 : f32 to f64
            %84 = math.absf %83 : f64
            %85 = arith.extf %70 : f32 to f64
            %86 = math.absf %85 : f64
            %87 = arith.cmpf olt, %84, %86 : f64
            scf.if %87 {
              %88 = memref.load %4[%c0] : memref<1xi32>
              %89 = memref.load %3[%c0] : memref<1xi32>
              %90 = arith.index_cast %88 : i32 to index
              %91 = arith.muli %arg11, %90 : index
              %92 = arith.addi %arg12, %91 : index
              %93 = arith.muli %arg10, %90 : index
              %94 = arith.index_cast %89 : i32 to index
              %95 = arith.muli %93, %94 : index
              %96 = arith.addi %92, %95 : index
              memref.store %cst_0, %arg2[%96] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


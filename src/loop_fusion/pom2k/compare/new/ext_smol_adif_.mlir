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
      %22 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %23 = memref.load %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %24 = arith.mulf %23, %22 : f32
      memref.store %24, %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %10 = memref.get_global @kbm1 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @jmm1 : memref<1xi32>
    %14 = memref.load %13[%c0] : memref<1xi32>
    %15 = memref.load %arg4[%c0] : memref<?xf32>
    %16 = arith.index_cast %14 : i32 to index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%12, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %17 = memref.get_global @imm1 : memref<1xi32>
    %18 = memref.load %17[%c0] : memref<1xi32>
    %19 = arith.index_cast %18 : i32 to index
    %20 = arith.maxsi %7, %16 : index
    %21 = arith.maxsi %19, %8 : index
    scf.for %arg10 = %c0 to %12 step %c1 {
      scf.for %arg11 = %c1 to %20 step %c1 {
        scf.for %arg12 = %c1 to %21 step %c1 {
          %22 = arith.subi %16, %arg11 : index
          %23 = arith.addi %22, %c-1 : index
          %24 = arith.cmpi sge, %23, %c0 : index
          %25 = arith.subi %8, %arg12 : index
          %26 = arith.addi %25, %c-1 : index
          %27 = arith.cmpi sge, %26, %c0 : index
          %28 = arith.andi %24, %27 : i1
          scf.if %28 {
            %36 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %37 = arith.cmpf olt, %36, %cst_2 : f32
            %38 = scf.if %37 -> (i1) {
              scf.yield %true : i1
            } else {
              %39 = arith.addi %arg12, %c-1 : index
              %40 = arith.muli %arg11, %8 : index
              %41 = arith.addi %39, %40 : index
              %42 = arith.muli %arg10, %8 : index
              %43 = arith.muli %42, %7 : index
              %44 = arith.addi %41, %43 : index
              %45 = memref.load %arg3[%44] : memref<?xf32>
              %46 = arith.cmpf olt, %45, %cst_2 : f32
              scf.yield %46 : i1
            }
            scf.if %38 {
              %39 = arith.muli %arg11, %8 : index
              %40 = arith.addi %arg12, %39 : index
              %41 = arith.muli %arg10, %8 : index
              %42 = arith.muli %41, %7 : index
              %43 = arith.addi %40, %42 : index
              memref.store %cst_0, %arg0[%43] : memref<?xf32>
            } else {
              %39 = arith.muli %arg11, %8 : index
              %40 = arith.addi %arg12, %39 : index
              %41 = arith.muli %arg10, %8 : index
              %42 = arith.muli %41, %7 : index
              %43 = arith.addi %40, %42 : index
              %44 = memref.load %arg0[%43] : memref<?xf32>
              %45 = arith.extf %44 : f32 to f64
              %46 = math.absf %45 : f64
              %47 = arith.truncf %46 : f64 to f32
              %48 = memref.get_global @dti2 : memref<1xf32>
              %49 = memref.load %48[%c0] : memref<1xf32>
              %50 = arith.mulf %49, %44 : f32
              %51 = arith.mulf %50, %44 : f32
              %52 = arith.mulf %51, %cst : f32
              %53 = memref.load %arg6[%40] : memref<?xf32>
              %54 = arith.addi %arg12, %c-1 : index
              %55 = arith.addi %54, %39 : index
              %56 = memref.load %arg8[%55] : memref<?xf32>
              %57 = memref.load %arg8[%40] : memref<?xf32>
              %58 = arith.addf %56, %57 : f32
              %59 = arith.mulf %53, %58 : f32
              %60 = arith.divf %52, %59 : f32
              %61 = memref.load %arg3[%43] : memref<?xf32>
              %62 = arith.addi %55, %42 : index
              %63 = memref.load %arg3[%62] : memref<?xf32>
              %64 = arith.subf %61, %63 : f32
              %65 = arith.addf %63, %61 : f32
              %66 = arith.addf %65, %cst_1 : f32
              %67 = arith.divf %64, %66 : f32
              %68 = arith.subf %47, %60 : f32
              %69 = arith.mulf %68, %67 : f32
              %70 = arith.mulf %69, %15 : f32
              memref.store %70, %arg0[%43] : memref<?xf32>
              %71 = arith.extf %47 : f32 to f64
              %72 = math.absf %71 : f64
              %73 = arith.extf %60 : f32 to f64
              %74 = math.absf %73 : f64
              %75 = arith.cmpf olt, %72, %74 : f64
              scf.if %75 {
                memref.store %cst_0, %arg0[%43] : memref<?xf32>
              }
            }
          }
          %29 = arith.subi %7, %arg11 : index
          %30 = arith.addi %29, %c-1 : index
          %31 = arith.cmpi sge, %30, %c0 : index
          %32 = arith.subi %19, %arg12 : index
          %33 = arith.addi %32, %c-1 : index
          %34 = arith.cmpi sge, %33, %c0 : index
          %35 = arith.andi %31, %34 : i1
          scf.if %35 {
            %36 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
            %37 = arith.cmpf olt, %36, %cst_2 : f32
            %38 = scf.if %37 -> (i1) {
              scf.yield %true : i1
            } else {
              %39 = arith.addi %arg11, %c-1 : index
              %40 = arith.muli %39, %8 : index
              %41 = arith.addi %arg12, %40 : index
              %42 = arith.muli %arg10, %8 : index
              %43 = arith.muli %42, %7 : index
              %44 = arith.addi %41, %43 : index
              %45 = memref.load %arg3[%44] : memref<?xf32>
              %46 = arith.cmpf olt, %45, %cst_2 : f32
              scf.yield %46 : i1
            }
            scf.if %38 {
              %39 = arith.muli %arg11, %8 : index
              %40 = arith.addi %arg12, %39 : index
              %41 = arith.muli %arg10, %8 : index
              %42 = arith.muli %41, %7 : index
              %43 = arith.addi %40, %42 : index
              memref.store %cst_0, %arg1[%43] : memref<?xf32>
            } else {
              %39 = arith.muli %arg11, %8 : index
              %40 = arith.addi %arg12, %39 : index
              %41 = arith.muli %arg10, %8 : index
              %42 = arith.muli %41, %7 : index
              %43 = arith.addi %40, %42 : index
              %44 = memref.load %arg1[%43] : memref<?xf32>
              %45 = arith.extf %44 : f32 to f64
              %46 = math.absf %45 : f64
              %47 = arith.truncf %46 : f64 to f32
              %48 = memref.get_global @dti2 : memref<1xf32>
              %49 = memref.load %48[%c0] : memref<1xf32>
              %50 = arith.mulf %49, %44 : f32
              %51 = arith.mulf %50, %44 : f32
              %52 = arith.mulf %51, %cst : f32
              %53 = memref.load %arg7[%40] : memref<?xf32>
              %54 = arith.addi %arg11, %c-1 : index
              %55 = arith.muli %54, %8 : index
              %56 = arith.addi %arg12, %55 : index
              %57 = memref.load %arg8[%56] : memref<?xf32>
              %58 = memref.load %arg8[%40] : memref<?xf32>
              %59 = arith.addf %57, %58 : f32
              %60 = arith.mulf %53, %59 : f32
              %61 = arith.divf %52, %60 : f32
              %62 = memref.load %arg3[%43] : memref<?xf32>
              %63 = arith.addi %56, %42 : index
              %64 = memref.load %arg3[%63] : memref<?xf32>
              %65 = arith.subf %62, %64 : f32
              %66 = arith.addf %64, %62 : f32
              %67 = arith.addf %66, %cst_1 : f32
              %68 = arith.divf %65, %67 : f32
              %69 = arith.subf %47, %61 : f32
              %70 = arith.mulf %69, %68 : f32
              %71 = arith.mulf %70, %15 : f32
              memref.store %71, %arg1[%43] : memref<?xf32>
              %72 = arith.extf %47 : f32 to f64
              %73 = math.absf %72 : f64
              %74 = arith.extf %61 : f32 to f64
              %75 = math.absf %74 : f64
              %76 = arith.cmpf olt, %73, %75 : f64
              scf.if %76 {
                memref.store %cst_0, %arg1[%43] : memref<?xf32>
              }
            }
          }
        }
      }
    }
    scf.for %arg10 = %c1 to %12 step %c1 {
      scf.for %arg11 = %c1 to %16 step %c1 {
        scf.for %arg12 = %c1 to %19 step %c1 {
          %22 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %23 = arith.cmpf olt, %22, %cst_2 : f32
          %24 = scf.if %23 -> (i1) {
            scf.yield %true : i1
          } else {
            %25 = arith.muli %arg11, %8 : index
            %26 = arith.addi %arg12, %25 : index
            %27 = arith.addi %arg10, %c-1 : index
            %28 = arith.muli %27, %8 : index
            %29 = arith.muli %28, %7 : index
            %30 = arith.addi %26, %29 : index
            %31 = memref.load %arg3[%30] : memref<?xf32>
            %32 = arith.cmpf olt, %31, %cst_2 : f32
            scf.yield %32 : i1
          }
          scf.if %24 {
            %25 = arith.muli %arg11, %8 : index
            %26 = arith.addi %arg12, %25 : index
            %27 = arith.muli %arg10, %8 : index
            %28 = arith.muli %27, %7 : index
            %29 = arith.addi %26, %28 : index
            memref.store %cst_0, %arg2[%29] : memref<?xf32>
          } else {
            %25 = arith.muli %arg11, %8 : index
            %26 = arith.addi %arg12, %25 : index
            %27 = arith.muli %arg10, %8 : index
            %28 = arith.muli %27, %7 : index
            %29 = arith.addi %26, %28 : index
            %30 = memref.load %arg2[%29] : memref<?xf32>
            %31 = arith.extf %30 : f32 to f64
            %32 = math.absf %31 : f64
            %33 = arith.truncf %32 : f64 to f32
            %34 = memref.get_global @dti2 : memref<1xf32>
            %35 = memref.load %34[%c0] : memref<1xf32>
            %36 = arith.mulf %35, %30 : f32
            %37 = arith.mulf %36, %30 : f32
            %38 = arith.addi %arg10, %c-1 : index
            %39 = memref.load %arg9[%38] : memref<?xf32>
            %40 = memref.load %arg8[%26] : memref<?xf32>
            %41 = arith.mulf %39, %40 : f32
            %42 = arith.divf %37, %41 : f32
            %43 = arith.muli %38, %8 : index
            %44 = arith.muli %43, %7 : index
            %45 = arith.addi %26, %44 : index
            %46 = memref.load %arg3[%45] : memref<?xf32>
            %47 = memref.load %arg3[%29] : memref<?xf32>
            %48 = arith.subf %46, %47 : f32
            %49 = arith.addf %47, %46 : f32
            %50 = arith.addf %49, %cst_1 : f32
            %51 = arith.divf %48, %50 : f32
            %52 = arith.subf %33, %42 : f32
            %53 = arith.mulf %52, %51 : f32
            %54 = arith.mulf %53, %15 : f32
            memref.store %54, %arg2[%29] : memref<?xf32>
            %55 = arith.extf %33 : f32 to f64
            %56 = math.absf %55 : f64
            %57 = arith.extf %42 : f32 to f64
            %58 = math.absf %57 : f64
            %59 = arith.cmpf olt, %56, %58 : f64
            scf.if %59 {
              memref.store %cst_0, %arg2[%29] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


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
      %20 = memref.load %reinterpret_cast_3[%arg11, %arg12] : memref<?x?xf32, strided<[?, 1]>>
      %21 = memref.load %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %22 = arith.mulf %21, %20 : f32
      memref.store %22, %reinterpret_cast[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
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
    scf.for %arg10 = %c0 to %12 step %c1 {
      scf.for %arg11 = %c1 to %16 step %c1 {
        scf.for %arg12 = %c1 to %8 step %c1 {
          %20 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %21 = arith.cmpf olt, %20, %cst_2 : f32
          %22 = scf.if %21 -> (i1) {
            scf.yield %true : i1
          } else {
            %23 = arith.addi %arg12, %c-1 : index
            %24 = arith.muli %arg11, %8 : index
            %25 = arith.addi %23, %24 : index
            %26 = arith.muli %arg10, %8 : index
            %27 = arith.muli %26, %7 : index
            %28 = arith.addi %25, %27 : index
            %29 = memref.load %arg3[%28] : memref<?xf32>
            %30 = arith.cmpf olt, %29, %cst_2 : f32
            scf.yield %30 : i1
          }
          scf.if %22 {
            %23 = arith.muli %arg11, %8 : index
            %24 = arith.addi %arg12, %23 : index
            %25 = arith.muli %arg10, %8 : index
            %26 = arith.muli %25, %7 : index
            %27 = arith.addi %24, %26 : index
            memref.store %cst_0, %arg0[%27] : memref<?xf32>
          } else {
            %23 = arith.muli %arg11, %8 : index
            %24 = arith.addi %arg12, %23 : index
            %25 = arith.muli %arg10, %8 : index
            %26 = arith.muli %25, %7 : index
            %27 = arith.addi %24, %26 : index
            %28 = memref.load %arg0[%27] : memref<?xf32>
            %29 = arith.extf %28 : f32 to f64
            %30 = math.absf %29 : f64
            %31 = arith.truncf %30 : f64 to f32
            %32 = memref.get_global @dti2 : memref<1xf32>
            %33 = memref.load %32[%c0] : memref<1xf32>
            %34 = arith.mulf %33, %28 : f32
            %35 = arith.mulf %34, %28 : f32
            %36 = arith.mulf %35, %cst : f32
            %37 = memref.load %arg6[%24] : memref<?xf32>
            %38 = arith.addi %arg12, %c-1 : index
            %39 = arith.addi %38, %23 : index
            %40 = memref.load %arg8[%39] : memref<?xf32>
            %41 = memref.load %arg8[%24] : memref<?xf32>
            %42 = arith.addf %40, %41 : f32
            %43 = arith.mulf %37, %42 : f32
            %44 = arith.divf %36, %43 : f32
            %45 = memref.load %arg3[%27] : memref<?xf32>
            %46 = arith.addi %39, %26 : index
            %47 = memref.load %arg3[%46] : memref<?xf32>
            %48 = arith.subf %45, %47 : f32
            %49 = arith.addf %47, %45 : f32
            %50 = arith.addf %49, %cst_1 : f32
            %51 = arith.divf %48, %50 : f32
            %52 = arith.subf %31, %44 : f32
            %53 = arith.mulf %52, %51 : f32
            %54 = arith.mulf %53, %15 : f32
            memref.store %54, %arg0[%27] : memref<?xf32>
            %55 = arith.extf %31 : f32 to f64
            %56 = math.absf %55 : f64
            %57 = arith.extf %44 : f32 to f64
            %58 = math.absf %57 : f64
            %59 = arith.cmpf olt, %56, %58 : f64
            scf.if %59 {
              memref.store %cst_0, %arg0[%27] : memref<?xf32>
            }
          }
        }
      }
    }
    %17 = memref.get_global @imm1 : memref<1xi32>
    %18 = memref.load %17[%c0] : memref<1xi32>
    %19 = arith.index_cast %18 : i32 to index
    scf.for %arg10 = %c0 to %12 step %c1 {
      scf.for %arg11 = %c1 to %7 step %c1 {
        scf.for %arg12 = %c1 to %19 step %c1 {
          %20 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %21 = arith.cmpf olt, %20, %cst_2 : f32
          %22 = scf.if %21 -> (i1) {
            scf.yield %true : i1
          } else {
            %23 = arith.addi %arg11, %c-1 : index
            %24 = arith.muli %23, %8 : index
            %25 = arith.addi %arg12, %24 : index
            %26 = arith.muli %arg10, %8 : index
            %27 = arith.muli %26, %7 : index
            %28 = arith.addi %25, %27 : index
            %29 = memref.load %arg3[%28] : memref<?xf32>
            %30 = arith.cmpf olt, %29, %cst_2 : f32
            scf.yield %30 : i1
          }
          scf.if %22 {
            %23 = arith.muli %arg11, %8 : index
            %24 = arith.addi %arg12, %23 : index
            %25 = arith.muli %arg10, %8 : index
            %26 = arith.muli %25, %7 : index
            %27 = arith.addi %24, %26 : index
            memref.store %cst_0, %arg1[%27] : memref<?xf32>
          } else {
            %23 = arith.muli %arg11, %8 : index
            %24 = arith.addi %arg12, %23 : index
            %25 = arith.muli %arg10, %8 : index
            %26 = arith.muli %25, %7 : index
            %27 = arith.addi %24, %26 : index
            %28 = memref.load %arg1[%27] : memref<?xf32>
            %29 = arith.extf %28 : f32 to f64
            %30 = math.absf %29 : f64
            %31 = arith.truncf %30 : f64 to f32
            %32 = memref.get_global @dti2 : memref<1xf32>
            %33 = memref.load %32[%c0] : memref<1xf32>
            %34 = arith.mulf %33, %28 : f32
            %35 = arith.mulf %34, %28 : f32
            %36 = arith.mulf %35, %cst : f32
            %37 = memref.load %arg7[%24] : memref<?xf32>
            %38 = arith.addi %arg11, %c-1 : index
            %39 = arith.muli %38, %8 : index
            %40 = arith.addi %arg12, %39 : index
            %41 = memref.load %arg8[%40] : memref<?xf32>
            %42 = memref.load %arg8[%24] : memref<?xf32>
            %43 = arith.addf %41, %42 : f32
            %44 = arith.mulf %37, %43 : f32
            %45 = arith.divf %36, %44 : f32
            %46 = memref.load %arg3[%27] : memref<?xf32>
            %47 = arith.addi %40, %26 : index
            %48 = memref.load %arg3[%47] : memref<?xf32>
            %49 = arith.subf %46, %48 : f32
            %50 = arith.addf %48, %46 : f32
            %51 = arith.addf %50, %cst_1 : f32
            %52 = arith.divf %49, %51 : f32
            %53 = arith.subf %31, %45 : f32
            %54 = arith.mulf %53, %52 : f32
            %55 = arith.mulf %54, %15 : f32
            memref.store %55, %arg1[%27] : memref<?xf32>
            %56 = arith.extf %31 : f32 to f64
            %57 = math.absf %56 : f64
            %58 = arith.extf %45 : f32 to f64
            %59 = math.absf %58 : f64
            %60 = arith.cmpf olt, %57, %59 : f64
            scf.if %60 {
              memref.store %cst_0, %arg1[%27] : memref<?xf32>
            }
          }
        }
      }
    }
    scf.for %arg10 = %c1 to %12 step %c1 {
      scf.for %arg11 = %c1 to %16 step %c1 {
        scf.for %arg12 = %c1 to %19 step %c1 {
          %20 = memref.load %reinterpret_cast_4[%arg10, %arg11, %arg12] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %21 = arith.cmpf olt, %20, %cst_2 : f32
          %22 = scf.if %21 -> (i1) {
            scf.yield %true : i1
          } else {
            %23 = arith.muli %arg11, %8 : index
            %24 = arith.addi %arg12, %23 : index
            %25 = arith.addi %arg10, %c-1 : index
            %26 = arith.muli %25, %8 : index
            %27 = arith.muli %26, %7 : index
            %28 = arith.addi %24, %27 : index
            %29 = memref.load %arg3[%28] : memref<?xf32>
            %30 = arith.cmpf olt, %29, %cst_2 : f32
            scf.yield %30 : i1
          }
          scf.if %22 {
            %23 = arith.muli %arg11, %8 : index
            %24 = arith.addi %arg12, %23 : index
            %25 = arith.muli %arg10, %8 : index
            %26 = arith.muli %25, %7 : index
            %27 = arith.addi %24, %26 : index
            memref.store %cst_0, %arg2[%27] : memref<?xf32>
          } else {
            %23 = arith.muli %arg11, %8 : index
            %24 = arith.addi %arg12, %23 : index
            %25 = arith.muli %arg10, %8 : index
            %26 = arith.muli %25, %7 : index
            %27 = arith.addi %24, %26 : index
            %28 = memref.load %arg2[%27] : memref<?xf32>
            %29 = arith.extf %28 : f32 to f64
            %30 = math.absf %29 : f64
            %31 = arith.truncf %30 : f64 to f32
            %32 = memref.get_global @dti2 : memref<1xf32>
            %33 = memref.load %32[%c0] : memref<1xf32>
            %34 = arith.mulf %33, %28 : f32
            %35 = arith.mulf %34, %28 : f32
            %36 = arith.addi %arg10, %c-1 : index
            %37 = memref.load %arg9[%36] : memref<?xf32>
            %38 = memref.load %arg8[%24] : memref<?xf32>
            %39 = arith.mulf %37, %38 : f32
            %40 = arith.divf %35, %39 : f32
            %41 = arith.muli %36, %8 : index
            %42 = arith.muli %41, %7 : index
            %43 = arith.addi %24, %42 : index
            %44 = memref.load %arg3[%43] : memref<?xf32>
            %45 = memref.load %arg3[%27] : memref<?xf32>
            %46 = arith.subf %44, %45 : f32
            %47 = arith.addf %45, %44 : f32
            %48 = arith.addf %47, %cst_1 : f32
            %49 = arith.divf %46, %48 : f32
            %50 = arith.subf %31, %40 : f32
            %51 = arith.mulf %50, %49 : f32
            %52 = arith.mulf %51, %15 : f32
            memref.store %52, %arg2[%27] : memref<?xf32>
            %53 = arith.extf %31 : f32 to f64
            %54 = math.absf %53 : f64
            %55 = arith.extf %40 : f32 to f64
            %56 = math.absf %55 : f64
            %57 = arith.cmpf olt, %54, %56 : f64
            scf.if %57 {
              memref.store %cst_0, %arg2[%27] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


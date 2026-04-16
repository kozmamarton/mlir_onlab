module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @rhoref : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_dens_(%arg0: memref<?xf32> {polygeist.name = "si", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ti", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "rhoo", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "zz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "tbias", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "sbias", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %cst_1 = arith.constant 1.000000e+05 : f32
    %cst_2 = arith.constant 3.500000e+01 : f32
    %cst_3 = arith.constant 1.340000e+00 : f32
    %cst_4 = arith.constant 4.500000e-02 : f32
    %cst_5 = arith.constant 4.550000e+00 : f32
    %cst_6 = arith.constant 0.0820999965 : f32
    %cst_7 = arith.constant 1.449100e+03 : f32
    %cst_8 = arith.constant 4.831400e-04 : f32
    %cst_9 = arith.constant 1.500000e+00 : f32
    %cst_10 = arith.constant 1.654600e-06 : f32
    %cst_11 = arith.constant 1.022700e-04 : f32
    %cst_12 = arith.constant -5.724660e-03 : f32
    %cst_13 = arith.constant 5.387500e-09 : f32
    %cst_14 = arith.constant 8.24669996E-7 : f32
    %cst_15 = arith.constant 7.643800e-05 : f32
    %cst_16 = arith.constant 4.089900e-03 : f32
    %cst_17 = arith.constant 0.82449299 : f32
    %cst_18 = arith.constant 6.53633192E-9 : f32
    %cst_19 = arith.constant 1.12008297E-6 : f32
    %cst_20 = arith.constant 1.00168501E-4 : f32
    %cst_21 = arith.constant 9.095290e-03 : f32
    %cst_22 = arith.constant 0.0679395198 : f32
    %cst_23 = arith.constant -1.574060e-01 : f32
    %cst_24 = arith.constant 9.99999974E-6 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @rhoref : memref<1xf32>
    %7 = memref.load %3[%c0] : memref<1xi32>
    %8 = memref.load %4[%c0] : memref<1xi32>
    %9 = memref.load %arg6[%c0] : memref<?xf32>
    %10 = memref.load %arg7[%c0] : memref<?xf32>
    %11 = memref.load %5[%c0] : memref<1xf32>
    %12 = memref.load %6[%c0] : memref<1xf32>
    %13 = arith.index_cast %7 : i32 to index
    %14 = arith.index_cast %8 : i32 to index
    %15 = arith.mulf %11, %12 : f32
    scf.for %arg8 = %c0 to %2 step %c1 {
      %16 = memref.load %arg5[%arg8] : memref<?xf32>
      %17 = arith.negf %16 : f32
      scf.for %arg9 = %c0 to %13 step %c1 {
        scf.for %arg10 = %c0 to %14 step %c1 {
          %18 = arith.muli %arg9, %14 overflow<nsw> : index
          %19 = arith.addi %arg10, %18 : index
          %20 = arith.muli %arg8, %14 overflow<nsw> : index
          %21 = arith.muli %20, %13 overflow<nsw> : index
          %22 = arith.addi %19, %21 : index
          %23 = memref.load %arg1[%22] : memref<?xf32>
          %24 = arith.addf %23, %9 : f32
          %25 = memref.load %arg0[%22] : memref<?xf32>
          %26 = arith.addf %25, %10 : f32
          %27 = arith.mulf %24, %24 : f32
          %28 = arith.mulf %27, %24 : f32
          %29 = arith.mulf %28, %24 : f32
          %30 = memref.load %arg3[%19] : memref<?xf32>
          %31 = arith.mulf %17, %30 : f32
          %32 = arith.mulf %15, %31 : f32
          %33 = arith.mulf %32, %cst_24 : f32
          %34 = arith.mulf %24, %cst_22 : f32
          %35 = arith.addf %34, %cst_23 : f32
          %36 = arith.mulf %27, %cst_21 : f32
          %37 = arith.subf %35, %36 : f32
          %38 = arith.mulf %28, %cst_20 : f32
          %39 = arith.addf %37, %38 : f32
          %40 = arith.mulf %29, %cst_19 : f32
          %41 = arith.subf %39, %40 : f32
          %42 = arith.mulf %29, %cst_18 : f32
          %43 = arith.mulf %42, %24 : f32
          %44 = arith.addf %41, %43 : f32
          %45 = arith.mulf %24, %cst_16 : f32
          %46 = arith.subf %cst_17, %45 : f32
          %47 = arith.mulf %27, %cst_15 : f32
          %48 = arith.addf %46, %47 : f32
          %49 = arith.mulf %28, %cst_14 : f32
          %50 = arith.subf %48, %49 : f32
          %51 = arith.mulf %29, %cst_13 : f32
          %52 = arith.addf %50, %51 : f32
          %53 = arith.mulf %52, %26 : f32
          %54 = arith.addf %44, %53 : f32
          %55 = arith.mulf %24, %cst_11 : f32
          %56 = arith.addf %55, %cst_12 : f32
          %57 = arith.mulf %27, %cst_10 : f32
          %58 = arith.subf %56, %57 : f32
          %59 = arith.extf %26 : f32 to f64
          %60 = math.absf %59 : f64
          %61 = arith.truncf %60 : f64 to f32
          %62 = math.powf %61, %cst_9 : f32
          %63 = arith.mulf %58, %62 : f32
          %64 = arith.addf %54, %63 : f32
          %65 = arith.mulf %26, %cst_8 : f32
          %66 = arith.mulf %65, %26 : f32
          %67 = arith.addf %64, %66 : f32
          %68 = arith.mulf %33, %cst_6 : f32
          %69 = arith.addf %68, %cst_7 : f32
          %70 = arith.mulf %24, %cst_5 : f32
          %71 = arith.addf %69, %70 : f32
          %72 = arith.mulf %27, %cst_4 : f32
          %73 = arith.subf %71, %72 : f32
          %74 = arith.subf %26, %cst_2 : f32
          %75 = arith.mulf %74, %cst_3 : f32
          %76 = arith.addf %73, %75 : f32
          %77 = arith.mulf %33, %cst_1 : f32
          %78 = arith.mulf %76, %76 : f32
          %79 = arith.divf %77, %78 : f32
          %80 = arith.mulf %33, %cst : f32
          %81 = arith.divf %80, %78 : f32
          %82 = arith.subf %cst_0, %81 : f32
          %83 = arith.mulf %79, %82 : f32
          %84 = arith.addf %67, %83 : f32
          %85 = arith.divf %84, %12 : f32
          %86 = memref.load %arg4[%19] : memref<?xf32>
          %87 = arith.mulf %85, %86 : f32
          memref.store %87, %arg2[%22] : memref<?xf32>
        }
      }
    }
    return
  }
}


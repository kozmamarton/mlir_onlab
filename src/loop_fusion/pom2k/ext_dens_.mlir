module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @rhoref : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_dens_(%arg0: memref<?xf32> {polygeist.name = "si", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ti", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "rhoo", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "zz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "tbias", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "sbias", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
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
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @rhoref : memref<1xf32>
    %7 = affine.load %3[0] : memref<1xi32>
    %8 = affine.load %4[0] : memref<1xi32>
    %9 = affine.load %arg6[0] : memref<?xf32>
    %10 = affine.load %arg7[0] : memref<?xf32>
    %11 = affine.load %5[0] : memref<1xf32>
    %12 = affine.load %6[0] : memref<1xf32>
    %13 = arith.index_cast %7 : i32 to index
    %14 = arith.index_cast %8 : i32 to index
    %15 = arith.mulf %11, %12 : f32
    affine.for %arg8 = 0 to %2 {
      %16 = affine.load %arg5[%arg8] : memref<?xf32>
      %17 = arith.negf %16 : f32
      affine.for %arg9 = 0 to %13 {
        affine.for %arg10 = 0 to %14 {
          %18 = arith.muli %14, %13 : index
          %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %13, %14], strides: [%18, %14, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %19 = affine.load %reinterpret_cast[%arg8, %arg9, %arg10] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %20 = arith.addf %19, %9 : f32
          %reinterpret_cast_25 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %13, %14], strides: [%18, %14, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          %21 = affine.load %reinterpret_cast_25[%arg8, %arg9, %arg10] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %22 = arith.addf %21, %10 : f32
          %23 = arith.mulf %20, %20 : f32
          %24 = arith.mulf %23, %20 : f32
          %25 = arith.mulf %24, %20 : f32
          %reinterpret_cast_26 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%13, %14], strides: [%14, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %26 = affine.load %reinterpret_cast_26[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
          %27 = arith.mulf %17, %26 : f32
          %28 = arith.mulf %15, %27 : f32
          %29 = arith.mulf %28, %cst_24 : f32
          %30 = arith.mulf %20, %cst_22 : f32
          %31 = arith.addf %30, %cst_23 : f32
          %32 = arith.mulf %23, %cst_21 : f32
          %33 = arith.subf %31, %32 : f32
          %34 = arith.mulf %24, %cst_20 : f32
          %35 = arith.addf %33, %34 : f32
          %36 = arith.mulf %25, %cst_19 : f32
          %37 = arith.subf %35, %36 : f32
          %38 = arith.mulf %25, %cst_18 : f32
          %39 = arith.mulf %38, %20 : f32
          %40 = arith.addf %37, %39 : f32
          %41 = arith.mulf %20, %cst_16 : f32
          %42 = arith.subf %cst_17, %41 : f32
          %43 = arith.mulf %23, %cst_15 : f32
          %44 = arith.addf %42, %43 : f32
          %45 = arith.mulf %24, %cst_14 : f32
          %46 = arith.subf %44, %45 : f32
          %47 = arith.mulf %25, %cst_13 : f32
          %48 = arith.addf %46, %47 : f32
          %49 = arith.mulf %48, %22 : f32
          %50 = arith.addf %40, %49 : f32
          %51 = arith.mulf %20, %cst_11 : f32
          %52 = arith.addf %51, %cst_12 : f32
          %53 = arith.mulf %23, %cst_10 : f32
          %54 = arith.subf %52, %53 : f32
          %55 = arith.extf %22 : f32 to f64
          %56 = math.absf %55 : f64
          %57 = arith.truncf %56 : f64 to f32
          %58 = math.powf %57, %cst_9 : f32
          %59 = arith.mulf %54, %58 : f32
          %60 = arith.addf %50, %59 : f32
          %61 = arith.mulf %22, %cst_8 : f32
          %62 = arith.mulf %61, %22 : f32
          %63 = arith.addf %60, %62 : f32
          %64 = arith.mulf %29, %cst_6 : f32
          %65 = arith.addf %64, %cst_7 : f32
          %66 = arith.mulf %20, %cst_5 : f32
          %67 = arith.addf %65, %66 : f32
          %68 = arith.mulf %23, %cst_4 : f32
          %69 = arith.subf %67, %68 : f32
          %70 = arith.subf %22, %cst_2 : f32
          %71 = arith.mulf %70, %cst_3 : f32
          %72 = arith.addf %69, %71 : f32
          %73 = arith.mulf %29, %cst_1 : f32
          %74 = arith.mulf %72, %72 : f32
          %75 = arith.divf %73, %74 : f32
          %76 = arith.mulf %29, %cst : f32
          %77 = arith.divf %76, %74 : f32
          %78 = arith.subf %cst_0, %77 : f32
          %79 = arith.mulf %75, %78 : f32
          %80 = arith.addf %63, %79 : f32
          %81 = arith.divf %80, %12 : f32
          %reinterpret_cast_27 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%13, %14], strides: [%14, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
          %82 = affine.load %reinterpret_cast_27[%arg9, %arg10] : memref<?x?xf32, strided<[?, 1]>>
          %83 = arith.mulf %81, %82 : f32
          %reinterpret_cast_28 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %13, %14], strides: [%18, %14, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
          affine.store %83, %reinterpret_cast_28[%arg8, %arg9, %arg10] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        } {constants = [], locals = [{name = "cr", non_scalar = false, type = "f32"}, {name = "p", non_scalar = false, type = "f32"}, {name = "rhor", non_scalar = false, type = "f32"}, {name = "sr", non_scalar = false, type = "f32"}, {name = "tr", non_scalar = false, type = "f32"}, {name = "tr2", non_scalar = false, type = "f32"}, {name = "tr3", non_scalar = false, type = "f32"}, {name = "tr4", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [{name = "cr", non_scalar = false, type = "f32"}, {name = "p", non_scalar = false, type = "f32"}, {name = "rhor", non_scalar = false, type = "f32"}, {name = "sr", non_scalar = false, type = "f32"}, {name = "tr", non_scalar = false, type = "f32"}, {name = "tr2", non_scalar = false, type = "f32"}, {name = "tr3", non_scalar = false, type = "f32"}, {name = "tr4", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [{name = "cr", non_scalar = false, type = "f32"}, {name = "p", non_scalar = false, type = "f32"}, {name = "rhor", non_scalar = false, type = "f32"}, {name = "sr", non_scalar = false, type = "f32"}, {name = "tr", non_scalar = false, type = "f32"}, {name = "tr2", non_scalar = false, type = "f32"}, {name = "tr3", non_scalar = false, type = "f32"}, {name = "tr4", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}


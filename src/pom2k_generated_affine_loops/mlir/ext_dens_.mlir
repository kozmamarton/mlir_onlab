module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
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
    %0 = memref.alloca() : memref<f32>
    %1 = llvm.mlir.undef : f32
    affine.store %1, %0[] : memref<f32>
    %2 = memref.alloca() : memref<f32>
    affine.store %1, %2[] : memref<f32>
    %3 = memref.alloca() : memref<f32>
    affine.store %1, %3[] : memref<f32>
    %4 = memref.alloca() : memref<f32>
    affine.store %1, %4[] : memref<f32>
    %5 = memref.alloca() : memref<f32>
    affine.store %1, %5[] : memref<f32>
    %6 = memref.alloca() : memref<f32>
    affine.store %1, %6[] : memref<f32>
    %7 = memref.alloca() : memref<f32>
    affine.store %1, %7[] : memref<f32>
    %8 = memref.alloca() : memref<f32>
    affine.store %1, %8[] : memref<f32>
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = affine.load %9[0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @jm : memref<1xi32>
    %13 = memref.get_global @im : memref<1xi32>
    %14 = memref.get_global @grav : memref<1xf32>
    %15 = memref.get_global @rhoref : memref<1xf32>
    %16 = affine.load %12[0] : memref<1xi32>
    %17 = affine.load %13[0] : memref<1xi32>
    %18 = affine.load %arg6[0] : memref<?xf32>
    %19 = affine.load %arg7[0] : memref<?xf32>
    %20 = affine.load %14[0] : memref<1xf32>
    %21 = affine.load %15[0] : memref<1xf32>
    %22 = arith.index_cast %16 : i32 to index
    %23 = arith.index_cast %17 : i32 to index
    %24 = arith.mulf %20, %21 : f32
    affine.for %arg8 = 0 to %11 {
      %25 = affine.load %arg5[%arg8] : memref<?xf32>
      %26 = arith.negf %25 : f32
      affine.for %arg9 = 0 to %22 {
        affine.for %arg10 = 0 to %23 {
          %27 = affine.load %arg1[%arg10 + %arg9 * symbol(%23) + (%arg8 * symbol(%23)) * symbol(%22)] : memref<?xf32>
          %28 = arith.addf %27, %18 : f32
          affine.store %28, %4[] : memref<f32>
          %29 = affine.load %arg0[%arg10 + %arg9 * symbol(%23) + (%arg8 * symbol(%23)) * symbol(%22)] : memref<?xf32>
          %30 = arith.addf %29, %19 : f32
          affine.store %30, %5[] : memref<f32>
          %31 = affine.load %4[] : memref<f32>
          %32 = arith.mulf %31, %31 : f32
          affine.store %32, %3[] : memref<f32>
          %33 = affine.load %3[] : memref<f32>
          %34 = affine.load %4[] : memref<f32>
          %35 = arith.mulf %33, %34 : f32
          affine.store %35, %2[] : memref<f32>
          %36 = affine.load %2[] : memref<f32>
          %37 = affine.load %4[] : memref<f32>
          %38 = arith.mulf %36, %37 : f32
          affine.store %38, %0[] : memref<f32>
          %39 = affine.load %arg3[%arg10 + %arg9 * symbol(%23)] : memref<?xf32>
          %40 = arith.mulf %26, %39 : f32
          %41 = arith.mulf %24, %40 : f32
          %42 = arith.mulf %41, %cst_24 : f32
          affine.store %42, %7[] : memref<f32>
          %43 = affine.load %4[] : memref<f32>
          %44 = arith.mulf %43, %cst_22 : f32
          %45 = arith.addf %44, %cst_23 : f32
          %46 = affine.load %3[] : memref<f32>
          %47 = arith.mulf %46, %cst_21 : f32
          %48 = arith.subf %45, %47 : f32
          %49 = affine.load %2[] : memref<f32>
          %50 = arith.mulf %49, %cst_20 : f32
          %51 = arith.addf %48, %50 : f32
          %52 = affine.load %0[] : memref<f32>
          %53 = arith.mulf %52, %cst_19 : f32
          %54 = arith.subf %51, %53 : f32
          %55 = arith.mulf %52, %cst_18 : f32
          %56 = arith.mulf %55, %43 : f32
          %57 = arith.addf %54, %56 : f32
          affine.store %57, %6[] : memref<f32>
          %58 = affine.load %6[] : memref<f32>
          %59 = affine.load %4[] : memref<f32>
          %60 = arith.mulf %59, %cst_16 : f32
          %61 = arith.subf %cst_17, %60 : f32
          %62 = affine.load %3[] : memref<f32>
          %63 = arith.mulf %62, %cst_15 : f32
          %64 = arith.addf %61, %63 : f32
          %65 = affine.load %2[] : memref<f32>
          %66 = arith.mulf %65, %cst_14 : f32
          %67 = arith.subf %64, %66 : f32
          %68 = affine.load %0[] : memref<f32>
          %69 = arith.mulf %68, %cst_13 : f32
          %70 = arith.addf %67, %69 : f32
          %71 = affine.load %5[] : memref<f32>
          %72 = arith.mulf %70, %71 : f32
          %73 = arith.addf %58, %72 : f32
          %74 = arith.mulf %59, %cst_11 : f32
          %75 = arith.addf %74, %cst_12 : f32
          %76 = arith.mulf %62, %cst_10 : f32
          %77 = arith.subf %75, %76 : f32
          %78 = arith.extf %71 : f32 to f64
          %79 = math.absf %78 : f64
          %80 = arith.truncf %79 : f64 to f32
          %81 = math.powf %80, %cst_9 : f32
          %82 = arith.mulf %77, %81 : f32
          %83 = arith.addf %73, %82 : f32
          %84 = arith.mulf %71, %cst_8 : f32
          %85 = arith.mulf %84, %71 : f32
          %86 = arith.addf %83, %85 : f32
          affine.store %86, %6[] : memref<f32>
          %87 = affine.load %7[] : memref<f32>
          %88 = arith.mulf %87, %cst_6 : f32
          %89 = arith.addf %88, %cst_7 : f32
          %90 = affine.load %4[] : memref<f32>
          %91 = arith.mulf %90, %cst_5 : f32
          %92 = arith.addf %89, %91 : f32
          %93 = affine.load %3[] : memref<f32>
          %94 = arith.mulf %93, %cst_4 : f32
          %95 = arith.subf %92, %94 : f32
          %96 = affine.load %5[] : memref<f32>
          %97 = arith.subf %96, %cst_2 : f32
          %98 = arith.mulf %97, %cst_3 : f32
          %99 = arith.addf %95, %98 : f32
          affine.store %99, %8[] : memref<f32>
          %100 = affine.load %6[] : memref<f32>
          %101 = affine.load %7[] : memref<f32>
          %102 = arith.mulf %101, %cst_1 : f32
          %103 = affine.load %8[] : memref<f32>
          %104 = arith.mulf %103, %103 : f32
          %105 = arith.divf %102, %104 : f32
          %106 = arith.mulf %101, %cst : f32
          %107 = arith.divf %106, %104 : f32
          %108 = arith.subf %cst_0, %107 : f32
          %109 = arith.mulf %105, %108 : f32
          %110 = arith.addf %100, %109 : f32
          affine.store %110, %6[] : memref<f32>
          %111 = affine.load %6[] : memref<f32>
          %112 = arith.divf %111, %21 : f32
          %113 = affine.load %arg4[%arg10 + %arg9 * symbol(%23)] : memref<?xf32>
          %114 = arith.mulf %112, %113 : f32
          affine.store %114, %arg2[%arg10 + %arg9 * symbol(%23) + (%arg8 * symbol(%23)) * symbol(%22)] : memref<?xf32>
        } {constants = [], locals = [{name = "cr", non_scalar = false, type = "f32"}, {name = "p", non_scalar = false, type = "f32"}, {name = "rhor", non_scalar = false, type = "f32"}, {name = "sr", non_scalar = false, type = "f32"}, {name = "tr", non_scalar = false, type = "f32"}, {name = "tr2", non_scalar = false, type = "f32"}, {name = "tr3", non_scalar = false, type = "f32"}, {name = "tr4", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [{name = "cr", non_scalar = false, type = "f32"}, {name = "p", non_scalar = false, type = "f32"}, {name = "rhor", non_scalar = false, type = "f32"}, {name = "sr", non_scalar = false, type = "f32"}, {name = "tr", non_scalar = false, type = "f32"}, {name = "tr2", non_scalar = false, type = "f32"}, {name = "tr3", non_scalar = false, type = "f32"}, {name = "tr4", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } {constants = [], locals = [{name = "cr", non_scalar = false, type = "f32"}, {name = "p", non_scalar = false, type = "f32"}, {name = "rhor", non_scalar = false, type = "f32"}, {name = "sr", non_scalar = false, type = "f32"}, {name = "tr", non_scalar = false, type = "f32"}, {name = "tr2", non_scalar = false, type = "f32"}, {name = "tr3", non_scalar = false, type = "f32"}, {name = "tr4", non_scalar = false, type = "f32"}], mlirclang.direction = "forward", mlirclang.indvar = "k", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "kbm1"}
    return
  }
}

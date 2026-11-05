#map = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @rhoref : memref<1xf32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_dens_(%arg0: memref<?xf32> {polygeist.name = "si", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ti", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "rhoo", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "zz", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "tbias", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "sbias", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
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
    %9 = memref.load %5[%c0] : memref<1xf32>
    %10 = memref.load %6[%c0] : memref<1xf32>
    %11 = arith.index_cast %7 : i32 to index
    %12 = arith.index_cast %8 : i32 to index
    %13 = arith.mulf %9, %10 : f32
    %14 = arith.muli %12, %11 : index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_26 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %11, %12], strides: [%14, %12, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_27 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_28 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%11, %12], strides: [%12, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg8, %arg9, %arg10) = (%c0, %c0, %c0) to (%2, %11, %12) step (%c2, %c4, %c32) {
      %15 = affine.min #map(%arg8)[%2]
      %16 = affine.min #map1(%arg9)[%11]
      %17 = affine.min #map2(%arg10)[%12]
      scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%15, %16, %17) step (%c1, %c1, %c1) {
        %18 = arith.addi %arg11, %arg8 : index
        %19 = arith.addi %arg12, %arg9 : index
        %20 = arith.addi %arg13, %arg10 : index
        %21 = memref.load %arg6[%c0] : memref<?xf32>
        %22 = memref.load %arg7[%c0] : memref<?xf32>
        %23 = memref.load %arg5[%18] : memref<?xf32>
        %24 = arith.negf %23 : f32
        %25 = memref.load %reinterpret_cast[%18, %19, %20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %26 = arith.addf %25, %21 : f32
        %27 = memref.load %reinterpret_cast_25[%18, %19, %20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %28 = arith.addf %27, %22 : f32
        %29 = arith.mulf %26, %26 : f32
        %30 = arith.mulf %29, %26 : f32
        %31 = arith.mulf %30, %26 : f32
        %32 = memref.load %reinterpret_cast_27[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %33 = arith.mulf %24, %32 : f32
        %34 = arith.mulf %13, %33 : f32
        %35 = arith.mulf %34, %cst_24 : f32
        %36 = arith.mulf %26, %cst_22 : f32
        %37 = arith.addf %36, %cst_23 : f32
        %38 = arith.mulf %29, %cst_21 : f32
        %39 = arith.subf %37, %38 : f32
        %40 = arith.mulf %30, %cst_20 : f32
        %41 = arith.addf %39, %40 : f32
        %42 = arith.mulf %31, %cst_19 : f32
        %43 = arith.subf %41, %42 : f32
        %44 = arith.mulf %31, %cst_18 : f32
        %45 = arith.mulf %44, %26 : f32
        %46 = arith.addf %43, %45 : f32
        %47 = arith.mulf %26, %cst_16 : f32
        %48 = arith.subf %cst_17, %47 : f32
        %49 = arith.mulf %29, %cst_15 : f32
        %50 = arith.addf %48, %49 : f32
        %51 = arith.mulf %30, %cst_14 : f32
        %52 = arith.subf %50, %51 : f32
        %53 = arith.mulf %31, %cst_13 : f32
        %54 = arith.addf %52, %53 : f32
        %55 = arith.mulf %54, %28 : f32
        %56 = arith.addf %46, %55 : f32
        %57 = arith.mulf %26, %cst_11 : f32
        %58 = arith.addf %57, %cst_12 : f32
        %59 = arith.mulf %29, %cst_10 : f32
        %60 = arith.subf %58, %59 : f32
        %61 = arith.extf %28 : f32 to f64
        %62 = math.absf %61 : f64
        %63 = arith.truncf %62 : f64 to f32
        %64 = math.powf %63, %cst_9 : f32
        %65 = arith.mulf %60, %64 : f32
        %66 = arith.addf %56, %65 : f32
        %67 = arith.mulf %28, %cst_8 : f32
        %68 = arith.mulf %67, %28 : f32
        %69 = arith.addf %66, %68 : f32
        %70 = arith.mulf %35, %cst_6 : f32
        %71 = arith.addf %70, %cst_7 : f32
        %72 = arith.mulf %26, %cst_5 : f32
        %73 = arith.addf %71, %72 : f32
        %74 = arith.mulf %29, %cst_4 : f32
        %75 = arith.subf %73, %74 : f32
        %76 = arith.subf %28, %cst_2 : f32
        %77 = arith.mulf %76, %cst_3 : f32
        %78 = arith.addf %75, %77 : f32
        %79 = arith.mulf %35, %cst_1 : f32
        %80 = arith.mulf %78, %78 : f32
        %81 = arith.divf %79, %80 : f32
        %82 = arith.mulf %35, %cst : f32
        %83 = arith.divf %82, %80 : f32
        %84 = arith.subf %cst_0, %83 : f32
        %85 = arith.mulf %81, %84 : f32
        %86 = arith.addf %69, %85 : f32
        %87 = arith.divf %86, %10 : f32
        %88 = memref.load %reinterpret_cast_28[%19, %20] : memref<?x?xf32, strided<[?, 1]>>
        %89 = arith.mulf %87, %88 : f32
        memref.store %89, %reinterpret_cast_26[%18, %19, %20] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


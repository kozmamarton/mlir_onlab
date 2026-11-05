#map = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
#map3 = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @grav : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_baropg_(%arg0: memref<?xf32> {polygeist.name = "rho", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "rmean", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "zz", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "ramp", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c8 = arith.constant 8 : index
    %c32 = arith.constant 32 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
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
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c2, %c4, %c32) {
      %69 = affine.min #map(%arg11)[%2]
      %70 = affine.min #map1(%arg12)[%7]
      %71 = affine.min #map2(%arg13)[%8]
      scf.parallel (%arg14, %arg15, %arg16) = (%c0, %c0, %c0) to (%69, %70, %71) step (%c1, %c1, %c1) {
        %72 = arith.addi %arg14, %arg11 : index
        %73 = arith.addi %arg15, %arg12 : index
        %74 = arith.addi %arg16, %arg13 : index
        %75 = memref.load %reinterpret_cast[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %76 = memref.load %reinterpret_cast_1[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %77 = arith.subf %75, %76 : f32
        memref.store %77, %reinterpret_cast[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %10 = memref.get_global @jmm1 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @imm1 : memref<1xi32>
    %14 = memref.get_global @grav : memref<1xf32>
    %15 = memref.load %13[%c0] : memref<1xi32>
    %16 = memref.load %4[%c0] : memref<1xi32>
    %17 = memref.load %14[%c0] : memref<1xf32>
    %18 = arith.index_cast %15 : i32 to index
    %19 = arith.index_cast %16 : i32 to index
    %20 = arith.mulf %17, %cst_0 : f32
    %reinterpret_cast_2 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%12, %19], strides: [%19, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%12, %19], strides: [%19, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%12, %19], strides: [%19, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%12, %18) step (%c8, %c32) {
      %69 = affine.min #map3(%arg11)[%12]
      %70 = affine.min #map2(%arg12)[%18]
      scf.parallel (%arg13, %arg14) = (%c0, %c0) to (%69, %70) step (%c1, %c1) {
        %71 = arith.addi %arg13, %arg11 : index
        %72 = arith.addi %arg14, %arg12 : index
        %73 = memref.load %arg4[%c0] : memref<?xf32>
        %74 = arith.negf %73 : f32
        %75 = arith.mulf %20, %74 : f32
        %76 = memref.load %reinterpret_cast_2[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
        %77 = arith.muli %71, %19 overflow<nsw> : index
        %78 = arith.addi %72, %77 : index
        %79 = arith.addi %78, %c-1 : index
        %80 = memref.load %arg5[%79] : memref<?xf32>
        %81 = arith.addf %76, %80 : f32
        %82 = arith.mulf %75, %81 : f32
        %83 = memref.load %reinterpret_cast_3[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
        %84 = memref.load %arg0[%79] : memref<?xf32>
        %85 = arith.subf %83, %84 : f32
        %86 = arith.mulf %82, %85 : f32
        memref.store %86, %reinterpret_cast_4[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %21 = memref.get_global @kbm1 : memref<1xi32>
    %22 = memref.load %21[%c0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = memref.load %10[%c0] : memref<1xi32>
    %25 = memref.load %13[%c0] : memref<1xi32>
    %26 = memref.load %4[%c0] : memref<1xi32>
    %27 = memref.load %3[%c0] : memref<1xi32>
    %28 = memref.load %14[%c0] : memref<1xf32>
    %29 = arith.index_cast %24 : i32 to index
    %30 = arith.index_cast %25 : i32 to index
    %31 = arith.index_cast %26 : i32 to index
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.mulf %28, %cst : f32
    %34 = arith.muli %31, %32 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%23, %32, %31], strides: [%34, %31, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%23, %32, %31], strides: [%34, %31, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_7 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%29, %31], strides: [%31, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%29, %30) step (%c8, %c32) {
      %69 = affine.min #map3(%arg11)[%29]
      %70 = affine.min #map2(%arg12)[%30]
      scf.parallel (%arg13, %arg14) = (%c0, %c0) to (%69, %70) step (%c1, %c1) {
        %71 = arith.addi %arg13, %arg11 : index
        %72 = arith.addi %arg14, %arg12 : index
        scf.for %arg15 = %c1 to %23 step %c1 {
          %73 = arith.addi %arg15, %c-1 : index
          %74 = memref.load %arg4[%73] : memref<?xf32>
          %75 = memref.load %arg4[%arg15] : memref<?xf32>
          %76 = arith.subf %74, %75 : f32
          %77 = arith.mulf %33, %76 : f32
          %78 = arith.addf %74, %75 : f32
          %79 = arith.mulf %33, %78 : f32
          %80 = memref.load %reinterpret_cast_5[%73, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %81 = memref.load %reinterpret_cast_7[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
          %82 = arith.muli %71, %31 overflow<nsw> : index
          %83 = arith.addi %72, %82 : index
          %84 = arith.addi %83, %c-1 : index
          %85 = memref.load %arg5[%84] : memref<?xf32>
          %86 = arith.addf %81, %85 : f32
          %87 = arith.mulf %77, %86 : f32
          %88 = memref.load %reinterpret_cast_6[%arg15, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %89 = arith.muli %arg15, %31 overflow<nsw> : index
          %90 = arith.muli %89, %32 overflow<nsw> : index
          %91 = arith.addi %83, %90 : index
          %92 = arith.addi %91, %c-1 : index
          %93 = memref.load %arg0[%92] : memref<?xf32>
          %94 = arith.subf %88, %93 : f32
          %95 = memref.load %reinterpret_cast_6[%73, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %96 = arith.addf %94, %95 : f32
          %97 = arith.muli %73, %31 overflow<nsw> : index
          %98 = arith.muli %97, %32 overflow<nsw> : index
          %99 = arith.addi %83, %98 : index
          %100 = arith.addi %99, %c-1 : index
          %101 = memref.load %arg0[%100] : memref<?xf32>
          %102 = arith.subf %96, %101 : f32
          %103 = arith.mulf %87, %102 : f32
          %104 = arith.addf %80, %103 : f32
          %105 = arith.subf %81, %85 : f32
          %106 = arith.mulf %79, %105 : f32
          %107 = arith.addf %88, %93 : f32
          %108 = arith.subf %107, %95 : f32
          %109 = arith.subf %108, %101 : f32
          %110 = arith.mulf %106, %109 : f32
          %111 = arith.addf %104, %110 : f32
          memref.store %111, %reinterpret_cast_5[%arg15, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_8 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%29, %31], strides: [%31, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_9 = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%29, %31], strides: [%31, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%23, %29, %30) step (%c2, %c4, %c32) {
      %69 = affine.min #map(%arg11)[%23]
      %70 = affine.min #map1(%arg12)[%29]
      %71 = affine.min #map2(%arg13)[%30]
      scf.parallel (%arg14, %arg15, %arg16) = (%c0, %c0, %c0) to (%69, %70, %71) step (%c1, %c1, %c1) {
        %72 = arith.addi %arg14, %arg11 : index
        %73 = arith.addi %arg15, %arg12 : index
        %74 = arith.addi %arg16, %arg13 : index
        %75 = memref.load %reinterpret_cast_7[%73, %74] : memref<?x?xf32, strided<[?, 1]>>
        %76 = arith.muli %73, %31 overflow<nsw> : index
        %77 = arith.addi %74, %76 : index
        %78 = arith.addi %77, %c-1 : index
        %79 = memref.load %arg5[%78] : memref<?xf32>
        %80 = arith.addf %75, %79 : f32
        %81 = arith.mulf %80, %cst : f32
        %82 = memref.load %reinterpret_cast_5[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %83 = arith.mulf %81, %82 : f32
        %84 = memref.load %reinterpret_cast_8[%73, %74] : memref<?x?xf32, strided<[?, 1]>>
        %85 = arith.mulf %83, %84 : f32
        %86 = memref.load %reinterpret_cast_9[%73, %74] : memref<?x?xf32, strided<[?, 1]>>
        %87 = memref.load %arg9[%78] : memref<?xf32>
        %88 = arith.addf %86, %87 : f32
        %89 = arith.mulf %85, %88 : f32
        memref.store %89, %reinterpret_cast_5[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %35 = memref.load %10[%c0] : memref<1xi32>
    %36 = arith.index_cast %35 : i32 to index
    %37 = memref.load %13[%c0] : memref<1xi32>
    %38 = memref.load %4[%c0] : memref<1xi32>
    %39 = memref.load %14[%c0] : memref<1xf32>
    %40 = arith.index_cast %37 : i32 to index
    %41 = arith.index_cast %38 : i32 to index
    %42 = arith.mulf %39, %cst_0 : f32
    %reinterpret_cast_10 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%36, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%36, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%36, %41], strides: [%41, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%36, %40) step (%c8, %c32) {
      %69 = affine.min #map3(%arg11)[%36]
      %70 = affine.min #map2(%arg12)[%40]
      scf.parallel (%arg13, %arg14) = (%c0, %c0) to (%69, %70) step (%c1, %c1) {
        %71 = arith.addi %arg13, %arg11 : index
        %72 = arith.addi %arg14, %arg12 : index
        %73 = memref.load %arg4[%c0] : memref<?xf32>
        %74 = arith.negf %73 : f32
        %75 = arith.mulf %42, %74 : f32
        %76 = memref.load %reinterpret_cast_10[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
        %77 = arith.addi %71, %c-1 : index
        %78 = memref.load %reinterpret_cast_10[%77, %72] : memref<?x?xf32, strided<[?, 1]>>
        %79 = arith.addf %76, %78 : f32
        %80 = arith.mulf %75, %79 : f32
        %81 = memref.load %reinterpret_cast_11[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
        %82 = memref.load %reinterpret_cast_11[%77, %72] : memref<?x?xf32, strided<[?, 1]>>
        %83 = arith.subf %81, %82 : f32
        %84 = arith.mulf %80, %83 : f32
        memref.store %84, %reinterpret_cast_12[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %43 = memref.load %21[%c0] : memref<1xi32>
    %44 = arith.index_cast %43 : i32 to index
    %45 = memref.load %10[%c0] : memref<1xi32>
    %46 = memref.load %13[%c0] : memref<1xi32>
    %47 = memref.load %4[%c0] : memref<1xi32>
    %48 = memref.load %3[%c0] : memref<1xi32>
    %49 = memref.load %14[%c0] : memref<1xf32>
    %50 = arith.index_cast %45 : i32 to index
    %51 = arith.index_cast %46 : i32 to index
    %52 = arith.index_cast %47 : i32 to index
    %53 = arith.index_cast %48 : i32 to index
    %54 = arith.mulf %49, %cst : f32
    %55 = arith.muli %52, %53 : index
    %reinterpret_cast_13 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%44, %53, %52], strides: [%55, %52, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%44, %53, %52], strides: [%55, %52, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%50, %52], strides: [%52, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12) = (%c1, %c1) to (%50, %51) step (%c8, %c32) {
      %69 = affine.min #map3(%arg11)[%50]
      %70 = affine.min #map2(%arg12)[%51]
      scf.parallel (%arg13, %arg14) = (%c0, %c0) to (%69, %70) step (%c1, %c1) {
        %71 = arith.addi %arg13, %arg11 : index
        %72 = arith.addi %arg14, %arg12 : index
        scf.for %arg15 = %c1 to %44 step %c1 {
          %73 = arith.addi %arg15, %c-1 : index
          %74 = memref.load %arg4[%73] : memref<?xf32>
          %75 = memref.load %arg4[%arg15] : memref<?xf32>
          %76 = arith.subf %74, %75 : f32
          %77 = arith.mulf %54, %76 : f32
          %78 = arith.addf %74, %75 : f32
          %79 = arith.mulf %54, %78 : f32
          %80 = memref.load %reinterpret_cast_13[%73, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %81 = memref.load %reinterpret_cast_15[%71, %72] : memref<?x?xf32, strided<[?, 1]>>
          %82 = arith.addi %71, %c-1 : index
          %83 = memref.load %reinterpret_cast_15[%82, %72] : memref<?x?xf32, strided<[?, 1]>>
          %84 = arith.addf %81, %83 : f32
          %85 = arith.mulf %77, %84 : f32
          %86 = memref.load %reinterpret_cast_14[%arg15, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %87 = memref.load %reinterpret_cast_14[%arg15, %82, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %88 = arith.subf %86, %87 : f32
          %89 = memref.load %reinterpret_cast_14[%73, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %90 = arith.addf %88, %89 : f32
          %91 = memref.load %reinterpret_cast_14[%73, %82, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %92 = arith.subf %90, %91 : f32
          %93 = arith.mulf %85, %92 : f32
          %94 = arith.addf %80, %93 : f32
          %95 = arith.subf %81, %83 : f32
          %96 = arith.mulf %79, %95 : f32
          %97 = arith.addf %86, %87 : f32
          %98 = arith.subf %97, %89 : f32
          %99 = arith.subf %98, %91 : f32
          %100 = arith.mulf %96, %99 : f32
          %101 = arith.addf %94, %100 : f32
          memref.store %101, %reinterpret_cast_13[%arg15, %71, %72] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast_16 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%50, %52], strides: [%52, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%50, %52], strides: [%52, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c1, %c1) to (%44, %50, %51) step (%c2, %c4, %c32) {
      %69 = affine.min #map(%arg11)[%44]
      %70 = affine.min #map1(%arg12)[%50]
      %71 = affine.min #map2(%arg13)[%51]
      scf.parallel (%arg14, %arg15, %arg16) = (%c0, %c0, %c0) to (%69, %70, %71) step (%c1, %c1, %c1) {
        %72 = arith.addi %arg14, %arg11 : index
        %73 = arith.addi %arg15, %arg12 : index
        %74 = arith.addi %arg16, %arg13 : index
        %75 = memref.load %reinterpret_cast_15[%73, %74] : memref<?x?xf32, strided<[?, 1]>>
        %76 = arith.addi %73, %c-1 : index
        %77 = memref.load %reinterpret_cast_15[%76, %74] : memref<?x?xf32, strided<[?, 1]>>
        %78 = arith.addf %75, %77 : f32
        %79 = arith.mulf %78, %cst : f32
        %80 = memref.load %reinterpret_cast_13[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %81 = arith.mulf %79, %80 : f32
        %82 = memref.load %reinterpret_cast_16[%73, %74] : memref<?x?xf32, strided<[?, 1]>>
        %83 = arith.mulf %81, %82 : f32
        %84 = memref.load %reinterpret_cast_17[%73, %74] : memref<?x?xf32, strided<[?, 1]>>
        %85 = memref.load %reinterpret_cast_17[%76, %74] : memref<?x?xf32, strided<[?, 1]>>
        %86 = arith.addf %84, %85 : f32
        %87 = arith.mulf %83, %86 : f32
        memref.store %87, %reinterpret_cast_13[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %56 = memref.load %0[%c0] : memref<1xi32>
    %57 = arith.index_cast %56 : i32 to index
    %58 = memref.load %10[%c0] : memref<1xi32>
    %59 = memref.load %13[%c0] : memref<1xi32>
    %60 = memref.load %4[%c0] : memref<1xi32>
    %61 = memref.load %3[%c0] : memref<1xi32>
    %62 = arith.index_cast %58 : i32 to index
    %63 = arith.index_cast %59 : i32 to index
    %64 = arith.index_cast %60 : i32 to index
    %65 = arith.index_cast %61 : i32 to index
    %66 = arith.muli %64, %65 : index
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%57, %65, %64], strides: [%66, %64, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%57, %65, %64], strides: [%66, %64, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_20 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%57, %65, %64], strides: [%66, %64, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%57, %65, %64], strides: [%66, %64, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %67 = arith.maxsi %65, %62 : index
    %68 = arith.maxsi %64, %63 : index
    scf.parallel (%arg11, %arg12, %arg13) = (%c0, %c0, %c0) to (%57, %67, %68) step (%c2, %c4, %c32) {
      %69 = affine.min #map(%arg11)[%57]
      %70 = affine.min #map1(%arg12)[%67]
      %71 = affine.min #map2(%arg13)[%68]
      scf.parallel (%arg14, %arg15, %arg16) = (%c0, %c0, %c0) to (%69, %70, %71) step (%c1, %c1, %c1) {
        %72 = arith.addi %arg14, %arg11 : index
        %73 = arith.addi %arg15, %arg12 : index
        %74 = arith.addi %arg16, %arg13 : index
        %75 = memref.load %arg10[%c0] : memref<?xf32>
        %76 = arith.addi %73, %c-1 : index
        %77 = arith.cmpi sge, %76, %c0 : index
        %78 = arith.subi %62, %73 : index
        %79 = arith.addi %78, %c-1 : index
        %80 = arith.cmpi sge, %79, %c0 : index
        %81 = arith.andi %77, %80 : i1
        %82 = arith.addi %74, %c-1 : index
        %83 = arith.cmpi sge, %82, %c0 : index
        %84 = arith.andi %81, %83 : i1
        %85 = arith.subi %63, %74 : index
        %86 = arith.addi %85, %c-1 : index
        %87 = arith.cmpi sge, %86, %c0 : index
        %88 = arith.andi %84, %87 : i1
        scf.if %88 {
          %96 = memref.load %reinterpret_cast_18[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %97 = arith.mulf %75, %96 : f32
          memref.store %97, %reinterpret_cast_18[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %98 = memref.load %reinterpret_cast_19[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %99 = arith.mulf %75, %98 : f32
          memref.store %99, %reinterpret_cast_19[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        }
        %89 = arith.subi %65, %73 : index
        %90 = arith.addi %89, %c-1 : index
        %91 = arith.cmpi sge, %90, %c0 : index
        %92 = arith.subi %64, %74 : index
        %93 = arith.addi %92, %c-1 : index
        %94 = arith.cmpi sge, %93, %c0 : index
        %95 = arith.andi %91, %94 : i1
        scf.if %95 {
          %96 = memref.load %reinterpret_cast_20[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %97 = memref.load %reinterpret_cast_21[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %98 = arith.addf %96, %97 : f32
          memref.store %98, %reinterpret_cast_20[%72, %73, %74] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


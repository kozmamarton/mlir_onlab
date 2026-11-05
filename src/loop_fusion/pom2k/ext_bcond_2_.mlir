#map = affine_map<(d0)[s0] -> (-d0 + s0, 256)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @jm : memref<1xi32>
  memref.global @jmm2 : memref<1xi32>
  memref.global @imm2 : memref<1xi32>
  memref.global @grav : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_bcond_2_(%arg0: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "uabe", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "uabw", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "vabn", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vabs", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "ele", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "elw", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "eln", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "els", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "ramp", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "rfe", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "rfw", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "rfn", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "rfs", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c256 = arith.constant 256 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @grav : memref<1xf32>
    %6 = memref.get_global @imm2 : memref<1xi32>
    %7 = memref.load %3[%c0] : memref<1xi32>
    %8 = memref.load %4[%c0] : memref<1xi32>
    %9 = memref.load %5[%c0] : memref<1xf32>
    %10 = memref.load %6[%c0] : memref<1xi32>
    %11 = arith.index_cast %7 : i32 to index
    %12 = arith.index_cast %8 : i32 to index
    %13 = arith.index_cast %10 : i32 to index
    scf.parallel (%arg19) = (%c1) to (%2) step (%c256) {
      %29 = affine.min #map(%arg19)[%2]
      scf.parallel (%arg20) = (%c0) to (%29) step (%c1) {
        %30 = arith.addi %arg20, %arg19 : index
        %31 = memref.load %arg15[%c0] : memref<?xf32>
        %32 = memref.load %arg14[%c0] : memref<?xf32>
        %33 = memref.load %arg16[%c0] : memref<?xf32>
        %34 = memref.load %arg2[%30] : memref<?xf32>
        %35 = arith.muli %30, %12 overflow<nsw> : index
        %36 = arith.addi %35, %13 : index
        %37 = memref.load %arg6[%36] : memref<?xf32>
        %38 = arith.divf %9, %37 : f32
        %39 = math.sqrt %38 : f32
        %40 = arith.mulf %31, %39 : f32
        %41 = memref.load %arg7[%36] : memref<?xf32>
        %42 = memref.load %arg8[%30] : memref<?xf32>
        %43 = arith.subf %41, %42 : f32
        %44 = arith.mulf %40, %43 : f32
        %45 = arith.addf %34, %44 : f32
        %46 = arith.addi %35, %11 : index
        memref.store %45, %arg0[%46] : memref<?xf32>
        %47 = memref.load %arg0[%46] : memref<?xf32>
        %48 = arith.mulf %32, %47 : f32
        memref.store %48, %arg0[%46] : memref<?xf32>
        memref.store %cst, %arg1[%46] : memref<?xf32>
        %49 = memref.load %arg3[%30] : memref<?xf32>
        %50 = arith.addi %35, %c1 : index
        %51 = memref.load %arg6[%50] : memref<?xf32>
        %52 = arith.divf %9, %51 : f32
        %53 = math.sqrt %52 : f32
        %54 = arith.mulf %33, %53 : f32
        %55 = memref.load %arg7[%50] : memref<?xf32>
        %56 = memref.load %arg9[%30] : memref<?xf32>
        %57 = arith.subf %55, %56 : f32
        %58 = arith.mulf %54, %57 : f32
        %59 = arith.subf %49, %58 : f32
        memref.store %59, %arg0[%50] : memref<?xf32>
        %60 = memref.load %arg0[%50] : memref<?xf32>
        %61 = arith.mulf %32, %60 : f32
        memref.store %61, %arg0[%50] : memref<?xf32>
        %62 = memref.load %arg0[%50] : memref<?xf32>
        memref.store %62, %arg0[%35] : memref<?xf32>
        memref.store %cst, %arg1[%35] : memref<?xf32>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %14 = memref.load %3[%c0] : memref<1xi32>
    %15 = arith.index_cast %14 : i32 to index
    %16 = memref.get_global @jmm2 : memref<1xi32>
    %17 = memref.load %0[%c0] : memref<1xi32>
    %18 = memref.load %4[%c0] : memref<1xi32>
    %19 = memref.load %5[%c0] : memref<1xf32>
    %20 = memref.load %16[%c0] : memref<1xi32>
    %21 = arith.index_cast %17 : i32 to index
    %22 = arith.index_cast %18 : i32 to index
    %23 = arith.muli %21, %22 : index
    %24 = arith.index_cast %20 : i32 to index
    %25 = arith.muli %24, %22 : index
    %26 = memref.get_global @jm : memref<1xi32>
    %27 = memref.load %26[%c0] : memref<1xi32>
    %28 = arith.index_cast %27 : i32 to index
    scf.parallel (%arg19) = (%c1) to (%15) step (%c256) {
      %29 = affine.min #map(%arg19)[%15]
      scf.parallel (%arg20) = (%c0) to (%29) step (%c1) {
        %30 = arith.addi %arg20, %arg19 : index
        %31 = memref.load %arg17[%c0] : memref<?xf32>
        %32 = memref.load %arg14[%c0] : memref<?xf32>
        %33 = memref.load %arg18[%c0] : memref<?xf32>
        %34 = memref.load %arg4[%30] : memref<?xf32>
        %35 = arith.addi %30, %25 : index
        %36 = memref.load %arg6[%35] : memref<?xf32>
        %37 = arith.divf %19, %36 : f32
        %38 = math.sqrt %37 : f32
        %39 = arith.mulf %31, %38 : f32
        %40 = memref.load %arg7[%35] : memref<?xf32>
        %41 = memref.load %arg10[%30] : memref<?xf32>
        %42 = arith.subf %40, %41 : f32
        %43 = arith.mulf %39, %42 : f32
        %44 = arith.addf %34, %43 : f32
        %45 = arith.mulf %32, %44 : f32
        %46 = arith.addi %30, %23 : index
        memref.store %45, %arg1[%46] : memref<?xf32>
        memref.store %cst, %arg0[%46] : memref<?xf32>
        %47 = memref.load %arg5[%30] : memref<?xf32>
        %48 = arith.addi %30, %22 : index
        %49 = memref.load %arg6[%48] : memref<?xf32>
        %50 = arith.divf %19, %49 : f32
        %51 = math.sqrt %50 : f32
        %52 = arith.mulf %33, %51 : f32
        %53 = memref.load %arg7[%48] : memref<?xf32>
        %54 = memref.load %arg11[%30] : memref<?xf32>
        %55 = arith.subf %53, %54 : f32
        %56 = arith.mulf %52, %55 : f32
        %57 = arith.subf %47, %56 : f32
        %58 = arith.mulf %32, %57 : f32
        memref.store %58, %arg1[%48] : memref<?xf32>
        memref.store %58, %arg1[%30] : memref<?xf32>
        memref.store %cst, %arg0[%30] : memref<?xf32>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%28, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%28, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%28, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%28, %22], strides: [%22, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg19, %arg20) = (%c0, %c0) to (%28, %22) step (%c8, %c32) {
      %29 = affine.min #map1(%arg19)[%28]
      %30 = affine.min #map2(%arg20)[%22]
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%29, %30) step (%c1, %c1) {
        %31 = arith.addi %arg21, %arg19 : index
        %32 = arith.addi %arg22, %arg20 : index
        %33 = memref.load %reinterpret_cast[%31, %32] : memref<?x?xf32, strided<[?, 1]>>
        %34 = memref.load %reinterpret_cast_0[%31, %32] : memref<?x?xf32, strided<[?, 1]>>
        %35 = arith.mulf %33, %34 : f32
        memref.store %35, %reinterpret_cast[%31, %32] : memref<?x?xf32, strided<[?, 1]>>
        %36 = memref.load %reinterpret_cast_1[%31, %32] : memref<?x?xf32, strided<[?, 1]>>
        %37 = memref.load %reinterpret_cast_2[%31, %32] : memref<?x?xf32, strided<[?, 1]>>
        %38 = arith.mulf %36, %37 : f32
        memref.store %38, %reinterpret_cast_1[%31, %32] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


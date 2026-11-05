#map = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @horcon : memref<1xf32>
  memref.global @jm : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_aam_(%arg0: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jmm1 : memref<1xi32>
    %4 = memref.get_global @imm1 : memref<1xi32>
    %5 = memref.get_global @im : memref<1xi32>
    %6 = memref.get_global @jm : memref<1xi32>
    %7 = memref.get_global @horcon : memref<1xf32>
    %8 = memref.load %3[%c0] : memref<1xi32>
    %9 = memref.load %4[%c0] : memref<1xi32>
    %10 = memref.load %5[%c0] : memref<1xi32>
    %11 = memref.load %6[%c0] : memref<1xi32>
    %12 = memref.load %7[%c0] : memref<1xf32>
    %13 = arith.index_cast %8 : i32 to index
    %14 = arith.index_cast %9 : i32 to index
    %15 = arith.index_cast %10 : i32 to index
    %16 = arith.index_cast %11 : i32 to index
    %17 = arith.muli %15, %16 : index
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %16, %15], strides: [%17, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %16, %15], strides: [%17, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %16, %15], strides: [%17, %15, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%13, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%13, %15], strides: [%15, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg5, %arg6, %arg7) = (%c0, %c1, %c1) to (%2, %13, %14) step (%c2, %c4, %c32) {
      %18 = affine.min #map(%arg5)[%2]
      %19 = affine.min #map1(%arg6)[%13]
      %20 = affine.min #map2(%arg7)[%14]
      scf.parallel (%arg8, %arg9, %arg10) = (%c0, %c0, %c0) to (%18, %19, %20) step (%c1, %c1, %c1) {
        %21 = arith.addi %arg8, %arg5 : index
        %22 = arith.addi %arg9, %arg6 : index
        %23 = arith.addi %arg10, %arg7 : index
        %24 = memref.load %reinterpret_cast_3[%22, %23] : memref<?x?xf32, strided<[?, 1]>>
        %25 = arith.mulf %12, %24 : f32
        %26 = memref.load %reinterpret_cast_4[%22, %23] : memref<?x?xf32, strided<[?, 1]>>
        %27 = arith.mulf %25, %26 : f32
        %28 = arith.muli %22, %15 overflow<nsw> : index
        %29 = arith.addi %23, %28 : index
        %30 = arith.muli %21, %15 overflow<nsw> : index
        %31 = arith.muli %30, %16 overflow<nsw> : index
        %32 = arith.addi %29, %31 : index
        %33 = arith.addi %32, %c1 : index
        %34 = memref.load %arg3[%33] : memref<?xf32>
        %35 = memref.load %reinterpret_cast[%21, %22, %23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %36 = arith.subf %34, %35 : f32
        %37 = arith.divf %36, %24 : f32
        %38 = arith.mulf %37, %37 : f32
        %39 = arith.addi %22, %c1 : index
        %40 = memref.load %reinterpret_cast_1[%21, %39, %23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %41 = memref.load %reinterpret_cast_1[%21, %22, %23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %42 = arith.subf %40, %41 : f32
        %43 = arith.divf %42, %26 : f32
        %44 = arith.mulf %43, %43 : f32
        %45 = arith.addf %38, %44 : f32
        %46 = memref.load %reinterpret_cast[%21, %39, %23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %47 = arith.muli %39, %15 overflow<nsw> : index
        %48 = arith.addi %23, %47 : index
        %49 = arith.addi %48, %31 : index
        %50 = arith.addi %49, %c1 : index
        %51 = memref.load %arg3[%50] : memref<?xf32>
        %52 = arith.addf %46, %51 : f32
        %53 = arith.addi %22, %c-1 : index
        %54 = memref.load %reinterpret_cast[%21, %53, %23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %55 = arith.subf %52, %54 : f32
        %56 = arith.muli %53, %15 overflow<nsw> : index
        %57 = arith.addi %23, %56 : index
        %58 = arith.addi %57, %31 : index
        %59 = arith.addi %58, %c1 : index
        %60 = memref.load %arg3[%59] : memref<?xf32>
        %61 = arith.subf %55, %60 : f32
        %62 = arith.mulf %61, %cst : f32
        %63 = arith.divf %62, %26 : f32
        %64 = memref.load %arg4[%33] : memref<?xf32>
        %65 = memref.load %arg4[%50] : memref<?xf32>
        %66 = arith.addf %64, %65 : f32
        %67 = arith.addi %32, %c-1 : index
        %68 = memref.load %arg4[%67] : memref<?xf32>
        %69 = arith.subf %66, %68 : f32
        %70 = arith.addi %49, %c-1 : index
        %71 = memref.load %arg4[%70] : memref<?xf32>
        %72 = arith.subf %69, %71 : f32
        %73 = arith.mulf %72, %cst : f32
        %74 = arith.divf %73, %24 : f32
        %75 = arith.addf %63, %74 : f32
        %76 = arith.mulf %75, %cst_0 : f32
        %77 = arith.mulf %76, %75 : f32
        %78 = arith.addf %45, %77 : f32
        %79 = math.sqrt %78 : f32
        %80 = arith.mulf %27, %79 : f32
        memref.store %80, %reinterpret_cast_2[%21, %22, %23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


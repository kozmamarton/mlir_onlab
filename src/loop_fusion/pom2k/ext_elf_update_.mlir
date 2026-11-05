#map = affine_map<(d0)[s0] -> (-d0 + s0, 8)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte2 : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_elf_update_(%arg0: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @dte2 : memref<1xf32>
    %6 = memref.load %3[%c0] : memref<1xi32>
    %7 = memref.load %4[%c0] : memref<1xi32>
    %8 = memref.load %5[%c0] : memref<1xf32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_0 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_1 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_2 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%2, %10], strides: [%10, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg6, %arg7) = (%c1, %c1) to (%2, %9) step (%c8, %c32) {
      %11 = affine.min #map(%arg6)[%2]
      %12 = affine.min #map1(%arg7)[%9]
      scf.parallel (%arg8, %arg9) = (%c0, %c0) to (%11, %12) step (%c1, %c1) {
        %13 = arith.addi %arg8, %arg6 : index
        %14 = arith.addi %arg9, %arg7 : index
        %15 = memref.load %reinterpret_cast[%13, %14] : memref<?x?xf32, strided<[?, 1]>>
        %16 = arith.muli %13, %10 overflow<nsw> : index
        %17 = arith.addi %14, %16 : index
        %18 = arith.addi %17, %c1 : index
        %19 = memref.load %arg2[%18] : memref<?xf32>
        %20 = memref.load %reinterpret_cast_0[%13, %14] : memref<?x?xf32, strided<[?, 1]>>
        %21 = arith.subf %19, %20 : f32
        %22 = arith.addi %13, %c1 : index
        %23 = memref.load %reinterpret_cast_1[%22, %14] : memref<?x?xf32, strided<[?, 1]>>
        %24 = arith.addf %21, %23 : f32
        %25 = memref.load %reinterpret_cast_1[%13, %14] : memref<?x?xf32, strided<[?, 1]>>
        %26 = arith.subf %24, %25 : f32
        %27 = arith.negf %26 : f32
        %28 = memref.load %reinterpret_cast_2[%13, %14] : memref<?x?xf32, strided<[?, 1]>>
        %29 = arith.divf %27, %28 : f32
        %30 = memref.load %reinterpret_cast_3[%13, %14] : memref<?x?xf32, strided<[?, 1]>>
        %31 = arith.subf %29, %30 : f32
        %32 = arith.mulf %8, %31 : f32
        %33 = arith.addf %15, %32 : f32
        memref.store %33, %reinterpret_cast_4[%13, %14] : memref<?x?xf32, strided<[?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


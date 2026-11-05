#map = affine_map<(d0, d1) -> (8, d0 - d1)>
#map1 = affine_map<(d0, d1) -> (32, d0 - d1)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_etf_update_(%arg0: memref<?xi32> {polygeist.name = "iext", polygeist.type = "int *"}, %arg1: memref<?xi32> {polygeist.name = "isplit", polygeist.type = "int *"}, %arg2: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c-2_i32 = arith.constant -2 : i32
    %c-1_i32 = arith.constant -1 : i32
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = memref.load %arg0[%c0] : memref<?xi32>
    %1 = memref.load %arg1[%c0] : memref<?xi32>
    %2 = arith.addi %1, %c-2_i32 : i32
    %3 = arith.cmpi eq, %0, %2 : i32
    scf.if %3 {
      %4 = memref.get_global @jm : memref<1xi32>
      %5 = memref.load %4[%c0] : memref<1xi32>
      %6 = arith.index_cast %5 : i32 to index
      %7 = memref.get_global @im : memref<1xi32>
      %8 = memref.load %7[%c0] : memref<1xi32>
      %9 = arith.index_cast %8 : i32 to index
      scf.parallel (%arg6, %arg7) = (%c0, %c0) to (%6, %9) step (%c8, %c32) {
        %10 = affine.min #map(%6, %arg6)
        %11 = affine.min #map1(%9, %arg7)
        scf.parallel (%arg8, %arg9) = (%c0, %c0) to (%10, %11) step (%c1, %c1) {
          %12 = arith.addi %arg8, %arg6 : index
          %13 = arith.addi %arg9, %arg7 : index
          %14 = memref.load %arg2[%c0] : memref<?xf32>
          %15 = arith.mulf %14, %cst_1 : f32
          %16 = arith.muli %12, %9 : index
          %17 = arith.addi %13, %16 : index
          %18 = memref.load %arg4[%17] : memref<?xf32>
          %19 = arith.mulf %15, %18 : f32
          memref.store %19, %arg3[%17] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    } else {
      %4 = memref.load %arg0[%c0] : memref<?xi32>
      %5 = memref.load %arg1[%c0] : memref<?xi32>
      %6 = arith.addi %5, %c-1_i32 : i32
      %7 = arith.cmpi eq, %4, %6 : i32
      scf.if %7 {
        %8 = memref.get_global @jm : memref<1xi32>
        %9 = memref.load %8[%c0] : memref<1xi32>
        %10 = arith.index_cast %9 : i32 to index
        %11 = memref.get_global @im : memref<1xi32>
        %12 = memref.load %11[%c0] : memref<1xi32>
        %13 = arith.index_cast %12 : i32 to index
        scf.parallel (%arg6, %arg7) = (%c0, %c0) to (%10, %13) step (%c8, %c32) {
          %14 = affine.min #map(%10, %arg6)
          %15 = affine.min #map1(%13, %arg7)
          scf.parallel (%arg8, %arg9) = (%c0, %c0) to (%14, %15) step (%c1, %c1) {
            %16 = arith.addi %arg8, %arg6 : index
            %17 = arith.addi %arg9, %arg7 : index
            %18 = memref.load %arg2[%c0] : memref<?xf32>
            %19 = arith.mulf %18, %cst_0 : f32
            %20 = arith.subf %cst, %19 : f32
            %21 = arith.mulf %20, %cst_0 : f32
            %22 = arith.muli %16, %13 : index
            %23 = arith.addi %17, %22 : index
            %24 = memref.load %arg3[%23] : memref<?xf32>
            %25 = memref.load %arg4[%23] : memref<?xf32>
            %26 = arith.mulf %21, %25 : f32
            %27 = arith.addf %24, %26 : f32
            memref.store %27, %arg3[%23] : memref<?xf32>
            scf.reduce 
          } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      } else {
        %8 = memref.load %arg0[%c0] : memref<?xi32>
        %9 = memref.load %arg1[%c0] : memref<?xi32>
        %10 = arith.cmpi eq, %8, %9 : i32
        scf.if %10 {
          %11 = memref.get_global @jm : memref<1xi32>
          %12 = memref.load %11[%c0] : memref<1xi32>
          %13 = arith.index_cast %12 : i32 to index
          %14 = memref.get_global @im : memref<1xi32>
          %15 = memref.load %14[%c0] : memref<1xi32>
          %16 = arith.index_cast %15 : i32 to index
          scf.parallel (%arg6, %arg7) = (%c0, %c0) to (%13, %16) step (%c8, %c32) {
            %17 = affine.min #map(%13, %arg6)
            %18 = affine.min #map1(%16, %arg7)
            scf.parallel (%arg8, %arg9) = (%c0, %c0) to (%17, %18) step (%c1, %c1) {
              %19 = arith.addi %arg8, %arg6 : index
              %20 = arith.addi %arg9, %arg7 : index
              %21 = arith.muli %19, %16 : index
              %22 = arith.addi %20, %21 : index
              %23 = memref.load %arg3[%22] : memref<?xf32>
              %24 = memref.load %arg4[%22] : memref<?xf32>
              %25 = arith.mulf %24, %cst_0 : f32
              %26 = arith.addf %23, %25 : f32
              %27 = memref.load %arg5[%22] : memref<?xf32>
              %28 = arith.mulf %26, %27 : f32
              memref.store %28, %arg3[%22] : memref<?xf32>
              scf.reduce 
            } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
            scf.reduce 
          } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        }
      }
    }
    return
  }
}


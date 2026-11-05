#map = affine_map<(d0, d1) -> (8, d0 - d1)>
#map1 = affine_map<(d0, d1) -> (32, d0 - d1)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_apply_filter_(%arg0: memref<?xf32> {polygeist.name = "vamax", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vmaxl", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}, %arg3: memref<?xi32> {polygeist.name = "iext", polygeist.type = "int *"}, %arg4: memref<?xi32> {polygeist.name = "isplit", polygeist.type = "int *"}, %arg5: memref<?xf32> {polygeist.name = "ispi", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "isp2i", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg19: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg20: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c8 = arith.constant 8 : index
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = memref.load %arg0[%c0] : memref<?xf32>
    %1 = memref.load %arg1[%c0] : memref<?xf32>
    %2 = arith.cmpf olt, %0, %1 : f32
    scf.if %2 {
      %3 = memref.get_global @jm : memref<1xi32>
      %4 = memref.load %3[%c0] : memref<1xi32>
      %5 = arith.index_cast %4 : i32 to index
      %6 = memref.get_global @im : memref<1xi32>
      %7 = memref.load %6[%c0] : memref<1xi32>
      %8 = arith.index_cast %7 : i32 to index
      scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%5, %8) step (%c8, %c32) {
        %12 = affine.min #map(%5, %arg21)
        %13 = affine.min #map1(%8, %arg22)
        scf.parallel (%arg23, %arg24) = (%c0, %c0) to (%12, %13) step (%c1, %c1) {
          %14 = arith.addi %arg23, %arg21 : index
          %15 = arith.addi %arg24, %arg22 : index
          %16 = memref.load %arg2[%c0] : memref<?xf32>
          %17 = arith.mulf %16, %cst_0 : f32
          %18 = arith.muli %14, %8 : index
          %19 = arith.addi %15, %18 : index
          %20 = memref.load %arg7[%19] : memref<?xf32>
          %21 = memref.load %arg8[%19] : memref<?xf32>
          %22 = arith.mulf %20, %cst : f32
          %23 = arith.subf %21, %22 : f32
          %24 = memref.load %arg9[%19] : memref<?xf32>
          %25 = arith.addf %23, %24 : f32
          %26 = arith.mulf %17, %25 : f32
          %27 = arith.addf %20, %26 : f32
          memref.store %27, %arg7[%19] : memref<?xf32>
          %28 = memref.load %arg10[%19] : memref<?xf32>
          %29 = memref.load %arg11[%19] : memref<?xf32>
          %30 = arith.mulf %28, %cst : f32
          %31 = arith.subf %29, %30 : f32
          %32 = memref.load %arg12[%19] : memref<?xf32>
          %33 = arith.addf %31, %32 : f32
          %34 = arith.mulf %17, %33 : f32
          %35 = arith.addf %28, %34 : f32
          memref.store %35, %arg10[%19] : memref<?xf32>
          %36 = memref.load %arg13[%19] : memref<?xf32>
          %37 = memref.load %arg14[%19] : memref<?xf32>
          %38 = arith.mulf %36, %cst : f32
          %39 = arith.subf %37, %38 : f32
          %40 = memref.load %arg15[%19] : memref<?xf32>
          %41 = arith.addf %39, %40 : f32
          %42 = arith.mulf %17, %41 : f32
          %43 = arith.addf %36, %42 : f32
          memref.store %43, %arg13[%19] : memref<?xf32>
          %44 = memref.load %arg13[%19] : memref<?xf32>
          memref.store %44, %arg14[%19] : memref<?xf32>
          %45 = memref.load %arg15[%19] : memref<?xf32>
          memref.store %45, %arg13[%19] : memref<?xf32>
          %46 = memref.load %arg17[%19] : memref<?xf32>
          %47 = memref.load %arg13[%19] : memref<?xf32>
          %48 = arith.addf %46, %47 : f32
          memref.store %48, %arg16[%19] : memref<?xf32>
          %49 = memref.load %arg7[%19] : memref<?xf32>
          memref.store %49, %arg8[%19] : memref<?xf32>
          %50 = memref.load %arg9[%19] : memref<?xf32>
          memref.store %50, %arg7[%19] : memref<?xf32>
          %51 = memref.load %arg10[%19] : memref<?xf32>
          memref.store %51, %arg11[%19] : memref<?xf32>
          %52 = memref.load %arg12[%19] : memref<?xf32>
          memref.store %52, %arg10[%19] : memref<?xf32>
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      %9 = memref.load %arg3[%c0] : memref<?xi32>
      %10 = memref.load %arg4[%c0] : memref<?xi32>
      %11 = arith.cmpi ne, %9, %10 : i32
      scf.if %11 {
        %12 = memref.load %3[%c0] : memref<1xi32>
        %13 = arith.index_cast %12 : i32 to index
        %14 = memref.load %6[%c0] : memref<1xi32>
        %15 = arith.index_cast %14 : i32 to index
        scf.parallel (%arg21, %arg22) = (%c0, %c0) to (%13, %15) step (%c8, %c32) {
          %24 = affine.min #map(%13, %arg21)
          %25 = affine.min #map1(%15, %arg22)
          scf.parallel (%arg23, %arg24) = (%c0, %c0) to (%24, %25) step (%c1, %c1) {
            %26 = arith.addi %arg23, %arg21 : index
            %27 = arith.addi %arg24, %arg22 : index
            %28 = memref.load %arg5[%c0] : memref<?xf32>
            %29 = arith.muli %26, %15 : index
            %30 = arith.addi %27, %29 : index
            %31 = memref.load %arg18[%30] : memref<?xf32>
            %32 = memref.load %arg13[%30] : memref<?xf32>
            %33 = arith.mulf %32, %28 : f32
            %34 = arith.addf %31, %33 : f32
            memref.store %34, %arg18[%30] : memref<?xf32>
            scf.reduce 
          } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        %16 = memref.load %3[%c0] : memref<1xi32>
        %17 = arith.index_cast %16 : i32 to index
        %18 = memref.load %6[%c0] : memref<1xi32>
        %19 = arith.index_cast %18 : i32 to index
        scf.parallel (%arg21, %arg22) = (%c0, %c1) to (%17, %19) step (%c8, %c32) {
          %24 = affine.min #map(%17, %arg21)
          %25 = affine.min #map1(%19, %arg22)
          scf.parallel (%arg23, %arg24) = (%c0, %c0) to (%24, %25) step (%c1, %c1) {
            %26 = arith.addi %arg23, %arg21 : index
            %27 = arith.addi %arg24, %arg22 : index
            %28 = memref.load %arg6[%c0] : memref<?xf32>
            %29 = arith.muli %26, %19 : index
            %30 = arith.addi %27, %29 : index
            %31 = memref.load %arg19[%30] : memref<?xf32>
            %32 = memref.load %arg7[%30] : memref<?xf32>
            %33 = memref.load %arg16[%30] : memref<?xf32>
            %34 = arith.addi %27, %c-1 : index
            %35 = arith.addi %34, %29 : index
            %36 = memref.load %arg16[%35] : memref<?xf32>
            %37 = arith.addf %33, %36 : f32
            %38 = arith.mulf %32, %37 : f32
            %39 = arith.mulf %38, %28 : f32
            %40 = arith.addf %31, %39 : f32
            memref.store %40, %arg19[%30] : memref<?xf32>
            scf.reduce 
          } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
        %20 = memref.load %3[%c0] : memref<1xi32>
        %21 = arith.index_cast %20 : i32 to index
        %22 = memref.load %6[%c0] : memref<1xi32>
        %23 = arith.index_cast %22 : i32 to index
        scf.parallel (%arg21, %arg22) = (%c1, %c0) to (%21, %23) step (%c8, %c32) {
          %24 = affine.min #map(%21, %arg21)
          %25 = affine.min #map1(%23, %arg22)
          scf.parallel (%arg23, %arg24) = (%c0, %c0) to (%24, %25) step (%c1, %c1) {
            %26 = arith.addi %arg23, %arg21 : index
            %27 = arith.addi %arg24, %arg22 : index
            %28 = memref.load %arg6[%c0] : memref<?xf32>
            %29 = arith.muli %26, %23 : index
            %30 = arith.addi %26, %c-1 : index
            %31 = arith.muli %30, %23 : index
            %32 = arith.addi %27, %29 : index
            %33 = memref.load %arg20[%32] : memref<?xf32>
            %34 = memref.load %arg10[%32] : memref<?xf32>
            %35 = memref.load %arg16[%32] : memref<?xf32>
            %36 = arith.addi %27, %31 : index
            %37 = memref.load %arg16[%36] : memref<?xf32>
            %38 = arith.addf %35, %37 : f32
            %39 = arith.mulf %34, %38 : f32
            %40 = arith.mulf %39, %28 : f32
            %41 = arith.addf %33, %40 : f32
            memref.store %41, %arg20[%32] : memref<?xf32>
            scf.reduce 
          } {mapping = [#gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
          scf.reduce 
        } {mapping = [#gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      }
    }
    return
  }
}


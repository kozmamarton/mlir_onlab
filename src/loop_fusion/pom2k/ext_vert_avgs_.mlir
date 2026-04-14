module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_vert_avgs_(%arg0: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "drx2d", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dry2d", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "aam2d", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "advx", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "advy", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "drhox", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "drhoy", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    scf.for %arg11 = %c0 to %2 step %c1 {
      scf.for %arg12 = %c0 to %5 step %c1 {
        %13 = arith.muli %arg11, %5 overflow<nsw> : index
        %14 = arith.addi %arg12, %13 : index
        memref.store %cst, %arg0[%14] : memref<?xf32>
        memref.store %cst, %arg1[%14] : memref<?xf32>
        memref.store %cst, %arg2[%14] : memref<?xf32>
        memref.store %cst, %arg3[%14] : memref<?xf32>
        memref.store %cst, %arg4[%14] : memref<?xf32>
      }
    }
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %0[%c0] : memref<1xi32>
    %10 = memref.load %3[%c0] : memref<1xi32>
    %11 = arith.index_cast %9 : i32 to index
    %12 = arith.index_cast %10 : i32 to index
    scf.for %arg11 = %c0 to %8 step %c1 {
      %13 = memref.load %arg10[%arg11] : memref<?xf32>
      scf.for %arg12 = %c0 to %11 step %c1 {
        scf.for %arg13 = %c0 to %12 step %c1 {
          %14 = arith.muli %arg12, %12 overflow<nsw> : index
          %15 = arith.addi %arg13, %14 : index
          %16 = arith.muli %arg11, %12 overflow<nsw> : index
          %17 = arith.muli %16, %11 overflow<nsw> : index
          %18 = arith.addi %15, %17 : index
          %19 = memref.load %arg5[%18] : memref<?xf32>
          %20 = arith.mulf %19, %13 : f32
          %21 = memref.load %arg0[%15] : memref<?xf32>
          %22 = arith.addf %21, %20 : f32
          memref.store %22, %arg0[%15] : memref<?xf32>
          %23 = memref.load %arg6[%18] : memref<?xf32>
          %24 = arith.mulf %23, %13 : f32
          %25 = memref.load %arg1[%15] : memref<?xf32>
          %26 = arith.addf %25, %24 : f32
          memref.store %26, %arg1[%15] : memref<?xf32>
          %27 = memref.load %arg7[%18] : memref<?xf32>
          %28 = arith.mulf %27, %13 : f32
          %29 = memref.load %arg2[%15] : memref<?xf32>
          %30 = arith.addf %29, %28 : f32
          memref.store %30, %arg2[%15] : memref<?xf32>
          %31 = memref.load %arg8[%18] : memref<?xf32>
          %32 = arith.mulf %31, %13 : f32
          %33 = memref.load %arg3[%15] : memref<?xf32>
          %34 = arith.addf %33, %32 : f32
          memref.store %34, %arg3[%15] : memref<?xf32>
          %35 = memref.load %arg9[%18] : memref<?xf32>
          %36 = arith.mulf %35, %13 : f32
          %37 = memref.load %arg4[%15] : memref<?xf32>
          %38 = arith.addf %37, %36 : f32
          memref.store %38, %arg4[%15] : memref<?xf32>
        }
      }
    }
    return
  }
}


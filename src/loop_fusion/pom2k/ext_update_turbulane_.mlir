module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_update_turbulane_(%arg0: memref<?xf32> {polygeist.name = "q2", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "q2b", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "q2l", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "q2lb", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = memref.load %arg6[%c0] : memref<?xf32>
    %8 = arith.index_cast %5 : i32 to index
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.mulf %7, %cst_0 : f32
    scf.for %arg7 = %c0 to %2 step %c1 {
      scf.for %arg8 = %c0 to %8 step %c1 {
        scf.for %arg9 = %c0 to %9 step %c1 {
          %11 = arith.muli %arg8, %9 overflow<nsw> : index
          %12 = arith.addi %arg9, %11 : index
          %13 = arith.muli %arg7, %9 overflow<nsw> : index
          %14 = arith.muli %13, %8 overflow<nsw> : index
          %15 = arith.addi %12, %14 : index
          %16 = memref.load %arg4[%15] : memref<?xf32>
          %17 = memref.load %arg1[%15] : memref<?xf32>
          %18 = arith.addf %16, %17 : f32
          %19 = memref.load %arg0[%15] : memref<?xf32>
          %20 = arith.mulf %19, %cst : f32
          %21 = arith.subf %18, %20 : f32
          %22 = arith.mulf %10, %21 : f32
          %23 = arith.addf %19, %22 : f32
          memref.store %23, %arg0[%15] : memref<?xf32>
          %24 = memref.load %arg5[%15] : memref<?xf32>
          %25 = memref.load %arg3[%15] : memref<?xf32>
          %26 = arith.addf %24, %25 : f32
          %27 = memref.load %arg2[%15] : memref<?xf32>
          %28 = arith.mulf %27, %cst : f32
          %29 = arith.subf %26, %28 : f32
          %30 = arith.mulf %10, %29 : f32
          %31 = arith.addf %27, %30 : f32
          memref.store %31, %arg2[%15] : memref<?xf32>
          %32 = memref.load %arg0[%15] : memref<?xf32>
          memref.store %32, %arg1[%15] : memref<?xf32>
          %33 = memref.load %arg4[%15] : memref<?xf32>
          memref.store %33, %arg0[%15] : memref<?xf32>
          %34 = memref.load %arg2[%15] : memref<?xf32>
          memref.store %34, %arg3[%15] : memref<?xf32>
          %35 = memref.load %arg5[%15] : memref<?xf32>
          memref.store %35, %arg2[%15] : memref<?xf32>
        }
      }
    }
    return
  }
}


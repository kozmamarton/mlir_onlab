module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_update_u_v_(%arg0: memref<?xf32> {polygeist.name = "tps", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "uf", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vf", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    scf.for %arg9 = %c0 to %2 step %c1 {
      scf.for %arg10 = %c0 to %5 step %c1 {
        %22 = arith.muli %arg9, %5 overflow<nsw> : index
        %23 = arith.addi %arg10, %22 : index
        memref.store %cst_1, %arg0[%23] : memref<?xf32>
      }
    }
    %6 = memref.get_global @kbm1 : memref<1xi32>
    %7 = memref.load %6[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %0[%c0] : memref<1xi32>
    %10 = memref.load %3[%c0] : memref<1xi32>
    %11 = memref.load %arg8[%c0] : memref<?xf32>
    %12 = arith.index_cast %9 : i32 to index
    %13 = arith.index_cast %10 : i32 to index
    %14 = arith.mulf %11, %cst_0 : f32
    scf.for %arg9 = %c0 to %8 step %c1 {
      scf.for %arg10 = %c0 to %12 step %c1 {
        scf.for %arg11 = %c0 to %13 step %c1 {
          %22 = arith.muli %arg10, %13 overflow<nsw> : index
          %23 = arith.addi %arg11, %22 : index
          %24 = arith.muli %arg9, %13 overflow<nsw> : index
          %25 = arith.muli %24, %12 overflow<nsw> : index
          %26 = arith.addi %23, %25 : index
          %27 = memref.load %arg5[%26] : memref<?xf32>
          %28 = memref.load %arg6[%26] : memref<?xf32>
          %29 = arith.addf %27, %28 : f32
          %30 = memref.load %arg4[%26] : memref<?xf32>
          %31 = arith.mulf %30, %cst : f32
          %32 = arith.subf %29, %31 : f32
          %33 = memref.load %arg0[%23] : memref<?xf32>
          %34 = arith.subf %32, %33 : f32
          %35 = arith.mulf %14, %34 : f32
          %36 = arith.addf %30, %35 : f32
          memref.store %36, %arg4[%26] : memref<?xf32>
        }
      }
    }
    %15 = memref.get_global @kb : memref<1xi32>
    %16 = memref.load %15[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.load %0[%c0] : memref<1xi32>
    %19 = memref.load %3[%c0] : memref<1xi32>
    %20 = arith.index_cast %18 : i32 to index
    %21 = arith.index_cast %19 : i32 to index
    scf.for %arg9 = %c0 to %17 step %c1 {
      scf.for %arg10 = %c0 to %20 step %c1 {
        scf.for %arg11 = %c0 to %21 step %c1 {
          %22 = arith.muli %arg10, %21 overflow<nsw> : index
          %23 = arith.addi %arg11, %22 : index
          %24 = arith.muli %arg9, %21 overflow<nsw> : index
          %25 = arith.muli %24, %20 overflow<nsw> : index
          %26 = arith.addi %23, %25 : index
          %27 = memref.load %arg1[%26] : memref<?xf32>
          memref.store %27, %arg3[%26] : memref<?xf32>
          %28 = memref.load %arg2[%26] : memref<?xf32>
          memref.store %28, %arg1[%26] : memref<?xf32>
          %29 = memref.load %arg4[%26] : memref<?xf32>
          memref.store %29, %arg6[%26] : memref<?xf32>
          %30 = memref.load %arg5[%26] : memref<?xf32>
          memref.store %30, %arg4[%26] : memref<?xf32>
        }
      }
    }
    return
  }
}


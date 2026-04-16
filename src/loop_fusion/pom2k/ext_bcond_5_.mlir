module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_bcond_5_(%arg0: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    scf.for %arg2 = %c0 to %2 step %c1 {
      scf.for %arg3 = %c0 to %7 step %c1 {
        scf.for %arg4 = %c0 to %8 step %c1 {
          %9 = arith.muli %arg3, %8 overflow<nsw> : index
          %10 = arith.addi %arg4, %9 : index
          %11 = arith.muli %arg2, %8 overflow<nsw> : index
          %12 = arith.muli %11, %7 overflow<nsw> : index
          %13 = arith.addi %10, %12 : index
          %14 = memref.load %arg0[%13] : memref<?xf32>
          %15 = memref.load %arg1[%10] : memref<?xf32>
          %16 = arith.mulf %14, %15 : f32
          memref.store %16, %arg0[%13] : memref<?xf32>
        }
      }
    }
    return
  }
}


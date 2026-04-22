module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_add_ad_2d_(%arg0: memref<?xf32> {polygeist.name = "adx2d", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ady2d", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "advua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "advva", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    scf.for %arg4 = %c0 to %2 step %c1 {
      scf.for %arg5 = %c0 to %5 step %c1 {
        %6 = arith.muli %arg4, %5 overflow<nsw> : index
        %7 = arith.addi %arg5, %6 : index
        %8 = memref.load %arg2[%7] : memref<?xf32>
        %9 = memref.load %arg0[%7] : memref<?xf32>
        %10 = arith.subf %9, %8 : f32
        memref.store %10, %arg0[%7] : memref<?xf32>
        %11 = memref.load %arg3[%7] : memref<?xf32>
        %12 = memref.load %arg1[%7] : memref<?xf32>
        %13 = arith.subf %12, %11 : f32
        memref.store %13, %arg1[%7] : memref<?xf32>
      }
    }
    return
  }
}


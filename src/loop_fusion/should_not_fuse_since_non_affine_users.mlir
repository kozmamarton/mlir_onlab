module {
  func.func @should_not_fuse_since_non_affine_users(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    %c0 = arith.constant 0 : index
    %c32 = arith.constant 32 : index
    %c1 = arith.constant 1 : index
    scf.parallel (%arg2) = (%c0) to (%c32) step (%c1) {
      %0 = memref.load %arg0[%arg2] : memref<32xf32>
      %1 = memref.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.addf %0, %1 : f32
      memref.store %2, %arg0[%arg2] : memref<32xf32>
      scf.reduce 
    }
    scf.for %arg2 = %c0 to %c32 step %c1 {
      %0 = memref.load %arg0[%arg2] : memref<32xf32>
      %1 = memref.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.subf %0, %1 : f32
      memref.store %2, %arg0[%arg2] : memref<32xf32>
    }
    scf.parallel (%arg2) = (%c0) to (%c32) step (%c1) {
      %0 = memref.load %arg0[%arg2] : memref<32xf32>
      %1 = memref.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.mulf %0, %1 : f32
      memref.store %2, %arg0[%arg2] : memref<32xf32>
      scf.reduce 
    }
    return
  }
}


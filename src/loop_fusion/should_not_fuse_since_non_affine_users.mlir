module {
  func.func @should_not_fuse_since_non_affine_users(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %0 = memref.load %arg0[%arg2] : memref<32xf32>
      %1 = memref.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.subf %0, %1 : f32
      memref.store %2, %arg0[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.mulf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    return
  }
}


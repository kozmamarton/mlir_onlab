module {
  func.func @should_fuse_reduction_to_pointwise() {
    %alloc = memref.alloc() : memref<1xf32>
    %alloc_0 = memref.alloc() : memref<10x10xf32>
    %alloc_1 = memref.alloc() : memref<10xf32>
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        %1 = affine.load %alloc[0] : memref<1xf32>
        %2 = affine.load %alloc_0[%arg0, %arg1] : memref<10x10xf32>
        %3 = arith.addf %1, %2 : f32
        affine.store %3, %alloc[0] : memref<1xf32>
      }
      %0 = affine.load %alloc[0] : memref<1xf32>
      affine.store %0, %alloc_1[%arg0] : memref<10xf32>
    }
    return
  }
}


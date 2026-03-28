module {
  func.func @should_fuse_reduction_to_pointwise() {
    %c1 = arith.constant 1 : index
    %c10 = arith.constant 10 : index
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() : memref<1xf32>
    %alloc_0 = memref.alloc() : memref<10x10xf32>
    scf.for %arg0 = %c0 to %c10 step %c1 {
      scf.for %arg1 = %c0 to %c10 step %c1 {
        %0 = memref.load %alloc[%c0] : memref<1xf32>
        %1 = memref.load %alloc_0[%arg0, %arg1] : memref<10x10xf32>
        %2 = arith.addf %0, %1 : f32
        memref.store %2, %alloc[%c0] : memref<1xf32>
      }
    }
    return
  }
}


module {
  func.func @should_fuse_reduction_to_pointwise() {
    %c1 = arith.constant 1 : index
    %c10 = arith.constant 10 : index
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() : memref<1xf32>
    %alloc_0 = memref.alloc() : memref<10x10xf32>
    scf.for %arg0 = %c0 to %c10 step %c1 {
      %0 = arith.addi %arg0, %c1 : index
      scf.parallel (%arg1) = (%arg0) to (%0) step (%c1) {
        scf.for %arg2 = %c0 to %c10 step %c1 {
          %1 = memref.load %alloc[%c0] : memref<1xf32>
          %2 = memref.load %alloc_0[%arg1, %arg2] : memref<10x10xf32>
          %3 = arith.addf %1, %2 : f32
          memref.store %3, %alloc[%c0] : memref<1xf32>
        }
        scf.reduce 
      }
    }
    return
  }
}


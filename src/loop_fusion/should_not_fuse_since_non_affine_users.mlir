module {
  func.func @should_not_fuse_since_non_affine_users(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    %c0 = arith.constant 0 : index
    %c32 = arith.constant 32 : index
    %c1 = arith.constant 1 : index
    scf.parallel (%arg2) = (%c0) to (%c32) step (%c1) {
      %0 = arith.addi %arg2, %c1 : index
      scf.parallel (%arg3) = (%arg2) to (%0) step (%c1) {
        %1 = memref.load %arg0[%arg3] : memref<32xf32>
        %2 = memref.load %arg1[%arg3] : memref<32xf32>
        %3 = arith.addf %1, %2 : f32
        memref.store %3, %arg0[%arg3] : memref<32xf32>
        scf.reduce 
      }
      scf.reduce 
    }
    scf.for %arg2 = %c0 to %c32 step %c1 {
      %0 = arith.addi %arg2, %c1 : index
      scf.for %arg3 = %arg2 to %0 step %c1 {
        %1 = memref.load %arg0[%arg3] : memref<32xf32>
        %2 = memref.load %arg1[%arg3] : memref<32xf32>
        %3 = arith.subf %1, %2 : f32
        memref.store %3, %arg0[%arg3] : memref<32xf32>
      }
    }
    scf.parallel (%arg2) = (%c0) to (%c32) step (%c1) {
      %0 = arith.addi %arg2, %c1 : index
      scf.parallel (%arg3) = (%arg2) to (%0) step (%c1) {
        %1 = memref.load %arg0[%arg3] : memref<32xf32>
        %2 = memref.load %arg1[%arg3] : memref<32xf32>
        %3 = arith.mulf %1, %2 : f32
        memref.store %3, %arg0[%arg3] : memref<32xf32>
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
}


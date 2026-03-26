module {
  func.func @should_fuse_at_depth_above_loop_carried_dependence(%arg0: memref<64x4xf32>, %arg1: memref<64x4xf32>) {
    %c15 = arith.constant 15 : index
    %c16 = arith.constant 16 : index
    %c64 = arith.constant 64 : index
    %c1 = arith.constant 1 : index
    %c4 = arith.constant 4 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<64x4xf32>
    scf.for %arg2 = %c0 to %c4 step %c1 {
      %0 = arith.addi %arg2, %c1 : index
      scf.for %arg3 = %arg2 to %0 step %c1 {
        scf.parallel (%arg4) = (%c0) to (%c64) step (%c1) {
          memref.store %cst, %alloc[%arg4, %arg3] : memref<64x4xf32>
          scf.reduce 
        }
        scf.for %arg4 = %c0 to %c4 step %c1 {
          scf.for %arg5 = %c0 to %c16 step %c1 {
            %1 = arith.muli %arg4, %c16 overflow<nsw> : index
            %2 = arith.subi %1, %arg5 : index
            %3 = arith.addi %2, %c15 : index
            %4 = memref.load %arg1[%3, %arg3] : memref<64x4xf32>
            "op0"(%4) : (f32) -> ()
          }
          scf.for %arg5 = %c0 to %c4 step %c1 {
            scf.for %arg6 = %c0 to %c16 step %c1 {
              %1 = arith.muli %arg5, %c16 overflow<nsw> : index
              %2 = arith.subi %1, %arg6 : index
              %3 = arith.addi %2, %c15 : index
              %4 = memref.load %arg0[%3, %arg4] : memref<64x4xf32>
              "op1"(%4) : (f32) -> ()
            }
            scf.for %arg6 = %c0 to %c16 step %c1 {
              %1 = "op2"() : () -> f32
              %2 = arith.muli %arg5, %c16 overflow<nsw> : index
              %3 = arith.addi %2, %arg6 : index
              %4 = memref.load %alloc[%3, %arg3] : memref<64x4xf32>
              %5 = arith.addf %4, %1 : f32
              memref.store %5, %alloc[%3, %arg3] : memref<64x4xf32>
            }
          }
        }
      }
    }
    return
  }
}


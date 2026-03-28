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
      scf.parallel (%arg3) = (%c0) to (%c64) step (%c1) {
        memref.store %cst, %alloc[%arg3, %arg2] : memref<64x4xf32>
        scf.reduce 
      }
      scf.for %arg3 = %c0 to %c4 step %c1 {
        scf.for %arg4 = %c0 to %c16 step %c1 {
          %0 = arith.muli %arg3, %c16 overflow<nsw> : index
          %1 = arith.subi %0, %arg4 : index
          %2 = arith.addi %1, %c15 : index
          %3 = memref.load %arg1[%2, %arg2] : memref<64x4xf32>
          "op0"(%3) : (f32) -> ()
        }
        scf.for %arg4 = %c0 to %c4 step %c1 {
          scf.for %arg5 = %c0 to %c16 step %c1 {
            %0 = arith.muli %arg4, %c16 overflow<nsw> : index
            %1 = arith.subi %0, %arg5 : index
            %2 = arith.addi %1, %c15 : index
            %3 = memref.load %arg0[%2, %arg3] : memref<64x4xf32>
            "op1"(%3) : (f32) -> ()
          }
          scf.for %arg5 = %c0 to %c16 step %c1 {
            %0 = "op2"() : () -> f32
            %1 = arith.muli %arg4, %c16 overflow<nsw> : index
            %2 = arith.addi %1, %arg5 : index
            %3 = memref.load %alloc[%2, %arg2] : memref<64x4xf32>
            %4 = arith.addf %3, %0 : f32
            memref.store %4, %alloc[%2, %arg2] : memref<64x4xf32>
          }
        }
      }
    }
    return
  }
}


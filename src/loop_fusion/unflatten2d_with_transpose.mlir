module {
  func.func @add_f32(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }
  func.func @unflatten2d_with_transpose(%arg0: memref<8x7xf32>) {
    %cst = arith.constant 7.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    scf.parallel (%arg1) = (%c0) to (%c8) step (%c1) {
      %c0_0 = arith.constant 0 : index
      %c7 = arith.constant 7 : index
      %c1_1 = arith.constant 1 : index
      scf.parallel (%arg2) = (%c0_0) to (%c7) step (%c1_1) {
        %c1_2 = arith.constant 1 : index
        %0 = arith.addi %arg1, %c1_2 : index
        %c1_3 = arith.constant 1 : index
        scf.parallel (%arg3) = (%arg1) to (%0) step (%c1_3) {
          %c1_4 = arith.constant 1 : index
          %1 = arith.addi %arg2, %c1_4 : index
          %c1_5 = arith.constant 1 : index
          scf.parallel (%arg4) = (%arg2) to (%1) step (%c1_5) {
            %c8_6 = arith.constant 8 : index
            %2 = arith.muli %arg4, %c8_6 overflow<nsw> : index
            %3 = arith.addi %2, %arg3 : index
            %c8_7 = arith.constant 8 : index
            %4 = arith.muli %arg4, %c8_7 overflow<nsw> : index
            %5 = arith.addi %arg3, %4 : index
            memref.store %cst, %arg0[%arg3, %arg4] : memref<8x7xf32>
            scf.reduce 
          }
          scf.reduce 
        }
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
  func.func @unflatten2d_wt_call() {
    %cst = arith.constant 7.000000e+00 : f32
    %alloc = memref.alloc() : memref<8x7xf32>
    %c0 = arith.constant 0 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    scf.parallel (%arg0) = (%c0) to (%c8) step (%c1) {
      %c0_0 = arith.constant 0 : index
      %c7 = arith.constant 7 : index
      %c1_1 = arith.constant 1 : index
      scf.parallel (%arg1) = (%c0_0) to (%c7) step (%c1_1) {
        %c1_2 = arith.constant 1 : index
        %0 = arith.addi %arg0, %c1_2 : index
        %c1_3 = arith.constant 1 : index
        scf.parallel (%arg2) = (%arg0) to (%0) step (%c1_3) {
          %c1_4 = arith.constant 1 : index
          %1 = arith.addi %arg1, %c1_4 : index
          %c1_5 = arith.constant 1 : index
          scf.parallel (%arg3) = (%arg1) to (%1) step (%c1_5) {
            %c8_6 = arith.constant 8 : index
            %2 = arith.muli %arg3, %c8_6 overflow<nsw> : index
            %3 = arith.addi %2, %arg2 : index
            %c8_7 = arith.constant 8 : index
            %4 = arith.muli %arg3, %c8_7 overflow<nsw> : index
            %5 = arith.addi %arg2, %4 : index
            memref.store %cst, %alloc[%arg2, %arg3] : memref<8x7xf32>
            scf.reduce 
          }
          scf.reduce 
        }
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
  func.func @unflattend2d_wt_call_indirect() {
    %cst = arith.constant 7.000000e+00 : f32
    %alloc = memref.alloc() : memref<8x7xf32>
    %c0 = arith.constant 0 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    scf.parallel (%arg0) = (%c0) to (%c8) step (%c1) {
      %c0_0 = arith.constant 0 : index
      %c7 = arith.constant 7 : index
      %c1_1 = arith.constant 1 : index
      scf.parallel (%arg1) = (%c0_0) to (%c7) step (%c1_1) {
        %c1_2 = arith.constant 1 : index
        %0 = arith.addi %arg0, %c1_2 : index
        %c1_3 = arith.constant 1 : index
        scf.parallel (%arg2) = (%arg0) to (%0) step (%c1_3) {
          %c1_4 = arith.constant 1 : index
          %1 = arith.addi %arg1, %c1_4 : index
          %c1_5 = arith.constant 1 : index
          scf.parallel (%arg3) = (%arg1) to (%1) step (%c1_5) {
            %c8_6 = arith.constant 8 : index
            %2 = arith.muli %arg3, %c8_6 overflow<nsw> : index
            %3 = arith.addi %2, %arg2 : index
            %c8_7 = arith.constant 8 : index
            %4 = arith.muli %arg3, %c8_7 overflow<nsw> : index
            %5 = arith.addi %arg2, %4 : index
            memref.store %cst, %alloc[%arg2, %arg3] : memref<8x7xf32>
            scf.reduce 
          }
          scf.reduce 
        }
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
}


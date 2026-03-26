module {
  func.func @add_f32(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }
  func.func @unflatten2d_with_transpose(%arg0: memref<8x7xf32>) {
    %c7 = arith.constant 7 : index
    %cst = arith.constant 7.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c8 = arith.constant 8 : index
    %c1 = arith.constant 1 : index
    scf.parallel (%arg1, %arg2) = (%c0, %c0) to (%c8, %c7) step (%c1, %c1) {
      %0 = arith.addi %arg1, %c1 : index
      scf.parallel (%arg3) = (%arg1) to (%0) step (%c1) {
        %1 = arith.addi %arg2, %c1 : index
        scf.parallel (%arg4) = (%arg2) to (%1) step (%c1) {
          memref.store %cst, %arg0[%arg3, %arg4] : memref<8x7xf32>
          scf.reduce 
        }
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
  func.func @unflatten2d_wt_call() {
    return
  }
  func.func @unflattend2d_wt_call_indirect() {
    return
  }
}


module {
  func.func @mul_add_0(%arg0: memref<3x4xf32>, %arg1: memref<4x3xf32>, %arg2: memref<3x3xf32>, %arg3: memref<3x3xf32>) {
    %c4 = arith.constant 4 : index
    %c1 = arith.constant 1 : index
    %c3 = arith.constant 3 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<1x1xf32>
    scf.for %arg4 = %c0 to %c3 step %c1 {
      scf.for %arg5 = %c0 to %c3 step %c1 {
        %0 = arith.addi %arg4, %c1 : index
        scf.parallel (%arg6) = (%arg4) to (%0) step (%c1) {
          %1 = arith.addi %arg5, %c1 : index
          scf.parallel (%arg7) = (%arg5) to (%1) step (%c1) {
            memref.store %cst, %alloc[%c0, %c0] : memref<1x1xf32>
            scf.for %arg8 = %c0 to %c4 step %c1 {
              %5 = memref.load %arg1[%arg8, %arg7] : memref<4x3xf32>
              %6 = memref.load %arg0[%arg6, %arg8] : memref<3x4xf32>
              %7 = arith.mulf %6, %5 : f32
              %8 = memref.load %alloc[%c0, %c0] : memref<1x1xf32>
              %9 = arith.addf %8, %7 : f32
              memref.store %9, %alloc[%c0, %c0] : memref<1x1xf32>
            }
            %2 = memref.load %arg2[%arg6, %arg7] : memref<3x3xf32>
            %3 = memref.load %alloc[%c0, %c0] : memref<1x1xf32>
            %4 = arith.addf %3, %2 : f32
            memref.store %4, %arg3[%arg6, %arg7] : memref<3x3xf32>
            scf.reduce 
          }
          scf.reduce 
        }
      }
    }
    return
  }
}


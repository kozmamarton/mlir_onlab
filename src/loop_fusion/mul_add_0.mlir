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
        memref.store %cst, %alloc[%c0, %c0] : memref<1x1xf32>
        scf.for %arg6 = %c0 to %c4 step %c1 {
          %3 = memref.load %arg1[%arg6, %arg5] : memref<4x3xf32>
          %4 = memref.load %arg0[%arg4, %arg6] : memref<3x4xf32>
          %5 = arith.mulf %4, %3 : f32
          %6 = memref.load %alloc[%c0, %c0] : memref<1x1xf32>
          %7 = arith.addf %6, %5 : f32
          memref.store %7, %alloc[%c0, %c0] : memref<1x1xf32>
        }
        %0 = memref.load %arg2[%arg4, %arg5] : memref<3x3xf32>
        %1 = memref.load %alloc[%c0, %c0] : memref<1x1xf32>
        %2 = arith.addf %1, %0 : f32
        memref.store %2, %arg3[%arg4, %arg5] : memref<3x3xf32>
      }
    }
    return
  }
}


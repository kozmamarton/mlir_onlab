module {
  func.func @mul_add_0(%arg0: memref<3x4xf32>, %arg1: memref<4x3xf32>, %arg2: memref<3x3xf32>, %arg3: memref<3x3xf32>) {
    %alloc = memref.alloc() : memref<1x1xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg4 = 0 to 3 {
      affine.for %arg5 = 0 to 3 {
        affine.store %cst, %alloc[0, 0] : memref<1x1xf32>
        affine.for %arg6 = 0 to 4 {
          %3 = affine.load %arg1[%arg6, %arg5] : memref<4x3xf32>
          %4 = affine.load %arg0[%arg4, %arg6] : memref<3x4xf32>
          %5 = arith.mulf %4, %3 : f32
          %6 = affine.load %alloc[0, 0] : memref<1x1xf32>
          %7 = arith.addf %6, %5 : f32
          affine.store %7, %alloc[0, 0] : memref<1x1xf32>
        }
        %0 = affine.load %arg2[%arg4, %arg5] : memref<3x3xf32>
        %1 = affine.load %alloc[0, 0] : memref<1x1xf32>
        %2 = arith.addf %1, %0 : f32
        affine.store %2, %arg3[%arg4, %arg5] : memref<3x3xf32>
      }
    }
    return
  }
}


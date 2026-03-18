#map = affine_map<(d0, d1) -> (d0 * 8 + d1)>
#map1 = affine_map<(d0, d1) -> (d0 + d1 * 8)>
module {
  func.func @unflatten2d_with_transpose(%arg0: memref<8x7xf32>) {
    %alloc = memref.alloc() : memref<1xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg1 = 0 to 8 {
      affine.for %arg2 = 0 to 7 {
        %0 = affine.apply #map(%arg2, %arg1)
        affine.store %cst, %alloc[0] : memref<1xf32>
        %1 = affine.apply #map1(%arg1, %arg2)
        %2 = affine.load %alloc[0] : memref<1xf32>
        affine.store %2, %arg0[%arg1, %arg2] : memref<8x7xf32>
      }
    }
    return
  }
}


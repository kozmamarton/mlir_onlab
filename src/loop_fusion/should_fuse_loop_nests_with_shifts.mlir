#map = affine_map<(d0) -> (d0 - 1)>
#map1 = affine_map<(d0, d1) -> (d0 + 1)>
#map2 = affine_map<(d0, d1) -> (d1 + 1)>
module {
  func.func @should_fuse_loop_nests_with_shifts() {
    %alloc = memref.alloc() : memref<1x1xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 1 to 10 {
      affine.for %arg1 = 1 to 10 {
        %0 = affine.apply #map(%arg0)
        %1 = affine.apply #map(%arg1)
        %2 = affine.apply #map1(%0, %1)
        %3 = affine.apply #map2(%0, %1)
        affine.store %cst, %alloc[0, 0] : memref<1x1xf32>
        %4 = affine.load %alloc[0, 0] : memref<1x1xf32>
      }
    }
    return
  }
}


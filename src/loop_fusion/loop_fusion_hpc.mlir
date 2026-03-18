module {
  func.func @should_fuse_reduction_to_pointwise() {
    %alloc = memref.alloc() : memref<1xf32>
    %alloc_0 = memref.alloc() : memref<10x10xf32>
    %alloc_1 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        %1 = affine.load %alloc[0] : memref<1xf32>
        %2 = affine.load %alloc_0[%arg0, %arg1] : memref<10x10xf32>
        %3 = arith.addf %1, %2 : f32
        affine.store %3, %alloc[0] : memref<1xf32>
      }
      %0 = affine.load %alloc[0] : memref<1xf32>
      affine.store %0, %alloc_1[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
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

// -----
module {
  func.func @should_fuse_at_depth_above_loop_carried_dependence(%arg0: memref<64x4xf32>, %arg1: memref<64x4xf32>) {
    %alloc = memref.alloc() : memref<64x4xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 64 {
        affine.store %cst, %alloc[%arg3, %arg2] : memref<64x4xf32>
      }
      affine.for %arg3 = 0 to 4 {
        affine.for %arg4 = 0 to 16 {
          %0 = affine.load %arg1[%arg3 * 16 - %arg4 + 15, %arg2] : memref<64x4xf32>
          "op0"(%0) : (f32) -> ()
        }
        affine.for %arg4 = 0 to 4 {
          affine.for %arg5 = 0 to 16 {
            %0 = affine.load %arg0[%arg4 * 16 - %arg5 + 15, %arg3] : memref<64x4xf32>
            "op1"(%0) : (f32) -> ()
          }
          affine.for %arg5 = 0 to 16 {
            %0 = "op2"() : () -> f32
            %1 = affine.load %alloc[%arg4 * 16 + %arg5, %arg2] : memref<64x4xf32>
            %2 = arith.addf %1, %0 : f32
            affine.store %2, %alloc[%arg4 * 16 + %arg5, %arg2] : memref<64x4xf32>
          }
        }
      }
    }
    return
  }
}

// -----
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

// -----
module {
  func.func @should_not_fuse_since_non_affine_users(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %0 = memref.load %arg0[%arg2] : memref<32xf32>
      %1 = memref.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.subf %0, %1 : f32
      memref.store %2, %arg0[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.mulf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    return
  }
}


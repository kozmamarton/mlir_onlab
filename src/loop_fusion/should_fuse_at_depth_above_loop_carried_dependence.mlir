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


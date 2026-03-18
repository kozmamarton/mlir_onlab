// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion))' | FileCheck %s

// Curated HPC-oriented affine loop fusion case adapted from llvm-project.
// Source: mlir/test/Dialect/Affine/loop-fusion-2.mlir.

// CHECK-LABEL: func @should_fuse_at_depth_above_loop_carried_dependence(%{{.*}}: memref<64x4xf32>, %{{.*}}: memref<64x4xf32>) {
func.func @should_fuse_at_depth_above_loop_carried_dependence(%arg0: memref<64x4xf32>, %arg1: memref<64x4xf32>) {
  %out = memref.alloc() : memref<64x4xf32>
  %0 = arith.constant 0.0 : f32
  affine.for %i0 = 0 to 64 {
    affine.for %i1 = 0 to 4 {
      affine.store %0, %out[%i0, %i1] : memref<64x4xf32>
    }
  }
  affine.for %i2 = 0 to 4 {
    affine.for %i3 = 0 to 4 {
      affine.for %i4 = 0 to 16 {
        %v = affine.load %arg1[16 * %i3 - %i4 + 15, %i2] : memref<64x4xf32>
        "op0"(%v) : (f32) -> ()
      }
      affine.for %i5 = 0 to 4 {
        affine.for %i6 = 0 to 16 {
          %v = affine.load %arg0[16 * %i5 - %i6 + 15, %i3] : memref<64x4xf32>
          "op1"(%v) : (f32) -> ()
        }
        affine.for %i7 = 0 to 16 {
          %r = "op2"() : () -> (f32)
          %v = affine.load %out[16 * %i5 + %i7, %i2] : memref<64x4xf32>
          %s = arith.addf %v, %r : f32
          affine.store %s, %out[16 * %i5 + %i7, %i2] : memref<64x4xf32>
        }
      }
    }
  }

  // CHECK:       memref.alloc() : memref<64x4xf32>
  // CHECK:       affine.for %{{.*}} = 0 to 4 {
  // CHECK-NEXT:    affine.for %{{.*}} = 0 to 64 {
  // CHECK-NEXT:      affine.store %{{.*}}, %{{.*}}[%{{.*}}, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:    }
  // CHECK-NEXT:    affine.for %{{.*}} = 0 to 4 {
  // CHECK-NEXT:      affine.for %{{.*}} = 0 to 16 {
  // CHECK-NEXT:        affine.load %{{.*}}[%{{.*}} * 16 - %{{.*}} + 15, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:        "op0"(%{{.*}}) : (f32) -> ()
  // CHECK-NEXT:      }
  // CHECK-NEXT:      affine.for %{{.*}} = 0 to 4 {
  // CHECK-NEXT:        affine.for %{{.*}} = 0 to 16 {
  // CHECK-NEXT:          affine.load %{{.*}}[%{{.*}} * 16 - %{{.*}} + 15, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:          "op1"(%{{.*}}) : (f32) -> ()
  // CHECK-NEXT:        }
  // CHECK-NEXT:        affine.for %{{.*}} = 0 to 16 {
  // CHECK-NEXT:          %{{.*}} = "op2"() : () -> f32
  // CHECK:               affine.load %{{.*}}[%{{.*}} * 16 + %{{.*}}, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:          arith.addf %{{.*}}, %{{.*}} : f32
  // CHECK:               affine.store %{{.*}}, %{{.*}}[%{{.*}} * 16 + %{{.*}}, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:        }
  // CHECK-NEXT:      }
  // CHECK-NEXT:    }
  // CHECK-NEXT:  }
  // CHECK-NEXT:  return
  return
}
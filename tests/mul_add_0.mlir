// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion))' | FileCheck %s

// Curated HPC-oriented affine loop fusion case adapted from llvm-project.
// Source: mlir/test/Dialect/Affine/loop-fusion-3.mlir.

// CHECK-LABEL: func @mul_add_0
func.func @mul_add_0(%arg0: memref<3x4xf32>, %arg1: memref<4x3xf32>, %arg2: memref<3x3xf32>, %arg3: memref<3x3xf32>) {
  %cst = arith.constant 0.000000e+00 : f32
  %0 = memref.alloc() : memref<3x3xf32>
  affine.for %arg4 = 0 to 3 {
    affine.for %arg5 = 0 to 3 {
      affine.store %cst, %0[%arg4, %arg5] : memref<3x3xf32>
    }
  }
  affine.for %arg4 = 0 to 3 {
    affine.for %arg5 = 0 to 3 {
      affine.for %arg6 = 0 to 4 {
        %1 = affine.load %arg1[%arg6, %arg5] : memref<4x3xf32>
        %2 = affine.load %arg0[%arg4, %arg6] : memref<3x4xf32>
        %3 = arith.mulf %2, %1 : f32
        %4 = affine.load %0[%arg4, %arg5] : memref<3x3xf32>
        %5 = arith.addf %4, %3 : f32
        affine.store %5, %0[%arg4, %arg5] : memref<3x3xf32>
      }
    }
  }
  affine.for %arg4 = 0 to 3 {
    affine.for %arg5 = 0 to 3 {
      %6 = affine.load %arg2[%arg4, %arg5] : memref<3x3xf32>
      %7 = affine.load %0[%arg4, %arg5] : memref<3x3xf32>
      %8 = arith.addf %7, %6 : f32
      affine.store %8, %arg3[%arg4, %arg5] : memref<3x3xf32>
    }
  }
  // CHECK:      affine.for %[[i0:.*]] = 0 to 3 {
  // CHECK-NEXT:   affine.for %[[i1:.*]] = 0 to 3 {
  // CHECK-NEXT:   affine.store %{{.*}}, %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:     affine.for %[[i2:.*]] = 0 to 4 {
  // CHECK-NEXT:       affine.load %{{.*}}[%[[i2]], %[[i1]]] : memref<4x3xf32>
  // CHECK-NEXT:       affine.load %{{.*}}[%[[i0]], %[[i2]]] : memref<3x4xf32>
  // CHECK-NEXT:       arith.mulf %{{.*}}, %{{.*}} : f32
  // CHECK-NEXT:       affine.load %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:       arith.addf %{{.*}}, %{{.*}} : f32
  // CHECK-NEXT:       affine.store %{{.*}}, %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:     }
  // CHECK-NEXT:     affine.load %{{.*}}[%[[i0]], %[[i1]]] : memref<3x3xf32>
  // CHECK-NEXT:     affine.load %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:     arith.addf %{{.*}}, %{{.*}} : f32
  // CHECK-NEXT:     affine.store %{{.*}}, %{{.*}}[%[[i0]], %[[i1]]] : memref<3x3xf32>
  // CHECK-NEXT:   }
  // CHECK-NEXT: }
  // CHECK-NEXT: return
  return
}
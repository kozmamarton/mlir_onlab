// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion{mode=producer}))' -split-input-file | FileCheck %s --check-prefix=PRODUCER-CONSUMER

// Curated layout-transform case adapted from llvm-project
// mlir/test/Dialect/Affine/loop-fusion-4.mlir.

// Expects fusion of producer into consumer at depth 2 and subsequent removal of
// source loop.
// PRODUCER-CONSUMER-LABEL: func @unflatten2d_with_transpose
func.func @unflatten2d_with_transpose(%arg1: memref<8x7xf32>) {
  %m = memref.alloc() : memref<56xf32>
  %cf7 = arith.constant 7.0 : f32

  affine.for %i0 = 0 to 7 {
    affine.for %i1 = 0 to 8 {
      affine.store %cf7, %m[8 * %i0 + %i1] : memref<56xf32>
    }
  }
  affine.for %i0 = 0 to 8 {
    affine.for %i1 = 0 to 7 {
      %v0 = affine.load %m[%i0 + 8 * %i1] : memref<56xf32>
      affine.store %v0, %arg1[%i0, %i1] : memref<8x7xf32>
    }
  }
  return
}

// PRODUCER-CONSUMER:        affine.for
// PRODUCER-CONSUMER-NEXT:     affine.for
// PRODUCER-CONSUMER-NOT:    affine.for
// PRODUCER-CONSUMER: return
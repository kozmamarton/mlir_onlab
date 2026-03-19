// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion{mode=producer}))' | FileCheck %s --check-prefix=PRODUCER-CONSUMER

// Curated layout-transform case adapted from llvm-project.
// Source: mlir/test/Dialect/Affine/loop-fusion-4.mlir.

// PRODUCER-CONSUMER-LABEL: func @unflatten2d_with_transpose
module {

  func.func @add_f32(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }

  func.func @unflatten2d_with_transpose(%arg1: memref<8x7xf32>)  {
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

  func.func @unflatten2d_wt_call() {
    %0 = memref.alloc() : memref<8x7xf32>
    call @unflatten2d_with_transpose(%0) : (memref<8x7xf32>) -> ()
    return
  }

  func.func @unflattend2d_wt_call_indirect() {
    %0 = memref.alloc() : memref<8x7xf32>
    %f = func.constant @unflatten2d_with_transpose : (memref<8x7xf32>) -> ()
    func.call_indirect %f(%0) : (memref<8x7xf32>) -> ()
    return
  }
}
// PRODUCER-CONSUMER:        affine.for
// PRODUCER-CONSUMER-NEXT:     affine.for
// PRODUCER-CONSUMER-NOT:    affine.for
// PRODUCER-CONSUMER: return
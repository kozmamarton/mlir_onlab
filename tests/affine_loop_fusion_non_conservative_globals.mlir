// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s

// Two memref.get_global ops of one symbol return the same memory, so a write
// through one and a read through the other is a RAW conflict.
// CHECK-LABEL: func @same_global_two_get_globals
// CHECK:       affine.for
// CHECK:       affine.for
memref.global "private" @g : memref<10xf32> = dense<0.0>
func.func @same_global_two_get_globals(%b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  %g1 = memref.get_global @g : memref<10xf32>
  %g2 = memref.get_global @g : memref<10xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %g1[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    %v = affine.load %g2[9 - %i] : memref<10xf32>
    affine.store %v, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// Distinct globals never overlap.
// CHECK-LABEL: func @distinct_globals
// CHECK:       affine.for
// CHECK-NOT:   affine.for
memref.global "private" @g : memref<10xf32> = dense<0.0>
memref.global "private" @h : memref<10xf32> = dense<0.0>
func.func @distinct_globals(%b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  %g = memref.get_global @g : memref<10xf32>
  %h = memref.get_global @h : memref<10xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %g[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    %v = affine.load %h[9 - %i] : memref<10xf32>
    affine.store %v, %b[%i] : memref<10xf32>
  }
  return
}

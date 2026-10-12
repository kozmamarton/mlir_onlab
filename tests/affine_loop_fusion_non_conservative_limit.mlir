// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s --check-prefix=LIM2
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="max-fused-loops=3" -split-input-file | FileCheck %s --check-prefix=LIM3
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="max-fused-loops=1" -split-input-file | FileCheck %s --check-prefix=LIM1

// Three independent loops.
// LIM2-LABEL: func @three_loops
// LIM2:       affine.for
// LIM2:       affine.for
// LIM2-NOT:   affine.for
// LIM3-LABEL: func @three_loops
// LIM3:       affine.for
// LIM3-NOT:   affine.for
// LIM1-LABEL: func @three_loops
// LIM1:       affine.for
// LIM1:       affine.for
// LIM1:       affine.for
func.func @three_loops(%a: memref<10xf32>, %b: memref<10xf32>, %d: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %d[%i] : memref<10xf32>
  }
  return
}

// -----

// Four loops with the default limit form two fused groups of two.
// LIM2-LABEL: func @four_loops
// LIM2:       affine.for
// LIM2:       affine.for
// LIM2-NOT:   affine.for
// LIM3-LABEL: func @four_loops
// LIM3:       affine.for
// LIM3:       affine.for
// LIM3-NOT:   affine.for
// LIM1-LABEL: func @four_loops
// LIM1-COUNT-4: affine.for
func.func @four_loops(%a: memref<10xf32>, %b: memref<10xf32>,
                      %d: memref<10xf32>, %e: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %d[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %e[%i] : memref<10xf32>
  }
  return
}

// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="alias-conservative=true" -split-input-file | FileCheck %s --check-prefix=ALIAS

// Matching outer loops fuse; the inner loops become siblings and fuse as well
// (the limit applies per resulting loop, not per nest).
// CHECK-LABEL: func @nests_matching_outer
// CHECK:       affine.for
// CHECK-NEXT:    affine.for
// CHECK-NOT:   affine.for
func.func @nests_matching_outer(%a: memref<10x10xf32>, %b: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %b[%i, %j] : memref<10x10xf32>
    }
  }
  return
}

// -----

// Inner loops inside separate guard regions are not siblings and stay separate.
// CHECK-LABEL: func @nests_mismatched_outer
// CHECK:       affine.for
// CHECK:         affine.for
// CHECK:         affine.if
// CHECK:           affine.for
func.func @nests_mismatched_outer(%a: memref<10x10xf32>, %b: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 1 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %b[%i, %j] : memref<10x10xf32>
    }
  }
  return
}

// -----

// Loops in different regions are handled independently.
// CHECK-LABEL: func @independent_regions
// CHECK:       affine.for
// CHECK-NOT:   affine.for
// CHECK:       affine.if
// CHECK:         affine.for
// CHECK-NOT:     affine.for
func.func @independent_regions(%a: memref<10xf32>, %b: memref<10xf32>,
                               %d: memref<10xf32>, %e: memref<10xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  affine.if affine_set<()[s0] : (s0 - 1 >= 0)>()[%n] {
    affine.for %i = 0 to 10 {
      affine.store %c, %d[%i] : memref<10xf32>
    }
    affine.for %i = 0 to 10 {
      affine.store %c, %e[%i] : memref<10xf32>
    }
  }
  return
}

// -----

// Loops carrying iter_args / results are skipped.
// CHECK-LABEL: func @iter_args_skipped
// CHECK:       affine.for
// CHECK:       affine.for
func.func @iter_args_skipped(%a: memref<10xf32>) -> f32 {
  %c = arith.constant 1.0 : f32
  %s = affine.for %i = 0 to 10 iter_args(%acc = %c) -> f32 {
    %v = affine.load %a[%i] : memref<10xf32>
    %n = arith.addf %acc, %v : f32
    affine.yield %n : f32
  }
  affine.for %i = 0 to 10 {
    affine.store %s, %a[%i] : memref<10xf32>
  }
  return %s : f32
}

// -----

// A call inside a loop body is an unknown side effect.
// CHECK-LABEL: func @call_inside_skipped
// CHECK:       affine.for
// CHECK:       affine.for
func.func private @ext()
func.func @call_inside_skipped(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    func.call @ext() : () -> ()
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// Views of the same root are a conflict even when the SSA values differ.
// CHECK-LABEL: func @same_root_views
// CHECK:       affine.for
// CHECK:       affine.for
func.func @same_root_views(%flat: memref<100xf32>) {
  %c = arith.constant 1.0 : f32
  %v1 = memref.reinterpret_cast %flat to offset: [0], sizes: [10, 10], strides: [10, 1]
      : memref<100xf32> to memref<10x10xf32>
  %v2 = memref.reinterpret_cast %flat to offset: [0], sizes: [100], strides: [1]
      : memref<100xf32> to memref<100xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %v1[%i, %i] : memref<10x10xf32>
  }
  affine.for %i = 0 to 10 {
    %x = affine.load %v2[%i] : memref<100xf32>
    affine.store %x, %v2[%i] : memref<100xf32>
  }
  return
}

// -----

// Views of different roots are independent by default.
// CHECK-LABEL: func @different_root_views
// CHECK:       affine.for
// CHECK-NOT:   affine.for
// ALIAS-LABEL: func @different_root_views
// ALIAS:       affine.for
// ALIAS:       affine.for
func.func @different_root_views(%f1: memref<100xf32>, %f2: memref<100xf32>) {
  %c = arith.constant 1.0 : f32
  %v1 = memref.reinterpret_cast %f1 to offset: [0], sizes: [10, 10], strides: [10, 1]
      : memref<100xf32> to memref<10x10xf32>
  %v2 = memref.reinterpret_cast %f2 to offset: [0], sizes: [10, 10], strides: [10, 1]
      : memref<100xf32> to memref<10x10xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %v1[%i, %i] : memref<10x10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %v2[%i, %i] : memref<10x10xf32>
  }
  return
}

// -----

// Both loops only read distinct arguments: fused even in conservative mode.
// ALIAS-LABEL: func @conservative_read_only
// ALIAS:       affine.for
// ALIAS-NOT:   affine.for
// CHECK-LABEL: func @conservative_read_only
// CHECK:       affine.for
// CHECK-NOT:   affine.for
func.func @conservative_read_only(%a: memref<10xf32>, %b: memref<10xf32>) {
  affine.for %i = 0 to 10 {
    %x = affine.load %a[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    %x = affine.load %b[%i] : memref<10xf32>
  }
  return
}

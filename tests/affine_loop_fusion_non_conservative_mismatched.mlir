// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s

// Example one: loop1 0..n, loop2 1..n -> 0..n, guard i > 0 around code 2.
// CHECK-LABEL: func @lower_bound_differs
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK:         affine.store {{.*}}, %arg0[%[[I]]]
// CHECK:         affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @lower_bound_differs(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 1 to %n {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Example two: loop1 0..n, loop2 0..n-1 -> 0..n, guard i < n-1 around code 2.
// CHECK-LABEL: func @upper_bound_differs
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK:         affine.store {{.*}}, %arg0[%[[I]]]
// CHECK:         affine.if {{.*}}(%[[I]]
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @upper_bound_differs(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// The guarded loop may come first: the larger range is still used.
// CHECK-LABEL: func @smaller_loop_first
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK:         affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @smaller_loop_first(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 1 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Constant trip counts: 0..10 and 0..7 -> 0..10 with guard i < 7.
// CHECK-LABEL: func @constant_trip_counts
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK:         affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @constant_trip_counts(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 7 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// Both bounds of the contained loop differ: 0..10 and 1..9 -> both conditions.
// CHECK-LABEL: func @both_bounds_differ
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK:         affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @both_bounds_differ(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 1 to 9 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// Partial overlap (neither range contains the other) is not fused.
// CHECK-LABEL: func @partial_overlap
// CHECK:       affine.for
// CHECK:       affine.for
func.func @partial_overlap(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 1 to %n {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Different steps are not fused even when ranges are nested.
// CHECK-LABEL: func @mismatched_with_different_steps
// CHECK:       affine.for
// CHECK:       affine.for
func.func @mismatched_with_different_steps(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 step 2 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 1 to 9 step 1 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// A memory conflict blocks fusion regardless of the bounds.
// CHECK-LABEL: func @mismatched_with_conflict
// CHECK:       affine.for
// CHECK:       affine.for
func.func @mismatched_with_conflict(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  affine.for %i = 0 to %n {
    %v = affine.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  affine.for %i = 1 to %n {
    %v = affine.load %b[%i] : memref<?xf32>
    affine.store %v, %a[%i] : memref<?xf32>
  }
  return
}

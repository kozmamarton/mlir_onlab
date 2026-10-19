// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-war-waw=true" -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s --check-prefix=OFF
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-war-waw=true fuse-producer-consumer=true" -split-input-file | FileCheck %s --check-prefix=BOTH

// Both loops write A[i]: b's write stays the last one for every element.
// CHECK-LABEL: func @waw_same_iteration
// CHECK:       affine.for
// CHECK-NOT:   affine.for
// OFF-LABEL:   func @waw_same_iteration
// OFF:         affine.for
// OFF:         affine.for
func.func @waw_same_iteration(%a: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  %d = arith.constant 2.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    affine.store %d, %a[%i] : memref<?xf32>
  }
  return
}

// -----

// b writes A[i+1] at iteration i, before a writes it at i+1: a's value would
// win, so the fusion is denied.
// CHECK-LABEL: func @waw_later_overwrite
// CHECK:       affine.for
// CHECK:       affine.for
func.func @waw_later_overwrite(%a: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  %d = arith.constant 2.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    affine.store %d, %a[%i + 1] : memref<?xf32>
  }
  return
}

// -----

// A boundary write in b to an element a wrote in its first iteration.
// CHECK-LABEL: func @waw_boundary_after
// CHECK:       affine.for
// CHECK-NOT:   affine.for
func.func @waw_boundary_after(%a: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  %d = arith.constant 2.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    affine.store %d, %a[0] : memref<?xf32>
  }
  return
}

// -----

// a overwrites A[0] in every iteration; b's write to A[0] at i = 0 would be
// overwritten by later iterations of a.
// CHECK-LABEL: func @waw_repeated_writer
// CHECK:       affine.for
// CHECK:       affine.for
func.func @waw_repeated_writer(%a: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  %d = arith.constant 2.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[0] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    affine.store %d, %a[%i] : memref<?xf32>
  }
  return
}

// -----

// a reads A[i] before b overwrites it in the same iteration.
// CHECK-LABEL: func @war_same_iteration
// CHECK:       affine.for
// CHECK-NOT:   affine.for
// OFF-LABEL:   func @war_same_iteration
// OFF:         affine.for
// OFF:         affine.for
func.func @war_same_iteration(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    %v = affine.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  return
}

// -----

// a reads A[i+1] at iteration i; b overwrites it only at iteration i+1.
// CHECK-LABEL: func @war_read_ahead
// CHECK:       affine.for
// CHECK-NOT:   affine.for
func.func @war_read_ahead(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    %v = affine.load %a[%i + 1] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  affine.for %i = 0 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  return
}

// -----

// a reads A[i-1] at iteration i, but b already overwrote it at iteration i-1.
// CHECK-LABEL: func @war_read_behind
// CHECK:       affine.for
// CHECK:       affine.for
func.func @war_read_behind(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 1 to %n {
    %v = affine.load %a[%i - 1] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  return
}

// -----

// b updates in place what a produced (RAW + WAW): needs both options.
// CHECK-LABEL: func @raw_and_waw
// CHECK:       affine.for
// CHECK:       affine.for
// BOTH-LABEL:  func @raw_and_waw
// BOTH:        affine.for
// BOTH-NOT:    affine.for
func.func @raw_and_waw(%a: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %a[%i] : memref<?xf32>
    %w = arith.addf %v, %c : f32
    affine.store %w, %a[%i] : memref<?xf32>
  }
  return
}

// -----

// A non-affine write cannot be analysed.
// CHECK-LABEL: func @non_affine_write
// CHECK:       affine.for
// CHECK:       affine.for
// BOTH-LABEL:  func @non_affine_write
// BOTH:        affine.for
// BOTH:        affine.for
func.func @non_affine_write(%a: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    memref.store %c, %a[%i] : memref<?xf32>
  }
  return
}

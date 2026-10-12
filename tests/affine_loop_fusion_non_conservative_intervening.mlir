// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s

// Pure ops between the loops do not block fusion.
// CHECK-LABEL: func @pure_op_between
// CHECK:       arith.constant
// CHECK:       affine.for
// CHECK-NOT:   affine.for
func.func @pure_op_between(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  %d = arith.addf %c, %c : f32
  affine.for %i = 0 to 10 {
    affine.store %d, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// The fused loop is placed at the later loop; a bound apply that folds to %n is accepted.
// CHECK-LABEL: func @pure_op_defines_bound
// CHECK:       affine.for %{{.*}} = 0 to %arg2
// CHECK-NOT:   affine.for
func.func @pure_op_defines_bound(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  %m = affine.apply affine_map<()[s0] -> (s0)>()[%n]
  affine.for %i = 0 to %m {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// A store between the loops blocks fusion, even to an unrelated memref.
// CHECK-LABEL: func @store_between
// CHECK:       affine.for
// CHECK:       affine.store
// CHECK:       affine.for
func.func @store_between(%a: memref<10xf32>, %b: memref<10xf32>, %u: memref<1xf32>) {
  %c = arith.constant 1.0 : f32
  %z = arith.constant 0 : index
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  memref.store %c, %u[%z] : memref<1xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// A load between the loops counts as non-trivial.
// CHECK-LABEL: func @load_between
// CHECK:       affine.for
// CHECK:       memref.load
// CHECK:       affine.for
func.func @load_between(%a: memref<10xf32>, %b: memref<10xf32>, %u: memref<1xf32>) {
  %c = arith.constant 1.0 : f32
  %z = arith.constant 0 : index
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  %v = memref.load %u[%z] : memref<1xf32>
  affine.for %i = 0 to 10 {
    affine.store %v, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// A call between the loops blocks fusion.
// CHECK-LABEL: func @call_between
// CHECK:       affine.for
// CHECK:       call @ext
// CHECK:       affine.for
func.func private @ext()
func.func @call_between(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  func.call @ext() : () -> ()
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}


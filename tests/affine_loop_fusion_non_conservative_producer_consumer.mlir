// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-producer-consumer=true" -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s --check-prefix=OFF
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-producer-consumer=true fuse-mismatched-bounds=false" -split-input-file | FileCheck %s --check-prefix=NOMIS
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-producer-consumer=true max-fused-loops=3" -split-input-file | FileCheck %s --check-prefix=MAX3
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-producer-consumer=true alias-conservative=true" -split-input-file | FileCheck %s --check-prefix=ALIAS

// Matching bounds, b reads what a wrote in the same iteration.
// CHECK-LABEL: func @matching
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK-NEXT:    affine.store {{.*}}, %arg0[%[[I]]]
// CHECK-NEXT:    affine.load %arg0[%[[I]]]
// CHECK-NEXT:    affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
// The producer-consumer case is off by default.
// OFF-LABEL:   func @matching
// OFF:         affine.for
// OFF:         affine.for
func.func @matching(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// loop1 0..n, loop2 1..n-1 reading A[i-1] and A[i]: both were written at an
// earlier or the same iteration, so b is guarded and fused.
// CHECK-LABEL: func @stencil_backward
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK-NEXT:    affine.store {{.*}}, %arg0[%[[I]]]
// CHECK-NEXT:    affine.if {{.*}}(%[[I]])
// CHECK-NEXT:      affine.load %arg0[%[[I]] - 1]
// CHECK-NEXT:      affine.load %arg0[%[[I]]]
// CHECK:           affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
// NOMIS-LABEL: func @stencil_backward
// NOMIS:       affine.for
// NOMIS:       affine.for
func.func @stencil_backward(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 1 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    %v0 = affine.load %a[%i - 1] : memref<?xf32>
    %v1 = affine.load %a[%i] : memref<?xf32>
    %s = arith.addf %v0, %v1 : f32
    affine.store %s, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// The consumer has the larger range: the producer is guarded instead.
// CHECK-LABEL: func @consumer_contains_producer
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK-NEXT:    affine.if {{.*}}(%[[I]])
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.load %arg0[%[[I]]]
// CHECK-NEXT:    affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @consumer_contains_producer(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 1 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// b reads A[i+1], which a writes only in the next iteration.
// CHECK-LABEL: func @stencil_forward
// CHECK:       affine.for
// CHECK:       affine.for
func.func @stencil_forward(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 1 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    %v = affine.load %a[%i + 1] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Every iteration of a overwrites A[0]; b must see the last value.
// CHECK-LABEL: func @repeated_writer
// CHECK:       affine.for
// CHECK:       affine.for
func.func @repeated_writer(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[0] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %a[0] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// b also writes the produced memref (WAW): still denied.
// CHECK-LABEL: func @consumer_also_writes
// CHECK:       affine.for
// CHECK:       affine.for
func.func @consumer_also_writes(%a: memref<?xf32>, %n: index) {
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

// b writes what a reads (WAR) besides the RAW on %a: still denied.
// CHECK-LABEL: func @reverse_dependence
// CHECK:       affine.for
// CHECK:       affine.for
func.func @reverse_dependence(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  affine.for %i = 0 to %n {
    %v = affine.load %b[%i] : memref<?xf32>
    affine.store %v, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// The consumer reads through memref.load, which the analysis cannot see.
// CHECK-LABEL: func @non_affine_read
// CHECK:       affine.for
// CHECK:       affine.for
func.func @non_affine_read(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = memref.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// With alias-conservative=true, a write to %a and a read of %b may alias.
// That is not a same-root RAW pair, so it stays denied. By default the roots
// are distinct and there is no conflict at all.
// CHECK-LABEL: func @may_alias_roots
// CHECK:       affine.for
// CHECK-NOT:   affine.for
// ALIAS-LABEL: func @may_alias_roots
// ALIAS:       affine.for
// ALIAS:       affine.for
func.func @may_alias_roots(%a: memref<?xf32>, %b: memref<?xf32>, %out: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %b[%i] : memref<?xf32>
    affine.store %v, %out[%i] : memref<?xf32>
  }
  return
}

// -----

// 2D nests: legality is decided at the outer depth; the inner loops become
// siblings and fuse in the recursive step.
// CHECK-LABEL: func @nest_same_row
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK-NEXT:    affine.for %[[J:.*]] = 0 to %arg3 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]], %[[J]]]
// CHECK-NEXT:      affine.load %arg0[%[[I]], %[[J]]]
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]], %[[J]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @nest_same_row(%a: memref<?x?xf32>, %b: memref<?x?xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      affine.store %c, %a[%i, %j] : memref<?x?xf32>
    }
  }
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      %v = affine.load %a[%i, %j] : memref<?x?xf32>
      affine.store %v, %b[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// Reading the previous row of a 2D producer is legal at the outer depth. The
// guard is pushed into the inner loops, which then fuse as well.
// CHECK-LABEL: func @nest_previous_row
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK-NEXT:    affine.for %[[J:.*]] = 0 to %arg3 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]], %[[J]]]
// CHECK-NEXT:      affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:        affine.load %arg0[%[[I]] - 1, %[[J]]]
// CHECK-NEXT:        affine.store {{.*}}, %arg1[%[[I]], %[[J]]]
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @nest_previous_row(%a: memref<?x?xf32>, %b: memref<?x?xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      affine.store %c, %a[%i, %j] : memref<?x?xf32>
    }
  }
  affine.for %i = 1 to %n {
    affine.for %j = 0 to %m {
      %v = affine.load %a[%i - 1, %j] : memref<?x?xf32>
      affine.store %v, %b[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// Reading the next row is not.
// CHECK-LABEL: func @nest_next_row
// CHECK:       affine.for %{{.*}} = 0 to %arg2 {
// CHECK:       affine.for %{{.*}} = 0 to #{{.*}}()[%arg2] {
func.func @nest_next_row(%a: memref<?x?xf32>, %b: memref<?x?xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      affine.store %c, %a[%i, %j] : memref<?x?xf32>
    }
  }
  affine.for %i = 0 to affine_map<()[s0] -> (s0 - 1)>()[%n] {
    affine.for %j = 0 to %m {
      %v = affine.load %a[%i + 1, %j] : memref<?x?xf32>
      affine.store %v, %b[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// A transposed read reaches rows written in later outer iterations.
// CHECK-LABEL: func @nest_transpose
// CHECK:       affine.for
// CHECK:       affine.for
// CHECK:       affine.for
// CHECK:       affine.for
func.func @nest_transpose(%a: memref<?x?xf32>, %b: memref<?x?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %n {
      affine.store %c, %a[%i, %j] : memref<?x?xf32>
    }
  }
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %n {
      %v = affine.load %a[%j, %i] : memref<?x?xf32>
      affine.store %v, %b[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// Flat buffer accessed through two identical reinterpret_cast views, as
// produced by reinterpret-flat-array-access.
// CHECK-LABEL: func @equivalent_views
// CHECK:       affine.for
// CHECK:         affine.for
// CHECK:           affine.store
// CHECK-NEXT:      affine.load
// CHECK-NOT:   affine.for
func.func @equivalent_views(%flat: memref<?xf32>, %b: memref<?x?xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  %v1 = memref.reinterpret_cast %flat to offset: [0], sizes: [%n, %m], strides: [%m, 1]
      : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      affine.store %c, %v1[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
    }
  }
  %v2 = memref.reinterpret_cast %flat to offset: [0], sizes: [%n, %m], strides: [%m, 1]
      : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      %v = affine.load %v2[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
      affine.store %v, %b[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// Views with different strides index the buffer differently: denied.
// CHECK-LABEL: func @different_views
// CHECK:       affine.for
// CHECK:       affine.for
// CHECK:       affine.for
// CHECK:       affine.for
func.func @different_views(%flat: memref<?xf32>, %b: memref<?x?xf32>, %n: index, %m: index, %k: index) {
  %c = arith.constant 1.0 : f32
  %v1 = memref.reinterpret_cast %flat to offset: [0], sizes: [%n, %m], strides: [%m, 1]
      : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      affine.store %c, %v1[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
    }
  }
  %v2 = memref.reinterpret_cast %flat to offset: [0], sizes: [%n, %m], strides: [%k, 1]
      : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  affine.for %i = 0 to %n {
    affine.for %j = 0 to %m {
      %v = affine.load %v2[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
      affine.store %v, %b[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// A producer chain obeys max-fused-loops: (L1 L2) L3 by default, one loop
// with max-fused-loops=3.
// CHECK-LABEL: func @chain
// CHECK:       affine.for
// CHECK:       affine.for
// CHECK-NOT:   affine.for
// MAX3-LABEL:  func @chain
// MAX3:        affine.for
// MAX3-NOT:    affine.for
func.func @chain(%a: memref<?xf32>, %b: memref<?xf32>, %out: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    %v = affine.load %b[%i] : memref<?xf32>
    affine.store %v, %out[%i] : memref<?xf32>
  }
  return
}

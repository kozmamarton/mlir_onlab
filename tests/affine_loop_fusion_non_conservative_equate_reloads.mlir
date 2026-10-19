// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="equate-reloads=true fuse-across-intervening-ops=true fuse-producer-consumer=true" -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-across-intervening-ops=true fuse-producer-consumer=true" -split-input-file | FileCheck %s --check-prefix=OFF

// Each loop's bound is re-loaded from the same global; nothing writes it, so
// the bounds are equal and the loops fuse with the first loop's bound.
// CHECK-LABEL: func @reloaded_bound
// CHECK:       affine.for %{{.*}} = 0 to %[[N:.*]] {
// CHECK-NOT:   affine.for
// OFF-LABEL:   func @reloaded_bound
// OFF:         affine.for
// OFF:         affine.for
memref.global "private" @n : memref<1xi32> = dense<10>
func.func @reloaded_bound(%a: memref<?xf32>, %b: memref<?xf32>) {
  %c = arith.constant 1.0 : f32
  %g = memref.get_global @n : memref<1xi32>
  %x = affine.load %g[0] : memref<1xi32>
  %n1 = arith.index_cast %x : i32 to index
  affine.for %i = 0 to %n1 {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  %y = affine.load %g[0] : memref<1xi32>
  %n2 = arith.index_cast %y : i32 to index
  affine.for %i = 0 to %n2 {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// The same, re-fetching the global with a second get_global and with a
// constant offset between the ranges: the shorter loop is guarded.
// CHECK-LABEL: func @reloaded_bound_offset
// CHECK:       affine.for %[[I:.*]] = 0 to
// CHECK:         affine.if {{.*}}(%[[I]])
// CHECK-NOT:   affine.for
memref.global "private" @n : memref<1xi32> = dense<10>
func.func @reloaded_bound_offset(%a: memref<?xf32>, %b: memref<?xf32>) {
  %c = arith.constant 1.0 : f32
  %g1 = memref.get_global @n : memref<1xi32>
  %x = affine.load %g1[0] : memref<1xi32>
  %n1 = arith.index_cast %x : i32 to index
  affine.for %i = 0 to %n1 {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  %g2 = memref.get_global @n : memref<1xi32>
  %y = affine.load %g2[0] : memref<1xi32>
  %n2 = arith.index_cast %y : i32 to index
  affine.for %i = 1 to %n2 {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// A write to the global between the two loads: they may differ.
// CHECK-LABEL: func @write_between_loads
// CHECK:       affine.for
// CHECK:       affine.for
memref.global "private" @n : memref<1xi32> = dense<10>
func.func @write_between_loads(%a: memref<?xf32>, %b: memref<?xf32>) {
  %c = arith.constant 1.0 : f32
  %k = arith.constant 5 : i32
  %g = memref.get_global @n : memref<1xi32>
  %x = affine.load %g[0] : memref<1xi32>
  %n1 = arith.index_cast %x : i32 to index
  affine.store %k, %g[0] : memref<1xi32>
  %y = affine.load %g[0] : memref<1xi32>
  %n2 = arith.index_cast %y : i32 to index
  affine.for %i = 0 to %n1 {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n2 {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Different indices of the same memref are different values.
// CHECK-LABEL: func @different_index
// CHECK:       affine.for
// CHECK:       affine.for
func.func @different_index(%a: memref<?xf32>, %b: memref<?xf32>, %d: memref<2xi32>) {
  %c = arith.constant 1.0 : f32
  %x = affine.load %d[0] : memref<2xi32>
  %n1 = arith.index_cast %x : i32 to index
  %y = affine.load %d[1] : memref<2xi32>
  %n2 = arith.index_cast %y : i32 to index
  affine.for %i = 0 to %n1 {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n2 {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Producer-consumer through reinterpret_cast views whose sizes are re-loaded
// per loop (as reinterpret-flat-array-access emits them): the views are
// equivalent only with equate-reloads.
// CHECK-LABEL: func @reloaded_views
// CHECK:       affine.for
// CHECK:         affine.for
// CHECK:           affine.store
// CHECK:           affine.load
// CHECK-NOT:   affine.for %{{.*}} = 0 to %{{.*}} {
// OFF-LABEL:   func @reloaded_views
// OFF:         affine.for
// OFF:           affine.for
// OFF:         affine.for
// OFF:           affine.for
memref.global "private" @n : memref<1xi32> = dense<10>
func.func @reloaded_views(%a: memref<?xf32>, %b: memref<?xf32>) {
  %c = arith.constant 1.0 : f32
  %g = memref.get_global @n : memref<1xi32>
  %x = affine.load %g[0] : memref<1xi32>
  %n1 = arith.index_cast %x : i32 to index
  %va = memref.reinterpret_cast %a to offset: [0], sizes: [%n1, %n1], strides: [%n1, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  affine.for %i = 0 to %n1 {
    affine.for %j = 0 to %n1 {
      affine.store %c, %va[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
    }
  }
  %y = affine.load %g[0] : memref<1xi32>
  %n2 = arith.index_cast %y : i32 to index
  %va2 = memref.reinterpret_cast %a to offset: [0], sizes: [%n2, %n2], strides: [%n2, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  %vb = memref.reinterpret_cast %b to offset: [0], sizes: [%n2, %n2], strides: [%n2, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  affine.for %i = 0 to %n2 {
    affine.for %j = 0 to %n2 {
      %v = affine.load %va2[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
      affine.store %v, %vb[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
    }
  }
  return
}

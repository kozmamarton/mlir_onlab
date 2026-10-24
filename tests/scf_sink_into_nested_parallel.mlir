// RUN: tutorial-opt %s --scf-sink-into-nested-parallel -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --scf-sink-into-nested-parallel --canonicalize -split-input-file | FileCheck %s --check-prefix=MERGE
// RUN: tutorial-opt %s --scf-sink-into-nested-parallel="alias-conservative=true" -split-input-file | FileCheck %s --check-prefix=ALIAS

// Loads and arithmetic of the outer iteration (pom2k profu: dz[k] * dzz[k])
// move into the nested loop, which canonicalization then merges.
// CHECK-LABEL: func @outer_only_ops
// CHECK:       scf.parallel (%[[I:.*]]) =
// CHECK-NEXT:    scf.parallel (%[[J:.*]], %[[L:.*]]) =
// CHECK-NEXT:      memref.load %arg0[%[[I]]]
// CHECK-NEXT:      memref.load %arg1[%[[I]]]
// CHECK-NEXT:      arith.mulf
// CHECK-NEXT:      memref.load %arg3[%[[J]], %[[L]]]
// MERGE-LABEL: func @outer_only_ops
// MERGE:       scf.parallel (%{{.*}}, %{{.*}}, %{{.*}}) =
// MERGE-NOT:   scf.parallel
// ALIAS-LABEL: func @outer_only_ops
// ALIAS:       scf.parallel
// ALIAS-NEXT:    memref.load
func.func @outer_only_ops(%dz: memref<?xf32>, %dzz: memref<?xf32>, %a: memref<?x?x?xf32>, %d: memref<?x?xf32>, %k: index, %n: index, %m: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  scf.parallel (%i) = (%c0) to (%k) step (%c1) {
    %x = memref.load %dz[%i] : memref<?xf32>
    %y = memref.load %dzz[%i] : memref<?xf32>
    %p = arith.mulf %x, %y : f32
    scf.parallel (%j, %l) = (%c0, %c0) to (%n, %m) step (%c1, %c1) {
      %v = memref.load %d[%j, %l] : memref<?x?xf32>
      %r = arith.mulf %p, %v : f32
      memref.store %r, %a[%i, %j, %l] : memref<?x?x?xf32>
    }
  }
  return
}

// -----

// Ops are sunk through a whole perfect chain into the innermost loop.
// CHECK-LABEL: func @chain
// CHECK:       scf.parallel (%[[I:.*]]) =
// CHECK-NEXT:    scf.parallel (%[[J:.*]]) =
// CHECK-NEXT:      scf.parallel
// CHECK-NEXT:        memref.load %arg0[%[[I]]]
// CHECK-NEXT:        memref.load %arg1[%[[J]]]
// CHECK-NEXT:        arith.addf
// CHECK-NEXT:        memref.store
// MERGE-LABEL: func @chain
// MERGE:       scf.parallel (%{{.*}}, %{{.*}}, %{{.*}}) =
// MERGE-NOT:   scf.parallel
func.func @chain(%dz: memref<?xf32>, %dy: memref<?xf32>, %a: memref<?x?x?xf32>, %k: index, %n: index, %m: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  scf.parallel (%i) = (%c0) to (%k) step (%c1) {
    %x = memref.load %dz[%i] : memref<?xf32>
    scf.parallel (%j) = (%c0) to (%n) step (%c1) {
      %y = memref.load %dy[%j] : memref<?xf32>
      %s = arith.addf %x, %y : f32
      scf.parallel (%l) = (%c0) to (%m) step (%c1) {
        memref.store %s, %a[%i, %j, %l] : memref<?x?x?xf32>
      }
    }
  }
  return
}

// -----

// A load from a memref that the nested loop writes stays outside.
// MERGE-LABEL: func @nested_writes_root
// CHECK-LABEL: func @nested_writes_root
// CHECK:       scf.parallel
// CHECK-NEXT:    memref.load
// CHECK-NEXT:    scf.parallel
func.func @nested_writes_root(%dz: memref<?xf32>, %k: index, %n: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  scf.parallel (%i) = (%c0) to (%k) step (%c1) {
    %x = memref.load %dz[%i] : memref<?xf32>
    scf.parallel (%j) = (%c0) to (%n) step (%c1) {
      memref.store %x, %dz[%j] : memref<?xf32>
    }
  }
  return
}

// -----

// Views of the written memref resolve to the same root.
// CHECK-LABEL: func @nested_writes_view
// CHECK:       scf.parallel
// CHECK-NEXT:    memref.load
// CHECK-NEXT:    scf.parallel
func.func @nested_writes_view(%flat: memref<?xf32>, %k: index, %n: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %v = memref.reinterpret_cast %flat to offset: [0], sizes: [%k, %n], strides: [%n, 1]
      : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  scf.parallel (%i) = (%c0) to (%k) step (%c1) {
    %x = memref.load %flat[%i] : memref<?xf32>
    scf.parallel (%j) = (%c0) to (%n) step (%c1) {
      memref.store %x, %v[%i, %j] : memref<?x?xf32, strided<[?, 1]>>
    }
  }
  return
}

// -----

// A store in the outer body cannot be repeated per inner iteration.
// CHECK-LABEL: func @outer_store
// CHECK:       scf.parallel
// CHECK-NEXT:    memref.store
// CHECK-NEXT:    scf.parallel
func.func @outer_store(%dz: memref<?xf32>, %a: memref<?x?xf32>, %k: index, %n: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %f = arith.constant 0.0 : f32
  scf.parallel (%i) = (%c0) to (%k) step (%c1) {
    memref.store %f, %dz[%i] : memref<?xf32>
    scf.parallel (%j) = (%c0) to (%n) step (%c1) {
      memref.store %f, %a[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// Nested bounds that use the outer induction variable cannot be merged, so
// nothing is sunk.
// CHECK-LABEL: func @triangular
// CHECK:       scf.parallel
// CHECK-NEXT:    memref.load
// CHECK-NEXT:    scf.parallel
func.func @triangular(%dz: memref<?xf32>, %a: memref<?x?xf32>, %k: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  scf.parallel (%i) = (%c0) to (%k) step (%c1) {
    %x = memref.load %dz[%i] : memref<?xf32>
    scf.parallel (%j) = (%c0) to (%i) step (%c1) {
      memref.store %x, %a[%i, %j] : memref<?x?xf32>
    }
  }
  return
}

// -----

// Reductions block the merge, so nothing is sunk.
// CHECK-LABEL: func @reduction
// CHECK:       scf.parallel
// CHECK-NEXT:    memref.load
// CHECK-NEXT:    scf.parallel
func.func @reduction(%dz: memref<?xf32>, %a: memref<?xf32>, %k: index, %n: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %zero = arith.constant 0.0 : f32
  scf.parallel (%i) = (%c0) to (%k) step (%c1) {
    %x = memref.load %dz[%i] : memref<?xf32>
    %s = scf.parallel (%j) = (%c0) to (%n) step (%c1) init (%zero) -> f32 {
      scf.reduce(%x : f32) {
      ^bb0(%l: f32, %r: f32):
        %t = arith.addf %l, %r : f32
        scf.reduce.return %t : f32
      }
    }
    memref.store %s, %a[%i] : memref<?xf32>
  }
  return
}

// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s

// CHECK-LABEL: func @disjoint_memrefs
// CHECK:       affine.for %[[I:.*]] = 0 to 100 {
// CHECK-NEXT:    affine.load %arg0[%[[I]]]
// CHECK:         affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    affine.load %arg2[%[[I]]]
// CHECK:         affine.store {{.*}}, %arg3[%[[I]]]
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @disjoint_memrefs(%a: memref<100xf32>, %b: memref<100xf32>,
                            %c: memref<100xf32>, %d: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    %v = affine.load %a[%i] : memref<100xf32>
    affine.store %v, %b[%i] : memref<100xf32>
  }
  affine.for %i = 0 to 100 {
    %v = affine.load %c[%i] : memref<100xf32>
    affine.store %v, %d[%i] : memref<100xf32>
  }
  return
}

// -----

// Read-read sharing of the input is allowed.
// CHECK-LABEL: func @shared_read_only_input
// CHECK:       affine.for
// CHECK-NOT:   affine.for
func.func @shared_read_only_input(%a: memref<100xf32>, %b: memref<100xf32>,
                                  %c: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    %v = affine.load %a[%i] : memref<100xf32>
    affine.store %v, %b[%i] : memref<100xf32>
  }
  affine.for %i = 0 to 100 {
    %v = affine.load %a[%i] : memref<100xf32>
    affine.store %v, %c[%i] : memref<100xf32>
  }
  return
}

// -----

// RAW: the second loop reads what the first writes.
// CHECK-LABEL: func @raw_conflict
// CHECK:       affine.for
// CHECK:       affine.for
func.func @raw_conflict(%a: memref<100xf32>, %b: memref<100xf32>,
                        %c: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    %v = affine.load %a[%i] : memref<100xf32>
    affine.store %v, %b[%i] : memref<100xf32>
  }
  affine.for %i = 0 to 100 {
    %v = affine.load %b[%i] : memref<100xf32>
    affine.store %v, %c[%i] : memref<100xf32>
  }
  return
}

// -----

// WAR: the second loop overwrites what the first reads.
// CHECK-LABEL: func @war_conflict
// CHECK:       affine.for
// CHECK:       affine.for
func.func @war_conflict(%a: memref<100xf32>, %b: memref<100xf32>,
                        %c: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    %v = affine.load %a[%i] : memref<100xf32>
    affine.store %v, %b[%i] : memref<100xf32>
  }
  affine.for %i = 0 to 100 {
    %v = affine.load %c[%i] : memref<100xf32>
    affine.store %v, %a[%i] : memref<100xf32>
  }
  return
}

// -----

// WAW: both loops write the same memref.
// CHECK-LABEL: func @waw_conflict
// CHECK:       affine.for
// CHECK:       affine.for
func.func @waw_conflict(%a: memref<100xf32>, %b: memref<100xf32>,
                        %c: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    %v = affine.load %a[%i] : memref<100xf32>
    affine.store %v, %c[%i] : memref<100xf32>
  }
  affine.for %i = 0 to 100 {
    %v = affine.load %b[%i] : memref<100xf32>
    affine.store %v, %c[%i] : memref<100xf32>
  }
  return
}

// -----

// Conflicts are detected per memref, not per index: even disjoint constant
// indices of the same memref are a conflict.
// CHECK-LABEL: func @same_memref_disjoint_indices
// CHECK:       affine.for
// CHECK:       affine.for
func.func @same_memref_disjoint_indices(%a: memref<200xf32>, %b: memref<100xf32>) {
  affine.for %i = 0 to 100 {
    %v = affine.load %b[%i] : memref<100xf32>
    affine.store %v, %a[%i] : memref<200xf32>
  }
  affine.for %i = 0 to 100 {
    %v = affine.load %b[%i] : memref<100xf32>
    affine.store %v, %a[%i + 100] : memref<200xf32>
  }
  return
}

// -----

// Equal non-unit steps are fused.
// CHECK-LABEL: func @equal_steps
// CHECK:       affine.for %{{.*}} = 0 to 100 step 2
// CHECK-NOT:   affine.for
func.func @equal_steps(%a: memref<100xf32>, %b: memref<100xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 100 step 2 {
    affine.store %c, %a[%i] : memref<100xf32>
  }
  affine.for %i = 0 to 100 step 2 {
    affine.store %c, %b[%i] : memref<100xf32>
  }
  return
}

// -----

// CHECK-LABEL: func @different_steps
// CHECK:       affine.for
// CHECK:       affine.for
func.func @different_steps(%a: memref<100xf32>, %b: memref<100xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 100 step 2 {
    affine.store %c, %a[%i] : memref<100xf32>
  }
  affine.for %i = 0 to 100 step 4 {
    affine.store %c, %b[%i] : memref<100xf32>
  }
  return
}

// -----

// Same symbolic bound operands.
// CHECK-LABEL: func @symbolic_same_bound
// CHECK:       affine.for %{{.*}} = 0 to %arg2
// CHECK-NOT:   affine.for
func.func @symbolic_same_bound(%a: memref<?xf32>, %b: memref<?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %n {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Different symbolic operands: the bound difference is not a constant.
// CHECK-LABEL: func @symbolic_different_bound
// CHECK:       affine.for
// CHECK:       affine.for
func.func @symbolic_different_bound(%a: memref<?xf32>, %b: memref<?xf32>,
                                    %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %m {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

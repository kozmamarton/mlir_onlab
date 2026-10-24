// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="require-perfect-nests=true" -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s --check-prefix=OFF
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="require-perfect-nests=true fuse-symbolic-bounds=true" -split-input-file | FileCheck %s --check-prefix=SYM

// The inner loops cannot fuse (different steps), so the outer fusion would
// leave two loops in one body: it is undone and both nests are restored in
// place, around the op between them.
// CHECK-LABEL: func @inner_rejected
// CHECK:       affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NEXT:  arith.addi
// CHECK-NEXT:  affine.for %{{.*}} = 1 to 10 {
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 step 2 {
// CHECK-NEXT:      affine.store {{.*}}, %arg1
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.if
// OFF-LABEL:   func @inner_rejected
// OFF:         affine.for %{{.*}} = 0 to 10 {
// OFF:           affine.if
// OFF-NEXT:        affine.for %{{.*}} = 0 to 10 step 2 {
func.func @inner_rejected(%a: memref<10x10xf32>, %b: memref<10x10xf32>, %n: index) -> index {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
  }
  %m = arith.addi %n, %n : index
  affine.for %i = 1 to 10 {
    affine.for %j = 0 to 10 step 2 {
      affine.store %c, %b[%i, %j] : memref<10x10xf32>
    }
  }
  return %m : index
}

// -----

// Nests that fuse all the way down are kept.
// CHECK-LABEL: func @perfect_kept
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0
// CHECK-NEXT:      affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:        affine.store {{.*}}, %arg1
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @perfect_kept(%a: memref<10x10xf32>, %b: memref<10x10xf32>) {
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

// After L1 L2 is undone, L2 still fuses with L3.
// CHECK-LABEL: func @chain
// CHECK:       affine.for
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 step 2 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NEXT:  affine.for
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:      affine.store {{.*}}, %arg1
// CHECK-NEXT:      affine.store {{.*}}, %arg2
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @chain(%a: memref<10x10xf32>, %b: memref<10x10xf32>, %d: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 step 2 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %b[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %d[%i, %j] : memref<10x10xf32>
    }
  }
  return
}

// -----

// A nest that is already imperfect may fuse as long as no level is added.
// CHECK-LABEL: func @already_imperfect
// CHECK:       affine.for
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
// CHECK:         affine.for %{{.*}} = 0 to 10 step 2 {
// CHECK:         affine.for %{{.*}} = 0 to 10 step 3 {
// CHECK-NOT:   affine.for
func.func @already_imperfect(%a: memref<10x10xf32>, %b: memref<10x10xf32>, %d: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
    affine.for %j = 0 to 10 step 2 {
      affine.store %c, %d[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 step 3 {
      affine.store %c, %b[%i, %j] : memref<10x10xf32>
    }
  }
  return
}

// -----

// Read-only ops next to the single inner loop do not make a level imperfect
// (scf-sink-into-nested-parallel moves them in after parallelization).
// CHECK-LABEL: func @read_only_outer_ops
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.load %arg2[%[[I]]]
// CHECK-NEXT:    affine.for
// CHECK-NOT:   affine.for
func.func @read_only_outer_ops(%a: memref<10x10xf32>, %b: memref<10x10xf32>, %s: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    %v = affine.load %s[%i] : memref<10xf32>
    affine.for %j = 0 to 10 {
      affine.store %v, %a[%i, %j] : memref<10x10xf32>
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

// An undone hull fusion also removes the affine.max built for it.
// CHECK-LABEL: func @undo_hull
// SYM-LABEL:   func @undo_hull
// SYM-NOT:     affine.max
// SYM:         affine.for %{{.*}} = 0 to %arg2 {
// SYM-NEXT:      affine.for %{{.*}} = 0 to 10 {
// SYM:         affine.for %{{.*}} = 0 to %arg3 {
// SYM-NEXT:      affine.for %{{.*}} = 0 to 10 step 2 {
// SYM-NOT:     affine.max
func.func @undo_hull(%a: memref<?x10xf32>, %b: memref<?x10xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<?x10xf32>
    }
  }
  affine.for %i = 0 to %m {
    affine.for %j = 0 to 10 step 2 {
      affine.store %c, %b[%i, %j] : memref<?x10xf32>
    }
  }
  return
}

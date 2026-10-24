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

// The guard of the smaller outer loop is pushed into the inner loops, which
// fuse with the guard around the inner body.
// CHECK-LABEL: func @nests_mismatched_outer
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %[[J:.*]] = 0 to 10 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]], %[[J]]]
// CHECK-NEXT:      affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:        affine.store {{.*}}, %arg1[%[[I]], %[[J]]]
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
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

// Guards of every level are merged into one affine.if in the innermost body.
// CHECK:       #[[SET3:.*]] = affine_set<(d0, d1, d2) : (d0 - 1 >= 0, -d1 + 8 >= 0, d2 - 2 >= 0, -d2 + 7 >= 0)>
// CHECK-LABEL: func @nests_mismatched_three_levels
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %[[J:.*]] = 0 to 10 {
// CHECK-NEXT:      affine.for %[[K:.*]] = 0 to 10 {
// CHECK-NEXT:        affine.store {{.*}}, %arg0[%[[I]], %[[J]], %[[K]]]
// CHECK-NEXT:        affine.if #[[SET3]](%[[I]], %[[J]], %[[K]]) {
// CHECK-NEXT:          affine.store {{.*}}, %arg1[%[[I]], %[[J]], %[[K]]]
// CHECK-NEXT:        }
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @nests_mismatched_three_levels(%a: memref<10x10x10xf32>, %b: memref<10x10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.for %k = 0 to 10 {
        affine.store %c, %a[%i, %j, %k] : memref<10x10x10xf32>
      }
    }
  }
  affine.for %i = 1 to 10 {
    affine.for %j = 0 to 9 {
      affine.for %k = 2 to 8 {
        affine.store %c, %b[%i, %j, %k] : memref<10x10x10xf32>
      }
    }
  }
  return
}

// -----

// The guarded loop may come first.
// CHECK-LABEL: func @nests_guarded_first
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %[[J:.*]] = 0 to 10 {
// CHECK-NEXT:      affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:        affine.store {{.*}}, %arg0[%[[I]], %[[J]]]
// CHECK-NEXT:      }
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]], %[[J]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @nests_guarded_first(%a: memref<10x10xf32>, %b: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 1 to 10 {
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

// The outer level guards b, the inner level guards a: one guard per body.
// CHECK-LABEL: func @nests_guard_per_body
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %[[J:.*]] = 0 to 10 {
// CHECK-NEXT:      affine.if {{.*}}(%[[J]]) {
// CHECK-NEXT:        affine.store {{.*}}, %arg0[%[[I]], %[[J]]]
// CHECK-NEXT:      }
// CHECK-NEXT:      affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:        affine.store {{.*}}, %arg1[%[[I]], %[[J]]]
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @nests_guard_per_body(%a: memref<10x10xf32>, %b: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 1 to 10 {
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

// Inner loops that cannot fuse keep the guard around the guarded loop.
// CHECK-LABEL: func @nests_inner_rejected
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.for %{{.*}} = 0 to 10 step 2 {
// CHECK-NEXT:        affine.store {{.*}}, %arg1
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
func.func @nests_inner_rejected(%a: memref<10x10xf32>, %b: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 1 to 10 {
    affine.for %j = 0 to 10 step 2 {
      affine.store %c, %b[%i, %j] : memref<10x10xf32>
    }
  }
  return
}

// -----

// A guard holding more than one op is not pushed down, so its loop is not a
// sibling of the other inner loop.
// CHECK-LABEL: func @nests_guard_with_other_ops
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.store {{.*}}, %arg2
// CHECK-NEXT:      affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:        affine.store {{.*}}, %arg1
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
func.func @nests_guard_with_other_ops(%a: memref<10x10xf32>, %b: memref<10x10xf32>,
                                      %d: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 1 to 10 {
    affine.store %c, %d[%i] : memref<10xf32>
    affine.for %j = 0 to 10 {
      affine.store %c, %b[%i, %j] : memref<10x10xf32>
    }
  }
  return
}

// -----

// An affine.if from the input is not a guard of this pass and is not pushed
// down; it is moved along with the body that contains it.
// CHECK-LABEL: func @nests_source_if_kept
// CHECK:       affine.for %[[I:.*]] = 0 to 10 {
// CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:      affine.store {{.*}}, %arg0
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.for %{{.*}} = 0 to 10 {
// CHECK-NEXT:        affine.store {{.*}}, %arg1
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
func.func @nests_source_if_kept(%a: memref<10x10xf32>, %b: memref<10x10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.for %j = 0 to 10 {
      affine.store %c, %a[%i, %j] : memref<10x10xf32>
    }
  }
  affine.for %i = 0 to 10 {
    affine.if affine_set<(d0) : (d0 - 1 >= 0)>(%i) {
      affine.for %j = 0 to 10 {
        affine.store %c, %b[%i, %j] : memref<10x10xf32>
      }
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

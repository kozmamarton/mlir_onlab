// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-symbolic-bounds=true" -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s --check-prefix=OFF
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-symbolic-bounds=true fuse-producer-consumer=true" -split-input-file | FileCheck %s --check-prefix=PC

// Upper bounds from unrelated symbols: the fused loop runs to their
// affine.max and each body is guarded by its own upper bound.
// CHECK-DAG:   #[[MAX:.*]] = affine_map<()[s0, s1] -> (s0, s1)>
// CHECK-DAG:   #[[BELOW:.*]] = affine_set<(d0)[s0] : (-d0 + s0 - 1 >= 0)>
// CHECK-LABEL: func @symbolic_upper
// CHECK:       %[[UB:.*]] = affine.max #[[MAX]]()[%arg2, %arg3]
// CHECK-NEXT:  affine.for %[[I:.*]] = 0 to %[[UB]] {
// CHECK-NEXT:    affine.if #[[BELOW]](%[[I]])[%arg2] {
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.if #[[BELOW]](%[[I]])[%arg3] {
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
// OFF-LABEL:   func @symbolic_upper
// OFF:         affine.for
// OFF:         affine.for
func.func @symbolic_upper(%a: memref<?xf32>, %b: memref<?xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %m {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Lower bounds from unrelated symbols use affine.min.
// CHECK-DAG:   #[[MIN:.*]] = affine_map<()[s0, s1] -> (s0, s1)>
// CHECK-DAG:   #[[ABOVE:.*]] = affine_set<(d0)[s0] : (d0 - s0 >= 0)>
// CHECK-LABEL: func @symbolic_lower
// CHECK:       %[[LB:.*]] = affine.min #[[MIN]]()[%arg2, %arg3]
// CHECK-NEXT:  affine.for %[[I:.*]] = %[[LB]] to %arg4 {
// CHECK-NEXT:    affine.if #[[ABOVE]](%[[I]])[%arg2] {
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.if #[[ABOVE]](%[[I]])[%arg3] {
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// OFF-LABEL:   func @symbolic_lower
// OFF:         affine.for
// OFF:         affine.for
func.func @symbolic_lower(%a: memref<?xf32>, %b: memref<?xf32>, %l: index, %k: index, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = %l to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = %k to %n {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Constant partial overlap: 0..n-1 and 1..n run over 0..n, each body keeps
// its own range.
// CHECK-LABEL: func @partial_overlap
// CHECK:       affine.for %[[I:.*]] = 0 to %arg2 {
// CHECK-NEXT:    affine.if {{.*}}(%[[I]])[%arg2] {
// CHECK-NEXT:      affine.store {{.*}}, %arg0[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:    affine.if {{.*}}(%[[I]]) {
// CHECK-NEXT:      affine.store {{.*}}, %arg1[%[[I]]]
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
// OFF-LABEL:   func @partial_overlap
// OFF:         affine.for
// OFF:         affine.for
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

// Inner loops of a guarded nest (im vs imm1 in pom2k): the outer guard is
// pushed down and merged with the inner upper bound into one affine.if.
// CHECK-LABEL: func @nest_symbolic_inner
// CHECK:       affine.for %[[J:.*]] = 0 to %arg2 {
// CHECK-NEXT:    %[[UB:.*]] = affine.max {{.*}}()[%arg3, %arg4]
// CHECK-NEXT:    affine.for %[[I:.*]] = 0 to %[[UB]] {
// CHECK-NEXT:      affine.if {{.*}}(%[[I]])[%arg3] {
// CHECK-NEXT:        affine.store {{.*}}, %arg0[%[[J]], %[[I]]]
// CHECK-NEXT:      }
// CHECK-NEXT:      affine.if {{.*}}(%[[J]], %[[I]])[%arg4] {
// CHECK-NEXT:        affine.store {{.*}}, %arg1[%[[J]], %[[I]]]
// CHECK-NEXT:      }
// CHECK-NEXT:    }
// CHECK-NEXT:  }
// CHECK-NOT:   affine.for
func.func @nest_symbolic_inner(%a: memref<?x?xf32>, %b: memref<?x?xf32>, %jm: index, %im: index, %imm1: index) {
  %c = arith.constant 1.0 : f32
  affine.for %j = 0 to %jm {
    affine.for %i = 0 to %im {
      affine.store %c, %a[%j, %i] : memref<?x?xf32>
    }
  }
  affine.for %j = 1 to %jm {
    affine.for %i = 1 to %imm1 {
      affine.store %c, %b[%j, %i] : memref<?x?xf32>
    }
  }
  return
}

// -----

// An affine.min/max of a bound that uses a loop induction variable is not a
// valid symbol, so the pair is not fused.
// CHECK-LABEL: func @bound_uses_iv
// CHECK:       affine.for %[[J:.*]] =
// CHECK-NEXT:    affine.for %{{.*}} = 0 to %arg2 {
// CHECK:         affine.for %{{.*}} = 0 to #{{.*}}(%[[J]]) {
func.func @bound_uses_iv(%a: memref<?x?xf32>, %b: memref<?x?xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %j = 0 to %n {
    affine.for %i = 0 to %n {
      affine.store %c, %a[%j, %i] : memref<?x?xf32>
    }
    affine.for %i = 0 to affine_map<(d0) -> (d0)>(%j) {
      affine.store %c, %b[%j, %i] : memref<?x?xf32>
    }
  }
  return
}

// -----

// A lower bound of unknown offset keeps the step phase only for step 1.
// CHECK-LABEL: func @symbolic_lower_step
// CHECK:       affine.for {{.*}} step 2
// CHECK:       affine.for {{.*}} step 2
func.func @symbolic_lower_step(%a: memref<?xf32>, %b: memref<?xf32>, %l: index, %k: index, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = %l to %n step 2 {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = %k to %n step 2 {
    affine.store %c, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// The dependence check holds for every symbol value: reading A[i] written in
// the same fused iteration is legal over the hull.
// PC-LABEL:    func @symbolic_producer_consumer
// PC:          affine.max
// PC-NEXT:     affine.for
// PC-NOT:      affine.for
func.func @symbolic_producer_consumer(%a: memref<?xf32>, %b: memref<?xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %m {
    %v = affine.load %a[%i] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// -----

// Reading A[i + 1] needs a value written in a later fused iteration.
// PC-LABEL:    func @symbolic_read_ahead
// PC:          affine.for
// PC:          affine.for
func.func @symbolic_read_ahead(%a: memref<?xf32>, %b: memref<?xf32>, %n: index, %m: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to %n {
    affine.store %c, %a[%i] : memref<?xf32>
  }
  affine.for %i = 0 to %m {
    %v = affine.load %a[%i + 1] : memref<?xf32>
    affine.store %v, %b[%i] : memref<?xf32>
  }
  return
}

// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion))' -split-input-file | FileCheck %s

// Curated HPC-oriented affine loop fusion cases adapted from llvm-project.
// Source provenance:
// - mlir/test/Dialect/Affine/loop-fusion.mlir
// - mlir/test/Dialect/Affine/loop-fusion-2.mlir
// - mlir/test/Dialect/Affine/loop-fusion-3.mlir

func.func @should_fuse_reduction_to_pointwise() {
  %a = memref.alloc() : memref<10x10xf32>
  %b = memref.alloc() : memref<10xf32>
  %c = memref.alloc() : memref<10xf32>

  %cf7 = arith.constant 7.0 : f32

  affine.for %i0 = 0 to 10 {
    affine.for %i1 = 0 to 10 {
      %v0 = affine.load %b[%i0] : memref<10xf32>
      %v1 = affine.load %a[%i0, %i1] : memref<10x10xf32>
      %v3 = arith.addf %v0, %v1 : f32
      affine.store %v3, %b[%i0] : memref<10xf32>
    }
  }
  affine.for %i2 = 0 to 10 {
    %v4 = affine.load %b[%i2] : memref<10xf32>
    affine.store %v4, %c[%i2] : memref<10xf32>
  }

  // Should fuse in entire inner loop on %i1 from source loop nest, as %i1
  // is not used in the access function of the store/load on %b.
  // CHECK:       affine.for %{{.*}} = 0 to 10 {
  // CHECK-NEXT:    affine.for %{{.*}} = 0 to 10 {
  // CHECK-NEXT:      affine.load %{{.*}}[0] : memref<1xf32>
  // CHECK-NEXT:      affine.load %{{.*}}[%{{.*}}, %{{.*}}] : memref<10x10xf32>
  // CHECK-NEXT:      arith.addf %{{.*}}, %{{.*}} : f32
  // CHECK-NEXT:      affine.store %{{.*}}, %{{.*}}[0] : memref<1xf32>
  // CHECK-NEXT:    }
  // CHECK-NEXT:    affine.load %{{.*}}[0] : memref<1xf32>
  // CHECK-NEXT:    affine.store %{{.*}}, %{{.*}}[%{{.*}}] : memref<10xf32>
  // CHECK-NEXT:  }
  // CHECK-NEXT:  return
  return
}

// -----

// CHECK-DAG: [[$MAP_SHIFT_MINUS_ONE_R1:#map[0-9a-zA-Z_]*]] = affine_map<(d0) -> (d0 - 1)>
// CHECK-DAG: [[$MAP_SHIFT_D0_BY_ONE:#map[0-9a-zA-Z_]*]] = affine_map<(d0, d1) -> (d0 + 1)>
// CHECK-DAG: [[$MAP_SHIFT_D1_BY_ONE:#map[0-9a-zA-Z_]*]] = affine_map<(d0, d1) -> (d1 + 1)>

// CHECK-LABEL: func @should_fuse_loop_nests_with_shifts() {
func.func @should_fuse_loop_nests_with_shifts() {
  %a = memref.alloc() : memref<10x10xf32>
  %cf7 = arith.constant 7.0 : f32

  affine.for %i0 = 0 to 9 {
    affine.for %i1 = 0 to 9 {
      affine.store %cf7, %a[%i0 + 1, %i1 + 1] : memref<10x10xf32>
    }
  }
  affine.for %i2 = 1 to 10 {
    affine.for %i3 = 1 to 10 {
      %v0 = affine.load %a[%i2, %i3] : memref<10x10xf32>
    }
  }

  // Source slice affine apply sequence:
  // *) First two affine apply's map from the dst to src iteration space.
  // *) Third affine apply is access function around src store.
  // *) Fourth affine apply shifts the stores access function by '-1', because
  //    of the offset induced by reducing the memref shape from 10x10 to 9x9.
  // *) Fifth affine apply shifts the loads access function by '-1', because
  //    of the offset induced by reducing the memref shape from 10x10 to 9x9.
  // NOTE: Should create a private memref with reduced shape 9x9xf32.
  // CHECK:      affine.for %{{.*}} = 1 to 10 {
  // CHECK-NEXT:   affine.for %{{.*}} = 1 to 10 {
  // CHECK-NEXT:     %[[I:.*]] = affine.apply [[$MAP_SHIFT_MINUS_ONE_R1]](%{{.*}})
  // CHECK-NEXT:     %[[J:.*]] = affine.apply [[$MAP_SHIFT_MINUS_ONE_R1]](%{{.*}})
  // CHECK-NEXT:     affine.apply [[$MAP_SHIFT_D0_BY_ONE]](%[[I]], %[[J]])
  // CHECK-NEXT:     affine.apply [[$MAP_SHIFT_D1_BY_ONE]](%[[I]], %[[J]])
  // CHECK-NEXT:     affine.store %{{.*}}, %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:     affine.load %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:   }
  // CHECK-NEXT: }
  // CHECK-NEXT: return
  return
}

// -----

// CHECK-LABEL: func @should_fuse_at_depth_above_loop_carried_dependence(%{{.*}}: memref<64x4xf32>, %{{.*}}: memref<64x4xf32>) {
func.func @should_fuse_at_depth_above_loop_carried_dependence(%arg0: memref<64x4xf32>, %arg1: memref<64x4xf32>) {
  %out = memref.alloc() : memref<64x4xf32>
  %0 = arith.constant 0.0 : f32
  affine.for %i0 = 0 to 64 {
    affine.for %i1 = 0 to 4 {
      affine.store %0, %out[%i0, %i1] : memref<64x4xf32>
    }
  }
  affine.for %i2 = 0 to 4 {
    affine.for %i3 = 0 to 4 {
      affine.for %i4 = 0 to 16 {
        %v = affine.load %arg1[16 * %i3 - %i4 + 15, %i2] : memref<64x4xf32>
        "op0"(%v) : (f32) -> ()
      }
      affine.for %i5 = 0 to 4 {
        affine.for %i6 = 0 to 16 {
          %v = affine.load %arg0[16 * %i5 - %i6 + 15, %i3] : memref<64x4xf32>
          "op1"(%v) : (f32) -> ()
        }
        affine.for %i7 = 0 to 16 {
          %r = "op2"() : () -> (f32)
          %v = affine.load %out[16 * %i5 + %i7, %i2] : memref<64x4xf32>
          %s = arith.addf %v, %r : f32
          affine.store %s, %out[16 * %i5 + %i7, %i2] : memref<64x4xf32>
        }
      }
    }
  }

  // We can fuse source loop nest '%i0' into dst loop nest '%i2', but the
  // depth at which we can insert the src loop nest slice into the dst loop
  // nest must be decreased because of a loop carried dependence on loop '%i3'.
  // As a result, the source loop nest is inserted at dst loop nest depth 1,
  // just above the loop with the carried dependence.
  // CHECK:       memref.alloc() : memref<64x4xf32>
  // CHECK:       affine.for %{{.*}} = 0 to 4 {
  // CHECK-NEXT:    affine.for %{{.*}} = 0 to 64 {
  // CHECK-NEXT:      affine.store %{{.*}}, %{{.*}}[%{{.*}}, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:    }
  // CHECK-NEXT:    affine.for %{{.*}} = 0 to 4 {
  // CHECK-NEXT:      affine.for %{{.*}} = 0 to 16 {
  // CHECK-NEXT:        affine.load %{{.*}}[%{{.*}} * 16 - %{{.*}} + 15, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:        "op0"(%{{.*}}) : (f32) -> ()
  // CHECK-NEXT:      }
  // CHECK-NEXT:      affine.for %{{.*}} = 0 to 4 {
  // CHECK-NEXT:        affine.for %{{.*}} = 0 to 16 {
  // CHECK-NEXT:          affine.load %{{.*}}[%{{.*}} * 16 - %{{.*}} + 15, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:          "op1"(%{{.*}}) : (f32) -> ()
  // CHECK-NEXT:        }
  // CHECK-NEXT:        affine.for %{{.*}} = 0 to 16 {
  // CHECK-NEXT:          %{{.*}} = "op2"() : () -> f32
  // CHECK:               affine.load %{{.*}}[%{{.*}} * 16 + %{{.*}}, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:          arith.addf %{{.*}}, %{{.*}} : f32
  // CHECK:               affine.store %{{.*}}, %{{.*}}[%{{.*}} * 16 + %{{.*}}, %{{.*}}] : memref<64x4xf32>
  // CHECK-NEXT:        }
  // CHECK-NEXT:      }
  // CHECK-NEXT:    }
  // CHECK-NEXT:  }
  // CHECK-NEXT:  return
  return
}

// -----

// Test case from github bug 777.
// CHECK-LABEL: func @mul_add_0
func.func @mul_add_0(%arg0: memref<3x4xf32>, %arg1: memref<4x3xf32>, %arg2: memref<3x3xf32>, %arg3: memref<3x3xf32>) {
  %cst = arith.constant 0.000000e+00 : f32
  %0 = memref.alloc() : memref<3x3xf32>
  affine.for %arg4 = 0 to 3 {
    affine.for %arg5 = 0 to 3 {
      affine.store %cst, %0[%arg4, %arg5] : memref<3x3xf32>
    }
  }
  affine.for %arg4 = 0 to 3 {
    affine.for %arg5 = 0 to 3 {
      affine.for %arg6 = 0 to 4 {
        %1 = affine.load %arg1[%arg6, %arg5] : memref<4x3xf32>
        %2 = affine.load %arg0[%arg4, %arg6] : memref<3x4xf32>
        %3 = arith.mulf %2, %1 : f32
        %4 = affine.load %0[%arg4, %arg5] : memref<3x3xf32>
        %5 = arith.addf %4, %3 : f32
        affine.store %5, %0[%arg4, %arg5] : memref<3x3xf32>
      }
    }
  }
  affine.for %arg4 = 0 to 3 {
    affine.for %arg5 = 0 to 3 {
      %6 = affine.load %arg2[%arg4, %arg5] : memref<3x3xf32>
      %7 = affine.load %0[%arg4, %arg5] : memref<3x3xf32>
      %8 = arith.addf %7, %6 : f32
      affine.store %8, %arg3[%arg4, %arg5] : memref<3x3xf32>
    }
  }
  // CHECK:      affine.for %[[i0:.*]] = 0 to 3 {
  // CHECK-NEXT:   affine.for %[[i1:.*]] = 0 to 3 {
  // CHECK-NEXT:   affine.store %{{.*}}, %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:     affine.for %[[i2:.*]] = 0 to 4 {
  // CHECK-NEXT:       affine.load %{{.*}}[%[[i2]], %[[i1]]] : memref<4x3xf32>
  // CHECK-NEXT:       affine.load %{{.*}}[%[[i0]], %[[i2]]] : memref<3x4xf32>
  // CHECK-NEXT:       arith.mulf %{{.*}}, %{{.*}} : f32
  // CHECK-NEXT:       affine.load %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:       arith.addf %{{.*}}, %{{.*}} : f32
  // CHECK-NEXT:       affine.store %{{.*}}, %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:     }
  // CHECK-NEXT:     affine.load %{{.*}}[%[[i0]], %[[i1]]] : memref<3x3xf32>
  // CHECK-NEXT:     affine.load %{{.*}}[0, 0] : memref<1x1xf32>
  // CHECK-NEXT:     arith.addf %{{.*}}, %{{.*}} : f32
  // CHECK-NEXT:     affine.store %{{.*}}, %{{.*}}[%[[i0]], %[[i1]]] : memref<3x3xf32>
  // CHECK-NEXT:   }
  // CHECK-NEXT: }
  // CHECK-NEXT: return
  return
}

// -----

// CHECK-LABEL: func @should_not_fuse_since_non_affine_users
func.func @should_not_fuse_since_non_affine_users(%in0 : memref<32xf32>,
                      %in1 : memref<32xf32>) {
  affine.for %d = 0 to 32 {
    %lhs = affine.load %in0[%d] : memref<32xf32>
    %rhs = affine.load %in1[%d] : memref<32xf32>
    %add = arith.addf %lhs, %rhs : f32
    affine.store %add, %in0[%d] : memref<32xf32>
  }
  affine.for %d = 0 to 32 {
    %lhs = memref.load %in0[%d] : memref<32xf32>
    %rhs = memref.load %in1[%d] : memref<32xf32>
    %add = arith.subf %lhs, %rhs : f32
    memref.store %add, %in0[%d] : memref<32xf32>
  }
  affine.for %d = 0 to 32 {
    %lhs = affine.load %in0[%d] : memref<32xf32>
    %rhs = affine.load %in1[%d] : memref<32xf32>
    %add = arith.mulf %lhs, %rhs : f32
    affine.store %add, %in0[%d] : memref<32xf32>
  }
  return
}

// CHECK:  affine.for
// CHECK:    arith.addf
// CHECK:  affine.for
// CHECK:    arith.subf
// CHECK:  affine.for
// CHECK:    arith.mulf
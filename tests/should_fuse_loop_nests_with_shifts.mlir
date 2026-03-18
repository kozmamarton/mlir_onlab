// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion))' | FileCheck %s

// Curated HPC-oriented affine loop fusion case adapted from llvm-project.
// Source: mlir/test/Dialect/Affine/loop-fusion.mlir.

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
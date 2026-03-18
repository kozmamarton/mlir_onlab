// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion))' | FileCheck %s

// Curated HPC-oriented affine loop fusion safety case adapted from llvm-project.
// Source: mlir/test/Dialect/Affine/loop-fusion-3.mlir.

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
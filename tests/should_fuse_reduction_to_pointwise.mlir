// RUN: mlir-opt -allow-unregistered-dialect %s -pass-pipeline='builtin.module(func.func(affine-loop-fusion))' | FileCheck %s

// Curated HPC-oriented affine loop fusion case adapted from llvm-project.
// Source: mlir/test/Dialect/Affine/loop-fusion.mlir.

func.func @should_fuse_reduction_to_pointwise() {
  %a = memref.alloc() : memref<10x10xf32>
  %b = memref.alloc() : memref<10xf32>
  %c = memref.alloc() : memref<10xf32>

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
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-across-intervening-ops=true" -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s --check-prefix=OFF
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-across-intervening-ops=true alias-conservative=true" -split-input-file | FileCheck %s --check-prefix=ALIAS

// A load of a scalar the earlier loop does not touch commutes with it. The
// fused loop is placed after the load, which stays in front of it.
// CHECK-LABEL: func @load_untouched_between
// CHECK:       affine.load %arg2[0]
// CHECK-NEXT:  affine.for
// CHECK-NOT:   affine.for
// OFF-LABEL:   func @load_untouched_between
// OFF:         affine.for
// OFF:         affine.for
func.func @load_untouched_between(%a: memref<10xf32>, %b: memref<10xf32>, %u: memref<1xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  %v = affine.load %u[0] : memref<1xf32>
  affine.for %i = 0 to 10 {
    affine.store %v, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// The load reads what the earlier loop writes (RAW against the gap).
// CHECK-LABEL: func @load_written_between
// CHECK:       affine.for
// CHECK:       affine.load %arg0[0]
// CHECK:       affine.for
func.func @load_written_between(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  %v = affine.load %a[0] : memref<10xf32>
  affine.for %i = 0 to 10 {
    affine.store %v, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// The gap writes what the earlier loop reads (WAR against the gap).
// CHECK-LABEL: func @store_read_between
// CHECK:       affine.for
// CHECK:       affine.store {{.*}}, %arg2[0]
// CHECK:       affine.for
func.func @store_read_between(%a: memref<10xf32>, %b: memref<10xf32>, %u: memref<1xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    %v = affine.load %u[0] : memref<1xf32>
    affine.store %v, %a[%i] : memref<10xf32>
  }
  affine.store %c, %u[0] : memref<1xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// The gap writes what the earlier loop writes (WAW against the gap).
// CHECK-LABEL: func @store_written_between
// CHECK:       affine.for
// CHECK:       affine.store {{.*}}, %arg0[0]
// CHECK:       affine.for
func.func @store_written_between(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  %z = arith.constant 0.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.store %z, %a[0] : memref<10xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// The earlier loop writes @g through one get_global and the gap re-reads it
// through another: same memory, so the gap does not commute.
// CHECK-LABEL: func @global_reloaded_between
// CHECK:       affine.for
// CHECK:       affine.load
// CHECK:       affine.for
memref.global "private" @g : memref<1xf32> = dense<0.0>
func.func @global_reloaded_between(%b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  %g1 = memref.get_global @g : memref<1xf32>
  affine.for %i = 0 to 10 {
    affine.store %c, %g1[0] : memref<1xf32>
  }
  %g2 = memref.get_global @g : memref<1xf32>
  %v = affine.load %g2[0] : memref<1xf32>
  affine.for %i = 0 to 10 {
    affine.store %v, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// A store to a local scalar the earlier loop does not touch commutes with it.
// CHECK-LABEL: func @alloca_store_between
// CHECK:       affine.store {{.*}}, %{{.*}}[] : memref<f32>
// CHECK-NEXT:  affine.for
// CHECK-NOT:   affine.for
func.func @alloca_store_between(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  %s = memref.alloca() : memref<f32>
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.store %c, %s[] : memref<f32>
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// Region ops in the gap are judged by the effects nested in them.
// CHECK-LABEL: func @if_between
// CHECK:       affine.if
// CHECK:       affine.for
// CHECK-NOT:   affine.for
func.func @if_between(%a: memref<10xf32>, %b: memref<10xf32>, %u: memref<1xf32>, %n: index) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.if affine_set<(d0) : (d0 - 1 >= 0)>(%n) {
    affine.store %c, %u[0] : memref<1xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// A call has unknown effects and still blocks the fusion.
// CHECK-LABEL: func @call_between
// CHECK:       affine.for
// CHECK:       call @ext
// CHECK:       affine.for
func.func private @ext()
func.func @call_between(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  func.call @ext() : () -> ()
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// Under alias-conservative, a gap read of one argument may alias the earlier
// loop's write to another argument.
// CHECK-LABEL: func @arg_load_between
// CHECK:       affine.for
// CHECK-NOT:   affine.for
// ALIAS-LABEL: func @arg_load_between
// ALIAS:       affine.for
// ALIAS:       affine.load %arg2[0]
// ALIAS:       affine.for
func.func @arg_load_between(%a: memref<10xf32>, %b: memref<10xf32>, %u: memref<1xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  %v = affine.load %u[0] : memref<1xf32>
  affine.for %i = 0 to 10 {
    affine.store %v, %b[%i] : memref<10xf32>
  }
  return
}

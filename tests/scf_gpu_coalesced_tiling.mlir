// RUN: tutorial-opt %s --scf-gpu-coalesced-tiling --canonicalize -split-input-file | FileCheck %s
// RUN: tutorial-opt %s --scf-gpu-coalesced-tiling="block-3d=64,2,1 block-2d=64,4" --canonicalize -split-input-file | FileCheck %s --check-prefix=OPT

// pom2k (k, j, i) nest: i is the stride-1 IV, so it gets the 32-wide x
// dimension of block (32, 4, 2), j gets y and k gets z.
// CHECK-LABEL: func @nest3d
// CHECK:       scf.parallel ({{.*}}) = ({{.*}}) to ({{.*}}) step (%c2, %c4, %c32)
// CHECK:         scf.parallel
// CHECK:         } {mapping = [#gpu.loop_dim_map<processor = thread_z{{.*}}processor = thread_y{{.*}}processor = thread_x
// CHECK:       } {mapping = [#gpu.loop_dim_map<processor = block_z{{.*}}processor = block_y{{.*}}processor = block_x
// OPT-LABEL:   func @nest3d
// OPT:         step (%c1, %c2, %c64)
func.func @nest3d(%a: memref<?xf32>, %b: memref<?xf32>, %kb: index, %jm: index, %im: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %s = arith.muli %im, %jm : index
  %va = memref.reinterpret_cast %a to offset: [0], sizes: [%kb, %jm, %im], strides: [%s, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
  %vb = memref.reinterpret_cast %b to offset: [0], sizes: [%kb, %jm, %im], strides: [%s, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
  scf.parallel (%k, %j, %i) = (%c0, %c0, %c0) to (%kb, %jm, %im) step (%c1, %c1, %c1) {
    %x = memref.load %vb[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
    memref.store %x, %va[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
  }
  return
}

// -----

// (j, i) nest: block (32, 8) with i on x; the positional 32,4,2 list of
// scf-parallel-loop-tiling would have given i only 4.
// CHECK-LABEL: func @nest2d
// CHECK:       scf.parallel ({{.*}}) = ({{.*}}) to ({{.*}}) step (%c8, %c32)
// CHECK:         } {mapping = [#gpu.loop_dim_map<processor = thread_y{{.*}}processor = thread_x
// CHECK:       } {mapping = [#gpu.loop_dim_map<processor = block_y{{.*}}processor = block_x
// OPT-LABEL:   func @nest2d
// OPT:         step (%c4, %c64)
func.func @nest2d(%a: memref<?xf32>, %jm: index, %im: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 0.0 : f32
  %va = memref.reinterpret_cast %a to offset: [0], sizes: [%jm, %im], strides: [%im, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
  scf.parallel (%j, %i) = (%c0, %c0) to (%jm, %im) step (%c1, %c1) {
    memref.store %cst, %va[%j, %i] : memref<?x?xf32, strided<[?, 1]>>
  }
  return
}

// -----

// Flat accesses: the IV added without a stride factor is the stride-1 one,
// even when it is not the innermost IV of the loop.
// CHECK-LABEL: func @flat_first_iv
// CHECK:       scf.parallel ({{.*}}) = ({{.*}}) to ({{.*}}) step (%c32, %c8)
// CHECK:         } {mapping = [#gpu.loop_dim_map<processor = thread_x{{.*}}processor = thread_y
func.func @flat_first_iv(%a: memref<?xf32>, %jm: index, %im: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 0.0 : f32
  scf.parallel (%i, %j) = (%c0, %c0) to (%im, %jm) step (%c1, %c1) {
    %row = arith.muli %j, %im : index
    %idx = arith.addi %row, %i : index
    memref.store %cst, %a[%idx] : memref<?xf32>
  }
  return
}

// -----

// Loops with reductions or an existing mapping are left alone.
// CHECK-LABEL: func @skipped
// CHECK:       scf.parallel (%{{.*}}) = (%c0) to (%arg1) step (%c1)
// CHECK:       scf.parallel (%{{.*}}) = (%c0) to (%arg1) step (%c1)
// CHECK-SAME:  init
func.func @skipped(%a: memref<?xf32>, %n: index) -> f32 {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 0.0 : f32
  scf.parallel (%i) = (%c0) to (%n) step (%c1) {
    memref.store %cst, %a[%i] : memref<?xf32>
  } {mapping = [#gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
  %r = scf.parallel (%i) = (%c0) to (%n) step (%c1) init (%cst) -> f32 {
    %x = memref.load %a[%i] : memref<?xf32>
    scf.reduce(%x : f32) {
    ^bb0(%l: f32, %r: f32):
      %s = arith.addf %l, %r : f32
      scf.reduce.return %s : f32
    }
  }
  return %r : f32
}

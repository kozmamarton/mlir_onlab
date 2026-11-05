// RUN: tutorial-opt %s --pass-pipeline="builtin.module(func.func(scf-offload-host-loops))" -split-input-file | FileCheck %s

// pom2k bcond_3 east/west boundary: one (j, k) iteration writes its own
// uf(imm1, j, k), uf(1, j, k) and uf(0, j, k), so both loops are parallel.
// CHECK-LABEL: func @boundary
// CHECK-NOT:   scf.for
// CHECK:       scf.parallel (%{{.*}}, %{{.*}}) =
// CHECK-NOT:   scf.for
func.func @boundary(%uf: memref<?xf32>, %u: memref<?xf32>, %kb: index, %jmm1: index, %im: index, %jm: index, %imm1: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %plane = arith.muli %im, %jm : index
  scf.for %k = %c0 to %kb step %c1 {
    scf.for %j = %c1 to %jmm1 step %c1 {
      %kk = arith.muli %k, %plane : index
      %jj = arith.muli %j, %im : index
      %row = arith.addi %kk, %jj : index
      %east = arith.addi %row, %imm1 : index
      %west = arith.addi %row, %c1 : index
      %x = memref.load %u[%west] : memref<?xf32>
      memref.store %x, %uf[%east] : memref<?xf32>
      memref.store %x, %uf[%west] : memref<?xf32>
      %y = memref.load %uf[%west] : memref<?xf32>
      memref.store %y, %uf[%row] : memref<?xf32>
    }
  }
  return
}

// -----

// A k sweep around an (j, i) kernel whose level k reads level k - 1 of the
// same column: k stays serial inside one kernel over (j, i), together with
// the dz[k] load from the k level.
// CHECK-LABEL: func @serial_k
// CHECK:       scf.parallel (%[[J:.*]], %[[I:.*]]) =
// CHECK-NEXT:    scf.for %[[K:.*]] =
// CHECK:           memref.load %arg1[%[[K]]]
// CHECK:           memref.store {{.*}}[%[[K]], %[[J]], %[[I]]]
// CHECK-NOT:   scf.parallel
func.func @serial_k(%a: memref<?xf32>, %dz: memref<?xf32>, %kb: index, %jm: index, %im: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %plane = arith.muli %im, %jm : index
  %va = memref.reinterpret_cast %a to offset: [0], sizes: [%kb, %jm, %im], strides: [%plane, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
  scf.for %k = %c1 to %kb step %c1 {
    %d = memref.load %dz[%k] : memref<?xf32>
    %km1 = arith.subi %k, %c1 : index
    scf.parallel (%j, %i) = (%c0, %c0) to (%jm, %im) step (%c1, %c1) {
      %p = memref.load %va[%km1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %r = arith.mulf %p, %d : f32
      memref.store %r, %va[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
    }
  }
  return
}

// -----

// Two sibling kernels in one k iteration with different ranges become one
// kernel over the union, each body guarded by its own range.
// CHECK-LABEL: func @fused_siblings
// CHECK:       scf.parallel
// CHECK-NEXT:    scf.for
// CHECK-NOT:     scf.parallel
// CHECK:           scf.if
// CHECK:           scf.if
func.func @fused_siblings(%a: memref<?xf32>, %b: memref<?xf32>, %kb: index, %jm: index, %im: index, %imm1: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %plane = arith.muli %im, %jm : index
  %va = memref.reinterpret_cast %a to offset: [0], sizes: [%kb, %jm, %im], strides: [%plane, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
  %vb = memref.reinterpret_cast %b to offset: [0], sizes: [%kb, %jm, %im], strides: [%plane, %im, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
  scf.for %k = %c1 to %kb step %c1 {
    %km1 = arith.subi %k, %c1 : index
    scf.parallel (%j, %i) = (%c0, %c0) to (%jm, %im) step (%c1, %c1) {
      %p = memref.load %va[%km1, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %p, %va[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
    }
    scf.parallel (%j, %i) = (%c0, %c1) to (%jm, %imm1) step (%c1, %c1) {
      %p = memref.load %va[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      memref.store %p, %vb[%k, %j, %i] : memref<?x?x?xf32, strided<[?, ?, 1]>>
    }
  }
  return
}

// -----

// Back substitution written as a countdown scf.while on a scalar alloca:
// it becomes an scf.for, then the serial k loop moves inside the i kernel.
// CHECK-LABEL: func @countdown
// CHECK-NOT:   scf.while
// CHECK-NOT:   memref.alloca
// CHECK:       scf.parallel (%{{.*}}) =
// CHECK-NEXT:    scf.for
func.func @countdown(%f: memref<?xf32>, %n: i32, %im: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %c0_i32 = arith.constant 0 : i32
  %cm1_i32 = arith.constant -1 : i32
  %counter = memref.alloca() : memref<i32>
  memref.store %c0_i32, %counter[] : memref<i32>
  memref.store %n, %counter[] : memref<i32>
  scf.while : () -> () {
    %v = memref.load %counter[] : memref<i32>
    %c = arith.cmpi sge, %v, %c0_i32 : i32
    scf.condition(%c)
  } do {
    %k = memref.load %counter[] : memref<i32>
    %ki = arith.index_cast %k : i32 to index
    %row = arith.muli %ki, %im : index
    %k1 = arith.addi %ki, %c1 : index
    %row1 = arith.muli %k1, %im : index
    scf.for %i = %c0 to %im step %c1 {
      %src = arith.addi %row1, %i : index
      %dst = arith.addi %row, %i : index
      %x = memref.load %f[%src] : memref<?xf32>
      memref.store %x, %f[%dst] : memref<?xf32>
    }
    %kd = memref.load %counter[] : memref<i32>
    %next = arith.addi %kd, %cm1_i32 : i32
    memref.store %next, %counter[] : memref<i32>
    scf.yield
  }
  return
}

// -----

// A recurrence along the only loop is not parallel: the loop stays.
// CHECK-LABEL: func @recurrence
// CHECK:       scf.for
// CHECK-NOT:   scf.parallel
func.func @recurrence(%a: memref<?xf32>, %n: index) {
  %c1 = arith.constant 1 : index
  scf.for %i = %c1 to %n step %c1 {
    %im1 = arith.subi %i, %c1 : index
    %x = memref.load %a[%im1] : memref<?xf32>
    memref.store %x, %a[%i] : memref<?xf32>
  }
  return
}

// -----

// A host load of an argument scalar that only feeds a kernel moves into it;
// one whose buffer the kernel writes stays on the host.
// CHECK-LABEL: func @sink_scalar
// CHECK:       %[[KEEP:.*]] = memref.load %arg2[%c0]
// CHECK:       scf.parallel
// CHECK-NEXT:    memref.load %arg0[%c0]
// CHECK-NEXT:    arith.mulf
// CHECK:         memref.store %[[KEEP]], %arg2
func.func @sink_scalar(%s: memref<?xf32>, %a: memref<?xf32>, %t: memref<?xf32>, %n: index) {
  %c0 = arith.constant 0 : index
  %c1 = arith.constant 1 : index
  %cst = arith.constant 2.0 : f32
  %x = memref.load %s[%c0] : memref<?xf32>
  %y = arith.mulf %x, %cst : f32
  %keep = memref.load %t[%c0] : memref<?xf32>
  scf.parallel (%i) = (%c0) to (%n) step (%c1) {
    memref.store %y, %a[%i] : memref<?xf32>
    memref.store %keep, %t[%i] : memref<?xf32>
  }
  return
}

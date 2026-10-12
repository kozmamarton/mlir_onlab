// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-matching-bounds=false" -split-input-file | FileCheck %s --check-prefix=MISMATCH-ONLY
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-mismatched-bounds=false" -split-input-file | FileCheck %s --check-prefix=MATCH-ONLY
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative="fuse-matching-bounds=false fuse-mismatched-bounds=false" -split-input-file | FileCheck %s --check-prefix=NONE
// RUN: tutorial-opt %s --affine-loop-fusion-non-conservative -split-input-file | FileCheck %s --check-prefix=DEFAULT

// MISMATCH-ONLY-LABEL: func @matching
// MISMATCH-ONLY:       affine.for
// MISMATCH-ONLY:       affine.for
// MATCH-ONLY-LABEL:    func @matching
// MATCH-ONLY:          affine.for
// MATCH-ONLY-NOT:      affine.for
// NONE-LABEL:          func @matching
// NONE:                affine.for
// NONE:                affine.for
// DEFAULT-LABEL:       func @matching
// DEFAULT:             affine.for
// DEFAULT-NOT:         affine.for
func.func @matching(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 10 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

// -----

// MISMATCH-ONLY-LABEL: func @mismatched
// MISMATCH-ONLY:       affine.for
// MISMATCH-ONLY:       affine.if
// MISMATCH-ONLY-NOT:   affine.for
// MATCH-ONLY-LABEL:    func @mismatched
// MATCH-ONLY:          affine.for
// MATCH-ONLY:          affine.for
// NONE-LABEL:          func @mismatched
// NONE:                affine.for
// NONE:                affine.for
// DEFAULT-LABEL:       func @mismatched
// DEFAULT:             affine.for
// DEFAULT:             affine.if
// DEFAULT-NOT:         affine.for
func.func @mismatched(%a: memref<10xf32>, %b: memref<10xf32>) {
  %c = arith.constant 1.0 : f32
  affine.for %i = 0 to 10 {
    affine.store %c, %a[%i] : memref<10xf32>
  }
  affine.for %i = 0 to 7 {
    affine.store %c, %b[%i] : memref<10xf32>
  }
  return
}

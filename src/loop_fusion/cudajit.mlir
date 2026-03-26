#map = affine_map<(d0, d1, d2) -> (d0 * 144 + d1 * 12 + d2 + 157)>
module {
  func.func @jit(%arg0: memref<?x?x?xf64>, %arg1: memref<?x?x?xf64>) {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 1.250000e-01 : f64
    %cst_0 = arith.constant 2.000000e+00 : f64
    %idx0 = index.constant 0
    %idx10 = index.constant 10
    %idx1 = index.constant 1
    %cast = memref.cast %arg0 : memref<?x?x?xf64> to memref<12x12x12xf64>
    %cast_1 = memref.cast %arg1 : memref<?x?x?xf64> to memref<12x12x12xf64>
    %subview = memref.subview %cast[1, 1, 1] [10, 10, 10] [1, 1, 1] : memref<12x12x12xf64> to memref<10x10x10xf64, #map>
    %subview_2 = memref.subview %cast_1[1, 1, 1] [10, 10, 10] [1, 1, 1] : memref<12x12x12xf64> to memref<10x10x10xf64, #map>
    scf.parallel (%arg2, %arg3, %arg4) = (%idx0, %idx0, %idx0) to (%idx10, %idx10, %idx10) step (%idx1, %idx1, %idx1) {
      %0 = arith.addi %arg2, %c1 : index
      %1 = arith.addi %arg3, %c1 : index
      %2 = memref.load %arg0[%arg4, %1, %0] : memref<?x?x?xf64>
      %3 = arith.addi %arg4, %c1 : index
      %4 = memref.load %arg0[%3, %1, %0] : memref<?x?x?xf64>
      %5 = arith.addi %arg4, %c2 : index
      %6 = memref.load %arg0[%5, %1, %0] : memref<?x?x?xf64>
      %7 = memref.load %arg0[%3, %arg3, %0] : memref<?x?x?xf64>
      %8 = arith.addi %arg3, %c2 : index
      %9 = memref.load %arg0[%3, %8, %0] : memref<?x?x?xf64>
      %10 = memref.load %arg0[%3, %1, %arg2] : memref<?x?x?xf64>
      %11 = arith.addi %arg2, %c2 : index
      %12 = memref.load %arg0[%3, %1, %11] : memref<?x?x?xf64>
      %13 = arith.mulf %4, %cst_0 : f64
      %14 = arith.subf %2, %13 : f64
      %15 = arith.addf %14, %6 : f64
      %16 = arith.mulf %15, %cst : f64
      %17 = arith.subf %7, %13 : f64
      %18 = arith.addf %17, %9 : f64
      %19 = arith.mulf %18, %cst : f64
      %20 = arith.addf %16, %19 : f64
      %21 = arith.subf %10, %13 : f64
      %22 = arith.addf %21, %12 : f64
      %23 = arith.mulf %22, %cst : f64
      %24 = arith.addf %20, %23 : f64
      %25 = arith.addf %24, %4 : f64
      memref.store %25, %subview[%arg4, %arg3, %arg2] : memref<10x10x10xf64, #map>
      %26 = memref.load %arg0[%arg4, %1, %0] : memref<?x?x?xf64>
      %27 = memref.load %arg0[%3, %1, %0] : memref<?x?x?xf64>
      %28 = memref.load %arg0[%5, %1, %0] : memref<?x?x?xf64>
      %29 = memref.load %arg0[%3, %arg3, %0] : memref<?x?x?xf64>
      %30 = memref.load %arg0[%3, %8, %0] : memref<?x?x?xf64>
      %31 = memref.load %arg0[%3, %1, %arg2] : memref<?x?x?xf64>
      %32 = memref.load %arg0[%3, %1, %11] : memref<?x?x?xf64>
      %33 = arith.mulf %27, %cst_0 : f64
      %34 = arith.subf %26, %33 : f64
      %35 = arith.addf %34, %28 : f64
      %36 = arith.mulf %35, %cst : f64
      %37 = arith.subf %29, %33 : f64
      %38 = arith.addf %37, %30 : f64
      %39 = arith.mulf %38, %cst : f64
      %40 = arith.addf %36, %39 : f64
      %41 = arith.subf %31, %33 : f64
      %42 = arith.addf %41, %32 : f64
      %43 = arith.mulf %42, %cst : f64
      %44 = arith.addf %40, %43 : f64
      %45 = arith.addf %44, %27 : f64
      memref.store %45, %subview_2[%arg4, %arg3, %arg2] : memref<10x10x10xf64, #map>
      scf.reduce 
    }
    return
  }
}


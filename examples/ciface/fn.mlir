#map0 = affine_map<(d0, d1, d2) -> (d0 * 144 + d1 * 12 + d2)>
#map1 = affine_map<(d0, d1, d2) -> (d0 * 144 + d1 * 12 + d2 + 157)>
#map2 = affine_map<(d0) -> (d0 + 1)>
#map3 = affine_map<(d0) -> (d0 + 2)>
module  {
  func.func @jit(%arg0: memref<?x?x?xf64>, %arg1: memref<?x?x?xf64>) {
    %c0 = constant 0 : index
    %c10 = constant 10 : index
    %c1 = constant 1 : index
    %cst = constant 1.250000e-01 : f32
    %cst_0 = constant 2.000000e+00 : f32
    %0 = memref_cast %arg0 : memref<?x?x?xf64> to memref<12x12x12xf64>
    %1 = memref_cast %arg1 : memref<?x?x?xf64> to memref<12x12x12xf64>
    %2 = subview %0[0, 0, 0] [12, 12, 12] [1, 1, 1] : memref<12x12x12xf64> to memref<12x12x12xf64, #map0>
    %3 = subview %0[1, 1, 1] [10, 10, 10] [1, 1, 1] : memref<12x12x12xf64> to memref<10x10x10xf64, #map1>
    %4 = subview %1[1, 1, 1] [10, 10, 10] [1, 1, 1] : memref<12x12x12xf64> to memref<10x10x10xf64, #map1>
    scf.parallel (%arg2, %arg3, %arg4) = (%c0, %c0, %c0) to (%c10, %c10, %c10) step (%c1, %c1, %c1) {
      %5 = affine.apply #map2(%arg2)
      %6 = affine.apply #map2(%arg3)
      %7 = load %2[%arg4, %6, %5] : memref<12x12x12xf64, #map0>
      %8 = affine.apply #map2(%arg4)
      %9 = load %2[%8, %6, %5] : memref<12x12x12xf64, #map0>
      %10 = affine.apply #map3(%arg4)
      %11 = load %2[%10, %6, %5] : memref<12x12x12xf64, #map0>
      %12 = load %2[%8, %arg3, %5] : memref<12x12x12xf64, #map0>
      %13 = affine.apply #map3(%arg3)
      %14 = load %2[%8, %13, %5] : memref<12x12x12xf64, #map0>
      %15 = load %2[%8, %6, %arg2] : memref<12x12x12xf64, #map0>
      %16 = affine.apply #map3(%arg2)
      %17 = load %2[%8, %6, %16] : memref<12x12x12xf64, #map0>
      %18 = fpext %cst_0 : f32 to f64
      %19 = mulf %18, %9 : f64
      %20 = subf %7, %19 : f64
      %21 = addf %20, %11 : f64
      %22 = fpext %cst : f32 to f64
      %23 = mulf %21, %22 : f64
      %24 = subf %12, %19 : f64
      %25 = addf %24, %14 : f64
      %26 = mulf %25, %22 : f64
      %27 = addf %23, %26 : f64
      %28 = subf %15, %19 : f64
      %29 = addf %28, %17 : f64
      %30 = mulf %29, %22 : f64
      %31 = addf %27, %30 : f64
      %32 = addf %31, %9 : f64
      store %32, %3[%arg4, %arg3, %arg2] : memref<10x10x10xf64, #map1>
      %33 = load %2[%arg4, %6, %5] : memref<12x12x12xf64, #map0>
      %34 = load %2[%8, %6, %5] : memref<12x12x12xf64, #map0>
      %35 = load %2[%10, %6, %5] : memref<12x12x12xf64, #map0>
      %36 = load %2[%8, %arg3, %5] : memref<12x12x12xf64, #map0>
      %37 = load %2[%8, %13, %5] : memref<12x12x12xf64, #map0>
      %38 = load %2[%8, %6, %arg2] : memref<12x12x12xf64, #map0>
      %39 = load %2[%8, %6, %16] : memref<12x12x12xf64, #map0>
      %40 = mulf %18, %34 : f64
      %41 = subf %33, %40 : f64
      %42 = addf %41, %35 : f64
      %43 = mulf %42, %22 : f64
      %44 = subf %36, %40 : f64
      %45 = addf %44, %37 : f64
      %46 = mulf %45, %22 : f64
      %47 = addf %43, %46 : f64
      %48 = subf %38, %40 : f64
      %49 = addf %48, %39 : f64
      %50 = mulf %49, %22 : f64
      %51 = addf %47, %50 : f64
      %52 = addf %51, %34 : f64
      store %52, %4[%arg4, %arg3, %arg2] : memref<10x10x10xf64, #map1>
      scf.yield
    }
    return
  }
}


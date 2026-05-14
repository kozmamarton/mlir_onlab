module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dti2 : memref<1xf32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @tprni : memref<1xf32>
  memref.global @kb : memref<1xi32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_advt1_(%arg0: memref<?xf32> {polygeist.name = "fb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fclim", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "zflux", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg19: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg20: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.get_global @kbm1 : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = arith.muli %8, %7 : index
    %10 = arith.muli %9, %2 : index
    %11 = arith.subi %8, %c1 : index
    %12 = arith.muli %11, %7 : index
    %13 = arith.muli %12, %2 : index
    scf.for %arg21 = %c0 to %2 step %c1 {
      scf.for %arg22 = %c0 to %7 step %c1 {
        %83 = arith.muli %arg21, %7 overflow<nsw> : index
        %84 = arith.addi %arg22, %83 : index
        %85 = arith.addi %84, %13 : index
        %86 = memref.load %arg1[%85] : memref<?xf32>
        %87 = arith.addi %84, %10 : index
        memref.store %86, %arg1[%87] : memref<?xf32>
        %88 = memref.load %arg0[%85] : memref<?xf32>
        memref.store %88, %arg0[%87] : memref<?xf32>
      }
    }
    %14 = memref.load %4[%c0] : memref<1xi32>
    %15 = arith.index_cast %14 : i32 to index
    %16 = memref.load %0[%c0] : memref<1xi32>
    %17 = memref.load %3[%c0] : memref<1xi32>
    %18 = arith.index_cast %16 : i32 to index
    %19 = arith.index_cast %17 : i32 to index
    %reinterpret_cast = memref.reinterpret_cast %arg9 to offset: [0], sizes: [%18, %19], strides: [%19, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %20 = arith.muli %19, %18 : index
    %reinterpret_cast_2 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%15, %18, %19], strides: [%20, %19, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg7 to offset: [0], sizes: [%15, %18, %19], strides: [%20, %19, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_4 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%15, %18, %19], strides: [%20, %19, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_5 = memref.reinterpret_cast %arg8 to offset: [0], sizes: [%15, %18, %19], strides: [%20, %19, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_6 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%15, %18, %19], strides: [%20, %19, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%15, %18, %19) step (%c1, %c1, %c1) {
      %83 = memref.load %reinterpret_cast[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %84 = arith.muli %arg22, %19 overflow<nsw> : index
      %85 = arith.addi %arg23, %84 : index
      %86 = arith.addi %85, %c-1 : index
      %87 = memref.load %arg9[%86] : memref<?xf32>
      %88 = arith.addf %83, %87 : f32
      %89 = memref.load %reinterpret_cast_2[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %90 = arith.muli %arg21, %19 overflow<nsw> : index
      %91 = arith.muli %90, %18 overflow<nsw> : index
      %92 = arith.addi %85, %91 : index
      %93 = arith.addi %92, %c-1 : index
      %94 = memref.load %arg1[%93] : memref<?xf32>
      %95 = arith.addf %89, %94 : f32
      %96 = arith.mulf %88, %95 : f32
      %97 = memref.load %reinterpret_cast_3[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %98 = arith.mulf %96, %97 : f32
      %99 = arith.mulf %98, %cst_1 : f32
      memref.store %99, %reinterpret_cast_4[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %100 = memref.load %reinterpret_cast[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %101 = arith.addi %arg22, %c-1 : index
      %102 = memref.load %reinterpret_cast[%101, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %103 = arith.addf %100, %102 : f32
      %104 = memref.load %reinterpret_cast_2[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %105 = memref.load %reinterpret_cast_2[%arg21, %101, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %106 = arith.addf %104, %105 : f32
      %107 = arith.mulf %103, %106 : f32
      %108 = memref.load %reinterpret_cast_5[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %109 = arith.mulf %107, %108 : f32
      %110 = arith.mulf %109, %cst_1 : f32
      memref.store %110, %reinterpret_cast_6[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %21 = memref.get_global @kb : memref<1xi32>
    %22 = memref.load %21[%c0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = memref.load %0[%c0] : memref<1xi32>
    %25 = memref.load %3[%c0] : memref<1xi32>
    %26 = arith.index_cast %24 : i32 to index
    %27 = arith.index_cast %25 : i32 to index
    %28 = arith.muli %27, %26 : index
    %reinterpret_cast_7 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%23, %26, %27], strides: [%28, %27, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_8 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%23, %26, %27], strides: [%28, %27, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%23, %26, %27) step (%c1, %c1, %c1) {
      %83 = memref.load %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %84 = memref.load %reinterpret_cast_8[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %85 = arith.subf %83, %84 : f32
      memref.store %85, %reinterpret_cast_7[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %29 = memref.load %4[%c0] : memref<1xi32>
    %30 = arith.index_cast %29 : i32 to index
    %31 = memref.get_global @tprni : memref<1xf32>
    %32 = memref.load %0[%c0] : memref<1xi32>
    %33 = memref.load %3[%c0] : memref<1xi32>
    %34 = memref.load %31[%c0] : memref<1xf32>
    %35 = arith.index_cast %32 : i32 to index
    %36 = arith.index_cast %33 : i32 to index
    %37 = arith.muli %36, %35 : index
    %reinterpret_cast_9 = memref.reinterpret_cast %arg10 to offset: [0], sizes: [%30, %35, %36], strides: [%37, %36, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_10 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%35, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_11 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%30, %35, %36], strides: [%37, %36, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_12 = memref.reinterpret_cast %arg11 to offset: [0], sizes: [%35, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_13 = memref.reinterpret_cast %arg13 to offset: [0], sizes: [%35, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_14 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%30, %35, %36], strides: [%37, %36, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_15 = memref.reinterpret_cast %arg12 to offset: [0], sizes: [%35, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_16 = memref.reinterpret_cast %arg14 to offset: [0], sizes: [%35, %36], strides: [%36, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_17 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%30, %35, %36], strides: [%37, %36, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c1, %c1) to (%30, %35, %36) step (%c1, %c1, %c1) {
      %83 = memref.load %reinterpret_cast_9[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %84 = arith.muli %arg22, %36 overflow<nsw> : index
      %85 = arith.addi %arg23, %84 : index
      %86 = arith.muli %arg21, %36 overflow<nsw> : index
      %87 = arith.muli %86, %35 overflow<nsw> : index
      %88 = arith.addi %85, %87 : index
      %89 = arith.addi %88, %c-1 : index
      %90 = memref.load %arg10[%89] : memref<?xf32>
      %91 = arith.addf %83, %90 : f32
      %92 = arith.mulf %91, %cst_0 : f32
      %93 = memref.load %reinterpret_cast_10[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %94 = arith.addi %85, %c-1 : index
      %95 = memref.load %arg16[%94] : memref<?xf32>
      %96 = arith.addf %93, %95 : f32
      %97 = arith.mulf %92, %96 : f32
      %98 = arith.mulf %97, %34 : f32
      %99 = memref.load %reinterpret_cast_11[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %100 = memref.load %arg0[%89] : memref<?xf32>
      %101 = arith.subf %99, %100 : f32
      %102 = arith.mulf %98, %101 : f32
      %103 = memref.load %reinterpret_cast_12[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %104 = arith.mulf %102, %103 : f32
      %105 = memref.load %reinterpret_cast_13[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %106 = memref.load %arg13[%94] : memref<?xf32>
      %107 = arith.addf %105, %106 : f32
      %108 = arith.divf %104, %107 : f32
      %109 = memref.load %reinterpret_cast_14[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %110 = arith.subf %109, %108 : f32
      memref.store %110, %reinterpret_cast_14[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %111 = memref.load %reinterpret_cast_9[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %112 = arith.addi %arg22, %c-1 : index
      %113 = memref.load %reinterpret_cast_9[%arg21, %112, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %114 = arith.addf %111, %113 : f32
      %115 = arith.mulf %114, %cst_0 : f32
      %116 = memref.load %reinterpret_cast_10[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %117 = memref.load %reinterpret_cast_10[%112, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %118 = arith.addf %116, %117 : f32
      %119 = arith.mulf %115, %118 : f32
      %120 = arith.mulf %119, %34 : f32
      %121 = memref.load %reinterpret_cast_11[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %122 = memref.load %reinterpret_cast_11[%arg21, %112, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %123 = arith.subf %121, %122 : f32
      %124 = arith.mulf %120, %123 : f32
      %125 = memref.load %reinterpret_cast_15[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %126 = arith.mulf %124, %125 : f32
      %127 = memref.load %reinterpret_cast_16[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %128 = memref.load %reinterpret_cast_16[%112, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %129 = arith.addf %127, %128 : f32
      %130 = arith.divf %126, %129 : f32
      %131 = memref.load %reinterpret_cast_17[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %132 = arith.subf %131, %130 : f32
      memref.store %132, %reinterpret_cast_17[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %133 = memref.load %reinterpret_cast_16[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %134 = memref.load %arg14[%94] : memref<?xf32>
      %135 = arith.addf %133, %134 : f32
      %136 = arith.mulf %135, %cst_0 : f32
      %137 = memref.load %reinterpret_cast_14[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %138 = arith.mulf %136, %137 : f32
      memref.store %138, %reinterpret_cast_14[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %139 = memref.load %reinterpret_cast_13[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %140 = memref.load %reinterpret_cast_13[%112, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %141 = arith.addf %139, %140 : f32
      %142 = arith.mulf %141, %cst_0 : f32
      %143 = memref.load %reinterpret_cast_17[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %144 = arith.mulf %142, %143 : f32
      memref.store %144, %reinterpret_cast_17[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %38 = memref.load %21[%c0] : memref<1xi32>
    %39 = arith.index_cast %38 : i32 to index
    %40 = memref.load %0[%c0] : memref<1xi32>
    %41 = memref.load %3[%c0] : memref<1xi32>
    %42 = arith.index_cast %40 : i32 to index
    %43 = arith.index_cast %41 : i32 to index
    %44 = arith.muli %43, %42 : index
    %reinterpret_cast_18 = memref.reinterpret_cast %arg2 to offset: [0], sizes: [%39, %42, %43], strides: [%44, %43, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_19 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%39, %42, %43], strides: [%44, %43, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c0, %c0, %c0) to (%39, %42, %43) step (%c1, %c1, %c1) {
      %83 = memref.load %reinterpret_cast_18[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %84 = memref.load %reinterpret_cast_19[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %85 = arith.addf %84, %83 : f32
      memref.store %85, %reinterpret_cast_19[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %45 = memref.get_global @jmm1 : memref<1xi32>
    %46 = memref.load %45[%c0] : memref<1xi32>
    %47 = arith.index_cast %46 : i32 to index
    %48 = memref.get_global @imm1 : memref<1xi32>
    %49 = memref.load %48[%c0] : memref<1xi32>
    %50 = memref.load %3[%c0] : memref<1xi32>
    %51 = memref.load %4[%c0] : memref<1xi32>
    %52 = memref.load %0[%c0] : memref<1xi32>
    %53 = arith.index_cast %49 : i32 to index
    %54 = arith.index_cast %50 : i32 to index
    %55 = arith.index_cast %51 : i32 to index
    %56 = arith.muli %55, %54 : index
    %57 = arith.index_cast %52 : i32 to index
    %58 = arith.muli %56, %57 : index
    %reinterpret_cast_20 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%47, %54], strides: [%54, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_21 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%47, %54], strides: [%54, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_22 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%47, %54], strides: [%54, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_23 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%47, %54], strides: [%54, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.for %arg21 = %c1 to %47 step %c1 {
      scf.for %arg22 = %c1 to %53 step %c1 {
        %83 = memref.load %reinterpret_cast_20[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %84 = memref.load %reinterpret_cast_21[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %85 = arith.mulf %83, %84 : f32
        %86 = memref.load %reinterpret_cast_22[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %87 = arith.mulf %85, %86 : f32
        memref.store %87, %reinterpret_cast_23[%arg21, %arg22] : memref<?x?xf32, strided<[?, 1]>>
        %88 = arith.muli %arg21, %54 overflow<nsw> : index
        %89 = arith.addi %arg22, %88 : index
        %90 = arith.addi %89, %58 : index
        memref.store %cst, %arg6[%90] : memref<?xf32>
      }
    }
    %59 = memref.load %4[%c0] : memref<1xi32>
    %60 = arith.index_cast %59 : i32 to index
    %61 = memref.load %45[%c0] : memref<1xi32>
    %62 = memref.load %48[%c0] : memref<1xi32>
    %63 = memref.load %3[%c0] : memref<1xi32>
    %64 = memref.load %0[%c0] : memref<1xi32>
    %65 = arith.index_cast %61 : i32 to index
    %66 = arith.index_cast %62 : i32 to index
    %67 = arith.index_cast %63 : i32 to index
    %68 = arith.index_cast %64 : i32 to index
    %69 = arith.muli %67, %68 : index
    %reinterpret_cast_24 = memref.reinterpret_cast %arg1 to offset: [0], sizes: [%60, %68, %67], strides: [%69, %67, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_25 = memref.reinterpret_cast %arg17 to offset: [0], sizes: [%60, %68, %67], strides: [%69, %67, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_26 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%65, %67], strides: [%67, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_27 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%60, %68, %67], strides: [%69, %67, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    scf.parallel (%arg21, %arg22, %arg23) = (%c1, %c1, %c1) to (%60, %65, %66) step (%c1, %c1, %c1) {
      %83 = arith.addi %arg21, %c-1 : index
      %84 = memref.load %reinterpret_cast_24[%83, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %85 = memref.load %reinterpret_cast_24[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %86 = arith.addf %84, %85 : f32
      %87 = arith.mulf %86, %cst_0 : f32
      %88 = memref.load %reinterpret_cast_25[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      %89 = arith.mulf %87, %88 : f32
      %90 = memref.load %reinterpret_cast_26[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
      %91 = arith.mulf %89, %90 : f32
      memref.store %91, %reinterpret_cast_27[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
      scf.reduce 
    }
    %70 = memref.load %4[%c0] : memref<1xi32>
    %71 = arith.index_cast %70 : i32 to index
    %72 = memref.get_global @dti2 : memref<1xf32>
    %73 = memref.load %45[%c0] : memref<1xi32>
    %74 = memref.load %48[%c0] : memref<1xi32>
    %75 = memref.load %3[%c0] : memref<1xi32>
    %76 = memref.load %0[%c0] : memref<1xi32>
    %77 = memref.load %72[%c0] : memref<1xf32>
    %78 = arith.index_cast %73 : i32 to index
    %79 = arith.index_cast %74 : i32 to index
    %80 = arith.index_cast %75 : i32 to index
    %81 = arith.index_cast %76 : i32 to index
    %82 = arith.muli %80, %81 : index
    %reinterpret_cast_28 = memref.reinterpret_cast %arg4 to offset: [0], sizes: [%71, %81, %80], strides: [%82, %80, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_29 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%71, %81, %80], strides: [%82, %80, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_30 = memref.reinterpret_cast %arg6 to offset: [0], sizes: [%71, %81, %80], strides: [%82, %80, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_31 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%71, %81, %80], strides: [%82, %80, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_32 = memref.reinterpret_cast %arg0 to offset: [0], sizes: [%71, %81, %80], strides: [%82, %80, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_33 = memref.reinterpret_cast %arg16 to offset: [0], sizes: [%78, %80], strides: [%80, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_34 = memref.reinterpret_cast %arg19 to offset: [0], sizes: [%78, %80], strides: [%80, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_35 = memref.reinterpret_cast %arg18 to offset: [0], sizes: [%78, %80], strides: [%80, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    %reinterpret_cast_36 = memref.reinterpret_cast %arg20 to offset: [0], sizes: [%78, %80], strides: [%80, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg21) = (%c0) to (%71) step (%c1) {
      %83 = memref.load %arg15[%arg21] : memref<?xf32>
      scf.parallel (%arg22, %arg23) = (%c1, %c1) to (%78, %79) step (%c1, %c1) {
        %84 = arith.muli %arg22, %80 overflow<nsw> : index
        %85 = arith.addi %arg23, %84 : index
        %86 = arith.muli %arg21, %80 overflow<nsw> : index
        %87 = arith.muli %86, %81 overflow<nsw> : index
        %88 = arith.addi %85, %87 : index
        %89 = arith.addi %88, %c1 : index
        %90 = memref.load %arg4[%89] : memref<?xf32>
        %91 = memref.load %reinterpret_cast_28[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %92 = arith.subf %90, %91 : f32
        %93 = arith.addi %arg22, %c1 : index
        %94 = memref.load %reinterpret_cast_29[%arg21, %93, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %95 = arith.addf %92, %94 : f32
        %96 = memref.load %reinterpret_cast_29[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %97 = arith.subf %95, %96 : f32
        %98 = memref.load %reinterpret_cast_30[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %99 = arith.addi %arg21, %c1 : index
        %100 = memref.load %reinterpret_cast_30[%99, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %101 = arith.subf %98, %100 : f32
        %102 = arith.divf %101, %83 : f32
        %103 = arith.addf %97, %102 : f32
        memref.store %103, %reinterpret_cast_31[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %104 = memref.load %reinterpret_cast_32[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %105 = memref.load %reinterpret_cast_33[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
        %106 = memref.load %reinterpret_cast_34[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
        %107 = arith.addf %105, %106 : f32
        %108 = arith.mulf %104, %107 : f32
        %109 = memref.load %reinterpret_cast_35[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
        %110 = arith.mulf %108, %109 : f32
        %111 = arith.mulf %77, %103 : f32
        %112 = arith.subf %110, %111 : f32
        %113 = memref.load %reinterpret_cast_36[%arg22, %arg23] : memref<?x?xf32, strided<[?, 1]>>
        %114 = arith.addf %105, %113 : f32
        %115 = arith.mulf %114, %109 : f32
        %116 = arith.divf %112, %115 : f32
        memref.store %116, %reinterpret_cast_31[%arg21, %arg22, %arg23] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      }
      scf.reduce 
    }
    return
  }
}


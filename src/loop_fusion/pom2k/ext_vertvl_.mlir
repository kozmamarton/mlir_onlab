module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_vertvl_(%arg0: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vfluxb", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dti2", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 5.000000e-01 : f32
    %cst_0 = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    scf.for %arg14 = %c0 to %2 step %c1 {
      %37 = arith.addi %7, %c-1 : index
      scf.for %arg15 = %c0 to %37 step %c1 {
        %38 = arith.addi %8, %c-1 : index
        scf.for %arg16 = %c0 to %38 step %c1 {
          %39 = arith.addi %arg15, %c1 : index
          %40 = arith.muli %39, %8 overflow<nsw> : index
          %41 = arith.addi %arg16, %40 : index
          %42 = arith.addi %41, %c1 : index
          %43 = memref.load %arg3[%42] : memref<?xf32>
          %44 = memref.load %arg3[%41] : memref<?xf32>
          %45 = arith.addf %43, %44 : f32
          %46 = arith.mulf %45, %cst_0 : f32
          %47 = memref.load %arg4[%42] : memref<?xf32>
          %48 = memref.load %arg4[%41] : memref<?xf32>
          %49 = arith.addf %47, %48 : f32
          %50 = arith.mulf %46, %49 : f32
          %51 = arith.muli %arg14, %8 overflow<nsw> : index
          %52 = arith.muli %51, %7 overflow<nsw> : index
          %53 = arith.addi %41, %52 : index
          %54 = arith.addi %53, %c1 : index
          %55 = memref.load %arg5[%54] : memref<?xf32>
          %56 = arith.mulf %50, %55 : f32
          memref.store %56, %arg0[%54] : memref<?xf32>
        }
      }
    }
    %9 = memref.load %0[%c0] : memref<1xi32>
    %10 = arith.index_cast %9 : i32 to index
    %11 = memref.load %3[%c0] : memref<1xi32>
    %12 = memref.load %4[%c0] : memref<1xi32>
    %13 = arith.index_cast %11 : i32 to index
    %14 = arith.index_cast %12 : i32 to index
    scf.for %arg14 = %c0 to %10 step %c1 {
      %37 = arith.addi %13, %c-1 : index
      scf.for %arg15 = %c0 to %37 step %c1 {
        %38 = arith.addi %14, %c-1 : index
        scf.for %arg16 = %c0 to %38 step %c1 {
          %39 = arith.addi %arg15, %c1 : index
          %40 = arith.muli %39, %14 overflow<nsw> : index
          %41 = arith.addi %arg16, %40 : index
          %42 = arith.addi %41, %c1 : index
          %43 = memref.load %arg2[%42] : memref<?xf32>
          %44 = arith.muli %arg15, %14 overflow<nsw> : index
          %45 = arith.addi %arg16, %44 : index
          %46 = arith.addi %45, %c1 : index
          %47 = memref.load %arg2[%46] : memref<?xf32>
          %48 = arith.addf %43, %47 : f32
          %49 = arith.mulf %48, %cst_0 : f32
          %50 = memref.load %arg4[%42] : memref<?xf32>
          %51 = memref.load %arg4[%46] : memref<?xf32>
          %52 = arith.addf %50, %51 : f32
          %53 = arith.mulf %49, %52 : f32
          %54 = arith.muli %arg14, %14 overflow<nsw> : index
          %55 = arith.muli %54, %13 overflow<nsw> : index
          %56 = arith.addi %41, %55 : index
          %57 = arith.addi %56, %c1 : index
          %58 = memref.load %arg6[%57] : memref<?xf32>
          %59 = arith.mulf %53, %58 : f32
          memref.store %59, %arg1[%57] : memref<?xf32>
        }
      }
    }
    %15 = memref.get_global @jmm1 : memref<1xi32>
    %16 = memref.load %15[%c0] : memref<1xi32>
    %17 = arith.index_cast %16 : i32 to index
    %18 = memref.get_global @imm1 : memref<1xi32>
    %19 = memref.load %18[%c0] : memref<1xi32>
    %20 = memref.load %4[%c0] : memref<1xi32>
    %21 = arith.index_cast %19 : i32 to index
    %22 = arith.index_cast %20 : i32 to index
    %23 = arith.addi %17, %c-1 : index
    scf.for %arg14 = %c0 to %23 step %c1 {
      %37 = arith.addi %21, %c-1 : index
      scf.for %arg15 = %c0 to %37 step %c1 {
        %38 = arith.addi %arg14, %c1 : index
        %39 = arith.muli %38, %22 overflow<nsw> : index
        %40 = arith.addi %arg15, %39 : index
        %41 = arith.addi %40, %c1 : index
        %42 = memref.load %arg8[%41] : memref<?xf32>
        %43 = memref.load %arg9[%41] : memref<?xf32>
        %44 = arith.addf %42, %43 : f32
        %45 = arith.mulf %44, %cst : f32
        memref.store %45, %arg7[%41] : memref<?xf32>
      }
    }
    %24 = memref.get_global @kb : memref<1xi32>
    %25 = memref.load %24[%c0] : memref<1xi32>
    %26 = arith.index_cast %25 : i32 to index
    %27 = memref.load %15[%c0] : memref<1xi32>
    %28 = memref.load %18[%c0] : memref<1xi32>
    %29 = memref.load %4[%c0] : memref<1xi32>
    %30 = memref.load %3[%c0] : memref<1xi32>
    %31 = memref.load %arg13[%c0] : memref<?xf32>
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    %35 = arith.index_cast %30 : i32 to index
    %36 = arith.addi %26, %c-1 : index
    scf.for %arg14 = %c0 to %36 step %c1 {
      %37 = memref.load %arg12[%arg14] : memref<?xf32>
      %38 = arith.addi %32, %c-1 : index
      scf.for %arg15 = %c0 to %38 step %c1 {
        %39 = arith.addi %33, %c-1 : index
        scf.for %arg16 = %c0 to %39 step %c1 {
          %40 = arith.addi %arg15, %c1 : index
          %41 = arith.muli %40, %34 overflow<nsw> : index
          %42 = arith.addi %arg16, %41 : index
          %43 = arith.muli %arg14, %34 overflow<nsw> : index
          %44 = arith.muli %43, %35 overflow<nsw> : index
          %45 = arith.addi %42, %44 : index
          %46 = arith.addi %45, %c1 : index
          %47 = memref.load %arg7[%46] : memref<?xf32>
          %48 = arith.addi %45, %c2 : index
          %49 = memref.load %arg0[%48] : memref<?xf32>
          %50 = memref.load %arg0[%46] : memref<?xf32>
          %51 = arith.subf %49, %50 : f32
          %52 = arith.addi %arg15, %c2 : index
          %53 = arith.muli %52, %34 overflow<nsw> : index
          %54 = arith.addi %arg16, %53 : index
          %55 = arith.addi %54, %44 : index
          %56 = arith.addi %55, %c1 : index
          %57 = memref.load %arg1[%56] : memref<?xf32>
          %58 = arith.addf %51, %57 : f32
          %59 = memref.load %arg1[%46] : memref<?xf32>
          %60 = arith.subf %58, %59 : f32
          %61 = arith.addi %42, %c1 : index
          %62 = memref.load %arg2[%61] : memref<?xf32>
          %63 = memref.load %arg3[%61] : memref<?xf32>
          %64 = arith.mulf %62, %63 : f32
          %65 = arith.divf %60, %64 : f32
          %66 = memref.load %arg10[%61] : memref<?xf32>
          %67 = memref.load %arg11[%61] : memref<?xf32>
          %68 = arith.subf %66, %67 : f32
          %69 = arith.divf %68, %31 : f32
          %70 = arith.addf %65, %69 : f32
          %71 = arith.mulf %37, %70 : f32
          %72 = arith.addf %47, %71 : f32
          %73 = arith.addi %arg14, %c1 : index
          %74 = arith.muli %73, %34 overflow<nsw> : index
          %75 = arith.muli %74, %35 overflow<nsw> : index
          %76 = arith.addi %42, %75 : index
          %77 = arith.addi %76, %c1 : index
          memref.store %72, %arg7[%77] : memref<?xf32>
        }
      }
    }
    return
  }
}


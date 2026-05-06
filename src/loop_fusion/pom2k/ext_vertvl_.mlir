module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @kb : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_vertvl_(%arg0: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "vfluxb", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dti2", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
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
      scf.for %arg15 = %c1 to %7 step %c1 {
        scf.for %arg16 = %c1 to %8 step %c1 {
          %35 = arith.muli %arg15, %8 overflow<nsw> : index
          %36 = arith.addi %arg16, %35 : index
          %37 = memref.load %arg3[%36] : memref<?xf32>
          %38 = arith.addi %36, %c-1 : index
          %39 = memref.load %arg3[%38] : memref<?xf32>
          %40 = arith.addf %37, %39 : f32
          %41 = arith.mulf %40, %cst_0 : f32
          %42 = memref.load %arg4[%36] : memref<?xf32>
          %43 = memref.load %arg4[%38] : memref<?xf32>
          %44 = arith.addf %42, %43 : f32
          %45 = arith.mulf %41, %44 : f32
          %46 = arith.muli %arg14, %8 overflow<nsw> : index
          %47 = arith.muli %46, %7 overflow<nsw> : index
          %48 = arith.addi %36, %47 : index
          %49 = memref.load %arg5[%48] : memref<?xf32>
          %50 = arith.mulf %45, %49 : f32
          memref.store %50, %arg0[%48] : memref<?xf32>
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
      scf.for %arg15 = %c1 to %13 step %c1 {
        scf.for %arg16 = %c1 to %14 step %c1 {
          %35 = arith.muli %arg15, %14 overflow<nsw> : index
          %36 = arith.addi %arg16, %35 : index
          %37 = memref.load %arg2[%36] : memref<?xf32>
          %38 = arith.addi %arg15, %c-1 : index
          %39 = arith.muli %38, %14 overflow<nsw> : index
          %40 = arith.addi %arg16, %39 : index
          %41 = memref.load %arg2[%40] : memref<?xf32>
          %42 = arith.addf %37, %41 : f32
          %43 = arith.mulf %42, %cst_0 : f32
          %44 = memref.load %arg4[%36] : memref<?xf32>
          %45 = memref.load %arg4[%40] : memref<?xf32>
          %46 = arith.addf %44, %45 : f32
          %47 = arith.mulf %43, %46 : f32
          %48 = arith.muli %arg14, %14 overflow<nsw> : index
          %49 = arith.muli %48, %13 overflow<nsw> : index
          %50 = arith.addi %36, %49 : index
          %51 = memref.load %arg6[%50] : memref<?xf32>
          %52 = arith.mulf %47, %51 : f32
          memref.store %52, %arg1[%50] : memref<?xf32>
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
    scf.for %arg14 = %c1 to %17 step %c1 {
      scf.for %arg15 = %c1 to %21 step %c1 {
        %35 = arith.muli %arg14, %22 overflow<nsw> : index
        %36 = arith.addi %arg15, %35 : index
        %37 = memref.load %arg8[%36] : memref<?xf32>
        %38 = memref.load %arg9[%36] : memref<?xf32>
        %39 = arith.addf %37, %38 : f32
        %40 = arith.mulf %39, %cst : f32
        memref.store %40, %arg7[%36] : memref<?xf32>
      }
    }
    %23 = memref.get_global @kb : memref<1xi32>
    %24 = memref.load %23[%c0] : memref<1xi32>
    %25 = arith.index_cast %24 : i32 to index
    %26 = memref.load %15[%c0] : memref<1xi32>
    %27 = memref.load %18[%c0] : memref<1xi32>
    %28 = memref.load %4[%c0] : memref<1xi32>
    %29 = memref.load %3[%c0] : memref<1xi32>
    %30 = memref.load %arg13[%c0] : memref<?xf32>
    %31 = arith.index_cast %26 : i32 to index
    %32 = arith.index_cast %27 : i32 to index
    %33 = arith.index_cast %28 : i32 to index
    %34 = arith.index_cast %29 : i32 to index
    scf.for %arg14 = %c1 to %25 step %c1 {
      %35 = arith.addi %arg14, %c-1 : index
      %36 = memref.load %arg12[%35] : memref<?xf32>
      scf.for %arg15 = %c1 to %31 step %c1 {
        scf.for %arg16 = %c1 to %32 step %c1 {
          %37 = arith.muli %arg15, %33 overflow<nsw> : index
          %38 = arith.addi %arg16, %37 : index
          %39 = arith.muli %35, %33 overflow<nsw> : index
          %40 = arith.muli %39, %34 overflow<nsw> : index
          %41 = arith.addi %38, %40 : index
          %42 = memref.load %arg7[%41] : memref<?xf32>
          %43 = arith.addi %41, %c1 : index
          %44 = memref.load %arg0[%43] : memref<?xf32>
          %45 = memref.load %arg0[%41] : memref<?xf32>
          %46 = arith.subf %44, %45 : f32
          %47 = arith.addi %arg15, %c1 : index
          %48 = arith.muli %47, %33 overflow<nsw> : index
          %49 = arith.addi %arg16, %48 : index
          %50 = arith.addi %49, %40 : index
          %51 = memref.load %arg1[%50] : memref<?xf32>
          %52 = arith.addf %46, %51 : f32
          %53 = memref.load %arg1[%41] : memref<?xf32>
          %54 = arith.subf %52, %53 : f32
          %55 = memref.load %arg2[%38] : memref<?xf32>
          %56 = memref.load %arg3[%38] : memref<?xf32>
          %57 = arith.mulf %55, %56 : f32
          %58 = arith.divf %54, %57 : f32
          %59 = memref.load %arg10[%38] : memref<?xf32>
          %60 = memref.load %arg11[%38] : memref<?xf32>
          %61 = arith.subf %59, %60 : f32
          %62 = arith.divf %61, %30 : f32
          %63 = arith.addf %58, %62 : f32
          %64 = arith.mulf %36, %63 : f32
          %65 = arith.addf %42, %64 : f32
          %66 = arith.muli %arg14, %33 overflow<nsw> : index
          %67 = arith.muli %66, %34 overflow<nsw> : index
          %68 = arith.addi %38, %67 : index
          memref.store %65, %arg7[%68] : memref<?xf32>
        }
      }
    }
    return
  }
}


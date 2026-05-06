module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @horcon : memref<1xf32>
  memref.global @jm : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_aam_(%arg0: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %0 = memref.get_global @kbm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jmm1 : memref<1xi32>
    %4 = memref.get_global @imm1 : memref<1xi32>
    %5 = memref.get_global @im : memref<1xi32>
    %6 = memref.get_global @jm : memref<1xi32>
    %7 = memref.get_global @horcon : memref<1xf32>
    %8 = memref.load %3[%c0] : memref<1xi32>
    %9 = memref.load %4[%c0] : memref<1xi32>
    %10 = memref.load %5[%c0] : memref<1xi32>
    %11 = memref.load %6[%c0] : memref<1xi32>
    %12 = memref.load %7[%c0] : memref<1xf32>
    %13 = arith.index_cast %8 : i32 to index
    %14 = arith.index_cast %9 : i32 to index
    %15 = arith.index_cast %10 : i32 to index
    %16 = arith.index_cast %11 : i32 to index
    scf.for %arg5 = %c0 to %2 step %c1 {
      scf.for %arg6 = %c1 to %13 step %c1 {
        scf.for %arg7 = %c1 to %14 step %c1 {
          %17 = arith.muli %arg6, %15 overflow<nsw> : index
          %18 = arith.addi %arg7, %17 : index
          %19 = memref.load %arg1[%18] : memref<?xf32>
          %20 = arith.mulf %12, %19 : f32
          %21 = memref.load %arg2[%18] : memref<?xf32>
          %22 = arith.mulf %20, %21 : f32
          %23 = arith.muli %arg5, %15 overflow<nsw> : index
          %24 = arith.muli %23, %16 overflow<nsw> : index
          %25 = arith.addi %18, %24 : index
          %26 = arith.addi %25, %c1 : index
          %27 = memref.load %arg3[%26] : memref<?xf32>
          %28 = memref.load %arg3[%25] : memref<?xf32>
          %29 = arith.subf %27, %28 : f32
          %30 = arith.divf %29, %19 : f32
          %31 = arith.mulf %30, %30 : f32
          %32 = arith.addi %arg6, %c1 : index
          %33 = arith.muli %32, %15 overflow<nsw> : index
          %34 = arith.addi %arg7, %33 : index
          %35 = arith.addi %34, %24 : index
          %36 = memref.load %arg4[%35] : memref<?xf32>
          %37 = memref.load %arg4[%25] : memref<?xf32>
          %38 = arith.subf %36, %37 : f32
          %39 = arith.divf %38, %21 : f32
          %40 = arith.mulf %39, %39 : f32
          %41 = arith.addf %31, %40 : f32
          %42 = memref.load %arg3[%35] : memref<?xf32>
          %43 = arith.addi %35, %c1 : index
          %44 = memref.load %arg3[%43] : memref<?xf32>
          %45 = arith.addf %42, %44 : f32
          %46 = arith.addi %arg6, %c-1 : index
          %47 = arith.muli %46, %15 overflow<nsw> : index
          %48 = arith.addi %arg7, %47 : index
          %49 = arith.addi %48, %24 : index
          %50 = memref.load %arg3[%49] : memref<?xf32>
          %51 = arith.subf %45, %50 : f32
          %52 = arith.addi %49, %c1 : index
          %53 = memref.load %arg3[%52] : memref<?xf32>
          %54 = arith.subf %51, %53 : f32
          %55 = arith.mulf %54, %cst : f32
          %56 = arith.divf %55, %21 : f32
          %57 = memref.load %arg4[%26] : memref<?xf32>
          %58 = memref.load %arg4[%43] : memref<?xf32>
          %59 = arith.addf %57, %58 : f32
          %60 = arith.addi %25, %c-1 : index
          %61 = memref.load %arg4[%60] : memref<?xf32>
          %62 = arith.subf %59, %61 : f32
          %63 = arith.addi %35, %c-1 : index
          %64 = memref.load %arg4[%63] : memref<?xf32>
          %65 = arith.subf %62, %64 : f32
          %66 = arith.mulf %65, %cst : f32
          %67 = arith.divf %66, %19 : f32
          %68 = arith.addf %56, %67 : f32
          %69 = arith.mulf %68, %cst_0 : f32
          %70 = arith.mulf %69, %68 : f32
          %71 = arith.addf %41, %70 : f32
          %72 = math.sqrt %71 : f32
          %73 = arith.mulf %22, %72 : f32
          memref.store %73, %arg0[%25] : memref<?xf32>
        }
      }
    }
    return
  }
}


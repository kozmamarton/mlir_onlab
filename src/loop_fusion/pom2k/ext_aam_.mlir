module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @horcon : memref<1xf32>
  memref.global @jm : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  func.func @ext_aam_(%arg0: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
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
      %17 = arith.addi %13, %c-1 : index
      scf.for %arg6 = %c0 to %17 step %c1 {
        %18 = arith.addi %14, %c-1 : index
        scf.for %arg7 = %c0 to %18 step %c1 {
          %19 = arith.addi %arg6, %c1 : index
          %20 = arith.muli %19, %15 overflow<nsw> : index
          %21 = arith.addi %arg7, %20 : index
          %22 = arith.addi %21, %c1 : index
          %23 = memref.load %arg1[%22] : memref<?xf32>
          %24 = arith.mulf %12, %23 : f32
          %25 = memref.load %arg2[%22] : memref<?xf32>
          %26 = arith.mulf %24, %25 : f32
          %27 = arith.muli %arg5, %15 overflow<nsw> : index
          %28 = arith.muli %27, %16 overflow<nsw> : index
          %29 = arith.addi %21, %28 : index
          %30 = arith.addi %29, %c2 : index
          %31 = memref.load %arg3[%30] : memref<?xf32>
          %32 = arith.addi %29, %c1 : index
          %33 = memref.load %arg3[%32] : memref<?xf32>
          %34 = arith.subf %31, %33 : f32
          %35 = arith.divf %34, %23 : f32
          %36 = arith.mulf %35, %35 : f32
          %37 = arith.addi %arg6, %c2 : index
          %38 = arith.muli %37, %15 overflow<nsw> : index
          %39 = arith.addi %arg7, %38 : index
          %40 = arith.addi %39, %28 : index
          %41 = arith.addi %40, %c1 : index
          %42 = memref.load %arg4[%41] : memref<?xf32>
          %43 = memref.load %arg4[%32] : memref<?xf32>
          %44 = arith.subf %42, %43 : f32
          %45 = arith.divf %44, %25 : f32
          %46 = arith.mulf %45, %45 : f32
          %47 = arith.addf %36, %46 : f32
          %48 = memref.load %arg3[%41] : memref<?xf32>
          %49 = arith.addi %40, %c2 : index
          %50 = memref.load %arg3[%49] : memref<?xf32>
          %51 = arith.addf %48, %50 : f32
          %52 = arith.muli %arg6, %15 overflow<nsw> : index
          %53 = arith.addi %arg7, %52 : index
          %54 = arith.addi %53, %28 : index
          %55 = arith.addi %54, %c1 : index
          %56 = memref.load %arg3[%55] : memref<?xf32>
          %57 = arith.subf %51, %56 : f32
          %58 = arith.addi %54, %c2 : index
          %59 = memref.load %arg3[%58] : memref<?xf32>
          %60 = arith.subf %57, %59 : f32
          %61 = arith.mulf %60, %cst : f32
          %62 = arith.divf %61, %25 : f32
          %63 = memref.load %arg4[%30] : memref<?xf32>
          %64 = memref.load %arg4[%49] : memref<?xf32>
          %65 = arith.addf %63, %64 : f32
          %66 = memref.load %arg4[%29] : memref<?xf32>
          %67 = arith.subf %65, %66 : f32
          %68 = memref.load %arg4[%40] : memref<?xf32>
          %69 = arith.subf %67, %68 : f32
          %70 = arith.mulf %69, %cst : f32
          %71 = arith.divf %70, %23 : f32
          %72 = arith.addf %62, %71 : f32
          %73 = arith.mulf %72, %cst_0 : f32
          %74 = arith.mulf %73, %72 : f32
          %75 = arith.addf %47, %74 : f32
          %76 = math.sqrt %75 : f32
          %77 = arith.mulf %26, %76 : f32
          memref.store %77, %arg0[%32] : memref<?xf32>
        }
      }
    }
    return
  }
}


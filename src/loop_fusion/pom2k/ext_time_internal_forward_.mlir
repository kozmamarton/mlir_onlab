module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_time_internal_forward_(%arg0: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "ispi", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "isp2i", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = memref.load %arg2[%c0] : memref<?xf32>
    %6 = arith.index_cast %4 : i32 to index
    scf.for %arg9 = %c0 to %2 step %c1 {
      scf.for %arg10 = %c0 to %6 step %c1 {
        %18 = arith.muli %arg9, %6 overflow<nsw> : index
        %19 = arith.addi %arg10, %18 : index
        %20 = memref.load %arg1[%19] : memref<?xf32>
        %21 = arith.mulf %20, %5 : f32
        memref.store %21, %arg0[%19] : memref<?xf32>
      }
    }
    %7 = memref.load %0[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %3[%c0] : memref<1xi32>
    %10 = memref.load %arg6[%c0] : memref<?xf32>
    %11 = arith.index_cast %9 : i32 to index
    scf.for %arg9 = %c0 to %8 step %c1 {
      %18 = arith.addi %11, %c-1 : index
      scf.for %arg10 = %c0 to %18 step %c1 {
        %19 = arith.muli %arg9, %11 overflow<nsw> : index
        %20 = arith.addi %arg10, %19 : index
        %21 = arith.addi %20, %c1 : index
        %22 = memref.load %arg4[%21] : memref<?xf32>
        %23 = memref.load %arg5[%21] : memref<?xf32>
        %24 = memref.load %arg5[%20] : memref<?xf32>
        %25 = arith.addf %23, %24 : f32
        %26 = arith.mulf %22, %25 : f32
        %27 = arith.mulf %26, %10 : f32
        memref.store %27, %arg3[%21] : memref<?xf32>
      }
    }
    %12 = memref.load %0[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.load %3[%c0] : memref<1xi32>
    %15 = memref.load %arg6[%c0] : memref<?xf32>
    %16 = arith.index_cast %14 : i32 to index
    %17 = arith.addi %13, %c-1 : index
    scf.for %arg9 = %c0 to %17 step %c1 {
      %18 = arith.addi %16, %c-1 : index
      scf.for %arg10 = %c0 to %18 step %c1 {
        %19 = arith.addi %arg9, %c1 : index
        %20 = arith.muli %19, %16 overflow<nsw> : index
        %21 = arith.addi %arg10, %20 : index
        %22 = arith.addi %21, %c1 : index
        %23 = memref.load %arg8[%22] : memref<?xf32>
        %24 = memref.load %arg5[%22] : memref<?xf32>
        %25 = arith.muli %arg9, %16 overflow<nsw> : index
        %26 = arith.addi %arg10, %25 : index
        %27 = arith.addi %26, %c1 : index
        %28 = memref.load %arg5[%27] : memref<?xf32>
        %29 = arith.addf %24, %28 : f32
        %30 = arith.mulf %23, %29 : f32
        %31 = arith.mulf %30, %15 : f32
        memref.store %31, %arg7[%22] : memref<?xf32>
      }
    }
    return
  }
}


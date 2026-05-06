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
        %17 = arith.muli %arg9, %6 overflow<nsw> : index
        %18 = arith.addi %arg10, %17 : index
        %19 = memref.load %arg1[%18] : memref<?xf32>
        %20 = arith.mulf %19, %5 : f32
        memref.store %20, %arg0[%18] : memref<?xf32>
      }
    }
    %7 = memref.load %0[%c0] : memref<1xi32>
    %8 = arith.index_cast %7 : i32 to index
    %9 = memref.load %3[%c0] : memref<1xi32>
    %10 = memref.load %arg6[%c0] : memref<?xf32>
    %11 = arith.index_cast %9 : i32 to index
    scf.for %arg9 = %c0 to %8 step %c1 {
      scf.for %arg10 = %c1 to %11 step %c1 {
        %17 = arith.muli %arg9, %11 overflow<nsw> : index
        %18 = arith.addi %arg10, %17 : index
        %19 = memref.load %arg4[%18] : memref<?xf32>
        %20 = memref.load %arg5[%18] : memref<?xf32>
        %21 = arith.addi %18, %c-1 : index
        %22 = memref.load %arg5[%21] : memref<?xf32>
        %23 = arith.addf %20, %22 : f32
        %24 = arith.mulf %19, %23 : f32
        %25 = arith.mulf %24, %10 : f32
        memref.store %25, %arg3[%18] : memref<?xf32>
      }
    }
    %12 = memref.load %0[%c0] : memref<1xi32>
    %13 = arith.index_cast %12 : i32 to index
    %14 = memref.load %3[%c0] : memref<1xi32>
    %15 = memref.load %arg6[%c0] : memref<?xf32>
    %16 = arith.index_cast %14 : i32 to index
    scf.for %arg9 = %c1 to %13 step %c1 {
      scf.for %arg10 = %c1 to %16 step %c1 {
        %17 = arith.muli %arg9, %16 overflow<nsw> : index
        %18 = arith.addi %arg10, %17 : index
        %19 = memref.load %arg8[%18] : memref<?xf32>
        %20 = memref.load %arg5[%18] : memref<?xf32>
        %21 = arith.addi %arg9, %c-1 : index
        %22 = arith.muli %21, %16 overflow<nsw> : index
        %23 = arith.addi %arg10, %22 : index
        %24 = memref.load %arg5[%23] : memref<?xf32>
        %25 = arith.addf %20, %24 : f32
        %26 = arith.mulf %19, %25 : f32
        %27 = arith.mulf %26, %15 : f32
        memref.store %27, %arg7[%18] : memref<?xf32>
      }
    }
    return
  }
}


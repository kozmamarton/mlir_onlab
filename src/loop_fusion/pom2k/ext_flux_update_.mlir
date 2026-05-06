module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_flux_update_(%arg0: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    scf.for %arg7 = %c1 to %2 step %c1 {
      scf.for %arg8 = %c1 to %5 step %c1 {
        %6 = arith.muli %arg7, %5 overflow<nsw> : index
        %7 = arith.addi %arg8, %6 : index
        %8 = memref.load %arg2[%7] : memref<?xf32>
        %9 = arith.addi %7, %c-1 : index
        %10 = memref.load %arg2[%9] : memref<?xf32>
        %11 = arith.addf %8, %10 : f32
        %12 = arith.mulf %11, %cst : f32
        %13 = memref.load %arg3[%7] : memref<?xf32>
        %14 = memref.load %arg3[%9] : memref<?xf32>
        %15 = arith.addf %13, %14 : f32
        %16 = arith.mulf %12, %15 : f32
        %17 = memref.load %arg5[%7] : memref<?xf32>
        %18 = arith.mulf %16, %17 : f32
        memref.store %18, %arg0[%7] : memref<?xf32>
        %19 = memref.load %arg2[%7] : memref<?xf32>
        %20 = arith.addi %arg7, %c-1 : index
        %21 = arith.muli %20, %5 overflow<nsw> : index
        %22 = arith.addi %arg8, %21 : index
        %23 = memref.load %arg2[%22] : memref<?xf32>
        %24 = arith.addf %19, %23 : f32
        %25 = arith.mulf %24, %cst : f32
        %26 = memref.load %arg4[%7] : memref<?xf32>
        %27 = memref.load %arg4[%22] : memref<?xf32>
        %28 = arith.addf %26, %27 : f32
        %29 = arith.mulf %25, %28 : f32
        %30 = memref.load %arg6[%7] : memref<?xf32>
        %31 = arith.mulf %29, %30 : f32
        memref.store %31, %arg1[%7] : memref<?xf32>
      }
    }
    return
  }
}


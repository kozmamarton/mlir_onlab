module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_flux_update_(%arg0: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c1 = arith.constant 1 : index
    %c-1 = arith.constant -1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.500000e-01 : f32
    %0 = memref.get_global @jm : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @im : memref<1xi32>
    %4 = memref.load %3[%c0] : memref<1xi32>
    %5 = arith.index_cast %4 : i32 to index
    %6 = arith.addi %2, %c-1 : index
    scf.for %arg7 = %c0 to %6 step %c1 {
      %7 = arith.addi %5, %c-1 : index
      scf.for %arg8 = %c0 to %7 step %c1 {
        %8 = arith.addi %arg7, %c1 : index
        %9 = arith.muli %8, %5 overflow<nsw> : index
        %10 = arith.addi %arg8, %9 : index
        %11 = arith.addi %10, %c1 : index
        %12 = memref.load %arg2[%11] : memref<?xf32>
        %13 = memref.load %arg2[%10] : memref<?xf32>
        %14 = arith.addf %12, %13 : f32
        %15 = arith.mulf %14, %cst : f32
        %16 = memref.load %arg3[%11] : memref<?xf32>
        %17 = memref.load %arg3[%10] : memref<?xf32>
        %18 = arith.addf %16, %17 : f32
        %19 = arith.mulf %15, %18 : f32
        %20 = memref.load %arg5[%11] : memref<?xf32>
        %21 = arith.mulf %19, %20 : f32
        memref.store %21, %arg0[%11] : memref<?xf32>
        %22 = memref.load %arg2[%11] : memref<?xf32>
        %23 = arith.muli %arg7, %5 overflow<nsw> : index
        %24 = arith.addi %arg8, %23 : index
        %25 = arith.addi %24, %c1 : index
        %26 = memref.load %arg2[%25] : memref<?xf32>
        %27 = arith.addf %22, %26 : f32
        %28 = arith.mulf %27, %cst : f32
        %29 = memref.load %arg4[%11] : memref<?xf32>
        %30 = memref.load %arg4[%25] : memref<?xf32>
        %31 = arith.addf %29, %30 : f32
        %32 = arith.mulf %28, %31 : f32
        %33 = memref.load %arg6[%11] : memref<?xf32>
        %34 = arith.mulf %32, %33 : f32
        memref.store %34, %arg1[%11] : memref<?xf32>
      }
    }
    return
  }
}


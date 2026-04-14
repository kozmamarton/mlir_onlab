module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte2 : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_elf_update_(%arg0: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c-1 = arith.constant -1 : index
    %c0 = arith.constant 0 : index
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @dte2 : memref<1xf32>
    %6 = memref.load %3[%c0] : memref<1xi32>
    %7 = memref.load %4[%c0] : memref<1xi32>
    %8 = memref.load %5[%c0] : memref<1xf32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    %11 = arith.addi %2, %c-1 : index
    scf.for %arg6 = %c0 to %11 step %c1 {
      %12 = arith.addi %9, %c-1 : index
      scf.for %arg7 = %c0 to %12 step %c1 {
        %13 = arith.addi %arg6, %c1 : index
        %14 = arith.muli %13, %10 overflow<nsw> : index
        %15 = arith.addi %arg7, %14 : index
        %16 = arith.addi %15, %c1 : index
        %17 = memref.load %arg1[%16] : memref<?xf32>
        %18 = arith.addi %15, %c2 : index
        %19 = memref.load %arg2[%18] : memref<?xf32>
        %20 = memref.load %arg2[%16] : memref<?xf32>
        %21 = arith.subf %19, %20 : f32
        %22 = arith.addi %arg6, %c2 : index
        %23 = arith.muli %22, %10 overflow<nsw> : index
        %24 = arith.addi %arg7, %23 : index
        %25 = arith.addi %24, %c1 : index
        %26 = memref.load %arg3[%25] : memref<?xf32>
        %27 = arith.addf %21, %26 : f32
        %28 = memref.load %arg3[%16] : memref<?xf32>
        %29 = arith.subf %27, %28 : f32
        %30 = arith.negf %29 : f32
        %31 = memref.load %arg4[%16] : memref<?xf32>
        %32 = arith.divf %30, %31 : f32
        %33 = memref.load %arg5[%16] : memref<?xf32>
        %34 = arith.subf %32, %33 : f32
        %35 = arith.mulf %8, %34 : f32
        %36 = arith.addf %17, %35 : f32
        memref.store %36, %arg0[%16] : memref<?xf32>
      }
    }
    return
  }
}


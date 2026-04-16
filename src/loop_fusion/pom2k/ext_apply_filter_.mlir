module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_apply_filter_(%arg0: memref<?xf32> {polygeist.name = "vamax", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "vmaxl", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}, %arg3: memref<?xi32> {polygeist.name = "iext", polygeist.type = "int *"}, %arg4: memref<?xi32> {polygeist.name = "isplit", polygeist.type = "int *"}, %arg5: memref<?xf32> {polygeist.name = "ispi", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "isp2i", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "ua", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "uab", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "uaf", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "va", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "vab", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "vaf", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "el", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "d", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "egf", polygeist.type = "float *"}, %arg19: memref<?xf32> {polygeist.name = "utf", polygeist.type = "float *"}, %arg20: memref<?xf32> {polygeist.name = "vtf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = memref.load %arg0[%c0] : memref<?xf32>
    %1 = memref.load %arg1[%c0] : memref<?xf32>
    %2 = arith.cmpf olt, %0, %1 : f32
    scf.if %2 {
      %3 = memref.get_global @jm : memref<1xi32>
      %4 = memref.load %3[%c0] : memref<1xi32>
      %5 = arith.index_cast %4 : i32 to index
      %6 = memref.get_global @im : memref<1xi32>
      %7 = memref.load %6[%c0] : memref<1xi32>
      %8 = memref.load %arg2[%c0] : memref<?xf32>
      %9 = arith.index_cast %7 : i32 to index
      %10 = arith.mulf %8, %cst_0 : f32
      scf.for %arg21 = %c0 to %5 step %c1 {
        %14 = arith.muli %arg21, %9 : index
        scf.for %arg22 = %c0 to %9 step %c1 {
          %15 = arith.addi %arg22, %14 : index
          %16 = memref.load %arg7[%15] : memref<?xf32>
          %17 = memref.load %arg8[%15] : memref<?xf32>
          %18 = arith.mulf %16, %cst : f32
          %19 = arith.subf %17, %18 : f32
          %20 = memref.load %arg9[%15] : memref<?xf32>
          %21 = arith.addf %19, %20 : f32
          %22 = arith.mulf %10, %21 : f32
          %23 = arith.addf %16, %22 : f32
          memref.store %23, %arg7[%15] : memref<?xf32>
          %24 = memref.load %arg10[%15] : memref<?xf32>
          %25 = memref.load %arg11[%15] : memref<?xf32>
          %26 = arith.mulf %24, %cst : f32
          %27 = arith.subf %25, %26 : f32
          %28 = memref.load %arg12[%15] : memref<?xf32>
          %29 = arith.addf %27, %28 : f32
          %30 = arith.mulf %10, %29 : f32
          %31 = arith.addf %24, %30 : f32
          memref.store %31, %arg10[%15] : memref<?xf32>
          %32 = memref.load %arg13[%15] : memref<?xf32>
          %33 = memref.load %arg14[%15] : memref<?xf32>
          %34 = arith.mulf %32, %cst : f32
          %35 = arith.subf %33, %34 : f32
          %36 = memref.load %arg15[%15] : memref<?xf32>
          %37 = arith.addf %35, %36 : f32
          %38 = arith.mulf %10, %37 : f32
          %39 = arith.addf %32, %38 : f32
          memref.store %39, %arg13[%15] : memref<?xf32>
          %40 = memref.load %arg13[%15] : memref<?xf32>
          memref.store %40, %arg14[%15] : memref<?xf32>
          %41 = memref.load %arg15[%15] : memref<?xf32>
          memref.store %41, %arg13[%15] : memref<?xf32>
          %42 = memref.load %arg17[%15] : memref<?xf32>
          %43 = memref.load %arg13[%15] : memref<?xf32>
          %44 = arith.addf %42, %43 : f32
          memref.store %44, %arg16[%15] : memref<?xf32>
          %45 = memref.load %arg7[%15] : memref<?xf32>
          memref.store %45, %arg8[%15] : memref<?xf32>
          %46 = memref.load %arg9[%15] : memref<?xf32>
          memref.store %46, %arg7[%15] : memref<?xf32>
          %47 = memref.load %arg10[%15] : memref<?xf32>
          memref.store %47, %arg11[%15] : memref<?xf32>
          %48 = memref.load %arg12[%15] : memref<?xf32>
          memref.store %48, %arg10[%15] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      %11 = memref.load %arg3[%c0] : memref<?xi32>
      %12 = memref.load %arg4[%c0] : memref<?xi32>
      %13 = arith.cmpi ne, %11, %12 : i32
      scf.if %13 {
        %14 = memref.load %3[%c0] : memref<1xi32>
        %15 = arith.index_cast %14 : i32 to index
        %16 = memref.load %6[%c0] : memref<1xi32>
        %17 = memref.load %arg5[%c0] : memref<?xf32>
        %18 = arith.index_cast %16 : i32 to index
        scf.for %arg21 = %c0 to %15 step %c1 {
          %29 = arith.muli %arg21, %18 : index
          scf.for %arg22 = %c0 to %18 step %c1 {
            %30 = arith.addi %arg22, %29 : index
            %31 = memref.load %arg18[%30] : memref<?xf32>
            %32 = memref.load %arg13[%30] : memref<?xf32>
            %33 = arith.mulf %32, %17 : f32
            %34 = arith.addf %31, %33 : f32
            memref.store %34, %arg18[%30] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        %19 = memref.load %3[%c0] : memref<1xi32>
        %20 = arith.index_cast %19 : i32 to index
        %21 = memref.load %6[%c0] : memref<1xi32>
        %22 = memref.load %arg6[%c0] : memref<?xf32>
        %23 = arith.index_cast %21 : i32 to index
        scf.for %arg21 = %c0 to %20 step %c1 {
          %29 = arith.muli %arg21, %23 : index
          scf.for %arg22 = %c1 to %23 step %c1 {
            %30 = arith.addi %arg22, %29 : index
            %31 = memref.load %arg19[%30] : memref<?xf32>
            %32 = memref.load %arg7[%30] : memref<?xf32>
            %33 = memref.load %arg16[%30] : memref<?xf32>
            %34 = arith.addi %arg22, %c-1 : index
            %35 = arith.addi %34, %29 : index
            %36 = memref.load %arg16[%35] : memref<?xf32>
            %37 = arith.addf %33, %36 : f32
            %38 = arith.mulf %32, %37 : f32
            %39 = arith.mulf %38, %22 : f32
            %40 = arith.addf %31, %39 : f32
            memref.store %40, %arg19[%30] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        %24 = memref.load %3[%c0] : memref<1xi32>
        %25 = arith.index_cast %24 : i32 to index
        %26 = memref.load %6[%c0] : memref<1xi32>
        %27 = memref.load %arg6[%c0] : memref<?xf32>
        %28 = arith.index_cast %26 : i32 to index
        scf.for %arg21 = %c1 to %25 step %c1 {
          %29 = arith.muli %arg21, %28 : index
          %30 = arith.addi %arg21, %c-1 : index
          %31 = arith.muli %30, %28 : index
          scf.for %arg22 = %c0 to %28 step %c1 {
            %32 = arith.addi %arg22, %29 : index
            %33 = memref.load %arg20[%32] : memref<?xf32>
            %34 = memref.load %arg10[%32] : memref<?xf32>
            %35 = memref.load %arg16[%32] : memref<?xf32>
            %36 = arith.addi %arg22, %31 : index
            %37 = memref.load %arg16[%36] : memref<?xf32>
            %38 = arith.addf %35, %37 : f32
            %39 = arith.mulf %34, %38 : f32
            %40 = arith.mulf %39, %27 : f32
            %41 = arith.addf %33, %40 : f32
            memref.store %41, %arg20[%32] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      }
    }
    return
  }
}


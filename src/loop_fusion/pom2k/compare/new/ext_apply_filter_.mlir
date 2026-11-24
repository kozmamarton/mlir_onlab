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
        %14 = memref.load %arg5[%c0] : memref<?xf32>
        scf.for %arg21 = %c0 to %5 step %c1 {
          %16 = arith.muli %arg21, %9 : index
          scf.for %arg22 = %c0 to %9 step %c1 {
            %17 = arith.addi %arg22, %16 : index
            %18 = memref.load %arg18[%17] : memref<?xf32>
            %19 = memref.load %arg13[%17] : memref<?xf32>
            %20 = arith.mulf %19, %14 : f32
            %21 = arith.addf %18, %20 : f32
            memref.store %21, %arg18[%17] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        %15 = memref.load %arg6[%c0] : memref<?xf32>
        scf.for %arg21 = %c0 to %5 step %c1 {
          %16 = arith.muli %arg21, %9 : index
          scf.for %arg22 = %c1 to %9 step %c1 {
            %17 = arith.addi %arg22, %16 : index
            %18 = memref.load %arg19[%17] : memref<?xf32>
            %19 = memref.load %arg7[%17] : memref<?xf32>
            %20 = memref.load %arg16[%17] : memref<?xf32>
            %21 = arith.addi %arg22, %c-1 : index
            %22 = arith.addi %21, %16 : index
            %23 = memref.load %arg16[%22] : memref<?xf32>
            %24 = arith.addf %20, %23 : f32
            %25 = arith.mulf %19, %24 : f32
            %26 = arith.mulf %25, %15 : f32
            %27 = arith.addf %18, %26 : f32
            memref.store %27, %arg19[%17] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        scf.for %arg21 = %c1 to %5 step %c1 {
          %16 = arith.muli %arg21, %9 : index
          %17 = arith.addi %arg21, %c-1 : index
          %18 = arith.muli %17, %9 : index
          scf.for %arg22 = %c0 to %9 step %c1 {
            %19 = arith.addi %arg22, %16 : index
            %20 = memref.load %arg20[%19] : memref<?xf32>
            %21 = memref.load %arg10[%19] : memref<?xf32>
            %22 = memref.load %arg16[%19] : memref<?xf32>
            %23 = arith.addi %arg22, %18 : index
            %24 = memref.load %arg16[%23] : memref<?xf32>
            %25 = arith.addf %22, %24 : f32
            %26 = arith.mulf %21, %25 : f32
            %27 = arith.mulf %26, %15 : f32
            %28 = arith.addf %20, %27 : f32
            memref.store %28, %arg20[%19] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      }
    }
    return
  }
}


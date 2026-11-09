module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  func.func @ext_etf_update_(%arg0: memref<?xi32> {polygeist.name = "iext", polygeist.type = "int *"}, %arg1: memref<?xi32> {polygeist.name = "isplit", polygeist.type = "int *"}, %arg2: memref<?xf32> {polygeist.name = "smoth", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-2_i32 = arith.constant -2 : i32
    %c-1_i32 = arith.constant -1 : i32
    %cst = arith.constant 1.000000e+00 : f32
    %cst_0 = arith.constant 5.000000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = memref.load %arg0[%c0] : memref<?xi32>
    %1 = memref.load %arg1[%c0] : memref<?xi32>
    %2 = arith.addi %1, %c-2_i32 : i32
    %3 = arith.cmpi eq, %0, %2 : i32
    scf.if %3 {
      %4 = memref.get_global @jm : memref<1xi32>
      %5 = memref.load %4[%c0] : memref<1xi32>
      %6 = arith.index_cast %5 : i32 to index
      %7 = memref.get_global @im : memref<1xi32>
      %8 = memref.load %7[%c0] : memref<1xi32>
      %9 = memref.load %arg2[%c0] : memref<?xf32>
      %10 = arith.index_cast %8 : i32 to index
      %11 = arith.mulf %9, %cst_1 : f32
      scf.for %arg6 = %c0 to %6 step %c1 {
        %12 = arith.muli %arg6, %10 : index
        scf.for %arg7 = %c0 to %10 step %c1 {
          %13 = arith.addi %arg7, %12 : index
          %14 = memref.load %arg4[%13] : memref<?xf32>
          %15 = arith.mulf %11, %14 : f32
          memref.store %15, %arg3[%13] : memref<?xf32>
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
    } else {
      %4 = arith.addi %1, %c-1_i32 : i32
      %5 = arith.cmpi eq, %0, %4 : i32
      scf.if %5 {
        %6 = memref.get_global @jm : memref<1xi32>
        %7 = memref.load %6[%c0] : memref<1xi32>
        %8 = arith.index_cast %7 : i32 to index
        %9 = memref.get_global @im : memref<1xi32>
        %10 = memref.load %9[%c0] : memref<1xi32>
        %11 = memref.load %arg2[%c0] : memref<?xf32>
        %12 = arith.index_cast %10 : i32 to index
        %13 = arith.mulf %11, %cst_0 : f32
        %14 = arith.subf %cst, %13 : f32
        %15 = arith.mulf %14, %cst_0 : f32
        scf.for %arg6 = %c0 to %8 step %c1 {
          %16 = arith.muli %arg6, %12 : index
          scf.for %arg7 = %c0 to %12 step %c1 {
            %17 = arith.addi %arg7, %16 : index
            %18 = memref.load %arg3[%17] : memref<?xf32>
            %19 = memref.load %arg4[%17] : memref<?xf32>
            %20 = arith.mulf %15, %19 : f32
            %21 = arith.addf %18, %20 : f32
            memref.store %21, %arg3[%17] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } else {
        %6 = arith.cmpi eq, %0, %1 : i32
        scf.if %6 {
          %7 = memref.get_global @jm : memref<1xi32>
          %8 = memref.load %7[%c0] : memref<1xi32>
          %9 = arith.index_cast %8 : i32 to index
          %10 = memref.get_global @im : memref<1xi32>
          %11 = memref.load %10[%c0] : memref<1xi32>
          %12 = arith.index_cast %11 : i32 to index
          scf.for %arg6 = %c0 to %9 step %c1 {
            %13 = arith.muli %arg6, %12 : index
            scf.for %arg7 = %c0 to %12 step %c1 {
              %14 = arith.addi %arg7, %13 : index
              %15 = memref.load %arg3[%14] : memref<?xf32>
              %16 = memref.load %arg4[%14] : memref<?xf32>
              %17 = arith.mulf %16, %cst_0 : f32
              %18 = arith.addf %15, %17 : f32
              %19 = memref.load %arg5[%14] : memref<?xf32>
              %20 = arith.mulf %18, %19 : f32
              memref.store %20, %arg3[%14] : memref<?xf32>
            } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        }
      }
    }
    return
  }
}


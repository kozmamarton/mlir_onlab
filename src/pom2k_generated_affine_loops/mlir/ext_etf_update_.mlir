module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
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
    %0 = affine.load %arg0[0] : memref<?xi32>
    %1 = affine.load %arg1[0] : memref<?xi32>
    %2 = arith.addi %1, %c-2_i32 : i32
    %3 = arith.cmpi eq, %0, %2 : i32
    scf.if %3 {
      %4 = memref.get_global @jm : memref<1xi32>
      %5 = affine.load %4[0] : memref<1xi32>
      %6 = arith.index_cast %5 : i32 to index
      %7 = memref.get_global @im : memref<1xi32>
      %8 = affine.load %7[0] : memref<1xi32>
      %9 = affine.load %arg2[0] : memref<?xf32>
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
      %4 = affine.load %arg0[0] : memref<?xi32>
      %5 = affine.load %arg1[0] : memref<?xi32>
      %6 = arith.addi %5, %c-1_i32 : i32
      %7 = arith.cmpi eq, %4, %6 : i32
      scf.if %7 {
        %8 = memref.get_global @jm : memref<1xi32>
        %9 = affine.load %8[0] : memref<1xi32>
        %10 = arith.index_cast %9 : i32 to index
        %11 = memref.get_global @im : memref<1xi32>
        %12 = affine.load %11[0] : memref<1xi32>
        %13 = affine.load %arg2[0] : memref<?xf32>
        %14 = arith.index_cast %12 : i32 to index
        %15 = arith.mulf %13, %cst_0 : f32
        %16 = arith.subf %cst, %15 : f32
        %17 = arith.mulf %16, %cst_0 : f32
        scf.for %arg6 = %c0 to %10 step %c1 {
          %18 = arith.muli %arg6, %14 : index
          scf.for %arg7 = %c0 to %14 step %c1 {
            %19 = arith.addi %arg7, %18 : index
            %20 = memref.load %arg3[%19] : memref<?xf32>
            %21 = memref.load %arg4[%19] : memref<?xf32>
            %22 = arith.mulf %17, %21 : f32
            %23 = arith.addf %20, %22 : f32
            memref.store %23, %arg3[%19] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
      } else {
        %8 = affine.load %arg0[0] : memref<?xi32>
        %9 = affine.load %arg1[0] : memref<?xi32>
        %10 = arith.cmpi eq, %8, %9 : i32
        scf.if %10 {
          %11 = memref.get_global @jm : memref<1xi32>
          %12 = affine.load %11[0] : memref<1xi32>
          %13 = arith.index_cast %12 : i32 to index
          %14 = memref.get_global @im : memref<1xi32>
          %15 = affine.load %14[0] : memref<1xi32>
          %16 = arith.index_cast %15 : i32 to index
          scf.for %arg6 = %c0 to %13 step %c1 {
            %17 = arith.muli %arg6, %16 : index
            scf.for %arg7 = %c0 to %16 step %c1 {
              %18 = arith.addi %arg7, %17 : index
              %19 = memref.load %arg3[%18] : memref<?xf32>
              %20 = memref.load %arg4[%18] : memref<?xf32>
              %21 = arith.mulf %20, %cst_0 : f32
              %22 = arith.addf %19, %21 : f32
              %23 = memref.load %arg5[%18] : memref<?xf32>
              %24 = arith.mulf %22, %23 : f32
              memref.store %24, %arg3[%18] : memref<?xf32>
            } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "im"}
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "0", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jm"}
        }
      }
    }
    return
  }
}

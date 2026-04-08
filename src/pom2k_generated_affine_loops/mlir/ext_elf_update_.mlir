module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "little">, #dlti.dl_entry<i64, dense<64> : vector<2xi32>>, #dlti.dl_entry<i128, dense<128> : vector<2xi32>>, #dlti.dl_entry<i1, dense<8> : vector<2xi32>>, #dlti.dl_entry<i8, dense<8> : vector<2xi32>>, #dlti.dl_entry<i16, dense<16> : vector<2xi32>>, #dlti.dl_entry<i32, dense<32> : vector<2xi32>>, #dlti.dl_entry<f16, dense<16> : vector<2xi32>>, #dlti.dl_entry<f64, dense<64> : vector<2xi32>>, #dlti.dl_entry<f128, dense<128> : vector<2xi32>>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @dte2 : memref<1xf32>
  memref.global @im : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  func.func @ext_elf_update_(%arg0: memref<?xf32> {polygeist.name = "elf", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "elb", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fluxua", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "fluxva", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "vfluxf", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %0 = memref.get_global @jmm1 : memref<1xi32>
    %1 = affine.load %0[0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @imm1 : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.get_global @dte2 : memref<1xf32>
    %6 = affine.load %3[0] : memref<1xi32>
    %7 = affine.load %4[0] : memref<1xi32>
    %8 = affine.load %5[0] : memref<1xf32>
    %9 = arith.index_cast %6 : i32 to index
    %10 = arith.index_cast %7 : i32 to index
    affine.for %arg6 = 1 to %2 {
      affine.for %arg7 = 1 to %9 {
        %11 = affine.load %arg1[%arg7 + %arg6 * symbol(%10)] : memref<?xf32>
        %12 = affine.load %arg2[%arg7 + %arg6 * symbol(%10) + 1] : memref<?xf32>
        %13 = affine.load %arg2[%arg7 + %arg6 * symbol(%10)] : memref<?xf32>
        %14 = arith.subf %12, %13 : f32
        %15 = affine.load %arg3[%arg7 + (%arg6 + 1) * symbol(%10)] : memref<?xf32>
        %16 = arith.addf %14, %15 : f32
        %17 = affine.load %arg3[%arg7 + %arg6 * symbol(%10)] : memref<?xf32>
        %18 = arith.subf %16, %17 : f32
        %19 = arith.negf %18 : f32
        %20 = affine.load %arg4[%arg7 + %arg6 * symbol(%10)] : memref<?xf32>
        %21 = arith.divf %19, %20 : f32
        %22 = affine.load %arg5[%arg7 + %arg6 * symbol(%10)] : memref<?xf32>
        %23 = arith.subf %21, %22 : f32
        %24 = arith.mulf %8, %23 : f32
        %25 = arith.addf %11, %24 : f32
        affine.store %25, %arg0[%arg7 + %arg6 * symbol(%10)] : memref<?xf32>
      } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
    } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
    return
  }
}

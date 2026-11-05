#map = affine_map<(d0)[s0] -> (-d0 + s0, 2)>
#map1 = affine_map<(d0)[s0] -> (-d0 + s0, 4)>
#map2 = affine_map<(d0)[s0] -> (-d0 + s0, 32)>
module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @dti2 : memref<1xf32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_smol_adif_(%arg0: memref<?xf32> {polygeist.name = "xmassflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ymassflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "zwflux", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "sw", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c32 = arith.constant 32 : index
    %c4 = arith.constant 4 : index
    %c2 = arith.constant 2 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %true = arith.constant true
    %c-1 = arith.constant -1 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 0.000000e+00 : f32
    %cst_1 = arith.constant 9.99999982E-15 : f32
    %cst_2 = arith.constant 9.99999971E-10 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    %9 = arith.muli %8, %7 : index
    %reinterpret_cast = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%2, %7, %8], strides: [%9, %8, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %reinterpret_cast_3 = memref.reinterpret_cast %arg5 to offset: [0], sizes: [%7, %8], strides: [%8, 1] : memref<?xf32> to memref<?x?xf32, strided<[?, 1]>>
    scf.parallel (%arg10, %arg11, %arg12) = (%c0, %c0, %c0) to (%2, %7, %8) step (%c2, %c4, %c32) {
      %40 = affine.min #map(%arg10)[%2]
      %41 = affine.min #map1(%arg11)[%7]
      %42 = affine.min #map2(%arg12)[%8]
      scf.parallel (%arg13, %arg14, %arg15) = (%c0, %c0, %c0) to (%40, %41, %42) step (%c1, %c1, %c1) {
        %43 = arith.addi %arg13, %arg10 : index
        %44 = arith.addi %arg14, %arg11 : index
        %45 = arith.addi %arg15, %arg12 : index
        %46 = memref.load %reinterpret_cast_3[%44, %45] : memref<?x?xf32, strided<[?, 1]>>
        %47 = memref.load %reinterpret_cast[%43, %44, %45] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %48 = arith.mulf %47, %46 : f32
        memref.store %48, %reinterpret_cast[%43, %44, %45] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %10 = memref.get_global @kbm1 : memref<1xi32>
    %11 = memref.load %10[%c0] : memref<1xi32>
    %12 = arith.index_cast %11 : i32 to index
    %13 = memref.get_global @jmm1 : memref<1xi32>
    %14 = memref.load %13[%c0] : memref<1xi32>
    %15 = memref.load %4[%c0] : memref<1xi32>
    %16 = memref.load %3[%c0] : memref<1xi32>
    %17 = arith.index_cast %14 : i32 to index
    %18 = arith.index_cast %15 : i32 to index
    %19 = arith.index_cast %16 : i32 to index
    %20 = arith.muli %18, %19 : index
    %reinterpret_cast_4 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%12, %19, %18], strides: [%20, %18, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %21 = memref.get_global @imm1 : memref<1xi32>
    %22 = memref.load %21[%c0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = arith.maxsi %19, %17 : index
    %25 = arith.maxsi %23, %18 : index
    %26 = memref.get_global @dti2 : memref<1xf32>
    %27 = memref.load %26[%c0] : memref<1xf32>
    scf.parallel (%arg10, %arg11, %arg12) = (%c0, %c1, %c1) to (%12, %24, %25) step (%c2, %c4, %c32) {
      %40 = affine.min #map(%arg10)[%12]
      %41 = affine.min #map1(%arg11)[%24]
      %42 = affine.min #map2(%arg12)[%25]
      scf.parallel (%arg13, %arg14, %arg15) = (%c0, %c0, %c0) to (%40, %41, %42) step (%c1, %c1, %c1) {
        %43 = arith.addi %arg13, %arg10 : index
        %44 = arith.addi %arg14, %arg11 : index
        %45 = arith.addi %arg15, %arg12 : index
        %46 = memref.load %arg4[%c0] : memref<?xf32>
        %47 = arith.subi %17, %44 : index
        %48 = arith.addi %47, %c-1 : index
        %49 = arith.cmpi sge, %48, %c0 : index
        %50 = arith.subi %18, %45 : index
        %51 = arith.addi %50, %c-1 : index
        %52 = arith.cmpi sge, %51, %c0 : index
        %53 = arith.andi %49, %52 : i1
        scf.if %53 {
          %61 = memref.load %reinterpret_cast_4[%43, %44, %45] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %62 = arith.cmpf olt, %61, %cst_2 : f32
          %63 = scf.if %62 -> (i1) {
            scf.yield %true : i1
          } else {
            %64 = arith.addi %45, %c-1 : index
            %65 = arith.muli %44, %18 : index
            %66 = arith.addi %64, %65 : index
            %67 = arith.muli %43, %18 : index
            %68 = arith.muli %67, %19 : index
            %69 = arith.addi %66, %68 : index
            %70 = memref.load %arg3[%69] : memref<?xf32>
            %71 = arith.cmpf olt, %70, %cst_2 : f32
            scf.yield %71 : i1
          }
          scf.if %63 {
            %64 = arith.muli %44, %18 : index
            %65 = arith.addi %45, %64 : index
            %66 = arith.muli %43, %18 : index
            %67 = arith.muli %66, %19 : index
            %68 = arith.addi %65, %67 : index
            memref.store %cst_0, %arg0[%68] : memref<?xf32>
          } else {
            %64 = arith.muli %44, %18 : index
            %65 = arith.addi %45, %64 : index
            %66 = arith.muli %43, %18 : index
            %67 = arith.muli %66, %19 : index
            %68 = arith.addi %65, %67 : index
            %69 = memref.load %arg0[%68] : memref<?xf32>
            %70 = arith.extf %69 : f32 to f64
            %71 = math.absf %70 : f64
            %72 = arith.truncf %71 : f64 to f32
            %73 = arith.mulf %27, %69 : f32
            %74 = arith.mulf %73, %69 : f32
            %75 = arith.mulf %74, %cst : f32
            %76 = memref.load %arg6[%65] : memref<?xf32>
            %77 = arith.addi %45, %c-1 : index
            %78 = arith.addi %77, %64 : index
            %79 = memref.load %arg8[%78] : memref<?xf32>
            %80 = memref.load %arg8[%65] : memref<?xf32>
            %81 = arith.addf %79, %80 : f32
            %82 = arith.mulf %76, %81 : f32
            %83 = arith.divf %75, %82 : f32
            %84 = memref.load %arg3[%68] : memref<?xf32>
            %85 = arith.addi %78, %67 : index
            %86 = memref.load %arg3[%85] : memref<?xf32>
            %87 = arith.subf %84, %86 : f32
            %88 = arith.addf %86, %84 : f32
            %89 = arith.addf %88, %cst_1 : f32
            %90 = arith.divf %87, %89 : f32
            %91 = arith.subf %72, %83 : f32
            %92 = arith.mulf %91, %90 : f32
            %93 = arith.mulf %92, %46 : f32
            memref.store %93, %arg0[%68] : memref<?xf32>
            %94 = arith.extf %72 : f32 to f64
            %95 = math.absf %94 : f64
            %96 = arith.extf %83 : f32 to f64
            %97 = math.absf %96 : f64
            %98 = arith.cmpf olt, %95, %97 : f64
            scf.if %98 {
              memref.store %cst_0, %arg0[%68] : memref<?xf32>
            }
          }
        }
        %54 = arith.subi %19, %44 : index
        %55 = arith.addi %54, %c-1 : index
        %56 = arith.cmpi sge, %55, %c0 : index
        %57 = arith.subi %23, %45 : index
        %58 = arith.addi %57, %c-1 : index
        %59 = arith.cmpi sge, %58, %c0 : index
        %60 = arith.andi %56, %59 : i1
        scf.if %60 {
          %61 = memref.load %reinterpret_cast_4[%43, %44, %45] : memref<?x?x?xf32, strided<[?, ?, 1]>>
          %62 = arith.cmpf olt, %61, %cst_2 : f32
          %63 = scf.if %62 -> (i1) {
            scf.yield %true : i1
          } else {
            %64 = arith.addi %44, %c-1 : index
            %65 = arith.muli %64, %18 : index
            %66 = arith.addi %45, %65 : index
            %67 = arith.muli %43, %18 : index
            %68 = arith.muli %67, %19 : index
            %69 = arith.addi %66, %68 : index
            %70 = memref.load %arg3[%69] : memref<?xf32>
            %71 = arith.cmpf olt, %70, %cst_2 : f32
            scf.yield %71 : i1
          }
          scf.if %63 {
            %64 = arith.muli %44, %18 : index
            %65 = arith.addi %45, %64 : index
            %66 = arith.muli %43, %18 : index
            %67 = arith.muli %66, %19 : index
            %68 = arith.addi %65, %67 : index
            memref.store %cst_0, %arg1[%68] : memref<?xf32>
          } else {
            %64 = arith.muli %44, %18 : index
            %65 = arith.addi %45, %64 : index
            %66 = arith.muli %43, %18 : index
            %67 = arith.muli %66, %19 : index
            %68 = arith.addi %65, %67 : index
            %69 = memref.load %arg1[%68] : memref<?xf32>
            %70 = arith.extf %69 : f32 to f64
            %71 = math.absf %70 : f64
            %72 = arith.truncf %71 : f64 to f32
            %73 = arith.mulf %27, %69 : f32
            %74 = arith.mulf %73, %69 : f32
            %75 = arith.mulf %74, %cst : f32
            %76 = memref.load %arg7[%65] : memref<?xf32>
            %77 = arith.addi %44, %c-1 : index
            %78 = arith.muli %77, %18 : index
            %79 = arith.addi %45, %78 : index
            %80 = memref.load %arg8[%79] : memref<?xf32>
            %81 = memref.load %arg8[%65] : memref<?xf32>
            %82 = arith.addf %80, %81 : f32
            %83 = arith.mulf %76, %82 : f32
            %84 = arith.divf %75, %83 : f32
            %85 = memref.load %arg3[%68] : memref<?xf32>
            %86 = arith.addi %79, %67 : index
            %87 = memref.load %arg3[%86] : memref<?xf32>
            %88 = arith.subf %85, %87 : f32
            %89 = arith.addf %87, %85 : f32
            %90 = arith.addf %89, %cst_1 : f32
            %91 = arith.divf %88, %90 : f32
            %92 = arith.subf %72, %84 : f32
            %93 = arith.mulf %92, %91 : f32
            %94 = arith.mulf %93, %46 : f32
            memref.store %94, %arg1[%68] : memref<?xf32>
            %95 = arith.extf %72 : f32 to f64
            %96 = math.absf %95 : f64
            %97 = arith.extf %84 : f32 to f64
            %98 = math.absf %97 : f64
            %99 = arith.cmpf olt, %96, %98 : f64
            scf.if %99 {
              memref.store %cst_0, %arg1[%68] : memref<?xf32>
            }
          }
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    %28 = memref.load %10[%c0] : memref<1xi32>
    %29 = arith.index_cast %28 : i32 to index
    %30 = memref.load %13[%c0] : memref<1xi32>
    %31 = memref.load %21[%c0] : memref<1xi32>
    %32 = memref.load %4[%c0] : memref<1xi32>
    %33 = memref.load %3[%c0] : memref<1xi32>
    %34 = arith.index_cast %30 : i32 to index
    %35 = arith.index_cast %31 : i32 to index
    %36 = arith.index_cast %32 : i32 to index
    %37 = arith.index_cast %33 : i32 to index
    %38 = arith.muli %36, %37 : index
    %reinterpret_cast_5 = memref.reinterpret_cast %arg3 to offset: [0], sizes: [%29, %37, %36], strides: [%38, %36, 1] : memref<?xf32> to memref<?x?x?xf32, strided<[?, ?, 1]>>
    %39 = memref.load %26[%c0] : memref<1xf32>
    scf.parallel (%arg10, %arg11, %arg12) = (%c1, %c1, %c1) to (%29, %34, %35) step (%c2, %c4, %c32) {
      %40 = affine.min #map(%arg10)[%29]
      %41 = affine.min #map1(%arg11)[%34]
      %42 = affine.min #map2(%arg12)[%35]
      scf.parallel (%arg13, %arg14, %arg15) = (%c0, %c0, %c0) to (%40, %41, %42) step (%c1, %c1, %c1) {
        %43 = arith.addi %arg13, %arg10 : index
        %44 = arith.addi %arg14, %arg11 : index
        %45 = arith.addi %arg15, %arg12 : index
        %46 = memref.load %arg4[%c0] : memref<?xf32>
        %47 = memref.load %reinterpret_cast_5[%43, %44, %45] : memref<?x?x?xf32, strided<[?, ?, 1]>>
        %48 = arith.cmpf olt, %47, %cst_2 : f32
        %49 = scf.if %48 -> (i1) {
          scf.yield %true : i1
        } else {
          %50 = arith.muli %44, %36 : index
          %51 = arith.addi %45, %50 : index
          %52 = arith.addi %43, %c-1 : index
          %53 = arith.muli %52, %36 : index
          %54 = arith.muli %53, %37 : index
          %55 = arith.addi %51, %54 : index
          %56 = memref.load %arg3[%55] : memref<?xf32>
          %57 = arith.cmpf olt, %56, %cst_2 : f32
          scf.yield %57 : i1
        }
        scf.if %49 {
          %50 = arith.muli %44, %36 : index
          %51 = arith.addi %45, %50 : index
          %52 = arith.muli %43, %36 : index
          %53 = arith.muli %52, %37 : index
          %54 = arith.addi %51, %53 : index
          memref.store %cst_0, %arg2[%54] : memref<?xf32>
        } else {
          %50 = arith.muli %44, %36 : index
          %51 = arith.addi %45, %50 : index
          %52 = arith.muli %43, %36 : index
          %53 = arith.muli %52, %37 : index
          %54 = arith.addi %51, %53 : index
          %55 = memref.load %arg2[%54] : memref<?xf32>
          %56 = arith.extf %55 : f32 to f64
          %57 = math.absf %56 : f64
          %58 = arith.truncf %57 : f64 to f32
          %59 = arith.mulf %39, %55 : f32
          %60 = arith.mulf %59, %55 : f32
          %61 = arith.addi %43, %c-1 : index
          %62 = memref.load %arg9[%61] : memref<?xf32>
          %63 = memref.load %arg8[%51] : memref<?xf32>
          %64 = arith.mulf %62, %63 : f32
          %65 = arith.divf %60, %64 : f32
          %66 = arith.muli %61, %36 : index
          %67 = arith.muli %66, %37 : index
          %68 = arith.addi %51, %67 : index
          %69 = memref.load %arg3[%68] : memref<?xf32>
          %70 = memref.load %arg3[%54] : memref<?xf32>
          %71 = arith.subf %69, %70 : f32
          %72 = arith.addf %70, %69 : f32
          %73 = arith.addf %72, %cst_1 : f32
          %74 = arith.divf %71, %73 : f32
          %75 = arith.subf %58, %65 : f32
          %76 = arith.mulf %75, %74 : f32
          %77 = arith.mulf %76, %46 : f32
          memref.store %77, %arg2[%54] : memref<?xf32>
          %78 = arith.extf %58 : f32 to f64
          %79 = math.absf %78 : f64
          %80 = arith.extf %65 : f32 to f64
          %81 = math.absf %80 : f64
          %82 = arith.cmpf olt, %79, %81 : f64
          scf.if %82 {
            memref.store %cst_0, %arg2[%54] : memref<?xf32>
          }
        }
        scf.reduce 
      } {mapping = [#gpu.loop_dim_map<processor = thread_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = thread_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
      scf.reduce 
    } {mapping = [#gpu.loop_dim_map<processor = block_z, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_y, map = (d0) -> (d0), bound = (d0) -> (d0)>, #gpu.loop_dim_map<processor = block_x, map = (d0) -> (d0), bound = (d0) -> (d0)>]}
    return
  }
}


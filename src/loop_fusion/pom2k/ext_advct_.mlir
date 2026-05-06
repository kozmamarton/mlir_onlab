module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advct_(%arg0: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "curv", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "advx", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "advy", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c-1 = arith.constant -1 : index
    %c1 = arith.constant 1 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 2.000000e+00 : f32
    %cst_0 = arith.constant 1.250000e-01 : f32
    %cst_1 = arith.constant 2.500000e-01 : f32
    %cst_2 = arith.constant 0.000000e+00 : f32
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    scf.for %arg15 = %c0 to %2 step %c1 {
      scf.for %arg16 = %c0 to %7 step %c1 {
        scf.for %arg17 = %c0 to %8 step %c1 {
          %112 = arith.muli %arg16, %8 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = arith.muli %arg15, %8 overflow<nsw> : index
          %115 = arith.muli %114, %7 overflow<nsw> : index
          %116 = arith.addi %113, %115 : index
          memref.store %cst_2, %arg2[%116] : memref<?xf32>
          memref.store %cst_2, %arg3[%116] : memref<?xf32>
          memref.store %cst_2, %arg0[%116] : memref<?xf32>
          memref.store %cst_2, %arg1[%116] : memref<?xf32>
        }
      }
    }
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @jmm1 : memref<1xi32>
    %13 = memref.get_global @imm1 : memref<1xi32>
    %14 = memref.load %12[%c0] : memref<1xi32>
    %15 = memref.load %13[%c0] : memref<1xi32>
    %16 = memref.load %4[%c0] : memref<1xi32>
    %17 = memref.load %3[%c0] : memref<1xi32>
    %18 = arith.index_cast %14 : i32 to index
    %19 = arith.index_cast %15 : i32 to index
    %20 = arith.index_cast %16 : i32 to index
    %21 = arith.index_cast %17 : i32 to index
    scf.for %arg15 = %c0 to %11 step %c1 {
      scf.for %arg16 = %c1 to %18 step %c1 {
        scf.for %arg17 = %c1 to %19 step %c1 {
          %112 = arith.addi %arg16, %c1 : index
          %113 = arith.muli %112, %20 overflow<nsw> : index
          %114 = arith.addi %arg17, %113 : index
          %115 = arith.muli %arg15, %20 overflow<nsw> : index
          %116 = arith.muli %115, %21 overflow<nsw> : index
          %117 = arith.addi %114, %116 : index
          %118 = memref.load %arg6[%117] : memref<?xf32>
          %119 = arith.muli %arg16, %20 overflow<nsw> : index
          %120 = arith.addi %arg17, %119 : index
          %121 = arith.addi %120, %116 : index
          %122 = memref.load %arg6[%121] : memref<?xf32>
          %123 = arith.addf %118, %122 : f32
          %124 = arith.addi %120, %c1 : index
          %125 = memref.load %arg8[%124] : memref<?xf32>
          %126 = arith.addi %120, %c-1 : index
          %127 = memref.load %arg8[%126] : memref<?xf32>
          %128 = arith.subf %125, %127 : f32
          %129 = arith.mulf %123, %128 : f32
          %130 = arith.addi %121, %c1 : index
          %131 = memref.load %arg5[%130] : memref<?xf32>
          %132 = memref.load %arg5[%121] : memref<?xf32>
          %133 = arith.addf %131, %132 : f32
          %134 = memref.load %arg7[%114] : memref<?xf32>
          %135 = arith.addi %arg16, %c-1 : index
          %136 = arith.muli %135, %20 overflow<nsw> : index
          %137 = arith.addi %arg17, %136 : index
          %138 = memref.load %arg7[%137] : memref<?xf32>
          %139 = arith.subf %134, %138 : f32
          %140 = arith.mulf %133, %139 : f32
          %141 = arith.subf %129, %140 : f32
          %142 = arith.mulf %141, %cst_1 : f32
          %143 = memref.load %arg7[%120] : memref<?xf32>
          %144 = memref.load %arg8[%120] : memref<?xf32>
          %145 = arith.mulf %143, %144 : f32
          %146 = arith.divf %142, %145 : f32
          memref.store %146, %arg2[%121] : memref<?xf32>
        }
      }
    }
    %22 = memref.load %9[%c0] : memref<1xi32>
    %23 = arith.index_cast %22 : i32 to index
    %24 = memref.load %3[%c0] : memref<1xi32>
    %25 = memref.load %13[%c0] : memref<1xi32>
    %26 = memref.load %4[%c0] : memref<1xi32>
    %27 = arith.index_cast %24 : i32 to index
    %28 = arith.index_cast %25 : i32 to index
    %29 = arith.index_cast %26 : i32 to index
    scf.for %arg15 = %c0 to %23 step %c1 {
      scf.for %arg16 = %c0 to %27 step %c1 {
        scf.for %arg17 = %c1 to %28 step %c1 {
          %112 = arith.muli %arg16, %29 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = arith.addi %113, %c1 : index
          %115 = memref.load %arg9[%114] : memref<?xf32>
          %116 = memref.load %arg9[%113] : memref<?xf32>
          %117 = arith.addf %115, %116 : f32
          %118 = arith.muli %arg15, %29 overflow<nsw> : index
          %119 = arith.muli %118, %27 overflow<nsw> : index
          %120 = arith.addi %113, %119 : index
          %121 = arith.addi %120, %c1 : index
          %122 = memref.load %arg5[%121] : memref<?xf32>
          %123 = arith.mulf %117, %122 : f32
          %124 = arith.addi %113, %c-1 : index
          %125 = memref.load %arg9[%124] : memref<?xf32>
          %126 = arith.addf %116, %125 : f32
          %127 = memref.load %arg5[%120] : memref<?xf32>
          %128 = arith.mulf %126, %127 : f32
          %129 = arith.addf %123, %128 : f32
          %130 = arith.mulf %129, %cst_0 : f32
          %131 = arith.addf %122, %127 : f32
          %132 = arith.mulf %130, %131 : f32
          memref.store %132, %arg0[%120] : memref<?xf32>
        }
      }
    }
    %30 = memref.load %9[%c0] : memref<1xi32>
    %31 = arith.index_cast %30 : i32 to index
    %32 = memref.load %3[%c0] : memref<1xi32>
    %33 = memref.load %4[%c0] : memref<1xi32>
    %34 = arith.index_cast %32 : i32 to index
    %35 = arith.index_cast %33 : i32 to index
    scf.for %arg15 = %c0 to %31 step %c1 {
      scf.for %arg16 = %c1 to %34 step %c1 {
        scf.for %arg17 = %c1 to %35 step %c1 {
          %112 = arith.muli %arg16, %35 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = memref.load %arg9[%113] : memref<?xf32>
          %115 = arith.addi %arg16, %c-1 : index
          %116 = arith.muli %115, %35 overflow<nsw> : index
          %117 = arith.addi %arg17, %116 : index
          %118 = memref.load %arg9[%117] : memref<?xf32>
          %119 = arith.addf %114, %118 : f32
          %120 = arith.muli %arg15, %35 overflow<nsw> : index
          %121 = arith.muli %120, %34 overflow<nsw> : index
          %122 = arith.addi %113, %121 : index
          %123 = memref.load %arg6[%122] : memref<?xf32>
          %124 = arith.mulf %119, %123 : f32
          %125 = arith.addi %113, %c-1 : index
          %126 = memref.load %arg9[%125] : memref<?xf32>
          %127 = arith.addi %117, %c-1 : index
          %128 = memref.load %arg9[%127] : memref<?xf32>
          %129 = arith.addf %126, %128 : f32
          %130 = arith.addi %122, %c-1 : index
          %131 = memref.load %arg6[%130] : memref<?xf32>
          %132 = arith.mulf %129, %131 : f32
          %133 = arith.addf %124, %132 : f32
          %134 = arith.mulf %133, %cst_0 : f32
          %135 = memref.load %arg5[%122] : memref<?xf32>
          %136 = arith.addi %117, %121 : index
          %137 = memref.load %arg5[%136] : memref<?xf32>
          %138 = arith.addf %135, %137 : f32
          %139 = arith.mulf %134, %138 : f32
          memref.store %139, %arg1[%122] : memref<?xf32>
        }
      }
    }
    %36 = memref.load %9[%c0] : memref<1xi32>
    %37 = arith.index_cast %36 : i32 to index
    %38 = memref.load %3[%c0] : memref<1xi32>
    %39 = memref.load %13[%c0] : memref<1xi32>
    %40 = memref.load %4[%c0] : memref<1xi32>
    %41 = arith.index_cast %38 : i32 to index
    %42 = arith.index_cast %39 : i32 to index
    %43 = arith.index_cast %40 : i32 to index
    scf.for %arg15 = %c0 to %37 step %c1 {
      scf.for %arg16 = %c1 to %41 step %c1 {
        scf.for %arg17 = %c1 to %42 step %c1 {
          %112 = arith.muli %arg16, %43 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = memref.load %arg9[%113] : memref<?xf32>
          %115 = arith.muli %arg15, %43 overflow<nsw> : index
          %116 = arith.muli %115, %41 overflow<nsw> : index
          %117 = arith.addi %113, %116 : index
          %118 = memref.load %arg10[%117] : memref<?xf32>
          %119 = arith.mulf %114, %118 : f32
          %120 = arith.mulf %119, %cst : f32
          %121 = arith.addi %117, %c1 : index
          %122 = memref.load %arg11[%121] : memref<?xf32>
          %123 = memref.load %arg11[%117] : memref<?xf32>
          %124 = arith.subf %122, %123 : f32
          %125 = arith.mulf %120, %124 : f32
          %126 = memref.load %arg7[%113] : memref<?xf32>
          %127 = arith.divf %125, %126 : f32
          %128 = memref.load %arg0[%117] : memref<?xf32>
          %129 = arith.subf %128, %127 : f32
          memref.store %129, %arg0[%117] : memref<?xf32>
          %130 = memref.load %arg9[%113] : memref<?xf32>
          %131 = arith.addi %113, %c-1 : index
          %132 = memref.load %arg9[%131] : memref<?xf32>
          %133 = arith.addf %130, %132 : f32
          %134 = arith.addi %arg16, %c-1 : index
          %135 = arith.muli %134, %43 overflow<nsw> : index
          %136 = arith.addi %arg17, %135 : index
          %137 = memref.load %arg9[%136] : memref<?xf32>
          %138 = arith.addf %133, %137 : f32
          %139 = arith.addi %136, %c-1 : index
          %140 = memref.load %arg9[%139] : memref<?xf32>
          %141 = arith.addf %138, %140 : f32
          %142 = arith.mulf %141, %cst_1 : f32
          %143 = memref.load %arg10[%117] : memref<?xf32>
          %144 = arith.addi %117, %c-1 : index
          %145 = memref.load %arg10[%144] : memref<?xf32>
          %146 = arith.addf %143, %145 : f32
          %147 = arith.addi %136, %116 : index
          %148 = memref.load %arg10[%147] : memref<?xf32>
          %149 = arith.addf %146, %148 : f32
          %150 = arith.addi %147, %c-1 : index
          %151 = memref.load %arg10[%150] : memref<?xf32>
          %152 = arith.addf %149, %151 : f32
          %153 = arith.mulf %142, %152 : f32
          %154 = memref.load %arg11[%117] : memref<?xf32>
          %155 = memref.load %arg11[%147] : memref<?xf32>
          %156 = arith.subf %154, %155 : f32
          %157 = memref.load %arg8[%113] : memref<?xf32>
          %158 = memref.load %arg8[%131] : memref<?xf32>
          %159 = arith.addf %157, %158 : f32
          %160 = memref.load %arg8[%136] : memref<?xf32>
          %161 = arith.addf %159, %160 : f32
          %162 = memref.load %arg8[%139] : memref<?xf32>
          %163 = arith.addf %161, %162 : f32
          %164 = arith.divf %156, %163 : f32
          %165 = memref.load %arg12[%117] : memref<?xf32>
          %166 = memref.load %arg12[%144] : memref<?xf32>
          %167 = arith.subf %165, %166 : f32
          %168 = memref.load %arg7[%113] : memref<?xf32>
          %169 = memref.load %arg7[%131] : memref<?xf32>
          %170 = arith.addf %168, %169 : f32
          %171 = memref.load %arg7[%136] : memref<?xf32>
          %172 = arith.addf %170, %171 : f32
          %173 = memref.load %arg7[%139] : memref<?xf32>
          %174 = arith.addf %172, %173 : f32
          %175 = arith.divf %167, %174 : f32
          %176 = arith.addf %164, %175 : f32
          %177 = arith.mulf %153, %176 : f32
          %178 = memref.load %arg1[%117] : memref<?xf32>
          %179 = arith.subf %178, %177 : f32
          memref.store %179, %arg1[%117] : memref<?xf32>
          %180 = memref.load %arg8[%113] : memref<?xf32>
          %181 = memref.load %arg0[%117] : memref<?xf32>
          %182 = arith.mulf %180, %181 : f32
          memref.store %182, %arg0[%117] : memref<?xf32>
          %183 = memref.load %arg7[%113] : memref<?xf32>
          %184 = memref.load %arg7[%131] : memref<?xf32>
          %185 = arith.addf %183, %184 : f32
          %186 = memref.load %arg7[%136] : memref<?xf32>
          %187 = arith.addf %185, %186 : f32
          %188 = memref.load %arg7[%139] : memref<?xf32>
          %189 = arith.addf %187, %188 : f32
          %190 = arith.mulf %189, %cst_1 : f32
          %191 = memref.load %arg1[%117] : memref<?xf32>
          %192 = arith.mulf %190, %191 : f32
          memref.store %192, %arg1[%117] : memref<?xf32>
        }
      }
    }
    %44 = memref.load %9[%c0] : memref<1xi32>
    %45 = arith.index_cast %44 : i32 to index
    %46 = memref.load %12[%c0] : memref<1xi32>
    %47 = memref.load %13[%c0] : memref<1xi32>
    %48 = memref.load %4[%c0] : memref<1xi32>
    %49 = memref.load %3[%c0] : memref<1xi32>
    %50 = arith.index_cast %46 : i32 to index
    %51 = arith.index_cast %47 : i32 to index
    %52 = arith.index_cast %48 : i32 to index
    %53 = arith.index_cast %49 : i32 to index
    scf.for %arg15 = %c0 to %45 step %c1 {
      scf.for %arg16 = %c1 to %50 step %c1 {
        scf.for %arg17 = %c1 to %51 step %c1 {
          %112 = arith.muli %arg16, %52 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = arith.muli %arg15, %52 overflow<nsw> : index
          %115 = arith.muli %114, %53 overflow<nsw> : index
          %116 = arith.addi %113, %115 : index
          %117 = memref.load %arg0[%116] : memref<?xf32>
          %118 = arith.addi %116, %c-1 : index
          %119 = memref.load %arg0[%118] : memref<?xf32>
          %120 = arith.subf %117, %119 : f32
          %121 = arith.addi %arg16, %c1 : index
          %122 = arith.muli %121, %52 overflow<nsw> : index
          %123 = arith.addi %arg17, %122 : index
          %124 = arith.addi %123, %115 : index
          %125 = memref.load %arg1[%124] : memref<?xf32>
          %126 = arith.addf %120, %125 : f32
          %127 = memref.load %arg1[%116] : memref<?xf32>
          %128 = arith.subf %126, %127 : f32
          memref.store %128, %arg3[%116] : memref<?xf32>
        }
      }
    }
    %54 = memref.load %9[%c0] : memref<1xi32>
    %55 = arith.index_cast %54 : i32 to index
    %56 = memref.load %12[%c0] : memref<1xi32>
    %57 = memref.load %13[%c0] : memref<1xi32>
    %58 = memref.load %4[%c0] : memref<1xi32>
    %59 = memref.load %3[%c0] : memref<1xi32>
    %60 = arith.index_cast %56 : i32 to index
    %61 = arith.index_cast %57 : i32 to index
    %62 = arith.index_cast %58 : i32 to index
    %63 = arith.index_cast %59 : i32 to index
    scf.for %arg15 = %c0 to %55 step %c1 {
      scf.for %arg16 = %c1 to %60 step %c1 {
        scf.for %arg17 = %c2 to %61 step %c1 {
          %112 = arith.muli %arg16, %62 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = memref.load %arg13[%113] : memref<?xf32>
          %115 = arith.mulf %114, %cst_1 : f32
          %116 = arith.muli %arg15, %62 overflow<nsw> : index
          %117 = arith.muli %116, %63 overflow<nsw> : index
          %118 = arith.addi %113, %117 : index
          %119 = memref.load %arg2[%118] : memref<?xf32>
          %120 = memref.load %arg9[%113] : memref<?xf32>
          %121 = arith.mulf %119, %120 : f32
          %122 = arith.addi %arg16, %c1 : index
          %123 = arith.muli %122, %62 overflow<nsw> : index
          %124 = arith.addi %arg17, %123 : index
          %125 = arith.addi %124, %117 : index
          %126 = memref.load %arg6[%125] : memref<?xf32>
          %127 = memref.load %arg6[%118] : memref<?xf32>
          %128 = arith.addf %126, %127 : f32
          %129 = arith.mulf %121, %128 : f32
          %130 = arith.addi %118, %c-1 : index
          %131 = memref.load %arg2[%130] : memref<?xf32>
          %132 = arith.addi %113, %c-1 : index
          %133 = memref.load %arg9[%132] : memref<?xf32>
          %134 = arith.mulf %131, %133 : f32
          %135 = arith.addi %125, %c-1 : index
          %136 = memref.load %arg6[%135] : memref<?xf32>
          %137 = memref.load %arg6[%130] : memref<?xf32>
          %138 = arith.addf %136, %137 : f32
          %139 = arith.mulf %134, %138 : f32
          %140 = arith.addf %129, %139 : f32
          %141 = arith.mulf %115, %140 : f32
          %142 = memref.load %arg3[%118] : memref<?xf32>
          %143 = arith.subf %142, %141 : f32
          memref.store %143, %arg3[%118] : memref<?xf32>
        }
      }
    }
    %64 = memref.load %0[%c0] : memref<1xi32>
    %65 = arith.index_cast %64 : i32 to index
    %66 = memref.load %3[%c0] : memref<1xi32>
    %67 = memref.load %4[%c0] : memref<1xi32>
    %68 = arith.index_cast %66 : i32 to index
    %69 = arith.index_cast %67 : i32 to index
    scf.for %arg15 = %c0 to %65 step %c1 {
      scf.for %arg16 = %c0 to %68 step %c1 {
        scf.for %arg17 = %c0 to %69 step %c1 {
          %112 = arith.muli %arg16, %69 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = arith.muli %arg15, %69 overflow<nsw> : index
          %115 = arith.muli %114, %68 overflow<nsw> : index
          %116 = arith.addi %113, %115 : index
          memref.store %cst_2, %arg4[%116] : memref<?xf32>
          memref.store %cst_2, %arg0[%116] : memref<?xf32>
          memref.store %cst_2, %arg1[%116] : memref<?xf32>
        }
      }
    }
    %70 = memref.load %9[%c0] : memref<1xi32>
    %71 = arith.index_cast %70 : i32 to index
    %72 = memref.load %3[%c0] : memref<1xi32>
    %73 = memref.load %4[%c0] : memref<1xi32>
    %74 = arith.index_cast %72 : i32 to index
    %75 = arith.index_cast %73 : i32 to index
    scf.for %arg15 = %c0 to %71 step %c1 {
      scf.for %arg16 = %c1 to %74 step %c1 {
        scf.for %arg17 = %c1 to %75 step %c1 {
          %112 = arith.muli %arg16, %75 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = memref.load %arg9[%113] : memref<?xf32>
          %115 = arith.addi %113, %c-1 : index
          %116 = memref.load %arg9[%115] : memref<?xf32>
          %117 = arith.addf %114, %116 : f32
          %118 = arith.muli %arg15, %75 overflow<nsw> : index
          %119 = arith.muli %118, %74 overflow<nsw> : index
          %120 = arith.addi %113, %119 : index
          %121 = memref.load %arg5[%120] : memref<?xf32>
          %122 = arith.mulf %117, %121 : f32
          %123 = arith.addi %arg16, %c-1 : index
          %124 = arith.muli %123, %75 overflow<nsw> : index
          %125 = arith.addi %arg17, %124 : index
          %126 = memref.load %arg9[%125] : memref<?xf32>
          %127 = arith.addi %125, %c-1 : index
          %128 = memref.load %arg9[%127] : memref<?xf32>
          %129 = arith.addf %126, %128 : f32
          %130 = arith.addi %125, %119 : index
          %131 = memref.load %arg5[%130] : memref<?xf32>
          %132 = arith.mulf %129, %131 : f32
          %133 = arith.addf %122, %132 : f32
          %134 = arith.mulf %133, %cst_0 : f32
          %135 = memref.load %arg6[%120] : memref<?xf32>
          %136 = arith.addi %120, %c-1 : index
          %137 = memref.load %arg6[%136] : memref<?xf32>
          %138 = arith.addf %135, %137 : f32
          %139 = arith.mulf %134, %138 : f32
          memref.store %139, %arg0[%120] : memref<?xf32>
        }
      }
    }
    %76 = memref.load %9[%c0] : memref<1xi32>
    %77 = arith.index_cast %76 : i32 to index
    %78 = memref.load %12[%c0] : memref<1xi32>
    %79 = memref.load %4[%c0] : memref<1xi32>
    %80 = memref.load %3[%c0] : memref<1xi32>
    %81 = arith.index_cast %78 : i32 to index
    %82 = arith.index_cast %79 : i32 to index
    %83 = arith.index_cast %80 : i32 to index
    scf.for %arg15 = %c0 to %77 step %c1 {
      scf.for %arg16 = %c1 to %81 step %c1 {
        scf.for %arg17 = %c0 to %82 step %c1 {
          %112 = arith.addi %arg16, %c1 : index
          %113 = arith.muli %112, %82 overflow<nsw> : index
          %114 = arith.addi %arg17, %113 : index
          %115 = memref.load %arg9[%114] : memref<?xf32>
          %116 = arith.muli %arg16, %82 overflow<nsw> : index
          %117 = arith.addi %arg17, %116 : index
          %118 = memref.load %arg9[%117] : memref<?xf32>
          %119 = arith.addf %115, %118 : f32
          %120 = arith.muli %arg15, %82 overflow<nsw> : index
          %121 = arith.muli %120, %83 overflow<nsw> : index
          %122 = arith.addi %114, %121 : index
          %123 = memref.load %arg6[%122] : memref<?xf32>
          %124 = arith.mulf %119, %123 : f32
          %125 = arith.addi %arg16, %c-1 : index
          %126 = arith.muli %125, %82 overflow<nsw> : index
          %127 = arith.addi %arg17, %126 : index
          %128 = memref.load %arg9[%127] : memref<?xf32>
          %129 = arith.addf %118, %128 : f32
          %130 = arith.addi %117, %121 : index
          %131 = memref.load %arg6[%130] : memref<?xf32>
          %132 = arith.mulf %129, %131 : f32
          %133 = arith.addf %124, %132 : f32
          %134 = arith.mulf %133, %cst_0 : f32
          %135 = arith.addf %123, %131 : f32
          %136 = arith.mulf %134, %135 : f32
          memref.store %136, %arg1[%130] : memref<?xf32>
        }
      }
    }
    %84 = memref.load %9[%c0] : memref<1xi32>
    %85 = arith.index_cast %84 : i32 to index
    %86 = memref.load %12[%c0] : memref<1xi32>
    %87 = memref.load %4[%c0] : memref<1xi32>
    %88 = memref.load %3[%c0] : memref<1xi32>
    %89 = arith.index_cast %86 : i32 to index
    %90 = arith.index_cast %87 : i32 to index
    %91 = arith.index_cast %88 : i32 to index
    scf.for %arg15 = %c0 to %85 step %c1 {
      scf.for %arg16 = %c1 to %89 step %c1 {
        scf.for %arg17 = %c1 to %90 step %c1 {
          %112 = arith.muli %arg16, %90 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = memref.load %arg9[%113] : memref<?xf32>
          %115 = arith.addi %113, %c-1 : index
          %116 = memref.load %arg9[%115] : memref<?xf32>
          %117 = arith.addf %114, %116 : f32
          %118 = arith.addi %arg16, %c-1 : index
          %119 = arith.muli %118, %90 overflow<nsw> : index
          %120 = arith.addi %arg17, %119 : index
          %121 = memref.load %arg9[%120] : memref<?xf32>
          %122 = arith.addf %117, %121 : f32
          %123 = arith.addi %120, %c-1 : index
          %124 = memref.load %arg9[%123] : memref<?xf32>
          %125 = arith.addf %122, %124 : f32
          %126 = arith.mulf %125, %cst_1 : f32
          %127 = arith.muli %arg15, %90 overflow<nsw> : index
          %128 = arith.muli %127, %91 overflow<nsw> : index
          %129 = arith.addi %113, %128 : index
          %130 = memref.load %arg10[%129] : memref<?xf32>
          %131 = arith.addi %129, %c-1 : index
          %132 = memref.load %arg10[%131] : memref<?xf32>
          %133 = arith.addf %130, %132 : f32
          %134 = arith.addi %120, %128 : index
          %135 = memref.load %arg10[%134] : memref<?xf32>
          %136 = arith.addf %133, %135 : f32
          %137 = arith.addi %134, %c-1 : index
          %138 = memref.load %arg10[%137] : memref<?xf32>
          %139 = arith.addf %136, %138 : f32
          %140 = arith.mulf %126, %139 : f32
          %141 = memref.load %arg11[%129] : memref<?xf32>
          %142 = memref.load %arg11[%134] : memref<?xf32>
          %143 = arith.subf %141, %142 : f32
          %144 = memref.load %arg8[%113] : memref<?xf32>
          %145 = memref.load %arg8[%115] : memref<?xf32>
          %146 = arith.addf %144, %145 : f32
          %147 = memref.load %arg8[%120] : memref<?xf32>
          %148 = arith.addf %146, %147 : f32
          %149 = memref.load %arg8[%123] : memref<?xf32>
          %150 = arith.addf %148, %149 : f32
          %151 = arith.divf %143, %150 : f32
          %152 = memref.load %arg12[%129] : memref<?xf32>
          %153 = memref.load %arg12[%131] : memref<?xf32>
          %154 = arith.subf %152, %153 : f32
          %155 = memref.load %arg7[%113] : memref<?xf32>
          %156 = memref.load %arg7[%115] : memref<?xf32>
          %157 = arith.addf %155, %156 : f32
          %158 = memref.load %arg7[%120] : memref<?xf32>
          %159 = arith.addf %157, %158 : f32
          %160 = memref.load %arg7[%123] : memref<?xf32>
          %161 = arith.addf %159, %160 : f32
          %162 = arith.divf %154, %161 : f32
          %163 = arith.addf %151, %162 : f32
          %164 = arith.mulf %140, %163 : f32
          %165 = memref.load %arg0[%129] : memref<?xf32>
          %166 = arith.subf %165, %164 : f32
          memref.store %166, %arg0[%129] : memref<?xf32>
          %167 = memref.load %arg9[%113] : memref<?xf32>
          %168 = memref.load %arg10[%129] : memref<?xf32>
          %169 = arith.mulf %167, %168 : f32
          %170 = arith.mulf %169, %cst : f32
          %171 = arith.addi %arg16, %c1 : index
          %172 = arith.muli %171, %90 overflow<nsw> : index
          %173 = arith.addi %arg17, %172 : index
          %174 = arith.addi %173, %128 : index
          %175 = memref.load %arg12[%174] : memref<?xf32>
          %176 = memref.load %arg12[%129] : memref<?xf32>
          %177 = arith.subf %175, %176 : f32
          %178 = arith.mulf %170, %177 : f32
          %179 = memref.load %arg8[%113] : memref<?xf32>
          %180 = arith.divf %178, %179 : f32
          %181 = memref.load %arg1[%129] : memref<?xf32>
          %182 = arith.subf %181, %180 : f32
          memref.store %182, %arg1[%129] : memref<?xf32>
          %183 = memref.load %arg8[%113] : memref<?xf32>
          %184 = memref.load %arg8[%115] : memref<?xf32>
          %185 = arith.addf %183, %184 : f32
          %186 = memref.load %arg8[%120] : memref<?xf32>
          %187 = arith.addf %185, %186 : f32
          %188 = memref.load %arg8[%123] : memref<?xf32>
          %189 = arith.addf %187, %188 : f32
          %190 = arith.mulf %189, %cst_1 : f32
          %191 = memref.load %arg0[%129] : memref<?xf32>
          %192 = arith.mulf %190, %191 : f32
          memref.store %192, %arg0[%129] : memref<?xf32>
          %193 = memref.load %arg7[%113] : memref<?xf32>
          %194 = memref.load %arg1[%129] : memref<?xf32>
          %195 = arith.mulf %193, %194 : f32
          memref.store %195, %arg1[%129] : memref<?xf32>
        }
      }
    }
    %92 = memref.load %9[%c0] : memref<1xi32>
    %93 = arith.index_cast %92 : i32 to index
    %94 = memref.load %12[%c0] : memref<1xi32>
    %95 = memref.load %13[%c0] : memref<1xi32>
    %96 = memref.load %4[%c0] : memref<1xi32>
    %97 = memref.load %3[%c0] : memref<1xi32>
    %98 = arith.index_cast %94 : i32 to index
    %99 = arith.index_cast %95 : i32 to index
    %100 = arith.index_cast %96 : i32 to index
    %101 = arith.index_cast %97 : i32 to index
    scf.for %arg15 = %c0 to %93 step %c1 {
      scf.for %arg16 = %c1 to %98 step %c1 {
        scf.for %arg17 = %c1 to %99 step %c1 {
          %112 = arith.muli %arg16, %100 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = arith.muli %arg15, %100 overflow<nsw> : index
          %115 = arith.muli %114, %101 overflow<nsw> : index
          %116 = arith.addi %113, %115 : index
          %117 = arith.addi %116, %c1 : index
          %118 = memref.load %arg0[%117] : memref<?xf32>
          %119 = memref.load %arg0[%116] : memref<?xf32>
          %120 = arith.subf %118, %119 : f32
          %121 = memref.load %arg1[%116] : memref<?xf32>
          %122 = arith.addf %120, %121 : f32
          %123 = arith.addi %arg16, %c-1 : index
          %124 = arith.muli %123, %100 overflow<nsw> : index
          %125 = arith.addi %arg17, %124 : index
          %126 = arith.addi %125, %115 : index
          %127 = memref.load %arg1[%126] : memref<?xf32>
          %128 = arith.subf %122, %127 : f32
          memref.store %128, %arg4[%116] : memref<?xf32>
        }
      }
    }
    %102 = memref.load %9[%c0] : memref<1xi32>
    %103 = arith.index_cast %102 : i32 to index
    %104 = memref.load %12[%c0] : memref<1xi32>
    %105 = memref.load %13[%c0] : memref<1xi32>
    %106 = memref.load %4[%c0] : memref<1xi32>
    %107 = memref.load %3[%c0] : memref<1xi32>
    %108 = arith.index_cast %104 : i32 to index
    %109 = arith.index_cast %105 : i32 to index
    %110 = arith.index_cast %106 : i32 to index
    %111 = arith.index_cast %107 : i32 to index
    scf.for %arg15 = %c0 to %103 step %c1 {
      scf.for %arg16 = %c2 to %108 step %c1 {
        scf.for %arg17 = %c1 to %109 step %c1 {
          %112 = arith.muli %arg16, %110 overflow<nsw> : index
          %113 = arith.addi %arg17, %112 : index
          %114 = memref.load %arg14[%113] : memref<?xf32>
          %115 = arith.mulf %114, %cst_1 : f32
          %116 = arith.muli %arg15, %110 overflow<nsw> : index
          %117 = arith.muli %116, %111 overflow<nsw> : index
          %118 = arith.addi %113, %117 : index
          %119 = memref.load %arg2[%118] : memref<?xf32>
          %120 = memref.load %arg9[%113] : memref<?xf32>
          %121 = arith.mulf %119, %120 : f32
          %122 = arith.addi %118, %c1 : index
          %123 = memref.load %arg5[%122] : memref<?xf32>
          %124 = memref.load %arg5[%118] : memref<?xf32>
          %125 = arith.addf %123, %124 : f32
          %126 = arith.mulf %121, %125 : f32
          %127 = arith.addi %arg16, %c-1 : index
          %128 = arith.muli %127, %110 overflow<nsw> : index
          %129 = arith.addi %arg17, %128 : index
          %130 = arith.addi %129, %117 : index
          %131 = memref.load %arg2[%130] : memref<?xf32>
          %132 = memref.load %arg9[%129] : memref<?xf32>
          %133 = arith.mulf %131, %132 : f32
          %134 = arith.addi %130, %c1 : index
          %135 = memref.load %arg5[%134] : memref<?xf32>
          %136 = memref.load %arg5[%130] : memref<?xf32>
          %137 = arith.addf %135, %136 : f32
          %138 = arith.mulf %133, %137 : f32
          %139 = arith.addf %126, %138 : f32
          %140 = arith.mulf %115, %139 : f32
          %141 = memref.load %arg4[%118] : memref<?xf32>
          %142 = arith.addf %141, %140 : f32
          memref.store %142, %arg4[%118] : memref<?xf32>
        }
      }
    }
    return
  }
}


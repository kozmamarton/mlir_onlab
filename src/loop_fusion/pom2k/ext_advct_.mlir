module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advct_(%arg0: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "curv", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "advx", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "advy", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "ub", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "vb", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c-2 = arith.constant -2 : index
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
      %112 = arith.addi %18, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %19, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c2 : index
          %115 = arith.muli %114, %20 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.muli %arg15, %20 overflow<nsw> : index
          %118 = arith.muli %117, %21 overflow<nsw> : index
          %119 = arith.addi %116, %118 : index
          %120 = arith.addi %119, %c1 : index
          %121 = memref.load %arg6[%120] : memref<?xf32>
          %122 = arith.addi %arg16, %c1 : index
          %123 = arith.muli %122, %20 overflow<nsw> : index
          %124 = arith.addi %arg17, %123 : index
          %125 = arith.addi %124, %118 : index
          %126 = arith.addi %125, %c1 : index
          %127 = memref.load %arg6[%126] : memref<?xf32>
          %128 = arith.addf %121, %127 : f32
          %129 = arith.addi %124, %c2 : index
          %130 = memref.load %arg8[%129] : memref<?xf32>
          %131 = memref.load %arg8[%124] : memref<?xf32>
          %132 = arith.subf %130, %131 : f32
          %133 = arith.mulf %128, %132 : f32
          %134 = arith.addi %125, %c2 : index
          %135 = memref.load %arg5[%134] : memref<?xf32>
          %136 = memref.load %arg5[%126] : memref<?xf32>
          %137 = arith.addf %135, %136 : f32
          %138 = arith.addi %116, %c1 : index
          %139 = memref.load %arg7[%138] : memref<?xf32>
          %140 = arith.muli %arg16, %20 overflow<nsw> : index
          %141 = arith.addi %arg17, %140 : index
          %142 = arith.addi %141, %c1 : index
          %143 = memref.load %arg7[%142] : memref<?xf32>
          %144 = arith.subf %139, %143 : f32
          %145 = arith.mulf %137, %144 : f32
          %146 = arith.subf %133, %145 : f32
          %147 = arith.mulf %146, %cst_1 : f32
          %148 = arith.addi %124, %c1 : index
          %149 = memref.load %arg7[%148] : memref<?xf32>
          %150 = memref.load %arg8[%148] : memref<?xf32>
          %151 = arith.mulf %149, %150 : f32
          %152 = arith.divf %147, %151 : f32
          memref.store %152, %arg2[%126] : memref<?xf32>
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
        %112 = arith.addi %28, %c-1 : index
        scf.for %arg17 = %c0 to %112 step %c1 {
          %113 = arith.muli %arg16, %29 overflow<nsw> : index
          %114 = arith.addi %arg17, %113 : index
          %115 = arith.addi %114, %c2 : index
          %116 = memref.load %arg9[%115] : memref<?xf32>
          %117 = arith.addi %114, %c1 : index
          %118 = memref.load %arg9[%117] : memref<?xf32>
          %119 = arith.addf %116, %118 : f32
          %120 = arith.muli %arg15, %29 overflow<nsw> : index
          %121 = arith.muli %120, %27 overflow<nsw> : index
          %122 = arith.addi %114, %121 : index
          %123 = arith.addi %122, %c2 : index
          %124 = memref.load %arg5[%123] : memref<?xf32>
          %125 = arith.mulf %119, %124 : f32
          %126 = memref.load %arg9[%114] : memref<?xf32>
          %127 = arith.addf %118, %126 : f32
          %128 = arith.addi %122, %c1 : index
          %129 = memref.load %arg5[%128] : memref<?xf32>
          %130 = arith.mulf %127, %129 : f32
          %131 = arith.addf %125, %130 : f32
          %132 = arith.mulf %131, %cst_0 : f32
          %133 = arith.addf %124, %129 : f32
          %134 = arith.mulf %132, %133 : f32
          memref.store %134, %arg0[%128] : memref<?xf32>
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
      %112 = arith.addi %34, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %35, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c1 : index
          %115 = arith.muli %114, %35 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.addi %116, %c1 : index
          %118 = memref.load %arg9[%117] : memref<?xf32>
          %119 = arith.muli %arg16, %35 overflow<nsw> : index
          %120 = arith.addi %arg17, %119 : index
          %121 = arith.addi %120, %c1 : index
          %122 = memref.load %arg9[%121] : memref<?xf32>
          %123 = arith.addf %118, %122 : f32
          %124 = arith.muli %arg15, %35 overflow<nsw> : index
          %125 = arith.muli %124, %34 overflow<nsw> : index
          %126 = arith.addi %116, %125 : index
          %127 = arith.addi %126, %c1 : index
          %128 = memref.load %arg6[%127] : memref<?xf32>
          %129 = arith.mulf %123, %128 : f32
          %130 = memref.load %arg9[%116] : memref<?xf32>
          %131 = memref.load %arg9[%120] : memref<?xf32>
          %132 = arith.addf %130, %131 : f32
          %133 = memref.load %arg6[%126] : memref<?xf32>
          %134 = arith.mulf %132, %133 : f32
          %135 = arith.addf %129, %134 : f32
          %136 = arith.mulf %135, %cst_0 : f32
          %137 = memref.load %arg5[%127] : memref<?xf32>
          %138 = arith.addi %120, %125 : index
          %139 = arith.addi %138, %c1 : index
          %140 = memref.load %arg5[%139] : memref<?xf32>
          %141 = arith.addf %137, %140 : f32
          %142 = arith.mulf %136, %141 : f32
          memref.store %142, %arg1[%127] : memref<?xf32>
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
      %112 = arith.addi %41, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %42, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c1 : index
          %115 = arith.muli %114, %43 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.addi %116, %c1 : index
          %118 = memref.load %arg9[%117] : memref<?xf32>
          %119 = arith.muli %arg15, %43 overflow<nsw> : index
          %120 = arith.muli %119, %41 overflow<nsw> : index
          %121 = arith.addi %116, %120 : index
          %122 = arith.addi %121, %c1 : index
          %123 = memref.load %arg10[%122] : memref<?xf32>
          %124 = arith.mulf %118, %123 : f32
          %125 = arith.mulf %124, %cst : f32
          %126 = arith.addi %121, %c2 : index
          %127 = memref.load %arg11[%126] : memref<?xf32>
          %128 = memref.load %arg11[%122] : memref<?xf32>
          %129 = arith.subf %127, %128 : f32
          %130 = arith.mulf %125, %129 : f32
          %131 = memref.load %arg7[%117] : memref<?xf32>
          %132 = arith.divf %130, %131 : f32
          %133 = memref.load %arg0[%122] : memref<?xf32>
          %134 = arith.subf %133, %132 : f32
          memref.store %134, %arg0[%122] : memref<?xf32>
          %135 = memref.load %arg9[%117] : memref<?xf32>
          %136 = memref.load %arg9[%116] : memref<?xf32>
          %137 = arith.addf %135, %136 : f32
          %138 = arith.muli %arg16, %43 overflow<nsw> : index
          %139 = arith.addi %arg17, %138 : index
          %140 = arith.addi %139, %c1 : index
          %141 = memref.load %arg9[%140] : memref<?xf32>
          %142 = arith.addf %137, %141 : f32
          %143 = memref.load %arg9[%139] : memref<?xf32>
          %144 = arith.addf %142, %143 : f32
          %145 = arith.mulf %144, %cst_1 : f32
          %146 = memref.load %arg10[%122] : memref<?xf32>
          %147 = memref.load %arg10[%121] : memref<?xf32>
          %148 = arith.addf %146, %147 : f32
          %149 = arith.addi %139, %120 : index
          %150 = arith.addi %149, %c1 : index
          %151 = memref.load %arg10[%150] : memref<?xf32>
          %152 = arith.addf %148, %151 : f32
          %153 = memref.load %arg10[%149] : memref<?xf32>
          %154 = arith.addf %152, %153 : f32
          %155 = arith.mulf %145, %154 : f32
          %156 = memref.load %arg11[%122] : memref<?xf32>
          %157 = memref.load %arg11[%150] : memref<?xf32>
          %158 = arith.subf %156, %157 : f32
          %159 = memref.load %arg8[%117] : memref<?xf32>
          %160 = memref.load %arg8[%116] : memref<?xf32>
          %161 = arith.addf %159, %160 : f32
          %162 = memref.load %arg8[%140] : memref<?xf32>
          %163 = arith.addf %161, %162 : f32
          %164 = memref.load %arg8[%139] : memref<?xf32>
          %165 = arith.addf %163, %164 : f32
          %166 = arith.divf %158, %165 : f32
          %167 = memref.load %arg12[%122] : memref<?xf32>
          %168 = memref.load %arg12[%121] : memref<?xf32>
          %169 = arith.subf %167, %168 : f32
          %170 = memref.load %arg7[%117] : memref<?xf32>
          %171 = memref.load %arg7[%116] : memref<?xf32>
          %172 = arith.addf %170, %171 : f32
          %173 = memref.load %arg7[%140] : memref<?xf32>
          %174 = arith.addf %172, %173 : f32
          %175 = memref.load %arg7[%139] : memref<?xf32>
          %176 = arith.addf %174, %175 : f32
          %177 = arith.divf %169, %176 : f32
          %178 = arith.addf %166, %177 : f32
          %179 = arith.mulf %155, %178 : f32
          %180 = memref.load %arg1[%122] : memref<?xf32>
          %181 = arith.subf %180, %179 : f32
          memref.store %181, %arg1[%122] : memref<?xf32>
          %182 = memref.load %arg8[%117] : memref<?xf32>
          %183 = memref.load %arg0[%122] : memref<?xf32>
          %184 = arith.mulf %182, %183 : f32
          memref.store %184, %arg0[%122] : memref<?xf32>
          %185 = memref.load %arg7[%117] : memref<?xf32>
          %186 = memref.load %arg7[%116] : memref<?xf32>
          %187 = arith.addf %185, %186 : f32
          %188 = memref.load %arg7[%140] : memref<?xf32>
          %189 = arith.addf %187, %188 : f32
          %190 = memref.load %arg7[%139] : memref<?xf32>
          %191 = arith.addf %189, %190 : f32
          %192 = arith.mulf %191, %cst_1 : f32
          %193 = memref.load %arg1[%122] : memref<?xf32>
          %194 = arith.mulf %192, %193 : f32
          memref.store %194, %arg1[%122] : memref<?xf32>
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
      %112 = arith.addi %50, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %51, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c1 : index
          %115 = arith.muli %114, %52 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.muli %arg15, %52 overflow<nsw> : index
          %118 = arith.muli %117, %53 overflow<nsw> : index
          %119 = arith.addi %116, %118 : index
          %120 = arith.addi %119, %c1 : index
          %121 = memref.load %arg0[%120] : memref<?xf32>
          %122 = memref.load %arg0[%119] : memref<?xf32>
          %123 = arith.subf %121, %122 : f32
          %124 = arith.addi %arg16, %c2 : index
          %125 = arith.muli %124, %52 overflow<nsw> : index
          %126 = arith.addi %arg17, %125 : index
          %127 = arith.addi %126, %118 : index
          %128 = arith.addi %127, %c1 : index
          %129 = memref.load %arg1[%128] : memref<?xf32>
          %130 = arith.addf %123, %129 : f32
          %131 = memref.load %arg1[%120] : memref<?xf32>
          %132 = arith.subf %130, %131 : f32
          memref.store %132, %arg3[%120] : memref<?xf32>
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
      %112 = arith.addi %60, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %61, %c-2 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c1 : index
          %115 = arith.muli %114, %62 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.addi %116, %c2 : index
          %118 = memref.load %arg13[%117] : memref<?xf32>
          %119 = arith.mulf %118, %cst_1 : f32
          %120 = arith.muli %arg15, %62 overflow<nsw> : index
          %121 = arith.muli %120, %63 overflow<nsw> : index
          %122 = arith.addi %116, %121 : index
          %123 = arith.addi %122, %c2 : index
          %124 = memref.load %arg2[%123] : memref<?xf32>
          %125 = memref.load %arg9[%117] : memref<?xf32>
          %126 = arith.mulf %124, %125 : f32
          %127 = arith.addi %arg16, %c2 : index
          %128 = arith.muli %127, %62 overflow<nsw> : index
          %129 = arith.addi %arg17, %128 : index
          %130 = arith.addi %129, %121 : index
          %131 = arith.addi %130, %c2 : index
          %132 = memref.load %arg6[%131] : memref<?xf32>
          %133 = memref.load %arg6[%123] : memref<?xf32>
          %134 = arith.addf %132, %133 : f32
          %135 = arith.mulf %126, %134 : f32
          %136 = arith.addi %122, %c1 : index
          %137 = memref.load %arg2[%136] : memref<?xf32>
          %138 = arith.addi %116, %c1 : index
          %139 = memref.load %arg9[%138] : memref<?xf32>
          %140 = arith.mulf %137, %139 : f32
          %141 = arith.addi %130, %c1 : index
          %142 = memref.load %arg6[%141] : memref<?xf32>
          %143 = memref.load %arg6[%136] : memref<?xf32>
          %144 = arith.addf %142, %143 : f32
          %145 = arith.mulf %140, %144 : f32
          %146 = arith.addf %135, %145 : f32
          %147 = arith.mulf %119, %146 : f32
          %148 = memref.load %arg3[%123] : memref<?xf32>
          %149 = arith.subf %148, %147 : f32
          memref.store %149, %arg3[%123] : memref<?xf32>
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
      %112 = arith.addi %74, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %75, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c1 : index
          %115 = arith.muli %114, %75 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.addi %116, %c1 : index
          %118 = memref.load %arg9[%117] : memref<?xf32>
          %119 = memref.load %arg9[%116] : memref<?xf32>
          %120 = arith.addf %118, %119 : f32
          %121 = arith.muli %arg15, %75 overflow<nsw> : index
          %122 = arith.muli %121, %74 overflow<nsw> : index
          %123 = arith.addi %116, %122 : index
          %124 = arith.addi %123, %c1 : index
          %125 = memref.load %arg5[%124] : memref<?xf32>
          %126 = arith.mulf %120, %125 : f32
          %127 = arith.muli %arg16, %75 overflow<nsw> : index
          %128 = arith.addi %arg17, %127 : index
          %129 = arith.addi %128, %c1 : index
          %130 = memref.load %arg9[%129] : memref<?xf32>
          %131 = memref.load %arg9[%128] : memref<?xf32>
          %132 = arith.addf %130, %131 : f32
          %133 = arith.addi %128, %122 : index
          %134 = arith.addi %133, %c1 : index
          %135 = memref.load %arg5[%134] : memref<?xf32>
          %136 = arith.mulf %132, %135 : f32
          %137 = arith.addf %126, %136 : f32
          %138 = arith.mulf %137, %cst_0 : f32
          %139 = memref.load %arg6[%124] : memref<?xf32>
          %140 = memref.load %arg6[%123] : memref<?xf32>
          %141 = arith.addf %139, %140 : f32
          %142 = arith.mulf %138, %141 : f32
          memref.store %142, %arg0[%124] : memref<?xf32>
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
      %112 = arith.addi %81, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        scf.for %arg17 = %c0 to %82 step %c1 {
          %113 = arith.addi %arg16, %c2 : index
          %114 = arith.muli %113, %82 overflow<nsw> : index
          %115 = arith.addi %arg17, %114 : index
          %116 = memref.load %arg9[%115] : memref<?xf32>
          %117 = arith.addi %arg16, %c1 : index
          %118 = arith.muli %117, %82 overflow<nsw> : index
          %119 = arith.addi %arg17, %118 : index
          %120 = memref.load %arg9[%119] : memref<?xf32>
          %121 = arith.addf %116, %120 : f32
          %122 = arith.muli %arg15, %82 overflow<nsw> : index
          %123 = arith.muli %122, %83 overflow<nsw> : index
          %124 = arith.addi %115, %123 : index
          %125 = memref.load %arg6[%124] : memref<?xf32>
          %126 = arith.mulf %121, %125 : f32
          %127 = arith.muli %arg16, %82 overflow<nsw> : index
          %128 = arith.addi %arg17, %127 : index
          %129 = memref.load %arg9[%128] : memref<?xf32>
          %130 = arith.addf %120, %129 : f32
          %131 = arith.addi %119, %123 : index
          %132 = memref.load %arg6[%131] : memref<?xf32>
          %133 = arith.mulf %130, %132 : f32
          %134 = arith.addf %126, %133 : f32
          %135 = arith.mulf %134, %cst_0 : f32
          %136 = arith.addf %125, %132 : f32
          %137 = arith.mulf %135, %136 : f32
          memref.store %137, %arg1[%131] : memref<?xf32>
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
      %112 = arith.addi %89, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %90, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c1 : index
          %115 = arith.muli %114, %90 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.addi %116, %c1 : index
          %118 = memref.load %arg9[%117] : memref<?xf32>
          %119 = memref.load %arg9[%116] : memref<?xf32>
          %120 = arith.addf %118, %119 : f32
          %121 = arith.muli %arg16, %90 overflow<nsw> : index
          %122 = arith.addi %arg17, %121 : index
          %123 = arith.addi %122, %c1 : index
          %124 = memref.load %arg9[%123] : memref<?xf32>
          %125 = arith.addf %120, %124 : f32
          %126 = memref.load %arg9[%122] : memref<?xf32>
          %127 = arith.addf %125, %126 : f32
          %128 = arith.mulf %127, %cst_1 : f32
          %129 = arith.muli %arg15, %90 overflow<nsw> : index
          %130 = arith.muli %129, %91 overflow<nsw> : index
          %131 = arith.addi %116, %130 : index
          %132 = arith.addi %131, %c1 : index
          %133 = memref.load %arg10[%132] : memref<?xf32>
          %134 = memref.load %arg10[%131] : memref<?xf32>
          %135 = arith.addf %133, %134 : f32
          %136 = arith.addi %122, %130 : index
          %137 = arith.addi %136, %c1 : index
          %138 = memref.load %arg10[%137] : memref<?xf32>
          %139 = arith.addf %135, %138 : f32
          %140 = memref.load %arg10[%136] : memref<?xf32>
          %141 = arith.addf %139, %140 : f32
          %142 = arith.mulf %128, %141 : f32
          %143 = memref.load %arg11[%132] : memref<?xf32>
          %144 = memref.load %arg11[%137] : memref<?xf32>
          %145 = arith.subf %143, %144 : f32
          %146 = memref.load %arg8[%117] : memref<?xf32>
          %147 = memref.load %arg8[%116] : memref<?xf32>
          %148 = arith.addf %146, %147 : f32
          %149 = memref.load %arg8[%123] : memref<?xf32>
          %150 = arith.addf %148, %149 : f32
          %151 = memref.load %arg8[%122] : memref<?xf32>
          %152 = arith.addf %150, %151 : f32
          %153 = arith.divf %145, %152 : f32
          %154 = memref.load %arg12[%132] : memref<?xf32>
          %155 = memref.load %arg12[%131] : memref<?xf32>
          %156 = arith.subf %154, %155 : f32
          %157 = memref.load %arg7[%117] : memref<?xf32>
          %158 = memref.load %arg7[%116] : memref<?xf32>
          %159 = arith.addf %157, %158 : f32
          %160 = memref.load %arg7[%123] : memref<?xf32>
          %161 = arith.addf %159, %160 : f32
          %162 = memref.load %arg7[%122] : memref<?xf32>
          %163 = arith.addf %161, %162 : f32
          %164 = arith.divf %156, %163 : f32
          %165 = arith.addf %153, %164 : f32
          %166 = arith.mulf %142, %165 : f32
          %167 = memref.load %arg0[%132] : memref<?xf32>
          %168 = arith.subf %167, %166 : f32
          memref.store %168, %arg0[%132] : memref<?xf32>
          %169 = memref.load %arg9[%117] : memref<?xf32>
          %170 = memref.load %arg10[%132] : memref<?xf32>
          %171 = arith.mulf %169, %170 : f32
          %172 = arith.mulf %171, %cst : f32
          %173 = arith.addi %arg16, %c2 : index
          %174 = arith.muli %173, %90 overflow<nsw> : index
          %175 = arith.addi %arg17, %174 : index
          %176 = arith.addi %175, %130 : index
          %177 = arith.addi %176, %c1 : index
          %178 = memref.load %arg12[%177] : memref<?xf32>
          %179 = memref.load %arg12[%132] : memref<?xf32>
          %180 = arith.subf %178, %179 : f32
          %181 = arith.mulf %172, %180 : f32
          %182 = memref.load %arg8[%117] : memref<?xf32>
          %183 = arith.divf %181, %182 : f32
          %184 = memref.load %arg1[%132] : memref<?xf32>
          %185 = arith.subf %184, %183 : f32
          memref.store %185, %arg1[%132] : memref<?xf32>
          %186 = memref.load %arg8[%117] : memref<?xf32>
          %187 = memref.load %arg8[%116] : memref<?xf32>
          %188 = arith.addf %186, %187 : f32
          %189 = memref.load %arg8[%123] : memref<?xf32>
          %190 = arith.addf %188, %189 : f32
          %191 = memref.load %arg8[%122] : memref<?xf32>
          %192 = arith.addf %190, %191 : f32
          %193 = arith.mulf %192, %cst_1 : f32
          %194 = memref.load %arg0[%132] : memref<?xf32>
          %195 = arith.mulf %193, %194 : f32
          memref.store %195, %arg0[%132] : memref<?xf32>
          %196 = memref.load %arg7[%117] : memref<?xf32>
          %197 = memref.load %arg1[%132] : memref<?xf32>
          %198 = arith.mulf %196, %197 : f32
          memref.store %198, %arg1[%132] : memref<?xf32>
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
      %112 = arith.addi %98, %c-1 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %99, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c1 : index
          %115 = arith.muli %114, %100 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.muli %arg15, %100 overflow<nsw> : index
          %118 = arith.muli %117, %101 overflow<nsw> : index
          %119 = arith.addi %116, %118 : index
          %120 = arith.addi %119, %c2 : index
          %121 = memref.load %arg0[%120] : memref<?xf32>
          %122 = arith.addi %119, %c1 : index
          %123 = memref.load %arg0[%122] : memref<?xf32>
          %124 = arith.subf %121, %123 : f32
          %125 = memref.load %arg1[%122] : memref<?xf32>
          %126 = arith.addf %124, %125 : f32
          %127 = arith.muli %arg16, %100 overflow<nsw> : index
          %128 = arith.addi %arg17, %127 : index
          %129 = arith.addi %128, %118 : index
          %130 = arith.addi %129, %c1 : index
          %131 = memref.load %arg1[%130] : memref<?xf32>
          %132 = arith.subf %126, %131 : f32
          memref.store %132, %arg4[%122] : memref<?xf32>
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
      %112 = arith.addi %108, %c-2 : index
      scf.for %arg16 = %c0 to %112 step %c1 {
        %113 = arith.addi %109, %c-1 : index
        scf.for %arg17 = %c0 to %113 step %c1 {
          %114 = arith.addi %arg16, %c2 : index
          %115 = arith.muli %114, %110 overflow<nsw> : index
          %116 = arith.addi %arg17, %115 : index
          %117 = arith.addi %116, %c1 : index
          %118 = memref.load %arg14[%117] : memref<?xf32>
          %119 = arith.mulf %118, %cst_1 : f32
          %120 = arith.muli %arg15, %110 overflow<nsw> : index
          %121 = arith.muli %120, %111 overflow<nsw> : index
          %122 = arith.addi %116, %121 : index
          %123 = arith.addi %122, %c1 : index
          %124 = memref.load %arg2[%123] : memref<?xf32>
          %125 = memref.load %arg9[%117] : memref<?xf32>
          %126 = arith.mulf %124, %125 : f32
          %127 = arith.addi %122, %c2 : index
          %128 = memref.load %arg5[%127] : memref<?xf32>
          %129 = memref.load %arg5[%123] : memref<?xf32>
          %130 = arith.addf %128, %129 : f32
          %131 = arith.mulf %126, %130 : f32
          %132 = arith.addi %arg16, %c1 : index
          %133 = arith.muli %132, %110 overflow<nsw> : index
          %134 = arith.addi %arg17, %133 : index
          %135 = arith.addi %134, %121 : index
          %136 = arith.addi %135, %c1 : index
          %137 = memref.load %arg2[%136] : memref<?xf32>
          %138 = arith.addi %134, %c1 : index
          %139 = memref.load %arg9[%138] : memref<?xf32>
          %140 = arith.mulf %137, %139 : f32
          %141 = arith.addi %135, %c2 : index
          %142 = memref.load %arg5[%141] : memref<?xf32>
          %143 = memref.load %arg5[%136] : memref<?xf32>
          %144 = arith.addf %142, %143 : f32
          %145 = arith.mulf %140, %144 : f32
          %146 = arith.addf %131, %145 : f32
          %147 = arith.mulf %119, %146 : f32
          %148 = memref.load %arg4[%123] : memref<?xf32>
          %149 = arith.addf %148, %147 : f32
          memref.store %149, %arg4[%123] : memref<?xf32>
        }
      }
    }
    return
  }
}


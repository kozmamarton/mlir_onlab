module attributes {dlti.dl_spec = #dlti.dl_spec<"dlti.endianness" = "little", i64 = dense<64> : vector<2xi64>, i128 = dense<128> : vector<2xi64>, i1 = dense<8> : vector<2xi64>, i8 = dense<8> : vector<2xi64>, i16 = dense<16> : vector<2xi64>, i32 = dense<32> : vector<2xi64>, f16 = dense<16> : vector<2xi64>, f64 = dense<64> : vector<2xi64>, f128 = dense<128> : vector<2xi64>>, llvm.data_layout = "e-m:o-i64:64-i128:128-n32:64-S128", llvm.target_triple = "arm64-apple-macosx15.0.0", "polygeist.target-cpu" = "apple-m1", "polygeist.target-features" = "+aes,+crc,+crypto,+dotprod,+fp-armv8,+fp16fml,+fullfp16,+lse,+neon,+ras,+rcpc,+rdm,+sha2,+sha3,+sm4,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8.5a,+v8a,+zcm,+zcz"} {
  memref.global @tprni : memref<1xf32>
  memref.global @dti2 : memref<1xf32>
  memref.global @kbm2 : memref<1xi32>
  memref.global @imm1 : memref<1xi32>
  memref.global @jmm1 : memref<1xi32>
  memref.global @kbm1 : memref<1xi32>
  memref.global @im : memref<1xi32>
  memref.global @jm : memref<1xi32>
  memref.global @kb : memref<1xi32>
  func.func @ext_advt2_(%arg0: memref<?xf32> {polygeist.name = "fb", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "f", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "fclim", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "xflux", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "yflux", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "zflux", polygeist.type = "float *"}, %arg7: memref<?xi32> {polygeist.name = "nitera", polygeist.type = "int *"}, %arg8: memref<?xf32> {polygeist.name = "sw", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "u", polygeist.type = "float *"}, %arg10: memref<?xf32> {polygeist.name = "v", polygeist.type = "float *"}, %arg11: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg12: memref<?xf32> {polygeist.name = "aam", polygeist.type = "float *"}, %arg13: memref<?xf32> {polygeist.name = "dum", polygeist.type = "float *"}, %arg14: memref<?xf32> {polygeist.name = "dvm", polygeist.type = "float *"}, %arg15: memref<?xf32> {polygeist.name = "dx", polygeist.type = "float *"}, %arg16: memref<?xf32> {polygeist.name = "dy", polygeist.type = "float *"}, %arg17: memref<?xf32> {polygeist.name = "dz", polygeist.type = "float *"}, %arg18: memref<?xf32> {polygeist.name = "h", polygeist.type = "float *"}, %arg19: memref<?xf32> {polygeist.name = "w", polygeist.type = "float *"}, %arg20: memref<?xf32> {polygeist.name = "art", polygeist.type = "float *"}, %arg21: memref<?xf32> {polygeist.name = "etb", polygeist.type = "float *"}, %arg22: memref<?xf32> {polygeist.name = "etf", polygeist.type = "float *"}, %arg23: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg24: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg25: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg26: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}, %arg27: memref<?xf32> {polygeist.name = "fbmem", polygeist.type = "float *"}, %arg28: memref<?xf32> {polygeist.name = "eta", polygeist.type = "float *"}, %arg29: memref<?xf32> {polygeist.name = "xmassflux", polygeist.type = "float *"}, %arg30: memref<?xf32> {polygeist.name = "ymassflux", polygeist.type = "float *"}, %arg31: memref<?xf32> {polygeist.name = "zwflux", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
    %c2 = arith.constant 2 : index
    %c10 = arith.constant 10 : index
    %c0 = arith.constant 0 : index
    %cst = arith.constant 9.99999971E-10 : f32
    %cst_0 = arith.constant 9.99999982E-15 : f32
    %cst_1 = arith.constant 2.000000e+00 : f32
    %c-1 = arith.constant -1 : index
    %true = arith.constant true
    %cst_2 = arith.constant 5.000000e-01 : f64
    %cst_3 = arith.constant 5.000000e-01 : f32
    %cst_4 = arith.constant 2.500000e-01 : f32
    %cst_5 = arith.constant 0.000000e+00 : f32
    %c1 = arith.constant 1 : index
    %0 = memref.get_global @kb : memref<1xi32>
    %1 = memref.load %0[%c0] : memref<1xi32>
    %2 = arith.index_cast %1 : i32 to index
    %3 = memref.get_global @jm : memref<1xi32>
    %4 = memref.get_global @im : memref<1xi32>
    %5 = memref.load %3[%c0] : memref<1xi32>
    %6 = memref.load %4[%c0] : memref<1xi32>
    %7 = arith.index_cast %5 : i32 to index
    %8 = arith.index_cast %6 : i32 to index
    scf.for %arg32 = %c0 to %2 step %c1 {
      scf.for %arg33 = %c0 to %7 step %c1 {
        scf.for %arg34 = %c0 to %8 step %c1 {
          %130 = arith.muli %arg33, %8 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          %132 = arith.muli %arg32, %8 overflow<nsw> : index
          %133 = arith.muli %132, %7 overflow<nsw> : index
          %134 = arith.addi %131, %133 : index
          memref.store %cst_5, %arg29[%134] : memref<?xf32>
          memref.store %cst_5, %arg30[%134] : memref<?xf32>
        }
      }
    }
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @jmm1 : memref<1xi32>
    %13 = memref.load %12[%c0] : memref<1xi32>
    %14 = memref.load %4[%c0] : memref<1xi32>
    %15 = memref.load %3[%c0] : memref<1xi32>
    %16 = arith.index_cast %13 : i32 to index
    %17 = arith.index_cast %14 : i32 to index
    %18 = arith.index_cast %15 : i32 to index
    scf.for %arg32 = %c0 to %11 step %c1 {
      %130 = arith.addi %16, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %131 = arith.addi %17, %c-1 : index
        scf.for %arg34 = %c0 to %131 step %c1 {
          %132 = arith.addi %arg33, %c1 : index
          %133 = arith.muli %132, %17 overflow<nsw> : index
          %134 = arith.addi %arg34, %133 : index
          %135 = memref.load %arg16[%134] : memref<?xf32>
          %136 = arith.addi %134, %c1 : index
          %137 = memref.load %arg16[%136] : memref<?xf32>
          %138 = arith.addf %135, %137 : f32
          %139 = arith.mulf %138, %cst_4 : f32
          %140 = memref.load %arg11[%134] : memref<?xf32>
          %141 = memref.load %arg11[%136] : memref<?xf32>
          %142 = arith.addf %140, %141 : f32
          %143 = arith.mulf %139, %142 : f32
          %144 = arith.muli %arg32, %17 overflow<nsw> : index
          %145 = arith.muli %144, %18 overflow<nsw> : index
          %146 = arith.addi %134, %145 : index
          %147 = arith.addi %146, %c1 : index
          %148 = memref.load %arg9[%147] : memref<?xf32>
          %149 = arith.mulf %143, %148 : f32
          memref.store %149, %arg29[%147] : memref<?xf32>
        }
      }
    }
    %19 = memref.load %9[%c0] : memref<1xi32>
    %20 = arith.index_cast %19 : i32 to index
    %21 = memref.get_global @imm1 : memref<1xi32>
    %22 = memref.load %3[%c0] : memref<1xi32>
    %23 = memref.load %21[%c0] : memref<1xi32>
    %24 = memref.load %4[%c0] : memref<1xi32>
    %25 = arith.index_cast %22 : i32 to index
    %26 = arith.index_cast %23 : i32 to index
    %27 = arith.index_cast %24 : i32 to index
    scf.for %arg32 = %c0 to %20 step %c1 {
      %130 = arith.addi %25, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %131 = arith.addi %26, %c-1 : index
        scf.for %arg34 = %c0 to %131 step %c1 {
          %132 = arith.muli %arg33, %27 overflow<nsw> : index
          %133 = arith.addi %arg34, %132 : index
          %134 = arith.addi %133, %c1 : index
          %135 = memref.load %arg15[%134] : memref<?xf32>
          %136 = arith.addi %arg33, %c1 : index
          %137 = arith.muli %136, %27 overflow<nsw> : index
          %138 = arith.addi %arg34, %137 : index
          %139 = arith.addi %138, %c1 : index
          %140 = memref.load %arg15[%139] : memref<?xf32>
          %141 = arith.addf %135, %140 : f32
          %142 = arith.mulf %141, %cst_4 : f32
          %143 = memref.load %arg11[%134] : memref<?xf32>
          %144 = memref.load %arg11[%139] : memref<?xf32>
          %145 = arith.addf %143, %144 : f32
          %146 = arith.mulf %142, %145 : f32
          %147 = arith.muli %arg32, %27 overflow<nsw> : index
          %148 = arith.muli %147, %25 overflow<nsw> : index
          %149 = arith.addi %138, %148 : index
          %150 = arith.addi %149, %c1 : index
          %151 = memref.load %arg10[%150] : memref<?xf32>
          %152 = arith.mulf %146, %151 : f32
          memref.store %152, %arg30[%150] : memref<?xf32>
        }
      }
    }
    %28 = memref.load %3[%c0] : memref<1xi32>
    %29 = arith.index_cast %28 : i32 to index
    %30 = memref.get_global @kbm2 : memref<1xi32>
    %31 = memref.load %4[%c0] : memref<1xi32>
    %32 = memref.load %9[%c0] : memref<1xi32>
    %33 = memref.load %30[%c0] : memref<1xi32>
    %34 = arith.index_cast %31 : i32 to index
    %35 = arith.index_cast %32 : i32 to index
    %36 = arith.muli %35, %34 : index
    %37 = arith.muli %36, %29 : index
    %38 = arith.index_cast %33 : i32 to index
    %39 = arith.muli %38, %34 : index
    %40 = arith.muli %39, %29 : index
    scf.for %arg32 = %c0 to %29 step %c1 {
      scf.for %arg33 = %c0 to %34 step %c1 {
        %130 = arith.muli %arg32, %34 overflow<nsw> : index
        %131 = arith.addi %arg33, %130 : index
        %132 = memref.load %arg21[%131] : memref<?xf32>
        memref.store %132, %arg28[%131] : memref<?xf32>
        %133 = arith.addi %131, %40 : index
        %134 = memref.load %arg0[%133] : memref<?xf32>
        %135 = arith.addi %131, %37 : index
        memref.store %134, %arg0[%135] : memref<?xf32>
      }
    }
    %41 = memref.load %0[%c0] : memref<1xi32>
    %42 = arith.index_cast %41 : i32 to index
    %43 = memref.load %3[%c0] : memref<1xi32>
    %44 = memref.load %4[%c0] : memref<1xi32>
    %45 = arith.index_cast %43 : i32 to index
    %46 = arith.index_cast %44 : i32 to index
    scf.for %arg32 = %c0 to %42 step %c1 {
      scf.for %arg33 = %c0 to %45 step %c1 {
        scf.for %arg34 = %c0 to %46 step %c1 {
          %130 = arith.muli %arg33, %46 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          %132 = arith.muli %arg32, %46 overflow<nsw> : index
          %133 = arith.muli %132, %45 overflow<nsw> : index
          %134 = arith.addi %131, %133 : index
          %135 = memref.load %arg19[%134] : memref<?xf32>
          memref.store %135, %arg31[%134] : memref<?xf32>
          %136 = memref.load %arg0[%134] : memref<?xf32>
          memref.store %136, %arg27[%134] : memref<?xf32>
        }
      }
    }
    %47 = memref.get_global @dti2 : memref<1xf32>
    %48 = memref.load %9[%c0] : memref<1xi32>
    %49 = memref.load %3[%c0] : memref<1xi32>
    %50 = memref.load %4[%c0] : memref<1xi32>
    %51 = memref.load %12[%c0] : memref<1xi32>
    %52 = memref.load %21[%c0] : memref<1xi32>
    %53 = memref.load %47[%c0] : memref<1xf32>
    %54 = memref.load %0[%c0] : memref<1xi32>
    %55 = arith.index_cast %48 : i32 to index
    %56 = arith.index_cast %49 : i32 to index
    %57 = arith.index_cast %50 : i32 to index
    %58 = arith.index_cast %51 : i32 to index
    %59 = arith.index_cast %52 : i32 to index
    %60 = arith.muli %55, %57 : index
    %61 = arith.muli %60, %56 : index
    %62 = arith.index_cast %54 : i32 to index
    scf.for %arg32 = %c0 to %62 step %c1 {
      scf.for %arg33 = %c0 to %56 step %c1 {
        scf.for %arg34 = %c0 to %57 step %c1 {
          %130 = arith.muli %arg33, %57 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          %132 = memref.load %arg23[%131] : memref<?xf32>
          %133 = arith.muli %arg32, %57 overflow<nsw> : index
          %134 = arith.muli %133, %56 overflow<nsw> : index
          %135 = arith.addi %131, %134 : index
          %136 = memref.load %arg3[%135] : memref<?xf32>
          %137 = arith.mulf %136, %132 : f32
          memref.store %137, %arg3[%135] : memref<?xf32>
        }
      }
    }
    %63 = memref.load %9[%c0] : memref<1xi32>
    %64 = arith.index_cast %63 : i32 to index
    %65 = memref.load %12[%c0] : memref<1xi32>
    %66 = memref.load %4[%c0] : memref<1xi32>
    %67 = memref.load %3[%c0] : memref<1xi32>
    %68 = memref.load %arg8[%c0] : memref<?xf32>
    %69 = arith.index_cast %65 : i32 to index
    %70 = arith.index_cast %66 : i32 to index
    %71 = arith.index_cast %67 : i32 to index
    scf.for %arg32 = %c0 to %64 step %c1 {
      %130 = arith.addi %69, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %131 = arith.addi %arg33, %c1 : index
        %132 = arith.addi %70, %c-1 : index
        scf.for %arg34 = %c0 to %132 step %c1 {
          %133 = arith.addi %arg34, %c1 : index
          %134 = arith.muli %131, %70 overflow<nsw> : index
          %135 = arith.addi %arg34, %134 : index
          %136 = arith.muli %arg32, %70 overflow<nsw> : index
          %137 = arith.muli %136, %71 overflow<nsw> : index
          %138 = arith.addi %135, %137 : index
          %139 = arith.addi %138, %c1 : index
          %140 = memref.load %arg3[%139] : memref<?xf32>
          %141 = arith.cmpf olt, %140, %cst : f32
          %142 = scf.if %141 -> (i1) {
            scf.yield %true : i1
          } else {
            %143 = memref.load %4[%c0] : memref<1xi32>
            %144 = memref.load %3[%c0] : memref<1xi32>
            %145 = arith.index_cast %143 : i32 to index
            %146 = arith.muli %131, %145 : index
            %147 = arith.addi %arg34, %146 : index
            %148 = arith.muli %arg32, %145 : index
            %149 = arith.index_cast %144 : i32 to index
            %150 = arith.muli %148, %149 : index
            %151 = arith.addi %147, %150 : index
            %152 = memref.load %arg3[%151] : memref<?xf32>
            %153 = arith.cmpf olt, %152, %cst : f32
            scf.yield %153 : i1
          }
          scf.if %142 {
            %143 = memref.load %4[%c0] : memref<1xi32>
            %144 = memref.load %3[%c0] : memref<1xi32>
            %145 = arith.index_cast %143 : i32 to index
            %146 = arith.muli %131, %145 : index
            %147 = arith.addi %133, %146 : index
            %148 = arith.muli %arg32, %145 : index
            %149 = arith.index_cast %144 : i32 to index
            %150 = arith.muli %148, %149 : index
            %151 = arith.addi %147, %150 : index
            memref.store %cst_5, %arg29[%151] : memref<?xf32>
          } else {
            %143 = memref.load %4[%c0] : memref<1xi32>
            %144 = memref.load %3[%c0] : memref<1xi32>
            %145 = arith.index_cast %143 : i32 to index
            %146 = arith.muli %131, %145 : index
            %147 = arith.addi %133, %146 : index
            %148 = arith.muli %arg32, %145 : index
            %149 = arith.index_cast %144 : i32 to index
            %150 = arith.muli %148, %149 : index
            %151 = arith.addi %147, %150 : index
            %152 = memref.load %arg29[%151] : memref<?xf32>
            %153 = arith.extf %152 : f32 to f64
            %154 = math.absf %153 : f64
            %155 = arith.truncf %154 : f64 to f32
            %156 = memref.load %47[%c0] : memref<1xf32>
            %157 = arith.mulf %156, %152 : f32
            %158 = arith.mulf %157, %152 : f32
            %159 = arith.mulf %158, %cst_1 : f32
            %160 = memref.load %arg24[%147] : memref<?xf32>
            %161 = arith.addi %arg34, %146 : index
            %162 = memref.load %arg11[%161] : memref<?xf32>
            %163 = memref.load %arg11[%147] : memref<?xf32>
            %164 = arith.addf %162, %163 : f32
            %165 = arith.mulf %160, %164 : f32
            %166 = arith.divf %159, %165 : f32
            %167 = memref.load %arg3[%151] : memref<?xf32>
            %168 = arith.addi %161, %150 : index
            %169 = memref.load %arg3[%168] : memref<?xf32>
            %170 = arith.subf %167, %169 : f32
            %171 = arith.addf %169, %167 : f32
            %172 = arith.addf %171, %cst_0 : f32
            %173 = arith.divf %170, %172 : f32
            %174 = arith.subf %155, %166 : f32
            %175 = arith.mulf %174, %173 : f32
            %176 = arith.mulf %175, %68 : f32
            memref.store %176, %arg29[%151] : memref<?xf32>
            %177 = arith.extf %155 : f32 to f64
            %178 = math.absf %177 : f64
            %179 = arith.extf %166 : f32 to f64
            %180 = math.absf %179 : f64
            %181 = arith.cmpf olt, %178, %180 : f64
            scf.if %181 {
              %182 = memref.load %4[%c0] : memref<1xi32>
              %183 = memref.load %3[%c0] : memref<1xi32>
              %184 = arith.index_cast %182 : i32 to index
              %185 = arith.muli %131, %184 : index
              %186 = arith.addi %133, %185 : index
              %187 = arith.muli %arg32, %184 : index
              %188 = arith.index_cast %183 : i32 to index
              %189 = arith.muli %187, %188 : index
              %190 = arith.addi %186, %189 : index
              memref.store %cst_5, %arg29[%190] : memref<?xf32>
            }
          }
        }
      }
    }
    %72 = memref.load %9[%c0] : memref<1xi32>
    %73 = arith.index_cast %72 : i32 to index
    %74 = memref.load %3[%c0] : memref<1xi32>
    %75 = memref.load %21[%c0] : memref<1xi32>
    %76 = memref.load %4[%c0] : memref<1xi32>
    %77 = memref.load %arg8[%c0] : memref<?xf32>
    %78 = arith.index_cast %74 : i32 to index
    %79 = arith.index_cast %75 : i32 to index
    %80 = arith.index_cast %76 : i32 to index
    scf.for %arg32 = %c0 to %73 step %c1 {
      %130 = arith.addi %78, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %131 = arith.addi %arg33, %c1 : index
        %132 = arith.addi %79, %c-1 : index
        scf.for %arg34 = %c0 to %132 step %c1 {
          %133 = arith.addi %arg34, %c1 : index
          %134 = arith.muli %131, %80 overflow<nsw> : index
          %135 = arith.addi %arg34, %134 : index
          %136 = arith.muli %arg32, %80 overflow<nsw> : index
          %137 = arith.muli %136, %78 overflow<nsw> : index
          %138 = arith.addi %135, %137 : index
          %139 = arith.addi %138, %c1 : index
          %140 = memref.load %arg3[%139] : memref<?xf32>
          %141 = arith.cmpf olt, %140, %cst : f32
          %142 = scf.if %141 -> (i1) {
            scf.yield %true : i1
          } else {
            %143 = memref.load %4[%c0] : memref<1xi32>
            %144 = memref.load %3[%c0] : memref<1xi32>
            %145 = arith.index_cast %143 : i32 to index
            %146 = arith.muli %arg33, %145 : index
            %147 = arith.addi %133, %146 : index
            %148 = arith.muli %arg32, %145 : index
            %149 = arith.index_cast %144 : i32 to index
            %150 = arith.muli %148, %149 : index
            %151 = arith.addi %147, %150 : index
            %152 = memref.load %arg3[%151] : memref<?xf32>
            %153 = arith.cmpf olt, %152, %cst : f32
            scf.yield %153 : i1
          }
          scf.if %142 {
            %143 = memref.load %4[%c0] : memref<1xi32>
            %144 = memref.load %3[%c0] : memref<1xi32>
            %145 = arith.index_cast %143 : i32 to index
            %146 = arith.muli %131, %145 : index
            %147 = arith.addi %133, %146 : index
            %148 = arith.muli %arg32, %145 : index
            %149 = arith.index_cast %144 : i32 to index
            %150 = arith.muli %148, %149 : index
            %151 = arith.addi %147, %150 : index
            memref.store %cst_5, %arg30[%151] : memref<?xf32>
          } else {
            %143 = memref.load %4[%c0] : memref<1xi32>
            %144 = memref.load %3[%c0] : memref<1xi32>
            %145 = arith.index_cast %143 : i32 to index
            %146 = arith.muli %131, %145 : index
            %147 = arith.addi %133, %146 : index
            %148 = arith.muli %arg32, %145 : index
            %149 = arith.index_cast %144 : i32 to index
            %150 = arith.muli %148, %149 : index
            %151 = arith.addi %147, %150 : index
            %152 = memref.load %arg30[%151] : memref<?xf32>
            %153 = arith.extf %152 : f32 to f64
            %154 = math.absf %153 : f64
            %155 = arith.truncf %154 : f64 to f32
            %156 = memref.load %47[%c0] : memref<1xf32>
            %157 = arith.mulf %156, %152 : f32
            %158 = arith.mulf %157, %152 : f32
            %159 = arith.mulf %158, %cst_1 : f32
            %160 = memref.load %arg25[%147] : memref<?xf32>
            %161 = arith.muli %arg33, %145 : index
            %162 = arith.addi %133, %161 : index
            %163 = memref.load %arg11[%162] : memref<?xf32>
            %164 = memref.load %arg11[%147] : memref<?xf32>
            %165 = arith.addf %163, %164 : f32
            %166 = arith.mulf %160, %165 : f32
            %167 = arith.divf %159, %166 : f32
            %168 = memref.load %arg3[%151] : memref<?xf32>
            %169 = arith.addi %162, %150 : index
            %170 = memref.load %arg3[%169] : memref<?xf32>
            %171 = arith.subf %168, %170 : f32
            %172 = arith.addf %170, %168 : f32
            %173 = arith.addf %172, %cst_0 : f32
            %174 = arith.divf %171, %173 : f32
            %175 = arith.subf %155, %167 : f32
            %176 = arith.mulf %175, %174 : f32
            %177 = arith.mulf %176, %77 : f32
            memref.store %177, %arg30[%151] : memref<?xf32>
            %178 = arith.extf %155 : f32 to f64
            %179 = math.absf %178 : f64
            %180 = arith.extf %167 : f32 to f64
            %181 = math.absf %180 : f64
            %182 = arith.cmpf olt, %179, %181 : f64
            scf.if %182 {
              %183 = memref.load %4[%c0] : memref<1xi32>
              %184 = memref.load %3[%c0] : memref<1xi32>
              %185 = arith.index_cast %183 : i32 to index
              %186 = arith.muli %131, %185 : index
              %187 = arith.addi %133, %186 : index
              %188 = arith.muli %arg32, %185 : index
              %189 = arith.index_cast %184 : i32 to index
              %190 = arith.muli %188, %189 : index
              %191 = arith.addi %187, %190 : index
              memref.store %cst_5, %arg30[%191] : memref<?xf32>
            }
          }
        }
      }
    }
    %81 = memref.load %9[%c0] : memref<1xi32>
    %82 = arith.index_cast %81 : i32 to index
    %83 = memref.load %12[%c0] : memref<1xi32>
    %84 = memref.load %21[%c0] : memref<1xi32>
    %85 = memref.load %4[%c0] : memref<1xi32>
    %86 = memref.load %3[%c0] : memref<1xi32>
    %87 = memref.load %arg8[%c0] : memref<?xf32>
    %88 = arith.index_cast %83 : i32 to index
    %89 = arith.index_cast %84 : i32 to index
    %90 = arith.index_cast %85 : i32 to index
    %91 = arith.index_cast %86 : i32 to index
    %92 = arith.addi %82, %c-1 : index
    scf.for %arg32 = %c0 to %92 step %c1 {
      %130 = arith.addi %arg32, %c1 : index
      %131 = arith.addi %88, %c-1 : index
      scf.for %arg33 = %c0 to %131 step %c1 {
        %132 = arith.addi %arg33, %c1 : index
        %133 = arith.addi %89, %c-1 : index
        scf.for %arg34 = %c0 to %133 step %c1 {
          %134 = arith.addi %arg34, %c1 : index
          %135 = arith.muli %132, %90 overflow<nsw> : index
          %136 = arith.addi %arg34, %135 : index
          %137 = arith.muli %130, %90 overflow<nsw> : index
          %138 = arith.muli %137, %91 overflow<nsw> : index
          %139 = arith.addi %136, %138 : index
          %140 = arith.addi %139, %c1 : index
          %141 = memref.load %arg3[%140] : memref<?xf32>
          %142 = arith.cmpf olt, %141, %cst : f32
          %143 = scf.if %142 -> (i1) {
            scf.yield %true : i1
          } else {
            %144 = memref.load %4[%c0] : memref<1xi32>
            %145 = memref.load %3[%c0] : memref<1xi32>
            %146 = arith.index_cast %144 : i32 to index
            %147 = arith.muli %132, %146 : index
            %148 = arith.addi %134, %147 : index
            %149 = arith.muli %arg32, %146 : index
            %150 = arith.index_cast %145 : i32 to index
            %151 = arith.muli %149, %150 : index
            %152 = arith.addi %148, %151 : index
            %153 = memref.load %arg3[%152] : memref<?xf32>
            %154 = arith.cmpf olt, %153, %cst : f32
            scf.yield %154 : i1
          }
          scf.if %143 {
            %144 = memref.load %4[%c0] : memref<1xi32>
            %145 = memref.load %3[%c0] : memref<1xi32>
            %146 = arith.index_cast %144 : i32 to index
            %147 = arith.muli %132, %146 : index
            %148 = arith.addi %134, %147 : index
            %149 = arith.muli %130, %146 : index
            %150 = arith.index_cast %145 : i32 to index
            %151 = arith.muli %149, %150 : index
            %152 = arith.addi %148, %151 : index
            memref.store %cst_5, %arg31[%152] : memref<?xf32>
          } else {
            %144 = memref.load %4[%c0] : memref<1xi32>
            %145 = memref.load %3[%c0] : memref<1xi32>
            %146 = arith.index_cast %144 : i32 to index
            %147 = arith.muli %132, %146 : index
            %148 = arith.addi %134, %147 : index
            %149 = arith.muli %130, %146 : index
            %150 = arith.index_cast %145 : i32 to index
            %151 = arith.muli %149, %150 : index
            %152 = arith.addi %148, %151 : index
            %153 = memref.load %arg31[%152] : memref<?xf32>
            %154 = arith.extf %153 : f32 to f64
            %155 = math.absf %154 : f64
            %156 = arith.truncf %155 : f64 to f32
            %157 = memref.load %47[%c0] : memref<1xf32>
            %158 = arith.mulf %157, %153 : f32
            %159 = arith.mulf %158, %153 : f32
            %160 = memref.load %arg26[%arg32] : memref<?xf32>
            %161 = memref.load %arg11[%148] : memref<?xf32>
            %162 = arith.mulf %160, %161 : f32
            %163 = arith.divf %159, %162 : f32
            %164 = arith.muli %arg32, %146 : index
            %165 = arith.muli %164, %150 : index
            %166 = arith.addi %148, %165 : index
            %167 = memref.load %arg3[%166] : memref<?xf32>
            %168 = memref.load %arg3[%152] : memref<?xf32>
            %169 = arith.subf %167, %168 : f32
            %170 = arith.addf %168, %167 : f32
            %171 = arith.addf %170, %cst_0 : f32
            %172 = arith.divf %169, %171 : f32
            %173 = arith.subf %156, %163 : f32
            %174 = arith.mulf %173, %172 : f32
            %175 = arith.mulf %174, %87 : f32
            memref.store %175, %arg31[%152] : memref<?xf32>
            %176 = arith.extf %156 : f32 to f64
            %177 = math.absf %176 : f64
            %178 = arith.extf %163 : f32 to f64
            %179 = math.absf %178 : f64
            %180 = arith.cmpf olt, %177, %179 : f64
            scf.if %180 {
              %181 = memref.load %4[%c0] : memref<1xi32>
              %182 = memref.load %3[%c0] : memref<1xi32>
              %183 = arith.index_cast %181 : i32 to index
              %184 = arith.muli %132, %183 : index
              %185 = arith.addi %134, %184 : index
              %186 = arith.muli %130, %183 : index
              %187 = arith.index_cast %182 : i32 to index
              %188 = arith.muli %186, %187 : index
              %189 = arith.addi %185, %188 : index
              memref.store %cst_5, %arg31[%189] : memref<?xf32>
            }
          }
        }
      }
    }
    scf.for %arg32 = %c0 to %c10 step %c1 {
      scf.for %arg33 = %c0 to %55 step %c1 {
        %133 = arith.addi %56, %c-1 : index
        scf.for %arg34 = %c0 to %133 step %c1 {
          %134 = arith.addi %57, %c-1 : index
          scf.for %arg35 = %c0 to %134 step %c1 {
            %135 = arith.addi %arg34, %c1 : index
            %136 = arith.muli %135, %57 overflow<nsw> : index
            %137 = arith.addi %arg35, %136 : index
            %138 = arith.muli %arg33, %57 overflow<nsw> : index
            %139 = arith.muli %138, %56 overflow<nsw> : index
            %140 = arith.addi %137, %139 : index
            %141 = arith.addi %140, %c1 : index
            %142 = memref.load %arg29[%141] : memref<?xf32>
            %143 = arith.extf %142 : f32 to f64
            %144 = math.absf %143 : f64
            %145 = arith.addf %143, %144 : f64
            %146 = memref.load %arg27[%140] : memref<?xf32>
            %147 = arith.extf %146 : f32 to f64
            %148 = arith.mulf %145, %147 : f64
            %149 = arith.subf %143, %144 : f64
            %150 = memref.load %arg27[%141] : memref<?xf32>
            %151 = arith.extf %150 : f32 to f64
            %152 = arith.mulf %149, %151 : f64
            %153 = arith.addf %148, %152 : f64
            %154 = arith.mulf %153, %cst_2 : f64
            %155 = arith.truncf %154 : f64 to f32
            memref.store %155, %arg4[%141] : memref<?xf32>
            %156 = memref.load %arg30[%141] : memref<?xf32>
            %157 = arith.extf %156 : f32 to f64
            %158 = math.absf %157 : f64
            %159 = arith.addf %157, %158 : f64
            %160 = arith.muli %arg34, %57 overflow<nsw> : index
            %161 = arith.addi %arg35, %160 : index
            %162 = arith.addi %161, %139 : index
            %163 = arith.addi %162, %c1 : index
            %164 = memref.load %arg27[%163] : memref<?xf32>
            %165 = arith.extf %164 : f32 to f64
            %166 = arith.mulf %159, %165 : f64
            %167 = arith.subf %157, %158 : f64
            %168 = memref.load %arg27[%141] : memref<?xf32>
            %169 = arith.extf %168 : f32 to f64
            %170 = arith.mulf %167, %169 : f64
            %171 = arith.addf %166, %170 : f64
            %172 = arith.mulf %171, %cst_2 : f64
            %173 = arith.truncf %172 : f64 to f32
            memref.store %173, %arg5[%141] : memref<?xf32>
          }
        }
      }
      %130 = arith.addi %58, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %133 = arith.addi %59, %c-1 : index
        scf.for %arg34 = %c0 to %133 step %c1 {
          %134 = arith.addi %arg33, %c1 : index
          %135 = arith.muli %134, %57 overflow<nsw> : index
          %136 = arith.addi %arg34, %135 : index
          %137 = arith.addi %136, %c1 : index
          memref.store %cst_5, %arg6[%137] : memref<?xf32>
          %138 = arith.addi %arg34, %61 : index
          %139 = arith.addi %138, %135 : index
          %140 = arith.addi %139, %c1 : index
          memref.store %cst_5, %arg6[%140] : memref<?xf32>
        }
      }
      %131 = arith.cmpi eq, %arg32, %c0 : index
      scf.if %131 {
        %133 = memref.load %12[%c0] : memref<1xi32>
        %134 = arith.index_cast %133 : i32 to index
        %135 = memref.load %21[%c0] : memref<1xi32>
        %136 = memref.load %4[%c0] : memref<1xi32>
        %137 = arith.index_cast %135 : i32 to index
        %138 = arith.index_cast %136 : i32 to index
        scf.for %arg33 = %c1 to %134 step %c1 {
          %139 = arith.muli %arg33, %138 : index
          scf.for %arg34 = %c1 to %137 step %c1 {
            %140 = arith.addi %arg34, %139 : index
            %141 = memref.load %arg19[%140] : memref<?xf32>
            %142 = memref.load %arg1[%140] : memref<?xf32>
            %143 = arith.mulf %141, %142 : f32
            %144 = memref.load %arg20[%140] : memref<?xf32>
            %145 = arith.mulf %143, %144 : f32
            memref.store %145, %arg6[%140] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      }
      %132 = arith.addi %55, %c-1 : index
      scf.for %arg33 = %c0 to %132 step %c1 {
        scf.for %arg34 = %c0 to %130 step %c1 {
          %133 = arith.addi %59, %c-1 : index
          scf.for %arg35 = %c0 to %133 step %c1 {
            %134 = arith.addi %arg34, %c1 : index
            %135 = arith.muli %134, %57 overflow<nsw> : index
            %136 = arith.addi %arg35, %135 : index
            %137 = arith.addi %arg33, %c1 : index
            %138 = arith.muli %137, %57 overflow<nsw> : index
            %139 = arith.muli %138, %56 overflow<nsw> : index
            %140 = arith.addi %136, %139 : index
            %141 = arith.addi %140, %c1 : index
            %142 = memref.load %arg31[%141] : memref<?xf32>
            %143 = arith.extf %142 : f32 to f64
            %144 = math.absf %143 : f64
            %145 = arith.addf %143, %144 : f64
            %146 = memref.load %arg27[%141] : memref<?xf32>
            %147 = arith.extf %146 : f32 to f64
            %148 = arith.mulf %145, %147 : f64
            %149 = arith.subf %143, %144 : f64
            %150 = arith.muli %arg33, %57 overflow<nsw> : index
            %151 = arith.muli %150, %56 overflow<nsw> : index
            %152 = arith.addi %136, %151 : index
            %153 = arith.addi %152, %c1 : index
            %154 = memref.load %arg27[%153] : memref<?xf32>
            %155 = arith.extf %154 : f32 to f64
            %156 = arith.mulf %149, %155 : f64
            %157 = arith.addf %148, %156 : f64
            %158 = arith.mulf %157, %cst_2 : f64
            %159 = arith.truncf %158 : f64 to f32
            memref.store %159, %arg6[%141] : memref<?xf32>
            %160 = arith.addi %136, %c1 : index
            %161 = memref.load %arg20[%160] : memref<?xf32>
            %162 = memref.load %arg6[%141] : memref<?xf32>
            %163 = arith.mulf %162, %161 : f32
            memref.store %163, %arg6[%141] : memref<?xf32>
          }
        }
      }
      scf.for %arg33 = %c0 to %55 step %c1 {
        %133 = memref.load %arg17[%arg33] : memref<?xf32>
        scf.for %arg34 = %c0 to %130 step %c1 {
          %134 = arith.addi %59, %c-1 : index
          scf.for %arg35 = %c0 to %134 step %c1 {
            %135 = arith.addi %arg34, %c1 : index
            %136 = arith.muli %135, %57 overflow<nsw> : index
            %137 = arith.addi %arg35, %136 : index
            %138 = arith.muli %arg33, %57 overflow<nsw> : index
            %139 = arith.muli %138, %56 overflow<nsw> : index
            %140 = arith.addi %137, %139 : index
            %141 = arith.addi %140, %c2 : index
            %142 = memref.load %arg4[%141] : memref<?xf32>
            %143 = arith.addi %140, %c1 : index
            %144 = memref.load %arg4[%143] : memref<?xf32>
            %145 = arith.subf %142, %144 : f32
            %146 = arith.addi %arg34, %c2 : index
            %147 = arith.muli %146, %57 overflow<nsw> : index
            %148 = arith.addi %arg35, %147 : index
            %149 = arith.addi %148, %139 : index
            %150 = arith.addi %149, %c1 : index
            %151 = memref.load %arg5[%150] : memref<?xf32>
            %152 = arith.addf %145, %151 : f32
            %153 = memref.load %arg5[%143] : memref<?xf32>
            %154 = arith.subf %152, %153 : f32
            %155 = memref.load %arg6[%143] : memref<?xf32>
            %156 = arith.addi %arg33, %c1 : index
            %157 = arith.muli %156, %57 overflow<nsw> : index
            %158 = arith.muli %157, %56 overflow<nsw> : index
            %159 = arith.addi %137, %158 : index
            %160 = arith.addi %159, %c1 : index
            %161 = memref.load %arg6[%160] : memref<?xf32>
            %162 = arith.subf %155, %161 : f32
            %163 = arith.divf %162, %133 : f32
            %164 = arith.addf %154, %163 : f32
            memref.store %164, %arg3[%143] : memref<?xf32>
            %165 = memref.load %arg27[%143] : memref<?xf32>
            %166 = arith.addi %137, %c1 : index
            %167 = memref.load %arg18[%166] : memref<?xf32>
            %168 = memref.load %arg28[%166] : memref<?xf32>
            %169 = arith.addf %167, %168 : f32
            %170 = arith.mulf %165, %169 : f32
            %171 = memref.load %arg20[%166] : memref<?xf32>
            %172 = arith.mulf %170, %171 : f32
            %173 = memref.load %arg3[%143] : memref<?xf32>
            %174 = arith.mulf %53, %173 : f32
            %175 = arith.subf %172, %174 : f32
            %176 = memref.load %arg22[%166] : memref<?xf32>
            %177 = arith.addf %167, %176 : f32
            %178 = arith.mulf %177, %171 : f32
            %179 = arith.divf %175, %178 : f32
            memref.store %179, %arg3[%143] : memref<?xf32>
          }
        }
      }
      scf.for %arg33 = %c0 to %56 step %c1 {
        scf.for %arg34 = %c0 to %57 step %c1 {
          %133 = arith.muli %arg33, %57 overflow<nsw> : index
          %134 = arith.addi %arg34, %133 : index
          %135 = memref.load %arg22[%134] : memref<?xf32>
          memref.store %135, %arg28[%134] : memref<?xf32>
        }
      }
      scf.for %arg33 = %c0 to %56 step %c1 {
        scf.for %arg34 = %c0 to %57 step %c1 {
          scf.for %arg35 = %c0 to %62 step %c1 {
            %133 = arith.muli %arg33, %57 overflow<nsw> : index
            %134 = arith.addi %arg34, %133 : index
            %135 = arith.muli %arg35, %57 overflow<nsw> : index
            %136 = arith.muli %135, %56 overflow<nsw> : index
            %137 = arith.addi %134, %136 : index
            %138 = memref.load %arg3[%137] : memref<?xf32>
            memref.store %138, %arg27[%137] : memref<?xf32>
          }
        }
      }
    }
    %93 = memref.load %0[%c0] : memref<1xi32>
    %94 = arith.index_cast %93 : i32 to index
    %95 = memref.load %3[%c0] : memref<1xi32>
    %96 = memref.load %4[%c0] : memref<1xi32>
    %97 = arith.index_cast %95 : i32 to index
    %98 = arith.index_cast %96 : i32 to index
    scf.for %arg32 = %c0 to %94 step %c1 {
      scf.for %arg33 = %c0 to %97 step %c1 {
        scf.for %arg34 = %c0 to %98 step %c1 {
          %130 = arith.muli %arg33, %98 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          %132 = arith.muli %arg32, %98 overflow<nsw> : index
          %133 = arith.muli %132, %97 overflow<nsw> : index
          %134 = arith.addi %131, %133 : index
          %135 = memref.load %arg2[%134] : memref<?xf32>
          %136 = memref.load %arg0[%134] : memref<?xf32>
          %137 = arith.subf %136, %135 : f32
          memref.store %137, %arg0[%134] : memref<?xf32>
        }
      }
    }
    %99 = memref.load %9[%c0] : memref<1xi32>
    %100 = arith.index_cast %99 : i32 to index
    %101 = memref.load %3[%c0] : memref<1xi32>
    %102 = memref.load %4[%c0] : memref<1xi32>
    %103 = arith.index_cast %101 : i32 to index
    %104 = arith.index_cast %102 : i32 to index
    scf.for %arg32 = %c0 to %100 step %c1 {
      %130 = arith.addi %103, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %131 = arith.addi %104, %c-1 : index
        scf.for %arg34 = %c0 to %131 step %c1 {
          %132 = arith.addi %arg33, %c1 : index
          %133 = arith.muli %132, %104 overflow<nsw> : index
          %134 = arith.addi %arg34, %133 : index
          %135 = arith.muli %arg32, %104 overflow<nsw> : index
          %136 = arith.muli %135, %103 overflow<nsw> : index
          %137 = arith.addi %134, %136 : index
          %138 = arith.addi %137, %c1 : index
          %139 = memref.load %arg12[%138] : memref<?xf32>
          %140 = memref.load %arg12[%137] : memref<?xf32>
          %141 = arith.addf %139, %140 : f32
          %142 = arith.mulf %141, %cst_3 : f32
          memref.store %142, %arg29[%138] : memref<?xf32>
          %143 = memref.load %arg12[%138] : memref<?xf32>
          %144 = arith.muli %arg33, %104 overflow<nsw> : index
          %145 = arith.addi %arg34, %144 : index
          %146 = arith.addi %145, %136 : index
          %147 = arith.addi %146, %c1 : index
          %148 = memref.load %arg12[%147] : memref<?xf32>
          %149 = arith.addf %143, %148 : f32
          %150 = arith.mulf %149, %cst_3 : f32
          memref.store %150, %arg30[%138] : memref<?xf32>
        }
      }
    }
    %105 = memref.load %9[%c0] : memref<1xi32>
    %106 = arith.index_cast %105 : i32 to index
    %107 = memref.get_global @tprni : memref<1xf32>
    %108 = memref.load %3[%c0] : memref<1xi32>
    %109 = memref.load %4[%c0] : memref<1xi32>
    %110 = memref.load %107[%c0] : memref<1xf32>
    %111 = arith.index_cast %108 : i32 to index
    %112 = arith.index_cast %109 : i32 to index
    scf.for %arg32 = %c0 to %106 step %c1 {
      %130 = arith.addi %111, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %131 = arith.addi %112, %c-1 : index
        scf.for %arg34 = %c0 to %131 step %c1 {
          %132 = arith.addi %arg33, %c1 : index
          %133 = arith.muli %132, %112 overflow<nsw> : index
          %134 = arith.addi %arg34, %133 : index
          %135 = arith.muli %arg32, %112 overflow<nsw> : index
          %136 = arith.muli %135, %111 overflow<nsw> : index
          %137 = arith.addi %134, %136 : index
          %138 = arith.addi %137, %c1 : index
          %139 = memref.load %arg29[%138] : memref<?xf32>
          %140 = arith.negf %139 : f32
          %141 = arith.addi %134, %c1 : index
          %142 = memref.load %arg18[%141] : memref<?xf32>
          %143 = memref.load %arg18[%134] : memref<?xf32>
          %144 = arith.addf %142, %143 : f32
          %145 = arith.mulf %140, %144 : f32
          %146 = arith.mulf %145, %110 : f32
          %147 = memref.load %arg0[%138] : memref<?xf32>
          %148 = memref.load %arg0[%137] : memref<?xf32>
          %149 = arith.subf %147, %148 : f32
          %150 = arith.mulf %146, %149 : f32
          %151 = memref.load %arg13[%141] : memref<?xf32>
          %152 = arith.mulf %150, %151 : f32
          %153 = memref.load %arg16[%141] : memref<?xf32>
          %154 = memref.load %arg16[%134] : memref<?xf32>
          %155 = arith.addf %153, %154 : f32
          %156 = arith.mulf %152, %155 : f32
          %157 = arith.mulf %156, %cst_3 : f32
          %158 = memref.load %arg15[%141] : memref<?xf32>
          %159 = memref.load %arg15[%134] : memref<?xf32>
          %160 = arith.addf %158, %159 : f32
          %161 = arith.divf %157, %160 : f32
          memref.store %161, %arg4[%138] : memref<?xf32>
          %162 = memref.load %arg30[%138] : memref<?xf32>
          %163 = arith.negf %162 : f32
          %164 = memref.load %arg18[%141] : memref<?xf32>
          %165 = arith.muli %arg33, %112 overflow<nsw> : index
          %166 = arith.addi %arg34, %165 : index
          %167 = arith.addi %166, %c1 : index
          %168 = memref.load %arg18[%167] : memref<?xf32>
          %169 = arith.addf %164, %168 : f32
          %170 = arith.mulf %163, %169 : f32
          %171 = arith.mulf %170, %110 : f32
          %172 = memref.load %arg0[%138] : memref<?xf32>
          %173 = arith.addi %166, %136 : index
          %174 = arith.addi %173, %c1 : index
          %175 = memref.load %arg0[%174] : memref<?xf32>
          %176 = arith.subf %172, %175 : f32
          %177 = arith.mulf %171, %176 : f32
          %178 = memref.load %arg14[%141] : memref<?xf32>
          %179 = arith.mulf %177, %178 : f32
          %180 = memref.load %arg15[%141] : memref<?xf32>
          %181 = memref.load %arg15[%167] : memref<?xf32>
          %182 = arith.addf %180, %181 : f32
          %183 = arith.mulf %179, %182 : f32
          %184 = arith.mulf %183, %cst_3 : f32
          %185 = memref.load %arg16[%141] : memref<?xf32>
          %186 = memref.load %arg16[%167] : memref<?xf32>
          %187 = arith.addf %185, %186 : f32
          %188 = arith.divf %184, %187 : f32
          memref.store %188, %arg5[%138] : memref<?xf32>
        }
      }
    }
    %113 = memref.load %0[%c0] : memref<1xi32>
    %114 = arith.index_cast %113 : i32 to index
    %115 = memref.load %3[%c0] : memref<1xi32>
    %116 = memref.load %4[%c0] : memref<1xi32>
    %117 = arith.index_cast %115 : i32 to index
    %118 = arith.index_cast %116 : i32 to index
    scf.for %arg32 = %c0 to %114 step %c1 {
      scf.for %arg33 = %c0 to %117 step %c1 {
        scf.for %arg34 = %c0 to %118 step %c1 {
          %130 = arith.muli %arg33, %118 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          %132 = arith.muli %arg32, %118 overflow<nsw> : index
          %133 = arith.muli %132, %117 overflow<nsw> : index
          %134 = arith.addi %131, %133 : index
          %135 = memref.load %arg2[%134] : memref<?xf32>
          %136 = memref.load %arg0[%134] : memref<?xf32>
          %137 = arith.addf %136, %135 : f32
          memref.store %137, %arg0[%134] : memref<?xf32>
        }
      }
    }
    %119 = memref.load %9[%c0] : memref<1xi32>
    %120 = arith.index_cast %119 : i32 to index
    %121 = memref.load %12[%c0] : memref<1xi32>
    %122 = memref.load %21[%c0] : memref<1xi32>
    %123 = memref.load %4[%c0] : memref<1xi32>
    %124 = memref.load %3[%c0] : memref<1xi32>
    %125 = memref.load %47[%c0] : memref<1xf32>
    %126 = arith.index_cast %121 : i32 to index
    %127 = arith.index_cast %122 : i32 to index
    %128 = arith.index_cast %123 : i32 to index
    %129 = arith.index_cast %124 : i32 to index
    scf.for %arg32 = %c0 to %120 step %c1 {
      %130 = arith.addi %126, %c-1 : index
      scf.for %arg33 = %c0 to %130 step %c1 {
        %131 = arith.addi %127, %c-1 : index
        scf.for %arg34 = %c0 to %131 step %c1 {
          %132 = arith.addi %arg33, %c1 : index
          %133 = arith.muli %132, %128 overflow<nsw> : index
          %134 = arith.addi %arg34, %133 : index
          %135 = arith.muli %arg32, %128 overflow<nsw> : index
          %136 = arith.muli %135, %129 overflow<nsw> : index
          %137 = arith.addi %134, %136 : index
          %138 = arith.addi %137, %c1 : index
          %139 = memref.load %arg3[%138] : memref<?xf32>
          %140 = arith.addi %137, %c2 : index
          %141 = memref.load %arg4[%140] : memref<?xf32>
          %142 = memref.load %arg4[%138] : memref<?xf32>
          %143 = arith.subf %141, %142 : f32
          %144 = arith.addi %arg33, %c2 : index
          %145 = arith.muli %144, %128 overflow<nsw> : index
          %146 = arith.addi %arg34, %145 : index
          %147 = arith.addi %146, %136 : index
          %148 = arith.addi %147, %c1 : index
          %149 = memref.load %arg5[%148] : memref<?xf32>
          %150 = arith.addf %143, %149 : f32
          %151 = memref.load %arg5[%138] : memref<?xf32>
          %152 = arith.subf %150, %151 : f32
          %153 = arith.mulf %125, %152 : f32
          %154 = arith.addi %134, %c1 : index
          %155 = memref.load %arg18[%154] : memref<?xf32>
          %156 = memref.load %arg22[%154] : memref<?xf32>
          %157 = arith.addf %155, %156 : f32
          %158 = memref.load %arg20[%154] : memref<?xf32>
          %159 = arith.mulf %157, %158 : f32
          %160 = arith.divf %153, %159 : f32
          %161 = arith.subf %139, %160 : f32
          memref.store %161, %arg3[%138] : memref<?xf32>
        }
      }
    }
    return
  }
  func.func @ext_smol_adif_(%arg0: memref<?xf32> {polygeist.name = "xmassflux", polygeist.type = "float *"}, %arg1: memref<?xf32> {polygeist.name = "ymassflux", polygeist.type = "float *"}, %arg2: memref<?xf32> {polygeist.name = "zwflux", polygeist.type = "float *"}, %arg3: memref<?xf32> {polygeist.name = "ff", polygeist.type = "float *"}, %arg4: memref<?xf32> {polygeist.name = "sw", polygeist.type = "float *"}, %arg5: memref<?xf32> {polygeist.name = "fsm", polygeist.type = "float *"}, %arg6: memref<?xf32> {polygeist.name = "aru", polygeist.type = "float *"}, %arg7: memref<?xf32> {polygeist.name = "arv", polygeist.type = "float *"}, %arg8: memref<?xf32> {polygeist.name = "dt", polygeist.type = "float *"}, %arg9: memref<?xf32> {polygeist.name = "dzz", polygeist.type = "float *"}) attributes {llvm.linkage = #llvm.linkage<external>} {
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
    scf.for %arg10 = %c0 to %2 step %c1 {
      scf.for %arg11 = %c0 to %7 step %c1 {
        scf.for %arg12 = %c0 to %8 step %c1 {
          %42 = arith.muli %arg11, %8 overflow<nsw> : index
          %43 = arith.addi %arg12, %42 : index
          %44 = memref.load %arg5[%43] : memref<?xf32>
          %45 = arith.muli %arg10, %8 overflow<nsw> : index
          %46 = arith.muli %45, %7 overflow<nsw> : index
          %47 = arith.addi %43, %46 : index
          %48 = memref.load %arg3[%47] : memref<?xf32>
          %49 = arith.mulf %48, %44 : f32
          memref.store %49, %arg3[%47] : memref<?xf32>
        }
      }
    }
    %9 = memref.get_global @kbm1 : memref<1xi32>
    %10 = memref.load %9[%c0] : memref<1xi32>
    %11 = arith.index_cast %10 : i32 to index
    %12 = memref.get_global @jmm1 : memref<1xi32>
    %13 = memref.load %12[%c0] : memref<1xi32>
    %14 = memref.load %4[%c0] : memref<1xi32>
    %15 = memref.load %3[%c0] : memref<1xi32>
    %16 = memref.load %arg4[%c0] : memref<?xf32>
    %17 = arith.index_cast %13 : i32 to index
    %18 = arith.index_cast %14 : i32 to index
    %19 = arith.index_cast %15 : i32 to index
    scf.for %arg10 = %c0 to %11 step %c1 {
      %42 = arith.addi %17, %c-1 : index
      scf.for %arg11 = %c0 to %42 step %c1 {
        %43 = arith.addi %arg11, %c1 : index
        %44 = arith.addi %18, %c-1 : index
        scf.for %arg12 = %c0 to %44 step %c1 {
          %45 = arith.addi %arg12, %c1 : index
          %46 = arith.muli %43, %18 overflow<nsw> : index
          %47 = arith.addi %arg12, %46 : index
          %48 = arith.muli %arg10, %18 overflow<nsw> : index
          %49 = arith.muli %48, %19 overflow<nsw> : index
          %50 = arith.addi %47, %49 : index
          %51 = arith.addi %50, %c1 : index
          %52 = memref.load %arg3[%51] : memref<?xf32>
          %53 = arith.cmpf olt, %52, %cst_2 : f32
          %54 = scf.if %53 -> (i1) {
            scf.yield %true : i1
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %arg12, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg3[%63] : memref<?xf32>
            %65 = arith.cmpf olt, %64, %cst_2 : f32
            scf.yield %65 : i1
          }
          scf.if %54 {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            memref.store %cst_0, %arg0[%63] : memref<?xf32>
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg0[%63] : memref<?xf32>
            %65 = arith.extf %64 : f32 to f64
            %66 = math.absf %65 : f64
            %67 = arith.truncf %66 : f64 to f32
            %68 = memref.get_global @dti2 : memref<1xf32>
            %69 = memref.load %68[%c0] : memref<1xf32>
            %70 = arith.mulf %69, %64 : f32
            %71 = arith.mulf %70, %64 : f32
            %72 = arith.mulf %71, %cst : f32
            %73 = memref.load %arg6[%59] : memref<?xf32>
            %74 = arith.addi %arg12, %58 : index
            %75 = memref.load %arg8[%74] : memref<?xf32>
            %76 = memref.load %arg8[%59] : memref<?xf32>
            %77 = arith.addf %75, %76 : f32
            %78 = arith.mulf %73, %77 : f32
            %79 = arith.divf %72, %78 : f32
            %80 = memref.load %arg3[%63] : memref<?xf32>
            %81 = arith.addi %74, %62 : index
            %82 = memref.load %arg3[%81] : memref<?xf32>
            %83 = arith.subf %80, %82 : f32
            %84 = arith.addf %82, %80 : f32
            %85 = arith.addf %84, %cst_1 : f32
            %86 = arith.divf %83, %85 : f32
            %87 = arith.subf %67, %79 : f32
            %88 = arith.mulf %87, %86 : f32
            %89 = arith.mulf %88, %16 : f32
            memref.store %89, %arg0[%63] : memref<?xf32>
            %90 = arith.extf %67 : f32 to f64
            %91 = math.absf %90 : f64
            %92 = arith.extf %79 : f32 to f64
            %93 = math.absf %92 : f64
            %94 = arith.cmpf olt, %91, %93 : f64
            scf.if %94 {
              %95 = memref.load %4[%c0] : memref<1xi32>
              %96 = memref.load %3[%c0] : memref<1xi32>
              %97 = arith.index_cast %95 : i32 to index
              %98 = arith.muli %43, %97 : index
              %99 = arith.addi %45, %98 : index
              %100 = arith.muli %arg10, %97 : index
              %101 = arith.index_cast %96 : i32 to index
              %102 = arith.muli %100, %101 : index
              %103 = arith.addi %99, %102 : index
              memref.store %cst_0, %arg0[%103] : memref<?xf32>
            }
          }
        }
      }
    }
    %20 = memref.load %9[%c0] : memref<1xi32>
    %21 = arith.index_cast %20 : i32 to index
    %22 = memref.get_global @imm1 : memref<1xi32>
    %23 = memref.load %3[%c0] : memref<1xi32>
    %24 = memref.load %22[%c0] : memref<1xi32>
    %25 = memref.load %4[%c0] : memref<1xi32>
    %26 = memref.load %arg4[%c0] : memref<?xf32>
    %27 = arith.index_cast %23 : i32 to index
    %28 = arith.index_cast %24 : i32 to index
    %29 = arith.index_cast %25 : i32 to index
    scf.for %arg10 = %c0 to %21 step %c1 {
      %42 = arith.addi %27, %c-1 : index
      scf.for %arg11 = %c0 to %42 step %c1 {
        %43 = arith.addi %arg11, %c1 : index
        %44 = arith.addi %28, %c-1 : index
        scf.for %arg12 = %c0 to %44 step %c1 {
          %45 = arith.addi %arg12, %c1 : index
          %46 = arith.muli %43, %29 overflow<nsw> : index
          %47 = arith.addi %arg12, %46 : index
          %48 = arith.muli %arg10, %29 overflow<nsw> : index
          %49 = arith.muli %48, %27 overflow<nsw> : index
          %50 = arith.addi %47, %49 : index
          %51 = arith.addi %50, %c1 : index
          %52 = memref.load %arg3[%51] : memref<?xf32>
          %53 = arith.cmpf olt, %52, %cst_2 : f32
          %54 = scf.if %53 -> (i1) {
            scf.yield %true : i1
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %arg11, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg3[%63] : memref<?xf32>
            %65 = arith.cmpf olt, %64, %cst_2 : f32
            scf.yield %65 : i1
          }
          scf.if %54 {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            memref.store %cst_0, %arg1[%63] : memref<?xf32>
          } else {
            %55 = memref.load %4[%c0] : memref<1xi32>
            %56 = memref.load %3[%c0] : memref<1xi32>
            %57 = arith.index_cast %55 : i32 to index
            %58 = arith.muli %43, %57 : index
            %59 = arith.addi %45, %58 : index
            %60 = arith.muli %arg10, %57 : index
            %61 = arith.index_cast %56 : i32 to index
            %62 = arith.muli %60, %61 : index
            %63 = arith.addi %59, %62 : index
            %64 = memref.load %arg1[%63] : memref<?xf32>
            %65 = arith.extf %64 : f32 to f64
            %66 = math.absf %65 : f64
            %67 = arith.truncf %66 : f64 to f32
            %68 = memref.get_global @dti2 : memref<1xf32>
            %69 = memref.load %68[%c0] : memref<1xf32>
            %70 = arith.mulf %69, %64 : f32
            %71 = arith.mulf %70, %64 : f32
            %72 = arith.mulf %71, %cst : f32
            %73 = memref.load %arg7[%59] : memref<?xf32>
            %74 = arith.muli %arg11, %57 : index
            %75 = arith.addi %45, %74 : index
            %76 = memref.load %arg8[%75] : memref<?xf32>
            %77 = memref.load %arg8[%59] : memref<?xf32>
            %78 = arith.addf %76, %77 : f32
            %79 = arith.mulf %73, %78 : f32
            %80 = arith.divf %72, %79 : f32
            %81 = memref.load %arg3[%63] : memref<?xf32>
            %82 = arith.addi %75, %62 : index
            %83 = memref.load %arg3[%82] : memref<?xf32>
            %84 = arith.subf %81, %83 : f32
            %85 = arith.addf %83, %81 : f32
            %86 = arith.addf %85, %cst_1 : f32
            %87 = arith.divf %84, %86 : f32
            %88 = arith.subf %67, %80 : f32
            %89 = arith.mulf %88, %87 : f32
            %90 = arith.mulf %89, %26 : f32
            memref.store %90, %arg1[%63] : memref<?xf32>
            %91 = arith.extf %67 : f32 to f64
            %92 = math.absf %91 : f64
            %93 = arith.extf %80 : f32 to f64
            %94 = math.absf %93 : f64
            %95 = arith.cmpf olt, %92, %94 : f64
            scf.if %95 {
              %96 = memref.load %4[%c0] : memref<1xi32>
              %97 = memref.load %3[%c0] : memref<1xi32>
              %98 = arith.index_cast %96 : i32 to index
              %99 = arith.muli %43, %98 : index
              %100 = arith.addi %45, %99 : index
              %101 = arith.muli %arg10, %98 : index
              %102 = arith.index_cast %97 : i32 to index
              %103 = arith.muli %101, %102 : index
              %104 = arith.addi %100, %103 : index
              memref.store %cst_0, %arg1[%104] : memref<?xf32>
            }
          }
        }
      }
    }
    %30 = memref.load %9[%c0] : memref<1xi32>
    %31 = arith.index_cast %30 : i32 to index
    %32 = memref.load %12[%c0] : memref<1xi32>
    %33 = memref.load %22[%c0] : memref<1xi32>
    %34 = memref.load %4[%c0] : memref<1xi32>
    %35 = memref.load %3[%c0] : memref<1xi32>
    %36 = memref.load %arg4[%c0] : memref<?xf32>
    %37 = arith.index_cast %32 : i32 to index
    %38 = arith.index_cast %33 : i32 to index
    %39 = arith.index_cast %34 : i32 to index
    %40 = arith.index_cast %35 : i32 to index
    %41 = arith.addi %31, %c-1 : index
    scf.for %arg10 = %c0 to %41 step %c1 {
      %42 = arith.addi %arg10, %c1 : index
      %43 = arith.addi %37, %c-1 : index
      scf.for %arg11 = %c0 to %43 step %c1 {
        %44 = arith.addi %arg11, %c1 : index
        %45 = arith.addi %38, %c-1 : index
        scf.for %arg12 = %c0 to %45 step %c1 {
          %46 = arith.addi %arg12, %c1 : index
          %47 = arith.muli %44, %39 overflow<nsw> : index
          %48 = arith.addi %arg12, %47 : index
          %49 = arith.muli %42, %39 overflow<nsw> : index
          %50 = arith.muli %49, %40 overflow<nsw> : index
          %51 = arith.addi %48, %50 : index
          %52 = arith.addi %51, %c1 : index
          %53 = memref.load %arg3[%52] : memref<?xf32>
          %54 = arith.cmpf olt, %53, %cst_2 : f32
          %55 = scf.if %54 -> (i1) {
            scf.yield %true : i1
          } else {
            %56 = memref.load %4[%c0] : memref<1xi32>
            %57 = memref.load %3[%c0] : memref<1xi32>
            %58 = arith.index_cast %56 : i32 to index
            %59 = arith.muli %44, %58 : index
            %60 = arith.addi %46, %59 : index
            %61 = arith.muli %arg10, %58 : index
            %62 = arith.index_cast %57 : i32 to index
            %63 = arith.muli %61, %62 : index
            %64 = arith.addi %60, %63 : index
            %65 = memref.load %arg3[%64] : memref<?xf32>
            %66 = arith.cmpf olt, %65, %cst_2 : f32
            scf.yield %66 : i1
          }
          scf.if %55 {
            %56 = memref.load %4[%c0] : memref<1xi32>
            %57 = memref.load %3[%c0] : memref<1xi32>
            %58 = arith.index_cast %56 : i32 to index
            %59 = arith.muli %44, %58 : index
            %60 = arith.addi %46, %59 : index
            %61 = arith.muli %42, %58 : index
            %62 = arith.index_cast %57 : i32 to index
            %63 = arith.muli %61, %62 : index
            %64 = arith.addi %60, %63 : index
            memref.store %cst_0, %arg2[%64] : memref<?xf32>
          } else {
            %56 = memref.load %4[%c0] : memref<1xi32>
            %57 = memref.load %3[%c0] : memref<1xi32>
            %58 = arith.index_cast %56 : i32 to index
            %59 = arith.muli %44, %58 : index
            %60 = arith.addi %46, %59 : index
            %61 = arith.muli %42, %58 : index
            %62 = arith.index_cast %57 : i32 to index
            %63 = arith.muli %61, %62 : index
            %64 = arith.addi %60, %63 : index
            %65 = memref.load %arg2[%64] : memref<?xf32>
            %66 = arith.extf %65 : f32 to f64
            %67 = math.absf %66 : f64
            %68 = arith.truncf %67 : f64 to f32
            %69 = memref.get_global @dti2 : memref<1xf32>
            %70 = memref.load %69[%c0] : memref<1xf32>
            %71 = arith.mulf %70, %65 : f32
            %72 = arith.mulf %71, %65 : f32
            %73 = memref.load %arg9[%arg10] : memref<?xf32>
            %74 = memref.load %arg8[%60] : memref<?xf32>
            %75 = arith.mulf %73, %74 : f32
            %76 = arith.divf %72, %75 : f32
            %77 = arith.muli %arg10, %58 : index
            %78 = arith.muli %77, %62 : index
            %79 = arith.addi %60, %78 : index
            %80 = memref.load %arg3[%79] : memref<?xf32>
            %81 = memref.load %arg3[%64] : memref<?xf32>
            %82 = arith.subf %80, %81 : f32
            %83 = arith.addf %81, %80 : f32
            %84 = arith.addf %83, %cst_1 : f32
            %85 = arith.divf %82, %84 : f32
            %86 = arith.subf %68, %76 : f32
            %87 = arith.mulf %86, %85 : f32
            %88 = arith.mulf %87, %36 : f32
            memref.store %88, %arg2[%64] : memref<?xf32>
            %89 = arith.extf %68 : f32 to f64
            %90 = math.absf %89 : f64
            %91 = arith.extf %76 : f32 to f64
            %92 = math.absf %91 : f64
            %93 = arith.cmpf olt, %90, %92 : f64
            scf.if %93 {
              %94 = memref.load %4[%c0] : memref<1xi32>
              %95 = memref.load %3[%c0] : memref<1xi32>
              %96 = arith.index_cast %94 : i32 to index
              %97 = arith.muli %44, %96 : index
              %98 = arith.addi %46, %97 : index
              %99 = arith.muli %42, %96 : index
              %100 = arith.index_cast %95 : i32 to index
              %101 = arith.muli %99, %100 : index
              %102 = arith.addi %98, %101 : index
              memref.store %cst_0, %arg2[%102] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


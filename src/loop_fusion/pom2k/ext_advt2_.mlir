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
          %129 = arith.muli %arg33, %8 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %8 overflow<nsw> : index
          %132 = arith.muli %131, %7 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          memref.store %cst_5, %arg29[%133] : memref<?xf32>
          memref.store %cst_5, %arg30[%133] : memref<?xf32>
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
      scf.for %arg33 = %c1 to %16 step %c1 {
        scf.for %arg34 = %c1 to %17 step %c1 {
          %129 = arith.muli %arg33, %17 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.addi %130, %c-1 : index
          %132 = memref.load %arg16[%131] : memref<?xf32>
          %133 = memref.load %arg16[%130] : memref<?xf32>
          %134 = arith.addf %132, %133 : f32
          %135 = arith.mulf %134, %cst_4 : f32
          %136 = memref.load %arg11[%131] : memref<?xf32>
          %137 = memref.load %arg11[%130] : memref<?xf32>
          %138 = arith.addf %136, %137 : f32
          %139 = arith.mulf %135, %138 : f32
          %140 = arith.muli %arg32, %17 overflow<nsw> : index
          %141 = arith.muli %140, %18 overflow<nsw> : index
          %142 = arith.addi %130, %141 : index
          %143 = memref.load %arg9[%142] : memref<?xf32>
          %144 = arith.mulf %139, %143 : f32
          memref.store %144, %arg29[%142] : memref<?xf32>
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
      scf.for %arg33 = %c1 to %25 step %c1 {
        scf.for %arg34 = %c1 to %26 step %c1 {
          %129 = arith.addi %arg33, %c-1 : index
          %130 = arith.muli %129, %27 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          %132 = memref.load %arg15[%131] : memref<?xf32>
          %133 = arith.muli %arg33, %27 overflow<nsw> : index
          %134 = arith.addi %arg34, %133 : index
          %135 = memref.load %arg15[%134] : memref<?xf32>
          %136 = arith.addf %132, %135 : f32
          %137 = arith.mulf %136, %cst_4 : f32
          %138 = memref.load %arg11[%131] : memref<?xf32>
          %139 = memref.load %arg11[%134] : memref<?xf32>
          %140 = arith.addf %138, %139 : f32
          %141 = arith.mulf %137, %140 : f32
          %142 = arith.muli %arg32, %27 overflow<nsw> : index
          %143 = arith.muli %142, %25 overflow<nsw> : index
          %144 = arith.addi %134, %143 : index
          %145 = memref.load %arg10[%144] : memref<?xf32>
          %146 = arith.mulf %141, %145 : f32
          memref.store %146, %arg30[%144] : memref<?xf32>
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
        %129 = arith.muli %arg32, %34 overflow<nsw> : index
        %130 = arith.addi %arg33, %129 : index
        %131 = memref.load %arg21[%130] : memref<?xf32>
        memref.store %131, %arg28[%130] : memref<?xf32>
        %132 = arith.addi %130, %40 : index
        %133 = memref.load %arg0[%132] : memref<?xf32>
        %134 = arith.addi %130, %37 : index
        memref.store %133, %arg0[%134] : memref<?xf32>
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
          %129 = arith.muli %arg33, %46 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %46 overflow<nsw> : index
          %132 = arith.muli %131, %45 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg19[%133] : memref<?xf32>
          memref.store %134, %arg31[%133] : memref<?xf32>
          %135 = memref.load %arg0[%133] : memref<?xf32>
          memref.store %135, %arg27[%133] : memref<?xf32>
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
          %129 = arith.muli %arg33, %57 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = memref.load %arg23[%130] : memref<?xf32>
          %132 = arith.muli %arg32, %57 overflow<nsw> : index
          %133 = arith.muli %132, %56 overflow<nsw> : index
          %134 = arith.addi %130, %133 : index
          %135 = memref.load %arg3[%134] : memref<?xf32>
          %136 = arith.mulf %135, %131 : f32
          memref.store %136, %arg3[%134] : memref<?xf32>
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
      scf.for %arg33 = %c1 to %69 step %c1 {
        scf.for %arg34 = %c1 to %70 step %c1 {
          %129 = arith.muli %arg33, %70 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %70 overflow<nsw> : index
          %132 = arith.muli %131, %71 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg3[%133] : memref<?xf32>
          %135 = arith.cmpf olt, %134, %cst : f32
          %136 = scf.if %135 -> (i1) {
            scf.yield %true : i1
          } else {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.addi %arg34, %c-1 : index
            %140 = arith.index_cast %137 : i32 to index
            %141 = arith.muli %arg33, %140 : index
            %142 = arith.addi %139, %141 : index
            %143 = arith.muli %arg32, %140 : index
            %144 = arith.index_cast %138 : i32 to index
            %145 = arith.muli %143, %144 : index
            %146 = arith.addi %142, %145 : index
            %147 = memref.load %arg3[%146] : memref<?xf32>
            %148 = arith.cmpf olt, %147, %cst : f32
            scf.yield %148 : i1
          }
          scf.if %136 {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.index_cast %137 : i32 to index
            %140 = arith.muli %arg33, %139 : index
            %141 = arith.addi %arg34, %140 : index
            %142 = arith.muli %arg32, %139 : index
            %143 = arith.index_cast %138 : i32 to index
            %144 = arith.muli %142, %143 : index
            %145 = arith.addi %141, %144 : index
            memref.store %cst_5, %arg29[%145] : memref<?xf32>
          } else {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.index_cast %137 : i32 to index
            %140 = arith.muli %arg33, %139 : index
            %141 = arith.addi %arg34, %140 : index
            %142 = arith.muli %arg32, %139 : index
            %143 = arith.index_cast %138 : i32 to index
            %144 = arith.muli %142, %143 : index
            %145 = arith.addi %141, %144 : index
            %146 = memref.load %arg29[%145] : memref<?xf32>
            %147 = arith.extf %146 : f32 to f64
            %148 = math.absf %147 : f64
            %149 = arith.truncf %148 : f64 to f32
            %150 = memref.load %47[%c0] : memref<1xf32>
            %151 = arith.mulf %150, %146 : f32
            %152 = arith.mulf %151, %146 : f32
            %153 = arith.mulf %152, %cst_1 : f32
            %154 = memref.load %arg24[%141] : memref<?xf32>
            %155 = arith.addi %arg34, %c-1 : index
            %156 = arith.addi %155, %140 : index
            %157 = memref.load %arg11[%156] : memref<?xf32>
            %158 = memref.load %arg11[%141] : memref<?xf32>
            %159 = arith.addf %157, %158 : f32
            %160 = arith.mulf %154, %159 : f32
            %161 = arith.divf %153, %160 : f32
            %162 = memref.load %arg3[%145] : memref<?xf32>
            %163 = arith.addi %156, %144 : index
            %164 = memref.load %arg3[%163] : memref<?xf32>
            %165 = arith.subf %162, %164 : f32
            %166 = arith.addf %164, %162 : f32
            %167 = arith.addf %166, %cst_0 : f32
            %168 = arith.divf %165, %167 : f32
            %169 = arith.subf %149, %161 : f32
            %170 = arith.mulf %169, %168 : f32
            %171 = arith.mulf %170, %68 : f32
            memref.store %171, %arg29[%145] : memref<?xf32>
            %172 = arith.extf %149 : f32 to f64
            %173 = math.absf %172 : f64
            %174 = arith.extf %161 : f32 to f64
            %175 = math.absf %174 : f64
            %176 = arith.cmpf olt, %173, %175 : f64
            scf.if %176 {
              %177 = memref.load %4[%c0] : memref<1xi32>
              %178 = memref.load %3[%c0] : memref<1xi32>
              %179 = arith.index_cast %177 : i32 to index
              %180 = arith.muli %arg33, %179 : index
              %181 = arith.addi %arg34, %180 : index
              %182 = arith.muli %arg32, %179 : index
              %183 = arith.index_cast %178 : i32 to index
              %184 = arith.muli %182, %183 : index
              %185 = arith.addi %181, %184 : index
              memref.store %cst_5, %arg29[%185] : memref<?xf32>
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
      scf.for %arg33 = %c1 to %78 step %c1 {
        scf.for %arg34 = %c1 to %79 step %c1 {
          %129 = arith.muli %arg33, %80 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %80 overflow<nsw> : index
          %132 = arith.muli %131, %78 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg3[%133] : memref<?xf32>
          %135 = arith.cmpf olt, %134, %cst : f32
          %136 = scf.if %135 -> (i1) {
            scf.yield %true : i1
          } else {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.addi %arg33, %c-1 : index
            %140 = arith.index_cast %137 : i32 to index
            %141 = arith.muli %139, %140 : index
            %142 = arith.addi %arg34, %141 : index
            %143 = arith.muli %arg32, %140 : index
            %144 = arith.index_cast %138 : i32 to index
            %145 = arith.muli %143, %144 : index
            %146 = arith.addi %142, %145 : index
            %147 = memref.load %arg3[%146] : memref<?xf32>
            %148 = arith.cmpf olt, %147, %cst : f32
            scf.yield %148 : i1
          }
          scf.if %136 {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.index_cast %137 : i32 to index
            %140 = arith.muli %arg33, %139 : index
            %141 = arith.addi %arg34, %140 : index
            %142 = arith.muli %arg32, %139 : index
            %143 = arith.index_cast %138 : i32 to index
            %144 = arith.muli %142, %143 : index
            %145 = arith.addi %141, %144 : index
            memref.store %cst_5, %arg30[%145] : memref<?xf32>
          } else {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.index_cast %137 : i32 to index
            %140 = arith.muli %arg33, %139 : index
            %141 = arith.addi %arg34, %140 : index
            %142 = arith.muli %arg32, %139 : index
            %143 = arith.index_cast %138 : i32 to index
            %144 = arith.muli %142, %143 : index
            %145 = arith.addi %141, %144 : index
            %146 = memref.load %arg30[%145] : memref<?xf32>
            %147 = arith.extf %146 : f32 to f64
            %148 = math.absf %147 : f64
            %149 = arith.truncf %148 : f64 to f32
            %150 = memref.load %47[%c0] : memref<1xf32>
            %151 = arith.mulf %150, %146 : f32
            %152 = arith.mulf %151, %146 : f32
            %153 = arith.mulf %152, %cst_1 : f32
            %154 = memref.load %arg25[%141] : memref<?xf32>
            %155 = arith.addi %arg33, %c-1 : index
            %156 = arith.muli %155, %139 : index
            %157 = arith.addi %arg34, %156 : index
            %158 = memref.load %arg11[%157] : memref<?xf32>
            %159 = memref.load %arg11[%141] : memref<?xf32>
            %160 = arith.addf %158, %159 : f32
            %161 = arith.mulf %154, %160 : f32
            %162 = arith.divf %153, %161 : f32
            %163 = memref.load %arg3[%145] : memref<?xf32>
            %164 = arith.addi %157, %144 : index
            %165 = memref.load %arg3[%164] : memref<?xf32>
            %166 = arith.subf %163, %165 : f32
            %167 = arith.addf %165, %163 : f32
            %168 = arith.addf %167, %cst_0 : f32
            %169 = arith.divf %166, %168 : f32
            %170 = arith.subf %149, %162 : f32
            %171 = arith.mulf %170, %169 : f32
            %172 = arith.mulf %171, %77 : f32
            memref.store %172, %arg30[%145] : memref<?xf32>
            %173 = arith.extf %149 : f32 to f64
            %174 = math.absf %173 : f64
            %175 = arith.extf %162 : f32 to f64
            %176 = math.absf %175 : f64
            %177 = arith.cmpf olt, %174, %176 : f64
            scf.if %177 {
              %178 = memref.load %4[%c0] : memref<1xi32>
              %179 = memref.load %3[%c0] : memref<1xi32>
              %180 = arith.index_cast %178 : i32 to index
              %181 = arith.muli %arg33, %180 : index
              %182 = arith.addi %arg34, %181 : index
              %183 = arith.muli %arg32, %180 : index
              %184 = arith.index_cast %179 : i32 to index
              %185 = arith.muli %183, %184 : index
              %186 = arith.addi %182, %185 : index
              memref.store %cst_5, %arg30[%186] : memref<?xf32>
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
    scf.for %arg32 = %c1 to %82 step %c1 {
      scf.for %arg33 = %c1 to %88 step %c1 {
        scf.for %arg34 = %c1 to %89 step %c1 {
          %129 = arith.muli %arg33, %90 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %90 overflow<nsw> : index
          %132 = arith.muli %131, %91 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg3[%133] : memref<?xf32>
          %135 = arith.cmpf olt, %134, %cst : f32
          %136 = scf.if %135 -> (i1) {
            scf.yield %true : i1
          } else {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.index_cast %137 : i32 to index
            %140 = arith.muli %arg33, %139 : index
            %141 = arith.addi %arg34, %140 : index
            %142 = arith.addi %arg32, %c-1 : index
            %143 = arith.muli %142, %139 : index
            %144 = arith.index_cast %138 : i32 to index
            %145 = arith.muli %143, %144 : index
            %146 = arith.addi %141, %145 : index
            %147 = memref.load %arg3[%146] : memref<?xf32>
            %148 = arith.cmpf olt, %147, %cst : f32
            scf.yield %148 : i1
          }
          scf.if %136 {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.index_cast %137 : i32 to index
            %140 = arith.muli %arg33, %139 : index
            %141 = arith.addi %arg34, %140 : index
            %142 = arith.muli %arg32, %139 : index
            %143 = arith.index_cast %138 : i32 to index
            %144 = arith.muli %142, %143 : index
            %145 = arith.addi %141, %144 : index
            memref.store %cst_5, %arg31[%145] : memref<?xf32>
          } else {
            %137 = memref.load %4[%c0] : memref<1xi32>
            %138 = memref.load %3[%c0] : memref<1xi32>
            %139 = arith.index_cast %137 : i32 to index
            %140 = arith.muli %arg33, %139 : index
            %141 = arith.addi %arg34, %140 : index
            %142 = arith.muli %arg32, %139 : index
            %143 = arith.index_cast %138 : i32 to index
            %144 = arith.muli %142, %143 : index
            %145 = arith.addi %141, %144 : index
            %146 = memref.load %arg31[%145] : memref<?xf32>
            %147 = arith.extf %146 : f32 to f64
            %148 = math.absf %147 : f64
            %149 = arith.truncf %148 : f64 to f32
            %150 = memref.load %47[%c0] : memref<1xf32>
            %151 = arith.mulf %150, %146 : f32
            %152 = arith.mulf %151, %146 : f32
            %153 = arith.addi %arg32, %c-1 : index
            %154 = memref.load %arg26[%153] : memref<?xf32>
            %155 = memref.load %arg11[%141] : memref<?xf32>
            %156 = arith.mulf %154, %155 : f32
            %157 = arith.divf %152, %156 : f32
            %158 = arith.muli %153, %139 : index
            %159 = arith.muli %158, %143 : index
            %160 = arith.addi %141, %159 : index
            %161 = memref.load %arg3[%160] : memref<?xf32>
            %162 = memref.load %arg3[%145] : memref<?xf32>
            %163 = arith.subf %161, %162 : f32
            %164 = arith.addf %162, %161 : f32
            %165 = arith.addf %164, %cst_0 : f32
            %166 = arith.divf %163, %165 : f32
            %167 = arith.subf %149, %157 : f32
            %168 = arith.mulf %167, %166 : f32
            %169 = arith.mulf %168, %87 : f32
            memref.store %169, %arg31[%145] : memref<?xf32>
            %170 = arith.extf %149 : f32 to f64
            %171 = math.absf %170 : f64
            %172 = arith.extf %157 : f32 to f64
            %173 = math.absf %172 : f64
            %174 = arith.cmpf olt, %171, %173 : f64
            scf.if %174 {
              %175 = memref.load %4[%c0] : memref<1xi32>
              %176 = memref.load %3[%c0] : memref<1xi32>
              %177 = arith.index_cast %175 : i32 to index
              %178 = arith.muli %arg33, %177 : index
              %179 = arith.addi %arg34, %178 : index
              %180 = arith.muli %arg32, %177 : index
              %181 = arith.index_cast %176 : i32 to index
              %182 = arith.muli %180, %181 : index
              %183 = arith.addi %179, %182 : index
              memref.store %cst_5, %arg31[%183] : memref<?xf32>
            }
          }
        }
      }
    }
    scf.for %arg32 = %c0 to %c10 step %c1 {
      scf.for %arg33 = %c0 to %55 step %c1 {
        scf.for %arg34 = %c1 to %56 step %c1 {
          scf.for %arg35 = %c1 to %57 step %c1 {
            %130 = arith.muli %arg34, %57 overflow<nsw> : index
            %131 = arith.addi %arg35, %130 : index
            %132 = arith.muli %arg33, %57 overflow<nsw> : index
            %133 = arith.muli %132, %56 overflow<nsw> : index
            %134 = arith.addi %131, %133 : index
            %135 = memref.load %arg29[%134] : memref<?xf32>
            %136 = arith.extf %135 : f32 to f64
            %137 = math.absf %136 : f64
            %138 = arith.addf %136, %137 : f64
            %139 = arith.addi %134, %c-1 : index
            %140 = memref.load %arg27[%139] : memref<?xf32>
            %141 = arith.extf %140 : f32 to f64
            %142 = arith.mulf %138, %141 : f64
            %143 = arith.subf %136, %137 : f64
            %144 = memref.load %arg27[%134] : memref<?xf32>
            %145 = arith.extf %144 : f32 to f64
            %146 = arith.mulf %143, %145 : f64
            %147 = arith.addf %142, %146 : f64
            %148 = arith.mulf %147, %cst_2 : f64
            %149 = arith.truncf %148 : f64 to f32
            memref.store %149, %arg4[%134] : memref<?xf32>
            %150 = memref.load %arg30[%134] : memref<?xf32>
            %151 = arith.extf %150 : f32 to f64
            %152 = math.absf %151 : f64
            %153 = arith.addf %151, %152 : f64
            %154 = arith.addi %arg34, %c-1 : index
            %155 = arith.muli %154, %57 overflow<nsw> : index
            %156 = arith.addi %arg35, %155 : index
            %157 = arith.addi %156, %133 : index
            %158 = memref.load %arg27[%157] : memref<?xf32>
            %159 = arith.extf %158 : f32 to f64
            %160 = arith.mulf %153, %159 : f64
            %161 = arith.subf %151, %152 : f64
            %162 = memref.load %arg27[%134] : memref<?xf32>
            %163 = arith.extf %162 : f32 to f64
            %164 = arith.mulf %161, %163 : f64
            %165 = arith.addf %160, %164 : f64
            %166 = arith.mulf %165, %cst_2 : f64
            %167 = arith.truncf %166 : f64 to f32
            memref.store %167, %arg5[%134] : memref<?xf32>
          }
        }
      }
      scf.for %arg33 = %c1 to %58 step %c1 {
        scf.for %arg34 = %c1 to %59 step %c1 {
          %130 = arith.muli %arg33, %57 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          memref.store %cst_5, %arg6[%131] : memref<?xf32>
          %132 = arith.addi %131, %61 : index
          memref.store %cst_5, %arg6[%132] : memref<?xf32>
        }
      }
      %129 = arith.cmpi eq, %arg32, %c0 : index
      scf.if %129 {
        %130 = memref.load %12[%c0] : memref<1xi32>
        %131 = arith.index_cast %130 : i32 to index
        %132 = memref.load %21[%c0] : memref<1xi32>
        %133 = memref.load %4[%c0] : memref<1xi32>
        %134 = arith.index_cast %132 : i32 to index
        %135 = arith.index_cast %133 : i32 to index
        scf.for %arg33 = %c1 to %131 step %c1 {
          %136 = arith.muli %arg33, %135 : index
          scf.for %arg34 = %c1 to %134 step %c1 {
            %137 = arith.addi %arg34, %136 : index
            %138 = memref.load %arg19[%137] : memref<?xf32>
            %139 = memref.load %arg1[%137] : memref<?xf32>
            %140 = arith.mulf %138, %139 : f32
            %141 = memref.load %arg20[%137] : memref<?xf32>
            %142 = arith.mulf %140, %141 : f32
            memref.store %142, %arg6[%137] : memref<?xf32>
          } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "i", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "imm1"}
        } {constants = [], locals = [], mlirclang.direction = "forward", mlirclang.indvar = "j", mlirclang.lb_src = "1", mlirclang.loop_kind = "scf.for", mlirclang.ub_src = "jmm1"}
      }
      scf.for %arg33 = %c1 to %55 step %c1 {
        scf.for %arg34 = %c1 to %58 step %c1 {
          scf.for %arg35 = %c1 to %59 step %c1 {
            %130 = arith.muli %arg34, %57 overflow<nsw> : index
            %131 = arith.addi %arg35, %130 : index
            %132 = arith.muli %arg33, %57 overflow<nsw> : index
            %133 = arith.muli %132, %56 overflow<nsw> : index
            %134 = arith.addi %131, %133 : index
            %135 = memref.load %arg31[%134] : memref<?xf32>
            %136 = arith.extf %135 : f32 to f64
            %137 = math.absf %136 : f64
            %138 = arith.addf %136, %137 : f64
            %139 = memref.load %arg27[%134] : memref<?xf32>
            %140 = arith.extf %139 : f32 to f64
            %141 = arith.mulf %138, %140 : f64
            %142 = arith.subf %136, %137 : f64
            %143 = arith.addi %arg33, %c-1 : index
            %144 = arith.muli %143, %57 overflow<nsw> : index
            %145 = arith.muli %144, %56 overflow<nsw> : index
            %146 = arith.addi %131, %145 : index
            %147 = memref.load %arg27[%146] : memref<?xf32>
            %148 = arith.extf %147 : f32 to f64
            %149 = arith.mulf %142, %148 : f64
            %150 = arith.addf %141, %149 : f64
            %151 = arith.mulf %150, %cst_2 : f64
            %152 = arith.truncf %151 : f64 to f32
            memref.store %152, %arg6[%134] : memref<?xf32>
            %153 = memref.load %arg20[%131] : memref<?xf32>
            %154 = memref.load %arg6[%134] : memref<?xf32>
            %155 = arith.mulf %154, %153 : f32
            memref.store %155, %arg6[%134] : memref<?xf32>
          }
        }
      }
      scf.for %arg33 = %c0 to %55 step %c1 {
        %130 = memref.load %arg17[%arg33] : memref<?xf32>
        scf.for %arg34 = %c1 to %58 step %c1 {
          scf.for %arg35 = %c1 to %59 step %c1 {
            %131 = arith.muli %arg34, %57 overflow<nsw> : index
            %132 = arith.addi %arg35, %131 : index
            %133 = arith.muli %arg33, %57 overflow<nsw> : index
            %134 = arith.muli %133, %56 overflow<nsw> : index
            %135 = arith.addi %132, %134 : index
            %136 = arith.addi %135, %c1 : index
            %137 = memref.load %arg4[%136] : memref<?xf32>
            %138 = memref.load %arg4[%135] : memref<?xf32>
            %139 = arith.subf %137, %138 : f32
            %140 = arith.addi %arg34, %c1 : index
            %141 = arith.muli %140, %57 overflow<nsw> : index
            %142 = arith.addi %arg35, %141 : index
            %143 = arith.addi %142, %134 : index
            %144 = memref.load %arg5[%143] : memref<?xf32>
            %145 = arith.addf %139, %144 : f32
            %146 = memref.load %arg5[%135] : memref<?xf32>
            %147 = arith.subf %145, %146 : f32
            %148 = memref.load %arg6[%135] : memref<?xf32>
            %149 = arith.addi %arg33, %c1 : index
            %150 = arith.muli %149, %57 overflow<nsw> : index
            %151 = arith.muli %150, %56 overflow<nsw> : index
            %152 = arith.addi %132, %151 : index
            %153 = memref.load %arg6[%152] : memref<?xf32>
            %154 = arith.subf %148, %153 : f32
            %155 = arith.divf %154, %130 : f32
            %156 = arith.addf %147, %155 : f32
            memref.store %156, %arg3[%135] : memref<?xf32>
            %157 = memref.load %arg27[%135] : memref<?xf32>
            %158 = memref.load %arg18[%132] : memref<?xf32>
            %159 = memref.load %arg28[%132] : memref<?xf32>
            %160 = arith.addf %158, %159 : f32
            %161 = arith.mulf %157, %160 : f32
            %162 = memref.load %arg20[%132] : memref<?xf32>
            %163 = arith.mulf %161, %162 : f32
            %164 = memref.load %arg3[%135] : memref<?xf32>
            %165 = arith.mulf %53, %164 : f32
            %166 = arith.subf %163, %165 : f32
            %167 = memref.load %arg22[%132] : memref<?xf32>
            %168 = arith.addf %158, %167 : f32
            %169 = arith.mulf %168, %162 : f32
            %170 = arith.divf %166, %169 : f32
            memref.store %170, %arg3[%135] : memref<?xf32>
          }
        }
      }
      scf.for %arg33 = %c0 to %56 step %c1 {
        scf.for %arg34 = %c0 to %57 step %c1 {
          %130 = arith.muli %arg33, %57 overflow<nsw> : index
          %131 = arith.addi %arg34, %130 : index
          %132 = memref.load %arg22[%131] : memref<?xf32>
          memref.store %132, %arg28[%131] : memref<?xf32>
        }
      }
      scf.for %arg33 = %c0 to %56 step %c1 {
        scf.for %arg34 = %c0 to %57 step %c1 {
          scf.for %arg35 = %c0 to %62 step %c1 {
            %130 = arith.muli %arg33, %57 overflow<nsw> : index
            %131 = arith.addi %arg34, %130 : index
            %132 = arith.muli %arg35, %57 overflow<nsw> : index
            %133 = arith.muli %132, %56 overflow<nsw> : index
            %134 = arith.addi %131, %133 : index
            %135 = memref.load %arg3[%134] : memref<?xf32>
            memref.store %135, %arg27[%134] : memref<?xf32>
          }
        }
      }
    }
    %92 = memref.load %0[%c0] : memref<1xi32>
    %93 = arith.index_cast %92 : i32 to index
    %94 = memref.load %3[%c0] : memref<1xi32>
    %95 = memref.load %4[%c0] : memref<1xi32>
    %96 = arith.index_cast %94 : i32 to index
    %97 = arith.index_cast %95 : i32 to index
    scf.for %arg32 = %c0 to %93 step %c1 {
      scf.for %arg33 = %c0 to %96 step %c1 {
        scf.for %arg34 = %c0 to %97 step %c1 {
          %129 = arith.muli %arg33, %97 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %97 overflow<nsw> : index
          %132 = arith.muli %131, %96 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg2[%133] : memref<?xf32>
          %135 = memref.load %arg0[%133] : memref<?xf32>
          %136 = arith.subf %135, %134 : f32
          memref.store %136, %arg0[%133] : memref<?xf32>
        }
      }
    }
    %98 = memref.load %9[%c0] : memref<1xi32>
    %99 = arith.index_cast %98 : i32 to index
    %100 = memref.load %3[%c0] : memref<1xi32>
    %101 = memref.load %4[%c0] : memref<1xi32>
    %102 = arith.index_cast %100 : i32 to index
    %103 = arith.index_cast %101 : i32 to index
    scf.for %arg32 = %c0 to %99 step %c1 {
      scf.for %arg33 = %c1 to %102 step %c1 {
        scf.for %arg34 = %c1 to %103 step %c1 {
          %129 = arith.muli %arg33, %103 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %103 overflow<nsw> : index
          %132 = arith.muli %131, %102 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg12[%133] : memref<?xf32>
          %135 = arith.addi %133, %c-1 : index
          %136 = memref.load %arg12[%135] : memref<?xf32>
          %137 = arith.addf %134, %136 : f32
          %138 = arith.mulf %137, %cst_3 : f32
          memref.store %138, %arg29[%133] : memref<?xf32>
          %139 = memref.load %arg12[%133] : memref<?xf32>
          %140 = arith.addi %arg33, %c-1 : index
          %141 = arith.muli %140, %103 overflow<nsw> : index
          %142 = arith.addi %arg34, %141 : index
          %143 = arith.addi %142, %132 : index
          %144 = memref.load %arg12[%143] : memref<?xf32>
          %145 = arith.addf %139, %144 : f32
          %146 = arith.mulf %145, %cst_3 : f32
          memref.store %146, %arg30[%133] : memref<?xf32>
        }
      }
    }
    %104 = memref.load %9[%c0] : memref<1xi32>
    %105 = arith.index_cast %104 : i32 to index
    %106 = memref.get_global @tprni : memref<1xf32>
    %107 = memref.load %3[%c0] : memref<1xi32>
    %108 = memref.load %4[%c0] : memref<1xi32>
    %109 = memref.load %106[%c0] : memref<1xf32>
    %110 = arith.index_cast %107 : i32 to index
    %111 = arith.index_cast %108 : i32 to index
    scf.for %arg32 = %c0 to %105 step %c1 {
      scf.for %arg33 = %c1 to %110 step %c1 {
        scf.for %arg34 = %c1 to %111 step %c1 {
          %129 = arith.muli %arg33, %111 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %111 overflow<nsw> : index
          %132 = arith.muli %131, %110 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg29[%133] : memref<?xf32>
          %135 = arith.negf %134 : f32
          %136 = memref.load %arg18[%130] : memref<?xf32>
          %137 = arith.addi %130, %c-1 : index
          %138 = memref.load %arg18[%137] : memref<?xf32>
          %139 = arith.addf %136, %138 : f32
          %140 = arith.mulf %135, %139 : f32
          %141 = arith.mulf %140, %109 : f32
          %142 = memref.load %arg0[%133] : memref<?xf32>
          %143 = arith.addi %133, %c-1 : index
          %144 = memref.load %arg0[%143] : memref<?xf32>
          %145 = arith.subf %142, %144 : f32
          %146 = arith.mulf %141, %145 : f32
          %147 = memref.load %arg13[%130] : memref<?xf32>
          %148 = arith.mulf %146, %147 : f32
          %149 = memref.load %arg16[%130] : memref<?xf32>
          %150 = memref.load %arg16[%137] : memref<?xf32>
          %151 = arith.addf %149, %150 : f32
          %152 = arith.mulf %148, %151 : f32
          %153 = arith.mulf %152, %cst_3 : f32
          %154 = memref.load %arg15[%130] : memref<?xf32>
          %155 = memref.load %arg15[%137] : memref<?xf32>
          %156 = arith.addf %154, %155 : f32
          %157 = arith.divf %153, %156 : f32
          memref.store %157, %arg4[%133] : memref<?xf32>
          %158 = memref.load %arg30[%133] : memref<?xf32>
          %159 = arith.negf %158 : f32
          %160 = memref.load %arg18[%130] : memref<?xf32>
          %161 = arith.addi %arg33, %c-1 : index
          %162 = arith.muli %161, %111 overflow<nsw> : index
          %163 = arith.addi %arg34, %162 : index
          %164 = memref.load %arg18[%163] : memref<?xf32>
          %165 = arith.addf %160, %164 : f32
          %166 = arith.mulf %159, %165 : f32
          %167 = arith.mulf %166, %109 : f32
          %168 = memref.load %arg0[%133] : memref<?xf32>
          %169 = arith.addi %163, %132 : index
          %170 = memref.load %arg0[%169] : memref<?xf32>
          %171 = arith.subf %168, %170 : f32
          %172 = arith.mulf %167, %171 : f32
          %173 = memref.load %arg14[%130] : memref<?xf32>
          %174 = arith.mulf %172, %173 : f32
          %175 = memref.load %arg15[%130] : memref<?xf32>
          %176 = memref.load %arg15[%163] : memref<?xf32>
          %177 = arith.addf %175, %176 : f32
          %178 = arith.mulf %174, %177 : f32
          %179 = arith.mulf %178, %cst_3 : f32
          %180 = memref.load %arg16[%130] : memref<?xf32>
          %181 = memref.load %arg16[%163] : memref<?xf32>
          %182 = arith.addf %180, %181 : f32
          %183 = arith.divf %179, %182 : f32
          memref.store %183, %arg5[%133] : memref<?xf32>
        }
      }
    }
    %112 = memref.load %0[%c0] : memref<1xi32>
    %113 = arith.index_cast %112 : i32 to index
    %114 = memref.load %3[%c0] : memref<1xi32>
    %115 = memref.load %4[%c0] : memref<1xi32>
    %116 = arith.index_cast %114 : i32 to index
    %117 = arith.index_cast %115 : i32 to index
    scf.for %arg32 = %c0 to %113 step %c1 {
      scf.for %arg33 = %c0 to %116 step %c1 {
        scf.for %arg34 = %c0 to %117 step %c1 {
          %129 = arith.muli %arg33, %117 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %117 overflow<nsw> : index
          %132 = arith.muli %131, %116 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg2[%133] : memref<?xf32>
          %135 = memref.load %arg0[%133] : memref<?xf32>
          %136 = arith.addf %135, %134 : f32
          memref.store %136, %arg0[%133] : memref<?xf32>
        }
      }
    }
    %118 = memref.load %9[%c0] : memref<1xi32>
    %119 = arith.index_cast %118 : i32 to index
    %120 = memref.load %12[%c0] : memref<1xi32>
    %121 = memref.load %21[%c0] : memref<1xi32>
    %122 = memref.load %4[%c0] : memref<1xi32>
    %123 = memref.load %3[%c0] : memref<1xi32>
    %124 = memref.load %47[%c0] : memref<1xf32>
    %125 = arith.index_cast %120 : i32 to index
    %126 = arith.index_cast %121 : i32 to index
    %127 = arith.index_cast %122 : i32 to index
    %128 = arith.index_cast %123 : i32 to index
    scf.for %arg32 = %c0 to %119 step %c1 {
      scf.for %arg33 = %c1 to %125 step %c1 {
        scf.for %arg34 = %c1 to %126 step %c1 {
          %129 = arith.muli %arg33, %127 overflow<nsw> : index
          %130 = arith.addi %arg34, %129 : index
          %131 = arith.muli %arg32, %127 overflow<nsw> : index
          %132 = arith.muli %131, %128 overflow<nsw> : index
          %133 = arith.addi %130, %132 : index
          %134 = memref.load %arg3[%133] : memref<?xf32>
          %135 = arith.addi %133, %c1 : index
          %136 = memref.load %arg4[%135] : memref<?xf32>
          %137 = memref.load %arg4[%133] : memref<?xf32>
          %138 = arith.subf %136, %137 : f32
          %139 = arith.addi %arg33, %c1 : index
          %140 = arith.muli %139, %127 overflow<nsw> : index
          %141 = arith.addi %arg34, %140 : index
          %142 = arith.addi %141, %132 : index
          %143 = memref.load %arg5[%142] : memref<?xf32>
          %144 = arith.addf %138, %143 : f32
          %145 = memref.load %arg5[%133] : memref<?xf32>
          %146 = arith.subf %144, %145 : f32
          %147 = arith.mulf %124, %146 : f32
          %148 = memref.load %arg18[%130] : memref<?xf32>
          %149 = memref.load %arg22[%130] : memref<?xf32>
          %150 = arith.addf %148, %149 : f32
          %151 = memref.load %arg20[%130] : memref<?xf32>
          %152 = arith.mulf %150, %151 : f32
          %153 = arith.divf %147, %152 : f32
          %154 = arith.subf %134, %153 : f32
          memref.store %154, %arg3[%133] : memref<?xf32>
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
          %41 = arith.muli %arg11, %8 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = memref.load %arg5[%42] : memref<?xf32>
          %44 = arith.muli %arg10, %8 overflow<nsw> : index
          %45 = arith.muli %44, %7 overflow<nsw> : index
          %46 = arith.addi %42, %45 : index
          %47 = memref.load %arg3[%46] : memref<?xf32>
          %48 = arith.mulf %47, %43 : f32
          memref.store %48, %arg3[%46] : memref<?xf32>
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
      scf.for %arg11 = %c1 to %17 step %c1 {
        scf.for %arg12 = %c1 to %18 step %c1 {
          %41 = arith.muli %arg11, %18 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = arith.muli %arg10, %18 overflow<nsw> : index
          %44 = arith.muli %43, %19 overflow<nsw> : index
          %45 = arith.addi %42, %44 : index
          %46 = memref.load %arg3[%45] : memref<?xf32>
          %47 = arith.cmpf olt, %46, %cst_2 : f32
          %48 = scf.if %47 -> (i1) {
            scf.yield %true : i1
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.addi %arg12, %c-1 : index
            %52 = arith.index_cast %49 : i32 to index
            %53 = arith.muli %arg11, %52 : index
            %54 = arith.addi %51, %53 : index
            %55 = arith.muli %arg10, %52 : index
            %56 = arith.index_cast %50 : i32 to index
            %57 = arith.muli %55, %56 : index
            %58 = arith.addi %54, %57 : index
            %59 = memref.load %arg3[%58] : memref<?xf32>
            %60 = arith.cmpf olt, %59, %cst_2 : f32
            scf.yield %60 : i1
          }
          scf.if %48 {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            memref.store %cst_0, %arg0[%57] : memref<?xf32>
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg0[%57] : memref<?xf32>
            %59 = arith.extf %58 : f32 to f64
            %60 = math.absf %59 : f64
            %61 = arith.truncf %60 : f64 to f32
            %62 = memref.get_global @dti2 : memref<1xf32>
            %63 = memref.load %62[%c0] : memref<1xf32>
            %64 = arith.mulf %63, %58 : f32
            %65 = arith.mulf %64, %58 : f32
            %66 = arith.mulf %65, %cst : f32
            %67 = memref.load %arg6[%53] : memref<?xf32>
            %68 = arith.addi %arg12, %c-1 : index
            %69 = arith.addi %68, %52 : index
            %70 = memref.load %arg8[%69] : memref<?xf32>
            %71 = memref.load %arg8[%53] : memref<?xf32>
            %72 = arith.addf %70, %71 : f32
            %73 = arith.mulf %67, %72 : f32
            %74 = arith.divf %66, %73 : f32
            %75 = memref.load %arg3[%57] : memref<?xf32>
            %76 = arith.addi %69, %56 : index
            %77 = memref.load %arg3[%76] : memref<?xf32>
            %78 = arith.subf %75, %77 : f32
            %79 = arith.addf %77, %75 : f32
            %80 = arith.addf %79, %cst_1 : f32
            %81 = arith.divf %78, %80 : f32
            %82 = arith.subf %61, %74 : f32
            %83 = arith.mulf %82, %81 : f32
            %84 = arith.mulf %83, %16 : f32
            memref.store %84, %arg0[%57] : memref<?xf32>
            %85 = arith.extf %61 : f32 to f64
            %86 = math.absf %85 : f64
            %87 = arith.extf %74 : f32 to f64
            %88 = math.absf %87 : f64
            %89 = arith.cmpf olt, %86, %88 : f64
            scf.if %89 {
              %90 = memref.load %4[%c0] : memref<1xi32>
              %91 = memref.load %3[%c0] : memref<1xi32>
              %92 = arith.index_cast %90 : i32 to index
              %93 = arith.muli %arg11, %92 : index
              %94 = arith.addi %arg12, %93 : index
              %95 = arith.muli %arg10, %92 : index
              %96 = arith.index_cast %91 : i32 to index
              %97 = arith.muli %95, %96 : index
              %98 = arith.addi %94, %97 : index
              memref.store %cst_0, %arg0[%98] : memref<?xf32>
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
      scf.for %arg11 = %c1 to %27 step %c1 {
        scf.for %arg12 = %c1 to %28 step %c1 {
          %41 = arith.muli %arg11, %29 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = arith.muli %arg10, %29 overflow<nsw> : index
          %44 = arith.muli %43, %27 overflow<nsw> : index
          %45 = arith.addi %42, %44 : index
          %46 = memref.load %arg3[%45] : memref<?xf32>
          %47 = arith.cmpf olt, %46, %cst_2 : f32
          %48 = scf.if %47 -> (i1) {
            scf.yield %true : i1
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.addi %arg11, %c-1 : index
            %52 = arith.index_cast %49 : i32 to index
            %53 = arith.muli %51, %52 : index
            %54 = arith.addi %arg12, %53 : index
            %55 = arith.muli %arg10, %52 : index
            %56 = arith.index_cast %50 : i32 to index
            %57 = arith.muli %55, %56 : index
            %58 = arith.addi %54, %57 : index
            %59 = memref.load %arg3[%58] : memref<?xf32>
            %60 = arith.cmpf olt, %59, %cst_2 : f32
            scf.yield %60 : i1
          }
          scf.if %48 {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            memref.store %cst_0, %arg1[%57] : memref<?xf32>
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg1[%57] : memref<?xf32>
            %59 = arith.extf %58 : f32 to f64
            %60 = math.absf %59 : f64
            %61 = arith.truncf %60 : f64 to f32
            %62 = memref.get_global @dti2 : memref<1xf32>
            %63 = memref.load %62[%c0] : memref<1xf32>
            %64 = arith.mulf %63, %58 : f32
            %65 = arith.mulf %64, %58 : f32
            %66 = arith.mulf %65, %cst : f32
            %67 = memref.load %arg7[%53] : memref<?xf32>
            %68 = arith.addi %arg11, %c-1 : index
            %69 = arith.muli %68, %51 : index
            %70 = arith.addi %arg12, %69 : index
            %71 = memref.load %arg8[%70] : memref<?xf32>
            %72 = memref.load %arg8[%53] : memref<?xf32>
            %73 = arith.addf %71, %72 : f32
            %74 = arith.mulf %67, %73 : f32
            %75 = arith.divf %66, %74 : f32
            %76 = memref.load %arg3[%57] : memref<?xf32>
            %77 = arith.addi %70, %56 : index
            %78 = memref.load %arg3[%77] : memref<?xf32>
            %79 = arith.subf %76, %78 : f32
            %80 = arith.addf %78, %76 : f32
            %81 = arith.addf %80, %cst_1 : f32
            %82 = arith.divf %79, %81 : f32
            %83 = arith.subf %61, %75 : f32
            %84 = arith.mulf %83, %82 : f32
            %85 = arith.mulf %84, %26 : f32
            memref.store %85, %arg1[%57] : memref<?xf32>
            %86 = arith.extf %61 : f32 to f64
            %87 = math.absf %86 : f64
            %88 = arith.extf %75 : f32 to f64
            %89 = math.absf %88 : f64
            %90 = arith.cmpf olt, %87, %89 : f64
            scf.if %90 {
              %91 = memref.load %4[%c0] : memref<1xi32>
              %92 = memref.load %3[%c0] : memref<1xi32>
              %93 = arith.index_cast %91 : i32 to index
              %94 = arith.muli %arg11, %93 : index
              %95 = arith.addi %arg12, %94 : index
              %96 = arith.muli %arg10, %93 : index
              %97 = arith.index_cast %92 : i32 to index
              %98 = arith.muli %96, %97 : index
              %99 = arith.addi %95, %98 : index
              memref.store %cst_0, %arg1[%99] : memref<?xf32>
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
    scf.for %arg10 = %c1 to %31 step %c1 {
      scf.for %arg11 = %c1 to %37 step %c1 {
        scf.for %arg12 = %c1 to %38 step %c1 {
          %41 = arith.muli %arg11, %39 overflow<nsw> : index
          %42 = arith.addi %arg12, %41 : index
          %43 = arith.muli %arg10, %39 overflow<nsw> : index
          %44 = arith.muli %43, %40 overflow<nsw> : index
          %45 = arith.addi %42, %44 : index
          %46 = memref.load %arg3[%45] : memref<?xf32>
          %47 = arith.cmpf olt, %46, %cst_2 : f32
          %48 = scf.if %47 -> (i1) {
            scf.yield %true : i1
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.addi %arg10, %c-1 : index
            %55 = arith.muli %54, %51 : index
            %56 = arith.index_cast %50 : i32 to index
            %57 = arith.muli %55, %56 : index
            %58 = arith.addi %53, %57 : index
            %59 = memref.load %arg3[%58] : memref<?xf32>
            %60 = arith.cmpf olt, %59, %cst_2 : f32
            scf.yield %60 : i1
          }
          scf.if %48 {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            memref.store %cst_0, %arg2[%57] : memref<?xf32>
          } else {
            %49 = memref.load %4[%c0] : memref<1xi32>
            %50 = memref.load %3[%c0] : memref<1xi32>
            %51 = arith.index_cast %49 : i32 to index
            %52 = arith.muli %arg11, %51 : index
            %53 = arith.addi %arg12, %52 : index
            %54 = arith.muli %arg10, %51 : index
            %55 = arith.index_cast %50 : i32 to index
            %56 = arith.muli %54, %55 : index
            %57 = arith.addi %53, %56 : index
            %58 = memref.load %arg2[%57] : memref<?xf32>
            %59 = arith.extf %58 : f32 to f64
            %60 = math.absf %59 : f64
            %61 = arith.truncf %60 : f64 to f32
            %62 = memref.get_global @dti2 : memref<1xf32>
            %63 = memref.load %62[%c0] : memref<1xf32>
            %64 = arith.mulf %63, %58 : f32
            %65 = arith.mulf %64, %58 : f32
            %66 = arith.addi %arg10, %c-1 : index
            %67 = memref.load %arg9[%66] : memref<?xf32>
            %68 = memref.load %arg8[%53] : memref<?xf32>
            %69 = arith.mulf %67, %68 : f32
            %70 = arith.divf %65, %69 : f32
            %71 = arith.muli %66, %51 : index
            %72 = arith.muli %71, %55 : index
            %73 = arith.addi %53, %72 : index
            %74 = memref.load %arg3[%73] : memref<?xf32>
            %75 = memref.load %arg3[%57] : memref<?xf32>
            %76 = arith.subf %74, %75 : f32
            %77 = arith.addf %75, %74 : f32
            %78 = arith.addf %77, %cst_1 : f32
            %79 = arith.divf %76, %78 : f32
            %80 = arith.subf %61, %70 : f32
            %81 = arith.mulf %80, %79 : f32
            %82 = arith.mulf %81, %36 : f32
            memref.store %82, %arg2[%57] : memref<?xf32>
            %83 = arith.extf %61 : f32 to f64
            %84 = math.absf %83 : f64
            %85 = arith.extf %70 : f32 to f64
            %86 = math.absf %85 : f64
            %87 = arith.cmpf olt, %84, %86 : f64
            scf.if %87 {
              %88 = memref.load %4[%c0] : memref<1xi32>
              %89 = memref.load %3[%c0] : memref<1xi32>
              %90 = arith.index_cast %88 : i32 to index
              %91 = arith.muli %arg11, %90 : index
              %92 = arith.addi %arg12, %91 : index
              %93 = arith.muli %arg10, %90 : index
              %94 = arith.index_cast %89 : i32 to index
              %95 = arith.muli %93, %94 : index
              %96 = arith.addi %92, %95 : index
              memref.store %cst_0, %arg2[%96] : memref<?xf32>
            }
          }
        }
      }
    }
    return
  }
}


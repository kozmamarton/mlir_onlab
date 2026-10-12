static ::llvm::LogicalResult IsPowerOfTwoPDLFn(::mlir::PatternRewriter &rewriter, ::mlir::Attribute attr) {
  int64_t value = cast<::mlir::IntegerAttr>(attr).getValue().getSExtValue();
  return success((value & (value - 1)) == 0);
}

namespace {

struct PowerOfTwoExpandRhs : ::mlir::PDLPatternModule {
  template <typename... ConfigsT>
  PowerOfTwoExpandRhs(::mlir::MLIRContext *context, ConfigsT &&...configs)
    : ::mlir::PDLPatternModule(::mlir::parseSourceString<::mlir::ModuleOp>(
R"mlir(pdl.pattern @PowerOfTwoExpandRhs : benefit(2) {
  %0 = operands loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:29)
  %1 = attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:57)
  %2 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:29)
  %3 = operation "arith.constant"(%0 : !pdl.range<value>)  {"value" = %1} -> (%2 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:29)
  %4 = result 0 of %3 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:29)
  %5 = operand loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:71)
  %6 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:14)
  %7 = operation "arith.muli"(%4, %5 : !pdl.value, !pdl.value)  -> (%6 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":15:14)
  apply_native_constraint "IsPowerOfTwo"(%1 : !pdl.attribute) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":16:3)
  %8 = apply_native_constraint "Halve"(%1 : !pdl.attribute) : !pdl.attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":17:22)
  rewrite %7 {
    %9 = operation "arith.constant"  {"value" = %8} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":20:20)
    %10 = result 0 of %9 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":21:33)
    %11 = operation "arith.muli"(%10, %5 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":21:18)
    %12 = result 0 of %11 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":22:33)
    %13 = result 0 of %11 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":22:41)
    %14 = operation "arith.addi"(%12, %13 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":22:18)
    replace %7 with %14 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":23:5)
  } loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":19:3)
} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":14:1)
    )mlir", context), std::forward<ConfigsT>(configs)...) {
    registerConstraintFunction("IsPowerOfTwo", IsPowerOfTwoPDLFn);
  }
};


struct PowerOfTwoExpandLhs : ::mlir::PDLPatternModule {
  template <typename... ConfigsT>
  PowerOfTwoExpandLhs(::mlir::MLIRContext *context, ConfigsT &&...configs)
    : ::mlir::PDLPatternModule(::mlir::parseSourceString<::mlir::ModuleOp>(
R"mlir(pdl.pattern @PowerOfTwoExpandLhs : benefit(2) {
  %0 = operand loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:29)
  %1 = operands loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:41)
  %2 = attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:69)
  %3 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:41)
  %4 = operation "arith.constant"(%1 : !pdl.range<value>)  {"value" = %2} -> (%3 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:41)
  %5 = result 0 of %4 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:41)
  %6 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:14)
  %7 = operation "arith.muli"(%0, %5 : !pdl.value, !pdl.value)  -> (%6 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":28:14)
  apply_native_constraint "IsPowerOfTwo"(%2 : !pdl.attribute) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":29:3)
  %8 = apply_native_constraint "Halve"(%2 : !pdl.attribute) : !pdl.attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":30:22)
  rewrite %7 {
    %9 = operation "arith.constant"  {"value" = %8} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":33:20)
    %10 = result 0 of %9 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":34:38)
    %11 = operation "arith.muli"(%0, %10 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":34:18)
    %12 = result 0 of %11 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":35:33)
    %13 = result 0 of %11 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":35:41)
    %14 = operation "arith.addi"(%12, %13 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":35:18)
    replace %7 with %14 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":36:5)
  } loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":32:3)
} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":27:1)
    )mlir", context), std::forward<ConfigsT>(configs)...) {
    registerConstraintFunction("IsPowerOfTwo", IsPowerOfTwoPDLFn);
  }
};


struct PeelFromMulRhs : ::mlir::PDLPatternModule {
  template <typename... ConfigsT>
  PeelFromMulRhs(::mlir::MLIRContext *context, ConfigsT &&...configs)
    : ::mlir::PDLPatternModule(::mlir::parseSourceString<::mlir::ModuleOp>(
R"mlir(pdl.pattern @PeelFromMulRhs : benefit(1) {
  %0 = operand loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:29)
  %1 = operands loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:41)
  %2 = attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:69)
  %3 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:41)
  %4 = operation "arith.constant"(%1 : !pdl.range<value>)  {"value" = %2} -> (%3 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:41)
  %5 = result 0 of %4 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:41)
  %6 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:14)
  %7 = operation "arith.muli"(%0, %5 : !pdl.value, !pdl.value)  -> (%6 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":42:14)
  %8 = apply_native_constraint "MinusOne"(%2 : !pdl.attribute) : !pdl.attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":47:24)
  rewrite %7 {
    %9 = operation "arith.constant"  {"value" = %8} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":50:20)
    %10 = result 0 of %9 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":51:38)
    %11 = operation "arith.muli"(%0, %10 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":51:18)
    %12 = result 0 of %11 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":52:33)
    %13 = operation "arith.addi"(%12, %0 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":52:18)
    replace %7 with %13 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":53:5)
  } loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":49:3)
} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":41:1)
    )mlir", context), std::forward<ConfigsT>(configs)...) {
  }
};


struct PeelFromMulLhs : ::mlir::PDLPatternModule {
  template <typename... ConfigsT>
  PeelFromMulLhs(::mlir::MLIRContext *context, ConfigsT &&...configs)
    : ::mlir::PDLPatternModule(::mlir::parseSourceString<::mlir::ModuleOp>(
R"mlir(pdl.pattern @PeelFromMulLhs : benefit(1) {
  %0 = operands loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:29)
  %1 = attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:57)
  %2 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:29)
  %3 = operation "arith.constant"(%0 : !pdl.range<value>)  {"value" = %1} -> (%2 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:29)
  %4 = result 0 of %3 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:29)
  %5 = operand loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:71)
  %6 = types loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:14)
  %7 = operation "arith.muli"(%4, %5 : !pdl.value, !pdl.value)  -> (%6 : !pdl.range<type>) loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":58:14)
  %8 = apply_native_constraint "MinusOne"(%1 : !pdl.attribute) : !pdl.attribute loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":59:24)
  rewrite %7 {
    %9 = operation "arith.constant"  {"value" = %8} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":62:20)
    %10 = result 0 of %9 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":63:33)
    %11 = operation "arith.muli"(%10, %5 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":63:18)
    %12 = result 0 of %11 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":64:33)
    %13 = operation "arith.addi"(%12, %5 : !pdl.value, !pdl.value)  loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":64:18)
    replace %7 with %13 loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":65:5)
  } loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":61:3)
} loc("/home/marton/uni/onlab/mlir-tutorial/include/Transform/Arith/MulToAdd.pdll":57:1)
    )mlir", context), std::forward<ConfigsT>(configs)...) {
  }
};

} // end namespace

template <typename... ConfigsT>
[[maybe_unused]] static void populateGeneratedPDLLPatterns(::mlir::RewritePatternSet &patterns, ConfigsT &&...configs) {
  patterns.add<PowerOfTwoExpandRhs>(patterns.getContext(), configs...);
  patterns.add<PowerOfTwoExpandLhs>(patterns.getContext(), configs...);
  patterns.add<PeelFromMulRhs>(patterns.getContext(), configs...);
  patterns.add<PeelFromMulLhs>(patterns.getContext(), configs...);
}

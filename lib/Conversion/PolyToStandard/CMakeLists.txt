add_mlir_library(PolyToStandard
  PolyToStandard.cpp

  ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Conversion/PolyToStandard
  DEPENDS
  PolyToStandardPassIncGen

  LINK_COMPONENTS
  Core

  LINK_LIBS PUBLIC
  MLIRPoly
  MLIRArithDialect
  MLIRFuncDialect
  MLIRFuncTransforms
  MLIRIR
  MLIRPass
  MLIRSCFDialect
  MLIRTensorDialect
  MLIRTransforms
  )

set(LLVM_TARGET_DEFINITIONS ${PROJECT_INCLUDE_DIR}/Conversion/PolyToStandard/PolyToStandard.td)
mlir_tablegen(PolyToStandard.h.inc -gen-pass-decls -name PolyToStandard)
add_dependencies(mlir-headers MLIRPolyOpsIncGen)
add_public_tablegen_target(PolyToStandardPassIncGen)
add_mlir_doc(PolyToStandard PolyToStandard PolyToStandard/ -gen-pass-doc)

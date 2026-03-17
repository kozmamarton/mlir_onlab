add_mlir_pdll_library(MulToAddPdllIncGen
  ${PROJECT_SOURCE_DIR}/include/Transform/Arith/MulToAdd.pdll
  ${PROJECT_SOURCE_DIR}/include/Transform/Arith/MulToAddPdll.h.inc
)

set(LLVM_TARGET_DEFINITIONS  ${PROJECT_SOURCE_DIR}/include/Transform/Arith/Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls -name Arith)
add_public_tablegen_target(MLIRMulToAddPasses)
add_mlir_doc(Passes ArithPasses ./ -gen-pass-doc)

add_mlir_library(MulToAdd
  MulToAdd.cpp
  MulToAddPdll.cpp

  ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Transform/Arith

  DEPENDS
    MLIRMulToAddPasses
    MulToAddPdllIncGen

  LINK_LIBS PUBLIC
)
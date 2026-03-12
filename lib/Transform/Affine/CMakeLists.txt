add_mlir_library(AffineFullUnroll
    AffineFullUnroll.cpp
    AffineFullUnrollPatternRewrite.cpp
    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Transform/Affine/
    DEPENDS
    MLIRAffineFullUnrollPasses

    LINK_LIBS PUBLIC
    MLIRIR
    MLIRPass
    MLIRSupport
    MLIRAffineDialect
    MLIRAffineUtils
)
set(LLVM_TARGET_DEFINITIONS ${PROJECT_SOURCE_DIR}/include/Transform/Affine/Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls -name Affine)
add_public_tablegen_target(MLIRAffineFullUnrollPasses)
add_mlir_doc(Passes AffinePasses ./ -gen-pass-doc)

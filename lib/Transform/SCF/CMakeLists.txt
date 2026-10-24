set(LLVM_TARGET_DEFINITIONS ${PROJECT_SOURCE_DIR}/include/Transform/SCF/Passes.td)
mlir_tablegen(Passes.h.inc -gen-pass-decls -name TutorialSCF)
add_public_tablegen_target(MLIRTutorialSCFPasses)
add_mlir_doc(Passes TutorialSCFPasses ./ -gen-pass-doc)

add_mlir_library(TutorialSCFTransforms
    SinkIntoNestedParallel.cpp

    ADDITIONAL_HEADER_DIRS
    ${PROJECT_SOURCE_DIR}/include/Transform/SCF/

    DEPENDS
    MLIRTutorialSCFPasses

    LINK_LIBS PUBLIC
    MLIRIR
    MLIRPass
    MLIRSupport
    MLIRSCFDialect
    MLIRMemRefDialect
    MLIRSideEffectInterfaces
    MLIRViewLikeInterface
)

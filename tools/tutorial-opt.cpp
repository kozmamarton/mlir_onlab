#include "Transform/Affine/Passes.h"
#include "Transform/Arith/Passes.h"
#include "Transform/SCF/Passes.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllExtensions.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Pass/PassManager.h"
#include "mlir/Pass/PassRegistry.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"

int main(int argc, char **argv) {
  mlir::DialectRegistry registry;
  mlir::registerAllDialects(registry);
  mlir::registerAllExtensions(registry);

  // Upstream passes, so whole pipelines can interleave them with ours.
  mlir::registerAllPasses();
  mlir::tutorial::registerAffinePasses();
  mlir::tutorial::registerArithPasses();
  mlir::tutorial::registerTutorialSCFPasses();
  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Tutorial Pass Driver", registry));
}

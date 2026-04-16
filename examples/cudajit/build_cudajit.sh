export MLIR_LIBDIR="$HOME/.local/shared/lib"
export BUILD_DIR="/absolute/path/to/your/llvm-build-dir"   # set this explicitly

echo "MLIR_LIBDIR=$MLIR_LIBDIR"
echo "BUILD_DIR=$BUILD_DIR"

find "$BUILD_DIR" -type f \( -name "libmlir_cuda_runtime.so*" -o -name "libmlir_runner_utils.so*" -o -name "libmlir_c_runner_utils.so*" \)
find "$MLIR_LIBDIR" -maxdepth 1 -type f \( -name "libmlir_cuda_runtime.so*" -o -name "libmlir_runner_utils.so*" -o -name "libmlir_c_runner_utils.so*" \)

clang++ cudajit.cpp cudajit.ll \
  -I"${CUDA_ROOT}/include" \
  -L"${CUDA_ROOT}/lib64" \
  -Wl,-rpath,"${CUDA_ROOT}/lib64" \
  -L"${MLIR_LIBDIR}" \
  -Wl,-rpath,"${MLIR_LIBDIR}" \
  -lmlir_cuda_runtime -lmlir_runner_utils -lmlir_c_runner_utils \
  -lcudart -lcuda -ldl -lpthread \
  -o result.out

ninja -C "$BUILD_DIR" install

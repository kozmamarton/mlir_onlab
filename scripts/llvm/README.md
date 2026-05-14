# Instructions for the usage of the scripts in this directory
1. Pull the full repository:
    ```bash
    git pull origin main --recurse-submodules
    ```
2. Make a build directory inside llvm repository:
    ```bash
    mkdir -p ../../externals/llvm-project/build/scripts
    ```
3. Copy the scripts from this directory to the llvm build script directory
    ```bash
    cp -r ./*.sh ../../externals/llvm-project/build/scripts
    ```
4. Run the build script that suits your need! No arguments are needed.


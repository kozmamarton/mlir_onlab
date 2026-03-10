module {
  func.func @just_power_of_two(%arg0: i32) -> i32 {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.addi %0, %0 : i32
    %2 = arith.addi %1, %1 : i32
    %3 = arith.addi %2, %2 : i32
    %4 = arith.addi %3, %3 : i32
    %5 = arith.addi %4, %4 : i32
    %6 = arith.addi %5, %arg0 : i32
    %7 = arith.addi %6, %arg0 : i32
    %8 = arith.addi %7, %arg0 : i32
    %9 = arith.addi %8, %arg0 : i32
    %10 = arith.addi %9, %arg0 : i32
    %11 = arith.addi %10, %arg0 : i32
    %12 = arith.addi %11, %arg0 : i32
    %13 = arith.addi %12, %arg0 : i32
    %14 = arith.addi %13, %arg0 : i32
    %15 = arith.addi %14, %arg0 : i32
    %16 = arith.addi %15, %arg0 : i32
    %17 = arith.addi %16, %arg0 : i32
    %18 = arith.addi %17, %arg0 : i32
    %19 = arith.addi %18, %arg0 : i32
    %20 = arith.addi %19, %arg0 : i32
    %21 = arith.addi %20, %arg0 : i32
    %22 = arith.addi %21, %arg0 : i32
    %23 = arith.addi %22, %arg0 : i32
    %24 = arith.addi %23, %arg0 : i32
    %25 = arith.addi %24, %arg0 : i32
    %26 = arith.addi %25, %arg0 : i32
    %27 = arith.addi %26, %arg0 : i32
    %28 = arith.addi %27, %arg0 : i32
    %29 = arith.addi %28, %arg0 : i32
    %30 = arith.addi %29, %arg0 : i32
    %31 = arith.addi %30, %arg0 : i32
    %32 = arith.addi %31, %arg0 : i32
    %33 = arith.addi %32, %arg0 : i32
    %34 = arith.addi %33, %arg0 : i32
    %35 = arith.addi %34, %arg0 : i32
    %36 = arith.addi %35, %arg0 : i32
    %37 = arith.addi %36, %arg0 : i32
    %38 = arith.addi %37, %arg0 : i32
    %39 = arith.addi %38, %arg0 : i32
    %40 = arith.addi %39, %arg0 : i32
    %41 = arith.addi %40, %arg0 : i32
    return %41 : i32
  }
  func.func @power_of_two_plus_one(%arg0: i32) -> i32 {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.addi %0, %0 : i32
    %2 = arith.addi %1, %1 : i32
    %3 = arith.addi %2, %arg0 : i32
    return %3 : i32
  }
}


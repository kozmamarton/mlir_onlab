// RUN: tutorial-opt -pass-pipeline="builtin.module(func.func(sccp))" %s | FileCheck %s

// Note how sscp creates new constants for the computed values,
// though it does not remove the dead code.

// CHECK-LABEL: @test_arith_sccp
// CHECK-NEXT: %[[v0:.*]] = arith.constant 63 : i32
// CHECK-NEXT: %[[v1:.*]] = arith.constant 49 : i32
// CHECK-NEXT: %[[v2:.*]] = arith.constant 14 : i32
// CHECK-NEXT: %[[v3:.*]] = arith.constant 8 : i32
// CHECK-NEXT: %[[v4:.*]] = arith.constant 7 : i32
// CHECK-NEXT: return %[[v2]] : i32
func.func @test_arith_sccp() -> i32 {
  %0 = arith.constant 7 : i32
  %1 = arith.constant 8 : i32
  %2 = arith.addi %0, %0 : i32
  %3 = arith.muli %0, %0 : i32
  %4 = arith.addi %2, %3 : i32
  return %2 : i32
}

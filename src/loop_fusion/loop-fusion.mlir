module {
}

// -----
module {
  func.func @should_fuse_raw_dep_for_locality() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_reduction_to_pointwise() {
    %alloc = memref.alloc() : memref<1xf32>
    %alloc_0 = memref.alloc() : memref<10x10xf32>
    %alloc_1 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        %1 = affine.load %alloc[0] : memref<1xf32>
        %2 = affine.load %alloc_0[%arg0, %arg1] : memref<10x10xf32>
        %3 = arith.addf %1, %2 : f32
        affine.store %3, %alloc[0] : memref<1xf32>
      }
      %0 = affine.load %alloc[0] : memref<1xf32>
      affine.store %0, %alloc_1[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 + 1)>
#map1 = affine_map<(d0, d1) -> (d0 + 1)>
#map2 = affine_map<(d0, d1) -> (d1 + 1)>
module {
  func.func @should_fuse_loop_nests_with_shifts() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 9 {
      %0 = affine.apply #map(%arg0)
      affine.for %arg1 = 0 to 9 {
        %1 = affine.apply #map1(%arg0, %arg1)
        %2 = affine.apply #map2(%arg0, %arg1)
        %3 = affine.apply #map(%arg1)
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_loop_nest() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_across_intermediate_loop_with_no_deps() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_all_loops() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_first_and_second_loops() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc_0[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_not_fuse_would_create_cycle() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %alloc_1 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
      affine.store %cst, %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
      %0 = affine.load %alloc_1[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc_0[%arg0] : memref<10xf32>
      affine.store %cst, %alloc_1[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_producer_consumer() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_and_move_to_preserve_war_dep() {
    %alloc = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_if_top_level_access() {
    %alloc = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    %c4 = arith.constant 4 : index
    %0 = affine.load %alloc[%c4] : memref<10xf32>
    return
  }
}

// -----
module {
  func.func @should_fuse_but_not_remove_src() {
    %alloc = memref.alloc() : memref<100xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 100 {
      affine.store %cst, %alloc[%arg0] : memref<100xf32>
    }
    affine.for %arg0 = 0 to 17 {
    }
    %0 = affine.load %alloc[99] : memref<100xf32>
    return
  }
}

// -----
module {
  func.func @should_fuse_no_top_level_access() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
}

// -----
#set = affine_set<(d0) : (1 == 0)>
module {
  func.func @should_fuse_despite_affine_if() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    %c4 = arith.constant 4 : index
    affine.if #set(%c4) {
    }
    return
  }
}

// -----
#set = affine_set<(d0) : (1 == 0)>
module {
  func.func @should_not_fuse_if_op_in_loop_nest() {
    %alloc = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    %c4 = arith.constant 4 : index
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.if #set(%c4) {
      }
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
#set = affine_set<(d0) : (d0 - 1 >= 0)>
module {
  func.func @should_fuse_if_op_in_loop_nest_not_sandwiched() -> memref<10xf32> {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
      affine.store %cst, %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.if #set(%arg0) {
        %0 = affine.load %alloc_0[%arg0] : memref<10xf32>
      }
    }
    return %alloc : memref<10xf32>
  }
}

// -----
#set = affine_set<(d0) : (d0 - 1 >= 0)>
module {
  func.func @should_not_fuse_if_op_in_loop_nest_between_src_and_dest() -> memref<10xf32> {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.if #set(%arg0) {
        affine.store %cst, %alloc[%arg0] : memref<10xf32>
      }
    }
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
      affine.store %0, %alloc_0[%arg0] : memref<10xf32>
    }
    return %alloc_0 : memref<10xf32>
  }
}

// -----
module {
  func.func @permute_and_fuse() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 30 {
      affine.for %arg1 = 0 to 10 {
        affine.for %arg2 = 0 to 20 {
          "foo"(%cst) : (f32) -> ()
        }
      }
    }
    return
  }
}

// -----
#map = affine_map<(d0, d1) -> (d0 * 4 + d1)>
#map1 = affine_map<(d0) -> (d0 floordiv 4)>
#map2 = affine_map<(d0) -> (d0 mod 4)>
module {
  func.func @fuse_reshape_64_16_4(%arg0: memref<64xf32>) {
    %alloc = memref.alloc() : memref<1x1xf32>
    affine.for %arg1 = 0 to 16 {
      affine.for %arg2 = 0 to 4 {
        %0 = affine.apply #map(%arg1, %arg2)
        %1 = affine.load %arg0[%0] : memref<64xf32>
        %2 = affine.apply #map1(%0)
        %3 = affine.apply #map2(%0)
        affine.store %1, %alloc[0, 0] : memref<1x1xf32>
        %4 = affine.load %alloc[-(%arg2 floordiv 4), (%arg2 floordiv 4) * 4] : memref<1x1xf32>
        "foo"(%4) : (f32) -> ()
      }
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 floordiv 4)>
#map1 = affine_map<(d0) -> (d0 mod 4)>
#map2 = affine_map<(d0, d1) -> (d0 * 4 + d1)>
module {
  func.func @fuse_reshape_16_4_64() {
    %alloc = memref.alloc() : memref<16x4xf32>
    affine.for %arg0 = 0 to 64 {
      %0 = affine.apply #map(%arg0)
      %1 = affine.apply #map1(%arg0)
      %2 = affine.load %alloc[%0, %1] : memref<16x4xf32>
      %3 = affine.apply #map2(%0, %1)
      "foo"(%2) : (f32) -> ()
    }
    return
  }
}

// -----
#map = affine_map<(d0, d1) -> ((d0 * 9 + d1) floordiv 288)>
#map1 = affine_map<(d0, d1) -> (((d0 * 9 + d1) mod 288) floordiv 144)>
#map2 = affine_map<(d0, d1) -> (((d0 * 9 + d1) mod 144) floordiv 48)>
#map3 = affine_map<(d0, d1) -> (((d0 * 9 + d1) mod 48) floordiv 16)>
#map4 = affine_map<(d0, d1) -> ((d0 * 9 + d1) mod 16)>
#map5 = affine_map<(d0, d1) -> (d0 * 9 + d1)>
#map6 = affine_map<(d0) -> (d0 floordiv 288)>
#map7 = affine_map<(d0) -> ((d0 mod 288) floordiv 144)>
#map8 = affine_map<(d0) -> ((d0 mod 144) floordiv 48)>
#map9 = affine_map<(d0) -> ((d0 mod 48) floordiv 16)>
#map10 = affine_map<(d0) -> (d0 mod 16)>
#map11 = affine_map<(d0) -> (0)>
module {
  func.func @R6_to_R2_reshape_square() -> memref<64x9xi32> {
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() : memref<64x9xi32>
    affine.for %arg0 = 0 to 64 {
      affine.for %arg1 = 0 to 9 {
        %0 = affine.apply #map(%arg0, %arg1)
        %1 = affine.apply #map1(%arg0, %arg1)
        %2 = affine.apply #map2(%arg0, %arg1)
        %3 = affine.apply #map3(%arg0, %arg1)
        %4 = affine.apply #map4(%arg0, %arg1)
        %5 = "foo"(%0, %1, %2, %3, %4, %c0) : (index, index, index, index, index, index) -> i32
        %6 = affine.apply #map5(%arg0, %arg1)
        %7 = affine.apply #map6(%6)
        %8 = affine.apply #map7(%6)
        %9 = affine.apply #map8(%6)
        %10 = affine.apply #map9(%6)
        %11 = affine.apply #map10(%6)
        %12 = affine.apply #map11(%6)
        %13 = arith.muli %5, %5 : i32
        affine.store %13, %alloc[%arg0, %arg1] : memref<64x9xi32>
      }
    }
    return %alloc : memref<64x9xi32>
  }
}

// -----
#map = affine_map<(d0) -> (d0 + 5)>
module {
  func.func @fuse_symbolic_bounds(%arg0: index, %arg1: index) {
    %0 = affine.apply #map(%arg1)
    %alloc = memref.alloc(%arg0, %0) : memref<?x?xf32>
    %cst = arith.constant 0.000000e+00 : f32
    %c5 = arith.constant 5 : index
    affine.for %arg2 = 0 to %arg0 {
      affine.for %arg3 = 0 to #map(%arg1) {
        affine.store %cst, %alloc[%arg2, %arg3] : memref<?x?xf32>
      }
    }
    affine.for %arg2 = 0 to %arg0 {
      affine.for %arg3 = 0 to %arg1 {
        %1 = affine.load %alloc[%arg2, %arg3 + symbol(%c5)] : memref<?x?xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_reduction_at_depth_of_one() {
    %alloc = memref.alloc() : memref<1xf32>
    %alloc_0 = memref.alloc() : memref<10x100xf32>
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 100 {
        %0 = affine.load %alloc[0] : memref<1xf32>
        %1 = affine.load %alloc_0[%arg0, %arg1] : memref<10x100xf32>
        %2 = "maxf"(%0, %1) : (f32, f32) -> f32
        affine.store %2, %alloc[0] : memref<1xf32>
      }
      affine.for %arg1 = 0 to 100 {
        %0 = affine.load %alloc[0] : memref<1xf32>
        %1 = affine.load %alloc_0[%arg0, %arg1] : memref<10x100xf32>
        %2 = arith.subf %1, %0 : f32
        affine.store %2, %alloc[0] : memref<1xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_at_src_depth1_and_dst_depth1() {
    %alloc = memref.alloc() : memref<1x16xf32>
    %alloc_0 = memref.alloc() : memref<100x16xf32>
    affine.for %arg0 = 0 to 100 {
      affine.for %arg1 = 0 to 16 {
        %0 = affine.load %alloc_0[%arg0, %arg1] : memref<100x16xf32>
        "op0"(%0) : (f32) -> ()
      }
      affine.for %arg1 = 0 to 16 {
        %0 = "op1"() : () -> f32
        affine.store %0, %alloc[0, %arg1] : memref<1x16xf32>
      }
      affine.for %arg1 = 0 to 16 {
        %0 = affine.load %alloc[0, %arg1] : memref<1x16xf32>
        "op2"(%0) : (f32) -> ()
      }
    }
    return
  }
}

// -----
#map = affine_map<(d0, d1) -> (d0 * 10 + d1)>
module {
  func.func @should_fuse_src_depth1_at_dst_depth2() {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        %0 = affine.apply #map(%arg0, %arg1)
        %1 = affine.apply #map(%arg0, %arg1)
      }
    }
    return
  }
}

// -----
module {
  func.func @fusion_at_depth0_not_currently_supported() {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_deep_loop_nests() {
    %alloc = memref.alloc() : memref<1x1x1x1x16x10xf32, 2>
    %alloc_0 = memref.alloc() : memref<2x2x3x3x16x10xf32, 2>
    %alloc_1 = memref.alloc() : memref<3x3x3x3x16x10xf32, 2>
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c1_2 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 3 {
      affine.for %arg1 = 0 to 3 {
        affine.for %arg2 = 0 to 2 {
          affine.for %arg3 = 0 to 2 {
            affine.for %arg4 = 0 to 3 {
              affine.for %arg5 = 0 to 3 {
                affine.for %arg6 = 0 to 16 {
                  affine.for %arg7 = 0 to 10 {
                    %0 = affine.load %alloc_0[%arg2, %arg3, %arg0, %arg1, %arg6, %arg7] : memref<2x2x3x3x16x10xf32, 2>
                  }
                }
                affine.for %arg6 = 0 to 16 {
                  affine.for %arg7 = 0 to 10 {
                    affine.store %cst, %alloc[0, 0, 0, 0, %arg6, %arg7] : memref<1x1x1x1x16x10xf32, 2>
                  }
                }
                affine.for %arg6 = 0 to 2 {
                  affine.for %arg7 = 0 to 2 {
                    affine.for %arg8 = 0 to 16 {
                      affine.for %arg9 = 0 to 10 {
                        %0 = affine.load %alloc_0[%arg6, %arg7, %arg4, %arg5, %arg8, %arg9] : memref<2x2x3x3x16x10xf32, 2>
                      }
                    }
                    affine.for %arg8 = 0 to 16 {
                      affine.for %arg9 = 0 to 10 {
                        %0 = affine.load %alloc[0, 0, 0, 0, %arg8, %arg9] : memref<1x1x1x1x16x10xf32, 2>
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_at_depth1_and_reduce_slice_trip_count() {
    %alloc = memref.alloc() : memref<1x16xf32>
    %alloc_0 = memref.alloc() : memref<4x256xf32>
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 4 {
      affine.for %arg1 = 0 to 256 {
        %0 = affine.load %alloc_0[%arg0, %arg1] : memref<4x256xf32>
      }
      affine.for %arg1 = 0 to 16 {
        affine.store %cst, %alloc[0, %arg1] : memref<1x16xf32>
      }
      affine.for %arg1 = 0 to 16 {
        %0 = affine.load %alloc[0, %arg1] : memref<1x16xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_at_depth1_with_trip_count_20() {
    %alloc = memref.alloc() : memref<20xf32>
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 5 {
      affine.for %arg1 = 0 to 20 {
        affine.store %cst, %alloc[%arg1] : memref<20xf32>
      }
      affine.for %arg1 = 0 to 10 {
        %0 = affine.load %alloc[%arg1] : memref<20xf32>
      }
      affine.for %arg1 = 0 to 10 {
        affine.for %arg2 = 0 to 20 {
          %0 = affine.load %alloc[%arg2] : memref<20xf32>
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_at_depth1_with_trip_count_19() {
    %alloc = memref.alloc() : memref<19xf32>
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 5 {
      affine.for %arg1 = 0 to 19 {
        affine.store %cst, %alloc[%arg1] : memref<19xf32>
      }
      affine.for %arg1 = 0 to 19 {
        %0 = affine.load %alloc[%arg1] : memref<19xf32>
      }
      affine.for %arg1 = 0 to 10 {
        affine.for %arg2 = 0 to 10 {
          %0 = affine.load %alloc[%arg2] : memref<19xf32>
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_with_private_memref() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 17 {
    }
    affine.for %arg0 = 0 to 82 {
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_live_out_arg_but_preserve_src_loop(%arg0: memref<10xf32>) {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg1 = 0 to 10 {
      affine.store %cst, %arg0[%arg1] : memref<10xf32>
    }
    affine.for %arg1 = 0 to 9 {
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_live_out_arg(%arg0: memref<10xf32>) {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg1 = 0 to 10 {
      affine.store %cst, %arg0[%arg1] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_escaping_memref_but_preserve_src_loop() -> memref<10xf32> {
    %cst = arith.constant 7.000000e+00 : f32
    %alloc = memref.alloc() : memref<10xf32>
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 9 {
    }
    return %alloc : memref<10xf32>
  }
}

// -----
#map = affine_map<(d0, d1) -> ((d0 * 3 + d1) floordiv 48)>
#map1 = affine_map<(d0, d1) -> (d0 * 3 + d1)>
#map2 = affine_map<(d0) -> (d0 floordiv 48)>
module {
  func.func @R3_to_R2_reshape() {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    affine.for %arg0 = 0 to 32 {
      affine.for %arg1 = 0 to 3 {
        %0 = affine.apply #map(%arg0, %arg1)
        %1 = "foo"(%0, %arg1, %c0) : (index, index, index) -> i32
        %2 = affine.apply #map1(%arg0, %arg1)
        %3 = affine.apply #map2(%2)
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_multi_output_producer() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
}

// -----
module {
  func.func @fusion_preventing_deps_on_middle_loop() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %alloc_1 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
      affine.store %0, %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
      %0 = affine.load %alloc_1[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc_0[%arg0] : memref<10xf32>
      affine.store %0, %alloc_1[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_and_move_to_preserve_war_dep() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 3 {
      %0 = affine.load %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
      affine.store %cst, %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 5 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @fusion_preventing_dep_on_constant() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %alloc_1 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc_0[%arg0] : memref<10xf32>
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc_0[%arg0] : memref<10xf32>
    }
    %cst_2 = arith.constant 1.100000e+01 : f32
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
      affine.store %cst_2, %alloc_1[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_and_preserve_dep_on_constant() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    %cst_1 = arith.constant 1.100000e+01 : f32
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
      affine.store %cst_1, %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 + 4)>
module {
  func.func @producer_consumer_with_outmost_user(%arg0: f16) {
    %c0 = arith.constant 0 : index
    %alloc = memref.alloc() : memref<f16, 1>
    %alloc_0 = memref.alloc() : memref<f16>
    %alloc_1 = memref.alloc() : memref<1xi32>
    affine.for %arg1 = 0 to 2 {
      %0 = affine.apply #map(%arg1)
      affine.for %arg2 = 0 to 1 {
        %1 = arith.addf %arg0, %arg0 : f16
        affine.store %1, %alloc[] : memref<f16, 1>
      }
    }
    affine.dma_start %alloc[], %alloc_0[], %alloc_1[%c0], %c0 : memref<f16, 1>, memref<f16>, memref<1xi32>
    return
  }
}


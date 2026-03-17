module {
}

// -----
module {
  func.func @should_fuse_at_depth_above_loop_carried_dependence(%arg0: memref<64x4xf32>, %arg1: memref<64x4xf32>) {
    %alloc = memref.alloc() : memref<64x4xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg2 = 0 to 4 {
      affine.for %arg3 = 0 to 64 {
        affine.store %cst, %alloc[%arg3, %arg2] : memref<64x4xf32>
      }
      affine.for %arg3 = 0 to 4 {
        affine.for %arg4 = 0 to 16 {
          %0 = affine.load %arg1[%arg3 * 16 - %arg4 + 15, %arg2] : memref<64x4xf32>
          "op0"(%0) : (f32) -> ()
        }
        affine.for %arg4 = 0 to 4 {
          affine.for %arg5 = 0 to 16 {
            %0 = affine.load %arg0[%arg4 * 16 - %arg5 + 15, %arg3] : memref<64x4xf32>
            "op1"(%0) : (f32) -> ()
          }
          affine.for %arg5 = 0 to 16 {
            %0 = "op2"() : () -> f32
            %1 = affine.load %alloc[%arg4 * 16 + %arg5, %arg2] : memref<64x4xf32>
            %2 = arith.addf %1, %0 : f32
            affine.store %2, %alloc[%arg4 * 16 + %arg5, %arg2] : memref<64x4xf32>
          }
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_only_two_loops_and_remove_producer() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
      affine.store %cst, %alloc_0[%arg0] : memref<10xf32>
    }
    affine.for %arg0 = 0 to 10 {
      %0 = affine.load %alloc[%arg0] : memref<10xf32>
      affine.store %0, %alloc_0[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_after_one_loop_interchange() {
    %alloc = memref.alloc() : memref<1xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[0] : memref<1xf32>
      affine.for %arg1 = 0 to 5 {
        %0 = affine.load %alloc[0] : memref<1xf32>
        affine.store %0, %alloc[0] : memref<1xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_after_two_loop_interchanges() {
    %alloc = memref.alloc() : memref<1x1xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 6 {
      affine.for %arg1 = 0 to 8 {
        affine.store %cst, %alloc[0, 0] : memref<1x1xf32>
        affine.for %arg2 = 0 to 4 {
          affine.for %arg3 = 0 to 2 {
            %0 = affine.load %alloc[0, 0] : memref<1x1xf32>
            %1 = arith.addf %0, %0 : f32
            affine.store %1, %alloc[0, 0] : memref<1x1xf32>
          }
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_live_out_writer(%arg0: memref<10xf32>) -> memref<10xf32> {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg1 = 0 to 10 {
      affine.store %cst, %arg0[%arg1] : memref<10xf32>
    }
    return %arg0 : memref<10xf32>
  }
}

// -----
#map = affine_map<(d0) -> (d0 * 16)>
#map1 = affine_map<(d0) -> (d0 * 16 + 16)>
module {
  func.func @slice_tile(%arg0: memref<128x8xf32>, %arg1: memref<32x8xf32>, %arg2: f32) -> memref<32x8xf32> {
    affine.for %arg3 = 0 to 2 {
      affine.for %arg4 = 0 to 8 {
        affine.for %arg5 = #map(%arg3) to #map1(%arg3) {
          affine.store %arg2, %arg1[%arg5, %arg4] : memref<32x8xf32>
        }
        affine.for %arg5 = 0 to 8 {
          affine.for %arg6 = 0 to 16 {
            %0 = affine.load %arg0[%arg5 * 16 + %arg6, %arg4] : memref<128x8xf32>
            %1 = "foo"(%0) : (f32) -> f32
          }
          affine.for %arg6 = 0 to 16 {
            %0 = affine.load %arg1[%arg3 * 16 + %arg6, %arg4] : memref<32x8xf32>
            %1 = arith.addf %0, %0 : f32
            affine.store %1, %arg1[%arg3 * 16 + %arg6, %arg4] : memref<32x8xf32>
          }
        }
      }
    }
    return %arg1 : memref<32x8xf32>
  }
}

// -----
#map = affine_map<(d0) -> (d0)>
#map1 = affine_map<(d0, d1) -> (d0 - d1)>
module {
  func.func @test_add_slice_bounds() {
    %alloc = memref.alloc() : memref<10xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    %c0 = arith.constant 0 : index
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        affine.for %arg2 = 0 to 10 {
          %0 = affine.apply #map(%arg0)
          %1 = affine.apply #map(%arg0)
          %2 = affine.apply #map1(%0, %1)
          affine.store %cst, %alloc[%2] : memref<10xf32>
        }
      }
    }
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        affine.for %arg2 = 0 to 10 {
          %0 = affine.load %alloc[%c0] : memref<10xf32>
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_init_loops_siblings_then_shared_producer(%arg0: memref<10x10xf32>, %arg1: memref<10x10xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %cst_1 = arith.constant 7.000000e+00 : f32
    affine.for %arg2 = 0 to 3 {
      affine.for %arg3 = 0 to 3 {
        %0 = arith.mulf %cst_1, %cst : f32
        affine.store %0, %arg0[%arg2, %arg3] : memref<10x10xf32>
        %1 = arith.addf %cst_1, %cst_0 : f32
        affine.store %1, %arg1[%arg2, %arg3] : memref<10x10xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @two_matrix_vector_products() {
    %alloc = memref.alloc() : memref<10x1xf32>
    %alloc_0 = memref.alloc() : memref<10xf32>
    %alloc_1 = memref.alloc() : memref<10xf32>
    %alloc_2 = memref.alloc() : memref<10xf32>
    %alloc_3 = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 0 to 10 {
        affine.store %cst, %alloc[%arg1, 0] : memref<10x1xf32>
      }
      affine.for %arg1 = 0 to 10 {
        %0 = affine.load %alloc[%arg1, 0] : memref<10x1xf32>
        %1 = affine.load %alloc_0[%arg0] : memref<10xf32>
        %2 = arith.mulf %0, %1 : f32
        %3 = affine.load %alloc_2[%arg0] : memref<10xf32>
        %4 = arith.addf %2, %3 : f32
        affine.store %4, %alloc_2[%arg0] : memref<10xf32>
      }
      affine.for %arg1 = 0 to 10 {
        %0 = affine.load %alloc[%arg1, 0] : memref<10x1xf32>
        %1 = affine.load %alloc_1[%arg0] : memref<10xf32>
        %2 = arith.mulf %0, %1 : f32
        %3 = affine.load %alloc_3[%arg0] : memref<10xf32>
        %4 = arith.addf %2, %3 : f32
        affine.store %4, %alloc_3[%arg0] : memref<10xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @should_not_slice_past_slice_barrier() {
    %alloc = memref.alloc() : memref<1x16xf32>
    affine.for %arg0 = 0 to 100 {
      affine.for %arg1 = 0 to 16 {
        %0 = "op1"() : () -> f32
        affine.store %0, %alloc[0, %arg1] : memref<1x16xf32>
      } {slice_fusion_barrier = true}
      affine.for %arg1 = 0 to 16 {
        %0 = affine.load %alloc[0, %arg1] : memref<1x16xf32>
        "op2"(%0) : (f32) -> ()
      }
    }
    return
  }
}

// -----
#map = affine_map<(d0, d1) -> (d0 * 16 + d1)>
module {
  func.func @fuse_across_dim_mismatch(%arg0: memref<4x4x16x1xf32>, %arg1: memref<144x9xf32>, %arg2: memref<9xf32>) {
    %alloc = memref.alloc() : memref<144x4xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg3 = 0 to 9 {
      affine.for %arg4 = 0 to 4 {
        affine.for %arg5 = 0 to 16 {
          %0 = affine.apply #map(%arg3, %arg5)
          affine.store %cst, %alloc[%0, %arg4] : memref<144x4xf32>
        }
      }
    }
    affine.for %arg3 = 0 to 9 {
      affine.for %arg4 = 0 to 9 {
        affine.for %arg5 = 0 to 4 {
          affine.for %arg6 = 0 to 16 {
            %0 = affine.apply #map(%arg3, %arg6)
            %1 = affine.load %alloc[%0, %arg5] : memref<144x4xf32>
          }
        }
      }
    }
    return
  }
}

// -----
#map = affine_map<(d0, d1) -> ((d0 * 72 + d1) floordiv 2304)>
#map1 = affine_map<(d0, d1) -> (((d0 * 72 + d1) mod 2304) floordiv 1152)>
#map2 = affine_map<(d0, d1) -> ((((d0 * 72 + d1) mod 1152) floordiv 9) floordiv 8)>
#map3 = affine_map<(d0, d1) -> ((d1 mod 9) floordiv 3)>
#map4 = affine_map<(d0, d1) -> (d1 mod 3)>
#map5 = affine_map<(d0, d1) -> (d0 * 16 + d1)>
#map6 = affine_map<(d0, d1) -> (d0 * 16 - d1 + 15)>
module {
  func.func @fuse_across_varying_dims_complex(%arg0: f32) {
    %alloc = memref.alloc() : memref<64x1xf32>
    %c0 = arith.constant 0 : index
    %alloc_0 = memref.alloc() : memref<2x2x3x3x16x1xf32>
    %alloc_1 = memref.alloc() : memref<144x4xf32>
    affine.for %arg1 = 0 to 9 {
      affine.for %arg2 = 0 to 64 {
        %0 = affine.apply #map(%arg2, %arg1)
        %1 = affine.apply #map1(%arg2, %arg1)
        %2 = affine.apply #map2(%arg2, %arg1)
        %3 = affine.apply #map3(%arg2, %arg1)
        %4 = affine.apply #map4(%arg2, %arg1)
        %5 = affine.load %alloc_0[%0, %1, %3, %4, %2, %c0] : memref<2x2x3x3x16x1xf32>
        affine.store %5, %alloc[%arg2, 0] : memref<64x1xf32>
      }
      affine.for %arg2 = 0 to 4 {
        affine.for %arg3 = 0 to 16 {
          %0 = affine.apply #map5(%arg2, %arg3)
          %1 = affine.load %alloc[%arg2 * 16 + %arg3, 0] : memref<64x1xf32>
        }
        affine.for %arg3 = 0 to 16 {
          %0 = affine.apply #map5(%arg1, %arg3)
          affine.store %arg0, %alloc_1[%0, %arg2] : memref<144x4xf32>
        }
      }
      affine.for %arg2 = 0 to 9 {
        affine.for %arg3 = 0 to 4 {
          affine.for %arg4 = 0 to 16 {
            %0 = affine.apply #map6(%arg3, %arg4)
            %1 = affine.load %alloc[%arg3 * 16 - %arg4 + 15, 0] : memref<64x1xf32>
          }
        }
      }
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 + 10)>
#map1 = affine_map<(d0) -> (d0 + 15)>
module {
  func.func @should_fuse_with_slice_union() {
    %alloc = memref.alloc() : memref<15xf32>
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.for %arg1 = 10 to 25 {
        affine.store %cst, %alloc[%arg1 - 10] : memref<15xf32>
      }
      %0 = affine.apply #map(%arg0)
      %1 = affine.load %alloc[%arg0] : memref<15xf32>
      affine.for %arg1 = 0 to 10 {
        %2 = affine.apply #map1(%arg1)
        %3 = affine.load %alloc[%arg1 + 5] : memref<15xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @affine_add_mm_fused(%arg0: memref<1024x1024xf32>, %arg1: memref<1024x1024xf32>, %arg2: memref<1024x1024xf32>, %arg3: memref<1024x1024xf32>) {
    affine.for %arg4 = 0 to 1024 {
      affine.for %arg5 = 0 to 1024 {
        %0 = affine.load %arg3[%arg4, %arg5] : memref<1024x1024xf32>
        %1 = affine.load %arg2[%arg4, %arg5] : memref<1024x1024xf32>
        %2 = arith.addf %1, %0 : f32
        affine.store %2, %arg2[%arg4, %arg5] : memref<1024x1024xf32>
        affine.for %arg6 = 0 to 1024 {
          %3 = affine.load %arg1[%arg6, %arg5] : memref<1024x1024xf32>
          %4 = affine.load %arg0[%arg4, %arg6] : memref<1024x1024xf32>
          %5 = arith.mulf %4, %3 : f32
          %6 = affine.load %arg2[%arg4, %arg5] : memref<1024x1024xf32>
          %7 = arith.addf %6, %5 : f32
          affine.store %7, %arg2[%arg4, %arg5] : memref<1024x1024xf32>
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @affine_2mm_fused(%arg0: memref<1024x1024xf32>, %arg1: memref<1024x1024xf32>, %arg2: memref<1024x1024xf32>, %arg3: memref<1024x1024xf32>, %arg4: memref<1024x1024xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg5 = 0 to 1024 {
      affine.for %arg6 = 0 to 1024 {
        affine.store %cst, %arg2[%arg5, %arg6] : memref<1024x1024xf32>
        affine.for %arg7 = 0 to 1024 {
          %0 = affine.load %arg1[%arg7, %arg6] : memref<1024x1024xf32>
          %1 = affine.load %arg0[%arg5, %arg7] : memref<1024x1024xf32>
          %2 = arith.mulf %1, %0 : f32
          %3 = affine.load %arg2[%arg5, %arg6] : memref<1024x1024xf32>
          %4 = arith.addf %3, %2 : f32
          affine.store %4, %arg2[%arg5, %arg6] : memref<1024x1024xf32>
        }
      }
      affine.for %arg6 = 0 to 1024 {
        affine.store %cst, %arg4[%arg5, %arg6] : memref<1024x1024xf32>
        affine.for %arg7 = 0 to 1024 {
          %0 = affine.load %arg1[%arg7, %arg6] : memref<1024x1024xf32>
          %1 = affine.load %arg0[%arg5, %arg7] : memref<1024x1024xf32>
          %2 = arith.mulf %1, %0 : f32
          %3 = affine.load %arg4[%arg5, %arg6] : memref<1024x1024xf32>
          %4 = arith.addf %3, %2 : f32
          affine.store %4, %arg4[%arg5, %arg6] : memref<1024x1024xf32>
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @affine_2_dependent_mm_fused(%arg0: memref<1024x1024xf32>, %arg1: memref<1024x1024xf32>, %arg2: memref<1024x1024xf32>, %arg3: memref<1024x1024xf32>, %arg4: memref<1024x1024xf32>) {
    affine.for %arg5 = 0 to 1024 {
      affine.for %arg6 = 0 to 1024 {
        affine.for %arg7 = 0 to 1024 {
          %0 = affine.load %arg1[%arg7, %arg6] : memref<1024x1024xf32>
          %1 = affine.load %arg0[%arg5, %arg7] : memref<1024x1024xf32>
          %2 = arith.mulf %1, %0 : f32
          %3 = affine.load %arg2[%arg5, %arg6] : memref<1024x1024xf32>
          %4 = arith.addf %3, %2 : f32
          affine.store %4, %arg2[%arg5, %arg6] : memref<1024x1024xf32>
        }
      }
      affine.for %arg6 = 0 to 1024 {
        affine.for %arg7 = 0 to 1024 {
          %0 = affine.load %arg3[%arg7, %arg6] : memref<1024x1024xf32>
          %1 = affine.load %arg2[%arg5, %arg7] : memref<1024x1024xf32>
          %2 = arith.mulf %1, %0 : f32
          %3 = affine.load %arg4[%arg5, %arg6] : memref<1024x1024xf32>
          %4 = arith.addf %3, %2 : f32
          affine.store %4, %arg4[%arg5, %arg6] : memref<1024x1024xf32>
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_self_dependence_multi_store_producer() {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_dead_multi_store_producer() {
    %alloc = memref.alloc() : memref<10xf32>
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %alloc[%arg0] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_function_live_out_multi_store_producer(%arg0: memref<10xf32>) {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg1 = 0 to 10 {
      affine.store %cst, %arg0[%arg1] : memref<10xf32>
    }
    return
  }
}


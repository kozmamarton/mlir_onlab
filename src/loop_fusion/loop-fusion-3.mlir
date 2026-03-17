module {
}

// -----
module {
  func.func @mul_add_0(%arg0: memref<3x4xf32>, %arg1: memref<4x3xf32>, %arg2: memref<3x3xf32>, %arg3: memref<3x3xf32>) {
    %alloc = memref.alloc() : memref<1x1xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg4 = 0 to 3 {
      affine.for %arg5 = 0 to 3 {
        affine.store %cst, %alloc[0, 0] : memref<1x1xf32>
        affine.for %arg6 = 0 to 4 {
          %3 = affine.load %arg1[%arg6, %arg5] : memref<4x3xf32>
          %4 = affine.load %arg0[%arg4, %arg6] : memref<3x4xf32>
          %5 = arith.mulf %4, %3 : f32
          %6 = affine.load %alloc[0, 0] : memref<1x1xf32>
          %7 = arith.addf %6, %5 : f32
          affine.store %7, %alloc[0, 0] : memref<1x1xf32>
        }
        %0 = affine.load %arg2[%arg4, %arg5] : memref<3x3xf32>
        %1 = affine.load %alloc[0, 0] : memref<1x1xf32>
        %2 = arith.addf %1, %0 : f32
        affine.store %2, %arg3[%arg4, %arg5] : memref<3x3xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_multi_outgoing_edge_store_producer(%arg0: memref<1xf32>) {
    %c0 = arith.constant 0 : index
    %c0_0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg1 = 0 to 1 {
      affine.store %cst, %arg0[%c0] : memref<1xf32>
      %0 = affine.load %arg0[%arg1] : memref<1xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_producer_with_multi_outgoing_edges(%arg0: memref<1xf32>, %arg1: memref<1xf32>) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg2 = 0 to 1 {
      %0 = affine.load %arg0[%c0] : memref<1xf32>
      affine.store %cst, %arg1[%c0] : memref<1xf32>
      affine.store %cst, %arg0[%arg2] : memref<1xf32>
      %1 = affine.load %arg1[%arg2] : memref<1xf32>
    }
    return
  }
  func.func @reshape_into_matmul(%arg0: memref<1024x1024xf32>, %arg1: memref<16x64x1024xf32>, %arg2: memref<1024x1024xf32>) {
    %alloc = memref.alloc() : memref<1024x1024xf32>
    affine.for %arg3 = 0 to 16 {
      affine.for %arg4 = 0 to 64 {
        affine.for %arg5 = 0 to 1024 {
          %0 = affine.load %arg1[%arg3, %arg4, %arg5] : memref<16x64x1024xf32>
          affine.store %0, %alloc[%arg3 * 64 + %arg4, %arg5] : memref<1024x1024xf32>
        }
      }
    }
    affine.for %arg3 = 0 to 1024 {
      affine.for %arg4 = 0 to 1024 {
        affine.for %arg5 = 0 to 1024 {
          %0 = affine.load %alloc[%arg5, %arg4] : memref<1024x1024xf32>
          %1 = affine.load %arg0[%arg3, %arg5] : memref<1024x1024xf32>
          %2 = arith.mulf %1, %0 : f32
          %3 = affine.load %arg2[%arg3, %arg4] : memref<1024x1024xf32>
          %4 = arith.addf %3, %2 : f32
          affine.store %4, %arg2[%arg3, %arg4] : memref<1024x1024xf32>
        }
      }
    }
    return
  }
}

// -----
module {
  func.func @vector_loop(%arg0: memref<10x20xf32>, %arg1: memref<10x20xf32>, %arg2: memref<10x20xf32>) {
    affine.for %arg3 = 0 to 10 {
      affine.for %arg4 = 0 to 5 {
        %0 = affine.vector_load %arg0[%arg3, %arg4 * 4] : memref<10x20xf32>, vector<4xf32>
        affine.vector_store %0, %arg1[%arg3, %arg4 * 4] : memref<10x20xf32>, vector<4xf32>
        affine.vector_store %0, %arg2[%arg3, %arg4 * 4] : memref<10x20xf32>, vector<4xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @multi_outgoing_edges(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
      %3 = affine.load %arg1[%arg2] : memref<32xf32>
      %4 = arith.subf %2, %3 : f32
      affine.store %4, %arg0[%arg2] : memref<32xf32>
      %5 = affine.load %arg1[%arg2] : memref<32xf32>
      %6 = arith.mulf %4, %5 : f32
      affine.store %6, %arg0[%arg2] : memref<32xf32>
      %7 = affine.load %arg1[%arg2] : memref<32xf32>
      %8 = arith.divf %6, %7 : f32
      affine.store %8, %arg0[%arg2] : memref<32xf32>
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 + 1)>
module {
  func.func @calc(%arg0: memref<?xf32>, %arg1: memref<?xf32>, %arg2: memref<?xf32>, %arg3: index) {
    %c1 = arith.constant 1 : index
    affine.for %arg4 = 0 to 9 {
      %0 = affine.apply #map(%arg4)
      %1 = affine.load %arg0[%0] : memref<?xf32>
      %2 = affine.load %arg1[%0] : memref<?xf32>
      %3 = arith.addf %1, %2 : f32
      %4 = affine.apply #map(%arg4)
      %5 = arith.mulf %3, %2 : f32
      affine.store %5, %arg2[%4] : memref<?xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_not_fuse_since_non_affine_users(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %0 = memref.load %arg0[%arg2] : memref<32xf32>
      %1 = memref.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.subf %0, %1 : f32
      memref.store %2, %arg0[%arg2] : memref<32xf32>
    }
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.mulf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_not_fuse_since_top_level_non_affine_users(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    %alloc = memref.alloc() : memref<f32>
    affine.for %arg2 = 0 to 32 {
      %1 = affine.load %arg0[%arg2] : memref<32xf32>
      %2 = affine.load %arg1[%arg2] : memref<32xf32>
      %3 = arith.addf %1, %2 : f32
      memref.store %3, %alloc[] : memref<f32>
      affine.store %3, %arg0[%arg2] : memref<32xf32>
    }
    %0 = memref.load %alloc[] : memref<f32>
    affine.for %arg2 = 0 to 32 {
      %1 = affine.load %arg0[%arg2] : memref<32xf32>
      %2 = affine.load %arg1[%arg2] : memref<32xf32>
      %3 = arith.mulf %1, %2 : f32
      %4 = arith.subf %3, %0 : f32
      affine.store %4, %arg0[%arg2] : memref<32xf32>
    }
    memref.dealloc %alloc : memref<f32>
    return
  }
}

// -----
module {
  func.func @should_not_fuse_since_top_level_non_affine_mem_write_users(%arg0: memref<32xf32>, %arg1: memref<32xf32>) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    memref.store %cst, %arg0[%c0] : memref<32xf32>
    affine.for %arg2 = 0 to 32 {
      %0 = affine.load %arg0[%arg2] : memref<32xf32>
      %1 = affine.load %arg1[%arg2] : memref<32xf32>
      %2 = arith.addf %0, %1 : f32
      affine.store %2, %arg0[%arg2] : memref<32xf32>
    }
    return
  }
  func.func @fuse_non_affine_intervening_op() {
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<100xf32>
    %alloc_0 = memref.alloc() : memref<100xf32>
    affine.for %arg0 = 0 to 100 {
      affine.store %cst, %alloc_0[%arg0] : memref<100xf32>
      affine.store %cst, %alloc[%arg0] : memref<100xf32>
    }
    memref.dealloc %alloc_0 : memref<100xf32>
    return
  }
  func.func @fuse_non_affine_intervening_read() {
    %cst = arith.constant 0.000000e+00 : f32
    %alloc = memref.alloc() : memref<100xf32>
    %alloc_0 = memref.alloc() : memref<100xf32>
    %alloc_1 = memref.alloc() : memref<100xf32>
    affine.for %arg0 = 0 to 100 {
      affine.store %cst, %alloc[%arg0] : memref<100xf32>
      affine.store %cst, %alloc_0[%arg0] : memref<100xf32>
    }
    affine.for %arg0 = 0 to 100 {
      %0 = memref.load %alloc[%arg0] : memref<100xf32>
    }
    return
  }
  func.func @fuse_non_affine_intervening_read_nest() {
    %cst = arith.constant 0.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c100 = arith.constant 100 : index
    %alloc = memref.alloc() : memref<100xf32>
    %alloc_0 = memref.alloc() : memref<100xf32>
    %alloc_1 = memref.alloc() : memref<100xf32>
    affine.for %arg0 = 0 to 100 {
      affine.store %cst, %alloc[%arg0] : memref<100xf32>
      affine.store %cst, %alloc_0[%arg0] : memref<100xf32>
    }
    scf.for %arg0 = %c0 to %c100 step %c1 {
      %0 = memref.load %alloc[%arg0] : memref<100xf32>
    }
    return
  }
  func.func @no_fusion_scf_for_store() {
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c100 = arith.constant 100 : index
    %alloc = memref.alloc() : memref<100xf32>
    %alloc_1 = memref.alloc() : memref<100xf32>
    %alloc_2 = memref.alloc() : memref<100xf32>
    affine.for %arg0 = 0 to 100 {
      affine.store %cst, %alloc[%arg0] : memref<100xf32>
    }
    scf.for %arg0 = %c0 to %c100 step %c1 {
      memref.store %cst_0, %alloc[%arg0] : memref<100xf32>
    }
    affine.for %arg0 = 0 to 100 {
      %0 = affine.load %alloc[%arg0] : memref<100xf32>
      affine.store %0, %alloc_1[%arg0] : memref<100xf32>
    }
    return
  }
}

// -----
module {
  func.func @fuse_minor_affine_map(%arg0: memref<128xf32>, %arg1: memref<20x512xf32>) {
    %alloc = memref.alloc() : memref<128xf32>
    affine.for %arg2 = 0 to 20 {
      affine.for %arg3 = 0 to 128 {
        %0 = affine.load %arg0[%arg3] : memref<128xf32>
        affine.store %0, %alloc[%arg3] : memref<128xf32>
      }
      affine.for %arg3 = 0 to 512 {
        %0 = affine.load %alloc[%arg3 mod 128] : memref<128xf32>
        affine.store %0, %arg1[%arg2, %arg3] : memref<20x512xf32>
      }
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_multi_store_producer_and_privatize_memfefs() {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 10 {
    }
    return
  }
  func.func @should_fuse_multi_store_producer_with_escaping_memrefs_and_remove_src(%arg0: memref<10xf32>, %arg1: memref<10xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg2 = 0 to 10 {
      affine.store %cst, %arg0[%arg2] : memref<10xf32>
      affine.store %cst, %arg1[%arg2] : memref<10xf32>
      %0 = affine.load %arg0[%arg2] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func @should_fuse_multi_store_producer_with_escaping_memrefs_and_preserve_src(%arg0: memref<10xf32>, %arg1: memref<10xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg2 = 0 to 10 {
      affine.store %cst, %arg0[%arg2] : memref<10xf32>
      affine.store %cst, %arg1[%arg2] : memref<10xf32>
    }
    affine.for %arg2 = 0 to 5 {
      affine.store %cst, %arg1[%arg2] : memref<10xf32>
    }
    return
  }
  func.func @should_not_fuse_due_to_dealloc(%arg0: memref<16xf32>) {
    %alloc = memref.alloc() : memref<16xf32>
    %alloc_0 = memref.alloc() : memref<16xf32>
    %cst = arith.constant 1.000000e+00 : f32
    affine.for %arg1 = 0 to 16 {
      %0 = affine.load %arg0[%arg1] : memref<16xf32>
      affine.store %0, %alloc[%arg1] : memref<16xf32>
      affine.store %0, %alloc_0[%arg1] : memref<16xf32>
    }
    memref.dealloc %alloc_0 : memref<16xf32>
    %alloc_1 = memref.alloc() : memref<16xf32>
    affine.for %arg1 = 0 to 16 {
      %0 = affine.load %alloc[%arg1] : memref<16xf32>
      %1 = arith.addf %cst, %0 : f32
      affine.store %1, %alloc_1[%arg1] : memref<16xf32>
    }
    memref.dealloc %alloc : memref<16xf32>
    return
  }
  func.func @cannot_fuse_intervening_deallocs(%arg0: memref<16xf32>) {
    %alloc = memref.alloc() : memref<16xf32>
    %alloc_0 = memref.alloc() : memref<16xf32>
    %cst = arith.constant 1.000000e+00 : f32
    affine.for %arg1 = 0 to 16 {
      %0 = affine.load %arg0[%arg1] : memref<16xf32>
      affine.store %0, %alloc[%arg1] : memref<16xf32>
      affine.store %0, %alloc_0[%arg1] : memref<16xf32>
    }
    memref.dealloc %alloc_0 : memref<16xf32>
    %alloc_1 = memref.alloc() : memref<16xf32>
    affine.for %arg1 = 0 to 16 {
      %0 = affine.load %alloc[%arg1] : memref<16xf32>
      %1 = arith.addf %cst, %0 : f32
      affine.store %1, %alloc_1[%arg1] : memref<16xf32>
    }
    memref.dealloc %alloc : memref<16xf32>
    return
  }
}

// -----
module {
  func.func @should_fuse_defining_node_has_no_dependence_from_source_node(%arg0: memref<10xf32>, %arg1: memref<f32>) {
    %0 = affine.load %arg1[] : memref<f32>
    affine.for %arg2 = 0 to 10 {
      %1 = affine.load %arg1[] : memref<f32>
      affine.store %1, %arg0[%arg2] : memref<10xf32>
      %2 = arith.divf %0, %1 : f32
    }
    return
  }
}

// -----
module {
  func.func @should_not_fuse_defining_node_has_dependence_from_source_loop(%arg0: memref<10xf32>, %arg1: memref<f32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg2 = 0 to 10 {
      affine.store %cst, %arg1[] : memref<f32>
      affine.store %cst, %arg0[%arg2] : memref<10xf32>
    }
    %0 = affine.load %arg1[] : memref<f32>
    affine.for %arg2 = 0 to 10 {
      %1 = affine.load %arg0[%arg2] : memref<10xf32>
      %2 = arith.divf %0, %1 : f32
    }
    return
  }
}

// -----
module {
  func.func @should_not_fuse_defining_node_has_transitive_dependence_from_source_loop(%arg0: memref<10xf32>, %arg1: memref<10xf32>, %arg2: memref<f32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg3 = 0 to 10 {
      affine.store %cst, %arg0[%arg3] : memref<10xf32>
      affine.store %cst, %arg1[%arg3] : memref<10xf32>
      affine.store %cst, %arg2[] : memref<f32>
    }
    %0 = affine.load %arg2[] : memref<f32>
    affine.for %arg3 = 0 to 10 {
      %1 = affine.load %arg0[%arg3] : memref<10xf32>
      %2 = arith.divf %0, %1 : f32
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 * 2)>
module {
  func.func @should_not_fuse_dest_loop_nest_return_value(%arg0: memref<10xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg1 = 0 to 10 {
      affine.store %cst, %arg0[%arg1] : memref<10xf32>
    }
    %0 = affine.for %arg1 = 0 to 5 iter_args(%arg2 = %cst) -> (f32) {
      %1 = affine.apply #map(%arg1)
      %2 = affine.load %arg0[%1] : memref<10xf32>
      affine.yield %2 : f32
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 * 2)>
module {
  func.func @should_not_fuse_src_loop_nest_return_value(%arg0: memref<10xf32>) {
    %cst = arith.constant 1.000000e+00 : f32
    %0 = affine.for %arg1 = 0 to 5 iter_args(%arg2 = %cst) -> (f32) {
      %1 = affine.apply #map(%arg1)
      %2 = arith.addf %arg2, %arg2 : f32
      affine.store %2, %arg0[%1] : memref<10xf32>
      affine.yield %2 : f32
    }
    affine.for %arg1 = 0 to 10 {
      %1 = affine.load %arg0[%arg1] : memref<10xf32>
    }
    return
  }
}

// -----
module {
  func.func private @some_function(memref<16xf32>)
  func.func @call_op_prevents_fusion(%arg0: memref<16xf32>) {
    %alloc = memref.alloc() : memref<16xf32>
    %cst = arith.constant 1.000000e+00 : f32
    affine.for %arg1 = 0 to 16 {
      %0 = affine.load %arg0[%arg1] : memref<16xf32>
      affine.store %0, %alloc[%arg1] : memref<16xf32>
    }
    call @some_function(%alloc) : (memref<16xf32>) -> ()
    %alloc_0 = memref.alloc() : memref<16xf32>
    affine.for %arg1 = 0 to 16 {
      %0 = affine.load %alloc[%arg1] : memref<16xf32>
      %1 = arith.addf %cst, %0 : f32
      affine.store %1, %alloc_0[%arg1] : memref<16xf32>
    }
    return
  }
}

// -----
module {
  func.func private @some_function()
  func.func @call_op_does_not_prevent_fusion(%arg0: memref<16xf32>) {
    %cst = arith.constant 1.000000e+00 : f32
    call @some_function() : () -> ()
    %alloc = memref.alloc() : memref<16xf32>
    affine.for %arg1 = 0 to 16 {
      %0 = affine.load %arg0[%arg1] : memref<16xf32>
      %1 = arith.addf %cst, %0 : f32
      affine.store %1, %alloc[%arg1] : memref<16xf32>
    }
    return
  }
}

// -----
#map = affine_map<(d0) -> (d0 + 5)>
module {
  func.func @should_fuse_with_both_consumers_separately(%arg0: memref<10xf32>) {
    %cst = arith.constant 7.000000e+00 : f32
    affine.for %arg1 = 0 to 10 {
      affine.store %cst, %arg0[%arg1] : memref<10xf32>
    }
    affine.for %arg1 = 0 to 4 {
      %0 = affine.apply #map(%arg1)
      %1 = affine.apply #map(%arg1)
    }
    affine.for %arg1 = 0 to 7 {
    }
    return
  }
}

// -----
module {
  func.func @no_fusion_cannot_compute_valid_slice() {
    %alloc = memref.alloc() : memref<5xf32>
    %alloc_0 = memref.alloc() : memref<6xf32>
    %alloc_1 = memref.alloc() : memref<5xf32>
    %cst = arith.constant 0.000000e+00 : f32
    affine.for %arg0 = 0 to 5 {
      %0 = affine.load %alloc[%arg0] : memref<5xf32>
      affine.store %0, %alloc_0[%arg0 + 1] : memref<6xf32>
    }
    affine.for %arg0 = 0 to 5 {
      %0 = affine.load %alloc_0[%arg0] : memref<6xf32>
      %1 = arith.mulf %0, %cst : f32
      affine.store %1, %alloc_1[%arg0] : memref<5xf32>
    }
    return
  }
  func.func @reduce_add_f32_f32(%arg0: memref<64x64xf32, 1>, %arg1: memref<1x64xf32, 1>, %arg2: memref<1x64xf32, 1>) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %alloca = memref.alloca() : memref<f32, 1>
    %alloca_1 = memref.alloca() : memref<f32, 1>
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 64 {
        %0 = affine.for %arg5 = 0 to 64 iter_args(%arg6 = %cst) -> (f32) {
          %4 = affine.load %arg0[%arg5, %arg4] : memref<64x64xf32, 1>
          %5 = arith.addf %arg6, %4 : f32
          affine.yield %5 : f32
        }
        %1 = arith.addf %0, %0 : f32
        affine.store %1, %arg1[%c0, %arg4] : memref<1x64xf32, 1>
        %2 = affine.for %arg5 = 0 to 64 iter_args(%arg6 = %cst_0) -> (f32) {
          %4 = affine.load %arg0[%arg5, %arg4] : memref<64x64xf32, 1>
          %5 = arith.mulf %arg6, %4 : f32
          affine.yield %5 : f32
        }
        %3 = arith.mulf %2, %2 : f32
        affine.store %3, %arg2[%arg3, %arg4] : memref<1x64xf32, 1>
      }
    }
    return
  }
}

// -----
module {
  func.func @reduce_add_non_innermost(%arg0: memref<64x64xf32, 1>, %arg1: memref<1x64xf32, 1>, %arg2: memref<1x64xf32, 1>) {
    %c0 = arith.constant 0 : index
    %cst = arith.constant 0.000000e+00 : f32
    %cst_0 = arith.constant 1.000000e+00 : f32
    %alloca = memref.alloca() : memref<f32, 1>
    %alloca_1 = memref.alloca() : memref<f32, 1>
    affine.for %arg3 = 0 to 1 {
      affine.for %arg4 = 0 to 64 {
        %0 = affine.for %arg5 = 0 to 64 iter_args(%arg6 = %cst) -> (f32) {
          %4 = affine.load %arg0[%arg5, %arg4] : memref<64x64xf32, 1>
          %5 = arith.addf %arg6, %4 : f32
          affine.yield %5 : f32
        }
        %1 = arith.addf %0, %0 : f32
        affine.store %1, %arg1[%c0, %arg4] : memref<1x64xf32, 1>
        %2 = affine.for %arg5 = 0 to 64 iter_args(%arg6 = %cst_0) -> (f32) {
          %4 = affine.load %arg0[%arg5, %arg4] : memref<64x64xf32, 1>
          %5 = arith.mulf %arg6, %4 : f32
          affine.yield %5 : f32
        }
        %3 = arith.mulf %2, %2 : f32
        affine.store %3, %arg2[%arg3, %arg4] : memref<1x64xf32, 1>
      }
    }
    return
  }
}

// -----
module {
  func.func @fuse_large_number_of_loops(%arg0: memref<20x10xf32, 1>, %arg1: memref<20x10xf32, 1>, %arg2: memref<20x10xf32, 1>, %arg3: memref<20x10xf32, 1>, %arg4: memref<20x10xf32, 1>, %arg5: memref<f32, 1>, %arg6: memref<f32, 1>, %arg7: memref<f32, 1>, %arg8: memref<f32, 1>, %arg9: memref<20x10xf32, 1>, %arg10: memref<20x10xf32, 1>, %arg11: memref<20x10xf32, 1>, %arg12: memref<20x10xf32, 1>) {
    %cst = arith.constant 1.000000e+00 : f32
    %0 = affine.load %arg6[] : memref<f32, 1>
    %1 = arith.subf %cst, %0 : f32
    affine.for %arg13 = 0 to 20 {
      affine.for %arg14 = 0 to 10 {
        %2 = affine.load %arg6[] : memref<f32, 1>
        %3 = affine.load %arg1[%arg13, %arg14] : memref<20x10xf32, 1>
        %4 = arith.mulf %1, %3 : f32
        %5 = affine.load %arg2[%arg13, %arg14] : memref<20x10xf32, 1>
        %6 = arith.mulf %5, %2 : f32
        %7 = affine.load %arg3[%arg13, %arg14] : memref<20x10xf32, 1>
        %8 = arith.mulf %7, %2 : f32
        %9 = arith.mulf %4, %3 : f32
        %10 = arith.addf %6, %4 : f32
        affine.store %10, %arg10[%arg13, %arg14] : memref<20x10xf32, 1>
        %11 = arith.addf %8, %9 : f32
        affine.store %11, %arg11[%arg13, %arg14] : memref<20x10xf32, 1>
        %12 = affine.load %arg10[%arg13, %arg14] : memref<20x10xf32, 1>
        %13 = arith.mulf %12, %12 : f32
        %14 = arith.subf %11, %13 : f32
        %15 = affine.load %arg8[] : memref<f32, 1>
        %16 = arith.addf %14, %15 : f32
        %17 = affine.load %arg5[] : memref<f32, 1>
        %18 = affine.load %arg7[] : memref<f32, 1>
        %19 = math.sqrt %16 : f32
        %20 = affine.load %arg1[%arg13, %arg14] : memref<20x10xf32, 1>
        %21 = arith.mulf %17, %20 : f32
        %22 = affine.load %arg4[%arg13, %arg14] : memref<20x10xf32, 1>
        %23 = arith.mulf %18, %22 : f32
        %24 = arith.divf %21, %19 : f32
        %25 = arith.addf %23, %24 : f32
        affine.store %25, %arg12[%arg13, %arg14] : memref<20x10xf32, 1>
        %26 = affine.load %arg0[%arg13, %arg14] : memref<20x10xf32, 1>
        %27 = arith.subf %26, %25 : f32
        affine.store %27, %arg9[%arg13, %arg14] : memref<20x10xf32, 1>
      }
    }
    return
  }
  func.func @alias_escaping_memref(%arg0: memref<2x5xf32>) {
    %cst = arith.constant 0.000000e+00 : f32
    %reinterpret_cast = memref.reinterpret_cast %arg0 to offset: [0], sizes: [10], strides: [1] : memref<2x5xf32> to memref<10xf32>
    affine.for %arg1 = 0 to 10 {
      affine.store %cst, %reinterpret_cast[%arg1] : memref<10xf32>
    }
    return
  }
  func.func @unknown_memref_def_op() {
    %cst = arith.constant 0.000000e+00 : f32
    %0 = call @bar() : () -> memref<10xf32>
    affine.for %arg0 = 0 to 10 {
      affine.store %cst, %0[%arg0] : memref<10xf32>
    }
    return
  }
  func.func private @bar() -> memref<10xf32>
}


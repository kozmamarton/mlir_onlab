#ifndef GPU_BENCHMARK_SUPPORT_H
#define GPU_BENCHMARK_SUPPORT_H

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <vector>

extern "C" {
void *mgpuStreamCreate();
void mgpuStreamDestroy(void *stream);
void mgpuStreamSynchronize(void *stream);
void *mgpuMemAlloc(uint64_t sizeBytes, void *stream, bool isHostShared);
void mgpuMemFree(void *ptr, void *stream);
void mgpuMemcpy(void *dst, void *src, size_t sizeBytes, void *stream);
}

extern "C" void mgpuModuleUnload(void *) {}

class DeviceBufferSet {
public:
  explicit DeviceBufferSet(size_t count)
      : buffers_(count, nullptr), sizes_(count, 0), stream_(mgpuStreamCreate()) {
    if (!stream_) {
      std::fprintf(stderr, "Unable to create CUDA stream.\n");
      std::exit(EXIT_FAILURE);
    }
  }

  DeviceBufferSet(const DeviceBufferSet &) = delete;
  DeviceBufferSet &operator=(const DeviceBufferSet &) = delete;

  ~DeviceBufferSet() {
    for (void *buffer : buffers_) {
      if (buffer)
        mgpuMemFree(buffer, stream_);
    }
    mgpuStreamDestroy(stream_);
  }

  void allocate(size_t index, size_t bytes) {
    sizes_[index] = bytes;
    buffers_[index] = mgpuMemAlloc(bytes, stream_, true);
    if (!buffers_[index] && bytes != 0) {
      std::fprintf(stderr, "Unable to allocate CUDA device buffer.\n");
      std::exit(EXIT_FAILURE);
    }
  }

  template <typename T>
  void copy_to_device(size_t index, const T *source) {
    mgpuMemcpy(buffers_[index], const_cast<T *>(source), sizes_[index], stream_);
  }

  template <typename T>
  void copy_to_host(size_t index, T *destination) {
    mgpuMemcpy(destination, buffers_[index], sizes_[index], stream_);
  }

  void synchronize() { mgpuStreamSynchronize(stream_); }
  void *operator[](size_t index) const { return buffers_[index]; }

private:
  std::vector<void *> buffers_;
  std::vector<size_t> sizes_;
  void *stream_;
};

#endif

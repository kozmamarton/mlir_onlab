#include "../imports/pom2k_c_header.h"

#include <cuda_runtime.h>

#include <chrono>
#include <errno.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int im;
int jm;
int kb;
int imm1;
int jmm1;
int kbm1;
int imm2;
int jmm2;
int kbm2;
real_t dti2;
real_t umol;

static void ext_profu_original_cpu(real_t *h, real_t *etf, real_t *c,
                                  real_t *km, real_t *a, real_t *dz,
                                  real_t *dzz, real_t *ee, real_t *gg,
                                  real_t *wusurf, real_t *uf, real_t *tps,
                                  real_t *cbc, real_t *ub, real_t *vb,
                                  real_t *dum, real_t *wubot, real_t *dhloc)
{
  for (int j = 0; j < jm; ++j)
    for (int i = 0; i < im; ++i)
      dhloc[ACC2(i, j)] = 1.0f;

  for (int j = 1; j < jm; ++j)
    for (int i = 1; i < im; ++i)
      dhloc[ACC2(i, j)] =
          (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] +
           etf[ACC2(i - 1, j)]) *
          0.5f;

  for (int k = 0; k < kb; ++k)
    for (int j = 1; j < jm; ++j)
      for (int i = 1; i < im; ++i)
        c[ACC3(i, j, k)] =
            (km[ACC3(i, j, k)] + km[ACC3(i - 1, j, k)]) * 0.5f;

  for (int k = 0; k < kbm2; ++k)
    for (int j = 0; j < jm; ++j)
      for (int i = 0; i < im; ++i)
        a[ACC3(i, j, k)] =
            -dti2 * (c[ACC3(i, j, k + 1)] + umol) /
            (dz[k] * dzz[k] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);

  for (int k = 1; k < kbm1; ++k)
    for (int j = 0; j < jm; ++j)
      for (int i = 0; i < im; ++i)
        c[ACC3(i, j, k)] =
            -dti2 * (c[ACC3(i, j, k)] + umol) /
            (dz[k] * dzz[k - 1] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);

  for (int j = 0; j < jm; ++j)
    for (int i = 0; i < im; ++i)
    {
      ee[ACC3(i, j, 0)] =
          a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
      gg[ACC3(i, j, 0)] =
          (-dti2 * wusurf[ACC2(i, j)] /
               (-dz[0] * dhloc[ACC2(i, j)]) -
           uf[ACC3(i, j, 0)]) /
          (a[ACC3(i, j, 0)] - 1.0f);
    }

  for (int k = 1; k < kbm2; ++k)
    for (int j = 0; j < jm; ++j)
      for (int i = 0; i < im; ++i)
      {
        gg[ACC3(i, j, k)] =
            1.0f /
            (a[ACC3(i, j, k)] +
             c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
        ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
        gg[ACC3(i, j, k)] =
            (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] -
             uf[ACC3(i, j, k)]) *
            gg[ACC3(i, j, k)];
      }

  for (int j = 1; j < jmm1; ++j)
    for (int i = 1; i < imm1; ++i)
    {
      const real_t vb_average =
          0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                   vb[ACC3(i - 1, j, kbm2)] +
                   vb[ACC3(i - 1, j + 1, kbm2)]);
      tps[ACC2(i, j)] =
          0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
          sqrtf(ub[ACC3(i, j, kbm2)] * ub[ACC3(i, j, kbm2)] +
                vb_average * vb_average);
      uf[ACC3(i, j, kbm2)] =
          (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] -
           uf[ACC3(i, j, kbm2)]) /
          (tps[ACC2(i, j)] * dti2 /
               (-dz[kbm2] * dhloc[ACC2(i, j)]) -
           1.0f - (ee[ACC3(i, j, kbm2 - 1)] - 1.0f) *
                     c[ACC3(i, j, kbm2)]);
      uf[ACC3(i, j, kbm2)] *= dum[ACC2(i, j)];
    }

  for (int k = kb - 3; k >= 0; --k)
    for (int j = 1; j < jmm1; ++j)
      for (int i = 1; i < imm1; ++i)
        uf[ACC3(i, j, k)] =
            (ee[ACC3(i, j, k)] * uf[ACC3(i, j, k + 1)] +
             gg[ACC3(i, j, k)]) *
            dum[ACC2(i, j)];

  for (int j = 1; j < jmm1; ++j)
    for (int i = 1; i < imm1; ++i)
      wubot[ACC2(i, j)] = -tps[ACC2(i, j)] * uf[ACC3(i, j, kbm2)];
}

__global__ static void initialize_and_average_kernel(
    const real_t *h, const real_t *etf, real_t *c, const real_t *km,
    real_t *dhloc, int im, int jm, size_t count_2d, size_t count_3d)
{
  const size_t index =
      static_cast<size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (index < count_2d)
  {
    const int i = static_cast<int>(index % im);
    const int j = static_cast<int>(index / im);
    dhloc[index] = (i > 0 && j > 0)
                       ? (h[index] + etf[index] + h[index - 1] +
                          etf[index - 1]) *
                             0.5f
                       : 1.0f;
  }
  if (index < count_3d)
  {
    const int i = static_cast<int>(index % im);
    const int j = static_cast<int>((index / im) % jm);
    if (i > 0 && j > 0)
      c[index] = (km[index] + km[index - 1]) * 0.5f;
  }
}

__global__ static void calculate_a_kernel(
    const real_t *c, real_t *a, const real_t *dz, const real_t *dzz,
    const real_t *dhloc, int kbm2, real_t dti2, real_t umol,
    size_t count_2d, size_t count_3d)
{
  const size_t index =
      static_cast<size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (index >= count_3d)
    return;
  const size_t plane = count_2d;
  const int k = static_cast<int>(index / plane);
  if (k < kbm2)
  {
    const size_t horizontal = index % plane;
    const real_t depth = dhloc[horizontal];
    a[index] = -dti2 * (c[index + plane] + umol) /
               (dz[k] * dzz[k] * depth * depth);
  }
}

__global__ static void update_c_kernel(
    real_t *c, const real_t *dz, const real_t *dzz, const real_t *dhloc,
    int kbm1, real_t dti2, real_t umol, size_t count_2d,
    size_t count_3d)
{
  const size_t index =
      static_cast<size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (index >= count_3d)
    return;
  const size_t plane = count_2d;
  const int k = static_cast<int>(index / plane);
  if (k > 0 && k < kbm1)
  {
    const real_t depth = dhloc[index % plane];
    c[index] = -dti2 * (c[index] + umol) /
               (dz[k] * dzz[k - 1] * depth * depth);
  }
}

__global__ static void solve_forward_kernel(
    const real_t *a, const real_t *c, const real_t *dz,
    const real_t *dhloc, const real_t *wusurf, const real_t *uf,
    real_t *ee, real_t *gg, int kbm2, real_t dti2, size_t count_2d)
{
  const size_t horizontal =
      static_cast<size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (horizontal >= count_2d)
    return;
  const size_t plane = count_2d;
  ee[horizontal] = a[horizontal] / (a[horizontal] - 1.0f);
  gg[horizontal] =
      (-dti2 * wusurf[horizontal] / (-dz[0] * dhloc[horizontal]) -
       uf[horizontal]) /
      (a[horizontal] - 1.0f);
  for (int k = 1; k < kbm2; ++k)
  {
    const size_t index = static_cast<size_t>(k) * plane + horizontal;
    const size_t previous = index - plane;
    gg[index] =
        1.0f / (a[index] + c[index] * (1.0f - ee[previous]) - 1.0f);
    ee[index] = a[index] * gg[index];
    gg[index] = (c[index] * gg[previous] - uf[index]) * gg[index];
  }
}

__global__ static void finish_columns_kernel(
    const real_t *c, const real_t *dz, const real_t *dhloc, const real_t *ee,
    const real_t *gg, const real_t *cbc, const real_t *ub, const real_t *vb,
    const real_t *dum, real_t *uf, real_t *tps, real_t *wubot,
    int im, int kb, int imm1, int jmm1, int kbm2, real_t dti2,
    size_t count_2d)
{
  const size_t horizontal =
      static_cast<size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
  if (horizontal >= count_2d)
    return;
  const int i = static_cast<int>(horizontal % im);
  const int j = static_cast<int>(horizontal / im);
  if (i > 0 && i < imm1 && j > 0 && j < jmm1)
  {
    const size_t plane = count_2d;
    const size_t bottom = static_cast<size_t>(kbm2) * plane + horizontal;
    const size_t above = bottom - plane;
    const real_t vb_average =
        0.25f * (vb[bottom] + vb[bottom + im] + vb[bottom - 1] +
                 vb[bottom + im - 1]);
    const real_t ub_bottom = ub[bottom];
    tps[horizontal] =
        0.5f * (cbc[horizontal] + cbc[horizontal - 1]) *
        sqrtf(ub_bottom * ub_bottom + vb_average * vb_average);
    uf[bottom] =
        (c[bottom] * gg[above] - uf[bottom]) /
        (tps[horizontal] * dti2 /
             (-dz[kbm2] * dhloc[horizontal]) -
         1.0f -
         (ee[above] - 1.0f) * c[bottom]);
    uf[bottom] *= dum[horizontal];

    for (int k = kb - 3; k >= 0; --k)
    {
      const size_t index = static_cast<size_t>(k) * plane + horizontal;
      uf[index] =
          (ee[index] * uf[index + plane] + gg[index]) * dum[horizontal];
    }
    wubot[horizontal] = -tps[horizontal] * uf[bottom];
  }
}

struct Fields
{
  real_t *two_d = nullptr;
  real_t *three_d = nullptr;
  real_t *dz = nullptr;
  real_t *dzz = nullptr;
  real_t *h = nullptr;
  real_t *etf = nullptr;
  real_t *wusurf = nullptr;
  real_t *tps = nullptr;
  real_t *cbc = nullptr;
  real_t *dum = nullptr;
  real_t *wubot = nullptr;
  real_t *dhloc = nullptr;
  real_t *c = nullptr;
  real_t *km = nullptr;
  real_t *a = nullptr;
  real_t *ee = nullptr;
  real_t *gg = nullptr;
  real_t *uf = nullptr;
  real_t *ub = nullptr;
  real_t *vb = nullptr;
};

static int allocate_fields(Fields *fields, size_t count_2d, size_t count_3d,
                           size_t levels)
{
  fields->two_d = static_cast<real_t *>(malloc(8 * count_2d * sizeof(real_t)));
  fields->three_d =
      static_cast<real_t *>(malloc(8 * count_3d * sizeof(real_t)));
  fields->dz = static_cast<real_t *>(malloc(levels * sizeof(real_t)));
  fields->dzz = static_cast<real_t *>(malloc(levels * sizeof(real_t)));
  if (!fields->two_d || !fields->three_d || !fields->dz || !fields->dzz)
    return 0;

  fields->h = fields->two_d;
  fields->etf = fields->h + count_2d;
  fields->wusurf = fields->etf + count_2d;
  fields->tps = fields->wusurf + count_2d;
  fields->cbc = fields->tps + count_2d;
  fields->dum = fields->cbc + count_2d;
  fields->wubot = fields->dum + count_2d;
  fields->dhloc = fields->wubot + count_2d;
  fields->c = fields->three_d;
  fields->km = fields->c + count_3d;
  fields->a = fields->km + count_3d;
  fields->ee = fields->a + count_3d;
  fields->gg = fields->ee + count_3d;
  fields->uf = fields->gg + count_3d;
  fields->ub = fields->uf + count_3d;
  fields->vb = fields->ub + count_3d;
  return 1;
}

static void free_fields(Fields *fields)
{
  free(fields->two_d);
  free(fields->three_d);
  free(fields->dz);
  free(fields->dzz);
  *fields = {};
}

static void copy_fields(Fields *destination, const Fields *source,
                        size_t count_2d, size_t count_3d, size_t levels)
{
  memcpy(destination->two_d, source->two_d, 8 * count_2d * sizeof(real_t));
  memcpy(destination->three_d, source->three_d,
         8 * count_3d * sizeof(real_t));
  memcpy(destination->dz, source->dz, levels * sizeof(real_t));
  memcpy(destination->dzz, source->dzz, levels * sizeof(real_t));
}

static void initialize_fields(Fields *fields, size_t count_2d,
                              size_t count_3d, size_t levels)
{
  for (size_t index = 0; index < count_2d; ++index)
  {
    fields->h[index] = 10.0f + static_cast<real_t>(index % 97) * 0.001f;
    fields->etf[index] = 0.1f + static_cast<real_t>(index % 31) * 0.0001f;
    fields->wusurf[index] = 0.001f;
    fields->tps[index] = 0.0f;
    fields->cbc[index] = 0.0025f;
    fields->dum[index] = 1.0f;
    fields->wubot[index] = 0.0f;
    fields->dhloc[index] = 1.0f;
  }
  for (size_t index = 0; index < count_3d; ++index)
  {
    fields->c[index] = 0.02f + static_cast<real_t>(index % 19) * 0.0001f;
    fields->km[index] = 0.03f + static_cast<real_t>(index % 23) * 0.0001f;
    fields->a[index] = 0.0f;
    fields->ee[index] = 0.0f;
    fields->gg[index] = 0.0f;
    fields->uf[index] = 0.001f;
    fields->ub[index] = 0.05f;
    fields->vb[index] = 0.02f;
  }
  for (size_t level = 0; level < levels; ++level)
  {
    fields->dz[level] = 1.0f / static_cast<real_t>(levels);
    fields->dzz[level] = 1.0f / static_cast<real_t>(levels);
  }
}

static int64_t timed_call_original(Fields *fields, const Fields *initial,
                                   size_t count_2d, size_t count_3d,
                                   size_t levels)
{
  copy_fields(fields, initial, count_2d, count_3d, levels);
  const auto start = std::chrono::steady_clock::now();
  ext_profu_original_cpu(fields->h, fields->etf, fields->c, fields->km,
                         fields->a, fields->dz, fields->dzz, fields->ee,
                         fields->gg, fields->wusurf, fields->uf, fields->tps,
                         fields->cbc, fields->ub, fields->vb, fields->dum,
                         fields->wubot, fields->dhloc);
  const auto end = std::chrono::steady_clock::now();
  return std::chrono::duration_cast<std::chrono::nanoseconds>(end - start)
      .count();
}

struct DeviceFields
{
  real_t *two_d = nullptr;
  real_t *three_d = nullptr;
  real_t *dz = nullptr;
  real_t *dzz = nullptr;
  real_t *h = nullptr;
  real_t *etf = nullptr;
  real_t *wusurf = nullptr;
  real_t *tps = nullptr;
  real_t *cbc = nullptr;
  real_t *dum = nullptr;
  real_t *wubot = nullptr;
  real_t *dhloc = nullptr;
  real_t *c = nullptr;
  real_t *km = nullptr;
  real_t *a = nullptr;
  real_t *ee = nullptr;
  real_t *gg = nullptr;
  real_t *uf = nullptr;
  real_t *ub = nullptr;
  real_t *vb = nullptr;
};

static bool cuda_check(cudaError_t error, const char *operation)
{
  if (error == cudaSuccess)
    return true;
  fprintf(stderr, "CUDA error during %s: %s\n", operation,
          cudaGetErrorString(error));
  return false;
}

static bool allocate_device_fields(DeviceFields *device, size_t count_2d,
                                   size_t count_3d, size_t levels)
{
  if (!cuda_check(cudaMalloc(&device->two_d, 8 * count_2d * sizeof(real_t)),
                  "allocating 2D fields") ||
      !cuda_check(cudaMalloc(&device->three_d, 8 * count_3d * sizeof(real_t)),
                  "allocating 3D fields") ||
      !cuda_check(cudaMalloc(&device->dz, levels * sizeof(real_t)),
                  "allocating dz") ||
      !cuda_check(cudaMalloc(&device->dzz, levels * sizeof(real_t)),
                  "allocating dzz"))
    return false;

  device->h = device->two_d;
  device->etf = device->h + count_2d;
  device->wusurf = device->etf + count_2d;
  device->tps = device->wusurf + count_2d;
  device->cbc = device->tps + count_2d;
  device->dum = device->cbc + count_2d;
  device->wubot = device->dum + count_2d;
  device->dhloc = device->wubot + count_2d;
  device->c = device->three_d;
  device->km = device->c + count_3d;
  device->a = device->km + count_3d;
  device->ee = device->a + count_3d;
  device->gg = device->ee + count_3d;
  device->uf = device->gg + count_3d;
  device->ub = device->uf + count_3d;
  device->vb = device->ub + count_3d;
  return true;
}

static void free_device_fields(DeviceFields *device)
{
  if (device->two_d)
    cudaFree(device->two_d);
  if (device->three_d)
    cudaFree(device->three_d);
  if (device->dz)
    cudaFree(device->dz);
  if (device->dzz)
    cudaFree(device->dzz);
  *device = {};
}

static bool copy_initial_to_device(DeviceFields *device, const Fields *fields,
                                   size_t count_2d, size_t count_3d,
                                   size_t levels)
{
  return cuda_check(cudaMemcpy(device->two_d, fields->two_d,
                               8 * count_2d * sizeof(real_t),
                               cudaMemcpyHostToDevice),
                    "copying 2D fields to device") &&
         cuda_check(cudaMemcpy(device->three_d, fields->three_d,
                               8 * count_3d * sizeof(real_t),
                               cudaMemcpyHostToDevice),
                    "copying 3D fields to device") &&
         cuda_check(cudaMemcpy(device->dz, fields->dz,
                               levels * sizeof(real_t),
                               cudaMemcpyHostToDevice),
                    "copying dz to device") &&
         cuda_check(cudaMemcpy(device->dzz, fields->dzz,
                               levels * sizeof(real_t),
                               cudaMemcpyHostToDevice),
                    "copying dzz to device");
}

static bool copy_device_to_host(const DeviceFields *device, Fields *fields,
                                size_t count_2d, size_t count_3d)
{
  return cuda_check(cudaMemcpy(fields->c, device->c,
                               count_3d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying c from device") &&
         cuda_check(cudaMemcpy(fields->a, device->a,
                               count_3d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying a from device") &&
         cuda_check(cudaMemcpy(fields->ee, device->ee,
                               count_3d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying ee from device") &&
         cuda_check(cudaMemcpy(fields->gg, device->gg,
                               count_3d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying gg from device") &&
         cuda_check(cudaMemcpy(fields->uf, device->uf,
                               count_3d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying uf from device") &&
         cuda_check(cudaMemcpy(fields->tps, device->tps,
                               count_2d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying tps from device") &&
         cuda_check(cudaMemcpy(fields->wubot, device->wubot,
                               count_2d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying wubot from device") &&
         cuda_check(cudaMemcpy(fields->dhloc, device->dhloc,
                               count_2d * sizeof(real_t),
                               cudaMemcpyDeviceToHost),
                    "copying dhloc from device");
}

static bool ext_profu_original_cuda(DeviceFields *device, size_t count_2d,
                                    size_t count_3d)
{
  constexpr int threads = 256;
  const size_t grid_2d = (count_2d + threads - 1) / threads;
  const size_t grid_3d = (count_3d + threads - 1) / threads;
  const size_t grid_init =
      (count_2d > count_3d ? count_2d : count_3d) + threads - 1;
  const unsigned int blocks_2d = static_cast<unsigned int>(grid_2d);
  const unsigned int blocks_3d = static_cast<unsigned int>(grid_3d);
  const unsigned int blocks_init =
      static_cast<unsigned int>(grid_init / threads);

  initialize_and_average_kernel<<<blocks_init, threads>>>(
      device->h, device->etf, device->c, device->km, device->dhloc, im, jm,
      count_2d, count_3d);
  calculate_a_kernel<<<blocks_3d, threads>>>(
      device->c, device->a, device->dz, device->dzz, device->dhloc, kbm2, dti2,
      umol, count_2d, count_3d);
  update_c_kernel<<<blocks_3d, threads>>>(
      device->c, device->dz, device->dzz, device->dhloc, kbm1, dti2, umol,
      count_2d, count_3d);
  solve_forward_kernel<<<blocks_2d, threads>>>(
      device->a, device->c, device->dz, device->dhloc, device->wusurf,
      device->uf, device->ee, device->gg, kbm2, dti2, count_2d);
  finish_columns_kernel<<<blocks_2d, threads>>>(
      device->c, device->dz, device->dhloc, device->ee, device->gg,
      device->cbc, device->ub, device->vb, device->dum, device->uf, device->tps,
      device->wubot, im, kb, imm1, jmm1, kbm2, dti2, count_2d);
  return cuda_check(cudaGetLastError(), "launching ext_profu CUDA kernels");
}

static bool timed_call_cuda(DeviceFields *device, const Fields *initial,
                            size_t count_2d, size_t count_3d, size_t levels,
                            double *elapsed_ns)
{
  if (!copy_initial_to_device(device, initial, count_2d, count_3d, levels))
    return false;

  const auto start = std::chrono::steady_clock::now();
  if (!ext_profu_original_cuda(device, count_2d, count_3d) ||
      !cuda_check(cudaDeviceSynchronize(), "synchronizing CUDA kernels"))
    return false;
  const auto end = std::chrono::steady_clock::now();
  *elapsed_ns =
      static_cast<double>(
          std::chrono::duration_cast<std::chrono::nanoseconds>(end - start)
              .count());
  return true;
}

static real_t checksum(const Fields *fields, size_t count_2d,
                       size_t count_3d)
{
  real_t sum = 0.0f;
  for (size_t index = 0; index < count_2d; ++index)
    sum += fields->tps[index] + fields->wubot[index] + fields->dhloc[index];
  for (size_t index = 0; index < count_3d; ++index)
    sum += fields->c[index] + fields->a[index] + fields->ee[index] +
           fields->gg[index] + fields->uf[index];
  return sum;
}

static real_t max_difference(const Fields *left, const Fields *right,
                             size_t count_2d, size_t count_3d)
{
  real_t maximum = 0.0f;
  const real_t *left_2d[] = {left->tps, left->wubot, left->dhloc};
  const real_t *right_2d[] = {right->tps, right->wubot, right->dhloc};
  const real_t *left_3d[] = {left->c, left->a, left->ee, left->gg, left->uf};
  const real_t *right_3d[] = {right->c, right->a, right->ee, right->gg,
                              right->uf};

  for (size_t array = 0; array < 3; ++array)
    for (size_t index = 0; index < count_2d; ++index)
    {
      const real_t difference =
          fabsf(left_2d[array][index] - right_2d[array][index]);
      if (!isfinite(difference))
        return INFINITY;
      if (difference > maximum)
        maximum = difference;
    }
  for (size_t array = 0; array < 5; ++array)
    for (size_t index = 0; index < count_3d; ++index)
    {
      const real_t difference =
          fabsf(left_3d[array][index] - right_3d[array][index]);
      if (!isfinite(difference))
        return INFINITY;
      if (difference > maximum)
        maximum = difference;
    }
  return maximum;
}

static int parse_positive(const char *text, int *value)
{
  char *end;
  errno = 0;
  const long parsed = strtol(text, &end, 10);
  if (errno || *text == '\0' || *end != '\0' || parsed <= 0 ||
      parsed > 100000)
    return 0;
  *value = static_cast<int>(parsed);
  return 1;
}

int main(int argc, char **argv)
{
  int dimensions[] = {65, 49, 21, 100};
  const char *dimension_names[] = {"im", "jm", "kb", "iterations"};
  if (argc > 5)
  {
    fprintf(stderr, "Usage: %s [im jm kb iterations]\n", argv[0]);
    return EXIT_FAILURE;
  }
  for (int argument = 1; argument < argc; ++argument)
    if (!parse_positive(argv[argument], &dimensions[argument - 1]))
    {
      fprintf(stderr, "Invalid positive integer for %s: %s\n",
              dimension_names[argument - 1], argv[argument]);
      return EXIT_FAILURE;
    }

  im = dimensions[0];
  jm = dimensions[1];
  kb = dimensions[2];
  if (im < 3 || jm < 3 || kb < 4)
  {
    fprintf(stderr, "Dimensions must satisfy im >= 3, jm >= 3, kb >= 4.\n");
    return EXIT_FAILURE;
  }
  imm1 = im - 1;
  jmm1 = jm - 1;
  kbm1 = kb - 1;
  kbm2 = kb - 2;
  dti2 = 0.1f;
  umol = 0.00001f;

  const size_t count_2d = static_cast<size_t>(im) * jm;
  if (count_2d > SIZE_MAX / static_cast<size_t>(kb))
  {
    fprintf(stderr, "Requested dimensions are too large.\n");
    return EXIT_FAILURE;
  }
  const size_t count_3d = count_2d * static_cast<size_t>(kb);
  if (count_3d > SIZE_MAX / (8 * sizeof(real_t)))
  {
    fprintf(stderr, "Requested dimensions are too large.\n");
    return EXIT_FAILURE;
  }

  int device_count = 0;
  if (!cuda_check(cudaGetDeviceCount(&device_count), "finding CUDA devices"))
    return EXIT_FAILURE;
  if (device_count == 0)
  {
    fprintf(stderr, "No CUDA devices are available.\n");
    return EXIT_FAILURE;
  }

  Fields initial = {};
  Fields original = {};
  Fields cuda_result = {};
  DeviceFields device = {};
  if (!allocate_fields(&initial, count_2d, count_3d, static_cast<size_t>(kb)) ||
      !allocate_fields(&original, count_2d, count_3d, static_cast<size_t>(kb)) ||
      !allocate_fields(&cuda_result, count_2d, count_3d,
                       static_cast<size_t>(kb)))
  {
    fprintf(stderr, "Unable to allocate benchmark arrays.\n");
    free_fields(&initial);
    free_fields(&original);
    free_fields(&cuda_result);
    return EXIT_FAILURE;
  }
  initialize_fields(&initial, count_2d, count_3d, static_cast<size_t>(kb));
  if (!allocate_device_fields(&device, count_2d, count_3d,
                              static_cast<size_t>(kb)))
  {
    free_device_fields(&device);
    free_fields(&initial);
    free_fields(&original);
    free_fields(&cuda_result);
    return EXIT_FAILURE;
  }

  for (int warmup = 0; warmup < 3; ++warmup)
  {
    (void)timed_call_original(&original, &initial, count_2d, count_3d,
                              static_cast<size_t>(kb));
    double ignored_ns = 0.0;
    if (!timed_call_cuda(&device, &initial, count_2d, count_3d,
                         static_cast<size_t>(kb), &ignored_ns))
    {
      free_device_fields(&device);
      free_fields(&initial);
      free_fields(&original);
      free_fields(&cuda_result);
      return EXIT_FAILURE;
    }
  }

  int64_t original_total_ns = 0;
  double cuda_total_ns = 0.0;
  for (int iteration = 0; iteration < dimensions[3]; ++iteration)
  {
    if ((iteration & 1) == 0)
    {
      original_total_ns += timed_call_original(
          &original, &initial, count_2d, count_3d, static_cast<size_t>(kb));
      double elapsed_ns = 0.0;
      if (!timed_call_cuda(&device, &initial, count_2d, count_3d,
                           static_cast<size_t>(kb), &elapsed_ns))
      {
        free_device_fields(&device);
        free_fields(&initial);
        free_fields(&original);
        free_fields(&cuda_result);
        return EXIT_FAILURE;
      }
      cuda_total_ns += elapsed_ns;
    }
    else
    {
      double elapsed_ns = 0.0;
      if (!timed_call_cuda(&device, &initial, count_2d, count_3d,
                           static_cast<size_t>(kb), &elapsed_ns))
      {
        free_device_fields(&device);
        free_fields(&initial);
        free_fields(&original);
        free_fields(&cuda_result);
        return EXIT_FAILURE;
      }
      cuda_total_ns += elapsed_ns;
      original_total_ns += timed_call_original(
          &original, &initial, count_2d, count_3d, static_cast<size_t>(kb));
    }
  }

  if (!copy_device_to_host(&device, &cuda_result, count_2d, count_3d))
  {
    free_device_fields(&device);
    free_fields(&initial);
    free_fields(&original);
    free_fields(&cuda_result);
    return EXIT_FAILURE;
  }

  const double original_average_ns =
      static_cast<double>(original_total_ns) / dimensions[3];
  const double cuda_average_ns = cuda_total_ns / dimensions[3];
  const double difference_ns = cuda_average_ns - original_average_ns;
  const double difference_percent =
      original_average_ns == 0.0
          ? 0.0
          : difference_ns * 100.0 / original_average_ns;
  const real_t maximum_difference =
      max_difference(&original, &cuda_result, count_2d, count_3d);

  printf("ext_profu_ CUDA benchmark (%d x %d x %d, %d iterations)\n",
         im, jm, kb, dimensions[3]);
  printf("Original: total %.3f ms, average %.3f us/call, checksum %.9g\n",
         original_total_ns / 1.0e6, original_average_ns / 1.0e3,
         static_cast<double>(checksum(&original, count_2d, count_3d)));
  printf("CUDA:     total %.3f ms, average %.3f us/launch+sync, checksum %.9g\n",
         cuda_total_ns / 1.0e6, cuda_average_ns / 1.0e3,
         static_cast<double>(checksum(&cuda_result, count_2d, count_3d)));
  printf("Difference (CUDA - original): %.3f us/call (%+.2f%%)\n",
         difference_ns / 1.0e3, difference_percent);
  printf("Maximum absolute difference across modified arrays: %.9g\n",
         static_cast<double>(maximum_difference));
  if (cuda_average_ns > 0.0)
    printf("Speedup (original / CUDA launch+sync): %.3fx\n",
           original_average_ns / cuda_average_ns);

  free_device_fields(&device);
  free_fields(&initial);
  free_fields(&original);
  free_fields(&cuda_result);
  return maximum_difference <= 1.0e-5f ? EXIT_SUCCESS : EXIT_FAILURE;
}

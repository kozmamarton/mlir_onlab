extern "C" {
#include "../pom2k_fun.h"
}

#include "../llvm/gpu_benchmark_support.h"

#include <chrono>
#include <errno.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MEMREF_F32_ARGS void *, void *, int64_t, int64_t, int64_t
extern "C" void ext_profu_(
    MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS,
    MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS,
    MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS,
    MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS, MEMREF_F32_ARGS,
    MEMREF_F32_ARGS, MEMREF_F32_ARGS);
#undef MEMREF_F32_ARGS

enum DeviceArray { H, ETF, C, KM, A, DZ, DZZ, EE, GG, WUSURF, UF, TPS, CBC,
                   UB, VB, DUM, WUBOT, DHLOC, DEVICE_ARRAY_COUNT };

#define PASS_MEMREF(index, count) \
  device[index], device[index], int64_t{0}, static_cast<int64_t>(count), int64_t{1}

static void ext_profu_original(real_t *h, real_t *etf, real_t *c, real_t *km,
                               real_t *a, real_t *dz, real_t *dzz, real_t *ee,
                               real_t *gg, real_t *wusurf, real_t *uf,
                               real_t *tps, real_t *cbc, real_t *ub,
                               real_t *vb, real_t *dum, real_t *wubot,
                               real_t *dhloc)
{
  for (int j = 0; j < jm; j++)
  {
    for (int i = 0; i < im; i++)
    {
      dhloc[ACC2(i, j)] = 1.0f;
    }
  }
  for (int j = 1; j < jm; j++)
  {
    for (int i = 1; i < im; i++)
    {
      dhloc[ACC2(i, j)] =
          (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] + etf[ACC2(i - 1, j)]) * 0.5f;
    }
  }
  /*
        do k=1,kb
          do j=2,jm
            do i=2,im
              c(i,j,k)=(km(i,j,k)+km(i-1,j,k))*.5e0
            end do
          end do
        end do
  */
  for (int k = 0; k < kb; k++)
  {
    for (int j = 1; j < jm; j++)
    {
      for (int i = 1; i < im; i++)
      {
        c[ACC3(i, j, k)] = (km[ACC3(i, j, k)] + km[ACC3(i - 1, j, k)]) * 0.5f;
      }
    }
  }
  /*
        do k=2,kbm1
          do j=1,jm
            do i=1,im
              a(i,j,k-1)=-dti2*(c(i,j,k)+umol)
       $                  /(dz(k-1)*dzz(k-1)*dhloc(i,j)*dhloc(i,j))
              c(i,j,k)=-dti2*(c(i,j,k)+umol)
       $                /(dz(k)*dzz(k-1)*dhloc(i,j)*dhloc(i,j))
            end do
          end do
        end do
  */
  for (int k = 0; k < kbm2; k++)
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        a[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k + 1)] + umol) /
                           (dz[k] * dzz[k] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
      }
    }
  }

  for (int k = 1; k < kbm1; k++)
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        c[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k)] + umol) /
                           (dz[k] * dzz[k - 1] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
      }
    }
  }
  /*
        do j=1,jm
          do i=1,im
            ee(i,j,1)=a(i,j,1)/(a(i,j,1)-1.e0)
            gg(i,j,1)=(-dti2*wusurf(i,j)/(-dz(1)*dhloc(i,j))
       $               -uf(i,j,1))
       $               /(a(i,j,1)-1.e0)
          end do
        end do
  */
  for (int j = 0; j < jm; j++)
  {
    for (int i = 0; i < im; i++)
    {
      ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
      gg[ACC3(i, j, 0)] =
          (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dhloc[ACC2(i, j)]) - uf[ACC3(i, j, 0)]) /
          (a[ACC3(i, j, 0)] - 1.0f);
    }
  }
  
  for (int k = 1; k < kbm2; k++)
  {
    for (int j = 0; j < jm; j++)
    {
      for (int i = 0; i < im; i++)
      {
        gg[ACC3(i, j, k)] =
            1.0f /
            (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
        ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
        gg[ACC3(i, j, k)] = (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - uf[ACC3(i, j, k)]) *
                            gg[ACC3(i, j, k)];
      }
    }
  }
  for (int j = 1; j < jmm1; j++)
  {
    for (int i = 1; i < imm1; i++)
    {
      tps[ACC2(i, j)] =
          0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
          sqrtf(ub[ACC3(i, j, kbm2)] * ub[ACC3(i, j, kbm2)] +
                (0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                          vb[ACC3(i - 1, j, kbm2)] + vb[ACC3(i - 1, j + 1, kbm2)])) *
                    (0.25f * (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                              vb[ACC3(i - 1, j, kbm2)] + vb[ACC3(i - 1, j + 1, kbm2)])));
      uf[ACC3(i, j, kbm2)] =
          (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] - uf[ACC3(i, j, kbm2)]) /
          (tps[ACC2(i, j)] * (dti2) / (-dz[kbm2] * dhloc[ACC2(i, j)]) - 1.0f -
           (ee[ACC3(i, j, kbm2 - 1)] - 1.0f) * c[ACC3(i, j, kbm2)]);
      uf[ACC3(i, j, kbm2)] = uf[ACC3(i, j, kbm2)] * dum[ACC2(i, j)];
    }
  }
  /*

        do k=2,kbm1
          ki=kb-k
          do j=2,jmm1
            do i=2,imm1
              uf(i,j,ki)=(ee(i,j,ki)*uf(i,j,ki+1)+gg(i,j,ki))*dum(i,j)
            end do
          end do
        end do
  */
  // ki -> ki-1
  for (int k = kb - 3; k >= 0; k--)
  {
    for (int j = 1; j < jmm1; j++)
    {
      for (int i = 1; i < imm1; i++)
      {
        uf[ACC3(i, j, k)] =
            (ee[ACC3(i, j, k)] * uf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]) *
            dum[ACC2(i, j)];
      }
    }
  }
  /*
        do j=2,jmm1
          do i=2,imm1
            wubot(i,j)=-tps(i,j)*uf(i,j,kbm1)
          end do
        end do
    */
  // kbm1 -> kbm1-1
  for (int j = 1; j < jmm1; j++)
  {
    for (int i = 1; i < imm1; i++)
    {
      wubot[ACC2(i, j)] = -tps[ACC2(i, j)] * uf[ACC3(i, j, kbm2)];
    }
  }
}

typedef struct
{
  real_t *two_d;
  real_t *three_d;
  real_t *dz;
  real_t *dzz;
  real_t *h;
  real_t *etf;
  real_t *wusurf;
  real_t *tps;
  real_t *cbc;
  real_t *dum;
  real_t *wubot;
  real_t *dhloc;
  real_t *c;
  real_t *km;
  real_t *a;
  real_t *ee;
  real_t *gg;
  real_t *uf;
  real_t *ub;
  real_t *vb;
} Fields;

static int allocate_fields(Fields *fields, size_t count_2d, size_t count_3d,
                           size_t levels)
{
  fields->two_d = static_cast<real_t *>(malloc(8 * count_2d * sizeof(real_t)));
  fields->three_d = static_cast<real_t *>(malloc(8 * count_3d * sizeof(real_t)));
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
}

static void copy_fields(Fields *destination, const Fields *source,
                        size_t count_2d, size_t count_3d, size_t levels)
{
  memcpy(destination->two_d, source->two_d,
         8 * count_2d * sizeof(real_t));
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
    fields->h[index] = 10.0f + (real_t)(index % 97) * 0.001f;
    fields->etf[index] = 0.1f + (real_t)(index % 31) * 0.0001f;
    fields->wusurf[index] = 0.001f;
    fields->tps[index] = 0.0f;
    fields->cbc[index] = 0.0025f;
    fields->dum[index] = 1.0f;
    fields->wubot[index] = 0.0f;
    fields->dhloc[index] = 1.0f;
  }
  for (size_t index = 0; index < count_3d; ++index)
  {
    fields->c[index] = 0.02f + (real_t)(index % 19) * 0.0001f;
    fields->km[index] = 0.03f + (real_t)(index % 23) * 0.0001f;
    fields->a[index] = 0.0f;
    fields->ee[index] = 0.0f;
    fields->gg[index] = 0.0f;
    fields->uf[index] = 0.001f;
    fields->ub[index] = 0.05f;
    fields->vb[index] = 0.02f;
  }
  for (size_t level = 0; level < levels; ++level)
  {
    fields->dz[level] = 1.0f / (real_t)levels;
    fields->dzz[level] = 1.0f / (real_t)levels;
  }
}

static int64_t timed_call_original(Fields *fields, const Fields *initial,
                                   size_t count_2d, size_t count_3d,
                                   size_t levels)
{
  copy_fields(fields, initial, count_2d, count_3d, levels);
  const auto start = std::chrono::steady_clock::now();
  ext_profu_original(fields->h, fields->etf, fields->c, fields->km,
                     fields->a, fields->dz, fields->dzz, fields->ee,
                     fields->gg, fields->wusurf, fields->uf, fields->tps,
                     fields->cbc, fields->ub, fields->vb, fields->dum,
                     fields->wubot, fields->dhloc);
  const auto end = std::chrono::steady_clock::now();
  return std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
}

static void allocate_device_fields(DeviceBufferSet &device, size_t count_2d,
                                   size_t count_3d, size_t levels)
{
#define ALLOCATE(index, count) device.allocate(index, (count) * sizeof(real_t))
  ALLOCATE(H, count_2d);
  ALLOCATE(ETF, count_2d);
  ALLOCATE(C, count_3d);
  ALLOCATE(KM, count_3d);
  ALLOCATE(A, count_3d);
  ALLOCATE(DZ, levels);
  ALLOCATE(DZZ, levels);
  ALLOCATE(EE, count_3d);
  ALLOCATE(GG, count_3d);
  ALLOCATE(WUSURF, count_2d);
  ALLOCATE(UF, count_3d);
  ALLOCATE(TPS, count_2d);
  ALLOCATE(CBC, count_2d);
  ALLOCATE(UB, count_3d);
  ALLOCATE(VB, count_3d);
  ALLOCATE(DUM, count_2d);
  ALLOCATE(WUBOT, count_2d);
  ALLOCATE(DHLOC, count_2d);
#undef ALLOCATE
}

static void copy_initial_to_device(DeviceBufferSet &device, const Fields *fields)
{
#define COPY_TO_DEVICE(index, field) device.copy_to_device(index, fields->field)
  COPY_TO_DEVICE(H, h);
  COPY_TO_DEVICE(ETF, etf);
  COPY_TO_DEVICE(C, c);
  COPY_TO_DEVICE(KM, km);
  COPY_TO_DEVICE(A, a);
  COPY_TO_DEVICE(DZ, dz);
  COPY_TO_DEVICE(DZZ, dzz);
  COPY_TO_DEVICE(EE, ee);
  COPY_TO_DEVICE(GG, gg);
  COPY_TO_DEVICE(WUSURF, wusurf);
  COPY_TO_DEVICE(UF, uf);
  COPY_TO_DEVICE(TPS, tps);
  COPY_TO_DEVICE(CBC, cbc);
  COPY_TO_DEVICE(UB, ub);
  COPY_TO_DEVICE(VB, vb);
  COPY_TO_DEVICE(DUM, dum);
  COPY_TO_DEVICE(WUBOT, wubot);
  COPY_TO_DEVICE(DHLOC, dhloc);
#undef COPY_TO_DEVICE
  device.synchronize();
}

static void call_llvm(DeviceBufferSet &device, size_t count_2d,
                      size_t count_3d, size_t levels)
{
  ext_profu_(
      PASS_MEMREF(H, count_2d), PASS_MEMREF(ETF, count_2d),
      PASS_MEMREF(C, count_3d), PASS_MEMREF(KM, count_3d),
      PASS_MEMREF(A, count_3d), PASS_MEMREF(DZ, levels),
      PASS_MEMREF(DZZ, levels), PASS_MEMREF(EE, count_3d),
      PASS_MEMREF(GG, count_3d), PASS_MEMREF(WUSURF, count_2d),
      PASS_MEMREF(UF, count_3d), PASS_MEMREF(TPS, count_2d),
      PASS_MEMREF(CBC, count_2d), PASS_MEMREF(UB, count_3d),
      PASS_MEMREF(VB, count_3d), PASS_MEMREF(DUM, count_2d),
      PASS_MEMREF(WUBOT, count_2d), PASS_MEMREF(DHLOC, count_2d));
}

static void copy_outputs_from_device(DeviceBufferSet &device, Fields *fields)
{
#define COPY_TO_HOST(index, field) device.copy_to_host(index, fields->field)
  COPY_TO_HOST(C, c);
  COPY_TO_HOST(A, a);
  COPY_TO_HOST(EE, ee);
  COPY_TO_HOST(GG, gg);
  COPY_TO_HOST(UF, uf);
  COPY_TO_HOST(TPS, tps);
  COPY_TO_HOST(WUBOT, wubot);
  COPY_TO_HOST(DHLOC, dhloc);
#undef COPY_TO_HOST
  device.synchronize();
}

static int64_t timed_call_llvm(const Fields *initial, DeviceBufferSet &device,
                               size_t count_2d, size_t count_3d,
                               size_t levels)
{
  copy_initial_to_device(device, initial);
  const auto start = std::chrono::steady_clock::now();
  // The generated entry point synchronizes its launch stream before returning.
  call_llvm(device, count_2d, count_3d, levels);
  const auto end = std::chrono::steady_clock::now();
  return std::chrono::duration_cast<std::chrono::nanoseconds>(end - start)
      .count();
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
  const real_t *right_3d[] = {right->c, right->a, right->ee, right->gg, right->uf};

  for (size_t array = 0; array < 3; ++array)
  {
    for (size_t index = 0; index < count_2d; ++index)
    {
      real_t difference = left_2d[array][index] - right_2d[array][index];
      if (difference < 0.0f)
        difference = -difference;
      if (difference > maximum)
        maximum = difference;
    }
  }
  for (size_t array = 0; array < 5; ++array)
  {
    for (size_t index = 0; index < count_3d; ++index)
    {
      real_t difference = left_3d[array][index] - right_3d[array][index];
      if (difference < 0.0f)
        difference = -difference;
      if (difference > maximum)
        maximum = difference;
    }
  }
  return maximum;
}

static int parse_positive(const char *text, int *value)
{
  char *end;
  errno = 0;
  long parsed = strtol(text, &end, 10);
  if (errno || *text == '\0' || *end != '\0' || parsed <= 0 || parsed > 100000)
    return 0;
  *value = (int)parsed;
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
  {
    if (!parse_positive(argv[argument], &dimensions[argument - 1]))
    {
      fprintf(stderr, "Invalid positive integer for %s: %s\n",
              dimension_names[argument - 1], argv[argument]);
      return EXIT_FAILURE;
    }
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

  size_t count_2d = (size_t)im * (size_t)jm;
  size_t count_3d = count_2d * (size_t)kb;
  if (count_3d > SIZE_MAX / (8 * sizeof(real_t)))
  {
    fprintf(stderr, "Requested dimensions are too large.\n");
    return EXIT_FAILURE;
  }

  Fields initial = {0};
  Fields original = {0};
  Fields transformed = {0};
  if (!allocate_fields(&initial, count_2d, count_3d, (size_t)kb) ||
      !allocate_fields(&original, count_2d, count_3d, (size_t)kb) ||
      !allocate_fields(&transformed, count_2d, count_3d, (size_t)kb))
  {
    fprintf(stderr, "Unable to allocate benchmark arrays.\n");
    free_fields(&initial);
    free_fields(&original);
    free_fields(&transformed);
    return EXIT_FAILURE;
  }
  initialize_fields(&initial, count_2d, count_3d, (size_t)kb);
  DeviceBufferSet device(DEVICE_ARRAY_COUNT);
  allocate_device_fields(device, count_2d, count_3d, (size_t)kb);

  for (int warmup = 0; warmup < 3; ++warmup)
  {
    (void)timed_call_original(&original, &initial, count_2d, count_3d,
                              (size_t)kb);
    (void)timed_call_llvm(&initial, device, count_2d, count_3d, (size_t)kb);
  }

  int64_t original_total_ns = 0;
  int64_t transformed_total_ns = 0;
  for (int iteration = 0; iteration < dimensions[3]; ++iteration)
  {
    int64_t elapsed;
    if ((iteration & 1) == 0)
    {
      elapsed = timed_call_original(&original, &initial, count_2d,
                                    count_3d, (size_t)kb);
      if (elapsed < 0)
      {
        fprintf(stderr, "clock_gettime failed.\n");
        free_fields(&initial);
        free_fields(&original);
        free_fields(&transformed);
        return EXIT_FAILURE;
      }
      original_total_ns += elapsed;
      elapsed = timed_call_llvm(&initial, device, count_2d, count_3d,
                                (size_t)kb);
      transformed_total_ns += elapsed;
    }
    else
    {
      elapsed = timed_call_llvm(&initial, device, count_2d, count_3d,
                                (size_t)kb);
      if (elapsed < 0)
      {
        fprintf(stderr, "clock_gettime failed.\n");
        free_fields(&initial);
        free_fields(&original);
        free_fields(&transformed);
        return EXIT_FAILURE;
      }
      transformed_total_ns += elapsed;
      elapsed = timed_call_original(&original, &initial, count_2d,
                                    count_3d, (size_t)kb);
      original_total_ns += elapsed;
    }
  }

  copy_outputs_from_device(device, &transformed);

  double original_average_ns = (double)original_total_ns / dimensions[3];
  double transformed_average_ns = (double)transformed_total_ns / dimensions[3];
  double difference_ns = transformed_average_ns - original_average_ns;
  double difference_percent = original_average_ns == 0.0
                                  ? 0.0
                                  : difference_ns * 100.0 / original_average_ns;

  Fields transformed_c = {0};
  if (!allocate_fields(&transformed_c, count_2d, count_3d, (size_t)kb))
  {
    fprintf(stderr, "Unable to allocate comparison fields.\n");
    free_fields(&transformed_c);
    free_fields(&initial);
    free_fields(&original);
    free_fields(&transformed);
    return EXIT_FAILURE;
  }
  copy_fields(&transformed_c, &initial, count_2d, count_3d, (size_t)kb);
  ext_profu_transformed(transformed_c.h, transformed_c.etf, transformed_c.c,
                        transformed_c.km, transformed_c.a, transformed_c.dz,
                        transformed_c.dzz, transformed_c.ee, transformed_c.gg,
                        transformed_c.wusurf, transformed_c.uf, transformed_c.tps,
                        transformed_c.cbc, transformed_c.ub, transformed_c.vb,
                        transformed_c.dum, transformed_c.wubot, transformed_c.dhloc);

  printf("ext_profu_ benchmark (%d x %d x %d, %d iterations)\n",
         im, jm, kb, dimensions[3]);
  printf("Original:    total %.3f ms, average %.3f us/call, checksum %.9g\n",
         original_total_ns / 1.0e6, original_average_ns / 1.0e3,
         (double)checksum(&original, count_2d, count_3d));
  printf("LLVM:        total %.3f ms, average %.3f us/launch+sync, checksum %.9g\n",
         transformed_total_ns / 1.0e6, transformed_average_ns / 1.0e3,
         (double)checksum(&transformed, count_2d, count_3d));
  printf("Difference (LLVM - original): %.3f us/call (%+.2f%%)\n",
         difference_ns / 1.0e3, difference_percent);
  printf("Maximum absolute difference across modified arrays: %.9g\n",
         (double)max_difference(&original, &transformed, count_2d, count_3d));
    printf("Maximum absolute difference versus transformed C: %.9g\n",
        (double)max_difference(&transformed_c, &transformed, count_2d, count_3d));
  if (transformed_average_ns > 0.0)
    printf("Speedup (original / LLVM): %.3fx\n",
           original_average_ns / transformed_average_ns);

  free_fields(&initial);
  free_fields(&original);
  free_fields(&transformed);
  free_fields(&transformed_c);
  return EXIT_SUCCESS;
}
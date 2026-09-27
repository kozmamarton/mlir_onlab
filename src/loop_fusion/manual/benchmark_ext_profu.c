#define _POSIX_C_SOURCE 200809L

#include "imports/pom2k_c_header.h"

#include <errno.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "pom2k_fun.h"
int im;
int jm;
int kb;
int imm1;
int jmm1;
int kbm1;
int kbm2;
real_t dti2;
real_t umol;

static void ext_profu_original(real_t *h, real_t *etf, real_t *c, real_t *km,
                               real_t *a, real_t *dz, real_t *dzz, real_t *ee,
                               real_t *gg, real_t *wusurf, real_t *uf,
                               real_t *tps, real_t *cbc, real_t *ub,
                               real_t *vb, real_t *dum, real_t *wubot,
                               real_t *dhloc)
{
  for (int j = 0; j < jm; ++j)
  {
    for (int i = 0; i < im; ++i)
      dhloc[ACC2(i, j)] = 1.0f;
  }
  for (int j = 1; j < jm; ++j)
  {
    for (int i = 1; i < im; ++i)
    {
      dhloc[ACC2(i, j)] =
          (h[ACC2(i, j)] + etf[ACC2(i, j)] + h[ACC2(i - 1, j)] +
           etf[ACC2(i - 1, j)]) *
          0.5f;
    }
  }
  for (int k = 0; k < kb; ++k)
  {
    for (int j = 1; j < jm; ++j)
    {
      for (int i = 1; i < im; ++i)
        c[ACC3(i, j, k)] =
            (km[ACC3(i, j, k)] + km[ACC3(i - 1, j, k)]) * 0.5f;
    }
  }
  for (int k = 0; k < kbm2; ++k)
  {
    for (int j = 0; j < jm; ++j)
    {
      for (int i = 0; i < im; ++i)
      {
        a[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k + 1)] + umol) /
                           (dz[k] * dzz[k] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
      }
    }
  }
  for (int k = 1; k < kbm1; ++k)
  {
    for (int j = 0; j < jm; ++j)
    {
      for (int i = 0; i < im; ++i)
      {
        c[ACC3(i, j, k)] = -(dti2) * (c[ACC3(i, j, k)] + umol) /
                           (dz[k] * dzz[k - 1] * dhloc[ACC2(i, j)] * dhloc[ACC2(i, j)]);
      }
    }
  }
  for (int j = 0; j < jm; ++j)
  {
    for (int i = 0; i < im; ++i)
    {
      ee[ACC3(i, j, 0)] = a[ACC3(i, j, 0)] / (a[ACC3(i, j, 0)] - 1.0f);
      gg[ACC3(i, j, 0)] =
          (-(dti2)*wusurf[ACC2(i, j)] / (-dz[0] * dhloc[ACC2(i, j)]) -
           uf[ACC3(i, j, 0)]) /
          (a[ACC3(i, j, 0)] - 1.0f);
    }
  }
  for (int k = 1; k < kbm2; ++k)
  {
    for (int j = 0; j < jm; ++j)
    {
      for (int i = 0; i < im; ++i)
      {
        gg[ACC3(i, j, k)] = 1.0f /
                            (a[ACC3(i, j, k)] + c[ACC3(i, j, k)] * (1.0f - ee[ACC3(i, j, k - 1)]) - 1.0f);
        ee[ACC3(i, j, k)] = a[ACC3(i, j, k)] * gg[ACC3(i, j, k)];
        gg[ACC3(i, j, k)] =
            (c[ACC3(i, j, k)] * gg[ACC3(i, j, k - 1)] - uf[ACC3(i, j, k)]) *
            gg[ACC3(i, j, k)];
      }
    }
  }
  for (int j = 1; j < jmm1; ++j)
  {
    for (int i = 1; i < imm1; ++i)
    {
      real_t vb_average = 0.25f *
                          (vb[ACC3(i, j, kbm2)] + vb[ACC3(i, j + 1, kbm2)] +
                           vb[ACC3(i - 1, j, kbm2)] + vb[ACC3(i - 1, j + 1, kbm2)]);
      tps[ACC2(i, j)] =
          0.5f * (cbc[ACC2(i, j)] + cbc[ACC2(i - 1, j)]) *
          sqrtf(ub[ACC3(i, j, kbm2)] * ub[ACC3(i, j, kbm2)] +
                vb_average * vb_average);
      uf[ACC3(i, j, kbm2)] =
          (c[ACC3(i, j, kbm2)] * gg[ACC3(i, j, kbm2 - 1)] -
           uf[ACC3(i, j, kbm2)]) /
          (tps[ACC2(i, j)] * dti2 / (-dz[kbm2] * dhloc[ACC2(i, j)]) -
           1.0f - (ee[ACC3(i, j, kbm2 - 1)] - 1.0f) * c[ACC3(i, j, kbm2)]);
      uf[ACC3(i, j, kbm2)] *= dum[ACC2(i, j)];
    }
  }
  for (int k = kb - 3; k >= 0; --k)
  {
    for (int j = 1; j < jmm1; ++j)
    {
      for (int i = 1; i < imm1; ++i)
      {
        uf[ACC3(i, j, k)] =
            (ee[ACC3(i, j, k)] * uf[ACC3(i, j, k + 1)] + gg[ACC3(i, j, k)]) *
            dum[ACC2(i, j)];
      }
    }
  }
  for (int j = 1; j < jmm1; ++j)
  {
    for (int i = 1; i < imm1; ++i)
      wubot[ACC2(i, j)] = -tps[ACC2(i, j)] * uf[ACC3(i, j, kbm2)];
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
  fields->two_d = malloc(8 * count_2d * sizeof(real_t));
  fields->three_d = malloc(8 * count_3d * sizeof(real_t));
  fields->dz = malloc(levels * sizeof(real_t));
  fields->dzz = malloc(levels * sizeof(real_t));
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
  struct timespec start;
  struct timespec end;
  copy_fields(fields, initial, count_2d, count_3d, levels);
  if (clock_gettime(CLOCK_MONOTONIC, &start) != 0)
    return -1;
  ext_profu_original(fields->h, fields->etf, fields->c, fields->km,
                     fields->a, fields->dz, fields->dzz, fields->ee,
                     fields->gg, fields->wusurf, fields->uf, fields->tps,
                     fields->cbc, fields->ub, fields->vb, fields->dum,
                     fields->wubot, fields->dhloc);
  if (clock_gettime(CLOCK_MONOTONIC, &end) != 0)
    return -1;
  return (int64_t)(end.tv_sec - start.tv_sec) * INT64_C(1000000000) +
         (int64_t)end.tv_nsec - (int64_t)start.tv_nsec;
}

static int64_t timed_call_transformed(Fields *fields, const Fields *initial,
                                      size_t count_2d, size_t count_3d,
                                      size_t levels)
{
  struct timespec start;
  struct timespec end;
  copy_fields(fields, initial, count_2d, count_3d, levels);
  if (clock_gettime(CLOCK_MONOTONIC, &start) != 0)
    return -1;
  ext_profu_transformed(fields->h, fields->etf, fields->c, fields->km,
                        fields->a, fields->dz, fields->dzz, fields->ee,
                        fields->gg, fields->wusurf, fields->uf, fields->tps,
                        fields->cbc, fields->ub, fields->vb, fields->dum,
                        fields->wubot, fields->dhloc);
  if (clock_gettime(CLOCK_MONOTONIC, &end) != 0)
    return -1;
  return (int64_t)(end.tv_sec - start.tv_sec) * INT64_C(1000000000) +
         (int64_t)end.tv_nsec - (int64_t)start.tv_nsec;
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

  for (int warmup = 0; warmup < 3; ++warmup)
  {
    (void)timed_call_original(&original, &initial, count_2d, count_3d,
                              (size_t)kb);
    (void)timed_call_transformed(&transformed, &initial, count_2d, count_3d,
                                 (size_t)kb);
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
      elapsed = timed_call_transformed(&transformed, &initial, count_2d,
                                       count_3d, (size_t)kb);
      transformed_total_ns += elapsed;
    }
    else
    {
      elapsed = timed_call_transformed(&transformed, &initial, count_2d,
                                       count_3d, (size_t)kb);
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

  double original_average_ns = (double)original_total_ns / dimensions[3];
  double transformed_average_ns = (double)transformed_total_ns / dimensions[3];
  double difference_ns = transformed_average_ns - original_average_ns;
  double difference_percent = original_average_ns == 0.0
                                  ? 0.0
                                  : difference_ns * 100.0 / original_average_ns;

  printf("ext_profu_ benchmark (%d x %d x %d, %d iterations)\n",
         im, jm, kb, dimensions[3]);
  printf("Original:    total %.3f ms, average %.3f us/call, checksum %.9g\n",
         original_total_ns / 1.0e6, original_average_ns / 1.0e3,
         (double)checksum(&original, count_2d, count_3d));
  printf("Transformed: total %.3f ms, average %.3f us/call, checksum %.9g\n",
         transformed_total_ns / 1.0e6, transformed_average_ns / 1.0e3,
         (double)checksum(&transformed, count_2d, count_3d));
  printf("Difference (transformed - original): %.3f us/call (%+.2f%%)\n",
         difference_ns / 1.0e3, difference_percent);
  printf("Maximum absolute difference across modified arrays: %.9g\n",
         (double)max_difference(&original, &transformed, count_2d, count_3d));
  if (transformed_average_ns > 0.0)
    printf("Speedup (original / transformed): %.3fx\n",
           original_average_ns / transformed_average_ns);

  free_fields(&initial);
  free_fields(&original);
  free_fields(&transformed);
  return EXIT_SUCCESS;
}
#include <chrono>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int im = 0;
int jm = 0;
int kbm1 = 0;

#define ACC2(i, j) ((size_t)(j) * (size_t)im + (size_t)(i))
#define ACC3(i, j, k) ((size_t)(k) * (size_t)jm * (size_t)im + (size_t)(j) * (size_t)im + (size_t)(i))

void ext_adjust_u_v_(float* tps, float* u, float* v, float* dz, float* utb, float* utf,
                     float* vtb, float* vtf, float* dt)
{
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            tps[ACC2(i, j)] = 0.0f;
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                tps[ACC2(i, j)] = tps[ACC2(i, j)] + u[ACC3(i, j, k)] * dz[k];
            }
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 1; i < im; i++)
            {
                u[ACC3(i, j, k)] =
                    (u[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                    (utb[ACC2(i, j)] + utf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]);
            }
        }
    }
    for (int j = 0; j < jm; j++)
    {
        for (int i = 0; i < im; i++)
        {
            tps[ACC2(i, j)] = 0.0f;
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 0; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                tps[ACC2(i, j)] = tps[ACC2(i, j)] + v[ACC3(i, j, k)] * dz[k];
            }
        }
    }
    for (int k = 0; k < kbm1; k++)
    {
        for (int j = 1; j < jm; j++)
        {
            for (int i = 0; i < im; i++)
            {
                v[ACC3(i, j, k)] =
                    (v[ACC3(i, j, k)] - tps[ACC2(i, j)]) +
                    (vtb[ACC2(i, j)] + vtf[ACC2(i, j)]) / (dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]);
            }
        }
    }
}

static void print_first_10(const char* label, const float* values, size_t size)
{
    const size_t count = size < 10 ? size : 10;
    printf("%s [0..%zu]: ", label, count == 0 ? 0 : count - 1);
    for (size_t index = 0; index < count; ++index)
    {
        printf("%.6f", values[index]);
        if (index + 1 != count)
        {
            printf(", ");
        }
    }
    printf("\n");
}

static const int rows = 1024;
static const int cols = 1024;
static const int levels = 20;
static const int64_t numOfSamples = 10;

int main(void)
{
    im = rows;
    jm = cols;
    kbm1 = levels;

    const size_t sz2d = (size_t)im * (size_t)jm;
    const size_t sz3d = (size_t)kbm1 * sz2d;
    const size_t sz1d = (size_t)kbm1;

    float* tps = (float*)malloc(sz2d * sizeof(float));
    float* u = (float*)malloc(sz3d * sizeof(float));
    float* v = (float*)malloc(sz3d * sizeof(float));
    float* dz = (float*)malloc(sz1d * sizeof(float));
    float* utb = (float*)malloc(sz2d * sizeof(float));
    float* utf = (float*)malloc(sz2d * sizeof(float));
    float* vtb = (float*)malloc(sz2d * sizeof(float));
    float* vtf = (float*)malloc(sz2d * sizeof(float));
    float* dt = (float*)malloc(sz2d * sizeof(float));

    if (!tps || !u || !v || !dz || !utb || !utf || !vtb || !vtf || !dt)
    {
        fprintf(stderr, "Allocation failed\n");
        free(tps);
        free(u);
        free(v);
        free(dz);
        free(utb);
        free(utf);
        free(vtb);
        free(vtf);
        free(dt);
        return 1;
    }

    for (size_t index = 0; index < sz2d; ++index)
    {
        const float x = (float)(index % (size_t)im);
        const float y = (float)(index / (size_t)im);
        tps[index] = 0.0f;
        utb[index] = 0.1f * x;
        utf[index] = 0.1f * x + 0.01f;
        vtb[index] = -0.2f * y;
        vtf[index] = -0.2f * y + 0.01f;
        dt[index] = sinf(0.01f * (float)index) + 2.0f;
    }

    for (size_t index = 0; index < sz3d; ++index)
    {
        u[index] = sinf(0.001f * (float)index);
        v[index] = cosf(0.001f * (float)index);
    }

    for (size_t k = 0; k < sz1d; ++k)
    {
        dz[k] = 10.0f + (float)k;
    }

    printf("\n");
    printf("Input snapshots (first 10 values each) (of %d total):\n", rows * cols);
    print_first_10("tps(before)", tps, sz2d);
    print_first_10("u(before)", u, sz3d);
    print_first_10("v(before)", v, sz3d);

    int64_t elapsedUsTotal = 0;
    for (int64_t sample = 0; sample < numOfSamples; ++sample)
    {
        const auto start = std::chrono::high_resolution_clock::now();
        ext_adjust_u_v_(tps, u, v, dz, utb, utf, vtb, vtf, dt);
        const auto end = std::chrono::high_resolution_clock::now();
        elapsedUsTotal +=
            std::chrono::duration_cast<std::chrono::microseconds>(end - start).count();
    }

    const double elapsedMs = (double)elapsedUsTotal * 1e-3;
    const int64_t averageElapsedUs = elapsedUsTotal / numOfSamples;
    const double averageElapsedMs = (double)averageElapsedUs * 1e-3;

    printf("\n");
    printf("Number of function calls initiated: %lld\n", (long long)numOfSamples);
    printf("cpu call time: total: %lld us (%.3f ms) average: %lld us (%.3f ms)\n\n",
           (long long)elapsedUsTotal,
           elapsedMs,
           (long long)averageElapsedUs,
           averageElapsedMs);

    printf("Output snapshots (same buffers after call, first 10 values each):\n");
    print_first_10("tps(after)", tps, sz2d);
    print_first_10("u(after)", u, sz3d);
    print_first_10("v(after)", v, sz3d);

    free(tps);
    free(u);
    free(v);
    free(dz);
    free(utb);
    free(utf);
    free(vtb);
    free(vtf);
    free(dt);

    return 0;
}

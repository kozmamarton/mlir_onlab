#include <algorithm>
#include <chrono>
#include <math.h>
#include <memory>
#include <stdint.h>
#include <stdio.h>

int im = 0;
int jm = 0;
int kbm1 = 0;

#define ACC2DFULL(i, j, sx, sy) ((i) + (j)*sx)
#define ACC2(i, j) ACC2DFULL(i, j, im, jm)
#define ACC3DFULL(i, j, k, sx, sy, sz) ((i) + (j)*sx + (k)*sx*sy)
#define ACC3(i, j, k) ACC3DFULL(i, j, k, im, jm, kbm1)


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

static const int rows = 8196*2;
static const int cols = 8196*2;
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

    auto initialTps = std::make_unique<float[]>(sz2d);
    auto initialU = std::make_unique<float[]>(sz3d);
    auto initialV = std::make_unique<float[]>(sz3d);
    auto dz = std::make_unique<float[]>(sz1d);
    auto utb = std::make_unique<float[]>(sz2d);
    auto utf = std::make_unique<float[]>(sz2d);
    auto vtb = std::make_unique<float[]>(sz2d);
    auto vtf = std::make_unique<float[]>(sz2d);
    auto dt = std::make_unique<float[]>(sz2d);

    for (size_t index = 0; index < sz2d; ++index)
    {
        const float x = (float)(index % (size_t)im);
        const float y = (float)(index / (size_t)im);
        initialTps[index] = 0.0f;
        utb[index] = 0.1f * x;
        utf[index] = 0.1f * x + 0.01f;
        vtb[index] = -0.2f * y;
        vtf[index] = -0.2f * y + 0.01f;
        dt[index] = sinf(0.01f * (float)index) + 2.0f;
    }

    for (size_t index = 0; index < sz3d; ++index)
    {
        initialU[index] = sinf(0.001f * (float)index);
        initialV[index] = cosf(0.001f * (float)index);
    }

    for (size_t k = 0; k < sz1d; ++k)
    {
        dz[k] = 10.0f + (float)k;
    }

    auto tps = std::make_unique<float[]>(sz2d);
    auto u = std::make_unique<float[]>(sz3d);
    auto v = std::make_unique<float[]>(sz3d);
    std::copy_n(initialTps.get(), sz2d, tps.get());
    std::copy_n(initialU.get(), sz3d, u.get());
    std::copy_n(initialV.get(), sz3d, v.get());

    printf("\n");
    printf("Input snapshots (first 10 values each) (of %d total):\n", rows * cols);
    print_first_10("tps(before)", tps.get(), sz2d);
    print_first_10("u(before)", u.get(), sz3d);
    print_first_10("v(before)", v.get(), sz3d);

    int64_t elapsedUsTotal = 0;
    for (int64_t sample = 0; sample < numOfSamples; ++sample)
    {
        std::copy_n(initialTps.get(), sz2d, tps.get());
        std::copy_n(initialU.get(), sz3d, u.get());
        std::copy_n(initialV.get(), sz3d, v.get());
        const auto start = std::chrono::high_resolution_clock::now();
        ext_adjust_u_v_(tps.get(),
                u.get(),
                v.get(),
                dz.get(),
                utb.get(),
                utf.get(),
                vtb.get(),
                vtf.get(),
                dt.get());
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
    print_first_10("tps(after)", tps.get(), sz2d);
    print_first_10("u(after)", u.get(), sz3d);
    print_first_10("v(after)", v.get(), sz3d);

    return 0;
}

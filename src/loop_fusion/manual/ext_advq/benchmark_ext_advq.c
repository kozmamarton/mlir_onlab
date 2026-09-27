#include "../pom2k_fun.h"

#include <chrono>
#include <cerrno>
#include <cmath>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>

static void ext_advq_original(
	real_t *qb, real_t *q, real_t *qf, real_t *xflux, real_t *yflux,
	real_t *dt, real_t *u, real_t *v, real_t *aam, real_t *h, real_t *dum,
	real_t *dx, real_t *dvm, real_t *dy, real_t *w, real_t *dz, real_t *art,
	real_t *etb, real_t *etf)
{
	for (int k = 1; k < kbm1; ++k) {
		for (int j = 1; j < jm; ++j) {
			for (int i = 1; i < im; ++i) {
				xflux[ACC3(i, j, k)] =
					0.125f * (q[ACC3(i, j, k)] + q[ACC3(i - 1, j, k)]) *
					(dt[ACC2(i, j)] + dt[ACC2(i - 1, j)]) *
					(u[ACC3(i, j, k)] + u[ACC3(i, j, k - 1)]);
				yflux[ACC3(i, j, k)] =
					0.125f * (q[ACC3(i, j, k)] + q[ACC3(i, j - 1, k)]) *
					(dt[ACC2(i, j)] + dt[ACC2(i, j - 1)]) *
					(v[ACC3(i, j, k)] + v[ACC3(i, j, k - 1)]);
			}
		}
	}

	for (int k = 1; k < kbm1; ++k) {
		for (int j = 1; j < jm; ++j) {
			for (int i = 1; i < im; ++i) {
				xflux[ACC3(i, j, k)] -= dum[ACC2(i, j)] * 0.25f *
					(aam[ACC3(i, j, k)] + aam[ACC3(i - 1, j, k)] +
					 aam[ACC3(i, j, k - 1)] + aam[ACC3(i - 1, j, k - 1)]) *
					(h[ACC2(i, j)] + h[ACC2(i - 1, j)]) *
					(qb[ACC3(i, j, k)] - qb[ACC3(i - 1, j, k)]) /
					(dx[ACC2(i, j)] + dx[ACC2(i - 1, j)]);
				yflux[ACC3(i, j, k)] -= dvm[ACC2(i, j)] * 0.25f *
					(aam[ACC3(i, j, k)] + aam[ACC3(i, j - 1, k)] +
					 aam[ACC3(i, j, k - 1)] + aam[ACC3(i, j - 1, k - 1)]) *
					(h[ACC2(i, j)] + h[ACC2(i, j - 1)]) *
					(qb[ACC3(i, j, k)] - qb[ACC3(i, j - 1, k)]) /
					(dy[ACC2(i, j)] + dy[ACC2(i, j - 1)]);
				xflux[ACC3(i, j, k)] *=
					0.5f * (dy[ACC2(i, j)] + dy[ACC2(i - 1, j)]);
				yflux[ACC3(i, j, k)] *=
					0.5f * (dx[ACC2(i, j)] + dx[ACC2(i, j - 1)]);
			}
		}
	}

	for (int k = 1; k < kbm1; ++k) {
		for (int j = 1; j < jmm1; ++j) {
			for (int i = 1; i < imm1; ++i) {
				qf[ACC3(i, j, k)] =
					(w[ACC3(i, j, k - 1)] * q[ACC3(i, j, k - 1)] -
					 w[ACC3(i, j, k + 1)] * q[ACC3(i, j, k + 1)]) *
						art[ACC2(i, j)] / (dz[k] + dz[k - 1]) +
					xflux[ACC3(i + 1, j, k)] - xflux[ACC3(i, j, k)] +
					yflux[ACC3(i, j + 1, k)] - yflux[ACC3(i, j, k)];
				qf[ACC3(i, j, k)] =
					((h[ACC2(i, j)] + etb[ACC2(i, j)]) * art[ACC2(i, j)] *
						 qb[ACC3(i, j, k)] - dti2 * qf[ACC3(i, j, k)]) /
					((h[ACC2(i, j)] + etf[ACC2(i, j)]) * art[ACC2(i, j)]);
			}
		}
	}
}

struct Fields {
	std::vector<real_t> qb, q, qf, xflux, yflux, u, v, aam, w;
	std::vector<real_t> dt, h, dum, dx, dvm, dy, art, etb, etf, dz;
};

static Fields make_fields(size_t count_2d, size_t count_3d, size_t levels)
{
	Fields fields;
	fields.qb.resize(count_3d);
	fields.q.resize(count_3d);
	fields.qf.resize(count_3d);
	fields.xflux.resize(count_3d);
	fields.yflux.resize(count_3d);
	fields.u.resize(count_3d);
	fields.v.resize(count_3d);
	fields.aam.resize(count_3d);
	fields.w.resize(count_3d);
	fields.dt.resize(count_2d);
	fields.h.resize(count_2d);
	fields.dum.resize(count_2d);
	fields.dx.resize(count_2d);
	fields.dvm.resize(count_2d);
	fields.dy.resize(count_2d);
	fields.art.resize(count_2d);
	fields.etb.resize(count_2d);
	fields.etf.resize(count_2d);
	fields.dz.resize(levels);
	return fields;
}

static void initialize_fields(Fields &fields)
{
	for (size_t i = 0; i < fields.qb.size(); ++i) {
		fields.qb[i] = 0.4f + static_cast<real_t>(i % 43) * 0.001f;
		fields.q[i] = 0.3f + static_cast<real_t>(i % 37) * 0.001f;
		fields.qf[i] = 0.0f;
		fields.xflux[i] = 0.0f;
		fields.yflux[i] = 0.0f;
		fields.u[i] = 0.02f + static_cast<real_t>(i % 13) * 0.0001f;
		fields.v[i] = 0.01f + static_cast<real_t>(i % 17) * 0.0001f;
		fields.aam[i] = 0.005f;
		fields.w[i] = 0.001f;
	}
	for (size_t i = 0; i < fields.dt.size(); ++i) {
		fields.dt[i] = 1.0f;
		fields.h[i] = 10.0f + static_cast<real_t>(i % 29) * 0.001f;
		fields.dum[i] = 1.0f;
		fields.dx[i] = 1.0f;
		fields.dvm[i] = 1.0f;
		fields.dy[i] = 1.0f;
		fields.art[i] = 1.0f;
		fields.etb[i] = 0.1f;
		fields.etf[i] = 0.1f;
	}
	for (size_t k = 0; k < fields.dz.size(); ++k)
		fields.dz[k] = 1.0f / static_cast<real_t>(fields.dz.size());
}

static void call_original(Fields &f)
{
	ext_advq_original(f.qb.data(), f.q.data(), f.qf.data(), f.xflux.data(),
					  f.yflux.data(), f.dt.data(), f.u.data(), f.v.data(),
					  f.aam.data(), f.h.data(), f.dum.data(), f.dx.data(),
					  f.dvm.data(), f.dy.data(), f.w.data(), f.dz.data(),
					  f.art.data(), f.etb.data(), f.etf.data());
}

static void call_transformed(Fields &f)
{
	ext_advq_transformed(f.qb.data(), f.q.data(), f.qf.data(), f.xflux.data(),
						 f.yflux.data(), f.dt.data(), f.u.data(), f.v.data(),
						 f.aam.data(), f.h.data(), f.dum.data(), f.dx.data(),
						 f.dvm.data(), f.dy.data(), f.w.data(), f.dz.data(),
						 f.art.data(), f.etb.data(), f.etf.data());
}

template <typename Function>
static int64_t timed_call(Fields &fields, const Fields &initial, Function call)
{
	fields = initial;
	const auto start = std::chrono::steady_clock::now();
	call(fields);
	const auto end = std::chrono::steady_clock::now();
	return std::chrono::duration_cast<std::chrono::nanoseconds>(end - start).count();
}

static double checksum(const Fields &fields)
{
	double sum = 0.0;
	for (size_t i = 0; i < fields.qf.size(); ++i)
		sum += fields.qf[i] + fields.xflux[i] + fields.yflux[i];
	return sum;
}

static real_t max_difference(const Fields &left, const Fields &right)
{
	real_t maximum = 0.0f;
	const std::vector<real_t> *left_outputs[] = {&left.qf, &left.xflux, &left.yflux};
	const std::vector<real_t> *right_outputs[] = {&right.qf, &right.xflux, &right.yflux};
	for (size_t array = 0; array < 3; ++array) {
		for (size_t i = 0; i < left_outputs[array]->size(); ++i) {
			const real_t difference = std::fabs((*left_outputs[array])[i] -
												(*right_outputs[array])[i]);
			if (difference > maximum)
				maximum = difference;
		}
	}
	return maximum;
}

static bool parse_positive(const char *text, int &value)
{
	char *end = nullptr;
	errno = 0;
	const long parsed = std::strtol(text, &end, 10);
	if (errno != 0 || *text == '\0' || *end != '\0' || parsed <= 0 || parsed > 100000)
		return false;
	value = static_cast<int>(parsed);
	return true;
}

int main(int argc, char **argv)
{
	int dimensions[] = {65, 49, 21, 100};
	const char *dimension_names[] = {"im", "jm", "kb", "iterations"};
	if (argc > 5) {
		std::fprintf(stderr, "Usage: %s [im jm kb iterations]\n", argv[0]);
		return EXIT_FAILURE;
	}
	for (int argument = 1; argument < argc; ++argument) {
		if (!parse_positive(argv[argument], dimensions[argument - 1])) {
			std::fprintf(stderr, "Invalid positive integer for %s: %s\n",
						 dimension_names[argument - 1], argv[argument]);
			return EXIT_FAILURE;
		}
	}
	im = dimensions[0];
	jm = dimensions[1];
	kb = dimensions[2];
	if (im < 3 || jm < 3 || kb < 4) {
		std::fprintf(stderr, "Dimensions must satisfy im >= 3, jm >= 3, kb >= 4.\n");
		return EXIT_FAILURE;
	}
	imm1 = im - 1;
	jmm1 = jm - 1;
	kbm1 = kb - 1;
	kbm2 = kb - 2;
	dti2 = 0.1f;

	const size_t count_2d = static_cast<size_t>(im) * static_cast<size_t>(jm);
	const size_t count_3d = count_2d * static_cast<size_t>(kb);
	Fields initial = make_fields(count_2d, count_3d, static_cast<size_t>(kb));
	Fields original = initial;
	Fields transformed = initial;
	initialize_fields(initial);

	for (int warmup = 0; warmup < 3; ++warmup) {
		(void)timed_call(original, initial, call_original);
		(void)timed_call(transformed, initial, call_transformed);
	}

	int64_t original_total_ns = 0;
	int64_t transformed_total_ns = 0;
	for (int iteration = 0; iteration < dimensions[3]; ++iteration) {
		if ((iteration & 1) == 0) {
			original_total_ns += timed_call(original, initial, call_original);
			transformed_total_ns += timed_call(transformed, initial, call_transformed);
		} else {
			transformed_total_ns += timed_call(transformed, initial, call_transformed);
			original_total_ns += timed_call(original, initial, call_original);
		}
	}

	const double original_average_ns = static_cast<double>(original_total_ns) / dimensions[3];
	const double transformed_average_ns = static_cast<double>(transformed_total_ns) / dimensions[3];
	const double difference_ns = transformed_average_ns - original_average_ns;
	const double difference_percent = original_average_ns == 0.0
										  ? 0.0
										  : difference_ns * 100.0 / original_average_ns;
	std::printf("ext_advq_ benchmark (%d x %d x %d, %d iterations)\n",
				im, jm, kb, dimensions[3]);
	std::printf("Original:    total %.3f ms, average %.3f us/call, checksum %.12g\n",
				original_total_ns / 1.0e6, original_average_ns / 1.0e3,
				checksum(original));
	std::printf("Transformed: total %.3f ms, average %.3f us/call, checksum %.12g\n",
				transformed_total_ns / 1.0e6, transformed_average_ns / 1.0e3,
				checksum(transformed));
	std::printf("Difference (transformed - original): %.3f us/call (%+.2f%%)\n",
				difference_ns / 1.0e3, difference_percent);
	std::printf("Maximum absolute difference across outputs: %.9g\n",
				static_cast<double>(max_difference(original, transformed)));
	if (transformed_average_ns > 0.0)
		std::printf("Speedup (original / transformed): %.3fx\n",
					original_average_ns / transformed_average_ns);
	return EXIT_SUCCESS;
}

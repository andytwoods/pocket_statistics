import 'dart:math';

double ldexp(double x, int e) => x * pow(2, e);

/// Calculates logn 1+x
double log1p(double x) {
	if (x.isInfinite && !x.isNegative) {
		return x;
	} else {
		final double u = 1 + x;
		final double d = u - 1;

		if (d == 0) {
			return x;
		} else {
			return log(u) * x / d;
		}
	}
}
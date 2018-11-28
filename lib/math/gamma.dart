import 'dart:math';
import 'package:pocket_statistics/math/math.dart';

double gamma(double x) {
  const double _euler =
      0.57721566490153286060651209008240243104215933593992; // A001620

  // Special cases
  if (x.isNegative && Double.fractionPart(x) == 0) {
    return double.nan;
  }

  if ((x.isInfinite && x.isNegative) || x.isNaN) {
    return double.nan;
  }

  if (x.isInfinite) return double.infinity;

  if (x == 0) {
    if (x.isNegative) return double.negativeInfinity;
    return double.infinity;
  }

  double q = x.abs();
  double p = q.floorToDouble();

  if (q > 33) {
    if (x >= 0) {
      List<double> y = _stirling(x);
      return y.first * y.last;
    }
    // Note: x is negative but (checked above) not a negative integer,
    // so x must be small enough to be in range for conversion to int64.
    // If |x| were >= 2⁶³ it would have to be an integer.
    int signgam = 1;
    {
      final int ip = p.toInt();
      if (ip & 1 == 0) {
        signgam = -1;
      }
    }
    double z = q - p;
    if (z > 0.5) {
      p = p + 1;
      z = q - p;
    }
    z = q * sin(pi * z);
    if (z == 0) {
      return signgam > 0 ? double.infinity : double.negativeInfinity;
    }
    final List<double> sq = _stirling(q);
    final double absz = z.abs();
    final double d = absz * sq.first * sq.last;
    if (d.isInfinite) {
      z = pi / absz / sq.first / sq.last;
    } else {
      z = pi / d;
    }
    return signgam * z;
  }

  // Reduce argument
  double z = 1.0;
  while (x >= 3) {
    x = x - 1;
    z = z * x;
  }
  while (x < 0) {
    if (x > -1e-09) {
      if (x == 0) {
        return double.infinity;
      }
      return z / ((1 + _euler * x) * x);
    }
    z = z / x;
    x = x + 1;
  }
  while (x < 2) {
    if (x < 1e-09) {
      if (x == 0) {
        return double.infinity;
      }
      return z / ((1 + _euler * x) * x);
    }
    z = z / x;
    x = x + 1;
  }

  if (x == 2) {
    return z;
  }

  x = x - 2;
  p = (((((x * _gamP[0] + _gamP[1]) * x + _gamP[2]) * x + _gamP[3]) * x +
                      _gamP[4]) *
                  x +
              _gamP[5]) *
          x +
      _gamP[6];
  q = ((((((x * _gamQ[0] + _gamQ[1]) * x + _gamQ[2]) * x + _gamQ[3]) * x +
                              _gamQ[4]) *
                          x +
                      _gamQ[5]) *
                  x +
              _gamQ[6]) *
          x +
      _gamQ[7];
  return z * p / q;
}

List<double> _stirling(double x) {
	if (x > 200) {
		return <double>[double.infinity, 1.0];
	}

	const double sqrtTwoPi = 2.506628274631000502417;
	const double maxStirling = 143.01608;

	double w = 1 / x;
	w = 1 +
			w *
					((((_gamS[0] * w + _gamS[1]) * w + _gamS[2]) * w + _gamS[3]) * w +
							_gamS[4]);
	double y1 = exp(x);
	double y2 = 1.0;
	if (x > maxStirling) {
		// avoid Pow() overflow
		double v = pow(x, 0.5 * x - 0.25);
		y1 = v;
		y2 = v / y1;
	} else {
		y1 = pow(x, x - 0.5) / y1;
	}
	return <double>[y1, sqrtTwoPi * w * y2];
}

const List<double> _gamP = const <double>[
  1.60119522476751861407e-04,
  1.19135147006586384913e-03,
  1.04213797561761569935e-02,
  4.76367800457137231464e-02,
  2.07448227648435975150e-01,
  4.94214826801497100753e-01,
  9.99999999999999996796e-01,
];

const List<double> _gamQ = const <double>[
  -2.31581873324120129819e-05,
  5.39605580493303397842e-04,
  -4.45641913851797240494e-03,
  1.18139785222060435552e-02,
  3.58236398605498653373e-02,
  -2.34591795718243348568e-01,
  7.14304917030273074085e-02,
  1.00000000000000000320e+00,
];

const List<double> _gamS = const <double>[
  7.87311395793093628397e-04,
  -2.29549961613378126380e-04,
  -2.68132617805781232825e-03,
  3.47222221605458667310e-03,
  8.33333333333482257126e-02,
];

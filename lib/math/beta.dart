

import 'dart:math';

import 'package:statistical_power/math/gamma.dart';
import 'package:statistical_power/math/lgamma.dart';

/// The  regularized lower incomplete gamma function.
/// Code kanged from SAMTools:
/// https://github.com/lh3/samtools/blob/master/bcftools/kfunc.c
double gammaIncLower(double s, double z) {
  const double _gammaEpsilon = 1e-14;
  double x = 1.0;
  double sum = 1.0;
  for (double k = 1.0; k < 100; k++) {
    x *= z / (s + k);
    sum += x;
    if (x / sum < _gammaEpsilon) {
      break;
    }
  }
  final double lgam = lgamma(s + 1).lgamma;
  return exp((s * log(z)) - z - lgam + log(sum));
}

/// Beta function
double beta(double a, double b) {
  final lst = <double>[a, b];
  double product = 1.0;
  double sum = 0.0;
  for (double ai in lst) {
    product *= gamma(ai);
    sum += ai;
  }
  return product / gamma(sum);
}

/// The incomplete beta function.
/// See: https://en.wikipedia.org/wiki/Beta_function#Incomplete_beta_function
double ibeta(double a, double b, double x) {
  return ibetaReg(a, b, x) * beta(a, b);
}

/// The regularized incomplete beta function.
/// See: https://en.wikipedia.org/wiki/Beta_function#Incomplete_beta_function
double ibetaReg(double a, double b, double x) {
  if (x == 0.0) {
    return 0.0;
  }
  if (x == 1.0) {
    return 1.0;
  }
  final double lab = lgamma(a + b).lgamma;
  final double la = lgamma(a).lgamma;
  final double lb = lgamma(b).lgamma;
  final lbeta = lab - la - lb + (a * log(x)) + (b * log(1 - x));
  if (x < (a + 1) / (a + b + 2)) {
    return exp(lbeta) * _contFracBeta(a, b, x) / a;
  }
  return 1 - exp(lbeta) * _contFracBeta(b, a, 1 - x) / b;
}

/// Evaluates the continued fraction form of the incomplete Beta function
/// Ref: https://malishoaib.wordpress.com/2014/04/15/the-beautiful-beta-functions-in-raw-python/
double _contFracBeta(double a, double b, double x) {
  const double _betaEpsilon = 2.2204460492503131e-16;
  const double _betaIterations = 1e9;

  double am = 1.0;
  double bm = 1.0;
  double az = 1.0;
  final double qab = a + b;
  final double qap = a + 1.0;
  final double qam = a - 1.0;
  double bz = 1.0 - (qab * x / qap);
  for (double i = 0.0; i <= _betaIterations; i += 1.0) {
    final double em = i + 1.0;
    final double tem = em + em;
    double d = em * (b - em) * x / ((qam + tem) * (a + tem));
    final double ap = az + (d * am);
    final double bp = bz + (d * bm);
    d = -(a + em) * (qab + em) * x / ((qap + tem) * (a + tem));
    final double app = ap + (d * az);
    final double bpp = bp + (d * bz);
    final double aold = az;
    am = ap / bpp;
    bm = bp / bpp;
    az = app / bpp;
    bz = 1.0;
    if ((az - aold).abs() < _betaEpsilon * (az).abs()) {
      return az;
    }
  }
  return double.nan;
}

/// Computes inverse of incomplete beta function
/// https://malishoaib.wordpress.com/2014/05/30/inverse-of-incomplete-beta-function-computational-statisticians-wet-dream/
double ibetaInv(double a, double b, double p) {
  final double a1 = a - 1.0;
  final double b1 = b - 1.0;
  const double error = 1e-8;

  if (p <= 0.0) return 0.0;
  if (p >= 1.0) return 1.0;

  double x;

  if (a >= 1.0 && b >= 1.0) {
    double pp;

    if (p < 0.5)
      pp = p;
    else
      pp = 1.0 - p;

    double t = sqrt(-2 * log(pp));
    x = (2.30753 + t * 0.27061) / (1.0 + t * (0.99229 + t * 0.04481)) - t;
    if (p < 0.5) x = -x;
    double al = ((x * x) - 3.0) / 6.0;
    double h = 2.0 / (1.0 / (2.0 * a - 1.0) + 1.0 / (2.0 * b - 1.0));
    double w = (x * sqrt(al + h) / h) -
        (1.0 / (2.0 * b - 1) - 1.0 / (2.0 * a - 1.0)) *
            (al + 5.0 / 6.0 - 2.0 / (3.0 * h));
    x = a / (a + b * exp(2.0 * w));
  } else {
    double lna = log(a / (a + b));
    double lnb = log(b / (a + b));
    double t = exp(a * lna) / a;
    double u = exp(b * lnb) / b;
    double w = t + u;
    if (p < t / w)
      x = pow(a * w * p, 1.0 / a);
    else
      x = 1.0 - pow(b * w * (1.0 - p), 1.0 / b);
  }

  double afac = -lgamma(a).lgamma - lgamma(b).lgamma + lgamma(a + b).lgamma;
  double j = 0.0;
  for (int i = 0; i < 10; i++) {
    if (x == 1.0) return x;
    double err = ibetaReg(a, b, x) - p;
    double t = exp(a1 * log(x) + b1 * log(1.0 - x) + afac);
    double u = err / t;
    t = u / (1.0 - 0.5 * min(1.0, u * (a1 / x - b1 / (1.0 - x))));
    x -= t;
    if (x <= 0.0) x = 0.5 * (x + t);
    if (x >= 1.0) x = 0.5 * (x + t + 1.0);
    if ((t.abs() < error * x) && (j > 0)) break;
  }

  return x;
}

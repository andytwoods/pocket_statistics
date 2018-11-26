
import 'dart:math';

import 'package:statistical_power/dists/dists.dart';
import 'package:statistical_power/dists/gamma.dart';
import 'package:statistical_power/math/beta.dart' as mybeta;

/// The Beta  Distribution is a continuous probability distribution
/// with parameters α > 0, β >= 0.
///
/// See: https://en.wikipedia.org/wiki/Beta_distribution
class Beta extends ContinuousRV {
  final double alpha;

  final double beta;

  final double _apb;

  final double _amb;

  final double _ab;

  Beta._(this.alpha, this.beta)
      : _apb = alpha + beta,
        _amb = alpha - beta,
        _ab = alpha * beta;

  factory Beta(double alpha, double beta) {
    if (alpha <= 0) {
      throw new ArgumentError.value(
          alpha, 'alpha', "Alpha must be greater than zero.");
    }
    if (beta <= 0) {
      throw new ArgumentError.value(
          beta, 'beta', "Beta must be greater than zero.");
    }

    return new Beta._(alpha, beta);
  }

  double mean() => alpha / _apb;

  double variance() {
    return _ab / (_apb * _apb * (_apb + 1));
  }

  double skewness() {

    final double numerator = 2 * (-_amb) * sqrt(_apb + 1);
    final double denominator = ((_apb + 2) * sqrt(_ab));
    return numerator / denominator;
  }

  double kurtosis() {
    final double first = _amb * _amb * (_apb + 1);
    final double second = _ab * (_apb + 2);
    final double denom = _ab * (_apb + 2) * (_apb + 3);
    return 6 * (first - second) / denom;
  }

  double std() => sqrt(variance());

  double relStd() => std() / mean();

  RandDistStats stats() =>
      new RandDistStats(mean(), variance(), skewness(), kurtosis(), std());

  double pdf(double x) {
    final b = mybeta.beta(alpha, beta);
    return pow(x, alpha - 1) * pow(1 - x, beta - 1) / b;
  }

  double cdf(double x) {
    return mybeta.ibetaReg(alpha, beta, x);
  }

  double ppf(double q) => mybeta.ibetaInv(alpha, beta, q);

  double sample() {
    //TODO
    throw new UnimplementedError();
  }

  double sampleMany(int count) {
    //TODO
    throw new UnimplementedError();
  }

  static double betacf(x, a, b) {
    double fpmin = 1e-30;
    double m = 1.0;
    double qab = a + b;
    double qap = a + 1;
    double qam = a - 1;
    double c = 1.0;
    double d = 1 - qab * x / qap;
    double m2, aa, del, h;

    // These q's will be used in factors that occur in the coefficients
    if (d.abs() < fpmin)
      d = fpmin;
    d = 1 / d;
    h = d;

    for (; m <= 100; m++) {
      m2 = 2 * m;
      aa = m * (b - m) * x / ((qam + m2) * (a + m2));
      // One step (the even one) of the recurrence
      d = 1 + aa * d;
      if (d.abs() < fpmin)
        d = fpmin;
      c = 1 + aa / c;
      if (c.abs() < fpmin)
        c = fpmin;
      d = 1 / d;
      h *= d * c;
      aa = -(a + m) * (qab + m) * x / ((a + m2) * (qap + m2));
      // Next step of the recurrence (the odd one)
      d = 1 + aa * d;
      if (d.abs() < fpmin)
        d = fpmin;
      c = 1 + aa / c;
      if (c.abs() < fpmin)
        c = fpmin;
      d = 1 / d;
      del = d * c;
      h *= del;
      if ((del - 1.0).abs() < 3e-7)
        break;
    }

    return h;
  }

  static double ibeta(double x, double a, double b) {
    // Factors in front of the continued fraction.
    double bt = (x == 0 || x == 1) ?  0 :
    exp(Gamma.gammaln(a + b) - Gamma.gammaln(a) -
        Gamma.gammaln(b) + a * log(x) + b *
        log(1 - x));
    if (x < 0 || x > 1)
      return -100000.0;
    if (x < (a + 1) / (a + b + 2))
      // Use continued fraction directly.
      return bt * betacf(x, a, b) / a;
    // else use continued fraction after making the symmetry transformation.
    return 1 - bt * betacf(1 - x, b, a) / b;
  }

  static double ibetainv(double p, double a, double b) {
    double EPS = 1e-8;
    double a1 = a - 1;
    double b1 = b - 1;

    double lna, lnb, pp, t, u, err, x, al, h, w, afac;
    if (p <= 0)
      return 0.0;
    if (p >= 1)
      return 1.0;
    if (a >= 1 && b >= 1) {
      pp = (p < 0.5) ? p : 1 - p;
      t = sqrt(-2 * log(pp));
      x = (2.30753 + t * 0.27061) / (1 + t* (0.99229 + t * 0.04481)) - t;
      if (p < 0.5)
        x = -x;
      al = (x * x - 3) / 6;
      h = 2 / (1 / (2 * a - 1)  + 1 / (2 * b - 1));
      w = (x * sqrt(al + h) / h) - (1 / (2 * b - 1) - 1 / (2 * a - 1)) *
          (al + 5 / 6 - 2 / (3 * h));
      x = a / (a + b * exp(2 * w));
    } else {
      lna = log(a / (a + b));
      lnb = log(b / (a + b));
      t = exp(a * lna) / a;
      u = exp(b * lnb) / b;
      w = t + u;
      if (p < t / w)
        x = pow(a * w * p, 1 / a);
      else
        x = 1 - pow(b * w * (1 - p), 1 / b);
    }
    afac = -Gamma.gammaln(a) - Gamma.gammaln(b) + Gamma.gammaln(a + b);
    for(int j=0; j < 10; j++) {
      if (x == 0 || x == 1)
        return x;
      err = ibeta(x, a, b) - p;
      t = exp(a1 * log(x) + b1 * log(1 - x) + afac);
      u = err / t;
      x -= (t = u / (1 - 0.5 * min(1, u * (a1 / x - b1 / (1 - x)))));
      if (x <= 0)
        x = 0.5 * (x + t);
      if (x >= 1)
        x = 0.5 * (x + t + 1);
      if (t.abs() < EPS * x && j > 0)
        break;
    }
    return x;
  }
}

//TODO test with x values out of range
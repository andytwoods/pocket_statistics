
import 'dart:math';

import 'package:statistical_power/dists/dists.dart';
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
}

//TODO test with x values out of range
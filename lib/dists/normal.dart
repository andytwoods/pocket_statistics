import 'dart:math';

import 'package:statistical_power/dists/dists.dart';
import 'package:statistical_power/math/erf.dart';
import 'package:statistical_power/math/normal.dart';

/// The Normal(or Gaussian) Distribution is a continuous probability distribution
/// with parameters μ, σ >= 0.
///
/// See: https://en.wikipedia.org/wiki/Normal_distribution
class Normal extends ContinuousRV {
  final double mu;

  final double sigma;

  Normal._(this.mu, this.sigma);

  factory Normal(double mu, double sigma) {
    if (sigma < 0) {
      throw new ArgumentError.value(
          sigma, 'sigma', 'Must be greater than zero');
    }
    return new Normal._(mu, sigma);
  }

  double mean() => mu;

  double variance() => sigma * sigma;

  double skewness() => 0.0;

  double kurtosis() => 3.0;

  double std() => sigma;

  double relStd() => sigma / mu;

  double pdf(double x) {
    final double diff = x - mu;
    final double expo = -1 * diff * diff / (2 * variance());
    final double denom = sqrt(2 * variance() * pi);
    return exp(expo) / denom;
  }

  double cdf(double x) {
    return .5 * (1 + error((x - mu) / (sigma * sqrt(2))));
  }

  double ppf(double q) => normalInv(q);

  double sample() {
    //TODO
    throw new UnimplementedError();
  }

  double sampleMany(int count) {
    //TODO
    throw new UnimplementedError();
  }

  double error(double x) {
    double t = 1.0 / (1 + .5 * x.abs());
    double tau = t *
        exp(-(x * x) -
            1.26551223 +
            1.00002368 * t +
            0.37409196 * pow(t, 2) +
            0.09678418 * pow(t, 3) -
            0.18628806 * pow(t, 4) +
            0.27886807 * pow(t, 5) -
            1.13520398 * pow(t, 6) +
            1.48851587 * pow(t, 7) -
            0.82215223 * pow(t, 8) +
            0.17087277 * pow(t, 9));
    return (x >= 0) ? 1 - tau : tau - 1;
  }
}

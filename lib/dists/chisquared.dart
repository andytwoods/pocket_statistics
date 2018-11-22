
import 'dart:math';

import 'package:statistical_power/dists/dists.dart';
import 'package:statistical_power/math/beta.dart';
import 'package:statistical_power/math/lgamma.dart';

/// The ChiSquared Distribution is a continuous probability distribution
/// with parameters df > 0.
///
/// See: https://en.wikipedia.org/wiki/Chi-squared_distribution
class ChiSquared extends ContinuousRV {
  final double degrees;

  ChiSquared._(this.degrees);

  factory ChiSquared(double degrees) {
    if (degrees <= 0) {
      throw new ArgumentError.value(
          degrees, 'degrees', 'Must be greater than zero');
    }
    return new ChiSquared._(degrees);
  }

  double mean() => degrees;

  double variance() => 2 * degrees;

  double skewness() => pow(2, 1.5) / sqrt(degrees);

  double kurtosis() => 3 + (12 / degrees);

  double std() => sqrt(2 * degrees);

  double relStd() => sqrt(2 / degrees);

  double pdf(double x) {
    if (x < 0) {
      return 0.0;
    }
    if (degrees == 2) {
      return exp(-x / 2) / 2;
    }
    double lg = lgamma(degrees / 2).lgamma;
    return exp((((degrees / 2) - 1) * log(x / 2)) - (x / 2) - lg) / 2;
  }

  double cdf(double x) {
    if (x < 0) {
      return 0.0;
    }
    if (degrees == 2) {
      return 1 - exp(-x / 2);
    }
    return gammaIncLower(degrees / 2, x / 2);
  }

  double ppf(double q) {
    //TODO
    throw new UnimplementedError();
  }

  double sample() {
    //TODO
    throw new UnimplementedError();
  }

  double sampleMany(int count) {
    //TODO
    throw new UnimplementedError();
  }
}

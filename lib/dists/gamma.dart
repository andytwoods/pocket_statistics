

import 'dart:math';
import 'package:statistical_power/math/lgamma.dart' as myLGamma;
import 'package:statistical_power/dists/dists.dart';
import 'package:statistical_power/math/beta.dart';

/// The Gamma Distribution is a continuous probability distribution
/// with parameters α > 0, β > 0.
///
/// See: https://en.wikipedia.org/wiki/Gamma_distribution
class Gamma extends ContinuousRV {
  final double shape;

  final double rate;

  Gamma._(this.shape, this.rate);

  factory Gamma(double shape, double rate) {
    if (shape <= 0) {
      throw new ArgumentError.value(
          shape, 'shape', 'Must be greater than zero');
    }
    if (rate <= 0) {
      throw new ArgumentError.value(rate, 'rate', 'Must be greater than zero');
    }
    return new Gamma._(shape, rate);
  }

  double mean() => shape / rate;

  double variance() => shape / (rate * rate);

  double skewness() => 2 / sqrt(shape);

  double kurtosis() => 6 / shape;

  double std() => sqrt(shape / (rate * rate));

  @override
  double relStd() => 1 / sqrt(shape);

  @override
  double pdf(double x) {
    if (x < 0) {
      return 0.0;
    }
    if (x == 0) {
      if (shape == 1) {
        return rate;
      }
      return 0.0;
    }
    if (shape == 1) {
      return exp((-1 * x) * rate) * rate;
    }
    double first = (shape - 1) * log(x * rate) - (x * rate);
    double lgamma = myLGamma.lgamma(shape).lgamma;
    return exp(first - lgamma) * rate;
  }

  @override
  double cdf(double x) {
    if (x <= 0) {
      return 0.0;
    }
    return gammaIncLower(shape, x * rate);
  }

  double ppf(double q) {
    //TODO
    throw new UnimplementedError();
  }

  @override
  double sample() {
    //TODO return min + (rand.Float64() * (max - min));
    throw new UnimplementedError();
  }

  double sampleMany(int count) {
    //TODO
    throw new UnimplementedError();
  }
}

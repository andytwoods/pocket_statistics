
import 'dart:math';

import 'package:statistical_power/dists/dists.dart';

/// The Cauchy  Distribution is a continuous probability distribution
/// with parameters x, γ >= 0.
///
/// See: https://en.wikipedia.org/wiki/Cauchy_distribution
class Cauchy extends ContinuousRV {
  final double location;

  final double scale;

  Cauchy._(this.location, this.scale);

  factory Cauchy(double location, double scale) {
    if (location <= 0) {
      throw new ArgumentError.value(
          location, 'location', 'Must be greater than 0');
    }
    return new Cauchy._(location, scale);
  }

  double mean() => double.nan;

  double variance() => double.nan;

  double skewness() => double.nan;

  double kurtosis() => double.nan;

  double std() => double.nan;

  @override
  double relStd() => double.nan;

  @override
  double pdf(double x) {
    final double diff = x - location;
    final double denom = (diff * diff) + (scale * scale);
    return scale / denom / pi;
  }

  @override
  double cdf(double x) => (atan((x - location) / scale) / pi) + 0.5;

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

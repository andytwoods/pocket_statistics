

import 'dart:math';

import 'package:pocket_statistics/dists/dists.dart';

/// The Uniform Distribution is a continuous probability distribution
/// with parameters Min and Max, with Max < Min.
///
/// See: https://en.wikipedia.org/wiki/Uniform_distribution_(continuous)
class Uniform extends ContinuousRV {
  final double min;

  final double max;

  Uniform._(this.min, this.max);

  factory Uniform(double min, double max) {
    if (max <= min) {
      throw new ArgumentError.value(max, 'max', 'Must be greater than min');
    }
    return new Uniform._(min, max);
  }

  double mean() => (min + max) / 2;

  double variance() {
    final double diff = max - min;
    return diff * diff / 12;
  }

  double skewness() => 0.0;

  double kurtosis() => -6/5;

  double std() {
	  final double diff = max - min;
	  return sqrt(diff * diff / 12);
  }

  @override
  double relStd() {
	  return (max - min) / (sqrt(3) * (max + min));
  }

  @override
  double pdf(double x) {
	  if(x < min || x > max) {
		  return 0.0;
	  }
	  return 1 / (max - min);
  }

  @override
  double cdf(double x) {
	  if (x < min) {
		  return 0.0;
	  }
	  if (x >= max) {
		  return 1.0;
	  }
	  return (x - min) / (max - min);
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

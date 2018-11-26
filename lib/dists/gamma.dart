

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

  // from https://github.com/jstat/jstat/blob/master/dist/jstat.js
  static double gammaln(double x) {
    List<double> cof = [
      76.18009172947146, -86.50532032941677, 24.01409824083091,
      -1.231739572450155, 0.1208650973866179e-2, -0.5395239384953e-5
    ];
    double ser = 1.000000000190015;
    double xx, y, tmp;
    tmp = (y = xx = x) + 5.5;
    tmp -= (xx + 0.5) * log(tmp);
    for (int j=0; j < 6; j++)
      ser += cof[j] / ++y;
    return log(2.5066282746310005 * ser / xx) - tmp;
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

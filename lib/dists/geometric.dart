import 'dart:math';
import 'package:pocket_statistics/dists/dists.dart';

/// The Geometric Distribution is a discrete probability distribution
/// with parameters p > 0 >= 1. Note: this is models the number of failures
/// until the first success is achieved.
///
/// See: https://en.wikipedia.org/wiki/Geometric_distribution
class Geometric extends ContinuousRV {
  final double prob;

  Geometric._(this.prob);

  factory Geometric(double prob) {
    if (prob <= 0 || prob > 1) {
      throw new ArgumentError.value(prob, 'prob', 'Must be in range (0, 1]');
    }
    return new Geometric._(prob);
  }

  double mean() => (1 - prob) / prob;

  double variance() => (1 - prob) / (prob * prob);

  double skewness() => (2 - prob) / sqrt(1 - prob);

  double kurtosis() => 6 + ((prob * prob) / (1 - prob));

  double std() => sqrt(1 - prob) / prob;

  @override
  double relStd() => sqrt(1 - prob) * prob / (prob * (1 - prob));

  @override
  double pdf(double x) {
    if (x < 0) {
      return 0.0;
    }
    return prob * pow(1 - prob, x);
  }

  @override
  double cdf(double x) {
    if (x < 0.0) {
      return 0.0;
    }
    return 1 - pow(1 - prob, x.floor() + 1);
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

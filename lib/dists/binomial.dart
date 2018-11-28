
import 'dart:math';

import 'package:pocket_statistics/dists/dists.dart';
import 'package:pocket_statistics/math/binomial.dart';

/// The Binomial Distribution is a discrete probability distribution
/// with parameters n > 0, 1 > p > 0.
///
/// See: https://en.wikipedia.org/wiki/Binomial_distribution
class Binomial extends ContinuousRV {
  final double trials;

  final double prob;

  Binomial._(this.trials, this.prob);

  factory Binomial(double trials, double prob) {
    if (trials < 0) {
      throw new ArgumentError.value(trials, 'trials', 'Must be positive');
    }

    if (prob < 0 || prob > 1) {
      throw new ArgumentError.value(
          trials, 'trials', 'Must be in range [0, 1]');
    }
    return new Binomial._(trials, prob);
  }

  double mean() => trials * prob;

  double variance() => trials * prob * (1 - prob);

  double skewness() => (1 - (2 * prob)) / sqrt(trials * prob * (1 - prob));

  double kurtosis() => 3 - (6 / trials) + (1 / (trials * prob * (1 - prob)));

  double std() => sqrt(trials * prob * (1 - prob));

  @override
  double relStd() => sqrt((1 - prob) / (trials * prob));

  @override
  double pdf(double x) {
    if (x < 0.0 || x > trials) {
      return 0.0;
    }
    x = x.floorToDouble();
    if (prob == 0) {
      if (x == 0) {
        return 1.0;
      }
      return 0.0;
    }
    if (prob == 1) {
      if (x == trials) {
        return 1.0;
      }
      return 0.0;
    }

    final double cnk = binomialCoefficient(trials, x);
    final double pows = pow(prob, x) * pow(1 - prob, trials - x);
    if (cnk.isInfinite) {
      return 0.0;
    }
    return cnk * pows;
  }

  @override
  double cdf(double x) {
    if (x < 0.0) {
      return 0.0;
    }
    if (x > trials) {
      return 1.0;
    }
    double result = 0.0;
    double end = x.floorToDouble() + 1;
    for (double i = 0.0; i < end; i++) {
      final double current = binomialCoefficient(trials, i);
      final double pows = pow(prob, i) * pow(1 - prob, trials - i);
      result += current * pows;
    }
    return result;
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

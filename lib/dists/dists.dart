

import 'dart:math' as math;

class RandDistStats {
  final double mean;

  final double variance;

  final double skewness;

  final double kurtois;

  final double std;

  RandDistStats(
      this.mean, this.variance, this.skewness, this.kurtois, this.std);
}

/// Interface for continuous random variables
abstract class ContinuousRV {
  double mean();

  double variance();

  double skewness();

  double kurtosis();

  double std();

  double relStd();

  RandDistStats stats() =>
      new RandDistStats(mean(), variance(), skewness(), kurtosis(), std());

  double pdf(double x);

  double cdf(double x);

  /// Percent point function (inverse of `cdf`) at q of the given RV
  double ppf(double q);

  double logpdf(double x) => math.log(pdf(x));

  double logcdf(double x) => math.log(cdf(x));

  double sf(double x) => 1.0 - cdf(x);

  double logsf(double x) => math.log(sf(x));

  /// Inverse survival function (inverse of `sf`) at q of the given RV
  double isf(double q) => ppf(1.0 - q);

  //TODO interval

  double pdfScaled(double x, {double loc: 0.0, double scale: 1.0}) {
    final double adjX = (x - loc) / scale;
    return pdf(adjX) / scale;
  }

  double logpdfScaled(double x, {double loc: 0.0, double scale: 1.0}) {
    final double adjX = (x - loc) / scale;
    return logpdfScaled(adjX) - math.log(scale);
  }

  double cdfScaled(double x, {double loc: 0.0, double scale: 1.0}) {
    final double adjX = (x - loc) / scale;
    return cdf(adjX);
  }

  double logcdfScaled(double x, {double loc: 0.0, double scale: 1.0}) {
    final double adjX = (x - loc) / scale;
    return logcdf(adjX);
  }

  double sfScaled(double x, {double loc: 0.0, double scale: 1.0}) {
    final double adjX = (x - loc) / scale;
    return sf(adjX);
  }

  double logsfScaled(double x, {double loc: 0.0, double scale: 1.0}) {
    final double adjX = (x - loc) / scale;
    return logsf(adjX);
  }

  /// Percent point function (inverse of `cdf`) at q of the given RV
  double ppfScaled(double q, {double loc: 0.0, double scale: 1.0}) {
    return ppf(q) * scale - loc;
  }

  /// Inverse survival function (inverse of `sf`) at q of the given RV
  double isfScaled(double q, {double loc: 0.0, double scale: 1.0}) {
    return isf(q) * scale - loc;
  }

  //TODO fit

  //TODO fit loc scale

  //TODO nnlf

  double sample();

  double sampleMany(int count);
}

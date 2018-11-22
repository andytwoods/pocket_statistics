
import 'dart:math';

import 'package:statistical_power/dists/dists.dart';
import 'package:statistical_power/math/beta.dart';
import 'package:statistical_power/math/gamma.dart';

/// TODO
class StudentT extends ContinuousRV {
  /// Degree of freedom
  final double df;

  final double _mean;

  final double _variance;

  final double _skewness;

  final double _kurtosis;

  final double _pdfConst;

  final double _pdfExp;

  final double _halfDf;

  StudentT(this.df)
      : _mean = df > 1 ? 0.0 : double.nan,
        _variance =
            df > 2 ? df / (df - 2) : (df > 1 ? double.infinity : double.nan),
        _skewness = df > 3 ? 0.0 : double.nan,
        _kurtosis =
            df < 2 ? double.nan : (df <= 4 ? double.infinity : 6 / (df - 4)),
        _pdfConst = gamma((df + 1) / 2) /
            (sqrt(df * pi) * gamma(df / 2)),
        _pdfExp = -(df + 1) / 2,
        _halfDf = df / 2 {
    if (df <= 0)
      throw new ArgumentError.value(df, "df", "Should be greater than 0");
  }

  double mean() => _mean;

  double median() => 0.0;

  double mode() => 0.0;

  double variance() => _variance;

  double skewness() => _skewness;

  double kurtosis() => _kurtosis;

  double std() => sqrt(variance());

  @override
  double relStd() {
    // TODO
    throw new UnimplementedError();
  }

  @override
  double pdf(double x) => _pdfConst * pow(1 + ((x * x) / df), _pdfExp);

  @override
  double cdf(double x) {
    double fac = sqrt(x * x + df);
    return ibeta(this._halfDf, _halfDf, (x + fac) / (2 * fac));
  }

  double ppf(double q) {
    double fac = ibetaInv(_halfDf, 0.5, 2 * min(q, 1 - q));
    double y = sqrt(df * (1 - fac) / fac);
    return (q > 0.5) ? y : -y;
  }

  @override
  double sample() {
    //TODO
    throw new UnimplementedError();
  }

  double sampleMany(int count) {
    //TODO
    throw new UnimplementedError();
  }
}

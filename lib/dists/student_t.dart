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
        _pdfConst = gamma((df + 1) / 2) / (sqrt(df * pi) * gamma(df / 2)),
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
  double cdf(double t) {
    double a = 0.0,
        b = 0.0,
        idf = df,
        im2 = 0.0,
        ioe = 0.0,
        s = 0.0,
        c = 0.0,
        ks = 0.0,
        fk = 0.0,
        k = 0.0;
    var g1 = 1 / pi;
    a = t / sqrt(idf);
    b = idf / (idf + t * t);
    im2 = df - 2;
    ioe = idf % 2;
    s = 1.0;
    c = 1.0;
    idf = 1.0;
    ks = 2 + ioe;
    fk = ks;
    if (im2 >= 2) {
      for (k = ks; k <= im2; k += 2) {
        c = c * b * (fk - 1) / fk;
        s += c;
        //        if (s != idf) {
        idf = s;
        fk += 2;
        //        }
      }
    }
    if (ioe != 1) return .5 + .5 * a * sqrt(b) * s;

    if (df == 1) s = 0.0;
    return .5 + (a * b * s + atan(a)) * g1;
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

import 'dart:math';

import 'package:pocket_statistics/dists/beta.dart';
import 'package:pocket_statistics/dists/dists.dart';
import 'package:pocket_statistics/math/erf.dart';
import 'package:pocket_statistics/math/normal.dart';

// from https://github.com/jstat/jstat/blob/master/dist/jstat.js
class FCentral {
  static double pdf(x, df1, df2) {
    throw new UnimplementedError();
  }

  static double cdf(x, df1, df2) {
    if (x < 0)
      return 0.0;
    return Beta.ibeta((df1 * x) / (df1 * x + df2), df1 / 2, df2 / 2);
  }

  static double inv(x, df1, df2) {
    return df2 / (df1 * (1 / Beta.ibetainv(x, df1 / 2, df2 / 2) - 1));
  }

  static double mean(df1, df2) {
    if (df2 > 2) return df2 / (df2 - 2);
    throw new UnsupportedError('');
  }

  static double mode(df1, df2) {

    if (df1 > 2) return (df2 * (df1 - 2)) / (df1 * (df2 + 2));
    throw new UnsupportedError('');
  }

  // return a random sample
  static double sample(df1, df2) {
    throw new UnimplementedError();
  }

  static double variance(df1, df2) {
    if (df2 <= 4) throw new UnsupportedError('');
    return 2 * df2 * df2 * (df1 + df2 - 2) /
        (df1 * (df2 - 2) * (df2 - 2) * (df2 - 4));
  }

}

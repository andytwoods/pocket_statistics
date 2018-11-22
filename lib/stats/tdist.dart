//from http://www.math.ucla.edu/~tom/distributions/tDist.html

import 'dart:math';

double logGamma(double Z) {
  double S = 1 +
      76.18009173 / Z -
      86.50532033 / (Z + 1) +
      24.01409822 / (Z + 2) -
      1.231739516 / (Z + 3) +
      .00120858003 / (Z + 4) -
      .00000536382 / (Z + 5);
  double LG = (Z - .5) * log(Z + 4.5) - (Z + 4.5) + log(S * 2.50662827465);
  return LG;
}

double Betinc(X, A, B) {
  double A0 = 0.0;
  double B0 = 1.0;
  double A1 = 1.0;
  double B1 = 1.0;
  double M9 = 0.0;
  double A2 = 0.0;
  double C9;
  while (((A1 - A2) / A1).abs() > .00001) {
    A2 = A1;
    C9 = -(A + M9) * (A + B + M9) * X / (A + 2 * M9) / (A + 2 * M9 + 1);
    A0 = A1 + C9 * A0;
    B0 = B1 + C9 * B0;
    M9 = M9 + 1;
    C9 = M9 * (B - M9) * X / (A + 2 * M9 - 1) / (A + 2 * M9);
    A1 = A0 + C9 * A1;
    B1 = B0 + C9 * B1;
    A0 = A0 / B1;
    B0 = B0 / B1;
    A1 = A1 / B1;
    B1 = 1.0;
  }
  return A1 / A;
}

double tDist(double X, double df) {
  double A = df / 2;
  double S = A + .5;
  double Z = df / (df + X * X);
  double BT = exp(
      logGamma(S) - logGamma(.5) - logGamma(A) + A * log(Z) + .5 * log(1 - Z));
  double betacdf;
  double tcdf;

  if (Z < (A + 1) / (S + 2)) {
    betacdf = BT * Betinc(Z, A, .5);
  } else {
    betacdf = 1 - BT * Betinc(1 - Z, .5, A);
  }
  if (X < 0) {
    tcdf = betacdf / 2;
  } else {
    tcdf = 1 - betacdf / 2;
  }

  return tcdf;
}

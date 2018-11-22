
/// Evaluates polynomial of degree N
///
///                     2          N
/// y  =  C  + C x + C x  +...+ C x
///        0    1     2          N
///
/// Coefficients are stored in reverse order:
///
/// coef[0] = C  , ..., coef[N] = C  .
///            N                   0
///
///     polyval(5, [3,0,1]);  // 3 * 5**2 + 0 * 5**1 + 1
///     >>> 76
double polyval(num x, List<num> coef) {
  final ite = coef.iterator;
  ite.moveNext();

  double ans = ite.current.toDouble();

  while (ite.moveNext()) {
    ans = ans * x + ite.current;
  }

  return ans;
}

/// Evaluates polynomial of degree N
///
///                                          N
/// Evaluate polynomial when coefficient of x  is 1.0.
/// Otherwise same as polevl.
double p1evl(double x, List<double> coef) {
  final ite = coef.iterator;
  ite.moveNext();

  double ans = x.toDouble() + ite.current;

  while (ite.moveNext()) {
    ans = ans * x + ite.current;
  }

  return ans;
}

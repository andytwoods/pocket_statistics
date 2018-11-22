
// Choose k elements from a set of n elements.
// See: https://en.wikipedia.org/wiki/Binomial_coefficient
double binomialCoefficient(double n, double k) {
  if (k > n) {
    return double.nan;
  }
  double r = 1.0;
  for (int d = 1; d <= k; d++) {
    r *= n;
    r /= d;
    n -= 1;
  }
  return r;
}

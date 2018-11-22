library grizzly.math;

import 'dart:typed_data';
import 'dart:math' as math;

class Double {
  /// Converts double precision to single precision approximately
  ///
  /// Converts mantisa from 53-bits to 20-bits
  static double toSingle(double inp) {
    final lst = new Float64List.fromList([inp]).buffer.asUint32List();
    if (Endian.host == Endian.little) {
      lst[0] = 0;
    } else {
      lst[1] = 0;
    }
    return lst.buffer.asFloat64List().first;
  }

  /// Converts double precision to single precision approximately
  ///
  /// Converts mantisa from 53-bits to 20-bits
  static int exponent(double inp) {
    final lst = new Float64List.fromList([inp]).buffer.asUint16List();
    int ret = 0;
    if (Endian.host == Endian.little) {
      ret = lst[3] >> 4;
    } else {
      ret = lst[4] >> 4;
    }
    return ret - 1023;
  }

  static double mask(double inp, int hw1, int hw0) {
    final lst = new Float64List.fromList([inp]).buffer.asUint32List();
    if (Endian.host == Endian.little) {
      lst[0] &= hw0;
      lst[1] &= hw1;
    } else {
      lst[1] &= hw0;
      lst[0] &= hw1;
    }
    return lst.buffer.asFloat64List().first;
  }

  static int bit0(double inp) {
    final lst = new Float64List.fromList([inp]).buffer.asUint32List();
    if (Endian.host == Endian.little) {
      return lst[0] & 1;
    } else {
      return lst[1] & 1;
    }
  }

  static double fractionPart(double f) {
    if (f < 1) {
      if (f < 0) {
        return -fractionPart(-f);
      }
      return f;
    }

    final int e = exponent(f);
    double x = f;

    // Keep the top 12+e bits, the integer part; clear the rest.
    if (e < 64 - 12) {
      int hw0 = 0;
      int hw1 = 0;

      if (e <= 20) {
        hw0 = 0;
        hw1 = 1 << (64 - 12 - e - 32) - 1;
      } else {
        hw0 = 1 << (64 - 12 - e) - 1;
        hw1 = 0xFFFF;
      }

      x = mask(x, hw1, hw0);
    }
    return f - x;
  }
}

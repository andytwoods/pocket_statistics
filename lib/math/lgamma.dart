

import 'dart:math';

import 'package:statistical_power/math/math.dart';

class Lgamma {
  final double lgamma;

  final int sign;

  Lgamma(this.lgamma, this.sign);
}

Lgamma lgamma(double x) {
  const double Ymin = 1.461632144968362245;
  final double Two52 = 4.5036e+15; // 0x4330000000000000 ~4.5036e+15
  // final double Two53 = 9.0072e+15; // 0x4340000000000000 ~9.0072e+15
  final double Two58 = 2.8823e+17; // 0x4390000000000000 ~2.8823e+17
  const double Tiny = 8.47033e-22; // 0x3b90000000000000 ~8.47033e-22
  const double Tc = 1.46163214496836224576e+00; // 0x3FF762D86356BE3F
  const double Tf = -1.21486290535849611461e-01; // 0xBFBF19B9BCC38A42
  // Tt = -(tail of Tf)
  const double Tt = -3.63867699703950536541e-18; // 0xBC50C7CAA48A971F

  // special cases
  int sign = 1;
  if (x.isNaN) {
    return new Lgamma(x, sign);
  }
  if (x.isInfinite) {
    return new Lgamma(x, sign);
  }
  if (x == 0.0) {
    return new Lgamma(double.infinity, sign);
  }

  bool neg = false;
  if (x < 0) {
    x = -x;
    neg = true;
  }

  if (x < Tiny) {
    // if |x| < 2**-70, return -log(|x|)
    if (neg) {
      sign = -1;
    }
    return new Lgamma(-log(x), sign);
  }

  double nadj;
  if (neg) {
    if (x >= Two52) {
      // |x| >= 2**52, must be -integer
      return new Lgamma(double.infinity, sign);
    }
    final double t = sinPi(x);
    if (t == 0) {
      return new Lgamma(double.infinity, sign);
    }
    nadj = log(pi / (t * x).abs());
    if (t < 0) {
      sign = -1;
    }
  }

  // purge off 1 and 2
  if (x == 1.0 || x == 2.0) {
    return new Lgamma(0.0, sign);
  }

  double lgamma;

  // use lgamma(x) = lgamma(x+1) - log(x)
  if (x < 2) {
    double y;
    int i;
    if (x <= 0.9) {
      lgamma = -log(x);
      if (x >= (Ymin - 1 + 0.27)) {
        // 0.7316 <= x <=  0.9
        y = 1 - x;
        i = 0;
      } else if (x >= (Ymin - 1 - 0.27)) {
        // 0.2316 <= x < 0.7316
        y = x - (Tc - 1);
        i = 1;
      } else {
        // 0 < x < 0.2316
        y = x;
        i = 2;
      }
    } else {
      lgamma = 0.0;
      if (x >= (Ymin + 0.27)) {
        // 1.7316 <= x < 2
        y = 2 - x;
        i = 0;
      } else if (x >= (Ymin - 0.27)) {
        // 1.2316 <= x < 1.7316
        y = x - Tc;
        i = 1;
      } else {
        // 0.9 < x < 1.2316
        y = x - 1;
        i = 2;
      }
    }

    switch (i) {
      case 0:
        final double z = y * y;
        final double p1 = _lgamA[0] +
            z *
                (_lgamA[2] +
                    z *
                        (_lgamA[4] +
                            z *
                                (_lgamA[6] +
                                    z * (_lgamA[8] + z * _lgamA[10]))));
        final double p2 = z *
            (_lgamA[1] +
                z *
                    (_lgamA[3] +
                        z *
                            (_lgamA[5] +
                                z *
                                    (_lgamA[7] +
                                        z * (_lgamA[9] + z * _lgamA[11])))));
        final double p = y * p1 + p2;
        lgamma += (p - 0.5 * y);
        break;
      case 1:
        final double z = y * y;
        final double w = z * y;
        final double p1 = _lgamT[0] +
            w *
                (_lgamT[3] +
                    w *
                        (_lgamT[6] +
                            w * (_lgamT[9] + w * _lgamT[12]))); // parallel comp
        final double p2 = _lgamT[1] +
            w *
                (_lgamT[4] +
                    w * (_lgamT[7] + w * (_lgamT[10] + w * _lgamT[13])));
        final double p3 = _lgamT[2] +
            w *
                (_lgamT[5] +
                    w * (_lgamT[8] + w * (_lgamT[11] + w * _lgamT[14])));
        final double p = z * p1 - (Tt - w * (p2 + y * p3));
        lgamma += (Tf + p);
        break;
      case 2:
        final double p1 = y *
            (_lgamU[0] +
                y *
                    (_lgamU[1] +
                        y *
                            (_lgamU[2] +
                                y *
                                    (_lgamU[3] +
                                        y * (_lgamU[4] + y * _lgamU[5])))));
        final double p2 = 1 +
            y *
                (_lgamV[1] +
                    y *
                        (_lgamV[2] +
                            y * (_lgamV[3] + y * (_lgamV[4] + y * _lgamV[5]))));
        lgamma += (-0.5 * y + p1 / p2);
        break;
    }
  } else if (x < 8) {
    // 2 <= x < 8
    int i = x.toInt();
    final double y = x - i.toDouble();
    final double p = y *
        (_lgamS[0] +
            y *
                (_lgamS[1] +
                    y *
                        (_lgamS[2] +
                            y *
                                (_lgamS[3] +
                                    y *
                                        (_lgamS[4] +
                                            y *
                                                (_lgamS[5] +
                                                    y * _lgamS[6]))))));
    final double q = 1 +
        y *
            (_lgamR[1] +
                y *
                    (_lgamR[2] +
                        y *
                            (_lgamR[3] +
                                y *
                                    (_lgamR[4] +
                                        y * (_lgamR[5] + y * _lgamR[6])))));
    lgamma = 0.5 * y + p / q;
    double z = 1.0; // Lgamma(1+s) = Log(s) + Lgamma(s)
    for (; i >= 3; i--) {
      switch (i) {
        case 7:
          z *= (y + 6);
          break;
        case 6:
          z *= (y + 5);
          break;
        case 5:
          z *= (y + 4);
          break;
        case 4:
          z *= (y + 3);
          break;
        case 3:
          z *= (y + 2);
          lgamma += log(z);
          break;
      }
    }
  } else if (x < Two58) {
    // 8 <= x < 2**58
    final double t = log(x);
    final double z = 1 / x;
    final double y = z * z;
    final double w = _lgamW[0] +
        z *
            (_lgamW[1] +
                y *
                    (_lgamW[2] +
                        y *
                            (_lgamW[3] +
                                y *
                                    (_lgamW[4] +
                                        y * (_lgamW[5] + y * _lgamW[6])))));
    lgamma = (x - 0.5) * (t - 1) + w;
  } else {
    // 2**58 <= x <= Inf
    lgamma = x * (log(x) - 1);
  }

  if (neg) {
    lgamma = nadj - lgamma;
  }
  return new Lgamma(lgamma, sign);
}

// sinPi(x) is a helper function for negative x
double sinPi(double x) {
  final double Two52 = 4.5036e+15; // 0x4330000000000000 ~4.5036e+15
  final double Two53 = 9.0072e+15; // 0x4340000000000000 ~9.0072e+15

  if (x < 0.25) {
    return -sin(pi * x);
  }

// argument reduction
  double z = x.floorToDouble();
  int n = 0;
  if (z != x) {
    // inexact
    x = x.remainder(2);
    n = (x * 4).toInt();
  } else {
    if (x >= Two53) {
      // x must be even
      x = 0.0;
      n = 0;
    } else {
      if (x < Two52) {
        z = x + Two52; // exact
      }
      n = Double.bit0(z);
      x = n.toDouble();
      n <<= 2;
    }
  }
  switch (n) {
    case 0:
      x = sin(pi * x);
      break;
    case 1:
    case 2:
      x = cos(pi * (0.5 - x));
      break;
    case 3:
    case 4:
      x = sin(pi * (1 - x));
      break;
    case 5:
    case 6:
      x = -cos(pi * (x - 1.5));
      break;
    default:
      x = sin(pi * (x - 2));
      break;
  }
  return -x;
}

const List<double> _lgamA = const <double>[
  7.72156649015328655494e-02, // 0x3FB3C467E37DB0C8
  3.22467033424113591611e-01, // 0x3FD4A34CC4A60FAD
  6.73523010531292681824e-02, // 0x3FB13E001A5562A7
  2.05808084325167332806e-02, // 0x3F951322AC92547B
  7.38555086081402883957e-03, // 0x3F7E404FB68FEFE8
  2.89051383673415629091e-03, // 0x3F67ADD8CCB7926B
  1.19270763183362067845e-03, // 0x3F538A94116F3F5D
  5.10069792153511336608e-04, // 0x3F40B6C689B99C00
  2.20862790713908385557e-04, // 0x3F2CF2ECED10E54D
  1.08011567247583939954e-04, // 0x3F1C5088987DFB07
  2.52144565451257326939e-05, // 0x3EFA7074428CFA52
  4.48640949618915160150e-05, // 0x3F07858E90A45837
];

const List<double> _lgamR = const <double>[
  1.0, // placeholder
  1.39200533467621045958e+00, // 0x3FF645A762C4AB74
  7.21935547567138069525e-01, // 0x3FE71A1893D3DCDC
  1.71933865632803078993e-01, // 0x3FC601EDCCFBDF27
  1.86459191715652901344e-02, // 0x3F9317EA742ED475
  7.77942496381893596434e-04, // 0x3F497DDACA41A95B
  7.32668430744625636189e-06, // 0x3EDEBAF7A5B38140
];

const List<double> _lgamS = const <double>[
  -7.72156649015328655494e-02, // 0xBFB3C467E37DB0C8
  2.14982415960608852501e-01, // 0x3FCB848B36E20878
  3.25778796408930981787e-01, // 0x3FD4D98F4F139F59
  1.46350472652464452805e-01, // 0x3FC2BB9CBEE5F2F7
  2.66422703033638609560e-02, // 0x3F9B481C7E939961
  1.84028451407337715652e-03, // 0x3F5E26B67368F239
  3.19475326584100867617e-05, // 0x3F00BFECDD17E945
];

const List<double> _lgamT = const <double>[
  4.83836122723810047042e-01, // 0x3FDEF72BC8EE38A2
  -1.47587722994593911752e-01, // 0xBFC2E4278DC6C509
  6.46249402391333854778e-02, // 0x3FB08B4294D5419B
  -3.27885410759859649565e-02, // 0xBFA0C9A8DF35B713
  1.79706750811820387126e-02, // 0x3F9266E7970AF9EC
  -1.03142241298341437450e-02, // 0xBF851F9FBA91EC6A
  6.10053870246291332635e-03, // 0x3F78FCE0E370E344
  -3.68452016781138256760e-03, // 0xBF6E2EFFB3E914D7
  2.25964780900612472250e-03, // 0x3F6282D32E15C915
  -1.40346469989232843813e-03, // 0xBF56FE8EBF2D1AF1
  8.81081882437654011382e-04, // 0x3F4CDF0CEF61A8E9
  -5.38595305356740546715e-04, // 0xBF41A6109C73E0EC
  3.15632070903625950361e-04, // 0x3F34AF6D6C0EBBF7
  -3.12754168375120860518e-04, // 0xBF347F24ECC38C38
  3.35529192635519073543e-04, // 0x3F35FD3EE8C2D3F4
];

const List<double> _lgamU = const <double>[
  -7.72156649015328655494e-02, // 0xBFB3C467E37DB0C8
  6.32827064025093366517e-01, // 0x3FE4401E8B005DFF
  1.45492250137234768737e+00, // 0x3FF7475CD119BD6F
  9.77717527963372745603e-01, // 0x3FEF497644EA8450
  2.28963728064692451092e-01, // 0x3FCD4EAEF6010924
  1.33810918536787660377e-02, // 0x3F8B678BBF2BAB09
];

const List<double> _lgamV = const <double>[
  1.0,
  2.45597793713041134822e+00, // 0x4003A5D7C2BD619C
  2.12848976379893395361e+00, // 0x40010725A42B18F5
  7.69285150456672783825e-01, // 0x3FE89DFBE45050AF
  1.04222645593369134254e-01, // 0x3FBAAE55D6537C88
  3.21709242282423911810e-03, // 0x3F6A5ABB57D0CF61
];

const List<double> _lgamW = const <double>[
  4.18938533204672725052e-01, // 0x3FDACFE390C97D69
  8.33333333333329678849e-02, // 0x3FB555555555553B
  -2.77777777728775536470e-03, // 0xBF66C16C16B02E5C
  7.93650558643019558500e-04, // 0x3F4A019F98CF38B6
  -5.95187557450339963135e-04, // 0xBF4380CB8C0FE741
  8.36339918996282139126e-04, // 0x3F4B67BA4CDAD5D1
  -1.63092934096575273989e-03, // 0xBF5AB89D0B9E43E4
];

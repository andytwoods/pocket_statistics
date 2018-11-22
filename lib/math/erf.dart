

import 'dart:math';

import 'package:statistical_power/math/math.dart';

const double _erx = 8.45062911510467529297e-01; // 0x3FEB0AC160000000

// Coefficients for approximation to  erf in [0, 0.84375]
const double _efx = 1.28379167095512586316e-01; // 0x3FC06EBA8214DB69
const double _efx8 = 1.02703333676410069053e+00; // 0x3FF06EBA8214DB69
const double _pp0 = 1.28379167095512558561e-01; // 0x3FC06EBA8214DB68
const double _pp1 = -3.25042107247001499370e-01; // 0xBFD4CD7D691CB913
const double _pp2 = -2.84817495755985104766e-02; // 0xBF9D2A51DBD7194F
const double _pp3 = -5.77027029648944159157e-03; // 0xBF77A291236668E4
const double _pp4 = -2.37630166566501626084e-05; // 0xBEF8EAD6120016AC
const double _qq1 = 3.97917223959155352819e-01; // 0x3FD97779CDDADC09
const double _qq2 = 6.50222499887672944485e-02; // 0x3FB0A54C5536CEBA
const double _qq3 = 5.08130628187576562776e-03; // 0x3F74D022C4D36B0F
const double _qq4 = 1.32494738004321644526e-04; // 0x3F215DC9221C1A10
const double _qq5 = -3.96022827877536812320e-06; // 0xBED09C4342A26120

// Coefficients for approximation to  erf  in [0.84375, 1.25]
const double _pa0 = -2.36211856075265944077e-03; // 0xBF6359B8BEF77538
const double _pa1 = 4.14856118683748331666e-01; // 0x3FDA8D00AD92B34D
const double _pa2 = -3.72207876035701323847e-01; // 0xBFD7D240FBB8C3F1
const double _pa3 = 3.18346619901161753674e-01; // 0x3FD45FCA805120E4
const double _pa4 = -1.10894694282396677476e-01; // 0xBFBC63983D3E28EC
const double _pa5 = 3.54783043256182359371e-02; // 0x3FA22A36599795EB
const double _pa6 = -2.16637559486879084300e-03; // 0xBF61BF380A96073F
const double _qa1 = 1.06420880400844228286e-01; // 0x3FBB3E6618EEE323
const double _qa2 = 5.40397917702171048937e-01; // 0x3FE14AF092EB6F33
const double _qa3 = 7.18286544141962662868e-02; // 0x3FB2635CD99FE9A7
const double _qa4 = 1.26171219808761642112e-01; // 0x3FC02660E763351F
const double _qa5 = 1.36370839120290507362e-02; // 0x3F8BEDC26B51DD1C
const double _qa6 = 1.19844998467991074170e-02; // 0x3F888B545735151D

// Coefficients for approximation to  erfc in [1.25, 1/0.35]
const double _ra0 = -9.86494403484714822705e-03; // 0xBF843412600D6435
const double _ra1 = -6.93858572707181764372e-01; // 0xBFE63416E4BA7360
const double _ra2 = -1.05586262253232909814e+01; // 0xC0251E0441B0E726
const double _ra3 = -6.23753324503260060396e+01; // 0xC04F300AE4CBA38D
const double _ra4 = -1.62396669462573470355e+02; // 0xC0644CB184282266
const double _ra5 = -1.84605092906711035994e+02; // 0xC067135CEBCCABB2
const double _ra6 = -8.12874355063065934246e+01; // 0xC054526557E4D2F2
const double _ra7 = -9.81432934416914548592e+00; // 0xC023A0EFC69AC25C
const double _sa1 = 1.96512716674392571292e+01; // 0x4033A6B9BD707687
const double _sa2 = 1.37657754143519042600e+02; // 0x4061350C526AE721
const double _sa3 = 4.34565877475229228821e+02; // 0x407B290DD58A1A71
const double _sa4 = 6.45387271733267880336e+02; // 0x40842B1921EC2868
const double _sa5 = 4.29008140027567833386e+02; // 0x407AD02157700314
const double _sa6 = 1.08635005541779435134e+02; // 0x405B28A3EE48AE2C
const double _sa7 = 6.57024977031928170135e+00; // 0x401A47EF8E484A93
const double _sa8 = -6.04244152148580987438e-02; // 0xBFAEEFF2EE749A62

// Coefficients for approximation to  erfc in [1/.35, 28]
const double _rb0 = -9.86494292470009928597e-03; // 0xBF84341239E86F4A
const double _rb1 = -7.99283237680523006574e-01; // 0xBFE993BA70C285DE
const double _rb2 = -1.77579549177547519889e+01; // 0xC031C209555F995A
const double _rb3 = -1.60636384855821916062e+02; // 0xC064145D43C5ED98
const double _rb4 = -6.37566443368389627722e+02; // 0xC083EC881375F228
const double _rb5 = -1.02509513161107724954e+03; // 0xC09004616A2E5992
const double _rb6 = -4.83519191608651397019e+02; // 0xC07E384E9BDC383F
const double _sb1 = 3.03380607434824582924e+01; // 0x403E568B261D5190
const double _sb2 = 3.25792512996573918826e+02; // 0x40745CAE221B9F0A
const double _sb3 = 1.53672958608443695994e+03; // 0x409802EB189D5118
const double _sb4 = 3.19985821950859553908e+03; // 0x40A8FFB7688C246A
const double _sb5 = 2.55305040643316442583e+03; // 0x40A3F219CEDF3BE6
const double _sb6 = 4.74528541206955367215e+02; // 0x407DA874E79FE763
const double _sb7 = -2.24409524465858183362e+01; // 0xC03670E242712D62

/// Returns the error function of [x]
///
/// Special cases are:
///	Erf(+Inf) = 1
///	Erf(-Inf) = -1
///	Erf(NaN) = NaN
double erf(double x) {
	const double veryTiny = 2.848094538889218e-306; // 0x0080000000000000
	const double small = 1.0 / (1 << 28); // 2**-28

	// special cases
	if (x.isNaN) return x;
	if (x.isInfinite) {
		if (x.isNegative) return -1.0;
		return 1.0;
	}

	final bool sign = x < 0;
	if (sign) {
		x = -x;
	}

	if (x < 0.84375) {
		// |x| < 0.84375
		double temp;
		if (x < small) {
			// |x| < 2**-28
			if (x < veryTiny) {
				temp = 0.125 * (8.0 * x + _efx8 * x); // avoid underflow
			} else {
				temp = x + _efx * x;
			}
		} else {
			final double z = x * x;
			final double r = _pp0 + z * (_pp1 + z * (_pp2 + z * (_pp3 + z * _pp4)));
			final double s =
					1 + z * (_qq1 + z * (_qq2 + z * (_qq3 + z * (_qq4 + z * _qq5))));
			final double y = r / s;
			temp = x + x * y;
		}
		if (sign) {
			return -temp;
		}
		return temp;
	}

	if (x < 1.25) {
		// 0.84375 <= |x| < 1.25
		final double s = x - 1;
		final double p = _pa0 +
				s *
						(_pa1 +
								s * (_pa2 + s * (_pa3 + s * (_pa4 + s * (_pa5 + s * _pa6)))));
		final double q = 1 +
				s *
						(_qa1 +
								s * (_qa2 + s * (_qa3 + s * (_qa4 + s * (_qa5 + s * _qa6)))));
		if (sign) {
			return -_erx - p / q;
		}
		return _erx + p / q;
	}

	if (x >= 6) {
		// inf > |x| >= 6
		if (sign) {
			return -1.0;
		}
		return 1.0;
	}

	final double s = 1 / (x * x);
	double r1;
	double s1;
	if (x < 1 / 0.35) {
		// |x| < 1 / 0.35  ~ 2.857143
		r1 = _ra7;
		r1 += _ra6 + s * r1;
		r1 += _ra5 + s * r1;
		r1 += _ra4 + s * r1;
		r1 += _ra3 + s * r1;
		r1 += _ra2 + s * r1;
		r1 += _ra1 + s * r1;
		r1 += _ra0 + s * r1;

		s1 = _sa8;
		s1 += _sa7 + s * s1;
		s1 += _sa6 + s * s1;
		s1 += _sa5 + s * s1;
		s1 += _sa4 + s * s1;
		s1 += _sa3 + s * s1;
		s1 += _sa2 + s * s1;
		s1 += _sa1 + s * s1;
		s1 += 1 + s * s1;
	} else {
		// |x| >= 1 / 0.35  ~ 2.857143
		r1 = _rb6;
		r1 += _rb5 + s * r1;
		r1 += _rb4 + s * r1;
		r1 += _rb3 + s * r1;
		r1 += _rb2 + s * r1;
		r1 += _rb1 + s * r1;
		r1 += _rb0 + s * r1;

		s1 = _sb7;
		s1 += _sb6 + s * s1;
		s1 += _sb5 + s * s1;
		s1 += _sb4 + s * s1;
		s1 += _sb3 + s * s1;
		s1 += _sb2 + s * s1;
		s1 += _sb1 + s * s1;
		s1 += 1 + s * s1;
	}

	final double z = Double.toSingle(x); // pseudo-single (20-bit) precision x
	final double r =
			exp(-z * z - 0.5625) * exp((z - x) * (z + x) + r1 / s1);
	if (sign) {
		return r / x - 1;
	}
	return 1 - r / x;
}

/// Returns the complementary error function of x
///
/// Special cases are:
///	Erfc(+Inf) = 0
///	Erfc(-Inf) = 2
///	Erfc(NaN) = NaN
double erfc(double x) {
	const double tiny = 1.0 / (1 << 56); // 2**-56

	// special cases
	if (x.isNaN) return x;
	if (x.isInfinite) {
		if (x.isNegative) return 2.0;
		return 0.0;
	}

	final bool sign = x < 0;
	if (sign) {
		x = -x;
	}

	if (x < 0.84375) {
		// |x| < 0.84375
		double temp;
		if (x < tiny) {
			// |x| < 2**-56
			temp = x;
		} else {
			final double z = x * x;
			final double r = _pp0 + z * (_pp1 + z * (_pp2 + z * (_pp3 + z * _pp4)));
			final double s =
					1 + z * (_qq1 + z * (_qq2 + z * (_qq3 + z * (_qq4 + z * _qq5))));
			final double y = r / s;
			if (x < 0.25) {
				// |x| < 1/4
				temp = x + x * y;
			} else {
				temp = 0.5 + (x * y + (x - 0.5));
			}
		}

		if (sign) {
			return 1 + temp;
		}
		return 1 - temp;
	}

	if (x < 1.25) {
		// 0.84375 <= |x| < 1.25
		final double s = x - 1;
		final double p = _pa0 +
				s *
						(_pa1 +
								s * (_pa2 + s * (_pa3 + s * (_pa4 + s * (_pa5 + s * _pa6)))));
		final double q = 1 +
				s *
						(_qa1 +
								s * (_qa2 + s * (_qa3 + s * (_qa4 + s * (_qa5 + s * _qa6)))));
		if (sign) {
			return 1 + _erx + p / q;
		}
		return 1 - _erx - p / q;
	}

	if (x < 28) {
		// |x| < 28
		final double s = 1 / (x * x);
		double r1;
		double s1;
		if (x < 1 / 0.35) {
			// |x| < 1 / 0.35 ~ 2.857143
			r1 = _ra7;
			r1 += _ra6 + s * r1;
			r1 += _ra5 + s * r1;
			r1 += _ra4 + s * r1;
			r1 += _ra3 + s * r1;
			r1 += _ra2 + s * r1;
			r1 += _ra1 + s * r1;
			r1 += _ra0 + s * r1;

			s1 = _sa8;
			s1 += _sa7 + s * s1;
			s1 += _sa6 + s * s1;
			s1 += _sa5 + s * s1;
			s1 += _sa4 + s * s1;
			s1 += _sa3 + s * s1;
			s1 += _sa2 + s * s1;
			s1 += _sa1 + s * s1;
			s1 += 1 + s * s1;
		} else {
			// |x| >= 1 / 0.35 ~ 2.857143
			if (sign && x > 6) {
				return 2.0; // x < -6
			}
			r1 = _rb6;
			r1 += _rb5 + s * r1;
			r1 += _rb4 + s * r1;
			r1 += _rb3 + s * r1;
			r1 += _rb2 + s * r1;
			r1 += _rb1 + s * r1;
			r1 += _rb0 + s * r1;

			s1 = _sb7;
			s1 += _sb6 + s * s1;
			s1 += _sb5 + s * s1;
			s1 += _sb4 + s * s1;
			s1 += _sb3 + s * s1;
			s1 += _sb2 + s * s1;
			s1 += _sb1 + s * s1;
			s1 += 1 + s * s1;
		}

		final double z = Double.toSingle(x); // pseudo-single (20-bit) precision x
		final double r =
				exp(-z * z - 0.5625) * exp((z - x) * (z + x) + r1 / s1);
		if (sign) {
			return 2 - r / x;
		}
		return r / x;
	}
	if (sign) {
		return 2.0;
	}
	return 0.0;
}
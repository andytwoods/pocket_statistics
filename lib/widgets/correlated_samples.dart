import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:statistical_power/dists/normal.dart';
import 'package:statistical_power/dists/student_t.dart';
import 'package:statistical_power/widgets/base_container.dart';
import 'package:statistical_power/widgets/my_editable.dart';
import 'package:statistical_power/widgets/my_result.dart';
import 'package:statistical_power/widgets/title.dart';

class CorrelatedSamples extends StatefulWidget {
  @override
  CorrelatedSamplesState createState() {
    return new CorrelatedSamplesState();
  }
}

class CorrelatedSamplesState extends State<CorrelatedSamples> {
  final TextEditingController totalN = new TextEditingController(text: '');
  final TextEditingController tValue = new TextEditingController(text: '');

  final TextEditingController meanG1 = new TextEditingController(text: '');
  final TextEditingController sdG1 = new TextEditingController(text: '');
  final TextEditingController n_pairs = new TextEditingController(text: '');
  final TextEditingController r = new TextEditingController(text: '');

  final TextEditingController meanG2 = new TextEditingController(text: '');
  final TextEditingController sdG2 = new TextEditingController(text: '');


  String confidence_intervals;

  double _cohens_d, _cohens_ds, _p, _hedges_g, _df, _CL, _meanG1, _meanG2, _sdG1, _sdG2, _n_pairs, _t, ciPlus, ciMinus, ci_mean, _r, _Mdif, _Sdif, _SEdif, _hedges_gav, _cohens_dav, _cohens_dz;

  void _onChanged() {

    if (meanG1 == null || sdG1 == null || meanG2 == null || sdG2 == null || n_pairs == null || r == null) {
      _df = null;
      ciPlus = null;
      ciMinus = null;
      _t = null;
      _p = null;
      _cohens_ds = null;
      _cohens_d = null;
      _hedges_g = null;
      _CL = null;
    } else {

      _meanG1 = double.parse(meanG1.text);
      _meanG2 = double.parse(meanG2.text);
      _sdG1 = double.parse(sdG1.text);
      _sdG2 = double.parse(sdG2.text);
      _n_pairs = double.parse(n_pairs.text);
      _r = double.parse(r.text);

      _df = _n_pairs - 1;
      _Mdif = (_meanG1 - _meanG2).abs();


      _Sdif = sqrt(_sdG1*_sdG1+_sdG2*_sdG2-2*_r*_sdG1*_sdG2);



      _SEdif = sqrt(((_sdG1*_sdG1/_n_pairs)+(_sdG2*_sdG2/_n_pairs))-(2*_r*(_sdG1/sqrt(_n_pairs))*(_sdG2/sqrt(_n_pairs))));
      _t = _Mdif/(_Sdif/sqrt(_n_pairs));

      double ci = _SEdif * StudentT(_df).inv(0.05 * .5)*-1;
      ciPlus =  _Mdif + ci;
      ciMinus = _Mdif - ci;

      _cohens_dav = _Mdif/sqrt((_sdG1*_sdG1+_sdG2*_sdG2)/2);
      _hedges_gav = _cohens_dav*(1-(3/(4*(_n_pairs-1)-1)));
      _cohens_dz = _Mdif / _Sdif;

      _p = (1 - StudentT(_df).cdf(_t.abs())) * 2;



      Normal cl = Normal(1.0, 1.0);
      //TODO verify below is correct. 9 dp and later, some inconsistencies
      _CL = 1 - cl.cdf(1 - (_Mdif/_Sdif));

    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        MyTitle('Independent samples'),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'Mean group 1',
                onChanged: _onChanged,
                controller: meanG1),
            MyEditable(
                title: 'SD group 1', onChanged: _onChanged, controller: sdG1),
            MyEditable(
                title: 'n pairs', onChanged: _onChanged, controller: n_pairs),
          ],
        ),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'Mean group 2',
                onChanged: _onChanged,
                controller: meanG2),
            MyEditable(
                title: 'SD group 2', onChanged: _onChanged, controller: sdG2),
            MyEditable(
                title: 'r', onChanged: _onChanged, controller: r),
          ],
        ),
        Row(children: [
          MyResult(title: "t", value: safeVal(_t)),
          MyResult(title: "df", value: safeVal(_df)),
        ]),
        Row(children: [
          MyResult(title: "Mdiff", value: safeVal(_Mdif)),
          MyResult(title: "Sdiff", value: safeVal(_Sdif)),
          MyResult(title: "SEdiff", value: safeVal(_SEdif)),
        ]),
        Row(children: [
          MyResult(title: "95% CI Mdiff High", value: safeVal(ciPlus)),
          MyResult(title: "95% CI Mdiff Low", value: safeVal(ciMinus)),
          MyResult(title: "p", value: safeVal(_p)),
        ]),

        Row(children: [
          MyResult(title: "Cohen's dz", value: safeVal(_cohens_dz)),
          MyResult(title: "Cohen's dₐᵥ", value: safeVal(_cohens_dav))
        ]),

        Row(children: [
          MyResult(title: "Hedges's gav", value: safeVal(_hedges_gav)),
          MyResult(title: "CL effect size", value: safeVal(_CL))
        ]),
        _t==null?Container():Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Reporting Example: Mean 1 was higher (M = 8.7, SD = 0.82) than Mean 2 (M = 7.7, SD = 0.95),  t(9) = 4.74, p = .001, 95% CI [0.52, 1.48], Hedges’s gav = 1.03 95% CI [0.50, 1.72]. The CL effect size indicates that after controlling for individual differences, the likelihood that a person scores higher for Mean 1 than for Mean 2 is 93%'),
        )
      ]),
    );
  }

  String safeVal(double cohens_d) {
    if (cohens_d == null) return '';
    return cohens_d.toString();
  }


}

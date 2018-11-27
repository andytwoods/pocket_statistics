import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:statistical_power/dists/normal.dart';
import 'package:statistical_power/dists/student_t.dart';
import 'package:statistical_power/stats/tdist.dart';
import 'package:statistical_power/widgets/base/base_container.dart';
import 'package:statistical_power/widgets/base/sharted_tools_mixin.dart';
import 'package:statistical_power/widgets/my_editable.dart';
import 'package:statistical_power/widgets/my_result.dart';
import 'package:statistical_power/widgets/title.dart';

class IndependentSamples extends StatefulWidget {
  @override
  IndependentSamplesState createState() {
    return new IndependentSamplesState();
  }
}

class IndependentSamplesState extends State<IndependentSamples> with SharedToolsMixin {
  final TextEditingController totalN = new TextEditingController(text: '');
  final TextEditingController tValue = new TextEditingController(text: '');

  final TextEditingController meanG1 = new TextEditingController(text: '');
  final TextEditingController sdG1 = new TextEditingController(text: '');
  final TextEditingController nG1 = new TextEditingController(text: '');

  final TextEditingController meanG2 = new TextEditingController(text: '');
  final TextEditingController sdG2 = new TextEditingController(text: '');
  final TextEditingController nG2 = new TextEditingController(text: '');

  String title = 'Independent samples';

  String confidence_intervals;

  double _cohens_d, _cohens_ds, _p, _hedges_g, _df, _CL, _meanG1, _meanG2, _sdG1, _sdG2, _nG1, _nG2, _t, ciPlus, ciMinus, ci_mean;

  void _onChanged() {

    if (meanG1 == null || sdG1 == null || nG1 == null || meanG2 == null || sdG2 == null || nG2 == null) {
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
      _nG1 = double.parse(nG1.text);
      _nG2 = double.parse(nG2.text);

      _df = _nG1 + _nG2 - 2;

      ci_mean = _meanG1 - _meanG2;
      double ci = StudentT(_df).inv(0.05 * .5)*-1 * (sqrt((_sdG1*_sdG1/_nG1)+(_sdG2*_sdG2/_nG2)));
      ciPlus =  ci_mean + ci;
      ciMinus = ci_mean - ci;

      _t =(_meanG1-_meanG2)/(sqrt(((((_nG1-1)*_sdG1*_sdG1)+((_nG2-1)*_sdG2*_sdG2))/(_nG1+_nG2-2))*((1/_nG1+1/_nG2))));
      _p = (1 - StudentT(_df).cdf(_t.abs())) * 2;
      _cohens_ds = (_meanG1-_meanG2)/(sqrt((((_nG1-1)*_sdG1*_sdG1)+((_nG2-1)*_sdG2*_sdG2))/(_nG1+_nG2-2))).abs();
      _cohens_d = (_meanG1-_meanG2)/(sqrt((((_nG1-1)*_sdG1*_sdG1)+((_nG2-1)*_sdG2*_sdG2))/(_nG1+_nG2))).abs();
      _hedges_g = _cohens_ds*(1-(3/(4*(_nG1+_nG2-2)-1)));
      Normal cl = Normal(1.0, 1.0);
      //TODO verify below is correct. 9 dp and later, some inconsistencies
      _CL = 1 - cl.cdf(1 - (_meanG1-_meanG2) / sqrt(_sdG1*_sdG1 + _sdG2 * _sdG2));

    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        MyTitle(title),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'Mean group 1',
                onChanged: _onChanged,
                controller: meanG1),
            MyEditable(
                title: 'SD group 1', onChanged: _onChanged, controller: sdG1),
            MyEditable(
                title: 'n group 1', onChanged: _onChanged, controller: nG1),
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
                title: 'n group 2', onChanged: _onChanged, controller: nG2),
          ],
        ),
        Row(children: [
          MyResult(title: "95% CI Mdiff High", value: safeVal(ciPlus)),
          MyResult(title: "95% CI Mdiff Low", value: safeVal(ciMinus)),
        ]),
        Row(children: [
          Blank(),
          MyResult(title: "t", value: safeVal(_t)),
        ]),
        Row(children: [
          MyResult(title: "df", value: safeVal(_df)),
          MyResult(title: "p", value: safeVal(_p))
        ]),
        Row(children: [
          MyResult(title: "Cohen's dₛ", value: safeVal(_cohens_ds)),
          MyResult(title: "Cohen's d", value: safeVal(_cohens_d))
        ]),

        Row(children: [
          MyResult(title: "Hedges's gₛ", value: safeVal(_hedges_g)),
          MyResult(title: "CL effect size", value: safeVal(_CL))
        ]),
        _t==null?Container():Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('Reporting Example: Group 1 scored higher (M = 8.7, SD = 0.82) than Group 2 (M = 7.7, SD = 0.95), t(18) = 2.52, p = .022, 95% CI [0.17, 1.83], Hedges’s gs = 1.08, 95% CI [0.13, 2.01]. The CL effect size indicates that the chance that for a randomly selected pair of individuals the score of a person from Group 1 is higher than the score of a person from group 2 is 79%.'),
        )
      ]),
    );
  }

}

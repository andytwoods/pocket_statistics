import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:statistical_power/dists/student_t.dart';
import 'package:statistical_power/stats/tdist.dart';
import 'package:statistical_power/widgets/base_container.dart';
import 'package:statistical_power/widgets/my_editable.dart';
import 'package:statistical_power/widgets/my_result.dart';
import 'package:statistical_power/widgets/title.dart';

class DsFromTForIndependentSamples extends StatefulWidget {
  @override
  DsFromTForIndependentSamplesState createState() {
    return new DsFromTForIndependentSamplesState();
  }
}

class DsFromTForIndependentSamplesState
    extends State<DsFromTForIndependentSamples> {

  final TextEditingController totalN = new TextEditingController(text: '');
  final TextEditingController tValue = new TextEditingController(text: '');

  double _cohens_d, _p, _hedges_g, _df, _CL;

  void _onChanged(){
    if(totalN.text=='' || tValue.text=='') return;
    double _totalN = double.parse(totalN.text);
    double _tValue = double.parse(tValue.text);

    _cohens_d = 2*_tValue / sqrt(_totalN);
    _p = tDist(_tValue.abs(), _totalN-2);
    _hedges_g = _cohens_d*(1-(3/(4*(_totalN)-9)));
    _df=_totalN - 2;

    StudentT st = StudentT(_df);
    print(st.cdf(_tValue));

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        MyTitle('dₛ from t independent samples'),
        Row(
          children: <Widget>[
            MyEditable(title: 'Total N', onChanged: _onChanged, controller: totalN),
            MyEditable(title: 't-value', onChanged: _onChanged, controller: tValue)
          ],
        ),
        Row(
          children: [
            MyResult(title: "Cohen's dₛ ≈", value: safeVal(_cohens_d)),
            MyResult(title: "p", value: safeVal(_p))
          ]
        ),
        Row(
            children: [
              MyResult(title: "Hedges gₛ ≈", value: safeVal(_hedges_g)),
              MyResult(title: "df", value: safeVal(_df))
            ]
        ),
        Row(
            children: [
              MyResult(title: "CL ≈", value: safeVal(_CL)),
              Blank()
            ]
        )
      ]),
    );
  }

  String safeVal(double cohens_d) {
    if(cohens_d==null) return '';
    return cohens_d.toString();
  }
}



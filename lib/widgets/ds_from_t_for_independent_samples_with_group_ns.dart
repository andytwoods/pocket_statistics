import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:statistical_power/dists/normal.dart';
import 'package:statistical_power/dists/student_t.dart';
import 'package:statistical_power/stats/tdist.dart';
import 'package:statistical_power/widgets/base/base_container.dart';
import 'package:statistical_power/widgets/my_editable.dart';
import 'package:statistical_power/widgets/my_result.dart';
import 'package:statistical_power/widgets/title.dart';

class DsFromTForIndependentSamplesWithNs extends StatefulWidget {
  @override
  DsFromTForIndependentSamplesNsState createState() {
    return new DsFromTForIndependentSamplesNsState();
  }
}

class DsFromTForIndependentSamplesNsState
    extends State<DsFromTForIndependentSamplesWithNs> {
  final TextEditingController nGroup1 = new TextEditingController(text: '');
  final TextEditingController nGroup2 = new TextEditingController(text: '');
  final TextEditingController tValue = new TextEditingController(text: '');

  double _cohens_d, _p, _hedges_g, _df, _CL;

  void _onChanged() {
    double _nGroup1 = double.tryParse(nGroup1.text);
    double _nGroup2 = double.tryParse(nGroup2.text);
    double _tValue = double.tryParse(tValue.text);

    if (_nGroup1 == null || _tValue == null || _nGroup2 == null) {
      _cohens_d = _hedges_g = _df = _p = _CL = null;

    } else {
      _cohens_d =
          _tValue * sqrt(_nGroup1 + _nGroup2)
          / sqrt(_nGroup1 * _nGroup2);
      _hedges_g = _cohens_d * (1 - (3 / (4 * (_nGroup1 + _nGroup2) - 9)));
      _df = _nGroup1 + _nGroup2 - 2;
      _p = (1-StudentT(_df).cdf(_tValue))*2;

      Normal cl = Normal(1.0, 1.0);

      //TODO verify below is correct. 9 dp and later, some inconsistencies
      _CL = 1-cl.cdf(1-_cohens_d /sqrt(2.0));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        MyTitle('dₛ from t independent samples with known values for n'),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'n group 1', onChanged: _onChanged, controller: nGroup1),
            MyEditable(
                title: 'n group 2', onChanged: _onChanged, controller: nGroup2),
            MyEditable(
                title: 't-value', onChanged: _onChanged, controller: tValue)
          ],
        ),
        Row(children: [
          MyResult(title: "Cohen's dₛ ≈", value: safeVal(_cohens_d)),
          MyResult(title: "p", value: safeVal(_p))
        ]),
        Row(children: [
          MyResult(title: "Hedges gₛ ≈", value: safeVal(_hedges_g)),
          MyResult(title: "df", value: safeVal(_df))
        ]),
        Row(children: [MyResult(title: "CL ≈", value: safeVal(_CL)), Blank()])
      ]),
    );
  }

  String safeVal(double cohens_d) {
    if (cohens_d == null) return '';
    return cohens_d.toString();
  }
}

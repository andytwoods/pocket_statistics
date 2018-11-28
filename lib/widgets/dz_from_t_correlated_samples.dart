import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:statistical_power/dists/normal.dart';
import 'package:statistical_power/dists/student_t.dart';
import 'package:statistical_power/widgets/base/base_container.dart';
import 'package:statistical_power/widgets/base/sharted_tools_mixin.dart';
import 'package:statistical_power/widgets/my_editable.dart';
import 'package:statistical_power/widgets/my_result.dart';
import 'package:statistical_power/widgets/title.dart';

String DsFromTCorrelatedSamplesTitle = 'dz from t for correlated samples';

class DsFromTCorrelatedSamples extends StatefulWidget {
  @override
  DsFromTCorrelatedSamplesState createState() {
    return new DsFromTCorrelatedSamplesState();
  }
}

class DsFromTCorrelatedSamplesState extends State<DsFromTCorrelatedSamples> with SharedToolsMixin {
  final TextEditingController totalN = new TextEditingController(text: '');
  final TextEditingController tValue = new TextEditingController(text: '');

  double _cohens_d, _p, _CL;

  void _onChanged() {
    double _nPairs = double.tryParse(totalN.text);
    double _tValue = double.tryParse(tValue.text);

    if (_nPairs == null || _tValue == null) {
      _cohens_d = _p = _CL = null;
    } else {
      _cohens_d = _tValue / sqrt(_nPairs);

      _p = (1 - StudentT(_nPairs - 1).cdf(_tValue.abs())) * 2;

      Normal cl = Normal(1.0, 1.0);

      //TODO verify below is correct. 9 dp and later, some inconsistencies
      _CL = 1 - cl.cdf(1 - _cohens_d);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        MyTitle(DsFromTCorrelatedSamplesTitle),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'n pairs', onChanged: _onChanged, controller: totalN),
            MyEditable(
                title: 't-value', onChanged: _onChanged, controller: tValue)
          ],
        ),
        Row(children: [
          MyResult(title: "Cohen's dz", value: safeVal(_cohens_d)),
          MyResult(title: "p-value", value: safeVal(_p))
        ]),
        Row(children: [
          MyResult(title: "CL effect size", value: safeVal(_CL)),
          Blank()
        ])
      ]),
    );
  }

}

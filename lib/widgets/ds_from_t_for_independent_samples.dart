import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:pocket_statistics/dists/normal.dart';
import 'package:pocket_statistics/dists/student_t.dart';
import 'package:pocket_statistics/widgets/base/base_container.dart';
import 'package:pocket_statistics/widgets/base/sharted_tools_mixin.dart';
import 'package:pocket_statistics/widgets/my_editable.dart';
import 'package:pocket_statistics/widgets/my_result.dart';
import 'package:pocket_statistics/widgets/title.dart';


String DsFromTForIndependentSamplesTitle = 'dₛ from t independent samples';

class DsFromTForIndependentSamples extends StatefulWidget {
  @override
  DsFromTForIndependentSamplesState createState() {
    return new DsFromTForIndependentSamplesState();
  }
}

class DsFromTForIndependentSamplesState
    extends State<DsFromTForIndependentSamples> with SharedToolsMixin {
  final TextEditingController totalN = new TextEditingController(text: '');
  final TextEditingController tValue = new TextEditingController(text: '');

  double _cohens_d, _p, _hedges_g, _df, _CL;

  void _onChanged() {
    double _totalN = double.tryParse(totalN.text);
    double _tValue = double.tryParse(tValue.text);

    if (_totalN == null || _tValue == null) {
      _cohens_d = _hedges_g = _df = _p = _CL = null;

    } else {
      _cohens_d = 2 * _tValue / sqrt(_totalN);
      _hedges_g = _cohens_d * (1 - (3 / (4 * (_totalN) - 9)));
      _df = _totalN - 2;
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
        MyTitle(DsFromTForIndependentSamplesTitle),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'Total N', onChanged: _onChanged, controller: totalN),
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
}

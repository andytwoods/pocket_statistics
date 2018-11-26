import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:statistical_power/dists/f.dart';
import 'package:statistical_power/dists/normal.dart';
import 'package:statistical_power/dists/student_t.dart';
import 'package:statistical_power/main.dart';
import 'package:statistical_power/stats/tdist.dart';
import 'package:statistical_power/widgets/base_container.dart';
import 'package:statistical_power/widgets/my_editable.dart';
import 'package:statistical_power/widgets/my_result.dart';
import 'package:statistical_power/widgets/title.dart';

class PartialNSquareAndWSquare extends StatefulWidget {
  @override
  PartialNSquareAndWSquareState createState() {
    return PartialNSquareAndWSquareState();
  }
}

class PartialNSquareAndWSquareState
    extends State<PartialNSquareAndWSquare> {
  final TextEditingController F = new TextEditingController(text: '');
  final TextEditingController dfEffect = new TextEditingController(text: '');
  final TextEditingController dfError = new TextEditingController(text: '');

  double _p, _npSquared, _wpSquared;

  void _onChanged() {
    double _F = double.tryParse(F.text);
    double _dfEffect = double.tryParse(dfEffect.text);
    double _dfError = double.tryParse(dfError.text);

    if (_F == null || _dfEffect == null || _dfError == null) {
      _p  = _npSquared = _wpSquared = null;

    } else {

      _npSquared = _F*_dfEffect/(_F*_dfEffect+_dfError);
      _wpSquared = (_F-1)/(_F+(_dfError+1)/(_dfEffect));

      _p = 1 - FCentral.cdf(_F, _dfEffect, _dfError);

      //TODO verify below is correct. 9 dp and later, some inconsistencies
      //_CL = 1-cl.cdf(1-_cohens_d /sqrt(2.0));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        MyTitle('Partial η² & ω² (latter only for One-Way ANOVA)'),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'F', onChanged: _onChanged, controller: F),
            MyEditable(
                title: 'df effect', onChanged: _onChanged, controller: dfEffect),
            MyEditable(
                title: 'df error', onChanged: _onChanged, controller: dfError)
          ],
        ),
        Row(children: [
          MyResult(title: "ηₚ²", value: safeVal(_npSquared)),
          MyResult(title: "wₚ²", value: safeVal(_wpSquared)),
          MyResult(title: "p", value: safeVal(_p))
        ]),
      ]),
    );
  }

  String safeVal(double cohens_d) {
    final AppWideInfo appWideInfo = AppWideInfo.of(context);
    print(appWideInfo);
    if (cohens_d == null) return '';
    return cohens_d.toString();
  }
}

import 'package:flutter/widgets.dart';
import 'package:statistical_power/widgets/my_editable.dart';
import 'package:statistical_power/widgets/title.dart';

class DsFromTForIndependentSamples extends StatefulWidget {
  @override
  DsFromTForIndependentSamplesState createState() {
    return new DsFromTForIndependentSamplesState();
  }
}

class DsFromTForIndependentSamplesState
    extends State<DsFromTForIndependentSamples> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      MyTitle('ds_from_t_for_independent_samples'),
      Row(
        children: <Widget>[
          MyEditable('Total N')
        ],
      )
    ]);
  }
}



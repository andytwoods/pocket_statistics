import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocket_statistics/dists/f.dart';
import 'package:pocket_statistics/widgets/base/sharted_tools_mixin.dart';
import 'package:pocket_statistics/widgets/my_editable.dart';
import 'package:pocket_statistics/widgets/my_editable_and_result.dart';
import 'package:pocket_statistics/widgets/my_result.dart';
import 'package:pocket_statistics/widgets/title.dart';

String GrimTitle = 'Grim';

class Grim extends StatefulWidget {
  @override
  GrimState createState() {
    return GrimState();
  }
}

class GrimState extends State<Grim>
    with SharedToolsMixin {
  final TextEditingController sampleSize = new TextEditingController(text: '');

  List<MyEditableAndResult> rows;

  double errorCount;
  String grimScore;


  @override
  void initState() {
    rows = [generateRow()];
  }

  void _onChanged() {

    void reset(){
      grimScore = '';
      errorCount = null;
      rows.forEach((MyEditableAndResult r){
        r.myState.value.clear();
        r.myState.setState(() {});
      });
    }

    double _sampleSize = double.tryParse(sampleSize.text);

    if(_sampleSize==null){reset();return;}

    errorCount = 0.0;
    rows.forEach((MyEditableAndResult r){
      double val = double.tryParse(r.myState.input.text);

      if(val!=null) {
        double expected = (val * _sampleSize).round().toDouble() / _sampleSize;
        if(expected!=val) errorCount ++;
        r.myState.value.text = expected.toString();
        r.myState.setState(() {});
      }
    });

    if(errorCount==0) grimScore = '0';
    else if(errorCount <= 2) grimScore = '1';
    else grimScore = '2 or 4';

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        MyTitle(GrimTitle),
        Row(
          children: <Widget>[
            MyEditable(title: 'Sample Size', onChanged: _onChanged, controller: sampleSize),
            MyResult(title: "Errors", value: safeVal(errorCount)),
            MyResult(title: "Grim score", value: grimScore),
          ],
        ),
        Divider(height: 30.0,color: Colors.black45,),
        Column(
          children: rows,
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[FlatButton.icon(icon: Icon(Icons.add), onPressed: (){
              rows.add(generateRow());
              setState(() {});
              },
label: Text('add more data'),
            ),])
      ]),
    );
  }

  MyEditableAndResult generateRow() {
    MyEditableAndResult m; // as used during initialisation
    m = MyEditableAndResult(
        editableTitle: 'Mean',
        resultTitle: 'Expected mean',
        onChanged: _onChanged,
        more: IconButton(icon: Icon(Icons.remove), onPressed: (){
          rows.remove(m);
          _onChanged();
          setState((){});
        },)
    );
    return m;
  }

}


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

  double grimScore;


  @override
  void initState() {
    rows = [generateRow()];
  }

  void _onChanged() {

    void reset(){

    }

    double _sampleSize = double.tryParse(sampleSize.text);
    if(_sampleSize==null){reset();return;}

    rows.forEach((MyEditableAndResult r){
      double val = double.tryParse(r.input.text);
      if(val==null) {reset(); return;}
      r.value.text = val.toString();
    });


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
            MyResult(title: "Grim score", value: safeVal(grimScore)),
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
label: Text('enter more data'),
            ),])
      ]),
    );
  }

  MyEditableAndResult generateRow() {
    MyEditableAndResult m; // as used during initialisation
    m = MyEditableAndResult(
        editableTitle: 'Mean',
        resultTitle: 'Expected mean',
        onChanged: ()=> _onChanged,
        more: IconButton(icon: Icon(Icons.remove), onPressed: (){
          rows.remove(m);
          setState((){});
        },)
    );
    return m;
  }

}


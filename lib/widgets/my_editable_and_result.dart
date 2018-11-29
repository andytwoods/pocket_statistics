

import 'package:flutter/material.dart';
import 'package:pocket_statistics/widgets/my_editable.dart';
import 'package:pocket_statistics/widgets/my_result.dart';

class MyEditableAndResult extends StatefulWidget {
  @required
  final String editableTitle, resultTitle;
  @required
  final Function onChanged;

  final Widget more;

  MyEditableAndResult({this.editableTitle, this.resultTitle, this.onChanged, this.more});

  MyEditableAndResultState myState;

  @override
  MyEditableAndResultState createState() {
    myState = MyEditableAndResultState();
    return myState;
  }
}

class MyEditableAndResultState extends State<MyEditableAndResult> {

  final TextEditingController value = new TextEditingController(text: '');
  final TextEditingController input = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyEditable(onChanged: widget.onChanged, title: widget.editableTitle, controller: input,),
        MyResult(title: widget.resultTitle, value: value.text,),
        widget.more==null?Container():widget.more
      ]

    );
  }
}
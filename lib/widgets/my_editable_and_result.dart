

import 'package:flutter/material.dart';
import 'package:pocket_statistics/widgets/my_editable.dart';
import 'package:pocket_statistics/widgets/my_result.dart';

class MyEditableAndResult extends StatefulWidget {
  @required
  final String editableTitle, resultTitle;
  @required
  final Function onChanged;
  @required
  final TextEditingController value = new TextEditingController(text: '');
  @required
  final TextEditingController input = new TextEditingController(text: '');
  final Widget more;

  MyEditableAndResult({this.editableTitle, this.resultTitle, this.onChanged, this.more});

  @override
  MyEditableAndResultState createState() {
    return new MyEditableAndResultState();
  }
}

class MyEditableAndResultState extends State<MyEditableAndResult> {

  final TextEditingController input = new TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MyEditable(onChanged: widget.onChanged, title: widget.editableTitle, controller: input,),
        MyResult(title: widget.resultTitle, value: widget.value.text,),
        widget.more==null?Container():widget.more
      ]

    );
  }
}
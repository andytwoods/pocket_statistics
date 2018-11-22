

import 'package:flutter/material.dart';

class MyEditable extends StatefulWidget{

  final String title;

  MyEditable(this.title);

  @override
  MyEditableState createState() {
    return new MyEditableState();
  }
}

class MyEditableState extends State<MyEditable> {

  TextEditingController controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Flexible(
      child: Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            color: Colors.lightGreenAccent,
          ),
          child: TextField(
            controller: controller,
              keyboardType: TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                  labelText: widget.title,
                prefixIcon: Icon(Icons.edit)
              )
          ),
        ),
      ),
    );
  }
}

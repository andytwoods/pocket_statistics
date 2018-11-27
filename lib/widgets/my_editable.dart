import 'package:flutter/material.dart';
import 'package:statistical_power/widgets/base/base_container.dart';

class MyEditable extends ValueStatelessWidget {

  @required
  final String title;
  @required
  final Function onChanged;
  @required
  final TextEditingController controller;

  MyEditable({this.title, this.onChanged, this.controller});

  @override
  Widget build(BuildContext context) {
    return MyContainer(
      retrieveMessage: retrieveMessage,
        retrieveValue: retrieveValue,
        color: Colors.lightGreenAccent,
        child: Stack(
          children: <Widget>[
            TextField(
              textAlign: TextAlign.center,
            controller: controller,
            onChanged: (_)=> onChanged(),
            keyboardType: TextInputType.numberWithOptions(
                decimal: true, signed: true),
            decoration: InputDecoration(
                border: InputBorder.none,
                labelText: title,
                contentPadding: null,
            )
    ),
            Align(
                alignment: Alignment.bottomRight,
                child: Icon(Icons.edit, size: 20.0, color: Colors.black26,))
          ],
        ));
  }

  @override
  String retrieveMessage() {
    return this.title;
  }

  @override
  String retrieveValue() {
    return controller.text;
  }
}


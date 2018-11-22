import 'package:flutter/material.dart';
import 'package:statistical_power/widgets/base_container.dart';

class MyEditable extends StatelessWidget {

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
        color: Colors.lightGreenAccent,
        child: TextField(
        controller: controller,
        onChanged: (_)=> onChanged(),
        keyboardType: TextInputType.numberWithOptions(
            decimal: true, signed: true),
        decoration: InputDecoration(
            labelText: title,
            prefixIcon: Icon(Icons.edit)
        )
    ));
  }
}


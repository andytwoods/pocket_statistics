import 'package:flutter/material.dart';

class DecimalPlaces extends StatelessWidget{

  static List<String> options = ['1', '2', '3', '4', '5', 'physics', '∞'];
  static String defaultOption = options.last;

  final String val;
  final Function onChanged;

  DecimalPlaces(this.val, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return new DropdownButton<String>(
      hint: Text('$val d.p.',
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.right,),
      items: options.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (val) {
        onChanged(val);
      },
    );
  }
}
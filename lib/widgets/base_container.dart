import 'package:flutter/material.dart';

class MyContainer extends StatelessWidget {

  @required
  final Widget child;
  final Color color;

  MyContainer({this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Container(
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: color,
                ),
                child: child
            )
        )
    );
  }

}

class Blank extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Container(
                margin: EdgeInsets.all(4.0),
            )
        )
    );
  }
}



import 'package:flutter/material.dart';

class MyTitle extends StatelessWidget{

  final String title;

  MyTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(title,
    style: Theme.of(context).textTheme.title,
    );
  }



}

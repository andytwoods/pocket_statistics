

import 'package:flutter/material.dart';
import 'package:pocket_statistics/widgets/base/base_container.dart';

class MyResult extends ValueStatelessWidget{

  @required
  final String title;
  @required
  final String value;

  MyResult({this.title, this.value});


  @override
  Widget build(BuildContext context) {
    return  MyContainer(
      retrieveValue: retrieveValue,
      retrieveMessage: retrieveMessage,
      color: Colors.yellowAccent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            child: Center(
              child: Text(title,
                style: Theme.of(context).textTheme.body1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Center(
                child: Text(
                  value,
//                    decoration: InputDecoration(
//                        prefixIcon: Icon(Icons.edit)
//                    )
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  String retrieveMessage() {
    return this.title;
  }

  @override
  String retrieveValue() {
    return value;
  }
}


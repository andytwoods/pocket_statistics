import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyContainer extends StatelessWidget {

  @required
  final Widget child;
  final Color color;
  final Function retrieveValue;
  final Function retrieveMessage;

  MyContainer({this.child, this.color = Colors.white, this.retrieveValue, this.retrieveMessage});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: GestureDetector(
          onLongPress: (){
            String txt = retrieveValue();
            Clipboard.setData(new ClipboardData(text: txt));
            if(txt.length>10){
              txt = txt.substring(0,10)+'...';
            }
            Scaffold.of(context).showSnackBar(
                new SnackBar(content: new Text("$txt Copied to Clipboard"),));
          },
          child: Container(
              margin: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                color: color,
              ),
              child: child
          ),
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

abstract class ValueStatelessWidget extends StatelessWidget {
  @protected
  String retrieveValue();
}
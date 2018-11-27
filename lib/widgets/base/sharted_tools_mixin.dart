import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:statistical_power/widgets/base/app_wide_info.dart';
import 'package:statistical_power/widgets/base/base_container.dart';

abstract class SharedToolsMixin <T extends StatefulWidget> extends State<T> {

  int dp;

  void visitor(Element element) {

    visitChildren(element: element);
    if(element.widget is MyContainer){
      MyContainer c = element.widget as MyContainer;
      String val = c.retrieveValue();
      String message = c.retrieveMessage();

      print('$message $val');
    }
  }

  void visitChildren({Element element}){
    if(element == null) this.context.visitChildElements(visitor);
    else element.visitChildElements(visitor);
  }

  void copyTree(){
    visitChildren();
  }

  @override
  void didChangeDependencies() {
    final AppWideInfo appWideInfo = AppWideInfo.of(context);
    dp = appWideInfo.dp;
    appWideInfo.copyTreeLinkup(copyTree);
  }

  String safeVal(double val) {
    if (val == null) return '';
    double mod = pow(10.0, dp+1);

    double computed;
    try {
      computed = ((val * mod).round().toDouble() / mod);
    }
    catch(e){
      computed = mod;
    }

    return computed.toString();
}

}

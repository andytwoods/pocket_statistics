import 'dart:math';

import 'package:flutter/material.dart';
import 'package:statistical_power/widgets/base/app_wide_info.dart';
import 'package:statistical_power/widgets/base/base_container.dart';

abstract class SharedToolsMixin<T extends StatefulWidget> extends State<T> {
  int dp;
  String title;

  String copyTree() {
    List<String> output = [title];

    //needs to be defined at top as Fs refer to each other
    //(and both can't be above the other).
    Function visitor, visitChildren;

    visitor = (Element element) {
      visitChildren(element: element);
      if (element.widget is MyContainer) {
        MyContainer c = element.widget as MyContainer;
        output.add(c.retrieveMessage() + ' = ' + c.retrieveValue());
      }
    };

    visitChildren = ({Element element}) {
      if (element == null)
        this.context.visitChildElements(visitor);
      else
        element.visitChildElements(visitor);
    };

    visitChildren();
    return output.join('\n');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final AppWideInfo appWideInfo = AppWideInfo.of(context);
    dp = appWideInfo.dp;
    appWideInfo.copyTreeLinkup(copyTree);
  }

  String safeVal(double val) {
    if (val == null) return '';
    double mod = pow(10.0, dp + 1);

    double computed;
    try {
      computed = ((val * mod).round().toDouble() / mod);
    } catch (e) {
      computed = mod;
    }

    return computed.toString();
  }
}

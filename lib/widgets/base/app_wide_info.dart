import 'package:flutter/material.dart';

class AppWideInfo extends InheritedWidget {

  AppWideInfo({
    Key key,
    this.child,
    this.dp,
  }): super(key: key, child: child);

  final int dp;
  final Widget child;

  static AppWideInfo of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(AppWideInfo);
  }

  @override
  bool updateShouldNotify(AppWideInfo oldWidget) => dp != oldWidget.dp;
}
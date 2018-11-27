import 'package:flutter/material.dart';
import 'package:statistical_power/widgets/base/app_wide_info.dart';

abstract class SharedToolsMixin <T extends StatefulWidget> extends State<T> {

  int dp;

  @override
  void didChangeDependencies() {
    final AppWideInfo appWideInfo = AppWideInfo.of(context);
    dp = appWideInfo.dp;
  }

}

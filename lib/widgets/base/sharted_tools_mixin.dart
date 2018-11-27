import 'package:flutter/material.dart';
import 'package:statistical_power/widgets/base/app_wide_info.dart';

abstract class SharedToolsMixin <T extends StatefulWidget> extends State<T> {

  int dp;

  @override
  void didChangeDependencies() {
    final AppWideInfo appWideInfo = AppWideInfo.of(context);
    dp = appWideInfo.dp;
  }

  String safeVal(double cohens_d) {
    if (cohens_d == null) return '';
    return cohens_d.toStringAsFixed(dp+1);
  }

}

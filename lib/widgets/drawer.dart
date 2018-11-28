import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:statistical_power/widgets/Partial_nSquare_and_wSquare.dart';
import 'package:statistical_power/widgets/correlated_samples.dart';
import 'package:statistical_power/widgets/ds_from_t_for_independent_samples.dart';
import 'package:statistical_power/widgets/ds_from_t_for_independent_samples_with_group_ns.dart';
import 'package:statistical_power/widgets/dz_from_t_correlated_samples.dart';
import 'package:statistical_power/widgets/independent_samples.dart';

Map<String, Function> pages = {
  CorrelatedSamplesTitle: () => CorrelatedSamples(),
  DsFromTForIndependentSamplesTitle: () => DsFromTForIndependentSamples(),
  DsFromTForIndependentSamplesWithNsTitle: () => DsFromTForIndependentSamplesWithNs(),
  DsFromTCorrelatedSamplesTitle: () => DsFromTCorrelatedSamples(),
  IndependentSamplesTitle: () => IndependentSamples(),
  PartialNSquareAndWSquareTitle: () => PartialNSquareAndWSquare()
};

class StatsDrawer extends StatelessWidget {

  @required
  Function selectedCallback;

  StatsDrawer({this.selectedCallback});

  @override
  Widget build(BuildContext ctxt) {
    List<MapEntry<String, Function>> pagesList = pages.entries.toList();

    return new Drawer(
        child: new ListView.builder(
            itemCount: pages.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == 0)
                return DrawerHeader(
                  child: new Text("QUICK STATS"),
                  decoration: new BoxDecoration(color: Colors.lightGreenAccent),
                );

              MapEntry<String, Function> m = pagesList[index];
              return new ListTile(
                title: new Text(m.key),
                onTap: () {
                  selectedCallback(m.value());
                  Navigator.of(context).pop();
                },
              );
            }));
  }
}

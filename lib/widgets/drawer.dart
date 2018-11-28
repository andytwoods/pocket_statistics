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
  DsFromTForIndependentSamplesWithNsTitle: () =>
      DsFromTForIndependentSamplesWithNs(),
  DsFromTCorrelatedSamplesTitle: () => DsFromTCorrelatedSamples(),
  IndependentSamplesTitle: () => IndependentSamples(),
  PartialNSquareAndWSquareTitle: () => PartialNSquareAndWSquare()
};

class StatsDrawer extends StatefulWidget {
  @required
  Function selectedCallback;

  StatsDrawer({this.selectedCallback});

  @override
  StatsDrawerState createState() {
    return new StatsDrawerState();
  }
}

class StatsDrawerState extends State<StatsDrawer> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext ctxt) {
    List<MapEntry<String, Function>> pagesList = pages.entries.toList();

    String searchFor = searchController.text.toLowerCase();
    if (searchFor.length > 0) {
      pagesList = pagesList.where((MapEntry<String, Function> pe) {
        return pe.key.toLowerCase().contains(searchFor);
      }).toList();
    }

    return new Drawer(child:
        new ListView.builder(itemBuilder: (BuildContext context, int index) {
      if (index == 0)
        return DrawerHeader(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Text("POCKET STATISTICS"),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () {
                            showAboutDialog(
                                context: context,
                                applicationLegalese:
                                    'github.com/andytwoods/pocket_statistics\n\nGNU General Public License v3.0');
                          },
                          child: Icon(
                            Icons.info,
                            color: Colors.black45,
                          ),
                        ),
                      )
                    ],
                  )),
              Container(
                decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(Radius.circular(10.0))),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  //pokes for a regeneration
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(1.0),
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                    labelText: 'search...',
                  ),
                ),
              )
            ],
          ),
          decoration: new BoxDecoration(color: Colors.lightGreenAccent),
        );
      index -= 1;

      if (index < pagesList.length) {
        MapEntry<String, Function> m = pagesList[index];
        return new ListTile(
          title: new Text(m.key),
          onTap: () {
            widget.selectedCallback(m.value());
            Navigator.of(context).pop();
          },
        );
      }

      return null;
    }));
  }
}

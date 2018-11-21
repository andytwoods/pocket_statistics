import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StatsDrawer extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Drawer(
        child: new ListView.builder(

          itemBuilder: (BuildContext context, int index) {
            if(index==0) return DrawerHeader(
              child: new Text("QUICK STATS"),
              decoration: new BoxDecoration(
                  color: Colors.orange
              ),
            );

            return new ListTile(
              title: new Text("Item => 1"),
              onTap: () {

              },
            );
          }

        )
    );
  }
}
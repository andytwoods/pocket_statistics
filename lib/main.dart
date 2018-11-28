import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:statistical_power/widgets/Partial_nSquare_and_wSquare.dart';
import 'package:statistical_power/widgets/base/app_wide_info.dart';
import 'package:statistical_power/widgets/decimal_places.dart';
import 'package:statistical_power/widgets/drawer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Pocket Statistics',
      theme: new ThemeData(
        //textTheme: TextTheme(),
        primarySwatch: Colors.blue,

      ),
      home: new MyHomePage(title: 'Pocket Statistics'),

    );
  }
}



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController dp = new TextEditingController(text: DecimalPlaces.defaultOption);

  Function _copyTree;

  Widget page = PartialNSquareAndWSquare();

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(

        title: new Text(widget.title),
        actions: <Widget>[
          DecimalPlaces(dp.text, (String val){
            setState(() {
              dp.text = val;
            });
          })
        ],
      ),
      drawer: StatsDrawer(selectedCallback:(Widget w) => setState(() {page = w;})),
      body: new Center(

        child: AppWideInfo(
            copyTreeLinkup: (Function _linkup)=> _copyTree = _linkup,
            dp: DecimalPlaces.options.indexOf(dp.text),
            child: page!=null?page: Container()
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: ()=>_copyTree==null?null: Share.share(_copyTree()),
        tooltip: 'Copy table to clipboard',
        child: Icon(Icons.content_copy),
      ),
    );
  }
}


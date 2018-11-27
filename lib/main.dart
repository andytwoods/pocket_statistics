import 'package:flutter/material.dart';
import 'package:statistical_power/widgets/Partial_nSquare_and_wSquare.dart';
import 'package:statistical_power/widgets/base/app_wide_info.dart';
import 'package:statistical_power/widgets/correlated_samples.dart';
import 'package:statistical_power/widgets/drawer.dart';
import 'package:statistical_power/widgets/ds_from_t_for_independent_samples.dart';
import 'package:statistical_power/widgets/ds_from_t_for_independent_samples_with_group_ns.dart';
import 'package:statistical_power/widgets/correlated_samples.dart';
import 'package:statistical_power/widgets/dz_from_t_correlated_samples.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController dp = new TextEditingController(text: DecimalPlaces.defaultOption);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
        actions: <Widget>[
          DecimalPlaces(dp.text, (String val){
            setState(() {
              dp.text = val;
            });
          })
        ],
      ),
      drawer: StatsDrawer(),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: AppWideInfo(
            dp: DecimalPlaces.options.indexOf(dp.text),
            child: PartialNSquareAndWSquare()
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: (){

        },
        tooltip: 'Copy table to clipboard',
        child: new Icon(Icons.content_copy),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DecimalPlaces extends StatelessWidget{

  static List<String> options = ['1', '2', '3', '4', '5', 'physics', 'all'];
  static String defaultOption = options.last;

  String val;
  Function onChanged;

  DecimalPlaces(this.val, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return new DropdownButton<String>(
      hint: Text('${val} dp'),
      items: options.map((String value) {
        return new DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),
      onChanged: (val) {
        onChanged(val);
      },
    );
  }


}
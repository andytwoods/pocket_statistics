# Pocket Statistics

An opensource proof-of-concept statistics app for Android and iPhone.

At the moment, the app only consists of a small number of tools for calculating effect sizes based on Daniel Lakens 'Calculating Effect Sizes' [toolsheet](https://osf.io/vbdah/). It is 'fully-wired' though, in that it is easy to add new stats-tools without really having to worry about 'app development'. 

It is my hope that we build from this and create something truly useful. 

Contributions most welcome.

### Why?
Why not.

## Technology behing the app
The app is written in [Flutter](https://flutter.io), a wonderful new opensource package from Google for creating Android and IOS apps (and soon, hopefully, [desktop apps](https://github.com/google/flutter-desktop-embedding)). Flutter takes care of most of the hard stuff such as:
* pretty elements on screen (text, images, inputs) 
* screen positions (in rows, columns, lists etc).
* transitions between pages
* orientation   

All coding in Flutter is done in [Dart](https://www.dartlang.org/) which is mostly straightforward (numbers must have atleast one decimal place though, e.g. 10.0). Flutter relies on Object Orientated Programming. Apps have a large tree structure of many many children and parent **widgets** (a key term -- most things are widgets in flutter) specifying both how the app will look and behave.  

## How to Contribute
There are many ways to help. Don't be daunted by the technology! 
* Keen coder? What about creating a new tool-page (see section below). Or porting [JStat](https://github.com/jstat/jstat) to Dart (which would make tool-page creation a lot easier). 
* If statistics is your thing, you could help construct formula, or proof the equations used.
* Science communicator? Could you make the writing more accessible for others?

### Installation

Install Flutter by following the [official guide](https://flutter.io/docs/get-started/install). 

You will need to decide on what IDE (code editor) you want to use. The guide assumes you will want to to install  Android Studio but you can also install Intellij IDEA Community (free) / Ultimate (paid for but [free for students/educators](https://www.jetbrains.com/student/)). I use Ultimate (and love it). 

If you decided to use Intellij IDEA there are several plugins you need to install (follow this [guide](https://stackoverflow.com/questions/50485795/how-to-install-flutter-and-dart-in-android-studio-and-inttellij)). If you follow the official guide's next step by [making your first app](https://flutter.io/docs/get-started/test-drive), these will be setup for you.
 
 You clone this repo within the Intellij via VCS -> Checkout From Version Control (select git and paste in this url https://github.com/andytwoods/pocket_statistics).

I develop using a virtual Android device. You can set one up in Intellij via Tools -> Android -> AVD Manager (if that option is disabled, here is a [solution](https://stackoverflow.com/questions/53497851/avd-manager-in-intellij-is-disabled/53497862#53497862)). I created a virtual Pixel 2. It is very easy though to also develop with actual androids or ios devices (in most cases, you just need to put your device in 'developer mode'). You cannot develop on a PC with an IOS device, however (although perhaps this could be done using Virtual Machines via e.g. VirtualBox).

### Creating a new page

* Duplicate an existing simple tool-page such as [lib/widgets/dz_from_t_correlated_samples.dart](https://github.com/andytwoods/pocket_statistics/blob/master/lib/widgets/dz_from_t_correlated_samples.dart). 

* Specify the layout of the page within the **build** method. Note how Rows and Columns are used. You can specify an empty 'cell' via Blank(). 

* All 'Inputs' need to have a TextEditingController specified for them (which allows for dynamic updating over the page).

* **setState(() {})** looks crazy but what it does is tell the app that the page needs to be refreshed.

* Dart numbers (double) **must** have at least 1 decimal place specified. E.g. 1.0. 

* Remember to add your created page to [lib/widgets/drawer.dart](https://github.com/andytwoods/pocket_statistics/blob/master/lib/widgets/drawer.dart).

```
String DsFromTCorrelatedSamplesTitle = 'dz from t for correlated samples';

class DsFromTCorrelatedSamples extends StatefulWidget {
  @override
  DsFromTCorrelatedSamplesState createState() {
    return new DsFromTCorrelatedSamplesState();
  }
}

class DsFromTCorrelatedSamplesState extends State<DsFromTCorrelatedSamples> with SharedToolsMixin {
  final TextEditingController totalN = new TextEditingController(text: '');
  final TextEditingController tValue = new TextEditingController(text: '');

  double _cohens_d, _p, _CL;
  //specify your variables

  // this is called when a value is updated.
  void _onChanged() {
    double _nPairs = double.tryParse(totalN.text);
    double _tValue = double.tryParse(tValue.text);
    if (_nPairs == null || _tValue == null) { 
      _cohens_d = _p = _CL = null;
      //wipe values here
    } else {
     _cohens_d = _p = _CL = 1.0;
     // set values here
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        MyTitle(DsFromTCorrelatedSamplesTitle),
        Row(
          children: <Widget>[
            MyEditable(
                title: 'n pairs', onChanged: _onChanged, controller: totalN),
            MyEditable(
                title: 't-value', onChanged: _onChanged, controller: tValue)
          ],
        ),
        Row(children: [
          MyResult(title: "Cohen's dz", value: safeVal(_cohens_d)),
          MyResult(title: "p-value", value: safeVal(_p))
        ]),
        Row(children: [
          MyResult(title: "CL effect size", value: safeVal(_CL)),
          Blank()
        ])
      ]),
    );
  }

}
```
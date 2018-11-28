# Pocket Statistics App

An opensource proof-in-concept statistics app for Android and iPhone.

Currently, the app consists of tools for calculating effect sizes based on Daniel Lakens 'Calculating Effect Sizes' [toolsheet](https://osf.io/vbdah/).

It is my hope that we build from this and create something truly useful :) 

Contributions most welcome. Please don't be daunted by the technology used! There are many ways to help, be it by porting statistical formula from other packages, improving documentation, or even spreading the word.

## Technology behing the app
The app is written in [Flutter](https://flutter.io), a wonderful new opensource package from Google for creating Android and IOS apps (and soon, hopefully, [desktop apps](https://github.com/google/flutter-desktop-embedding)). Flutter takes care of most of the hard stuff such as:
* pretty elements on screen (text, images, inputs) 
* screen positions (in rows, columns, lists etc).
* transitions between pages
* orientation   

All coding in Flutter is done in [Dart](https://www.dartlang.org/) which is mostly straightforward. Flutter heavily relies on Object Orientated Programming with an app resembling a large tree structure with many many children and parent **widgets** (a key term -- most things are widgets in flutter) specifying both how the app will look and behave.  

## How to Contribute

###Installation

Install Flutter by following the [official guide](https://flutter.io/docs/get-started/install). 

You will need to decide on what IDE (code editor) you want to use. The guide assumes you will want to to install  Android Studio but you can also install Intellij IDEA Community (free) / Ultimate (paid for but [free for students/educators](https://www.jetbrains.com/student/)). I use Ultimate (and love it). 

If you decided to use Intellij IDEA there are several plugins you need to install (follow this [guide](https://stackoverflow.com/questions/50485795/how-to-install-flutter-and-dart-in-android-studio-and-inttellij)). If you follow the official guide's next step by [making your first app](https://flutter.io/docs/get-started/test-drive), these will be setup for you.
 
 You clone this repo within the Intellij via VCS -> Checkout From Version Control (select git and paste in this url https://github.com/andytwoods/statistical_power_app).

I develop using a virtual Android device. You can set one up in Intellij via Tools -> Android -> AVD Manager (if that option is disabled, here is a [solution](https://stackoverflow.com/questions/53497851/avd-manager-in-intellij-is-disabled/53497862#53497862)). I created a virtual Pixel 2. It is very easy though to also develop with actual androids or ios devices (in most cases, you just need to put your device in 'developer mode'). You cannot develop on a PC with an IOS device, however (although perhaps this could be done using Virtual Machines via e.g. VirtualBox).


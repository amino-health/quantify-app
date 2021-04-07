import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeScreen.dart';
//import 'package:quantify_app/screens/welcomeScreen.dart';
//import 'package:quantify_app/screens/addActivityScreen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    Map<int, Color> color = {
      50: Color.fromRGBO(153, 22, 61, .1),
      100: Color.fromRGBO(153, 22, 61, .2),
      200: Color.fromRGBO(153, 22, 61, .3),
      300: Color.fromRGBO(153, 22, 61, .4),
      400: Color.fromRGBO(153, 22, 61, .5),
      500: Color.fromRGBO(153, 22, 61, .6),
      600: Color.fromRGBO(153, 22, 61, .7),
      700: Color.fromRGBO(153, 22, 61, .8),
      800: Color.fromRGBO(153, 22, 61, .9),
      900: Color.fromRGBO(153, 22, 61, 1),
    };

    MaterialColor primaryColor = MaterialColor(0xFF99163D, color);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
        theme: ThemeData(primarySwatch: primaryColor), home: HomeScreen());
  }
}

import 'package:flutter/material.dart';
import 'package:quantify_app/screens/welcomeScreen.dart';
//import 'package:quantify_app/screens/addActivityScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFF99163D),
        ),
        home: WelcomeScreen());
  }
}

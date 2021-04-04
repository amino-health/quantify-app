import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/user.dart';

//import 'package:quantify_app/screens/welcomeScreen.dart';
//import 'package:quantify_app/screens/createActivityScreen.dart';
import 'package:flutter/services.dart';
//import 'package:quantify_app/screens/authenticate/register.dart';

import 'package:quantify_app/screens/welcomeScreen.dart';
import 'package:quantify_app/services/auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: WelcomeScreen(),
      ),
    );
  }
}

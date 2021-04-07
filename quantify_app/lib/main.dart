//import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:flutter/services.dart';
//import 'package:quantify_app/screens/authenticate/register.dart';
import 'package:quantify_app/screens/welcomeScreen.dart';
import 'package:quantify_app/services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Container(
              child: Text("FEL"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<UserClass>.value(
            value: AuthService().user,
            child: MaterialApp(
              home: WelcomeScreen(),
            ),
          );
        }
        return MaterialApp(
          home: Container(
            child: Text("WAITING"),
          ),
        );
      },
    );
  }
}

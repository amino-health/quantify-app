//import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:flutter/services.dart';
//import 'package:quantify_app/screens/authenticate/register.dart';
import 'package:quantify_app/screens/welcomeScreen.dart';
import 'package:quantify_app/services/auth.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runZonedGuarded<Future<void>>(() async {
    runApp(MyApp());

    await Firebase.initializeApp();
  }, (error, stackTrace) {
    print('Caught Dart Error');
    bool isInDebugMode = true;
    if (isInDebugMode) {
      print('$error');
      print('$stackTrace');
    } else {
      //send to error tracking in production
      FirebaseCrashlytics.instance.recordError(error, stackTrace);
    }
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

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
              theme: ThemeData(primarySwatch: primaryColor),
              home: WelcomeScreen(),
            ),
          );
        }
        return MaterialApp(
          home: Container(
            child: Loading(),
          ),
        );
      },
    );
  }
}

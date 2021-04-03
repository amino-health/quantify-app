import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/user.dart';
import 'package:quantify_app/screens/authenticate/authenticate.dart';
import 'package:quantify_app/screens/homeScreen.dart';

//Listen when we will get the user object back, listen auth changes
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Return Home or Authenticate widget, depending on if user loggged in or not
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return HomeScreen();
    }
  }
}

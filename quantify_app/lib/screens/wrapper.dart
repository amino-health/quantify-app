import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/authenticate/authenticate.dart';
import 'package:quantify_app/screens/homeScreen.dart';
import 'package:quantify_app/screens/userInfoScreen.dart';
import 'package:quantify_app/services/database.dart';

import 'tos.dart';

//Listen when we will get the user object back, listen auth changes
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Return Home or Authenticate widget, depending on if user loggged in or not
    final user = Provider.of<UserClass>(context);
    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            UserData userData = snapshot.data;
            if (snapshot.hasData) {
              if (userData.getNewUser()) {
                return UserInfoScreen();
              }
              if (!userData.consent) {
                return TosScreen();
              } else {
                return HomeScreen();
              }
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Authenticate();
            } else {
              return Loading();
            }
          });
    }
  }
}

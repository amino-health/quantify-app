import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';

import 'package:quantify_app/screens/change.dart';
import 'package:quantify_app/screens/deleteAccount.dart';
import 'package:quantify_app/screens/reauthenticate/changeemail.dart';
import 'package:quantify_app/screens/reauthenticate/changepassword.dart';
import 'package:quantify_app/screens/tos.dart';
import 'package:quantify_app/screens/wrapper.dart';
import 'package:quantify_app/services/auth.dart';
import 'package:quantify_app/services/database.dart';
import 'package:settings_ui/settings_ui.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  //int _currentHeight = 190;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);
    final AuthService _auth = AuthService();

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            //Check if firebasedata thete
            UserData userData = snapshot.data;

            return SettingsList(
              contentPadding:
                  const EdgeInsets.only(left: 10, right: 10, top: 20),
              sections: [
                SettingsSection(
                  title: 'Contact info',
                  tiles: [
                    SettingsTile(
                      title: 'Email',
                      subtitle: userData.email,
                      onPressed: (BuildContext context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeEmail()),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Contact info',
                  tiles: [
                    SettingsTile(
                      title: 'Change password',
                      // subtitle: userData.email,
                      onPressed: (BuildContext context) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()),
                        );
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Body information',
                  tiles: [
                    SettingsTile(
                      title: 'Current height',
                      subtitle: userData.height,
                      onPressed: (BuildContext context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Change(
                                      toChange: "height",
                                      current: userData.height,
                                    )));
                      },
                    ),
                    SettingsTile(
                      title: 'Current weight',
                      subtitle: userData.weight,
                      onPressed: (BuildContext context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Change(
                                      toChange: "weight",
                                      current: userData.weight,
                                    )));
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Account information',
                  tiles: [
                    SettingsTile(
                      title: 'Sign out',
                      // ignore: deprecated_member_use
                      onTap: () async {
                        await _auth.signOut();
                      },
                    ),
                    SettingsTile(
                      title: 'Delete account',
                      onPressed: (BuildContext context) async {
                        bool result = await showDialog(
                            context: context, builder: (_) => DeleteAccount());
                        if (result) {
                          await DatabaseService(uid: user.uid).removeDir();
                          _auth.deleteAccount();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Wrapper()));
                        } else {}
                      },
                    ),
                  ],
                ),
                SettingsSection(
                  title: 'Miscellaneous',
                  tiles: [
                    SettingsTile(
                      title: 'Terms & conditions',
                      onPressed: (BuildContext context) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TosScreen(
                                      showContinue: false,
                                    )));
                      },
                    ),
                    SettingsTile(
                      title: 'About Quantify',
                      onPressed: (BuildContext context) {},
                    ),
                  ],
                ),
              ],
            );
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Loading();
          } else {
            return Loading();
          }
        });
  }
}

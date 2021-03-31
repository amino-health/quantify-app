import 'package:flutter/material.dart';
import 'package:quantify_app/screens/change.dart';
import 'package:quantify_app/screens/tos.dart';
import 'package:quantify_app/screens/welcomeScreen.dart';
import 'package:settings_ui/settings_ui.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _currentEmail = 'current@email.com';
  int _currentWeight = 85;
  int _currentHeight = 190;

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 20),
      sections: [
        SettingsSection(
          title: 'Contact info',
          tiles: [
            SettingsTile(
              title: 'Email',
              subtitle: _currentEmail,
              onPressed: (BuildContext context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Change(
                              toChange: "email",
                              current: _currentEmail,
                            )));
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Body information',
          tiles: [
            SettingsTile(
              title: 'Current height',
              subtitle: '$_currentHeight cm',
              onPressed: (BuildContext context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Change(toChange: "height", current: _currentHeight,)));
              },
            ),
            SettingsTile(
              title: 'Current weight',
              subtitle: '$_currentWeight kg',
              onPressed: (BuildContext context) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Change(toChange: "weight", current: _currentWeight,)));
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Account information',
          tiles: [
            SettingsTile(
              title: 'Sign out',
              onPressed: (BuildContext context) {
                Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WelcomeScreen()));
              },
            ),
            SettingsTile(
              title: 'Delete account',
              onPressed: (BuildContext context) {
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
                        builder: (context) => TosScreen(showContinue: false,)));
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
  }
}

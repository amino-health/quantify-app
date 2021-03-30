import 'package:flutter/material.dart';
import 'package:quantify_app/screens/change.dart';
import 'package:quantify_app/screens/tos.dart';
import 'package:settings_ui/settings_ui.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
              subtitle: 'current@email.com',
              onPressed: (BuildContext context) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Change(toChange: "email")));
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Body information',
          tiles: [
            SettingsTile(
              title: 'Current height',
              subtitle: '190cm',
              onPressed: (BuildContext context) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Change(toChange: "height")));
              },
            ),
            SettingsTile(
              title: 'Current weight',
              subtitle: '85 kg',
              onPressed: (BuildContext context) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Change(toChange: "weight")));
              },
            ),
          ],
        ),
        SettingsSection(
          title: 'Account information',
          tiles: [
            SettingsTile(
              title: 'Sign out',
              onPressed: (BuildContext context) {},
            ),
            SettingsTile(
              title: 'Delete account',
              onPressed: (BuildContext context) {},
            ),
          ],
        ),
        SettingsSection(
          title: 'Miscellaneous',
          tiles: [
            SettingsTile(
              title: 'Terms of service',
              onPressed: (BuildContext context) {},
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

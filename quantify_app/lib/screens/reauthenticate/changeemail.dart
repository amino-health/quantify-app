import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/authenticate/register.dart';
import 'package:quantify_app/services/auth.dart';

import 'package:quantify_app/services/database.dart';

class ChangeEmail extends StatefulWidget {
  final String data;
  ChangeEmail({this.data});

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String newemail = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Reauthenticate:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto-Medium',
                            fontSize:
                                (MediaQuery.of(context).size.height * 0.03)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            validator: (val) {
                              return EmailValidator.validate(val)
                                  ? null
                                  : "Invalid email";
                            },
                            decoration: InputDecoration(
                              hintText: 'Email:',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onChanged: (val) {
                              setState(() => email = val.trim());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            obscureText: true,
                            validator: (val) => val.length < 8
                                ? 'Enter password 8+ chars'
                                : null, //Valid if not empto, return help tect
                            decoration: InputDecoration(
                              hintText: 'Password',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onChanged: (val) {
                              setState(() => password = val.trim());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            validator: (val) {
                              return EmailValidator.validate(val)
                                  ? null
                                  : "Invalid email";
                            },
                            decoration: InputDecoration(
                              hintText: 'New Email:',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onChanged: (val) {
                              setState(() => newemail = val.trim());
                            }),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: SizedBox(
                          height: 50,
                          width: 350,
                          child: ElevatedButton(
                            child: Text("Reauthenticate"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                try {
                                  bool working = await _auth.updateEmail(
                                    email: email,
                                    password: password,
                                    newEmail: newemail,
                                  );
                                  if (working) {
                                    await DatabaseService(uid: user.uid)
                                        .updateUserData(
                                            userData.name,
                                            userData.uid,
                                            newemail,
                                            userData.newuser,
                                            userData.age,
                                            userData.weight,
                                            userData.height,
                                            userData.consent,
                                            userData.gender);
                                    print('Sucess');
                                  } else {
                                    print('Fail');
                                  }
                                } catch (e) {
                                  {
                                    print('ERROR');
                                  }
                                }

                                Navigator.pop(context);

                                //Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF99163D),
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  // borderRadius: BorderRadius.circular(300),
                                  ),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        // ignore: missing_required_param
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          child: Text(
                            error, //title
                            textAlign: TextAlign.end, //aligment
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        // ignore: missing_required_param
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'Go back', //title
                            textAlign: TextAlign.end, //aligment
                          ),
                        ),
                      ),
                      // ignore: deprecated_member_use
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

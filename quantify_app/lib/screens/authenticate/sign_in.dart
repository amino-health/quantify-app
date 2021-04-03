import 'package:flutter/material.dart';
import 'package:quantify_app/screens/authenticate/register.dart';
import 'package:quantify_app/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
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
                'Log in:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto-Medium',
                    fontSize: (MediaQuery.of(context).size.height * 0.03)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    validator: (val) => val.isEmpty ? "Enter a email" : null,
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
                padding: EdgeInsets.symmetric(vertical: 2.0),
                child: ElevatedButton(
                  child: Text("Sign in"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF99163D),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
                child: ElevatedButton(
                  child: Text("Sign in with google"),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF99163D),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                // ignore: missing_required_param
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Register()));
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
                  onPressed: () => widget.toggleView(),
                  child: Text(
                    'Dont have an account yet? Sign up', //title
                    textAlign: TextAlign.end, //aligment
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

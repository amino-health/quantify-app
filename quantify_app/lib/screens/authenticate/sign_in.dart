import 'package:email_validator/email_validator.dart';
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
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: SizedBox(
                  height: 50,
                  width: 350,
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
                          // borderRadius: BorderRadius.circular(300),
                          ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                // ignore: missing_required_param
                child: Text('Or', //title
                    textAlign: TextAlign.end,
                    style: TextStyle(color: Colors.black) //aligment

                    ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    //child: Text("Sign in with Google"),
                    onPressed: () async {
                      dynamic result = await _auth.signInWithGoogle();
                      if (result == null) {
                        setState(() {
                          print("Could not sign in with those credentials");
                        });
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(300),
                          ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                            image: AssetImage("lib/assets/google_logo.png"),
                            height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 20),
                          child: Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(
                    //child: Text("Sign in with Google"),
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
                      primary: Color(0xFF3A559F),
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                          // borderRadius: BorderRadius.circular(300),
                          ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                            image: AssetImage("lib/assets/facebook_logo.png"),
                            height: 20.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            'Sign in with FaceBook',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
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
              // ignore: deprecated_member_use
            ],
          ),
        ),
      ),
    );
  }
}

//import 'package:quantify_app/screens/authenticate/sign_in.dart';
import 'package:quantify_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String error = '';
  String name = '';
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConf = TextEditingController();

  TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 80.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Register here:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: 'Roboto-Medium',
                    fontSize: (MediaQuery.of(context).size.height * 0.03)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(

                    controller: _nameController,

                    key: Key('inputName'),

                    validator: (val) => val.isEmpty ? "Ente a name" : null,
                    decoration: InputDecoration(
                      hintText: 'Full name',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    onChanged: (val) {
                      setState(() => name = val.trim());
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    key: Key('inputEmail'),
                    validator: (val) {
                      return EmailValidator.validate(val)
                          ? null
                          : "Invalid email";
                    }, //Valid if not empto, return help tect
                    decoration: InputDecoration(
                      hintText: 'Email',
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
                    key: Key('inputPassword'),
                    controller: _password,
                    validator: (val) {
                      String result = '';

                      val.length < 8
                          ? result = 'Enter password 8+ chars'
                          : result = null;

                      val == _passwordConf.text
                          ? result = null
                          : result = 'Password does not match';

                      return result;
                    },
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() => password = val.trim());
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                    key: Key('inputPasswordAgain'),
                    controller: _passwordConf,
                    decoration: InputDecoration(
                      hintText: 'Re-enter Password',
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      String result = '';

                      val.length < 8
                          ? result = 'Enter password 8+ chars'
                          : result = null;

                      val == _password.text
                          ? result = null
                          : result = 'Password does not match';

                      return result;
                    }),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                child: SizedBox(
                  height: 50,
                  width: 350,
                  child: ElevatedButton(

                    key: Key('register'),

                    child: Text("Sign up"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        name = _nameController.text.trim();
                        dynamic result =
                            await _auth.registerWithEmailAndPassword(
                                name,
                                email,
                                password); // If this succed want to go to
                        if (result == null) {
                          setState(() => error =
                              'Email already exist'); //Function vill show
                          print(error);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF99163D),
                      onPrimary: Colors.white,
                      // shape: RoundedRectangleBorder(
                      //   borderRadius: BorderRadius.circular(60.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                // ignore: missing_required_param
                child: TextButton(
                  onPressed: () => widget.toggleView(),
                  child: Text(
                    'Already have an account? Sign in', //title
                    textAlign: TextAlign.center, //aligment
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

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/screens/changeemail.dart';
import '../loading.dart';
import '../models/userClass.dart';
import '../services/database.dart';
import 'homeSkeleton.dart';

class Change extends StatefulWidget {
  final String toChange;
  final dynamic current;

  Change({Key key, this.toChange, this.current}) : super(key: key);

  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  final TextStyle titleTextStyle;

  _ChangeState({this.titleTextStyle});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    String _unit = widget.toChange == "weight"
        ? " kg"
        : widget.toChange == "height"
            ? " cm"
            : "";
    String _change = widget.toChange.toString();
    String _current = widget.current.toString() + _unit;

    TextEditingController _inputController = TextEditingController();
    final user = Provider.of<UserClass>(context);

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;

          if (snapshot.hasData) {
            return Scaffold(
              appBar: CustomAppBar(),
              body: Container(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Current ${widget.toChange}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          _current,
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Text(
                        "New ${widget.toChange}",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(top: 12, bottom: 10),
                        child: TextFormField(
                          controller: _inputController,
                          keyboardType: _change == "email"
                              ? TextInputType.text
                              : TextInputType.number,
                          inputFormatters: _change != "email"
                              ? <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(
                                      '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')),
                                ]
                              : null,
                          validator: (text) {
                            if (_change == "email") {
                              return EmailValidator.validate(text)
                                  ? null
                                  : "Invalid email";
                            }
                            if (_change == "height") {
                              try {
                                return double.parse(text) < 252.0 &&
                                        double.parse(text) > 67.0
                                    ? null
                                    : "Invalid height";
                              } catch (e) {
                                return "Can only contain digits";
                              }
                            }
                            if (_change == "weight") {
                              return double.parse(text) < 442.0 &&
                                      double.parse(text) > 30.0
                                  ? null
                                  : "Invalid height";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(4),
                            isDense: true,
                            hintText:
                                '${_change[0].toUpperCase()}${_change.substring(1)}',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (_change == "weight") {
                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                      userData.uid,
                                      userData.email,
                                      userData.newuser,
                                      userData.age,
                                      _inputController.text,
                                      userData.height,
                                      userData.consent,
                                      userData.gender);

                              Navigator.pop(context);
                            }
                            if (_change == "height") {
                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                      userData.uid,
                                      userData.email,
                                      userData.newuser,
                                      userData.age,
                                      userData.weight,
                                      _inputController.text,
                                      userData.consent,
                                      userData.gender);
                              Navigator.pop(context);
                            }
                            if (_change == "email") {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChangeEmail()),
                              );

                              result.updateEmail(_inputController.text);
                              print(context);
                            }
                          }
                        },
                        child: Text('Save'),
                      ),
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

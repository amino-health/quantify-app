import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/services/database.dart';
import 'package:flutter_picker/flutter_picker.dart';

//import 'package:flutter_svg/flutter_svg.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen({Key key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  DateTime selectedDate = DateTime.now();
  String dropdownValue = 'Gender';
  final _formKey = GlobalKey<FormState>();
  bool myvar = false;

  String newweight = '';
  String newheight = '';
  final _weighttext = TextEditingController();
  final _heighttext = TextEditingController();
  //bool _heightvalidate = false;
  //bool _weightvalidate = false;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  static const PickerData = '''['Gender', 'Male', 'Female']''';

  @override
  void dispose() {
    _weighttext.dispose();
    _heighttext.dispose();
    super.dispose();
  }

  _selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoDatePicker(context);
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: selectedDate.add(Duration(minutes: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  /// This builds cupertion date picker in iOS
  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 1900,
              maximumYear: 2021,
            ),
          );
        });
  }

  infotitle(String title, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 0,
        top: MediaQuery.of(context).size.height * 0.05,
      ),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontFamily: 'Roboto-Bold',
            fontSize: MediaQuery.of(context).size.height * 0.04),
      ),
      height: MediaQuery.of(context).size.height * 0.1,
      width: MediaQuery.of(context).size.width * 0.4,
    );
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData)),
        changeToFirst: true,
        textAlign: TextAlign.left,
        title: Text("Gender"),
        columnPadding: const EdgeInsets.all(8.0),
        onConfirm: (Picker picker, List value) {
          print(value.toString());
          print(picker.getSelectedValues());
        });
    picker.show(_scaffoldkey.currentState);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              key: _scaffoldkey,
              resizeToAvoidBottomInset: false,
              body: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Input your data:',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Roboto-Medium',
                            fontSize:
                                (MediaQuery.of(context).size.height * 0.03)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          readOnly: true,
                          onTap: () {
                            _selectDate(context);
                          },
                          focusNode: AlwaysDisabledFocusNode(),
                          decoration: InputDecoration(
                            hintText: 'Birth:',
                            labelText:
                                "${selectedDate.toLocal()}".split(' ')[0],
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32.0)),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            validator: (String val) =>
                                int.parse(val) < 30 && int.parse(val) > 442
                                    ? 'Enter a valid weight'
                                    : null,
                            //Valid if not empto, return help tect
                            decoration: InputDecoration(
                              hintText: 'Weight',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onChanged: (val) {
                              setState(() => newweight = val.trim());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            validator: (val) =>
                                int.parse(val) < 67 && int.parse(val) > 270
                                    ? 'Enter a valid height'
                                    : null,
                            decoration: InputDecoration(
                              hintText: 'Height',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            onChanged: (val) {
                              setState(() => newheight = val.trim());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          //width: 400.0,
                          // margin: EdgeInsets.fromLTRB(30.0, 10.0, 20.0, 10.0),
                          child: ElevatedButton(
                            onPressed: showPicker(context),
                            child: Text("Button"),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        child: SizedBox(
                          height: 50,
                          width: 350,
                          child: ElevatedButton(
                            child: Text("Confirm"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await DatabaseService(uid: user.uid)
                                    .updateUserData(
                                        userData.uid,
                                        userData.email,
                                        false,
                                        userData.age,
                                        newweight,
                                        newheight,
                                        userData.consent,
                                        dropdownValue);
                              }

                              //Navigator.pop(context);
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

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

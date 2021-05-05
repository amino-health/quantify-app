import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/services/database.dart';

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
    DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1905),
      lastDate: selectedDate.add(Duration(minutes: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );

    print(picked.millisecondsSinceEpoch);
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
                          key: Key('pickDate'),
                          readOnly: true,
                          onTap: () async {
                            await _selectDate(context);
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
                            key: Key('enterWeight'),
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
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() => newweight = val.trim());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                            key: Key('enterHeight'),
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
                            keyboardType: TextInputType.number,
                            onChanged: (val) {
                              setState(() => newheight = val.trim());
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          //width: 400.0,
                          //margin: EdgeInsets.fromLTRB(30.0, 0, 20.0, 0),
                          child: DropdownButtonHideUnderline(
                            child: Container(

                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                              width: MediaQuery.of(context).size.width * 0.6,

                              key: Key('pickGender'),
                              

                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        width: 1.0, color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(32.0))),
                              ),
                              child: DropdownButton<String>(
                                hint: Text('Gender'),
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                onTap: () => FocusScope.of(context).unfocus(),
                                onChanged: (String newValue) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <String>[
                                  'Gender',
                                  'Male',
                                  'Female',
                                  "Don't want to say"
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
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
                            key: Key('confirm'),
                            child: Text("Confirm"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await DatabaseService(uid: user.uid)
                                    .updateUserData(
                                        userData.name,
                                        userData.uid,
                                        userData.email,
                                        false,
                                        selectedDate.millisecondsSinceEpoch,
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

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:quantify_app/screens/homeScreen.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class UserInfoScreen extends StatefulWidget {
  UserInfoScreen({Key key});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  DateTime selectedDate = DateTime.now();

  String dropdownValue = 'Male';


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
      lastDate: DateTime(2021),
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







  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Row(
        //Date of birth row
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          infotitle('Birth', context),
          Container(
            child: TextField(
              onTap: () {
                _selectDate(context);
              },
              focusNode: AlwaysDisabledFocusNode(),
          
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                labelText: "${selectedDate.toLocal()}".split(' ')[0],
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.5,
          ),
        ],
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        infotitle('Weight', context),
        Container(
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            maxLength: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              labelText: 'Kilograms',
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.5,
        )
      ]),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        infotitle('Height', context),
        Container(
          child: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            maxLength: 3,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              labelText: 'Centimeters',
            ),
          ),
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.5,
        )
      ]),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            infotitle('Gender', context),
            Container(
              child: DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Color(0xFF99163D)),
                underline: Container(
                  height: 2,
                  color: Color(0xFF99163D),
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                  });
                },
                items: <String>['Male', 'Female', "Don't want to say"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            ]
          ),
          Padding(
              padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.25)),
              child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed))
                          return Color(0xDD99163D);
                        else
                          return Color(0xFF99163D);
                        
                      },
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 45.0, right: 45.0, top: 12.0, bottom: 12.0),
                    child: (Text('Get Started',
                        style:
                            TextStyle(fontFamily: 'Roboto-Medium', fontSize: 16.0))),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()
                        )
                    );
                  }
              ),
            ),
          
    ])));
  }
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
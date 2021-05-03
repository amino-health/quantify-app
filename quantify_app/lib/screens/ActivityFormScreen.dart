import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quantify_app/models/training.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
//import 'package:duration_picker/duration_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'package:fluttericon/rpg_awesome_icons.dart';

/*
  This list is used when rendering the image linked to the activity's categories. 
*/
List<IconData> iconList = [
  Icons.directions_bike,
  Icons.directions_run,
  Icons.directions_walk,
  Icons.sports_hockey,
  Icons.sports_baseball,
  Icons.sports_basketball,
  Icons.sports_football,
  Icons.sports_soccer,
  Icons.sports_tennis,
  Icons.sports_handball,
  Icons.miscellaneous_services,
  RpgAwesome.muscle_up,
];

class ActivityPopup extends StatefulWidget {
  final bool isAdd;

  final String titlevalue;
  final String subtitle;
  final DateTime date;
  final int duration;
  final int intensity;
  final int category;

  final keyRef;
  ActivityPopup(
      {ValueKey key,
      @required this.isAdd,
      @required this.titlevalue,
      @required this.subtitle,
      @required this.date,
      @required this.duration,
      @required this.intensity,
      @required this.keyRef,
      @required this.category})
      : super(key: key);

  @override
  _ActivityPopupState createState() => _ActivityPopupState(
      isAdd, titlevalue, subtitle, date, duration, intensity, keyRef, category);
}

class _ActivityPopupState extends State<ActivityPopup> {
  DateTime selectedDate = DateTime.now();
  Duration selectedTime = Duration(minutes: 30);
  double _currentSliderValue = 1;
  int _category = 0;
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();
  //TimeOfDay _time = TimeOfDay.now();
  final DateTime today = DateTime.now();
  TimeOfDay newTime;

  bool _titlevalidate = false;
  bool isAdd;
  String keyRef;
  String titlevalue;
  String subtitle;
  DateTime date;
  int duration;
  int category;

  int intensity;

  _ActivityPopupState(this.isAdd, this.titlevalue, this.subtitle, this.date,
      this.duration, this.intensity, this.keyRef, this.category);

  @override
  void dispose() {
    descriptioncontroller.dispose();
    titlecontroller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _currentSliderValue = intensity.roundToDouble();
    _category = category;
    selectedDate = date;
    selectedTime = Duration(milliseconds: duration);
    _fillController(titlecontroller, titlevalue);
    _fillController(descriptioncontroller, subtitle);
  }

//Switch cases meant to return different widgets for different platforms
  _selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return buildMaterialTimePicker(context);
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return buildCupertinoTimePicker(context);
    }
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

//Build the duration selector for Android
  buildMaterialTimePicker(BuildContext context) async {
    final Duration picked = await showDurationPicker(
      context: context,
      initialTime: Duration(hours: duration, minutes: duration),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  /// This builds duration cupertion date picker in iOS
  buildCupertinoTimePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: Colors.white,
                    child: CupertinoTimerPicker(
                        initialTimerDuration: Duration(milliseconds: duration),
                        mode: CupertinoTimerPickerMode.hm,
                        onTimerDurationChanged: (picked) {
                          if (picked != null && picked != selectedTime)
                            setState(() {
                              selectedTime = picked;
                            });
                        }),
                  ),
                  CupertinoButton(
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        Navigator.of(context).pop();
                      })
                ],
              ),
            ));
  }
//Build the start date selector for Android

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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

//Build the start date selector for iOS
  buildCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: Colors.white,
                    child: CupertinoDatePicker(
                        use24hFormat: true,
                        mode: CupertinoDatePickerMode.dateAndTime,
                        initialDateTime: selectedDate,
                        onDateTimeChanged: (picked) {
                          if (picked != null && picked != selectedDate)
                            setState(() {
                              selectedDate = picked;
                            });
                        }),
                  ),
                  CupertinoButton(
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        Navigator.of(context).pop();
                      })
                ],
              ),
            ));
  }

//Converts duration in milliseconds to hours and minutes and formats string value
  String convertTime(int time) {
    time ~/= 1000; //To centiseconds
    time ~/= 60; //to seconds
    int minutes = time % 60;
    time ~/= 60;
    int hours = time;
    if (hours == 1) {
      if (minutes == 0) {
        return "$hours Hour";
      } else {
        return "$hours Hour and $minutes Minutes";
      }
    }
    if (hours > 1) {
      if (minutes == 0) {
        return "$hours Hours";
      } else {
        return "$hours Hours and $minutes Minutes";
      }
    } else if (minutes > 0) {
      return "$minutes Minutes";
    } else {
      return "No duration";
    }
  }

  //Update the textform fields with the data they had last time if user
  //tries to add an activity they have added before
  TextEditingController _fillController(
      TextEditingController contr, String fillertext) {
    setState(() {
      if (isAdd) {
        contr.text = fillertext;
      }
    });
    return contr;
  }

//Widget that contains all textforms and pickers for view.
  Widget formBody(context) {
    return Column(
      children: [
        Expanded(
          flex: 92,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
                decoration: BoxDecoration(
                    color: Color(0xFFFFFFF6),
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(3, 8),
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 8)
                    ],
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 10,
                              right: MediaQuery.of(context).size.width * 0.15,
                              left: MediaQuery.of(context).size.width * 0.15),
                          child: Container(
                              child: TextFormField(
                            maxLength: 15,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              counterText: "",
                              labelText: 'Name',
                              errorText: _titlevalidate
                                  ? 'Value Can\'t Be Empty'
                                  : null,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                            controller: titlecontroller,
                          )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 0,
                              right: MediaQuery.of(context).size.width * 0.15,
                              left: MediaQuery.of(context).size.width * 0.15),
                          child: Container(
                              child: TextFormField(
                                  maxLines: 1,
                                  expands: false,
                                  maxLength: 128,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    counterText: "",
                                    labelText: 'Description',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                  ),
                                  //focusNode: isAdd ? AlwaysDisabledFocusNode() : FocusNode(),
                                  controller: descriptioncontroller)),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: 5,
                              bottom: 5,
                              right: MediaQuery.of(context).size.width * 0.15,
                              left: MediaQuery.of(context).size.width * 0.15),
                          child: Container(
                              child: TextFormField(
                            readOnly: true,
                            onTap: () {
                              _selectDate(context);
                            },
                            focusNode: AlwaysDisabledFocusNode(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: DateFormat('EEE, M/d/y - HH:mm')
                                  .format(selectedDate),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0)),
                            ),
                          )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: 10,
                              right: MediaQuery.of(context).size.width * 0.15,
                              left: MediaQuery.of(context).size.width * 0.15),
                          child: Container(
                              child: TextField(
                                  onTap: () {
                                    _selectTime(context);
                                  },
                                  focusNode: AlwaysDisabledFocusNode(),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: 'Duration',
                                      counterText: "",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                      labelText: convertTime(
                                          selectedTime.inMilliseconds)))),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.45,
                            child: CarouselSlider(
                              options: CarouselOptions(
                                initialPage: category,
                                onPageChanged: (index, reason) {
                                  setState(() {
                                    _category = index;
                                  });
                                },
                                viewportFraction: 0.5,
                                enlargeCenterPage: true,
                              ),
                              items: iconList.map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 5.0),

                                        // decoration: BoxDecoration(color: Colors.amber),
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child:
                                              Icon(i, color: Color(0xFF99163D)),
                                        ));
                                  },
                                );
                              }).toList(),
                            )),
                      ),
                      Expanded(
                        flex: 2,
                        child: SleekCircularSlider(
                            min: 1,
                            max: 10,
                            initialValue: intensity.roundToDouble(),
                            appearance: CircularSliderAppearance(
                                infoProperties:
                                    InfoProperties(modifier: sliderModifier),
                                customColors: CustomSliderColors(
                                    progressBarColor: Color(0xFF99163D))),
                            onChange: (double value) {
                              _currentSliderValue = value;
                            }),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        Expanded(
          flex: 8,
          child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text(isAdd ? "Add Activty" : "Create Activity"),
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
                  onPressed: () {
                    print(_category);
                    titlecontroller.text.isEmpty
                        ? _titlevalidate = true
                        : _titlevalidate = false;
                    if (_titlevalidate) {
                      setState(() {});
                    }

                    if (titlecontroller.text.isNotEmpty) {
                      Navigator.pop(
                          context,
                          TrainingData(
                            trainingid: keyRef.toString(),
                            name: titlecontroller.text.toString(),
                            description: descriptioncontroller.text.toString(),
                            date: selectedDate,
                            duration: selectedTime,
                            intensity: _currentSliderValue.round(),
                            listtype: 2,
                            inHistory: true,
                            category: _category,
                          ));
                    }
                  },
                ),
              )),
        )
      ],
    );
  }

//Formats text displayed inside rounded slider. double value is 0-100.
  String sliderModifier(double value) {
    final roundedValue = value.round().toInt().toString();
    return '$roundedValue / 10';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBar(),
        body: formBody(context));
  }
}

//Assignable to focusnode attribute of textformfield to prohibit input.
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

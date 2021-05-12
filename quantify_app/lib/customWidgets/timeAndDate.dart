//import 'package:duration_picker/duration_picker.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
class TimeAndDatePicker extends StatefulWidget {
  final ValueChanged<int> updateTime;
  final DateTime date;
  final int duration;

  TimeAndDatePicker({this.updateTime, this.date, this.duration});
  TimeAndDatePicker.duration({this.updateTime, this.date, this.duration});
  @override
  _TimeAndDatePickerState createState() => _TimeAndDatePickerState(
      updateTime: updateTime, date: date, duration: duration);
}

class _TimeAndDatePickerState extends State<TimeAndDatePicker> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Duration selectedDuration = Duration(hours: 0, minutes: 0);
  DateTime date;
  int duration;

  final ValueChanged<int> updateTime;
  _TimeAndDatePickerState({this.updateTime, this.date, this.duration});
  @override
  void initState() {
    super.initState();

    if (duration != null) {
      selectedDuration = Duration(milliseconds: duration);
    }

    print('date is $selectedDate');
    print('duration is $selectedDuration');
    selectedDate =
        DateTime(date.year, date.month, date.day, date.hour, date.minute);
    selectedTime = TimeOfDay(hour: date.hour, minute: date.minute);
  }

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

  selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return buildMaterialTimePicker(context);
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        return buildCupertinoTimePicker(context);
    }
  }

  selectDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return buildMaterialDatePicker(context);
      case TargetPlatform.macOS:
      case TargetPlatform.iOS:
        return buildCupertinoDatePicker(context);
    }
  }

  selectDuration(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        return buildMaterialDurationPicker(context);
      case TargetPlatform.iOS:
        return buildCupertinoTimePicker(context);
    }
  }

//Build the duration selector for Android
  buildMaterialDurationPicker(BuildContext context) async {
    final Duration picked = await showDurationPicker(
      context: context,
      initialTime: Duration(milliseconds: duration),
    );
    if (picked != null && picked != selectedDuration)
      setState(() {
        selectedDuration = picked;
        updateTime(selectedDuration.inMilliseconds);
      });
  }

//Build the duration selector for Android
  buildMaterialTimePicker(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
        selectedDate = DateTime(selectedDate.year, selectedDate.month,
            selectedDate.day, selectedTime.hour, selectedTime.minute);
        updateTime(selectedDate.millisecondsSinceEpoch);
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
                          if (picked != null && picked != selectedDuration)
                            setState(() {
                              selectedDuration = picked;
                              updateTime(selectedDuration.inMilliseconds);
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
    buildMaterialTimePicker(context);
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
                        updateTime(selectedDate.millisecondsSinceEpoch);
                        Navigator.of(context).pop();
                      })
                ],
              ),
            ));
  }

  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 5,
            bottom: 5,
            right: MediaQuery.of(context).size.width * 0.01,
            left: MediaQuery.of(context).size.width * 0.01),
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: TextFormField(
                focusNode: AlwaysDisabledFocusNode(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: duration == null
                      ? DateFormat('EEE, M/d/y - HH:mm').format(selectedDate)
                      : convertTime(selectedDuration.inMilliseconds),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                readOnly: true,
                onTap: duration == null
                    ? () => selectDate(context)
                    : () => selectDuration(context))));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

//Switch cases meant to return different widgets for different platforms

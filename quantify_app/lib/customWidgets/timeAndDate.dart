//import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

@immutable
class TimeAndDatePicker extends StatefulWidget {
  final ValueChanged<DateTime> update;
  final DateTime date;
  final int duration;

  TimeAndDatePicker({this.update, this.date, this.duration});
  @override
  _TimeAndDatePickerState createState() =>
      _TimeAndDatePickerState(update: update, date: date, duration: duration);
}

class _TimeAndDatePickerState extends State<TimeAndDatePicker> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  Duration selectedDuration = Duration(hours: 0);
  DateTime date;
  int duration = 0;

  final ValueChanged<DateTime> update;
  _TimeAndDatePickerState({this.update, this.date, this.duration});
  @override
  void initState() {
    super.initState();
    selectedDate = date;
    print('date is $date');
    selectedTime = TimeOfDay(hour: date.hour, minute: date.minute);
  }

  selectTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
        return buildMaterialTimePicker(context);
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
      case TargetPlatform.macOS:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
        return buildCupertinoDatePicker(context);
    }
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
        update(selectedDate);
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
                        update(selectedDate);
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
                  hintText:
                      DateFormat('EEE, M/d/y - HH:mm').format(selectedDate),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                ),
                readOnly: true,
                onTap: () => selectDate(context))));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

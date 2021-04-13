import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:quantify_app/screens/addActivityScreen.dart';

class ActivityPopup extends StatefulWidget {
  final bool isAdd;

  final String titlevalue;
  final String subtitle;

  final keyval;
  ActivityPopup(
      {ValueKey key,
      @required this.keyval,
      @required this.isAdd,
      @required this.titlevalue,
      @required this.subtitle})
      : super(key: key);

  @override
  _ActivityPopupState createState() =>
      _ActivityPopupState(keyval, isAdd, titlevalue, subtitle);
}

class _ActivityPopupState extends State<ActivityPopup> {
  DateTime selectedDate = DateTime.now();
  Duration selectedTime = Duration(minutes: 30);
  double _currentSliderValue = 1;
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();

  TimeOfDay _time = TimeOfDay.now();
  final DateTime today = DateTime.now();
  TimeOfDay newTime;
  int myVar;
  //This variable is updated in the inline else case
  //since flutter requires an else case in the 'done'
  //button onPressed attribute

  bool _titlevalidate = false;
  bool isAdd;
  String keyval;
  String titlevalue;
  String subtitle;
  _ActivityPopupState(this.keyval, this.isAdd, this.titlevalue, this.subtitle);

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

  buildMaterialTimePicker(BuildContext context) async {
    final Duration picked = await showDurationPicker(
      context: context,
      initialTime: new Duration(minutes: 30),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  /// This builds cupertion date picker in iOS
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

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: selectedDate,
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
                        initialDateTime: DateTime(today.year, today.month,
                            today.day, _time.hour, _time.minute),
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

  TextEditingController _fillController(
      TextEditingController contr, String fillertext) {
    setState(() {
      if (isAdd) {
        contr.text = fillertext;
      }
    });
    return contr;
  }

  @override
  Widget build(BuildContext context) {
    isAdd = this.isAdd;
    selectedTime = this.selectedTime;
    _titlevalidate = this._titlevalidate;
    return AlertDialog(
        content: SingleChildScrollView(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Form(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(isAdd ? 'Add activity' : 'Create Activity'),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 14, left: 8, right: 8),
                    child: Text(
                      'Activity name',
                      textAlign: TextAlign.left,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    //focusNode: isAdd ? AlwaysDisabledFocusNode() : FocusNode(),
                    decoration: InputDecoration(
                      errorText:
                          _titlevalidate ? 'Value Can\'t Be Empty' : null,
                    ),
                    controller: _fillController(titlecontroller, titlevalue),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, left: 8, right: 8),
                    child: Text(
                      'Short Description',
                      textAlign: TextAlign.left,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    //focusNode: isAdd ? AlwaysDisabledFocusNode() : FocusNode(),
                    controller:
                        _fillController(descriptioncontroller, subtitle),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 8, left: 8, right: 8),
                    child: Text(
                      'Start time',
                      textAlign: TextAlign.left,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    onTap: () {
                      _selectDate(context);
                    },
                    focusNode: AlwaysDisabledFocusNode(),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: "${selectedDate.toLocal()}".split(' ')[0] +
                          ' - ' +
                          "${selectedDate.toLocal()}".split(' ')[1][0] +
                          "${selectedDate.toLocal()}".split(' ')[1][1] +
                          "${selectedDate.toLocal()}".split(' ')[1][2] +
                          "${selectedDate.toLocal()}".split(' ')[1][3] +
                          "${selectedDate.toLocal()}".split(' ')[1][4],
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                    child: Text(
                      'Duration',
                      textAlign: TextAlign.left,
                      style: TextStyle(),
                    ),
                  ),
                ),
                Container(
                  child: TextField(
                    onTap: () {
                      _selectTime(context);
                    },
                    focusNode: AlwaysDisabledFocusNode(),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: selectedTime.toString().substring(0, 4),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Container(
                    child: Slider(
                  value: _currentSliderValue,
                  activeColor: Color(0xFF99163D),
                  inactiveColor: Colors.grey[500],
                  min: 1,
                  max: 10,
                  divisions: 10,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                )),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                  child: Container(child: Text('Intensity')),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: Text("Done"),
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
                      setState(() {
                        titlecontroller.text.isEmpty
                            ? _titlevalidate = true
                            : _titlevalidate = false;
                      });
                      titlecontroller.text.isNotEmpty
                          ? Navigator.pop(context, [
                              titlecontroller.text.toString(),
                              descriptioncontroller.text.toString(),
                              selectedDate.toString(),
                              _currentSliderValue.round().toString(),
                              keyval.toString()
                            ])
                          : myVar = 0;
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

class EnabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => true;
}

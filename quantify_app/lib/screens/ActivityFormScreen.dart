import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:quantify_app/screens/addActivityScreen.dart';

class ActivityPopup extends StatefulWidget {
  final bool isAdd;
  final String titlevalue;
  final String subtitle;
  ActivityPopup(
      {Key key,
      @required this.isAdd,
      @required this.titlevalue,
      @required this.subtitle})
      : super(key: key);

  @override
  _ActivityPopupState createState() =>
      _ActivityPopupState(isAdd, titlevalue, subtitle);
}

class _ActivityPopupState extends State<ActivityPopup> {
  DateTime selectedDate = DateTime.now();
  double _currentSliderValue = 1;
  final TextEditingController titlecontroller = TextEditingController();
  final TextEditingController descriptioncontroller = TextEditingController();

  bool isAdd;
  String titlevalue;
  String subtitle;
  _ActivityPopupState(this.isAdd, this.titlevalue, this.subtitle);

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
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
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

  @override
  Widget build(BuildContext context) {
    isAdd = this.isAdd;
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
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                      focusNode:
                          isAdd ? AlwaysDisabledFocusNode() : FocusNode(),
                      decoration:
                          InputDecoration(labelText: isAdd ? titlevalue : ''),
                      controller: titlecontroller),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
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
                      focusNode:
                          isAdd ? AlwaysDisabledFocusNode() : FocusNode(),
                      decoration:
                          InputDecoration(labelText: isAdd ? subtitle : ''),
                      controller: descriptioncontroller),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Short Description',
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
                      Navigator.pop(context, [
                        titlecontroller.text.toString(),
                        descriptioncontroller.text.toString(),
                        selectedDate.toString(),
                        _currentSliderValue.round().toString()
                      ]);
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
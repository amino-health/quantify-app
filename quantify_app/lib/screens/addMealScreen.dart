import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeScreen.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io' show Platform;

class AddMealScreen extends StatefulWidget {
  AddMealScreen({Key key}) : super(key: key);

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  FocusNode myFocusNode = FocusNode();

  final textController = TextEditingController();

  File _image;
  DateTime _date = new DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  final DateTime today = DateTime.now();
  // ignore: unused_field
  DateTime _timeStamp;
  String _note = "";
  @override
  void dispose() {
    myFocusNode.dispose();
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    bool _isIos;
    try {
      _isIos = Platform.isIOS || Platform.isMacOS;
    } catch (e) {
      _isIos = false;
    }
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 15),
            reverse: true,
            child: Column(children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.height * 0.4,
                decoration: BoxDecoration(
                    color: _image == null ? Colors.grey : Color(0x00000000),
                    image: _image != null
                        ? DecorationImage(image: FileImage(_image))
                        : null),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  FutureBuilder<String>(builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return new FloatingActionButton(
                        heroTag: "btn1",
                        onPressed: () async {
                          _getImageGallery();
                        },
                        backgroundColor: Color(0xff99163d),
                        child: Icon(_isIos
                            ? CupertinoIcons.photo_fill_on_rectangle_fill
                            : Icons.insert_photo));
                  }),
                  Padding(padding: EdgeInsets.only(left: 20, right: 20)),
                  FutureBuilder<String>(builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return new FloatingActionButton(
                        heroTag: "btn2",
                        onPressed: () async {
                          _getImageCamera();
                        },
                        backgroundColor: Color(0xff99163d),
                        child: Icon(_isIos
                            ? CupertinoIcons.camera_fill
                            : Icons.local_see));
                  }),
                ]),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  textInputAction: TextInputAction.go,
                  focusNode: myFocusNode,
                  controller: textController,
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Write something about your meal!",
                      hintStyle: TextStyle(fontFamily: 'Roboto-Medium')),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  color: Color(0x00f0f0f0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        return const Color(0xFF99163D);
                      })),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        DateTime newDate;
                        if (_isIos) {
                          await showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) => Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: CupertinoDatePicker(
                                      mode: CupertinoDatePickerMode.date,
                                      onDateTimeChanged: (picked) {
                                        FocusScope.of(context).unfocus();

                                        newDate = picked;
                                      },
                                      maximumDate: DateTime.now(),
                                      initialDateTime: _date,
                                      minimumDate: DateTime(2000),
                                    ),
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
                            ),
                          );
                        } else {
                          FocusScope.of(context).unfocus();
                          newDate = await showDatePicker(
                              context: context,
                              initialDate: _date,
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now());
                        }
                        if (newDate != null) {
                          setState(() {
                            _date = newDate;
                            _timeStamp = DateTime(_date.year, _date.month,
                                _date.day, _time.hour, _time.minute);
                          });
                        }
                      },
                      child: Text(
                        _date.year.toString() +
                            "-" +
                            (_date.month < 10 ? "0" : "") +
                            _date.month.toString() +
                            "-" +
                            (_date.day < 10 ? "0" : "") +
                            _date.day.toString(),
                        style: TextStyle(
                            fontSize: 22, fontFamily: 'Roboto-Medium'),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    ":",
                    style: TextStyle(fontSize: 22, fontFamily: 'Roboto-Medium'),
                  ),
                ),
                Container(
                  color: Color(0x00f0f0f0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor:
                          MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                        return const Color(0xFF99163D);
                      })),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();

                        TimeOfDay newTime;
                        if (_isIos) {
                          await showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => Container(
                                    color: Colors.white,
                                    height: MediaQuery.of(context).size.height *
                                        0.6,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          color: Colors.white,
                                          child: CupertinoDatePicker(
                                              use24hFormat: true,
                                              mode:
                                                  CupertinoDatePickerMode.time,
                                              initialDateTime: DateTime(
                                                  today.year,
                                                  today.month,
                                                  today.day,
                                                  _time.hour,
                                                  _time.minute),
                                              onDateTimeChanged: (picked) {
                                                newTime =
                                                    TimeOfDay.fromDateTime(
                                                        picked);
                                              }),
                                        ),
                                        CupertinoButton(
                                            child: Text(
                                              'OK',
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();

                                              Navigator.of(context).pop();
                                            })
                                      ],
                                    ),
                                  ));
                        } else {
                          FocusScope.of(context).unfocus();

                          newTime = await showTimePicker(
                              context: context, initialTime: _time);
                        }
                        if (newTime != null) {
                          setState(() {
                            _time = newTime;
                            _timeStamp = DateTime(_date.year, _date.month,
                                _date.day, _time.hour, _time.minute);
                          });
                        }
                      },
                      child: Text(
                        (_time.hour < 10 ? "0" : "") +
                            _time.hour.toString() +
                            ":" +
                            (_time.minute < 10 ? "0" : "") +
                            _time.minute.toString(),
                        style: TextStyle(
                            fontSize: 22, fontFamily: 'Roboto-Medium'),
                      ),
                    ),
                  ),
                ),
              ]),
              Container(
                  padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height * 0.05),
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ElevatedButton(
                    onPressed: () {
                      _note = textController.text;
                      if (_note == "") {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Center(child: Text("Hold up!")),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("No"),
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith<
                                                  Color>(
                                              (Set<MaterialState> states) {
                                        return const Color(0xFF99163D);
                                      })),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()),
                                            (Route<dynamic> route) => false);
                                      },
                                      child: Text("Yes"),
                                      style: ButtonStyle(backgroundColor:
                                          MaterialStateProperty.resolveWith<
                                                  Color>(
                                              (Set<MaterialState> states) {
                                        return const Color(0xFF99163D);
                                      })),
                                    )
                                  ],
                                )
                              ],
                              content: Text(
                                "You haven't filled in any info. Are you sure that you want to add this meal?",
                                style: TextStyle(fontFamily: "roboto-medium"),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        );
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                            (Route<dynamic> route) => false);
                      }
                    },
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
                      child: (Text('Add meal',
                          style: TextStyle(
                              fontFamily: 'Roboto-Medium', fontSize: 16.0))),
                    ),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

  _getImageGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);

    File croppedFile;
    //File result;
    if (image != null) {
      croppedFile = await _cropImage(image);
      setState(() {
        _image = croppedFile;
      });
    }
  }

  _getImageCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);

    File croppedFile;
    //File result;
    if (image != null) {
      croppedFile = await _cropImage(image);
      setState(() {
        _image = croppedFile;
      });
    }
  }

  _cropImage(image) async {
    return await ImageCropper.cropImage(
        cropStyle: CropStyle.rectangle,
        sourcePath: image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [CropAspectRatioPreset.square, CropAspectRatioPreset.original]
            : [
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop your image',
            toolbarColor: Color(0xFF99163d),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: "Crop your image",
          minimumAspectRatio: 1.0,
        ));
  }
}

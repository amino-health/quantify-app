import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/customWidgets/timeAndDate.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/mealData.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:quantify_app/services/database.dart';
//import 'package:quantify_app/customWidgets/globals.dart' as globals;

class AddMealScreen extends StatefulWidget {
  final _image;
  final _date;
  final _time;
  final _note;
  final _imageUrl;
  final _edit;
  final _docId;
  AddMealScreen({Key key})
      : _image = [File(''), File(''), File(''), File('')],
        _date = new DateTime.now(),
        _time = TimeOfDay.now(),
        _note = "",
        _imageUrl = [null, null, null, null],
        _edit = false,
        _docId = null,
        super(key: key);
  AddMealScreen.edit(List<File> image, date, time, note, url, edit, docId)
      : this._image = image,
        this._date = date,
        this._time = time,
        this._note = note,
        this._imageUrl = url,
        this._edit = edit,
        this._docId = docId;
  @override
  _AddMealScreenState createState() => _AddMealScreenState(
      _image, _date, _time, _note, _imageUrl, _edit, _docId);
}

class _AddMealScreenState extends State<AddMealScreen> {
  _AddMealScreenState(this._image, this._date, this._time, this._note,
      this._imageUrl, this._edit, this._docId);
  FocusNode myFocusNode = FocusNode();
  final textController = TextEditingController();
  List<File> _image;
  DateTime _date;
  TimeOfDay _time;
  String _note;
  List<String> _imageUrl;
  bool _edit = false;
  String _docId;
  bool _imageChanged = false;
  final DateTime today = DateTime.now();
  DateTime _timeStamp;
  var _displayImage;
  int _index;
  List<File> imageList;
  DateTime newDate;
  @override
  void initState() {
    super.initState();
    textController.text = _note;
    if (_image != null) {
      while (_image.length < 4) {
        _image.add(File(''));
      }
    }
    if (_imageUrl != null) {
      while (_imageUrl.length < 4) {
        _imageUrl.add(null);
      }
    }
    imageList = _image;
    _timeStamp =
        DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    // Clean up the controller when the widget is disposed.
    textController.dispose();
    super.dispose();
  }

  void setDate(int dateTimeInt) {
    print('datetime is $dateTimeInt');
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(dateTimeInt);

    _date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    _time = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  Widget addImageButton(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 1.0),
                    child: InkWell(
                      onTap: () async {
                        _getImageCamera(index);
                      },
                      child: Container(
                        child: Icon(Icons.camera_alt),
                        color: Color(0xFF99163D),
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 1.0),
                    child: InkWell(
                      onTap: () async {
                        _getImageGallery(index);
                      },
                      child: Container(
                        child: Icon(Icons.photo_album),
                        color: Color(0xFF99163D),
                        height: MediaQuery.of(context).size.width * 0.1,
                        width: MediaQuery.of(context).size.width * 0.2,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  Future<Widget> fetchImage(BuildContext context, bool _isIos, String localPath,
      String imgRef) async {
    if (localPath != null) {
      try {
        File imageFile = File(localPath);
        if (await imageFile.exists()) {
          Image img = Image.file(imageFile);
          return img;
        }
      } on FileSystemException {
        print("Couldn't find local image");
      } catch (e) {
        print(e);
      }
    }
    return imgRef != null
        ? CachedNetworkImage(
            width: 85,
            progressIndicatorBuilder: (context, url, downProg) =>
                CircularProgressIndicator(value: downProg.progress),
            imageUrl: imgRef,
            errorWidget: (context, url, error) => Icon(_isIos
                ? CupertinoIcons.exclamationmark_triangle_fill
                : Icons.error),
          )
        : Container(
            child: Icon(
              Icons.image_not_supported,
              size: 60,
            ),
          );
  }

  Widget emptyImageContainer(
    BuildContext context,
    DecorationImage displayImage,
    int index,
  ) {
    if (index != 0 &&
        _image[index - 1].path != '' &&
        _image[index].path == '') {
      return addImageButton(context, index);
    }

    if (_image[index].path == '') {
      if (index == 0) {
        return addImageButton(context, index);
      } else {
        return Container();
      }
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.01),
        child: new InkWell(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                    height: MediaQuery.of(context).size.width * 0.2,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: FutureBuilder(
                        future: fetchImage(context, false, _image[index].path,
                            _imageUrl[index]),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            Loading();
                          } else {
                            return snapshot.data;
                          }
                          return Container();
                        }))),
            onTap: () async {
              _image[index].path == ''
                  ? _getImageGallery(index)
                  : setState(() {
                      _displayImage = displayImage;
                      _index = index;
                    });
            }),
      );
    }
  }

  void removeImage() {
    if (_index != null && _index < 4) {
      setState(() {
        _imageChanged = true;
        _displayImage = null;
        _image[_index] = File('');
        _index = 5;
        _image.sort((a, b) => a.path == '' ? 1 : 0);
      });
    }
  }

  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);

    List<dynamic> displayImageList = [null, null, null, null];
    int i = 0;
    for (File image in _image) {
      if (image.path != '') {
        displayImageList[i] = (DecorationImage(image: FileImage(image)));
      } else if (_imageUrl != null &&
          _imageUrl.length > i &&
          _imageUrl[i] != null) {
        displayImageList[i] =
            (DecorationImage(image: NetworkImage(_imageUrl[i])));
      } else {
        displayImageList[i] = (null);
      }
      i++;
    }
    return Container(
      child: StreamBuilder<UserClass>(
          stream: null,
          builder: (context, snapshot) {
            var children = [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Stack(children: [
                    Container(
                        //This container contains the grey area for the photo, changes to the image if one is taken.
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          color: _displayImage == null
                              ? Colors.grey
                              : Color(0x00000000),
                        ),
                        child: _displayImage != null
                            ? FutureBuilder(
                                future: fetchImage(context, false,
                                    _image[_index].path, _imageUrl[_index]),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (!snapshot.hasData) {
                                    Loading();
                                  } else {
                                    return snapshot.data;
                                  }
                                  return Container();
                                })
                            : null),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        color: Colors.white.withOpacity(0.5),
                        child: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => removeImage()),
                      ),
                    )
                  ]),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<String>(builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return emptyImageContainer(
                          context, displayImageList[0], 0);
                    }),
                    FutureBuilder<String>(builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return emptyImageContainer(
                          context, displayImageList[1], 1);
                    }),
                    FutureBuilder<String>(builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return emptyImageContainer(
                          context, displayImageList[2], 2);
                    }),
                    FutureBuilder<String>(builder:
                        (BuildContext context, AsyncSnapshot<String> snapshot) {
                      return emptyImageContainer(
                          context, displayImageList[3], 3);
                    }),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.go,
                  focusNode: myFocusNode,
                  controller: textController,
                  maxLines: null,
                  onSubmitted: (value) {
                    textController.text = value;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 128,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                      hintText: "Write something about your meal!",
                      hintStyle: TextStyle(fontFamily: 'Roboto-Medium')),
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.75,
                  child:
                      TimeAndDatePicker(updateTime: setDate, date: _timeStamp)),
              Container(
                  padding: EdgeInsets.only(
                      top: (MediaQuery.of(context).size.height * 0.05),
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: ElevatedButton(
                    onPressed: () {
                      _note = textController.text;
                      if (_note == "" && _image[0].path == '') {
                        _removeWarning(user);
                      } else {
                        _uploadMealAndNavigate(user);
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
                      child: (Text(_edit ? "Edit" : 'Add meal',
                          style: TextStyle(
                              fontFamily: 'Roboto-Medium', fontSize: 16.0))),
                    ),
                  ))
            ];
            return new Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: CustomAppBar(),
              body: GestureDetector(
                onTap: () =>
                    FocusScope.of(context).requestFocus(new FocusNode()),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
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
                      child: Column(children: children),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _getImageGallery(int index) async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    File croppedFile;
    //File result;
    if (image != null) {
      croppedFile = await _cropImage(image);
      setState(() {
        _image[index] = croppedFile;
        _index = index;
        imageList[index] = _image[index];
        _displayImage = DecorationImage(image: FileImage(_image[index]));
        _imageChanged = true;
      });
    }
  }

  _getImageCamera(int index) async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    File croppedFile;
    //File result;
    if (image != null) {
      croppedFile = await _cropImage(image);
      setState(() {
        _image[index] = croppedFile;

        imageList[index] = _image[index];
        _index = index;
        _displayImage = DecorationImage(image: FileImage(_image[index]));
        _imageChanged = true;
      });
    }
  }

  _cropImage(image) async {
    return await ImageCropper.cropImage(
        cropStyle: CropStyle.rectangle,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        sourcePath: image.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
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

  _removeWarning(user) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text("Hold up!")),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("No"),
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                    return const Color(0xFF99163D);
                  })),
                ),
                ElevatedButton(
                  onPressed: () {
                    _uploadMealAndNavigate(user);
                  },
                  child: Text("Yes"),
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
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
  }

  _uploadMealAndNavigate(user) {
    _timeStamp =
        DateTime(_date.year, _date.month, _date.day, _time.hour, _time.minute);
    if (_edit) {
      DatabaseService(uid: user.uid)
          .editMeal(_docId, _image, _timeStamp, _note, _imageChanged);
    } else {
      DatabaseService(uid: user.uid).uploadImage(imageList, _timeStamp, _note);
    }
    List<String> localList = [];
    for (File file in _image) {
      localList.add(file.path);
    }
    while (Navigator.canPop(context)) {
      Navigator.pop(context,
          new MealData(_note, _timeStamp, _imageUrl, _docId, localList));
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

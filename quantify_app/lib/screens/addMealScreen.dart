import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddMealScreen extends StatefulWidget {
  AddMealScreen({Key key}) : super(key: key);

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  File _image;
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                color: Colors.grey,
                image: _image != null
                    ? DecorationImage(image: FileImage(_image))
                    : null),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            FutureBuilder<String>(builder:
                (BuildContext context, AsyncSnapshot<String> snapshot) {
              return new ElevatedButton(
                  onPressed: () async {
                    _getImageCamera();
                  },
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                    return const Color(0xFF99163D);
                  })),
                  child: Text(
                    "Camera",
                  ));
            }),
            FutureBuilder<String>(builder:
                (BuildContext context, AsyncSnapshot<String> snapshot) {
              return new ElevatedButton(
                  onPressed: () async {
                    _getImageGallery();
                  },
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                    return const Color(0xFF99163D);
                  })),
                  child: Text(
                    "Gallery",
                  ));
            })
          ]),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SmartButton(),
      bottomNavigationBar: CustomNavBar(),
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

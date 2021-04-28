import 'dart:async';
import 'dart:io';
//import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/rpg_awesome_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/mealData.dart';
import 'package:quantify_app/models/training.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/ActivityFormScreen.dart';
import 'package:quantify_app/screens/addMealScreen.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/services/database.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class DiaryDetailsScreen extends StatefulWidget {
  final ValueKey keyRef;
  final String titlevalue;
  final String subtitle;
  final int dateTime;
  final int duration;
  final int intensity;
  final bool isIos;
  final String localPath;
  final String imgRef;
  final int category;

  const DiaryDetailsScreen(
      {Key key,
      @required this.keyRef,
      @required this.titlevalue,
      @required this.subtitle,
      @required this.dateTime,
      @required this.duration,
      @required this.intensity,
      @required this.isIos,
      @required this.localPath,
      @required this.imgRef,
      @required this.category})
      : super(key: key);

  @override
  _DiaryDetailsState createState() => _DiaryDetailsState(
      keyRef,
      titlevalue,
      subtitle,
      dateTime,
      duration,
      intensity,
      isIos,
      localPath,
      imgRef,
      category);
}

class _DiaryDetailsState extends State<DiaryDetailsScreen> {
  ValueKey keyRef;
  String titlevalue;
  String subtitle;
  int dateTime;
  int duration;
  int intensity;
  bool isIos;
  String localPath;
  String imgRef;
  int category;
  _DiaryDetailsState(
      this.keyRef,
      this.titlevalue,
      this.subtitle,
      this.dateTime,
      this.duration,
      this.intensity,
      this.isIos,
      this.localPath,
      this.imgRef,
      this.category);

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
  void _removeActivity(ValueKey dismissKey) {
    print('keyvalue is ${dismissKey.value}');
    final user = Provider.of<UserClass>(context, listen: false);
    DatabaseService(uid: user.uid).removeDiaryItem(dismissKey.value);
  }

  void _removeMeal(MealData mealToRemove) {
    print('in remove meal');
    final user = Provider.of<UserClass>(context, listen: false);
    DatabaseService(uid: user.uid).removeMeal(mealToRemove);
  }

  updateMeal(MealData mealData) {
    File file;
    if (mealData.localPath != null) {
      try {
        file = File(mealData.localPath);
      } catch (e) {}
    }
    print(file);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => AddMealScreen.edit(
                file,
                mealData.mealDate,
                TimeOfDay.fromDateTime(mealData.mealDate),
                mealData.mealDescription,
                mealData.mealImageUrl,
                true,
                mealData.docId)));
  }

  Future updateActivity(context, activityData) async {
    print(activityData);
    final user = Provider.of<UserClass>(context, listen: false);
    await DatabaseService(uid: user.uid).updateTrainingDiaryData(
        activityData.trainingid, //ID
        activityData.name, //name
        activityData.description, //description
        activityData.date, //date
        activityData.duration, //duration
        activityData.intensity, //Intensity
        activityData.category //category
        );
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

  Widget mealImage(context, String imageRef, String localPath, bool _isIos) {
    return FutureBuilder(
        future: displayImage(context, _isIos, localPath, imageRef),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            Loading();
          } else {
            return snapshot.data;
          }
          return Container();
        });
  }

  Widget activityImage(context, int duration, int intensity, int category) {
    print('icon is');

    print('category $category');
    print(Icon(iconList[category]));
    return Container(
      color: Color(0xFF99163D),
      child: Container(
          child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(iconList[category]),
              ))),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                    flex: 1,
                    child: Container(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                          duration == 0 ? 'NO DURATION' : convertTime(duration),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: 'rubik',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ))),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black,
                          ),
                          child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child: Text(intensity.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'rubik',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFFFFF6))),
                          )),
                    ))
              ],
            ),
          )
        ],
      )),
    );
  }

  Future<Widget> displayImage(BuildContext context, bool _isIos,
      String localPath, String imgRef) async {
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

  overlayView(bool isMeal, String titlevalue, String subtitle, int dateTime,
      {bool isIos,
      String localPath,
      String imgRef,
      int duration,
      int intensity,
      int category}) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
          child: Column(children: [
        Container(
            height: isMeal
                ? MediaQuery.of(context).size.width
                : MediaQuery.of(context).size.height * 0.35,
            child: Stack(
              children: [
                isMeal
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: FittedBox(
                            fit: BoxFit.fitHeight,
                            child:
                                mealImage(context, imgRef, localPath, isIos)),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: activityImage(
                            context, duration, intensity, category),
                      ),
                Container(
                    color: Colors.black.withOpacity(0.5),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    child: Text(
                        DateFormat('HH:mm\nEEEE - d MMMM').format(
                            DateTime.fromMillisecondsSinceEpoch(dateTime)),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'rubik',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white.withOpacity(0.8)))),
              ],
            )), //displayImage(context, isIos, localPath, imgRef))),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                alignment: Alignment.topLeft,
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
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(titlevalue,
                                    style: TextStyle(
                                        fontFamily: 'rubik',
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(subtitle,
                                    style: TextStyle(
                                        fontFamily: 'rubik',
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.grey[800])),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 20.0, bottom: 10),
                          child: (Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Color(0xFF99163D)),
                                  iconSize:
                                      MediaQuery.of(context).size.height * 0.06,
                                  onPressed: () {
                                    if (isMeal) {
                                      _removeMeal(new MealData(
                                          subtitle,
                                          DateTime.fromMillisecondsSinceEpoch(
                                              dateTime),
                                          imgRef,
                                          keyRef.value,
                                          localPath));
                                    } else {
                                      _removeActivity(keyRef);
                                    }
                                    Navigator.of(context).pop();
                                  }),
                              IconButton(
                                  icon: Icon(Icons.edit,
                                      color: Color(0xFF99163D)),
                                  iconSize:
                                      MediaQuery.of(context).size.height * 0.06,
                                  onPressed: () async {
                                    print('keyref is $keyRef');

                                    if (!isMeal) {
                                      TrainingData activityData =
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ActivityPopup(
                                                          keyRef: keyRef.value
                                                              .toString(),
                                                          isAdd: true,
                                                          titlevalue:
                                                              titlevalue,
                                                          subtitle: subtitle,
                                                          date: DateTime
                                                              .fromMillisecondsSinceEpoch(
                                                                  dateTime),
                                                          duration: duration,
                                                          intensity: intensity,
                                                          category: category)));
                                      if (activityData != null) {
                                        updateActivity(context, activityData);
                                      }
                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      updateMeal(new MealData(
                                          subtitle,
                                          DateTime.fromMillisecondsSinceEpoch(
                                              dateTime),
                                          imgRef,
                                          keyRef.value,
                                          localPath));
                                    }
                                    /*while (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }*/
                                  })
                            ],
                          )),
                        ))
                  ],
                ),
              ),
            ))
      ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (localPath == 'activity') {
      return overlayView(false, titlevalue, subtitle, dateTime,
          duration: duration, intensity: intensity, category: category);
    } else {
      return overlayView(true, titlevalue, subtitle, dateTime,
          isIos: isIos, localPath: localPath, imgRef: imgRef);
    }
  }
}

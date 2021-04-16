import 'dart:io';
//import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/mealData.dart';
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

  const DiaryDetailsScreen({
    Key key,
    @required this.keyRef,
    @required this.titlevalue,
    @required this.subtitle,
    @required this.dateTime,
    @required this.duration,
    @required this.intensity,
    @required this.isIos,
    @required this.localPath,
    @required this.imgRef,
  }) : super(key: key);

  @override
  _DiaryDetailsState createState() => _DiaryDetailsState(keyRef, titlevalue,
      subtitle, dateTime, duration, intensity, isIos, localPath, imgRef);
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
  _DiaryDetailsState(this.keyRef, this.titlevalue, this.subtitle, this.dateTime,
      this.duration, this.intensity, this.isIos, this.localPath, this.imgRef);

  void _removeActivity(ValueKey dismissKey) {
    print('keyvalue is ${dismissKey.value}');
    final user = Provider.of<UserClass>(context, listen: false);
    DatabaseService(uid: user.uid).removeDiaryItem(dismissKey.value);
  }

  void _removeMeal(MealData mealToRemove) {
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
      activityData[5], //ID
      activityData[0], //name
      activityData[1], //description
      activityData[2], //date
      activityData[3], //duration
      activityData[4], //Intensity
    );
  }

  bottomButton(BuildContext context, String _title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 6.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Colors.grey[800];
                                else
                                  return Colors.grey[700];
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 8, bottom: 8),
                          child: Text(
                            'Edit ' + _title,
                            style: TextStyle(fontFamily: 'roboto-bold'),
                          ),
                        ),
                        onPressed: () async {
                          print('keyref is $keyRef');

                          if (_title == 'Activity') {
                            List<Object> activityData = await showDialog(
                                context: context,
                                builder: (_) => ActivityPopup(
                                    keyRef: keyRef.value.toString(),
                                    isAdd: true,
                                    titlevalue: titlevalue,
                                    subtitle: subtitle,
                                    date: DateTime.fromMillisecondsSinceEpoch(
                                        dateTime),
                                    duration: duration,
                                    intensity: intensity));
                            updateActivity(context, activityData);
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            }
                          } else {
                            await updateMeal(new MealData(
                                subtitle,
                                DateTime.fromMillisecondsSinceEpoch(dateTime),
                                imgRef,
                                keyRef.value,
                                localPath));
                          }
                          /*while (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }*/
                        })))),
        Container(
            child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 6.0),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return Color(0xDD99163D);
                                else
                                  return Color(0xFF99163D);
                              },
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 8, bottom: 8),
                          child: Text(
                            'Delete ' + _title,
                            style: TextStyle(fontFamily: 'roboto-bold'),
                          ),
                        ),
                        onPressed: () async {
                          print('keyref is $keyRef');
                          _title == 'Activity'
                              ? _removeActivity(keyRef)
                              : _removeMeal(new MealData(
                                  subtitle,
                                  DateTime.fromMillisecondsSinceEpoch(dateTime),
                                  imgRef,
                                  keyRef.value,
                                  localPath));
                          Navigator.of(context).pop();
                        })))),
      ],
    );
  }

  Widget displayImage(
      BuildContext context, bool _isIos, String localPath, String imgRef) {
    if (localPath != null) {
      try {
        return Image.file(File(localPath));
      } catch (e) {}
    }
    return imgRef != null
        ? CachedNetworkImage(
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
            ),
          );
  }

  activityView(String titlevalue, String subtitle, int dateTime, int duration,
      int intensity) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
          child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                      fit: BoxFit.fill, child: Icon(Icons.directions_run)),
                  flex: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                  DateFormat('EEE, M/d/y\nHH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          dateTime)),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 25))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                    'Duration: ' +
                                        (Duration(milliseconds: duration)
                                                    .inMinutes /
                                                60)
                                            .toString() +
                                        ':' +
                                        (Duration(milliseconds: duration)
                                                    .inMinutes %
                                                60)
                                            .toString() +
                                        ' Hrs',
                                    style: TextStyle(fontSize: 25)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text('Intensity: ' + intensity.toString(),
                                  style: TextStyle(fontSize: 25))),
                        ),
                      ),
                    ],
                  ),
                  flex: 5,
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  titlevalue,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 2,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Text(subtitle, style: TextStyle(fontSize: 25)),
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          bottomButton(context, 'Activity')
        ],
      )),
    );
  }

  mealView(String titlevalue, String subtitle, int dateTime, bool isIos,
      String localPath, String imgRef) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
          child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                      fit: BoxFit.fill,
                      child: displayImage(context, isIos, localPath, imgRef)),
                  flex: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                  DateFormat('EEE, M/d/y\nHH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          dateTime)),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 60))),
                        ),
                      ),
                    ],
                  ),
                  flex: 5,
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  titlevalue,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 2,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Text(subtitle, style: TextStyle(fontSize: 25)),
                alignment: Alignment.topLeft,
              ),
            ),
          ),
          bottomButton(context, 'Meal')
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (localPath == 'activity') {
      return activityView(titlevalue, subtitle, dateTime, duration, intensity);
    } else {
      return mealView(titlevalue, subtitle, dateTime, isIos, localPath, imgRef);
    }
  }
}

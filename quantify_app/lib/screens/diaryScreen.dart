//import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/activityDiary.dart';
import 'package:quantify_app/models/training.dart';
import 'package:quantify_app/screens/ActivityFormScreen.dart';
import 'package:quantify_app/screens/addMealScreen.dart';
import 'package:quantify_app/screens/diaryDetailsScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantify_app/services/database.dart';
import 'package:quantify_app/models/mealData.dart';

class DiaryScreen extends StatefulWidget {
  DiaryScreen({ValueKey key, this.goToGraph, this.update});
  final ValueChanged goToGraph;
  final ValueChanged update;

  @override
  _DiaryScreenState createState() =>
      _DiaryScreenState(goToGraph: goToGraph, update: update);
}

class _DiaryScreenState extends State<DiaryScreen> {
  List<Widget> diaryList = <Widget>[];

  final ValueChanged<DateTime> goToGraph;
  final ValueChanged<List<dynamic>> update;
  _DiaryScreenState({this.goToGraph, this.update});

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
    Icons.fitness_center
  ];

//Deletes activity in diary from database. dismissKey is generated by firebase.
  void _removeActivity(ValueKey dismissKey) {
    setState(() {
      final user = Provider.of<UserClass>(context, listen: false);
      DatabaseService(uid: user.uid).removeDiaryItem(dismissKey.value);
    });
  }
//Deletes meal in diary from database. mealToRemove contains docId which is key generated by firebase.

  void _removeMeal(MealData mealToRemove) {
    final user = Provider.of<UserClass>(context, listen: false);
    DatabaseService(uid: user.uid).removeMeal(mealToRemove);

    setState(() {
      diaryList
          .removeWhere((item) => item.key.toString() == mealToRemove.docId);
    });
  }
//Pushes 'addmealscreen' and fills in screen with values of mealData.
//When user presses done button, database is updated with new values if changed
//mealData contains docId which is key generated by firebase.

  updateMeal(MealData mealData) {
    List<File> file = [];
    for (String path in mealData.localPath) {
      if (path != '') {
        try {
          file.add(File(path));
        } catch (e) {}
      }
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

//Updates database with new and edited data from activitydata
  Future updateActivity(context, activityData) async {
    final user = Provider.of<UserClass>(context, listen: false);
    await DatabaseService(uid: user.uid).updateTrainingDiaryData(
      activityData.trainingid, //ID
      activityData.name, //name
      activityData.description, //description
      activityData.date, //date
      activityData.duration, //duration
      activityData.intensity, //Intensity
      activityData.category, //category
    );
    //setState(() {});
  }

//Convert duration from milliseconds to readable string
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

/*  
Depending on if user pressed graph button on meal or training data, call 
goToGraph with a datetime which switches to graph view and pans the graph to 
the desired location by setting min and max x axis values. 

Also display information about either meal or activity with 'update' method under
graph.
*/
  void goToGraphPoint(DateTime date,
      {TrainingDiaryData trainingData, MealData mealData}) {
    goToGraph(date);

    if (trainingData != null) {
      //Future.delayed(Duration.zero, () {
      update([trainingData, false]);
      //   });
    } else if (mealData != null) {
      //Future.delayed(Duration.zero, () {
      update([mealData, false]);
      // });
    }
  }

/*
Display slidable list item with information about activity.
This includes: 
String name,
String _subtitle,
DateTime date,
Duration duration, 
int intensity, 
Icon category
 */
  activityItem(BuildContext context, String name, String _subtitle, int date,
      int duration, int intensity, ValueKey newKey, int category) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Slidable(
          key: newKey,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiaryDetailsScreen(
                        keyRef: newKey,
                        titlevalue: name,
                        subtitle: _subtitle,
                        dateTime: date,
                        duration: duration,
                        isIos: false,
                        localPath: ['activity'],
                        imgRef: ['activity'],
                        intensity: intensity,
                        category: category)),
              );
            },
            child: Container(
              color: Colors.grey[200],
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: AspectRatio(
                            aspectRatio: 1.4,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Row(
                                children: [
                                  Icon(iconList[category], size: 60),
                                  CircleAvatar(
                                      backgroundColor: Color(0xFF99163D),
                                      radius: 12,
                                      child: Text(intensity.toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'rubik',
                                          ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 5.0, 2.0, 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'rubik',
                                              ),
                                            ),
                                          ),
                                          AutoSizeText(
                                            _subtitle,
                                            minFontSize: 8,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              //fontSize: 12.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          Text(
                                            convertTime(duration),
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('EEE, M/d/y - HH:mm')
                                                .format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        date)),
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ))),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back_ios_outlined,
                                      color: Colors.grey[300]),
                                  Icon(Icons.arrow_forward_ios_outlined,
                                      color: Colors.grey[300])
                                ],
                              ),
                            ))
                      ])),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Graph',
              color: Colors.green,
              icon: Icons.stacked_line_chart,
              onTap: () =>
                  goToGraphPoint(DateTime.fromMillisecondsSinceEpoch(date),
                      trainingData: new TrainingDiaryData(
                        trainingid: newKey.value,
                        name: name,
                        description: _subtitle,
                        date: DateTime.fromMillisecondsSinceEpoch(date),
                        duration: Duration(milliseconds: duration),
                        intensity: intensity,
                      )),
            )
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => _removeActivity(newKey),
            ),
            IconSlideAction(
                caption: 'Edit',
                color: Colors.grey[600],
                icon: Icons.edit,
                onTap: () async {
                  TrainingData activityData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ActivityPopup(
                              keyRef: newKey.value.toString(),
                              isAdd: true,
                              titlevalue: name,
                              subtitle: _subtitle,
                              date: DateTime.fromMillisecondsSinceEpoch(date),
                              duration: duration,
                              intensity: intensity,
                              category: category)));
                  if (activityData != null) {
                    updateActivity(context, activityData);
                  }
                }),
          ],
        ));
  }

/*
Display slidable list item with information about meal.
This includes: 
String note,
DateTime date,
Image imageRef, 
 */
  mealItem(BuildContext context, int date, List<String> imageRef,
      List<String> localPath, String note, ValueKey newKey) {
    bool _isIos;

    try {
      _isIos = Platform.isIOS || Platform.isMacOS;
    } catch (e) {
      _isIos = false;
    }
    return Padding(
        key: newKey,
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Slidable(
          key: newKey,
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DiaryDetailsScreen(
                          keyRef: newKey,
                          titlevalue: 'meal',
                          subtitle: note,
                          dateTime: date,
                          duration: 0,
                          intensity: null,
                          isIos: _isIos,
                          localPath: localPath,
                          imgRef: imageRef,
                          category: null,
                        )),
              );
            },
            child: Container(
              color: Colors.grey[200],
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: AspectRatio(
                            aspectRatio: 1.4,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius: localPath[0] != null
                                          ? BorderRadius.circular(8.0)
                                          : BorderRadius.circular(0),
                                      child: Container(
                                          width: 52,
                                          child: FutureBuilder(
                                              future: displayImage(
                                                  context,
                                                  _isIos,
                                                  localPath[0],
                                                  imageRef[0]),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot snapshot) {
                                                if (!snapshot.hasData) {
                                                  Loading();
                                                } else {
                                                  return snapshot.data;
                                                }
                                                return Container();
                                              })),
                                    ),
                                  ),
                                  CircleAvatar(
                                      backgroundColor: Color(0xFF99163D),
                                      radius: 12,
                                      child: Text(78.toString(),
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'rubik',
                                          ))),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    20.0, 5.0, 2.0, 5.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              'Meal',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'rubik',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            note,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              DateFormat('HH:mm').format(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      date)),
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              DateFormat('EEE, M/d/y').format(
                                                  DateTime
                                                      .fromMillisecondsSinceEpoch(
                                                          date)),
                                              style: const TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ))),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_back_ios_outlined,
                                      color: Colors.grey[300]),
                                  Icon(Icons.arrow_forward_ios_outlined,
                                      color: Colors.grey[300])
                                ],
                              ),
                            ))
                      ])),
            ),
          ),
          actions: <Widget>[
            IconSlideAction(
              caption: 'Graph',
              color: Colors.green,
              icon: Icons.stacked_line_chart,
              onTap: () =>
                  goToGraphPoint(DateTime.fromMillisecondsSinceEpoch(date),
                      mealData: new MealData(
                        note,
                        DateTime.fromMillisecondsSinceEpoch(date),
                        imageRef,
                        newKey.value,
                        localPath,
                      )),
            )
          ],
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => _removeMeal(new MealData(
                  note,
                  DateTime.fromMillisecondsSinceEpoch(date),
                  imageRef,
                  newKey.value,
                  localPath)),
            ),
            IconSlideAction(
                caption: 'Edit',
                color: Colors.grey[600],
                icon: Icons.edit,
                onTap: () => updateMeal(new MealData(
                    note,
                    DateTime.fromMillisecondsSinceEpoch(date),
                    imageRef,
                    newKey.value,
                    localPath)))
          ],
        ));
  }

/*
  If image found locally, return image
  If image found on database, fetch image and return
  If image not found return 'No image' icon
  If image found but unable to fetch, return warning icon
*/
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
        print('displayImage1: $e');
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

/*
method called every build. Clears diary list and updates again with databasedata
sorted by date.
*/
  void structureData(context, databaseData) {
    diaryList.clear();

    databaseData
        .sort((b, a) => a['date'].toString().compareTo(b['date'].toString()));

    for (DocumentSnapshot entry in databaseData) {
      /* List<dynamic> combinedMeals =
          databaseData.where((value) => value['date'] != entry['date']);
      databaseData.removeWhere((value) => value['date'] != entry['date']);
      print('Pics for meal: $combinedMeals.length');
*/
//For every diary item in database, if item has an intensity field it is an activity
//otherwise it's a meal.
      try {
        entry.get('intensity');
        diaryList.add(
          activityItem(
              context,
              entry['name'],
              entry['description'],
              entry['date'],
              entry['duration'],
              entry['intensity'],
              ValueKey(entry.id),
              entry['category']),
        );
      } catch (e) {
        List<String> refList = entry['imageRef'].cast<String>();
        //List<String> refList = [];
        List<String> localList = entry['localPath'].cast<String>();

        diaryList.add(mealItem(context, entry['date'], refList, localList,
            entry['note'], ValueKey(entry.id)));
      }
    }
  }

  customScrollview(BuildContext context) {
    return Container(
      //decoration: BoxDecoration(image: Icon(Icons.add)),
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(children: diaryList),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context, listen: false);

    return StreamBuilder(
        stream: DatabaseService(uid: user.uid).userDiary,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            List documents = snapshot.data.toList();
            documents = documents.expand((i) => i).toList();

            structureData(context, documents);
          } else {
            Loading();
          }

          return Center(
              child: Column(
            children: [
              customScrollview(context),
            ],
          ));
        });
  }
}

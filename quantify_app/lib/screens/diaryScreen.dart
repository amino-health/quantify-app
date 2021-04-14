//import 'package:dio/dio.dart';

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/screens/diaryDetailsScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantify_app/services/database.dart';
import 'package:quantify_app/models/mealData.dart';

//import 'package:flutter_svg/flutter_svg.dart';

class DiaryScreen extends StatefulWidget {
  DiaryScreen({ValueKey key});

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

List weeklist = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
String weekday =
    weeklist[DateTime.parse('2021-04-06 10:02:14.453').weekday - 1];

List months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec'
];
String month = months[DateTime.parse('2021-04-06 10:02:14.453').month - 1];

class _DiaryScreenState extends State<DiaryScreen> {
  List<Widget> diaryList = <Widget>[];
  List<String> testList = [
    'Sample Diaryitem',
    'Description about exercise in simple text.',
    '10:02 \n $weekday 6 $month',
    'intensity'
  ];

  void _removeActivity(ValueKey dismissKey) {
    setState(() {
      final user = Provider.of<UserClass>(context, listen: false);
      DatabaseService(uid: user.uid).removeDiaryItem(dismissKey.value);
    });
  }

  void _removeMeal(MealData mealToRemove) {
    print(mealToRemove.localPath);
    print(mealToRemove.mealImageUrl);
    final user = Provider.of<UserClass>(context, listen: false);
    DatabaseService(uid: user.uid).removeMeal(mealToRemove);

    setState(() {
      diaryList
          .removeWhere((item) => item.key.toString() == mealToRemove.docId);
    });
  }

  activityItem(BuildContext context, String name, String _subtitle, int date,
      int duration, String intensity, ValueKey newKey) {
    return Padding(
      key: newKey,
      padding: const EdgeInsets.only(top: 8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
            color: Colors.white,
            child: ListTile(
                leading: Icon(Icons.directions_run,
                    size: MediaQuery.of(context).size.height * 0.075),
                title: Text(name),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, right: 10),
                        child: Text(
                          _subtitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(child: Icon(Icons.access_time_sharp)),
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                      DateFormat('EEE, M/d/y\nHH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              date)),
                                      textAlign: TextAlign.left)),
                            ],
                          ),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: TextButton(
                                  onPressed: () {}, child: Text('Show Graph')))
                        ],
                      ),
                      flex: 5,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiaryDetailsScreen(
                            titlevalue: name,
                            subtitle: _subtitle,
                            dateTime: date,
                            duration: duration,
                            isIos: false,
                            localPath: 'activity',
                            imgRef: 'activity',
                            intensity: intensity)),
                  );
                })),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _removeActivity(newKey),
          ),
        ],
      ),
    );
  }

  mealItem(BuildContext context, int date, String imageRef, String localPath,
      String note, ValueKey newKey) {
    bool _isIos;
    try {
      _isIos = Platform.isIOS || Platform.isMacOS;
    } catch (e) {
      _isIos = false;
    }
    return Padding(
      key: newKey,
      padding: const EdgeInsets.only(top: 8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
            color: Colors.white,
            child: ListTile(
                leading: Container(
                    child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child:
                            displayImage(context, _isIos, localPath, imageRef)),
                    height: MediaQuery.of(context).size.height * 0.125,
                    width: MediaQuery.of(context).size.width * 0.125),
                title: Text('Meal'),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, right: 10),
                        child: Text(
                          note,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(child: Icon(Icons.access_time_sharp)),
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                      DateFormat('EEE, M/d/y\nHH:mm').format(
                                          DateTime.fromMillisecondsSinceEpoch(
                                              date)),
                                      textAlign: TextAlign.left)),
                            ],
                          ),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: TextButton(
                                  onPressed: () {}, child: Text('Show Graph')))
                        ],
                      ),
                      flex: 5,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiaryDetailsScreen(
                              titlevalue: 'meal',
                              subtitle: note,
                              dateTime: date,
                              duration: 0,
                              intensity: '',
                              isIos: _isIos,
                              localPath: localPath,
                              imgRef: imageRef,
                            )),
                  );
                })),
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
        ],
      ),
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

  void structureData(context, databaseData) {
    diaryList.clear();

    databaseData
        .sort((b, a) => a['date'].toString().compareTo(b['date'].toString()));

    for (DocumentSnapshot entry in databaseData) {
      //ValueKey newkey = _generateKey();

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
              ValueKey(entry.id)),
        );
      } catch (e) {
        diaryList.add(mealItem(context, entry['date'], entry['imageRef'],
            entry['localPath'], entry['note'], ValueKey(entry.id)));
      }
    }
  }

  customScrollview(BuildContext context) {
    return Container(
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
            print('No training data found for user');
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

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/ActivityFormScreen.dart';
import 'package:quantify_app/screens/diaryScreen.dart';
//import 'package:quantify_app/screens/diaryScreen.dart';


import 'package:quantify_app/screens/addMealScreen.dart';

//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:quantify_app/screens/firstScanScreen.dart';

import 'package:quantify_app/models/activityDiary.dart';

import 'package:quantify_app/screens/graphs.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:intl/intl.dart';
import 'package:quantify_app/screens/profileScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:quantify_app/services/database.dart';

import 'package:quantify_app/models/mealData.dart';

import 'diaryScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

GlobalKey overviewKey = new GlobalKey();

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  MealData _mealData = new MealData("", DateTime.now(), null, null, null);
  TrainingDiaryData _trainingData = new TrainingDiaryData();
  bool showMeal = false;
  bool showActivity = false;
  setData(Object data) {
    List castedData = data as List;
    if (castedData.first.runtimeType == MealData) {
      overviewKey.currentState.setState(() {
        _mealData = castedData.first;
        showMeal = true;
        showActivity = false;
      });
    } else {
      overviewKey.currentState.setState(() {
        _trainingData = castedData.first;
        showActivity = true;
        showMeal = false;
      });
    }
    /**/
  }

  Future<void> delete({@required bool isMeal}) {
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
                    onPressed: () async {
                      final user =
                          Provider.of<UserClass>(context, listen: false);
                      if (isMeal) {
                        overviewKey.currentState.setState(() {
                          DatabaseService(uid: user.uid).removeMeal(_mealData);
                          showMeal = false;
                        });
                      } else {
                        overviewKey.currentState.setState(() {
                          DatabaseService(uid: user.uid)
                              .removeDiaryItem(_trainingData.trainingid);
                          showActivity = false;
                        });
                      }
                      Navigator.pop(context);
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
              "Are you sure that you want to remove this ${isMeal ? "meal" : "activity"}?",
              style: TextStyle(fontFamily: "roboto-medium"),
              textAlign: TextAlign.center,
            ),
          );
        });
  }

  Future<void> edit({@required bool isMeal}) async {
    if (isMeal) {
      File file;
      if (_mealData.localPath != null) {
        try {
          file = File(_mealData.localPath);
        } catch (e) {}
      }
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddMealScreen.edit(
                  file,
                  _mealData.mealDate,
                  TimeOfDay.fromDateTime(_mealData.mealDate),
                  _mealData.mealDescription,
                  _mealData.mealImageUrl,
                  true,
                  _mealData.docId)));
    } else {
      List activityData = await showDialog(
          context: context,
          builder: (_) => ActivityPopup(
              keyRef: _trainingData.trainingid,
              isAdd: true,
              titlevalue: _trainingData.name,
              subtitle: _trainingData.description,
              date: _trainingData.date,
              duration: _trainingData.duration.inMilliseconds,
              intensity: _trainingData.intensity));
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
  }

  Widget displayImage(bool _isIos) {
    if (_mealData.localPath != null) {
      try {
        return Image.file(File(_mealData.localPath));
      } catch (e) {}
    }
    return _mealData.mealImageUrl != null
        ? CachedNetworkImage(
            progressIndicatorBuilder: (context, url, downProg) =>
                CircularProgressIndicator(value: downProg.progress),
            imageUrl: _mealData.mealImageUrl,
            errorWidget: (context, url, error) => Icon(_isIos
                ? CupertinoIcons.exclamationmark_triangle_fill
                : Icons.error),
          )
        : Container(
            child: Icon(
              Icons.image_not_supported,
              size: MediaQuery.of(context).size.height * 0.1,
            ),
          );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return "${twoDigits(duration.inHours)}h:${twoDigitMinutes}m";
  }

  activityContent(context, _isIos) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
            color: Color(0xff99163d),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat("yyyy-MM-dd - kk:mm")
                          .format(_trainingData.date),
                      textScaleFactor: 1.5,
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          overviewKey.currentState.setState(() {
                            showActivity = false;
                          });
                        },
                        icon: Icon(Icons.close)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Icon(Icons.directions_run))),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          _trainingData.name,
                          textScaleFactor: 2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: TextStyle(color: Colors.white),
                        ),
                        AutoSizeText(
                          _trainingData.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1.5,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                        AutoSizeText(
                          "Intensity: " +
                              _trainingData.intensity.toString() +
                              "/10",
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                        AutoSizeText(
                          "Duration: " + _printDuration(_trainingData.duration),
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9333,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: IconButton(
                          color: Colors.white,
                          iconSize: MediaQuery.of(context).size.height * 0.04,
                          onPressed: () {
                            delete(isMeal: false);
                          },
                          icon: Icon(
                              _isIos ? CupertinoIcons.trash : Icons.delete)),
                    ),
                    IconButton(
                        color: Colors.white,
                        iconSize: MediaQuery.of(context).size.height * 0.04,
                        onPressed: () {
                          edit(isMeal: false);
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
              )
            ]),
      ),
    );
  }

  mealContent(context, _isIos) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
      child: Container(
        decoration: BoxDecoration(
            color: Color(0xff99163d),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      DateFormat("yyyy-MM-dd - kk:mm")
                          .format(_mealData.mealDate),
                      textScaleFactor: 1.5,
                      style: TextStyle(
                          color: Colors.white, fontStyle: FontStyle.italic),
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        color: Colors.white,
                        onPressed: () {
                          overviewKey.currentState.setState(() {
                            showMeal = false;
                          });
                        },
                        icon: Icon(Icons.close)),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: displayImage(_isIos)),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AutoSizeText(
                          _mealData.mealDescription,
                          maxLines: 4,
                          textScaleFactor: 1.5,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white, fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9333,
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 32),
                      child: IconButton(
                          color: Colors.white,
                          iconSize: MediaQuery.of(context).size.height * 0.04,
                          onPressed: () {
                            delete(isMeal: true);
                          },
                          icon: Icon(
                              _isIos ? CupertinoIcons.trash : Icons.delete)),
                    ),
                    IconButton(
                        color: Colors.white,
                        iconSize: MediaQuery.of(context).size.height * 0.04,
                        onPressed: () {
                          edit(isMeal: true);
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
              )
            ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool _isIos;
    try {
      _isIos = Platform.isIOS || Platform.isMacOS;
    } catch (e) {
      _isIos = false;
    }
    final List<Widget> _children = [
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                child: GraphicalInterface(
                  update: setData,
                ),
              ),
            ),
            Expanded(
              child: StatefulBuilder(
                  key: overviewKey,
                  builder: (BuildContext context, setStateMeal) {
                    if (showMeal) {
                      return mealContent(context, _isIos);
                    } else if (showActivity) {
                      return activityContent(context, _isIos);
                    } else {
                      return Container();
                    }
                  }),
            ),
          ],
        ),
      ),
      DiaryScreen(),
      Profile(),
      Text('Settingspage'),
    ];

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    var scaffold = Scaffold(
        appBar: CustomAppBar(),
        body: _children[_selectedIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SmartButton(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color(0xFF99163D),
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[400],
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                backgroundColor: Color(0xFF99163D),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.book),
                backgroundColor: Color(0xFF99163D),
                label: 'Diary'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people),
                backgroundColor: Color(0xFF99163D),
                label: 'Profile'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                backgroundColor: Color(0xFF99163D),
                label: 'Settings'),
          ],
        ));

    return scaffold;
  }
}

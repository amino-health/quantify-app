import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:quantify_app/screens/firstScanScreen.dart';
import 'package:quantify_app/screens/graphs.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class MealData {
  MealData(
      this.mealHeader, this.mealDescription, this.mealDate, this.mealImage);
  String mealHeader = "";
  String mealDescription = "";
  DateTime mealDate;
  Image mealImage;
}

GlobalKey mealKey = new GlobalKey();

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  MealData _mealData = new MealData("", "", DateTime.now(), null);
  bool showPic = false;
  setMealData(MealData mealData) {
    mealKey.currentState.setState(() {
      _mealData = mealData;
      showPic = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 50,
              child: Container(
                child: GraphicalInterface(
                  update: setMealData,
                ),
              ),
            ),
            StatefulBuilder(
                key: mealKey,
                builder: (BuildContext context, setStateMeal) {
                  var content = Expanded(
                      flex: 50,
                      child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.45,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0, right: 0),
                                      child: Container(
                                        //height: MediaQuery.of(context).size.height * 0.2,
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          image: (_mealData.mealImage != null
                                              ? DecorationImage(
                                                  image:
                                                      _mealData.mealImage.image,
                                                  fit: BoxFit.fitHeight)
                                              : null),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.width *
                                        0.45,
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0, right: 00),
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              "\"" +
                                                  _mealData.mealDescription +
                                                  "\"",
                                              textScaleFactor: 1.5,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0, right: 0),
                                          child: Text(
                                            DateFormat("yyyy-MM-dd - kk:mm")
                                                .format(_mealData.mealDate),
                                            textScaleFactor: 1,
                                            style: TextStyle(
                                                fontStyle: FontStyle.italic),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.9333,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                color: Colors.grey,
                              )
                            ]),
                      ));
                  return showPic
                      ? content
                      : Expanded(
                          flex: 50,
                          child: Container(),
                        );
                }),
          ],
        ),
      ),
      Text('Diarypage'),
      Text('Profilepage'),
      Text('Settingspage'),
    ];

    var scaffold = Scaffold(
      appBar: CustomAppBar(),
      body: _children[_selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SmartButton(),
      bottomNavigationBar: CustomNavBar(),
    );

    return scaffold;
  }
}

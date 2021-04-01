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
  DateTime mealDate = DateTime.now();
  Image mealImage;
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  MealData _mealData = new MealData("", "", DateTime.now(), null);
  void _setMealData(MealData mealData) {
    setState(() {
      _mealData = mealData;
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
              child: GraphicalInterface(update: _setMealData),
            ),
          ),
          Expanded(
              flex: 50,
              child: Container(
                child: Column(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      _mealData.mealHeader +
                          " at " +
                          DateFormat("yyyy-MM-dd - kk:mm")
                              .format(_mealData.mealDate),
                      textScaleFactor: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Text(
                      _mealData.mealDescription,
                      textScaleFactor: 1,
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                        image: (_mealData.mealImage != null
                            ? DecorationImage(image: _mealData.mealImage.image)
                            : null),
                      ),
                    ),
                  )
                ]),
              ))
        ],
      )),
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

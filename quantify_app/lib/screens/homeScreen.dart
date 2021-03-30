import 'package:flutter/material.dart';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:quantify_app/screens/firstScanScreen.dart';
import 'package:quantify_app/screens/graphs.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/screens/profileScreen.dart';



class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 50,
          child: Container(
            child: GraphicalInterface(),
          ),
        ),
        Expanded(
            flex: 50,
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  'Lorem Ipsum',
                  textScaleFactor: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Text(
                  '"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ',
                  textScaleFactor: 1,
                ),
              ),
            ]))
      ],
    )),
    Text('Diarypage'),
    Profile(),
    Text('Settings'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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

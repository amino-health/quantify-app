import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quantify_app/screens/addActivityScreen.dart';
import 'package:quantify_app/screens/firstScanScreen.dart';
import 'package:quantify_app/screens/addMealScreen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        alignment: Alignment.centerLeft,
        child: SvgPicture.asset("lib/assets/quantify.svg",
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.04),
      ),
      backgroundColor: Color(0xFF99163D),
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
    );
  }
}

class SmartButton extends StatefulWidget {
  SmartButton({Key key});

  @override
  _SmartButtonState createState() => _SmartButtonState();
}

class _SmartButtonState extends State<SmartButton> {
  Widget build(BuildContext context) {
    return FloatingActionButton(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        heroTag: 'btn0',
        child: Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 4),
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: const Alignment(0.7, -0.5),
                end: const Alignment(0.6, 0.5),
                colors: [
                  Color(0xFF53a78c),
                  Color(0xFF70d88b),
                ],
              ),
            ),
            child: Icon(Icons.add, color: Color(0xFF99163D))),
        onPressed: () => showModalBottomSheet<void>(
              backgroundColor: Colors.transparent,
              context: context,
              isDismissible: true,
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Wrap(
                  children: <Widget>[
                    Container(
                      child: Container(
                        decoration: new BoxDecoration(
                          color: Color(0xFF99163D).withOpacity(0.0),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Column(
                                children: [
                                  //Row with NFC scan button
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20),
                                          child: FloatingActionButton(
                                            child: Icon(Icons.nfc,
                                                color: Color(0xFF99163D)),
                                            backgroundColor: Colors.white,
                                            heroTag: 'btn3',
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FirstScanScreen()),
                                              );
                                            },
                                          ),
                                        ),
                                      ]),
                                  //Row with food and activity add buttons
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20.0, top: 20),
                                        child: FloatingActionButton(
                                          child: Icon(Icons.directions_run,
                                              color: Color(0xFF99163D)),
                                          backgroundColor: Colors.white,
                                          heroTag: 'btn1',
                                          onPressed: () {
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AddActivityScreen()),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 20),
                                        child: FloatingActionButton(
                                          child: Icon(Icons.fastfood,
                                              color: Color(0xFF99163D)),
                                          heroTag: 'btn2',
                                          backgroundColor: Colors.white,
                                          onPressed: () =>
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddMealScreen())),
                                        ),
                                      ),
                                    ],
                                  ),
                                  //Row with cancelbutton
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20, bottom: 30),
                                          child: FloatingActionButton(
                                            child: Icon(Icons.cancel,
                                                color: Color(0xFF99163D)),
                                            heroTag: 'btn4',
                                            backgroundColor: Colors.white,
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                        ),
                                      ]),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ));
  }
}

class CustomNavBar extends StatefulWidget {
  CustomNavBar({Key key});

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
    );
  }
}

//import 'package:dio/dio.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/training.dart';
//import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
//import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/screens/ActivityFormScreen.dart';
import 'package:quantify_app/services/database.dart';

//import 'package:flutter_svg/flutter_svg.dart';

class AddActivityScreen extends StatefulWidget {
  AddActivityScreen({Key key});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  TabController _tabController;

  final List<Tab> _activityTabs = <Tab>[
    new Tab(
      child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('History', style: TextStyle(color: Colors.black))),
    ),
    new Tab(
      child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('My Activities', style: TextStyle(color: Colors.black))),
    ),
    new Tab(
      child: FittedBox(
          fit: BoxFit.fitWidth,
          child:
              Text('Basic Activities', style: TextStyle(color: Colors.black))),
    ),
  ];

  //Temporary lists for activity cards
  List<dynamic> myActivityList = <dynamic>[];
  List<dynamic> allActivityList = <dynamic>[];
  List<dynamic> historyActivityList = <dynamic>[];
  List<dynamic> recentActivityList = <dynamic>[];

  //
  //Variables for search bar with Dio
  //
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Icon _searchIcon = new Icon(Icons.search, size: 30);
  Widget _appBarTitle = new Text('Add Activity');
  //
  //END
  //

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              labelStyle: (TextStyle(color: Colors.white)),
              prefixIcon: new Icon(Icons.search),
              hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Add Activity');

        _filter.clear();
      }
    });
  }

  _AddActivityScreenState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        new TabController(vsync: this, length: _activityTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _filter.dispose();
    super.dispose();
  }

  bottomButton(BuildContext context, String _title) {
    return Container(
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 6.0),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ))),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 8, bottom: 8),
                      child: Text(
                        _title,
                        style: TextStyle(fontFamily: 'roboto-bold'),
                      ),
                    ),
                    onPressed: () async {
                      TrainingData activityData = await showDialog(
                          context: context,
                          builder: (_) => ActivityPopup(
                                keyRef: '',
                                isAdd: false,
                                titlevalue: '',
                                subtitle: '',
                                date: DateTime.now(),
                                duration: 0,
                                intensity: 5,
                              ));
                      addItem(context, activityData);
                    }))));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _removeItem(ValueKey dismissKey) {
    setState(() {});

    List<dynamic> activityList = [
      historyActivityList,
      myActivityList,
      allActivityList
    ];

    final user = Provider.of<UserClass>(context, listen: false);
    for (int j = 0; j < activityList.length; j++) {
      for (int i = 0; i < activityList[j].length; i++) {
        print(activityList[j][i][0].key.value);
        print(dismissKey.value);
        print(j);
        if (activityList[j][i][0].key.value == (dismissKey.value)) {
          if (j == 0) {
            print('list item is');
            print(historyActivityList[i][1]);
            DatabaseService(uid: user.uid).updateTrainingData(
                (dismissKey.value.toString()),
                '',
                '',
                DateTime.fromMicrosecondsSinceEpoch(historyActivityList[i][2]),
                0,
                0,
                false);
            historyActivityList.remove(historyActivityList[i]);
            j += 1;
          }
          if (j == 1 && j == _selectedIndex) {
            print(' J == 1');
            myActivityList.remove(myActivityList[i][1]);
            DatabaseService(uid: user.uid).removeActivity(dismissKey.value);
          } else if (j == 2 && j == _selectedIndex) {
            print(' J == 2');
            allActivityList.remove(allActivityList[i]);
            DatabaseService(uid: user.uid).removeActivity(dismissKey.value);
          }
        }
      }
    }

    //DatabaseService(uid: user.uid).removeActivity(dismissKey.value);
    print('value for key is');
    print(dismissKey.value);
  }

  //This method returns a string converted integer higher than the highest
  //existing key integer.

  //Returns a container item with key _name and a child slider with a numbered key
  activityItem(BuildContext context, String name, String _subtitle, int date,
      int intensity, String keyRef) {
    return Container(
        key: ValueKey(keyRef),
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          //_removeItem(newKey);

          child: Card(
            child: ListTile(
                title: Text(name),
                subtitle: Text(_subtitle),
                isThreeLine: false,
                onTap: () async {
                  TrainingData activityData = await showDialog(
                      context: context,
                      builder: (_) => ActivityPopup(
                            keyRef: keyRef,
                            isAdd: true,
                            titlevalue: name,
                            subtitle: _subtitle,
                            date: DateTime.now(),
                            duration: 0,
                            intensity: intensity,
                          ));
                  addActivity(context, activityData);
                }),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => _removeItem(ValueKey(keyRef)),
            ),
          ],
        ));
  }

  //This function controls which content list is displayed
  customScrollview(BuildContext context) {
    List<dynamic> activityList = <dynamic>[];
    List<Widget> filteredActivityList = <Widget>[];
    if (_selectedIndex == 0) {
      historyActivityList
          .sort((b, a) => a[2].toString().compareTo(b[2].toString()));
      activityList = historyActivityList;
    }
    if (_selectedIndex == 1) {
      activityList = myActivityList;
    }
    if (_selectedIndex == 2) {
      activityList = allActivityList;
    }

    for (int i = 0; i < activityList.length; i++) {
      if (activityList[i][1]
          .toString()
          .toLowerCase()
          .contains(_searchText.toLowerCase())) {
        filteredActivityList.add(activityList[i][0]);
      }
    }

    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: filteredActivityList),
        ),
      ),
    );
  }

  //Is called whenever a user presses Done in add activity view
  Future addActivity(context, activityData) async {
    print('in add activity');
    final user = Provider.of<UserClass>(context, listen: false);
    print(activityData);
    await DatabaseService(uid: user.uid).updateTrainingData(
        activityData.trainingid,
        activityData.name, //name
        activityData.description, //description
        activityData.date, //date
        activityData.intensity, //Intensity
        _selectedIndex + 1,
        true);
    await DatabaseService(uid: user.uid).createTrainingDiaryData(
      activityData.name, //name
      activityData.description, //description
      activityData.date, //date
      activityData.duration, //duration
      activityData.intensity, //Intensity
    );
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  /*
  The database returns a list of each user activity no matter what 
  menu header its supposed to show up in (historyact, myact, allact). 
  This part looks at the 'listtype' attribute and splits the database
  return data into 3 separate lists for the 3 different menus.
  */
  void structureData(context, databaseData) {
    historyActivityList.clear();
    myActivityList.clear();
    allActivityList.clear();
    for (DocumentSnapshot entry in databaseData) {
      if (entry['inHistory']) {
        historyActivityList.insert(0, [
          activityItem(context, entry['name'], entry['description'],
              entry['date'], entry['intensity'], entry.id),
          entry['name'] + entry['description'],
          entry['date']
        ]);
      }
      if (entry['listtype'] == 2) {
        //2 = MyactivityData

        myActivityList.insert(0, [
          activityItem(context, entry['name'], entry['description'],
              entry['date'], entry['intensity'], entry.id),
          entry['name'] + entry['description']
        ]);
      } else if (entry['listtype'] == 3) {
        //1 = basicActivitiesData

        allActivityList.insert(0, [
          activityItem(context, entry['name'], entry['description'],
              entry['date'], entry['intensity'], entry.id),
          entry['name'] + entry['description']
        ]);
      }
    }
  }

  void addItem(context, activityData) async {
    print('In add item');
    final user = Provider.of<UserClass>(context, listen: false);
    await DatabaseService(uid: user.uid).createTrainingData(
        activityData.name, //name
        activityData.description, //desc
        activityData.date, //date
        activityData.intensity, //intensity
        2,
        true);
    await DatabaseService(uid: user.uid).createTrainingDiaryData(
      activityData.name, //name
      activityData.description, //description
      activityData.date, //date
      activityData.duration, //duration
      activityData.intensity, //Intensity
    );
    while (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  tabBar(BuildContext context) {
    return TabBar(
      controller: _tabController,
      tabs: _activityTabs,
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context, listen: false);

    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('userData')
            .doc(user.uid)
            .collection('training')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            //print('documents is ${documents}');
            structureData(context, documents);
          } else {
            print('No training data found for user');
          }
          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              //elevation: 0.0,
              leading: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.09,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: BackButton(),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.06,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: IconButton(
                          icon: _searchIcon, onPressed: _searchPressed),
                    ),
                  ),
                ],
              ),
              leadingWidth: MediaQuery.of(context).size.width * 0.15,
              title: _appBarTitle,
              backgroundColor: Color(0xFF99163D),
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
            ),
            body: Center(
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.075,
                  width: MediaQuery.of(context).size.width * 1,
                  child: new Card(
                    elevation: 26.0,
                    color: Color(0xFFF0F0F0),
                    child: tabBar(context),
                  ),
                ),
                customScrollview(context),
              ],
            )),
            bottomNavigationBar: bottomButton(context, 'Create New Activity'),
          );
        });
  }
}

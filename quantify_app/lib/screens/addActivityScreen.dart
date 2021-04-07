//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/screens/ActivityFormScreen.dart';

//import 'package:flutter_svg/flutter_svg.dart';

class AddActivityScreen extends StatefulWidget {
  AddActivityScreen({Key key});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen>
    with TickerProviderStateMixin {
  //final _activitySearch = TextEditingController();
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
                      List<String> activityData = await showDialog(
                          context: context,
                          builder: (_) => ActivityPopup(
                              isAdd: false, titlevalue: '', subtitle: ''));
                      addItem(context, activityData);
                    }))));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _removeItem(Key dismissKey) {
    setState(() {});
    List<dynamic> activityList = [
      historyActivityList,
      myActivityList,
      allActivityList
    ];
    for (int j = 0; j < activityList.length; j++) {
      for (int i = 0; i < activityList[j].length; i++) {
        print(activityList[j][i][0].key.hashCode.toString().toLowerCase());
        print(dismissKey.hashCode.toString().toLowerCase());
        if (activityList[j][i][0].key.hashCode == (dismissKey.hashCode)) {
          //activityList[j].remove(activityList[j][i]);

          if (j == 0) {
            historyActivityList.remove(historyActivityList[i]);
          }
          if (j == 1) {
            myActivityList.remove(myActivityList[i]);
          }
          if (j == 2 && j == _selectedIndex) {
            allActivityList.remove(allActivityList[i]);
          }
        }
      }
    } //Todo remove Activityitem from database
  }

  //This method checks if the new activity item already exists in any of
  //the lists historyActivityList, myActivityList, allActivityList.

  Key _generateKey() {
    List<dynamic> activityList =
        historyActivityList + myActivityList + allActivityList;
    int topKeyIndex = 0;
    for (int j = 0; j < activityList.length; j++) {
      int compareVal = int.parse(activityList[j][0].key.value);
      if (topKeyIndex <= compareVal) {
        topKeyIndex = compareVal + 1;
      }
    }
    print('generated key is $topKeyIndex');
    return Key(topKeyIndex.toString());
  }

  //Returns a container item with key _name and a child dismissable with key _name_subtitle
  activityItem(
      BuildContext context, String name, String _subtitle, Key newKey) {
    return Container(
        key: newKey,
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Dismissible(
            key: newKey,
            onDismissed: (direction) {
              // Remove the item from the data source.
              _removeItem(newKey);

              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("$name was removed!")));
            },
            // Show a red background as the item is swiped away.
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color(0xFF99163D),
                    Color(0xFFF0F0F0),
                  ],
                ),
              ),
            ),
            child: Card(
                child: ListTile(
                    title: Text(name),
                    subtitle: Text(_subtitle),
                    isThreeLine: false,
                    onTap: () async {
                      List<String> activityData = await showDialog(
                          context: context,
                          builder: (_) => ActivityPopup(
                              isAdd: true,
                              titlevalue: name,
                              subtitle: _subtitle));
                      addActivity(context, activityData);
                    }))));
  }

  customScrollview(BuildContext context) {
    List<dynamic> activityList = <dynamic>[];
    List<Widget> filteredActivityList = <Widget>[];
    if (_selectedIndex == 0) {
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

    // if (activityList[i].toLowerCase().contains(_searchText.toLowerCase()))

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

  //Placeholdermethod Is called whenever a user presses Done in add activity view
  void addActivity(context, activityData) {
    setState(() {
      //print(DateTime.parse(activityData[2]).weekday);
      print(activityData[2]);
    });
  }

  void addItem(context, activityData) {
    setState(() {
      Key newkey = _generateKey();
      myActivityList.add([
        activityItem(context, activityData[0], activityData[1], newkey),
        activityData[0] + activityData[1]
      ]);
      historyActivityList.add([
        activityItem(context, activityData[0], activityData[1], newkey),
        activityData[0] + activityData[1]
      ]);
      // }
    });
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
                child: IconButton(icon: _searchIcon, onPressed: _searchPressed),
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
  }
}

import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/screens/ActivityFormScreen.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class AddActivityScreen extends StatefulWidget {
  AddActivityScreen({Key key});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen>
    with TickerProviderStateMixin {
  final _activitySearch = TextEditingController();
  int _selectedIndex = 0;

  TabController _tabController;

  List<Widget> myActivityList = <Widget>[];
  List<Widget> allActivityList = <Widget>[];
  List<Widget> historyActivityList = <Widget>[];
  List<Widget> recentActivityList = <Widget>[];

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
          child: Text('All Activities', style: TextStyle(color: Colors.black))),
    ),
  ];

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

  activityItem(BuildContext context, String _name, String _subtitle) {
    return Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Card(
            child: ListTile(
                title: Text(_name),
                subtitle: Text(_subtitle),
                isThreeLine: false,
                onTap: () async {
                  List<String> activityData = await showDialog(
                      context: context,
                      builder: (_) => ActivityPopup(
                          isAdd: true, titlevalue: _name, subtitle: _subtitle));
                  addActivity(context, activityData);
                })));
  }

  customScrollview(BuildContext context) {
    List<Widget> activityList = <Widget>[];
    if (_selectedIndex == 0) {
      activityList = historyActivityList;
    }
    if (_selectedIndex == 1) {
      activityList = myActivityList;
    }
    if (_selectedIndex == 2) {
      activityList = allActivityList;
    }
    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.end,
              children: activityList),
        ),
      ),
    );
  }

  //Placeholdermethod Is called whenever a user presses Done in add activity view
  void addActivity(context, activityData) {
    setState(() {});
  }

  void addItem(context, activityData) {
    setState(() {
      myActivityList
          .add(activityItem(context, activityData[0], activityData[1]));
      historyActivityList
          .add(activityItem(context, activityData[0], activityData[1]));
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
      appBar: CustomAppBar(),
      body: Center(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: TextField(
              controller: _activitySearch,
              decoration: InputDecoration(
                suffixText: 'Kg',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0)),
                ),
                labelText: 'Search for an activity',
              ),
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.95,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
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

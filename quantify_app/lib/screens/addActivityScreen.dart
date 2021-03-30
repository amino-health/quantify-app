import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class AddActivityScreen extends StatefulWidget {
  AddActivityScreen({Key key});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen>
    with TickerProviderStateMixin {
  TabController _tabController;

  final _activitySearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 3);
  }

  bottomButton(BuildContext context, String _title) {
    return Container(
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed))
                      return Color(0xDD99163D);
                    else
                      return Color(0xFF99163D);
                  },
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(color: Color(0xFFF0F0F0), width: 3)),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 8, bottom: 8),
                child: Text(
                  _title,
                  style: TextStyle(fontFamily: 'roboto-bold'),
                ),
              ),
              onPressed: () {},
            )));
  }

  customScrollview(BuildContext context) {
    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
              activityItem(context, 'test1'),
            ],
          ),
        ),
      ),
    );
  }

  activityItem(BuildContext context, String _name) {
    return Container(
        child: TextButton(
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Text(
          _name,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {},
    ));
  }

  tabBar(BuildContext context) {
    return TabBar(tabs: <Tab>[
      new Tab(
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('History', style: TextStyle(color: Colors.black))),
      ),
      new Tab(
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child:
                Text('My Activities', style: TextStyle(color: Colors.black))),
      ),
      new Tab(
        child: FittedBox(
            fit: BoxFit.fitWidth,
            child:
                Text('All Activities', style: TextStyle(color: Colors.black))),
      ),
    ], controller: _tabController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: TextField(
              controller: _activitySearch,
              decoration: InputDecoration(
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
          customScrollview(context)
        ],
      )),
      bottomNavigationBar: bottomButton(context, 'Create New Activity'),
    );
  }
}

import 'package:flutter/material.dart';

//import 'package:bezier_chart/bezier_chart.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

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
        child: SvgPicture.asset("lib/assets/text.svg",
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
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(25.0),
                                topRight: const Radius.circular(25.0))),
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
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        FirstScanPage()),
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
                                          onPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 20),
                                        child: FloatingActionButton(
                                          child: Icon(Icons.fastfood,
                                              color: Color(0xFF99163D)),
                                          backgroundColor: Colors.white,
                                          onPressed: () =>
                                              Navigator.pop(context),
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

class GraphicalInterface extends StatefulWidget {
  GraphicalInterface({Key key});

  @override
  _GraphicalInterfaceState createState() => _GraphicalInterfaceState();
}

class _GraphicalInterfaceState extends State<GraphicalInterface> {
  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                child: SfCartesianChart(
      zoomPanBehavior: _zoomPanBehavior,
      onPointTapped: (PointTapArgs args) {
        print(args.pointIndex);
      },
      onMarkerRender: (MarkerRenderArgs args) {
        if (args.pointIndex == 1) {
          args.color = Colors.red;
          args.markerHeight = 20;
          args.markerWidth = 20;
          args.shape = DataMarkerType.diamond;
          args.borderColor = Colors.green;
          args.borderWidth = 2;
        }
        if (args.pointIndex == 11) {
          args.color = Colors.blue;
          args.markerHeight = 20;
          args.markerWidth = 20;
          args.shape = DataMarkerType.diamond;
          args.borderColor = Colors.red;
          args.borderWidth = 2;
        }
      },

      // Initialize category axis
      primaryXAxis: CategoryAxis(
        isInversed: true,
        visibleMaximum: 8,
      ),
      title: ChartTitle(text: 'Monday Dec 12'),

      series: <LineSeries<GlucoseData, String>>[
        LineSeries<GlucoseData, String>(
            // Bind data source
            dataSource: <GlucoseData>[
              GlucoseData('2300', 23),
              GlucoseData('2200', 22),
              GlucoseData('2100', 18),
              GlucoseData('2000', 19),
              GlucoseData('1900', 24),
              GlucoseData('1800', 29),
              GlucoseData('1700', 35),
              GlucoseData('1600', 40),
              GlucoseData('1500', 45),
              GlucoseData('1400', 39),
              GlucoseData('1300', 26),
              GlucoseData('1200', 18),
              GlucoseData('1100', 11),
            ],
            xValueMapper: (GlucoseData glucose, _) => glucose.time,
            yValueMapper: (GlucoseData glucose, _) => glucose.glucoseVal,
            markerSettings:
                MarkerSettings(isVisible: true, shape: DataMarkerType.diamond))
      ],
    ))));
  }
  /*
   Widget build(BuildContext context) {
     
      final fromDate = DateTime(2021, 03, 21);
      final toDate = DateTime.now();

      final date1 = DateTime.now().subtract(Duration(days: 2, hours: 14));
      final date2 = DateTime.now().subtract(Duration(days: 0, hours: 2 ));

      return Center(
        child: Container(
          
          
          child: BezierChart(
            
            fromDate: fromDate,
            bezierChartScale: BezierChartScale.HOURLY,
            toDate: toDate,
            selectedDate: toDate,
            
            series: [
              BezierLine(
                label: "Glucose",
                dataPointFillColor: Colors.red ,
                
                lineColor: Colors.grey[900],
                onMissingValue: (dateTime) {
                  if (dateTime.day.isEven) {
                    return 10.0;
                  }
                  return 5.0;
                },
                data: [
                  DataPoint<DateTime>(value: 10, xAxis: date1),
                  DataPoint<DateTime>(value: 50, xAxis: date2),
                ],
              ),
            ],
            config: BezierChartConfig(
              displayYAxis: true,
              
              
              xAxisTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 10),
              yAxisTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 10),
              showDataPoints: true,
              verticalIndicatorStrokeWidth: 3.0,
              verticalIndicatorColor: Colors.black26,
              showVerticalIndicator: true,
              verticalIndicatorFixedPosition: false,
              backgroundColor: Color(0xFFE0E0E0),           
              footerHeight: 30.0,
              snap: false
            ),
          ),
        ),
      );
    }
    */

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

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class FirstScanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No sensor paired',
            textScaleFactor: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Text(
                'To start tracking use your device to scan the glucose sensor',
                textScaleFactor: 1.5,
                textAlign: TextAlign.center),
          ),
          Icon(Icons.nfc,
              size: MediaQuery.of(context).size.height * 0.3,
              color: Color(0xFF99163D)),
          Text(
            'Waiting for sensor...',
            textScaleFactor: 2,
          )
        ],
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SmartButton(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
    Text('Profilepage'),
    Text('Settingspage'),
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

class GlucoseData {
  GlucoseData(this.time, this.glucoseVal);
  final String time;
  final double glucoseVal;
}

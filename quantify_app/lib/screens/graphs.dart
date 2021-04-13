import 'dart:math';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/homeScreen.dart';
import 'package:quantify_app/services/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:flutter/services.dart' show rootBundle;

//import 'package:bezier_chart/bezier_chart.dart';

class GraphicalInterface extends StatefulWidget {
  final ValueChanged<MealData> update;
  GraphicalInterface({this.update});
  //GraphicalInterface({Key key});

  @override
  _GraphicalInterfaceState createState() =>
      _GraphicalInterfaceState(update: update);
}

class _GraphicalInterfaceState extends State<GraphicalInterface> {
  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
  DateTime today = DateTime.now();
  TooltipBehavior _tooltipBehavior;
  bool alreadyRandom = false;
  final ValueChanged<MealData> update;
  _GraphicalInterfaceState({this.update});
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        header: "Glucose level",
        format: 'point.y mmol/L',
        canShowMarker: false);
  }

  var list = <GlucoseData>[];

  _createRandomData(int n) {
    if (!alreadyRandom) {
      final random = new Random();
      DateTime now = DateTime.now();
      double rand = (10 + random.nextInt(15)).toDouble();
      for (int i = 0; i < n; i++) {
        list.add(GlucoseData(now.subtract(Duration(minutes: 5 * i)), rand));
        rand = ((rand - 2) + random.nextInt(5)).toDouble();
      }
      alreadyRandom = true;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);
    return StreamBuilder(
        stream: DatabaseService(uid: user.uid).userMeals,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          list = _createRandomData(1000);

          List imageData = snapshot.data;
          List idList = imageData.map((e) => e.id).toList();
          imageData = imageData.map((e) => e.data()).toList();
          int i = 0;
          for (var item in imageData) {
            item['docId'] = idList[i];
            i++;

            item['gluc'] = list.firstWhere((element) {
              if (element.time != null &&
                  element.time.millisecondsSinceEpoch < item['date']) {
                item['date'] = element.time.millisecondsSinceEpoch;
                return element.time.millisecondsSinceEpoch == item['date'];
              }
              return false;
            }, orElse: () {
              return GlucoseData(
                  DateTime.fromMillisecondsSinceEpoch(item['date']), 10.0);
            });
          }

          return Scaffold(
            body: Center(
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: SfCartesianChart(
                      tooltipBehavior: _tooltipBehavior,
                      onActualRangeChanged: (ActualRangeChangedArgs args) {
                        if (args.orientation == AxisOrientation.horizontal) {}
                      },
                      zoomPanBehavior: _zoomPanBehavior,
                      onPointTapped: (PointTapArgs args) {
                        //print(args.dataPoints.first.y);
                        if (args.dataPoints.length == imageData.length) {
                          var meal = imageData[args.pointIndex];
                          update(new MealData(
                              meal['note'],
                              DateTime.fromMillisecondsSinceEpoch(meal['date']),
                              meal['imageRef'],
                              meal['docId'],
                              meal['localPath']));
                        }
                      },
                      onMarkerRender: (markerArgs) {
                        markerArgs.color = Colors.red;
                      },
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(
                              text: "mmol/L",
                              alignment: ChartAlignment.center,
                              textStyle: TextStyle(fontSize: 12))),
                      // Initialize category axis
                      primaryXAxis: DateTimeAxis(
                          autoScrollingDelta: 8,
                          autoScrollingDeltaType: DateTimeIntervalType.hours
                          //isInversed: true,
                          //maximumLabels: 8,
                          ),
                      title: ChartTitle(
                          text: DateFormat('EEEE, d MMM').format(today)),

                      series: <ChartSeries>[
                        LineSeries<GlucoseData, DateTime>(
                            enableTooltip: true,
                            // Bind data source
                            dataSource: list,
                            xValueMapper: (GlucoseData glucose, _) =>
                                glucose.time,
                            yValueMapper: (GlucoseData glucose, _) =>
                                glucose.glucoseVal,
                            markerSettings: MarkerSettings(
                                isVisible: false,
                                shape: DataMarkerType.diamond)),
                        ScatterSeries(
                            enableTooltip: true,
                            dataSource: imageData,
                            xValueMapper: (x, _) =>
                                DateTime.fromMillisecondsSinceEpoch(x['date']),
                            yValueMapper: (x, _) => x['gluc'].glucoseVal,
                            markerSettings: MarkerSettings(
                                color: Colors.red,
                                borderColor: Colors.red,
                                height: 20.0,
                                width: 20.0,
                                isVisible: false,
                                shape: DataMarkerType.diamond)),
                      ],
                    ))),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: Align(
              alignment: Alignment(1, 0.7),
              child: FloatingActionButton(
                heroTag: "toStartButton",
                backgroundColor: Color(0xff99163d),
                onPressed: () {
                  setState(() {});
                },
                child: Icon(Icons.arrow_forward),
              ),
            ),
          );
        });
  }
}

class GlucoseData {
  GlucoseData(this.time, this.glucoseVal);
  final DateTime time;
  final double glucoseVal;
}

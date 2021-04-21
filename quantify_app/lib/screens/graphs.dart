import 'dart:math';
//import 'dart:io';
//import 'package:cached_network_image/cached_network_image.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/activityDiary.dart';
import 'package:quantify_app/models/userClass.dart';
//import 'package:quantify_app/screens/homeScreen.dart';
import 'package:quantify_app/services/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:quantify_app/models/mealData.dart';

//import 'package:bezier_chart/bezier_chart.dart';

class GraphicalInterface extends StatefulWidget {
  final ValueChanged update;
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
  final ValueChanged<List<dynamic>> update;
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

  var tempGluclist = <GlucoseData>[];

  _createRandomData(int n) {
    if (!alreadyRandom) {
      final random = new Random();
      DateTime now = DateTime.now();
      double rand = (2 + random.nextInt(5)).toDouble();
      for (int i = 0; i < n; i++) {
        tempGluclist
            .add(GlucoseData(now.subtract(Duration(minutes: 5 * i)), rand));
        if (rand < 4) {
          rand += random.nextInt(2).toDouble();
        } else if (rand > 10) {
          rand -= random.nextInt(2).toDouble();
        } else {
          rand = (rand - 2) + random.nextInt(5).toDouble();
        }
      }
      alreadyRandom = true;
    }
    return tempGluclist;
  }

  DateTime visMin = DateTime.now().subtract(Duration(hours: 8));
  DateTime visMax = DateTime.now();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);
    return StreamBuilder(
        stream: DatabaseService(uid: user.uid).userDiary,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
          }
          tempGluclist = _createRandomData(1000);
          List graphData = snapshot.data;
          List imageData = graphData[1];
          List activityData = graphData[0];

          imageData = imageData.map((e) {
            var data = e.data();
            data['docId'] = e.id;
            return data;
          }).toList();

          activityData = activityData.map((e) {
            var data = e.data();
            data['docId'] = e.id;
            return data;
          }).toList();
          for (var item in imageData + activityData) {
            item['gluc'] = tempGluclist.firstWhere((element) {
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
          GlobalKey titleKey = new GlobalKey();
          return Scaffold(
            body: Center(
              child: Container(
                  child: Column(
                children: [
                  StatefulBuilder(
                      key: titleKey,
                      builder: (BuildContext context, setStateTitle) {
                        return Container(
                          child: Text(
                            DateFormat('d MMM: HH:mm').format(visMin) +
                                " - " +
                                DateFormat('HH:mm').format(visMax),
                          ),
                        );
                      }),
                  Expanded(
                    child: SfCartesianChart(
                      tooltipBehavior: _tooltipBehavior,
                      zoomPanBehavior: _zoomPanBehavior,
                      onPointTapped: (PointTapArgs args) {
                        if (args.seriesIndex == 1) {
                          var meal = imageData[args.pointIndex];
                          update([
                            new MealData(
                                meal['note'],
                                DateTime.fromMillisecondsSinceEpoch(
                                    meal['date']),
                                meal['imageRef'],
                                meal['docId'],
                                meal['localPath']),
                            false
                          ]);
                        } else if (args.seriesIndex == 2) {
                          var activity = activityData[args.pointIndex];
                          update([
                            new TrainingDiaryData(
                                trainingid: activity['docId'],
                                name: activity['name'],
                                description: activity['description'],
                                date: DateTime.fromMillisecondsSinceEpoch(
                                    activity['date']),
                                duration: Duration(
                                    milliseconds: activity['duration']),
                                intensity: activity['intensity']),
                            true
                          ]);
                        }
                      },
                      onActualRangeChanged: (ActualRangeChangedArgs args) {
                        if (args.orientation == AxisOrientation.horizontal) {
                          Future.delayed(Duration.zero, () {
                            try {
                              titleKey.currentState.setState(() {
                                visMin = DateTime.fromMillisecondsSinceEpoch(
                                    args.visibleMin);
                                visMax = DateTime.fromMillisecondsSinceEpoch(
                                    args.visibleMax);
                              });
                            } catch (e) {}
                          });
                        }
                      },
                      primaryYAxis: NumericAxis(
                          title: AxisTitle(
                              text: "mmol/L",
                              alignment: ChartAlignment.center,
                              textStyle: TextStyle(fontSize: 12))),
                      // Initialize category axis
                      primaryXAxis: DateTimeAxis(
                        autoScrollingDelta: 8,
                        autoScrollingDeltaType: DateTimeIntervalType.hours,
                      ),

                      series: <ChartSeries>[
                        LineSeries<GlucoseData, DateTime>(
                            enableTooltip: true,

                            // Bind data source
                            dataSource: tempGluclist,
                            xValueMapper: (GlucoseData glucose, _) =>
                                glucose.time,
                            yValueMapper: (GlucoseData glucose, _) =>
                                glucose.glucoseVal,
                            markerSettings: MarkerSettings(
                                isVisible: false,
                                shape: DataMarkerType.diamond)),
                        ScatterSeries(
                            color: Colors.red,
                            enableTooltip: true,
                            dataSource: imageData,
                            xValueMapper: (x, _) =>
                                DateTime.fromMillisecondsSinceEpoch(x['date']),
                            yValueMapper: (x, _) => x['gluc'].glucoseVal,
                            markerSettings: MarkerSettings(
                                height: 25.0,
                                width: 25.0,
                                shape: DataMarkerType.circle)),
                        ScatterSeries(
                          color: Colors.blue,
                          enableTooltip: true,
                          dataSource: activityData,
                          xValueMapper: (x, _) =>
                              DateTime.fromMillisecondsSinceEpoch(x['date']),
                          yValueMapper: (x, _) => x['gluc'].glucoseVal,
                          markerSettings: MarkerSettings(
                              height: 25.0,
                              width: 25.0,
                              shape: DataMarkerType.circle),
                        )
                      ],
                    ),
                  ),
                ],
              )),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniEndFloat,
            floatingActionButton: Align(
              //alignment: Alignment.bottomRight  ,
              alignment: Alignment(1, 0.8),
              child: FloatingActionButton(
                mini: true,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(1))),
                heroTag: "toStartButton",
                backgroundColor: Color(0xff99163d),
                onPressed: () {
                  setState(() {
                    visMax = DateTime.now();
                  });
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

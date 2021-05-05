import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/activityDiary.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/services/database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:quantify_app/models/mealData.dart';

class GraphicalInterface extends StatefulWidget {
  final ValueChanged update;
  final ValueChanged latest;
  GraphicalInterface({this.update, this.latest, @required this.graphPosSetter});
  final DateTime graphPosSetter;

  //GraphicalInterface({Key key});

  @override
  _GraphicalInterfaceState createState() => _GraphicalInterfaceState(
      update: update, latest: latest, graphPosSetter: graphPosSetter);
}

class _GraphicalInterfaceState extends State<GraphicalInterface> {
  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
  DateTime today = DateTime.now();
  TooltipBehavior _tooltipBehavior;
  bool alreadyRandom = false;
  final ValueChanged<List<dynamic>> update;
  final ValueChanged latest;

  _GraphicalInterfaceState({this.update, this.latest, this.graphPosSetter});
  DateTime graphPosSetter;

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
          List mealData = graphData[1];
          List activityData = graphData[0];
          mealData = mealData.map((e) {
            var data = e.data();
            data['docId'] = e.id;
            return data;
          }).toList();

          activityData = activityData.map((e) {
            var data = e.data();
            data['docId'] = e.id;
            return data;
          }).toList();
          for (var item in mealData + activityData) {
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
          mealData.sort(
              (b, a) => a['date'].toString().compareTo(b['date'].toString()));
          activityData.sort(
              (b, a) => a['date'].toString().compareTo(b['date'].toString()));
          var latestMeal;
          var latestAct;
          if (mealData.length > 0) {
            latestMeal = mealData[0];

            latestMeal = MealData(
                latestMeal['note'],
                DateTime.fromMillisecondsSinceEpoch(latestMeal['date']),
                latestMeal['imageRef'].cast<String>(),
                latestMeal['docId'],
                latestMeal['localPath'].cast<String>());
          }
          if (activityData.length > 0) {
            latestAct = activityData[0];
            latestAct = TrainingDiaryData(
                trainingid: latestAct['docId'],
                name: latestAct['name'],
                description: latestAct['description'],
                date: DateTime.fromMillisecondsSinceEpoch(latestAct['date']),
                duration: Duration(milliseconds: latestAct['duration']),
                intensity: latestAct['intensity'],
                category: latestAct['category']);
          }

          latest([latestMeal, latestAct]);
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
                          var latestMeal = mealData[args.pointIndex];
                          update([
                            new MealData(
                                latestMeal['note'],
                                DateTime.fromMillisecondsSinceEpoch(
                                    latestMeal['date']),
                                latestMeal['imageRef'].cast<String>(),
                                latestMeal['docId'],
                                latestMeal['localPath'].cast<String>()),
                            true
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
                                intensity: activity['intensity'],
                                category: activity['category']),
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
                        visibleMinimum: graphPosSetter != null
                            ? graphPosSetter.subtract(Duration(hours: 4))
                            : null,
                        visibleMaximum: graphPosSetter != null
                            ? graphPosSetter.add(Duration(hours: 4))
                            : null,
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
                            dataSource: mealData,
                            xValueMapper: (x, _) =>
                                DateTime.fromMillisecondsSinceEpoch(x['date']),
                            yValueMapper: (x, _) => x['gluc'].glucoseVal,
                            markerSettings: MarkerSettings(
                                height: 25.0,
                                width: 25.0,
                                shape: DataMarkerType.diamond)),
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
                              shape: DataMarkerType.diamond),
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
                    graphPosSetter = null;
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

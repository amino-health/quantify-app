import 'dart:async';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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

  List<String> iconList = [
    'https://raw.githubusercontent.com/google/material-design-icons/master/png/maps/directions_bike/materialicons/48dp/2x/baseline_directions_bike_black_48dp.png',
    'https://raw.githubusercontent.com/google/material-design-icons/master/png/maps/directions_run/materialicons/48dp/2x/baseline_directions_run_black_48dp.png',
    'https://raw.githubusercontent.com/google/material-design-icons/master/png/maps/directions_walk/materialicons/48dp/2x/baseline_directions_walk_black_48dp.png',
    'https://github.com/google/material-design-icons/blob/master/png/social/sports_hockey/materialicons/48dp/2x/baseline_sports_hockey_black_48dp.png',
    'https://github.com/google/material-design-icons/blob/master/png/social/sports_baseball/materialicons/48dp/2x/baseline_sports_baseball_black_48dp.png',
    'https://raw.githubusercontent.com/google/material-design-icons/master/png/social/sports_basketball/materialicons/48dp/2x/baseline_sports_basketball_black_48dp.png',
    'https://github.com/google/material-design-icons/blob/master/png/social/sports_football/materialicons/48dp/2x/baseline_sports_football_black_48dp.png',
    'https://github.com/google/material-design-icons/blob/master/png/social/sports_soccer/materialicons/48dp/2x/baseline_sports_soccer_black_48dp.png',
    'https://github.com/google/material-design-icons/blob/master/png/social/sports_tennis/materialicons/48dp/2x/baseline_sports_tennis_black_48dp.png',
    'https://github.com/google/material-design-icons/blob/master/png/social/sports_handball/materialicons/48dp/2x/baseline_sports_handball_black_48dp.png',
    'https://raw.githubusercontent.com/google/material-design-icons/master/png/maps/miscellaneous_services/materialicons/48dp/2x/baseline_miscellaneous_services_black_48dp.png',
    'https://raw.githubusercontent.com/google/material-design-icons/master/png/places/fitness_center/materialicons/48dp/2x/baseline_fitness_center_black_48dp.png'
  ];

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
                      onMarkerRender: (MarkerRenderArgs markerargs) {},
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
                              height: 25,
                              width: 25,
                              shape: DataMarkerType.circle,
                            )),
                        ScatterSeries(
                            isVisible: true,
                            enableTooltip: true,
                            dataSource: activityData,
                            xValueMapper: (x, _) =>
                                DateTime.fromMillisecondsSinceEpoch(x['date']),
                            yValueMapper: (x, _) => x['gluc'].glucoseVal,
                            dataLabelMapper: (x, _) =>
                                x['gluc'].glucoseVal.toString(),
                            markerSettings: MarkerSettings(
                              width: 15,
                              height: 15,
                              isVisible: true,
                              shape: DataMarkerType.circle,
                              borderWidth: 3,
                              borderColor: Colors.white,
                            ),
                            dataLabelSettings: DataLabelSettings(
                                isVisible: true,
                                builder: (dynamic data,
                                    dynamic point,
                                    dynamic series,
                                    int pointIndex,
                                    int seriesIndex) {
                                  return Container(
                                    height: 20,
                                    width: 20,
                                    child: CachedNetworkImage(
                                        imageUrl: iconList[
                                            activityData[pointIndex]
                                                ['category']],
                                        errorWidget: (context, _, nullval) =>
                                            Icon(Icons.warning)),
                                  );
                                }))
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

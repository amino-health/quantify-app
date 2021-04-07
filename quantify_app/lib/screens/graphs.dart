import 'dart:math';
//import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantify_app/screens/homeScreen.dart';
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
    final random = new Random();
    DateTime now = DateTime.now();
    double rand = (10 + random.nextInt(15)).toDouble();
    for (int i = 0; i < n; i++) {
      list.add(GlucoseData(now.subtract(Duration(hours: i)), rand));
      rand = ((rand - 2) + random.nextInt(5)).toDouble();
    }
    alreadyRandom = true;
    return list;
  }

  var visMin;
  var visMax;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              child: SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                onActualRangeChanged: (ActualRangeChangedArgs args) {
                  if (args.orientation == AxisOrientation.horizontal) {
                    visMax = args.visibleMax;
                    visMin = args.visibleMin;
                  }
                },
                zoomPanBehavior: _zoomPanBehavior,
                onPointTapped: (PointTapArgs args) {
                  if (args.pointIndex % 5 == 0) {
                    update(new MealData(
                        "Your meal",
                        "Quick afternoon snack",
                        args.dataPoints[args.pointIndex].x,
                        Image.network(
                            "https://www.burgerdudes.se/wp-content/uploads/2020/02/prime_mikescheese_19feb_med.jpg")));
                  }
                },
                onMarkerRender: (MarkerRenderArgs args) {
                  if (args.pointIndex % 5 == 0) {
                    args.color = Colors.red;
                    args.markerHeight = 20;
                    args.markerWidth = 20;
                    args.shape = DataMarkerType.diamond;
                    args.borderColor = Colors.red;
                    args.borderWidth = 2;
                  }
                  if (args.pointIndex % 12 == 0) {
                    args.color = Colors.blue;
                    args.markerHeight = 20;
                    args.markerWidth = 20;
                    args.shape = DataMarkerType.diamond;
                    args.borderColor = Colors.blue;
                    args.borderWidth = 2;
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
                    autoScrollingDeltaType: DateTimeIntervalType.hours
                    //isInversed: true,
                    //maximumLabels: 8,
                    ),
                title:
                    ChartTitle(text: DateFormat('EEEE, d MMM').format(today)),

                series: <LineSeries<GlucoseData, DateTime>>[
                  LineSeries<GlucoseData, DateTime>(
                      enableTooltip: true,

                      // Bind data source
                      dataSource:
                          !alreadyRandom ? _createRandomData(100) : list,
                      xValueMapper: (GlucoseData glucose, _) => glucose.time,
                      yValueMapper: (GlucoseData glucose, _) =>
                          glucose.glucoseVal,
                      markerSettings: MarkerSettings(
                          isVisible: true, shape: DataMarkerType.diamond))
                ],
              ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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

class GlucoseData {
  GlucoseData(this.time, this.glucoseVal);
  final DateTime time;
  final double glucoseVal;
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/date_symbol_data_local.dart';
//import 'package:bezier_chart/bezier_chart.dart';

class GraphicalInterface extends StatefulWidget {
  GraphicalInterface({Key key});

  @override
  _GraphicalInterfaceState createState() => _GraphicalInterfaceState();
}

class _GraphicalInterfaceState extends State<GraphicalInterface> {
  ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
  DateTime today = DateTime.now();
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

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
        primaryYAxis: NumericAxis(title: AxisTitle(text: "mmol/L")),
        // Initialize category axis
        primaryXAxis: DateTimeAxis(
          autoScrollingDelta: 8,
          //isInversed: true,
          //maximumLabels: 8,
        ),
        title: ChartTitle(text: DateFormat('EEEE, d MMM').format(today)),

        series: <LineSeries<GlucoseData, DateTime>>[
          LineSeries<GlucoseData, DateTime>(
              // Bind data source
              dataSource: <GlucoseData>[
                GlucoseData(DateTime.now().subtract(Duration(hours: 0)), 23),
                GlucoseData(DateTime.now().subtract(Duration(hours: 1)), 22),
                GlucoseData(DateTime.now().subtract(Duration(hours: 2)), 18),
                GlucoseData(DateTime.now().subtract(Duration(hours: 3)), 17),
                GlucoseData(DateTime.now().subtract(Duration(hours: 4)), 15),
                GlucoseData(DateTime.now().subtract(Duration(hours: 5)), 12),
                GlucoseData(DateTime.now().subtract(Duration(hours: 6)), 14),
                GlucoseData(DateTime.now().subtract(Duration(hours: 7)), 15),
                GlucoseData(DateTime.now().subtract(Duration(hours: 8)), 17),
                GlucoseData(DateTime.now().subtract(Duration(hours: 9)), 20),
                GlucoseData(DateTime.now().subtract(Duration(hours: 11)), 19),
                GlucoseData(DateTime.now().subtract(Duration(hours: 12)), 16),
                GlucoseData(DateTime.now().subtract(Duration(hours: 13)), 15),
                GlucoseData(DateTime.now().subtract(Duration(hours: 14)), 14),
                GlucoseData(DateTime.now().subtract(Duration(hours: 15)), 15),
                GlucoseData(DateTime.now().subtract(Duration(hours: 16)), 17),
                GlucoseData(DateTime.now().subtract(Duration(hours: 17)), 20),
                GlucoseData(DateTime.now().subtract(Duration(hours: 18)), 19),
                GlucoseData(DateTime.now().subtract(Duration(hours: 19)), 16),
                GlucoseData(DateTime.now().subtract(Duration(hours: 20)), 15),
                GlucoseData(DateTime.now().subtract(Duration(hours: 21)), 14),
                GlucoseData(DateTime.now().subtract(Duration(hours: 22)), 15),
              ],
              xValueMapper: (GlucoseData glucose, _) => glucose.time,
              yValueMapper: (GlucoseData glucose, _) => glucose.glucoseVal,
              markerSettings: MarkerSettings(
                  isVisible: true, shape: DataMarkerType.diamond))
        ],
      ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Align(
        alignment: Alignment(1, 0.7),
        child: FloatingActionButton(
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

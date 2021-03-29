import 'package:flutter/material.dart';


import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:bezier_chart/bezier_chart.dart';




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




class GlucoseData {
  GlucoseData(this.time, this.glucoseVal);
  final String time;
  final double glucoseVal;
}
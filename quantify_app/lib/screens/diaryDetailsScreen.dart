import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class DiaryDetailsScreen extends StatefulWidget {
  final String titlevalue;
  final String subtitle;
  final String dateTime;
  final String duration;
  final String intensity;

  const DiaryDetailsScreen({
    Key key,
    @required this.titlevalue,
    @required this.subtitle,
    @required this.dateTime,
    @required this.duration,
    @required this.intensity,
  }) : super(key: key);

  @override
  _DiaryDetailsState createState() =>
      _DiaryDetailsState(titlevalue, subtitle, dateTime, duration, intensity);
}

class _DiaryDetailsState extends State<DiaryDetailsScreen> {
  String titlevalue;
  String subtitle;
  String dateTime;
  String duration;
  String intensity;
  _DiaryDetailsState(this.titlevalue, this.subtitle, this.dateTime,
      this.duration, this.intensity);

//class DiaryDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
          child: Column(
        children: [
          Expanded(
            flex: 4,
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                      fit: BoxFit.fill, child: Icon(Icons.directions_run)),
                  flex: 5,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                              fit: BoxFit.fitWidth, child: Text(dateTime)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(('Duration: ' +
                                  (duration[0]) +
                                  'Hrs' +
                                  (duration[2] + duration[3]) +
                                  'Mins'))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text('Intensity: ' + intensity)),
                        ),
                      ),
                    ],
                  ),
                  flex: 5,
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  titlevalue,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 2,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                child: Text(subtitle),
                alignment: Alignment.topLeft,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

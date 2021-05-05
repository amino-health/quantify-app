import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/graphs.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/services/sensor.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Sensor sensor = new Sensor();
  int returnValue;

  void callbackResult(int result) {
    returnValue = result;
    print(returnValue);
    List<GlucoseData> lg = sensor.getTrendData();
    lg.forEach((element) {
      print("g: " +
          element.glucoseVal.toString() +
          " t: " +
          element.time.toString());
    });
    List<GlucoseData> hg = sensor.getHistoryData();
    hg.forEach((element) {
      print("g: " +
          element.glucoseVal.toString() +
          " t: " +
          element.time.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);
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
            ),
            ElevatedButton(
              onPressed: () async {
                int result =
                    await sensor.sensorSession(user.uid, callbackResult);
                print("RESLUT: " + result.toString());
              },
              child: Text("Scan"),
            ),
            ElevatedButton(
                onPressed: () async {
                  print(returnValue);
                  List<GlucoseData> lg = sensor.getTrendData();
                  lg.forEach((element) {
                    print("g: " +
                        element.glucoseVal.toString() +
                        " t: " +
                        element.time.toString());
                  });
                  List<GlucoseData> hg = sensor.getHistoryData();
                  hg.forEach((element) {
                    print("g: " +
                        element.glucoseVal.toString() +
                        " t: " +
                        element.time.toString());
                  });
                },
                child: Text("Print")),
          ],
        )));
  }
}

/* */

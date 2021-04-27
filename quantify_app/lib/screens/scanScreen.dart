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
  String _message = 'Scan the sensor';

  void callbackResult(int result) {
    returnValue = result;
    print(returnValue);

    switch (returnValue) {
      case 1:
        setState(
          () {
            _message = 'Sensor has not started yet';
          },
        );
        break;
      case 2:
        setState(
          () {
            _message = 'Wait sixty minutes before using sensor';
          },
        );
        break;
      case 3:
        setState(
          () {
            _message = 'Scan done';
          },
        );
        break;
      case 4:
        setState(
          () {
            _message = 'Sensor is more than 14 days old';
          },
        );
        break;
      case 5:
        setState(
          () {
            _message = 'Sensor is dead';
          },
        );
        break;
      case 6:
        setState(
          () {
            _message = 'Sensor failed';
          },
        );
        break;
      default:
        setState(
          () {
            _message = 'Scanning failed';
          },
        );
    }
    List<GlucoseData> lg = sensor.getTrendData();
    lg.forEach((element) {
      print(
        "g: " +
            element.glucoseVal.toString() +
            " t: " +
            element.time.toString(),
      );
    });
    List<GlucoseData> hg = sensor.getHistoryData();
    hg.forEach(
      (element) {
        print(
          "g: " +
              element.glucoseVal.toString() +
              " t: " +
              element.time.toString(),
        );
      },
    );
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
              _message,
              textScaleFactor: 3,
            ),
            Icon(
              Icons.nfc,
              size: MediaQuery.of(context).size.height * 0.3,
              color: Color(0xFF99163D),
            ),
            ElevatedButton(
              onPressed: () async {
                int result =
                    await sensor.sensorSession(user.uid, callbackResult);
                print("RESLUT: " + result.toString());
              },
              child: Text("Scan"),
            ),
          ],
        )));
  }
}

/* */

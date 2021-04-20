import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/services/sensor.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Sensor sensor = new Sensor();

  @override
  Widget build(BuildContext context) {
    Future<dynamic> _sensorScanned = sensor.sensorSession();
    return Scaffold(
      appBar: CustomAppBar(),
      body: FutureBuilder(
          future: _sensorScanned,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
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
                  )
                ],
              ));
            }
            return Container(
              child: snapshot.data,
            );
          }),
    );
  }
}

/* */

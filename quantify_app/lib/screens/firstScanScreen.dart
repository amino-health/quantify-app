import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class FirstScanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          )
        ],
      )),
    );
  }
}

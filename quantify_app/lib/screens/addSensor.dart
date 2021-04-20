import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:quantify_app/screens/graphs.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:quantify_app/services/sensor.dart';

class AddSensor extends StatefulWidget {
  @override
  _AddSensorState createState() => _AddSensorState();
}

class _AddSensorState extends State<AddSensor> {
  Sensor sensor = new Sensor();
  String _text = "";
  @override
  Widget build(BuildContext context) {
    final Future<String> _future = Future<String>.delayed(
      const Duration(seconds: 5),
      () => 'Data Loaded',
    );
    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            children: [
              Text(_text),
              ElevatedButton(
                  onPressed: () {
                    for (GlucoseData item in sensor.getTrendData()) {
                      print(item.glucoseVal.toString());
                    }
                  },
                  child: Text("Knapp"))
            ],
          )),
      floatingActionButton: FloatingActionButton(
        child: Text("knapp"),
        onPressed: () async {
          await sensor.sensorSession();
          print("--------------------------");

          setState(() {
            _text = sensor.getTrendData()[0].glucoseVal.toString();
          });
        },
      ),
    );
  }
}

import 'package:flutter/widgets.dart';

class SensorWidgetList {
  final List<Widget> widgetList = [
    Container(
      child: Text("Sensor not yet started"),
    ),
    Text("Sensor in warm up phase"),
    Text("Sensor ready and working"),
    Text("Sensor expired"),
    Text("Sensor shutdown"),
    Text("Sensor failure")
  ];

  Widget getSensorWidgetList(int widgetNumber) {
    return this.widgetList[widgetNumber];
  }
}

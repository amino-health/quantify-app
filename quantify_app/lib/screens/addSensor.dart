import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';

class AddSensor extends StatefulWidget {
  @override
  _AddSensorState createState() => _AddSensorState();
}

class _AddSensorState extends State<AddSensor> {
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
        child: FutureBuilder<String>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return Text("Waiting");
            }
            return Text(snapshot.data);
          },
        ),
      ),
    );
  }
}

/*Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current ",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
          ],
        ), */

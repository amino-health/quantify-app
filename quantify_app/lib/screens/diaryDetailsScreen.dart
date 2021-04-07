import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class DiaryDetailsScreen extends StatelessWidget {
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
                              fit: BoxFit.fitWidth,
                              child: Text('14:22 \n Tue 6 Jun')),
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
                  'Sample text',
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
                child: Text('Sample Description'),
                alignment: Alignment.topLeft,
              ),
            ),
          ),
        ],
      )),
    );
  }
}

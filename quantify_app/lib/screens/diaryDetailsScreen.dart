import 'dart:io';
//import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class DiaryDetailsScreen extends StatefulWidget {
  final String titlevalue;
  final String subtitle;
  final int dateTime;
  final int duration;
  final String intensity;
  final bool isIos;
  final String localPath;
  final String imgRef;

  const DiaryDetailsScreen({
    Key key,
    @required this.titlevalue,
    @required this.subtitle,
    @required this.dateTime,
    @required this.duration,
    @required this.intensity,
    @required this.isIos,
    @required this.localPath,
    @required this.imgRef,
  }) : super(key: key);

  @override
  _DiaryDetailsState createState() => _DiaryDetailsState(titlevalue, subtitle,
      dateTime, duration, intensity, isIos, localPath, imgRef);
}

class _DiaryDetailsState extends State<DiaryDetailsScreen> {
  String titlevalue;
  String subtitle;
  int dateTime;
  int duration;
  String intensity;
  bool isIos;
  String localPath;
  String imgRef;
  _DiaryDetailsState(this.titlevalue, this.subtitle, this.dateTime,
      this.duration, this.intensity, this.isIos, this.localPath, this.imgRef);

  Widget displayImage(
      BuildContext context, bool _isIos, String localPath, String imgRef) {
    if (localPath != null) {
      try {
        return Image.file(File(localPath));
      } catch (e) {}
    }
    return imgRef != null
        ? CachedNetworkImage(
            progressIndicatorBuilder: (context, url, downProg) =>
                CircularProgressIndicator(value: downProg.progress),
            imageUrl: imgRef,
            errorWidget: (context, url, error) => Icon(_isIos
                ? CupertinoIcons.exclamationmark_triangle_fill
                : Icons.error),
          )
        : Container(
            child: Icon(
              Icons.image_not_supported,
            ),
          );
  }

  activityView(String titlevalue, String subtitle, int dateTime, int duration,
      String intensity) {
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
                              child: Text(
                                  DateFormat('EEE, M/d/y\nHH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          dateTime)),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 25))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                            alignment: Alignment.bottomLeft,
                            child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                    'Duration: ' +
                                        (Duration(milliseconds: duration)
                                                    .inMinutes /
                                                60)
                                            .toString() +
                                        ':' +
                                        (Duration(milliseconds: duration)
                                                    .inMinutes %
                                                60)
                                            .toString() +
                                        ' Hrs',
                                    style: TextStyle(fontSize: 25)))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text('Intensity: ' + intensity,
                                  style: TextStyle(fontSize: 25))),
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
                child: Text(subtitle, style: TextStyle(fontSize: 25)),
                alignment: Alignment.topLeft,
              ),
            ),
          ),
        ],
      )),
    );
  }

  mealView(String titlevalue, String subtitle, int dateTime, bool isIos,
      String localPath, String imgRef) {
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
                      fit: BoxFit.fill,
                      child: displayImage(context, isIos, localPath, imgRef)),
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
                              child: Text(
                                  DateFormat('EEE, M/d/y\nHH:mm').format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          dateTime)),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(fontSize: 60))),
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
                child: Text(subtitle, style: TextStyle(fontSize: 25)),
                alignment: Alignment.topLeft,
              ),
            ),
          ),
        ],
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (localPath == 'activity') {
      return activityView(titlevalue, subtitle, dateTime, duration, intensity);
    } else {
      return mealView(titlevalue, subtitle, dateTime, isIos, localPath, imgRef);
    }
  }
}

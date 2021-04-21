import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:quantify_app/models/sensorWidgetList.dart';
import 'package:quantify_app/screens/graphs.dart';

class Sensor {
  // Constants
  static const int trendOffsetFstByte = 29;
  static const int trendOffsetSndByte = 28;
  static const int histOffsetFstByte = 125;
  static const int histOffsetSndByte = 124;
  static const int blockSize = 6;
  static const int minInMilliSec = 60000;

  int nfcReadTimeout = 1000;
  Uint8List data = Uint8List(360);

  Future<dynamic> sensorSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      print("isAvaliable");
      if (Platform.isAndroid) {
        print("isAndroid");
        NfcManager.instance.startSession(
          onDiscovered: (tag) async {
            try {
              print("----------------------------------");
              print(tag.data);

              Widget result = await readDataAndroid(tag);

              await NfcManager.instance.stopSession();
              return result;
              //setState(() => _alertMessage = result);
            } catch (e) {
              await NfcManager.instance
                  .stopSession()
                  .catchError((e) {/* no op */});
              print(e);
            }
          },
        ).catchError((e) => print(e));
      }
    }
  }

  Future<Widget> readDataAndroid(NfcTag tag) async {
    print('handleSensor');
    if (tag != null) {
      Uint8List identifier = tag.data['nfcv']['identifier'];
      int dsfId = tag.data['nfcv']['dsfId'];
      int responseFlags = tag.data['nfcv']['responseFlags'];
      int maxTransceiveLength = tag.data['nfcv']['maxTransceiveLength'];
      NfcV nfcV = NfcV(
          tag: tag,
          identifier: identifier,
          dsfId: dsfId,
          responseFlags: responseFlags,
          maxTransceiveLength: maxTransceiveLength);

      print("Trying to read data from tag");
      try {
        final int step = 1;
        for (int blockIndex = 0; blockIndex <= 40; blockIndex += step) {
          Uint8List sendData = Uint8List.fromList(
              [96, 32, 0, 0, 0, 0, 0, 0, 0, 0, blockIndex, 0]);

          List.copyRange(sendData, 2, identifier);

          Uint8List readData;
          //int startReadingTime = (DateTime.now().millisecondsSinceEpoch);
          //Uint8List.fromList([96,32,195,200,139,96,0,160,7,224,blockIndex,0])
          while (true) {
            try {
              readData = await nfcV.transceive(
                  data:
                      sendData); // 96 för datan 33 för längden. 195,200,139,96,0,160,7,224 is the identifier for the sensor
              break;
            } catch (e) {
              print(e);
            }
          }
          Uint8List cleanData = Uint8List(8);
          List.copyRange(cleanData, 0, readData, 2);
          print(cleanData);
          List.copyRange(data, 8 * blockIndex, cleanData);
        }
        return SensorWidgetList().getSensorWidgetList(data[4]);
      } catch (e) {
        print(e);
      }
    }
    return Container(
      child: Text("Error"),
    );
  }

  int getHistoryIndex() {
    return data[26];
  }

  int getTrendIndex() {
    return data[27];
  }

  double getGlucoseLevel(int fstByte, int sndByte) {
    return (((256 * fstByte) + (sndByte)) & 0x0FFF) / 8.5;
  }

  List<GlucoseData> getHistoryData() {
    List<GlucoseData> result = [];
    int watchTime = DateTime.now().millisecondsSinceEpoch;
    int indexTrend = getTrendIndex();
    int sensorTime = 256 * (data[317]) + (data[316]);
    int sensorStartTime = watchTime - sensorTime * minInMilliSec;

    for (int index = 0; index < 32; index++) {
      int i = indexTrend - index - 1;
      if (i < 0) i += 32;
      int time = [0, sensorTime - index].reduce(max);
      result.add(GlucoseData(
          DateTime.fromMillisecondsSinceEpoch(
              sensorStartTime + time * minInMilliSec),
          getGlucoseLevel(data[(i * blockSize + histOffsetFstByte)],
              data[(i * blockSize + histOffsetSndByte)])));
    }

    return result;
  }

  List<GlucoseData> getTrendData() {
    List<GlucoseData> result = [];
    int watchTime = DateTime.now().millisecondsSinceEpoch;
    int indexTrend = getTrendIndex();
    int sensorTime = 256 * (data[317]) + (data[316]);
    int sensorStartTime = watchTime - sensorTime * minInMilliSec;

    for (int index = 0; index < 16; index++) {
      int i = indexTrend - index - 1;
      if (i < 0) i += 16;
      int time = [0, sensorTime - index].reduce(max);
      result.add(GlucoseData(
          DateTime.fromMillisecondsSinceEpoch(
              sensorStartTime + time * minInMilliSec),
          getGlucoseLevel(data[(i * blockSize + trendOffsetFstByte)],
              data[(i * blockSize + trendOffsetSndByte)])));
    }

    return result;
  }
}

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:quantify_app/models/sensorWidgetList.dart';
import 'package:quantify_app/screens/graphs.dart';
import 'package:quantify_app/services/database.dart';

class Sensor {
  // Constants
  static const int trendOffsetFstByte = 29;
  static const int trendOffsetSndByte = 28;
  static const int histOffsetFstByte = 125;
  static const int histOffsetSndByte = 124;
  static const int blockSize = 6;
  static const int minInMilliSec = 60000;
  static const int sensorAlive = 3;

  int nfcReadTimeout = 1000;
  Uint8List data = Uint8List(360);
  String uid;

  Future<int> sensorSession(String uid, Function(int) f) async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    this.uid = uid;

    if (isAvailable) {
      print("isAvaliable");
      if (Platform.isAndroid) {
        print("isAndroid");
        await NfcManager.instance.startSession(
          onDiscovered: (tag) async {
            try {
              print("----------------------------------");
              print(tag.data);

              int result = await readDataAndroid(tag);
              if (result == sensorAlive) {
                List<GlucoseData> trend = getTrendData();
                List<GlucoseData> history = getHistoryData();

                await DatabaseService(uid: uid).updateGlucose(trend);
                await DatabaseService(uid: uid).updateGlucose(history);
              }
              await NfcManager.instance.stopSession();
              f(result);
            } catch (e) {
              await NfcManager.instance
                  .stopSession()
                  .catchError((e) {/* no op */});
              print(e);
            }
          },
        ).catchError((e) async {
          print(e);
          await NfcManager.instance.stopSession();
        });
      }
    }
    return 6;
  }

  Future<int> readDataAndroid(NfcTag tag) async {
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
        return data[4]; //SensorWidgetList().getSensorWidgetList(data[4]);
      } catch (e) {
        print(e);
      }
    }
    return 6;
  }

  int getTrendIndex() {
    return data[26];
  }

  int getHistoryIndex() {
    return data[27];
  }

  double getGlucoseLevel(int fstByte, int sndByte) {
    return (((256 * fstByte) + (sndByte)) & 0x0FFF) / 1;
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
      int time = [
        0,
        (((sensorTime - 3) / 15).abs() * 15 - index * 15).round()
      ] // Bordea vara 30 ist för 3 om det ska stämma med minuter
          .reduce(max);
      DateTime readTime = DateTime.fromMillisecondsSinceEpoch(
          sensorStartTime + time * minInMilliSec);
      result.add(
        GlucoseData(
          DateTime(readTime.year, readTime.month, readTime.day, readTime.hour,
              readTime.minute),
          getGlucoseLevel(
            data[(i * blockSize + histOffsetFstByte)],
            data[(i * blockSize + histOffsetSndByte)],
          ),
        ),
      );
      List list = [];
      for (int j = 0; j < 6; j++) {
        list.add(data[(i * blockSize + histOffsetSndByte) + j]);
      }
      DatabaseService(uid: this.uid)
          .uploadBlockData(list, sensorStartTime + time * minInMilliSec);
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
      List list = [];
      for (int j = 0; j < 6; j++) {
        list.add(data[(i * blockSize + trendOffsetSndByte) + j]);
      }
      DatabaseService(uid: this.uid)
          .uploadBlockData(list, sensorStartTime + time * minInMilliSec);
    }

    return result;
  }
}

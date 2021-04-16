import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';

class AddSensor extends StatefulWidget {
  @override
  _AddSensorState createState() => _AddSensorState();
}

class _AddSensorState extends State<AddSensor> {
  bool _nfc_use_multi_block_read = false;
  int nfcReadTimeout = 1000;

  Future<void> addSensor() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      if (Platform.isAndroid) {
        print("isAvaliable");
        NfcManager.instance.startSession(
          onDiscovered: (tag) async {
            try {
              print("HEEEEEEEEEEEEEEEEEEEEELLOO");

              print(tag.data);
              await handleSensor(tag);
              await NfcManager.instance.stopSession();
              return;
              //setState(() => _alertMessage = result);
            } catch (e) {
              print("FAAAAILED");
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

  Future<void> handleSensor(NfcTag tag) async {
    await addSensor();
    print('done');
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
        final int step = 1; //_nfc_use_multi_block_read ? 3 : 1;
        final int blockSize = 8;

        for (int blockIndex = 0; blockIndex <= 40; blockIndex += step) {
          Uint8List data;
          /*if (_nfc_use_multi_block_read) {
            data = Uint8List.fromList(
                [2, 35, blockIndex, 2]); // multi-block read 3 blocks
          } else {
            data = Uint8List.fromList(
                [96, 32, 0, 0, 0, 0, 0, 0, 0, 0, blockIndex, 0]);
            List.copyRange(data, 2, identifier, 0);
          }*/

          Uint8List readData;
          //int startReadingTime = (DateTime.now().millisecondsSinceEpoch);
          while (true) {
            try {
              readData = await nfcV.transceive(
                  data: Uint8List.fromList([
                96,
                32,
                195,
                200,
                139,
                96,
                0,
                160,
                7,
                224,
                blockIndex,
                0
              ])); // 195,200,139,96,0,160,7,224 is the identifier for the sensor
              print(readData);
              break;
            } catch (e) {
              print(e);
            }
          }

          /*if (_nfc_use_multi_block_read) {
            List.copyRange(
                readData, blockIndex * blockSize, data, 1, readData.length - 1);
          } else {
            readData = Arrays.copyOfRange(readData, 2, readData.length);
            System.arraycopy(
                readData, 0, data, blockIndex * blockSize, blockSize);
          }*/
        }
        print("Got NFC tag data");
      } catch (e) {
        print("asjhdkljaskdjhasjd");
        print(e);
      }
    }
  }

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
          child: Text("Hej")),
      floatingActionButton: FloatingActionButton(
        child: Text("knapp"),
        onPressed: addSensor,
      ),
    );
  }
}

/*FutureBuilder<String>(
          future: _future,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return Text("Waiting");
            }
            return Text(snapshot.data);
          },
        ), */

//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quantify_app/screens/DiaryDetailsScreen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quantify_app/services/database.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class DiaryScreen extends StatefulWidget {
  DiaryScreen({ValueKey key});

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

List weeklist = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
String weekday =
    weeklist[DateTime.parse('2021-04-06 10:02:14.453').weekday - 1];

List months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec'
];
String month = months[DateTime.parse('2021-04-06 10:02:14.453').month - 1];

class _DiaryScreenState extends State<DiaryScreen> {
  List<Widget> diaryList = <Widget>[];
  List<String> testList = [
    'Sample Diaryitem',
    'Description about exercise in simple text.',
    '10:02 \n $weekday 6 $month',
    'intensity'
  ];

  void _removeItem(ValueKey dismissKey) {
    setState(() {
      final user = Provider.of<UserClass>(context, listen: false);
      DatabaseService(uid: user.uid).removeDiaryItem(dismissKey.value);
    });
/*
    for (int j = 0; j < diaryList.length; j++) {
      
     
      if (diaryList[j].key == (dismissKey.value)) {
        print('List before $diaryList');
        diaryList.remove(diaryList[j]);
        print('List after $diaryList');
        print('removed item with key $j from data source');
      }
    } //Todo remove Activityitem from database
    */
  }
/*
  ValueKey _generateKey() {
    int topKeyIndex = 0;

    for (int j = 0; j < diaryList.length; j++) {
      String keyval = diaryList[j]
          .key
          .toString()
          .substring(3, diaryList[j].key.toString().length - 3);
      int compareVal = int.parse(keyval);
      if (topKeyIndex <= compareVal) {
        topKeyIndex = compareVal + 1;
      }
    }
    print('generated key is $topKeyIndex');
    return Key(topKeyIndex.toString());
  }
*/
  //activityData is list with String title, String subtitle, String, date, String intesity
  /*void addItem(context, activityData) {
    List<Widget> diaryList = [];

    ValueKey newkey = _generateKey();
    diaryList.add(diaryItem(context, activityData[0], activityData[1],
        activityData[2], activityData[3], newkey));

    // }
  }*/

  diaryItem(BuildContext context, String name, String _subtitle, String date,
      String duration, String intensity, ValueKey newKey) {
    return Padding(
      key: newKey,
      padding: const EdgeInsets.only(top: 8.0),
      child: Slidable(
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        child: Container(
            color: Colors.white,
            child: ListTile(
                leading: Icon(Icons.directions_run,
                    size: MediaQuery.of(context).size.height * 0.075),
                title: Text(name),
                subtitle: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20.0, right: 10),
                        child: Text(
                          _subtitle,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      flex: 5,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(child: Icon(Icons.access_time_sharp)),
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                      (date.substring(0, 10) +
                                              '\n' +
                                              date.substring(11, date.length))
                                          .toString(),
                                      textAlign: TextAlign.left)),
                            ],
                          ),
                          FittedBox(
                              fit: BoxFit.fitWidth,
                              child: TextButton(
                                  onPressed: () {}, child: Text('Show Graph')))
                        ],
                      ),
                      flex: 5,
                    )
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DiaryDetailsScreen(
                            titlevalue: name,
                            subtitle: _subtitle,
                            dateTime: (date.substring(0, 10) +
                                    '\n' +
                                    date.substring(11, date.length))
                                .toString(),
                            duration: duration,
                            intensity: intensity)),
                  );
                })),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () => _removeItem(newKey),
          ),
        ],
      ),
    );
  }

  void structureData(context, databaseData) {
    diaryList.clear();
    for (DocumentSnapshot entry in databaseData) {
      //ValueKey newkey = _generateKey();
      String date = entry['date'];
      date = date.substring(0, date.length - 7);
      //String duration = entry['duration'].substring(0, entry['duration'].length() - 6);
      diaryList.add(
        diaryItem(context, entry['name'], entry['description'], date,
            entry['duration'], entry['intensity'], ValueKey(entry.id)),
      );
    }
  }

  customScrollview(BuildContext context) {
    return Container(
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(children: diaryList),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context, listen: false);

    return FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('userData')
            .doc(user.uid)
            .collection('trainingDiary')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            print(documents);
            structureData(context, documents);
          } else {
            print('No training data found for user');
          }
          /* if (diaryList.isEmpty) {
            addItem(context, testList);
            addItem(context, testList);
            addItem(context, testList);
            addItem(context, testList);
          }*/

          return Center(
              child: Column(
            children: [
              customScrollview(context),
            ],
          ));
        });
  }
}

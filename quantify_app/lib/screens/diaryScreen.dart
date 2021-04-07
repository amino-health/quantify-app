//import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quantify_app/screens/DiaryDetailsScreen.dart';

//import 'package:flutter_svg/flutter_svg.dart';

class DiaryScreen extends StatefulWidget {
  DiaryScreen({Key key});

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

  void _removeItem(Key dismissKey) {
    setState(() {});

    for (int j = 0; j < diaryList.length; j++) {
      print(diaryList[j].key.hashCode.toString().toLowerCase());
      print(diaryList.hashCode.toString().toLowerCase());
      if (diaryList[j].key.hashCode == (dismissKey.hashCode)) {
        print('List before $diaryList');
        diaryList.remove(diaryList[j]);
        print('List after $diaryList');
        print('removed item with key $j from data source');
      }
    } //Todo remove Activityitem from database
  }

  Key _generateKey() {
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

  //activityData is list with String title, String subtitle, String, date, String intesity
  void addItem(context, activityData) {
    setState(() {
      Key newkey = _generateKey();
      diaryList.add(diaryItem(context, activityData[0], activityData[1],
          activityData[2], activityData[3], newkey));

      // }
    });
  }

  diaryItem(BuildContext context, String name, String _subtitle, String date,
      String intensity, Key newKey) {
    return Container(
        key: newKey,
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.15,
        child: Dismissible(
            key: newKey,
            onDismissed: (direction) {
              // Remove the item from the data source.
              _removeItem(newKey);
            },
            // Show a red background as the item is swiped away.
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color(0xFF99163D),
                    Color(0xFFF0F0F0),
                  ],
                ),
              ),
            ),
            child: Card(
                child: ListTile(
                    leading: Icon(Icons.directions_run,
                        size: MediaQuery.of(context).size.height * 0.075),
                    title: Text(name),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20.0, right: 10),
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
                                  Container(
                                      child: Icon(Icons.access_time_sharp)),
                                  FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(date,
                                          textAlign: TextAlign.left)),
                                ],
                              ),
                              FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: TextButton(
                                      onPressed: () {},
                                      child: Text('Show Graph')))
                            ],
                          ),
                          flex: 5,
                        )
                      ],
                    ),
                    /*trailing: Column(
                      children: [
                        Text(date, textAlign: TextAlign.center),
                        TextButton(onPressed: () {}, child: Text('Show Graph'))
                      ],
                    ),*/
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DiaryDetailsScreen()),
                      );
                    }))));
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
    if (diaryList.isEmpty) {
      addItem(context, testList);
      addItem(context, testList);
      addItem(context, testList);
    }

    return Center(
        child: Column(
      children: [
        customScrollview(context),
      ],
    ));
  }
}

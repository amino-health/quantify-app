import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quantify_app/loading.dart';
import 'package:quantify_app/models/userClass.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:quantify_app/services/database.dart';

class TosScreen extends StatefulWidget {
  final bool showContinue;
  TosScreen({Key key, this.showContinue}) : super(key: key);

  @override
  _TosScreenState createState() => _TosScreenState();
}

class _TosScreenState extends State<TosScreen> {
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);

  final _scaffoldKey = new GlobalKey<ScaffoldState>();
//Boolean value that is checked when user presses continue.
  var _checked = false;
  Widget build(BuildContext context) {
    final user = Provider.of<UserClass>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return new Scaffold(
                key: _scaffoldKey,
                appBar: CustomAppBar(),
                body: Center(
                    child: Column(
                  children: <Widget>[
                    Align(
                      child: Text(
                        "Terms & conditions",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: Align(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.7,
                          width: MediaQuery.of(context).size.width * 0.9,
                          color: Color(0xFFF0F0F0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Text(lipsum.createText(numParagraphs: 5)
                                  //style: TextStyle(fontFamily: 'RobotoMono')
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CheckboxListTile(
                          key: Key('tos'),
                          title: Text("I accept the terms and conditions."),
                          controlAffinity: ListTileControlAffinity.leading,
                          value: _checked,
                          onChanged: (newValue) {
                            setState(() {
                              _checked = !_checked;
                            });
                          }),
                    ),
                    Flexible(
                      flex: 1,
                      child: Align(
                        child: ElevatedButton(
                          key: Key('continue'),
                          onPressed: () async {
                            if (_checked) {
                              await DatabaseService(uid: user.uid)
                                  .updateUserData(
                                      userData.name,
                                      userData.uid,
                                      userData.email,
                                      false,
                                      userData.age,
                                      userData.weight,
                                      userData.height,
                                      true,
                                      userData.gender);
                            }
                          },
                          style: ButtonStyle(backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return const Color(0xFF99163D);
                          })),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: Center(child: Text("Continue")),
                          ),
                        ),
                      ),
                    )
                  ],
                )));
          } else {
            return Loading();
          }
        });
  }
}

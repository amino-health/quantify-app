import 'dart:html';

import 'package:flutter/material.dart';

class TosScreen extends StatefulWidget {
  TosScreen({Key key}) : super(key: key);

  @override
  _TosScreenState createState() => _TosScreenState();
}

class _TosScreenState extends State<TosScreen> {
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        body: Center(
          child: Column(
            children: [
              Text("Terms & conditions",style: TextStyle(fontSize: 30),),
              Container(
                height: MediaQuery.of(context).size.height*0.4,
                width: MediaQuery.of(context).size.width*0.9,
                color: Colors.grey,)
            ],)
    ));
    return scaffold;
  }
}

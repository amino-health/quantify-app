import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';
import 'package:lipsum/lipsum.dart' as lipsum;
import 'package:google_fonts/google_fonts.dart';
import 'package:quantify_app/screens/homeScreen.dart';

class TosScreen extends StatefulWidget {
  TosScreen({Key key, bool showContinue}) : super(key: key);

  @override
  _TosScreenState createState() => _TosScreenState();
}

class _TosScreenState extends State<TosScreen> {
  ScrollController _scrollController = ScrollController(keepScrollOffset: true);

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  var _checked = false;
  Widget build(BuildContext context) {
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
                      child: Text(lipsum.createText(numParagraphs: 5),
                          style: GoogleFonts.roboto(fontSize: 15)),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: CheckboxListTile(
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
                  onPressed: () {
                    if (_checked) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
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
  }
}

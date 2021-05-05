import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:quantify_app/screens/wrapper.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              "lib/assets/red_logo.svg",
            )
            //height: MediaQuery.of(context).size.height * 1),
            ),
      ),
      Container(
          height: MediaQuery.of(context).size.height * 0.1,
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "lib/assets/text.svg",
            color: Colors.black,
          )
          //height: MediaQuery.of(context).size.height * 0.04),
          ),
      Padding(
        padding: const EdgeInsets.only(left: 50, right: 50, top: 10),
        child: Text('Are you ready to take your life to the next level?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: 'Roboto-Medium',
                fontSize: (MediaQuery.of(context).size.height * 0.03))),
      ),
      Padding(
        padding:
            EdgeInsets.only(top: (MediaQuery.of(context).size.height * 0.1)),
        child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed))
                    return Color(0xDD99163D);
                  else
                    return Color(0xFF99163D);
                },
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 45.0, right: 45.0, top: 12.0, bottom: 12.0),
              child: (Text('Get Started',
                  style:
                      TextStyle(fontFamily: 'Roboto-Medium', fontSize: 16.0))),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Wrapper()));
            }),
      ),
    ])));
  }
}

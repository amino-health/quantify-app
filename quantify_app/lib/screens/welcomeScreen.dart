import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:quantify_app/screens/main.dart';
//import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              alignment: Alignment.center,
              child: SvgPicture.asset("lib/assets/text.svg",
                  color: Colors.black,
                  height: MediaQuery.of(context).size.height * 0.04),
            ),




            Padding(
              padding: const EdgeInsets.only(left: 50, right: 50),
              child: Text('Are you ready to take your life to the next level?',
              textAlign: TextAlign.center,
              style: 
                TextStyle(
                  fontFamily: 'Roboto-Medium', fontSize: 30.0
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed))
                        return Color(0xDD99163D);
                      else
                        return Color(0xFF99163D);
                      return null; // Use the component's default.
                    },
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:45.0, right: 45.0, top: 12.0, bottom: 12.0),
                  child: (
                    Text(
                      'Get Started',
                      
                      style: TextStyle(
                        fontFamily: 'Roboto-Medium', fontSize: 16.0
                      )
                    )
                  ),
                ),
                onPressed: () {}
              ),
            ),
          ]
        )
      )
    );
  }
}

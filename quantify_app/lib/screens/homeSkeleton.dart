import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  CustomAppBar({Key key})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize; // default is 56.0

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      title: Container(
        height: MediaQuery.of(context).size.height * 0.1,
        alignment: Alignment.centerLeft,
        child: SvgPicture.asset("lib/assets/quantify.svg",
            color: Colors.white,
            height: MediaQuery.of(context).size.height * 0.04),
      ),
      backgroundColor: Color(0xFF99163D),
      toolbarHeight: MediaQuery.of(context).size.height * 0.1,
    );
  }
}

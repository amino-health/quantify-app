import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'homeSkeleton.dart';

class Change extends StatefulWidget {
  final String toChange;

  Change({Key key, this.toChange}) : super(key: key);

  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _changeController = TextEditingController();
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                keyboardType: widget.toChange == "email"
                    ? TextInputType.emailAddress
                    : TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  labelText: "New ${widget.toChange}",
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                return const Color(0xFF99163D);
              })),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.7,
                child: Center(child: Text("Confirm change")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'homeSkeleton.dart';

class Change extends StatefulWidget {
  final String toChange;
  final dynamic current;

  Change({Key key, this.toChange, this.current}) : super(key: key);

  @override
  _ChangeState createState() => _ChangeState();
}

class _ChangeState extends State<Change> {
  final TextStyle titleTextStyle;

  _ChangeState({this.titleTextStyle});

  @override
  Widget build(BuildContext context) {
    String _unit = widget.toChange == "weight"
        ? " kg"
        : widget.toChange == "height"
            ? " cm"
            : "";
    String _change = widget.toChange.toString();
    String _current = widget.current.toString() + _unit;

    TextEditingController _inputController = TextEditingController();

    bool _validate = false;
    String _errorMsg = "";

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current ${widget.toChange}",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 16, bottom: 16),
              child: Text(
                _current,
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              "New ${widget.toChange}",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).accentColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12),
              child: TextFormField(
                controller: _inputController,
                keyboardType: _change == "email"
                    ? TextInputType.text
                    : TextInputType.number,
                onEditingComplete: () {
                  String text = _inputController.text;
                  if (_change == "email") {
                    EmailValidator.validate(text)
                        ? _validate = true
                        : _errorMsg = "Invalid email";
                  }
                  if (_change == "height") {
                    double.parse(text) < 210.0 && double.parse(text) > 100.0
                        ? _validate = true
                        : _errorMsg = "Invalid height";
                  }
                  if (_change == "weight") {
                    double.parse(text) < 150.0 && double.parse(text) > 30.0
                        ? _validate = true
                        : _errorMsg = "Invalid height";
                  }
                },
                decoration: InputDecoration(
                  errorText: _validate ? null : _errorMsg,
                  contentPadding: EdgeInsets.all(4),
                  isDense: true,
                  hintText:
                      '${_change[0].toUpperCase()}${_change.substring(1)}',
                  border: UnderlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final _formKey = GlobalKey<FormState>();

    String _unit = widget.toChange == "weight"
        ? " kg"
        : widget.toChange == "height"
            ? " cm"
            : "";
    String _change = widget.toChange.toString();
    String _current = widget.current.toString() + _unit;

    TextEditingController _inputController = TextEditingController();

    return Scaffold(
      appBar: CustomAppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: Form(
          key: _formKey,
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
                padding: const EdgeInsets.only(top: 12, bottom: 10),
                child: TextFormField(
                  controller: _inputController,
                  keyboardType: _change == "email"
                      ? TextInputType.text
                      : TextInputType.number,
                  inputFormatters: _change != "email"
                      ? <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(
                              '^\$|^(0|([1-9][0-9]{0,}))(\\.[0-9]{0,})?\$')),
                        ]
                      : null,
                  validator: (text) {
                    if (_change == "email") {
                      return EmailValidator.validate(text)
                          ? null
                          : "Invalid email";
                    }
                    if (_change == "height") {
                      try {
                        return double.parse(text) < 252.0 &&
                                double.parse(text) > 67.0
                            ? null
                            : "Invalid height";
                      } catch (e) {
                        return "Can only contain digits";
                      }
                    }
                    if (_change == "weight") {
                      return double.parse(text) < 442.0 &&
                              double.parse(text) > 30.0
                          ? null
                          : "Invalid height";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(4),
                    isDense: true,
                    hintText:
                        '${_change[0].toUpperCase()}${_change.substring(1)}',
                    border: UnderlineInputBorder(),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

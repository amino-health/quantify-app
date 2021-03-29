import 'package:flutter/material.dart';
import 'package:quantify_app/screens/homeSkeleton.dart';

class AddMealScreen extends StatefulWidget {
  AddMealScreen({Key key}) : super(key: key);

  @override
  _AddMealScreenState createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: CustomAppBar(),
      body: Center(
          child: ElevatedButton(
        onPressed: () {},
        child: Text("Camera"),
      )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SmartButton(),
      bottomNavigationBar: CustomNavBar(),
    );
  }
}

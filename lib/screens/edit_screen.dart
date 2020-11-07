import 'package:flutter/material.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

class EditScreen extends StatefulWidget {
  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          decoration: BackgroundDecoration(3.0, 0.43),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: EditForm()))),
    );
  }
}

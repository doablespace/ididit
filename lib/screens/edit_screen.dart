import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

enum ActivityChange { add, edit, challenge }

class EditScreen extends StatefulWidget {
  final ActivityChange activityChange;
  final Activity input;
  EditScreen({ActivityChange activityChange: ActivityChange.add, this.input})
      : this.activityChange = activityChange;

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: 400,
          decoration: BackgroundDecoration(4.0, 0.43),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: EditForm(widget.activityChange, widget.input)),
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/edit_form.dart';

class EditScreen extends StatefulWidget {
  final String title = '';
  final String description = '';
  final String picture = '';
  final Map<String, Color> color = ActivityColors.blue;

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          decoration: BackgroundDecoration(3.0, 0.43),
          child:
              Scaffold(backgroundColor: Colors.transparent, body: EditForm())),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';

class ActivityTitle extends StatefulWidget {
  final Activity activity;

  ActivityTitle(this.activity);
  @override
  _ActivityTitleState createState() => _ActivityTitleState();
}

class _ActivityTitleState extends State<ActivityTitle> {
  int _charCount = 0;
  int _maxCharCount = 50;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: _lightGreyTextStyle,
      cursorColor: ThemeColors.lightGrey,
      decoration: InputDecoration(
        labelText: 'New mystery activity',
        labelStyle: _lightGreyTextStyle,
        hintText: 'Input text',
        hintStyle: _lightGreyTextStyle,
        alignLabelWithHint: true,
        contentPadding: EdgeInsets.all(20.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        counter: Text('$_charCount / 50', style: _lightGreyTextStyle),
        enabledBorder: _activityTitleBorder,
        focusedBorder: _activityTitleBorder,
      ),
      validator: (title) {
        if (title.length > _maxCharCount) {
          return 'Title can have maximum 50 characters.';
        }
        return null;
      },
      onChanged: (title) => setState(() => _charCount = title.length),
      onSaved: (title) => widget.activity.name = title,
    );
  }
}

var _activityTitleBorder = OutlineInputBorder(
    gapPadding: 3.0,
    borderRadius: BorderRadius.all(Radius.circular(24)),
    borderSide: BorderSide(color: ThemeColors.lightGrey, width: 1.0));

var _lightGreyTextStyle = TextStyle(color: ThemeColors.lightGrey);

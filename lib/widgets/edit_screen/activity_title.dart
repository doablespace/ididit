import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';

import 'edit_form.dart';

class ActivityTitle extends StatefulWidget {
  final Activity activity;

  ActivityTitle(this.activity);
  @override
  _ActivityTitleState createState() => _ActivityTitleState();
}

class _ActivityTitleState extends State<ActivityTitle> {
  int _charCount = 0;
  int _maxCharCount = 50;
  // This is workaround for not being to change color of border label on error.
  bool _isError = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 16),
      child: TextFormField(
        style: CustomTextStyle(ThemeColors.lightGrey),
        cursorColor: ThemeColors.lightGrey,
        decoration: InputDecoration(
          labelText: 'New mystery activity',
          labelStyle: CustomTextStyle(
            _isError ? ThemeColors.pastelRed : ThemeColors.lightGrey,
          ),
          hintText: 'Input text',
          hintStyle: CustomTextStyle(
            _isError ? ThemeColors.pastelRed : ThemeColors.lightGrey,
          ),
          errorStyle: CustomTextStyle(ThemeColors.pastelRed),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.all(20.0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          counter: Text(
            '$_charCount / 50',
            style: CustomTextStyle(
                _isError ? ThemeColors.pastelRed : ThemeColors.lightGrey),
          ),
          enabledBorder: TitleInputBorder(ThemeColors.lightGrey),
          focusedBorder: TitleInputBorder(ThemeColors.lightGrey),
          errorBorder: TitleInputBorder(ThemeColors.pastelRed),
          focusedErrorBorder: TitleInputBorder(ThemeColors.pastelRed),
        ),
        validator: (title) {
          if (title.length > _maxCharCount) {
            setState(() {
              _isError = true;
            });
            return 'Sadly, you have to do with maximum 50 characters.';
          }
          if (title.length <= 0) {
            setState(() {
              _isError = true;
            });
            return "Don't forget to add title.";
          }
          return null;
        },
        onChanged: (title) => setState(() => _charCount = title.length),
        onSaved: (title) => widget.activity.name = title,
      ),
    );
  }
}

class TitleInputBorder extends OutlineInputBorder {
  TitleInputBorder(Color borderColor)
      : super(
            gapPadding: 3.0,
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: borderColor, width: 2.0));
}

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
    final double _inputFontSize = 18;

    return Padding(
      padding:
          const EdgeInsets.only(top: 32.0, bottom: 16, left: 24, right: 24),
      child: TextFormField(
        initialValue: widget.activity.name,
        style: CustomTextStyle(
          ThemeColors.upperBackground,
          fontSize: _inputFontSize,
        ),
        cursorColor: ThemeColors.upperBackground,
        decoration: InputDecoration(
          labelText: 'Activity name',
          labelStyle: CustomTextStyle(
            _isError ? ThemeColors.noColor : ThemeColors.upperBackground,
          ),
          hintText: 'New mystery activity',
          hintStyle: CustomTextStyle(
              _isError
                  ? ThemeColors.noColor.withOpacity(0.6)
                  : ThemeColors.upperBackground.withOpacity(0.6),
              fontSize: _inputFontSize,
              fontWeight: FontWeight.w400),
          errorStyle: CustomTextStyle(ThemeColors.noColor),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.all(20.0),
          counter: Text(
            '$_charCount / 50',
            style: CustomTextStyle(
                _isError ? ThemeColors.noColor : ThemeColors.upperBackground),
          ),
          enabledBorder: TitleInputBorder(ThemeColors.upperBackground),
          focusedBorder: TitleInputBorder(ThemeColors.upperBackground),
          errorBorder: TitleInputBorder(ThemeColors.noColor),
          focusedErrorBorder: TitleInputBorder(ThemeColors.noColor),
        ),
        validator: (title) {
          if (title.length > _maxCharCount) {
            setState(() {
              _isError = true;
            });
            return 'Sadly, maximum 50 characters.';
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

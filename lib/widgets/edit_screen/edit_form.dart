import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/edit_screen/activity_color.dart';
import 'package:ididit/widgets/edit_screen/activity_title.dart';

import 'activity_image.dart';

class EditForm extends StatefulWidget {
  @override
  EditFormState createState() {
    return EditFormState();
  }
}

class EditFormState extends State<EditForm> {
  // Form identifier.
  final _formKey = GlobalKey<FormState>();
  Activity activity = Activity(color: 0);

  updateColor() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 100;
    double buttonHeight = 36;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 64.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ActivityImage(activity),
                ActivityTitle(activity),
                ActivityColor(activity, updateColor),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: buttonHeight,
                  width: buttonWidth,
                  margin: EdgeInsets.only(right: 12),
                  decoration: new BoxDecoration(
                    border:
                        Border.all(color: ThemeColors.lightGrey, width: 2.0),
                    borderRadius: new BorderRadius.all(Radius.circular(100)),
                  ),
                  child: TextButton(
                      onPressed: null,
                      child: Text('CANCEL',
                          style: CustomTextStyle(ThemeColors.lightGrey))),
                ),
                Container(
                  height: buttonHeight,
                  width: buttonWidth,
                  decoration: new BoxDecoration(
                    color: ThemeColors.lightGrey,
                    border:
                        Border.all(color: ThemeColors.lightGrey, width: 2.0),
                    borderRadius: new BorderRadius.all(Radius.circular(100)),
                  ),
                  child: TextButton(
                      onPressed: () {
                        var form = _formKey.currentState;
                        if (form.validate()) {
                          form.save();
                          print(activity.name);
                          print(activity.color);
                          print(activity.icon);
                        }
                      },
                      child: Text('ADD',
                          style: CustomTextStyle(ThemeColors.lightBlue))),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextStyle extends TextStyle {
  CustomTextStyle(Color color,
      {FontWeight fontWeight: FontWeight.w600, double fontSize: 14})
      : super(color: color, fontWeight: FontWeight.w600, fontSize: fontSize);
}

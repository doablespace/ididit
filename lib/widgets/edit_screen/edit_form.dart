import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/screens/edit_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/edit_screen/activity_color.dart';
import 'package:ididit/widgets/edit_screen/activity_image.dart';
import 'package:ididit/widgets/edit_screen/activity_title.dart';
import 'package:ididit/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

class EditForm extends StatefulWidget {
  final ActivityChange _activityChange;
  final Activity _input;
  EditForm(this._activityChange, this._input);
  @override
  EditFormState createState() {
    return EditFormState();
  }
}

class EditFormState extends State<EditForm> {
  // Form identifier.
  final _formKey = GlobalKey<FormState>();
  Activity activity;

  updateColor() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Bloc to access database.
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);
    // Call only on first access.
    if (activity == null) {
      if (widget._activityChange == ActivityChange.challenge) {
        activity = widget._input;
      } else {
        // Pick color at random. Here, to have effect on `ActivityImage`.
        var colorId = Random().nextInt(ActivityColors.colors.length);
        activity = widget._activityChange == ActivityChange.edit
            ? activitiesBloc.currentActivity
            : Activity(color: colorId);
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
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
            padding: const EdgeInsets.symmetric(vertical: 32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundedButton(
                  label: 'Cancel',
                  borderColor: ThemeColors.upperBackground,
                  textColor: ThemeColors.upperBackground,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 24),
                  child: RoundedButton(
                    label: widget._activityChange == ActivityChange.edit
                        ? 'Edit'
                        : 'Add',
                    borderColor: ThemeColors.upperBackground,
                    backgroundColor: ThemeColors.upperBackground,
                    textColor: ThemeColors.lowerBackground,
                    onPressed: () {
                      var form = _formKey.currentState;
                      // Check for
                      if (form.validate()) {
                        // Saves text from text input fields.
                        form.save();
                        if (widget._activityChange == ActivityChange.edit) {
                          activitiesBloc.editActivity(activity);
                        } else {
                          activity.created = DateTime.now();
                          activitiesBloc.addActivity(activity);
                        }

                        Navigator.pop(context);
                      }
                    },
                  ),
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
      : super(color: color, fontWeight: fontWeight, fontSize: fontSize);
}

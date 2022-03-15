import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/screens/edit_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/edit_screen/activity_color.dart';
import 'package:ididit/widgets/edit_screen/activity_image.dart';
import 'package:ididit/widgets/edit_screen/activity_title.dart';
import 'package:ididit/widgets/rounded_button.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

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
            : Activity(
                color: colorId,
                customOrder: activitiesBloc.minOrder - 1,
              );
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
                IconButton(
                  color: ThemeColors.upperBackground,
                  icon: Icon(Icons.share_rounded),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 18),
                  tooltip: 'Challenge someone',
                  onPressed: () {
                    // Save old activity.
                    final prev = activity;
                    // Get form values into a clone.
                    activity = Activity.fromMap(prev.toMap());
                    _formKey.currentState.save();
                    final values = activity
                        .toMap()
                        .map((key, value) => MapEntry(key, value?.toString()));
                    // Restore original activity.
                    activity = prev;

                    // Create deep link.
                    values.remove('created');
                    final link = Uri(
                        scheme: 'https',
                        host: 'i-did-it.netlify.app',
                        path: '/',
                        queryParameters: values);
                    try {
                      Share.share(link.toString());
                    } on PlatformException {
                      return;
                    }

                    Navigator.pop(context);
                  },
                ),
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
                          activity.created = DateTime.now().toUtc();
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

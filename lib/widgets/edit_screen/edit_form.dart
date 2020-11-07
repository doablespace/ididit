import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
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
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ActivityImage(activity),
          ActivityTitle(activity),
          ActivityColor(activity, updateColor),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                var form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  print(activity.name);
                  print(activity.color);
                }
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}

// Create a Form widget.
import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/widgets/edit_screen/activity-color.dart';
import 'package:ididit/widgets/edit_screen/activity-title.dart';

class EditForm extends StatefulWidget {
  @override
  EditFormState createState() {
    return EditFormState();
  }
}

class EditFormState extends State<EditForm> {
  // Form identifier.
  final _formKey = GlobalKey<FormState>();
  Activity activity = Activity();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ActivityTitle(activity),
          ActivityColor(activity),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                var form = _formKey.currentState;
                if (form.validate()) {
                  form.save();
                  print(activity.name);
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

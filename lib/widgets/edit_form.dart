// Create a Form widget.
import 'package:flutter/material.dart';
import 'package:ididit/ui/color_theme.dart';

class EditForm extends StatefulWidget {
  @override
  EditFormState createState() {
    return EditFormState();
  }
}

class EditFormState extends State<EditForm> {
  // Form identifier.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          TextFormField(
            decoration: new InputDecoration(
              labelText: 'New mystery activity',
              labelStyle: TextStyle(color: ThemeColors.lightGrey),
              hintText: 'Input text',
              hintStyle: TextStyle(color: ThemeColors.lightGrey),
              alignLabelWithHint: true,
              contentPadding: EdgeInsets.all(20.0),
              border: OutlineInputBorder(
                  gapPadding: 0.0,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide:
                      BorderSide(color: ThemeColors.lightGrey, width: 1.0)),
              focusedBorder: OutlineInputBorder(
                  gapPadding: 3.0,
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                  borderSide:
                      BorderSide(color: ThemeColors.lightGrey, width: 1.0)),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false
                // otherwise.
                if (_formKey.currentState.validate()) {
                  // If the form is valid, display a Snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text('Processing Data')));
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

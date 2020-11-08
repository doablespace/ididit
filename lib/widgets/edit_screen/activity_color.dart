import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';

class ActivityColor extends StatefulWidget {
  final Activity activity;
  // To pass back to form information on color change.
  final Function() notifyForm;

  ActivityColor(this.activity, this.notifyForm);

  @override
  _ActivityColorState createState() => _ActivityColorState(activity.color);
}

class _ActivityColorState extends State<ActivityColor> {
  _ActivityColorState(this.colorId);

  void changeColor(id) {
    setState(() {
      colorId = id;
      widget.activity.color = id;
      widget.notifyForm();
    });
  }

  int colorId;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.transparent),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (int i = 0; i < ActivityColors.colors.length; i++)
              Stack(children: [
                Container(
                    // IMPORTANT: The background circle size are determined from `radio.dart` file.
                    // _kOuterRadius = 8.0
                    height: 24,
                    width: 24,
                    margin: EdgeInsets.all(8),
                    decoration: new BoxDecoration(
                      color: ActivityColors.colors[i]['ink'],
                      border: Border.all(
                          color: ActivityColors.colors[i]['accent'],
                          width: 0.0),
                      borderRadius: new BorderRadius.all(Radius.circular(100)),
                    )),
                Transform.scale(scale: 2.5, child: ColorRadio(i, this))
              ])
          ],
        ),
      ),
    );
  }
}

class ColorRadio extends Radio {
  ColorRadio(int colorId, _ActivityColorState _activityColorState)
      : super(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          activeColor: ActivityColors.colors[colorId]['accent'],
          value: colorId,
          groupValue: _activityColorState.colorId,
          onChanged: _activityColorState.changeColor,
        );
}

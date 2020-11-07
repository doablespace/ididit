import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';

class ActivityColor extends StatefulWidget {
  final Activity activity;
  ActivityColor(this.activity);

  @override
  _ActivityColorState createState() => _ActivityColorState();
}

class _ActivityColorState extends State<ActivityColor> {
  void changeColor(id) {
    setState(() {
      colorId = id;
      widget.activity.color = id;
    });
  }

  int colorId = 0;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Colors.transparent),
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
                  margin: EdgeInsets.all(12),
                  decoration: new BoxDecoration(
                    color: ActivityColors.colors[i]['ink'],
                    border: Border.all(
                        color: ActivityColors.colors[i]['accent'], width: 0.0),
                    borderRadius: new BorderRadius.all(Radius.circular(100)),
                  )),
              Transform.scale(scale: 2.5, child: ColorRadio(i, this))
            ])
        ],
      ),
    );
  }
}

class ColorRadio extends Radio {
  ColorRadio(int colorId, _ActivityColorState _activityColorState)
      : super(
          activeColor: ActivityColors.colors[colorId]['accent'],
          value: colorId,
          groupValue: _activityColorState.colorId,
          onChanged: _activityColorState.changeColor,
        );
}

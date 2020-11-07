import 'package:flutter/material.dart';
import 'package:ididit/ui/color_theme.dart';

class ActivityBox extends StatelessWidget {
  final Color color;
  final Widget child;

  const ActivityBox({Key key, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(50),
        child: child,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.darkBlue.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 4,
            offset: Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
    );
  }
}

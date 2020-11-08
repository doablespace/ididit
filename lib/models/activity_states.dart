import 'package:flutter/material.dart';
import 'package:ididit/ui/color_theme.dart';

class ActivityState {
  final int value;
  final IconData iconData;
  final String text;
  final Color color;

  const ActivityState({
    @required this.value,
    @required this.iconData,
    @required this.text,
    @required this.color,
  });

  factory ActivityState.fromDirection(DismissDirection direction) {
    switch (direction) {
      case DismissDirection.up:
        return yes;
      case DismissDirection.down:
        return no;
      case DismissDirection.startToEnd:
        return almost;
      case DismissDirection.endToStart:
        return skip;
      default:
        throw ArgumentError.value(
            direction, 'direction', 'Invalid DismissDirection provided.');
    }
  }

  static final yes = ActivityState(
    value: 0,
    iconData: Icons.check_rounded,
    text: 'yes',
    color: ThemeColors.yesColor,
  );
  static final no = ActivityState(
    value: 1,
    iconData: Icons.close_rounded,
    text: 'no',
    color: ThemeColors.noColor,
  );
  static final almost = ActivityState(
    value: 2,
    iconData: Icons.show_chart_rounded,
    text: 'almost',
    color: ThemeColors.almostColor,
  );
  static final skip = ActivityState(
    value: 3,
    iconData: Icons.chevron_left_rounded,
    text: 'skip',
    color: ThemeColors.skipColor,
  );
  static final values = [yes, no, almost, skip];
}

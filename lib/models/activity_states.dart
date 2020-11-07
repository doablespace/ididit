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
        return activityStates[0];
      case DismissDirection.down:
        return activityStates[1];
      case DismissDirection.startToEnd:
        return activityStates[2];
      case DismissDirection.endToStart:
        return activityStates[3];
      default:
        throw ArgumentError.value(
            direction, 'direction', 'Invalid DismissDirection provided.');
    }
  }
}

final activityStates = [
  ActivityState(
    value: 0,
    iconData: Icons.check_rounded,
    text: 'yes',
    color: ThemeColors.pastelGreen,
  ),
  ActivityState(
    value: 1,
    iconData: Icons.close_rounded,
    text: 'no',
    color: ThemeColors.pastelRed,
  ),
  ActivityState(
    value: 2,
    iconData: Icons.show_chart_rounded,
    text: 'almost',
    color: ThemeColors.pastelYellow,
  ),
  ActivityState(
    value: 3,
    iconData: Icons.chevron_left_rounded,
    text: 'skip',
    color: ThemeColors.pastelGrey,
  ),
];

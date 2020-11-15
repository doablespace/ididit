import 'package:flutter/material.dart';
import 'package:ididit/ui/color_theme.dart';

class ActivityState {
  final int value;
  final IconData iconData;
  final String text;
  final Color color;
  final String swipeDirection;
  final IconData swipeIconData;

  const ActivityState({
    @required this.value,
    @required this.iconData,
    @required this.text,
    @required this.color,
    @required this.swipeDirection,
    @required this.swipeIconData,
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
    swipeDirection: 'up',
    swipeIconData: Icons.arrow_upward_rounded,
  );
  static final no = ActivityState(
    value: 1,
    iconData: Icons.close_rounded,
    text: 'no',
    color: ThemeColors.noColor,
    swipeDirection: 'down',
    swipeIconData: Icons.arrow_downward_rounded,
  );
  static final almost = ActivityState(
    value: 2,
    iconData: Icons.show_chart_rounded,
    text: 'almost',
    color: ThemeColors.almostColor,
    swipeDirection: 'right',
    swipeIconData: Icons.arrow_forward_ios_rounded,
  );
  static final skip = ActivityState(
    value: 3,
    iconData: Icons.chevron_left_rounded,
    text: 'skip',
    color: ThemeColors.skipColor,
    swipeDirection: 'left',
    swipeIconData: Icons.arrow_back_ios_rounded,
  );
  static final values = [yes, no, almost, skip];
}

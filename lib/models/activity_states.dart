import 'package:flutter/material.dart';

class ActivityState {
  final IconData iconData;
  final String text;

  const ActivityState({
    @required this.iconData,
    @required this.text,
  });
}

final activityStates = [
  const ActivityState(iconData: Icons.check_rounded, text: 'yes'),
  const ActivityState(iconData: Icons.close_rounded, text: 'no'),
  const ActivityState(iconData: Icons.show_chart_rounded, text: 'almost'),
  const ActivityState(iconData: Icons.chevron_left_rounded, text: 'skip'),
];

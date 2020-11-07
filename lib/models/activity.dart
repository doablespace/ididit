import 'package:flutter/material.dart';
import 'package:ididit/models/icon_names.dart';
import 'package:ididit/ui/color_theme.dart';

class Activity {
  int id;
  DateTime created;
  String name;
  int icon;
  int color;

  Activity({this.id, this.created, this.name, this.icon, this.color});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created.millisecondsSinceEpoch,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  String get iconAsset =>
      'assets/${iconNames[(icon ?? 0) % iconNames.length]}.svg';

  Map<String, Color> get colors =>
      ActivityColors.colors[(color ?? 0) % ActivityColors.colors.length];
  Color get accent => colors['accent'];
  Color get ink => colors['ink'];
}

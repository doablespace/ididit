import 'package:flutter/material.dart';
import 'package:ididit/models/activity_log_entry.dart';
import 'package:ididit/models/icon_names.dart';
import 'package:ididit/ui/color_theme.dart';

class Activity {
  int id;
  DateTime created;
  String name;
  int icon;
  int color;

  ActivityLogEntry logEntry;

  Activity({this.id, this.created, this.name, this.icon, this.color});

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      created: DateTime.fromMillisecondsSinceEpoch(map['created'], isUtc: true),
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created': created.toUtc().microsecondsSinceEpoch,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }

  String get iconAsset =>
      'assets/${iconNames[(icon ?? 0) % iconNames.length]}.svg';
  static String get selectIcon => 'assets/choose-icon.svg';
  static String indexIcon(id) =>
      'assets/${iconNames[(id ?? 0) % iconNames.length]}.svg';

  Map<String, Color> get colors =>
      ActivityColors.colors[(color ?? 0) % ActivityColors.colors.length];
  Color get accent => colors['accent'];
  Color get ink => colors['ink'];
}

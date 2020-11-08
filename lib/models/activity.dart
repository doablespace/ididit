import 'package:flutter/material.dart';
import 'package:ididit/models/activity_log_entry.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/ui/activity_icons.dart';
import 'package:ididit/ui/color_theme.dart';

class Activity extends ChangeNotifier {
  int id;
  DateTime created;
  String name;
  int icon;
  int color;

  ActivityLogEntry _logEntry;

  Activity({this.id, this.created, this.name, this.icon, this.color});

  factory Activity.fromMap(Map<String, dynamic> map) {
    return Activity(
      id: map['id'],
      created:
          DateTime.fromMillisecondsSinceEpoch(map['created'] ?? 0, isUtc: true),
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  factory Activity.tryParse(Map<String, String> map) {
    Map<String, dynamic> parsed = {};
    parsed['title'] = map['title'];
    parsed['created'] = int.tryParse(map['created'] ?? '');
    parsed['name'] = map['name'];
    parsed['icon'] = int.tryParse(map['icon'] ?? '');
    parsed['color'] = int.tryParse(map['color'] ?? '');
    return Activity.fromMap(parsed);
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

  IconData get iconAsset => indexIcon(icon);
  static String get selectIcon => 'assets/choose-icon.svg';
  static IconData indexIcon(id) =>
      ActivityIcons.values[(id ?? 0) % ActivityIcons.values.length];

  Map<String, Color> get colors =>
      ActivityColors.colors[(color ?? 0) % ActivityColors.colors.length];
  Color get accent => colors['accent'];
  Color get ink => colors['ink'];

  ActivityLogEntry get logEntry => _logEntry;
  set logEntry(ActivityLogEntry value) {
    _logEntry = value;
    notifyListeners();
  }

  ActivityState get state => logEntry?.state ?? ActivityState.skip;

  void saved() => notifyListeners();
}

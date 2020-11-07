import 'package:ididit/models/icon_names.dart';

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

  String get iconAsset => 'assets/${iconNames[icon % iconNames.length]}.svg';
  static String get selectIcon => 'assets/choose-icon.svg';
}

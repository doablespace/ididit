class Activity {
  int id;
  final DateTime created;
  final String name;
  final int icon;
  final int color;

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
}
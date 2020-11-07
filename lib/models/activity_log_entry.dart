class ActivityLogEntry {
  final int id;
  final int activityId;
  final int status;
  final DateTime targetTime;
  final DateTime modified;

  ActivityLogEntry(
      {this.id, this.activityId, this.status, this.targetTime, this.modified});

  factory ActivityLogEntry.fromMap(Map<String, dynamic> map) {
    return ActivityLogEntry(
      id: map['id'],
      activityId: map['activity_id'],
      status: map['status'],
      targetTime:
          DateTime.fromMicrosecondsSinceEpoch(map['target_time'], isUtc: true),
      modified:
          DateTime.fromMicrosecondsSinceEpoch(map['modified'], isUtc: true),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity_id': activityId,
      'status': status,
      'target_time': targetTime.toUtc().microsecondsSinceEpoch,
      'modified': modified.toUtc().microsecondsSinceEpoch,
    };
  }
}

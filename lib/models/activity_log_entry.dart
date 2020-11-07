class ActivityLogEntry {
  final int id;
  final int activityId;
  final ActivityStatus status;
  final DateTime targetTime;
  final DateTime modified;

  ActivityLogEntry(
      {this.id, this.activityId, this.status, this.targetTime, this.modified});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity_id': activityId,
      'status': status as int,
      'target_time': targetTime.microsecondsSinceEpoch,
      'modified': modified.microsecondsSinceEpoch,
    };
  }
}

enum ActivityStatus { Skipped, Yes, No, Almost }

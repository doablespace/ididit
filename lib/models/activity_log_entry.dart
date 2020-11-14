import 'package:flutter/material.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/date_time_helper.dart';

class ActivityLogEntry extends ChangeNotifier {
  int id;
  int activityId;
  int _status;
  DateTime targetTime;
  DateTime modified;

  ActivityLogEntry(
      {this.id, this.activityId, int status, this.targetTime, this.modified})
      : _status = status;

  factory ActivityLogEntry.fromMap(Map<String, dynamic> map) {
    return ActivityLogEntry(
      id: map['id'],
      activityId: map['activity_id'],
      status: map['status'],
      targetTime: DateTimeHelper.daysFromDatabase(map['target_time']),
      modified:
          DateTime.fromMicrosecondsSinceEpoch(map['modified'], isUtc: true),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'activity_id': activityId,
      'status': status,
      'target_time': DateTimeHelper.daysToDatabase(targetTime),
      'modified': modified.toUtc().microsecondsSinceEpoch,
    };
  }

  int get status => _status;
  set status(int value) {
    _status = value;
    notifyListeners();
  }

  ActivityState get state => status != null
      ? ActivityState.values[status % ActivityState.values.length]
      : null;
}

import 'dart:async';

import 'package:ididit/data/versions/versions.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_log_entry.dart';
import 'package:ididit/models/date_time_helper.dart';
import 'package:sqflite/sqflite.dart';

typedef void LoadingProgress(int loaded, int total);

class Db {
  final Future<Database> _database;

  Db()
      : _database = openDatabase('ididit.db',
            onUpgrade: _onUpgrade, version: versions.length);

  /// Runs initial database migrations.
  static FutureOr<void> _onUpgrade(
      Database db, int oldVersion, int newVersion) async {
    // Execute necessary migrations in order.
    for (var i = oldVersion; i < newVersion; i++) {
      await versions[i].execute(db);
    }
  }

  /// Inserts or updates an [Activity].
  Future<void> saveActivity(Activity activity) async {
    final Database db = await _database;
    activity.id = await db.insert('activities', activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// Finds activities and their corresponding [Activity.logEntry] for the
  /// specified [day].
  Future<List<Activity>> findActivities(DateTime day,
      {LoadingProgress progress}) async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('activities');
    final activities = List<Activity>.generate(
        maps.length, (index) => Activity.fromMap(maps[index]));
    await findActivityLogs(activities, day, progress: progress);
    return activities;
  }

  /// Fills [Activity.logEntry] for each of [activities] for the specified
  /// [day].
  Future<void> findActivityLogs(List<Activity> activities, DateTime day,
      {LoadingProgress progress}) async {
    var i = 0;
    for (final activity in activities) {
      final logs = await findActivityLog(activity.id, day);
      activity.logEntry = logs.isNotEmpty ? logs.last : null;
      activity.logHistory = logs.isNotEmpty ? logs : List.empty();
      progress?.call(i++, activities.length);
    }
  }

  Future<void> deleteActivity(int id) async {
    final Database db = await _database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteActivityLog(int id) async {
    final Database db = await _database;
    await db.delete('activity_log', where: 'id = ?', whereArgs: [id]);
  }

  /// Finds [ActivityLogEntry] of [Activity] with the specified [id] for the
  /// specified [day] along with extra 7 day history.
  Future<List<ActivityLogEntry>> findActivityLog(int id, DateTime day) async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('activity_log',
        where:
            'activity_id = ? and target_time <= ? and target_time >= ? order by target_time asc',
        whereArgs: [
          id,
          DateTimeHelper.daysToDatabase(day),
          DateTimeHelper.daysToDatabase(
            day.add(Duration(days: -8)),
          ), // 7 extra days.
        ]);
    return List.generate(
        maps.length, (index) => ActivityLogEntry.fromMap(maps[index]));
  }

  /// Adds or updates [ActivityLogEntry] of the specified [activity] for the
  /// specified [day] so that it has the specified [status].
  Future<void> markActivity(Activity activity, DateTime day, int status) async {
    final Database db = await _database;
    if (activity.logEntry != null &&
        DateTimeHelper.areSameDay(activity.logEntry.targetTime, day)) {
      activity.logEntry.status = status;
      await db.update('activity_log', activity.logEntry.toMap(),
          where: 'id = ?', whereArgs: [activity.logEntry.id]);
    } else {
      activity.logEntry = ActivityLogEntry(
        activityId: activity.id,
        status: status,
        targetTime: day,
        modified: DateTime.now().toUtc(),
      );
      activity.logEntry.id =
          await db.insert('activity_log', activity.logEntry.toMap());
    }
  }
}

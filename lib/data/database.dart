import 'dart:async';

import 'package:ididit/data/versions/versions.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_log_entry.dart';
import 'package:ididit/models/date_time_helper.dart';
import 'package:sqflite/sqflite.dart';

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
  Future<List<Activity>> findActivities(DateTime day) async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('activities');
    final result = List<Activity>(maps.length);
    for (var i = 0; i < result.length; i++) {
      final activity = Activity.fromMap(maps[i]);
      final logs = await findActivityLog(activity.id, day);
      activity.logEntry = logs.isNotEmpty ? logs.last : null;
      result[i] = activity;
    }
    return result;
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
  /// specified [day].
  Future<List<ActivityLogEntry>> findActivityLog(int id, DateTime day) async {
    final Database db = await _database;
    final List<Map<String, dynamic>> maps = await db.query('activity_log',
        where: 'activity_id = ? and target_time = ?',
        whereArgs: [id, DateTimeHelper.daysToDatabase(day)]);
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

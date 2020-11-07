import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ididit/data/day_splitter.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_log_entry.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  final Future<Database> database;

  Db() : database = openDatabase('ididit.db', onCreate: _onCreate, version: 1);

  /// Runs initial database migrations.
  static FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created INTEGER,
        name TEXT,
        icon INTEGER,
        color INTEGER
      );
      CREATE TABLE activity_log(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_id INTEGER,
        status INTEGER,
        target_time INTEGER,
        modified INTEGER,
        FOREIGN KEY(activity_id) REFERENCES activities(id)
      );
      ''');
  }

  /// Inserts or updates an [Activity].
  Future<void> saveActivity(Activity activity) async {
    final Database db = await database;
    activity.id = await db.insert('activities', activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Activity>> findActivities(DateTime time) async {
    final Database db = await database;
    final range = daySplitter.getRange(time);
    final List<Map<String, dynamic>> maps = await db.query('activities');
    final result = List<Activity>(maps.length);
    for (var i = 0; i < result.length; i++) {
      final activity = Activity.fromMap(maps[i]);
      final logs = await findActivityLog(activity.id, range);
      activity.logEntry = logs.isNotEmpty ? logs[0] : null;
      result[i] = activity;
    }
    return List.generate(maps.length, (index) => Activity.fromMap(maps[index]));
  }

  Future<void> deleteActivity(int id) async {
    final Database db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<ActivityLogEntry>> findActivityLog(
      int id, DateTimeRange range) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('activity_log',
        where: 'activity_id = ? and target_time >= ? and target_time < ?',
        whereArgs: [
          id,
          range.start.microsecondsSinceEpoch,
          range.end.microsecondsSinceEpoch
        ]);
    return List.generate(
        maps.length, (index) => ActivityLogEntry.fromMap(maps[index]));
  }

  Future<int> findActivityStatus(int id, DateTime time) async {
    final log = await findActivityLog(id, daySplitter.getRange(time));
    if (log.isNotEmpty) return log[0].status;
    return null;
  }

  Future<void> markActivity(int id, DateTime time, int status) async {
    final Database db = await database;

    final range = daySplitter.getRange(time);
    final log = await findActivityLog(id, range);
    if (log.isNotEmpty) {
      await db.update('activity_log', log[0].toMap(),
          where: 'activity_id = ? and target_time >= ? and target_time < ?',
          whereArgs: [
            id,
            range.start.microsecondsSinceEpoch,
            range.end.microsecondsSinceEpoch
          ]);
    } else {
      await db.insert(
          'activity_log',
          ActivityLogEntry(
            activityId: id,
            status: status,
            targetTime: time,
            modified: time,
          ).toMap());
    }
  }
}

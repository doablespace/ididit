import 'dart:async';

import 'package:ididit/models/activity.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  final Future<Database> database;

  Db() : database = openDatabase('ididit.db', onCreate: _onCreate);

  /// Runs initial database migrations.
  static FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities(
        id INT PRIMARY KEY,
        created INT,
        name TEXT,
        icon INT,
        color INT,
      );
      CREATE TABLE activity_log(
        id INT PRIMARY KEY,
        activity_id INT,
        status INT,
        target_time INT,
        modified INT,
        FOREIGN KEY(activity_id) REFERENCES activities(id),
      );
      ''');
  }

  /// Inserts or updates an [Activity].
  Future<void> saveActivity(Activity activity) async {
    final Database db = await database;
    await db.insert('activities', activity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

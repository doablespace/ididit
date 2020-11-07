import 'dart:async';

import 'package:ididit/models/activity.dart';
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

  Future<List<Activity>> get activities async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('activities');
    return List.generate(maps.length, (index) {
      final map = maps[index];
      return Activity(
        id: map['id'],
        created: DateTime.fromMillisecondsSinceEpoch(map['created']),
        name: map['name'],
        icon: map['icon'],
        color: map['color'],
      );
    });
  }

  Future<void> deleteActivity(int id) async {
    final Database db = await database;
    await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }
}

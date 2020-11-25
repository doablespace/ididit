import 'package:ididit/data/open_moji_database.dart';
import 'package:ididit/data/versions/versions.dart';
import 'package:sqflite/sqflite.dart';

class Version1 extends Version {
  const Version1();

  @override
  Future<void> execute(DatabaseExecutor db, OpenMojiDatabase openMojis) async {
    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created INTEGER,
        name TEXT,
        icon INTEGER,
        color INTEGER
      );
      ''');
    await db.execute('''
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
}

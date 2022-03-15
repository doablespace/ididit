import 'package:ididit/data/versions/versions.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Version3Order extends Version {
  const Version3Order();

  @override
  Future<void> execute(DatabaseExecutor db) async {
    await db.execute('''
      ALTER TABLE activities
        ADD COLUMN custom_order INTEGER;

      WITH a AS (
        SELECT ROW_NUMBER() OVER(ORDER BY created) AS c, id 
        FROM activities
      )
      UPDATE activities SET custom_order = a.c
      FROM a WHERE activities.id = a.id;
    ''');
  }
}

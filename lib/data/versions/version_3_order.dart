import 'package:ididit/data/versions/versions.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Version3Order extends Version {
  const Version3Order();

  @override
  Future<void> execute(DatabaseExecutor db) async {
    await db.execute('''
      ALTER TABLE activities
        ADD COLUMN custom_order INTEGER;
    ''');
    await db.execute('UPDATE activities SET custom_order = id;');
  }
}

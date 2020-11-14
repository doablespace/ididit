import 'package:ididit/data/versions/versions.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Version2OnlyDays extends Version {
  const Version2OnlyDays();

  @override
  Future<void> execute(DatabaseExecutor db) async {
    for (final activity in await db
        .query('activity_log', columns: ['id', 'target_time', 'modified'])) {
      // Parse `target_time` microseconds since epoch to `DateTime`.
      var targetTime =
          DateTime.fromMicrosecondsSinceEpoch(activity['target_time']);

      // Day threshold (4 o'clock).
      final threshold =
          DateTime(targetTime.year, targetTime.month, targetTime.day, 4);

      // If `target_time` is before threshold, the `day` is actually one less.
      if (targetTime.isBefore(threshold))
        targetTime = targetTime.subtract(Duration(days: 1));
      targetTime = targetTime.toUtc();

      // Convert to days since epoch.
      final epoch = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
      final days = targetTime.difference(epoch).inDays;

      // Convert `modified` to be relative to `target_time`.
      final modified =
          DateTime.fromMicrosecondsSinceEpoch(activity['modified']);
      final modifiedRelative = targetTime.difference(modified);

      await db.execute('''
        UPDATE activity_log SET target_time = $days, 
          modified = ${modifiedRelative.inMicroseconds}
        WHERE id = ${activity['id']};
      ''');
    }
  }
}

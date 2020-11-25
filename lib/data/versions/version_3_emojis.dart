import 'package:ididit/data/open_moji_database.dart';
import 'package:ididit/data/versions/versions.dart';
import 'package:sqflite_common/sqlite_api.dart';

class Version3Emojis extends Version {
  const Version3Emojis();

  @override
  Future<void> execute(DatabaseExecutor db, OpenMojiDatabase openMojis) async {
    // Add column `emoji` to activities.
    await db.execute('ALTER TABLE activities ADD COLUMN emoji TEXT;');

    // Convert activity name to emoji representation.
    for (final activity
        in await db.query('activities', columns: ['id', 'name'])) {
      final name = activity['name'];
      final emojis = await openMojis.textToEmoji(name);
      final emojiText = emojis.map((openMoji) => openMoji.emoji).join();

      await db.execute('UPDATE activities SET emoji = ? WHERE id = ?',
          [emojiText, activity['id']]);
    }
  }
}

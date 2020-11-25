import 'package:ididit/data/open_moji_database.dart';
import 'package:ididit/data/versions/version_1.dart';
import 'package:ididit/data/versions/version_2_only_days.dart';
import 'package:ididit/data/versions/version_3_emojis.dart';
import 'package:sqflite/sqflite.dart';

abstract class Version {
  const Version();

  Future<void> execute(DatabaseExecutor db, OpenMojiDatabase openMojiDatabase);
}

final versions = [
  const Version1(),
  const Version2OnlyDays(),
  const Version3Emojis(),
];

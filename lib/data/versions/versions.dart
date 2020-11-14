import 'package:ididit/data/versions/version_1.dart';
import 'package:sqflite/sqflite.dart';

abstract class Version {
  const Version();

  Future<void> execute(Database db);
}

final versions = [const Version1()];

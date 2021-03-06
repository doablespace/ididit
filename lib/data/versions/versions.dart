import 'package:ididit/data/versions/version_1.dart';
import 'package:ididit/data/versions/version_2_only_days.dart';
import 'package:ididit/data/versions/version_3_order.dart';
import 'package:sqflite/sqflite.dart';

abstract class Version {
  const Version();

  Future<void> execute(DatabaseExecutor db);
}

final versions = [
  const Version1(),
  const Version2OnlyDays(),
  const Version3Order(),
];

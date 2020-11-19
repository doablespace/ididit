import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:ididit/models/open_moji.dart';

class OpenMojiDatabase {
  final List<OpenMoji> _list;

  OpenMojiDatabase._(List<OpenMoji> list) : _list = list;

  static Future<OpenMojiDatabase> load(AssetBundle assets, String file) async {
    final list = await assets.loadStructuredData(file, (value) async {
      final rows = CsvToListConverter(
        csvSettingsDetector: FirstOccurrenceSettingsDetector(
          eols: ['\r\n', '\n'],
        ),
      ).convert(value);
      return rows.skip(1).map((row) => OpenMoji.fromRow(row)).toList();
    });
    return OpenMojiDatabase._(list);
  }
}

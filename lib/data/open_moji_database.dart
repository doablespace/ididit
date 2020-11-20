import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:ididit/extensions.dart';
import 'package:ididit/models/open_moji.dart';

class OpenMojiDatabase {
  final Map<String, OpenMoji> map;
  final List<OpenMoji> list;

  OpenMojiDatabase._(this.map, this.list);

  static Future<OpenMojiDatabase> load(AssetBundle assets, String file) {
    return assets.loadStructuredData(file, (value) async {
      final rows = CsvToListConverter(
        csvSettingsDetector: FirstOccurrenceSettingsDetector(
          eols: ['\r\n', '\n'],
        ),
        shouldParseNumbers: false,
      ).convert(value);
      final openMojis = rows
          .skip(1)
          .mapIndexed((index, row) => OpenMoji.fromRow(row, order: index + 1));
      final map = Map<String, OpenMoji>.fromIterable(openMojis,
          key: (openMoji) => openMoji.emoji);
      return OpenMojiDatabase._(map, openMojis.toList());
    });
  }
}

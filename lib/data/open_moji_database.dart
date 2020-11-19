import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:ididit/models/open_moji.dart';

class OpenMojiDatabase {
  final Map<String, OpenMoji> map;
  final List<OpenMoji> list;
  final Fuzzy<OpenMoji> fuse;

  OpenMojiDatabase._(this.map, this.list)
      : fuse = Fuzzy(
          list,
          options: FuzzyOptions(
            shouldNormalize: true,
            keys: [
              WeightedKey(
                weight: 1,
                name: 'annotation',
                getter: (openmoji) => openmoji.annotation,
              ),
              WeightedKey(
                  weight: 0.9,
                  name: 'tags',
                  getter: (openmoji) => openmoji.getAllTags(map).join(' ')),
              WeightedKey(
                weight: 0.8,
                name: 'group',
                getter: (openmoji) => openmoji.group,
              ),
              WeightedKey(
                weight: 0.7,
                name: 'subgroup',
                getter: (openmoji) => openmoji.subgroup,
              ),
              WeightedKey(
                weight: 0.6,
                name: 'emoji',
                getter: (openmoji) => openmoji.emoji,
              ),
              WeightedKey(
                weight: 0.1,
                name: 'hexcode',
                getter: (openmoji) => openmoji.hexcode,
              ),
            ],
          ),
        );

  static Future<OpenMojiDatabase> load(AssetBundle assets, String file) {
    return assets.loadStructuredData(file, (value) async {
      final rows = CsvToListConverter(
        csvSettingsDetector: FirstOccurrenceSettingsDetector(
          eols: ['\r\n', '\n'],
        ),
        shouldParseNumbers: false,
      ).convert(value);
      final openMojis = rows.skip(1).map((row) => OpenMoji.fromRow(row));
      final map = Map<String, OpenMoji>.fromIterable(openMojis,
          key: (openMoji) => openMoji.emoji);
      return OpenMojiDatabase._(map, openMojis.toList());
    });
  }
}

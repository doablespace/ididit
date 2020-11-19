import 'package:flutter/material.dart';

class OpenMoji {
  final String emoji;
  final String hexcode;
  final String group;
  final String subgroup;
  final String annotation;
  final List<String> tags;

  OpenMoji({
    @required this.emoji,
    @required this.hexcode,
    @required this.group,
    @required this.subgroup,
    @required this.annotation,
    @required this.tags,
  });

  factory OpenMoji.fromRow(List<dynamic> row) {
    return OpenMoji(
      emoji: row[0],
      hexcode: row[1],
      group: row[2],
      subgroup: row[3],
      annotation: row[4],
      tags: _parseTags(row[5]).followedBy(_parseTags(row[6])).toList(),
    );
  }

  static Iterable<String> _parseTags(dynamic cell) {
    return (cell as String).split(', ');
  }

  @override
  String toString() => '$emoji $annotation';

  String get assetName => 'assets/openmoji/$hexcode.svg';
}

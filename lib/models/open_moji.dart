import 'package:flutter/material.dart';

class OpenMoji {
  final String emoji;
  final String hexcode;
  final String group;
  final String subgroup;
  final String annotation;
  final List<String> tags;
  final String skintoneBaseEmoji;

  OpenMoji({
    @required this.emoji,
    @required this.hexcode,
    @required this.group,
    @required this.subgroup,
    @required this.annotation,
    @required this.tags,
    this.skintoneBaseEmoji,
  });

  factory OpenMoji.fromRow(List<dynamic> row) {
    return OpenMoji(
      emoji: row[0],
      hexcode: row[1],
      group: row[2],
      subgroup: row[3],
      annotation: row[4],
      tags: _parseTags(row[5]).followedBy(_parseTags(row[6])).toSet().toList(),
      skintoneBaseEmoji: row[11],
    );
  }

  static Iterable<String> _parseTags(dynamic cell) {
    return (cell as String)
        .split(', ')
        .where((part) => part != null && part.length > 0);
  }

  @override
  String toString() => '$emoji $annotation';

  String get assetName => 'assets/openmoji/$hexcode.svg';

  /// Determines whether this [OpenMoji] has [skintoneBaseEmoji] *different*
  /// from itself.
  bool get hasSkintoneBaseEmoji =>
      skintoneBaseEmoji != null &&
      skintoneBaseEmoji.length > 0 &&
      emoji != skintoneBaseEmoji;

  Iterable<String> getAllTags(Map<String, OpenMoji> map) {
    if (hasSkintoneBaseEmoji) {
      final baseTags = map[skintoneBaseEmoji].tags;
      return tags.followedBy(baseTags);
    }
    return tags;
  }
}

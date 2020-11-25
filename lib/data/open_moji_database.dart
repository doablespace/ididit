import 'package:csv/csv.dart';
import 'package:csv/csv_settings_autodetection.dart';
import 'package:edit_distance/edit_distance.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:full_text_search/full_text_search.dart';
import 'package:full_text_search/term_search_result.dart';
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

  OpenMojiSearch search(String query) => OpenMojiSearch(this, query);

  Future<List<OpenMoji>> textToEmoji(String text) async {
    // Split text into words.
    final words = text
        .split(_tokenizer)
        .where((t) => t != null && t.isNotEmpty)
        .mapIndexed((i, t) => _Word(i, t))
        .toList();

    // Find longest words.
    words.sort((x, y) => y.value.length.compareTo(x.value.length));

    // Find three emojis for longest words.
    var resultCount = 0;
    for (final word in words) {
      final fts = search(word.value).fts;
      final results = await fts.execute();
      if (results.isEmpty) continue;
      word.openMoji = results.first.result;

      if (++resultCount == 3) break;
    }

    // Reorder according to original order.
    final results = words.where((w) => w.openMoji != null).toList();
    results.sort((x, y) => x.originalIndex.compareTo(y.originalIndex));

    return results.map((w) => w.openMoji).toList();
  }
}

class _Word {
  final int originalIndex;
  final String value;
  OpenMoji openMoji;

  _Word(this.originalIndex, this.value);
}

final _tokenizer = RegExp("[\\s\-\.:]");

class OpenMojiSearch {
  final FullTextSearch<OpenMoji> fts;

  OpenMojiSearch(OpenMojiDatabase db, String query)
      : fts = FullTextSearch<OpenMoji>.scoring(
          term: query,
          items: Stream.fromIterable(db.list),
          tokenize: (openMoji) {
            final annotationTokens = openMoji.annotation
                .split(_tokenizer)
                .where((t) => t != null && t.isNotEmpty);
            return [
              ...annotationTokens,
              ...openMoji.getAllTags(db.map),
              openMoji.emoji
            ];
          },
          scorers: [
            MatchAllTermsScoring(),
            MatchedTokensScoring(),
            MatchedTermsScoring(),
            _SimilarityScoring(),
            _EqualityBoostScoring(),
          ],
          matchers: [
            EqualsMatch(),
            StartsWithMatch(),
            _SimilarMatch(),
          ],
        );
}

class _SimilarMatch with TermMatcherMixin {
  @override
  List<TermMatch> apply<T>(FullTextSearch<T> search, TokenizedItem<T> item,
      String term, Token token) {
    if (term.length < 4 || token.token.length < 4) return const [];
    term = term.toLowerCase();
    final distance = Levenshtein().distance(term, token.token);
    return [
      if (distance > 0 && distance < 3)
        _SimilarTermMatch(term, token, 1 - (distance - 1) / 2),
    ];
  }

  @override
  String get key => matchKey;
  static const matchKey = 'similar';
}

class _SimilarTermMatch extends Equatable implements TermMatch {
  @override
  final Token matchedToken;

  @override
  final String term;

  final double similarity;

  _SimilarTermMatch(this.term, this.matchedToken, this.similarity);

  @override
  String get key => _SimilarMatch.matchKey;

  @override
  List<Object> get props => [key, matchedToken, term];
}

class _SimilarityScoring extends SearchScoring {
  final String debugLabel;

  _SimilarityScoring([this.debugLabel = "tokenSimilar"]);

  @override
  void scoreTerm(FullTextSearch search, TermSearchResult term, Score current) {
    for (final t in term.matchedTokens) {
      switch (t.key) {
        case _SimilarMatch.matchKey:
          current += Boost.amount(
            (t as _SimilarTermMatch).similarity,
            debugLabel,
          );
          break;
      }
    }
  }
}

/// Applies boost to long tokens matched exactly (boost is linear in the length
/// of the token).
class _EqualityBoostScoring extends SearchScoring {
  void scoreTerm(FullTextSearch search, TermSearchResult term, Score current) {
    for (final t in term.matchedTokens) {
      if (t.key == EqualsMatch.matchKey && t.matchedToken.token.length > 3)
        current += Boost.amount(t.term.length.toDouble(), "tokenEqualsBoost");
    }
  }
}

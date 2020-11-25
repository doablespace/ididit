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
            return [...annotationTokens, ...openMoji.getAllTags(db.map)];
          },
          scorers: [
            MatchAllTermsScoring(),
            MatchedTokensScoring(),
            MatchedTermsScoring(),
            _SimilarityScoring(),
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
    // final similarity = StringSimilarity.compareTwoStrings(term, token.token);
    // return [
    //   if (similarity > 0.5) _SimilarTermMatch(term, token, similarity),
    // ];
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

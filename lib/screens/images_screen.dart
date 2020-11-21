import 'package:edit_distance/edit_distance.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_text_search/full_text_search.dart';
import 'package:full_text_search/term_search_result.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/open_moji.dart';
import 'package:provider/provider.dart';
import 'package:string_similarity/string_similarity.dart';

class ImagesScreen extends StatefulWidget {
  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final queryController = TextEditingController();
  final scrollController = ScrollController();

  String previousQuery = '';

  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: queryController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear_rounded),
            onPressed: () {
              queryController.text = '';
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: queryController,
        builder: (context, child) {
          final map = activitiesBloc.openMojis.map;

          // Search OpenMojis.
          final query = (queryController.text ?? '').trim();
          final fts = FullTextSearch<OpenMoji>.scoring(
            term: query,
            items: Stream.fromIterable(map.values),
            tokenize: (openMoji) {
              return [openMoji.annotation, ...openMoji.getAllTags(map)];
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

          // Scroll to beginning when query changes.
          if (scrollController.hasClients && previousQuery != query)
            scrollController.jumpTo(0);
          previousQuery = query;

          return FutureBuilder<List<TermSearchResult<OpenMoji>>>(
            future: fts.execute(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();

              final results = snapshot.data;

              return GridView.builder(
                controller: scrollController,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 80,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final result = results[index];
                  final openMoji = result.result;
                  return InkWell(
                    child: SvgPicture.asset(openMoji.assetName),
                    onTap: () {
                      Scaffold.of(context).hideCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${openMoji.group} > ${openMoji.subgroup} > ' +
                                '${openMoji.annotation} ' +
                                '[${openMoji.getAllTags(map).join('] [')}]' +
                                (openMoji.hasSkintoneBaseEmoji
                                    ? ' (${openMoji.skintoneBaseEmoji})'
                                    : ''),
                          ),
                        ),
                      );

                      print(result);
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
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
  @override
  void scoreTerm(FullTextSearch search, TermSearchResult term, Score current) {
    for (final t in term.matchedTokens) {
      switch (t.key) {
        case _SimilarMatch.matchKey:
          current += Boost.amount(
            (t as _SimilarTermMatch).similarity,
            "tokenSimilar",
          );
          break;
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_text_search/full_text_search.dart';
import 'package:full_text_search/term_search_result.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/open_moji.dart';
import 'package:provider/provider.dart';

class ImagesScreen extends StatefulWidget {
  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final queryController = TextEditingController();
  final scrollController = ScrollController();

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
          final fts = FullTextSearch<OpenMoji>(
            term: query,
            items: map.values,
            tokenize: (openMoji) {
              return [openMoji.annotation, ...openMoji.getAllTags(map)];
            },
          );

          // Scroll to beginning when query changes.
          if (scrollController.hasClients) scrollController.jumpTo(0);

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

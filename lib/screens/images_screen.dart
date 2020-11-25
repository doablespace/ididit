import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:full_text_search/term_search_result.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/open_moji.dart';
import 'package:provider/provider.dart';

class ImagesScreen extends StatefulWidget {
  final String initialQuery;

  const ImagesScreen({Key key, this.initialQuery}) : super(key: key);

  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final queryController = TextEditingController();
  final scrollController = ScrollController();

  String previousQuery = '';

  @override
  void initState() {
    super.initState();

    queryController.text = previousQuery = widget.initialQuery;
  }

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
          final fts = activitiesBloc.openMojis.search(query).fts;

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
                      print('Emoji: ${openMoji.group} > ' +
                          '${openMoji.subgroup} > ' +
                          '${openMoji.annotation} ' +
                          '[${openMoji.getAllTags(map).join('] [')}]' +
                          (openMoji.hasSkintoneBaseEmoji
                              ? ' (${openMoji.skintoneBaseEmoji})'
                              : ''));
                      print('Tokens: ${fts.tokenize(openMoji)}');
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

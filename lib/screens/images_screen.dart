import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ididit/bloc/activities_bloc.dart';
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
          final result =
              activitiesBloc.openMojis.fuse.search(queryController.text ?? '');

          // HACK: Workaround https://github.com/comigor/fuzzy/issues/8.
          result.forEach(
              (r) => r.score = r.matches.isEmpty ? 1 : r.matches.first.score);
          result.sort((a, b) => a.score.compareTo(b.score));

          // Scroll to beginning when query changes.
          if (scrollController.hasClients) scrollController.jumpTo(0);

          return GridView.builder(
            controller: scrollController,
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 80,
            ),
            itemCount: result.length,
            itemBuilder: (context, index) {
              final openMoji = result[index].item;
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
                },
              );
            },
          );
        },
      ),
    );
  }
}

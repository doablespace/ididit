import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:provider/provider.dart';

class _ImageSearch extends ChangeNotifier {
  String _query;

  String get query => _query;
  set query(String value) {
    _query = value;
    notifyListeners();
  }
}

class ImagesScreen extends StatefulWidget {
  @override
  _ImagesScreenState createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  final search = _ImageSearch();
  final scrollController = ScrollController();

  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            search.query = value;
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: search,
        builder: (context, child) {
          // Search OpenMojis.
          final result =
              activitiesBloc.openMojis.fuse.search(search.query ?? '');

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
                            '[${openMoji.tags.join('] [')}]',
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

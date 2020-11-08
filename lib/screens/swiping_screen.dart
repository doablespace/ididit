import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_list.dart';
import 'package:ididit/widgets/current_activity.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';
import 'package:ididit/widgets/help_overlay.dart';
import 'package:ididit/widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class SwipingScreen extends StatelessWidget {
  // Link between main activity position and overlayed help.
  final LayerLink _helpLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return SafeArea(
      child: StreamBuilder<bool>(
        stream: activitiesBloc.youDidItStream,
        initialData: activitiesBloc.youDidIt,
        builder: (context, snapshot) {
          final youDidIt = snapshot.data ?? false;

          return Container(
            decoration: BackgroundDecoration(3.0, youDidIt ? 0.57 : 0.45),
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
                elevation: 0, // For actual transparency.
                actions: [
                  if (!youDidIt)
                    IconButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                      icon: Icon(
                        Icons.help_center_rounded,
                        color: ThemeColors.lowerBackground,
                      ),
                      tooltip: 'Show help',
                      onPressed: () {
                        Navigator.of(context).push(NavigationHelp(_helpLink));
                      },
                    ),
                ],
              ),
              backgroundColor: Colors.transparent,
              body: youDidIt
                  ? null
                  : Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(32, 16, 72, 16),
                            // Needed for normal text style in child.
                            child: Material(
                              type: MaterialType.transparency,
                              child: ProgressBars(youDidIt: youDidIt),
                            ),
                          ),
                          Expanded(
                            child: CompositedTransformTarget(
                              link: _helpLink,
                              child: CurrentActivity(),
                            ),
                          ),
                        ],
                      ),
                    ),
              bottomNavigationBar: ActivityList(),
            ),
          );
        },
      ),
    );
  }
}

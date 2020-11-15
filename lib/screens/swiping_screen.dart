import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/screens/onboarding_screen.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_list.dart';
import 'package:ididit/widgets/current_activity.dart';
import 'package:ididit/widgets/day_selector.dart';
import 'package:ididit/widgets/help_overlay.dart';
import 'package:ididit/widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class SwipingScreen extends StatelessWidget {
  // Link between main activity position and overlayed help.
  final LayerLink _helpLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    _onboard(context);
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return StreamBuilder<bool>(
      stream: activitiesBloc.youDidItStream,
      initialData: activitiesBloc.youDidIt,
      builder: (context, snapshot) {
        final youDidIt = snapshot.data ?? false;

        return Container(
          decoration: BackgroundDecoration(3.0, youDidIt ? 0.57 : 0.45),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                if (!youDidIt)
                  IconButton(
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
              title: DaySelector(),
            ),
            backgroundColor: Colors.transparent,
            body: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.fromLTRB(32, 16, youDidIt ? 32 : 72, 16),
                    // Needed for normal text style in child.
                    child: Material(
                      type: MaterialType.transparency,
                      child: ProgressBars(youDidIt: youDidIt),
                    ),
                  ),
                  youDidIt
                      ? Text('') // TODO: Improve. Cannot have empty widget.
                      : Expanded(
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
    );
  }

  void _onboard(BuildContext context) async {
    await Hive.initFlutter('ididit');
    if (!await Hive.boxExists('first_run'))
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => OnboardingScreen()));
  }
}

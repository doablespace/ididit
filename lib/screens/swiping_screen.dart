import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/screens/onboarding_screen.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_list.dart';
import 'package:ididit/widgets/current_activity/current_activity.dart';
import 'package:ididit/widgets/day_selector.dart';
import 'package:ididit/widgets/help_overlay.dart';
import 'package:ididit/widgets/progress_bars.dart';
import 'package:provider/provider.dart';

class SwipingScreen extends StatelessWidget {
  // Links to synchronize the overlay help.
  final LayerLink _boxLink = LayerLink();

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
          decoration: BackgroundDecoration(3.0, youDidIt ? 0.57 : 0.48),
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                if (!youDidIt)
                  IconButton(
                    icon: Icon(Icons.help_center_rounded),
                    tooltip: 'Show help',
                    onPressed: () {
                      Navigator.of(context).push(NavigationHelp(_boxLink));
                    },
                  ),
              ],
              title: DaySelector(),

              // Loading progress bar
              flexibleSpace: Align(
                alignment: Alignment.bottomCenter,
                child: StreamBuilder(
                  stream: activitiesBloc.loadingStream,
                  initialData: activitiesBloc.loading,
                  builder: (context, snapshot) {
                    return LinearProgressIndicator(
                      value: snapshot.data,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(ThemeColors.inkColor),
                    );
                  },
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(32, 16, 52, 16),
                    // Needed for normal text style in child.
                    child: Material(
                      type: MaterialType.transparency,
                      child: ProgressBars(youDidIt: youDidIt),
                    ),
                  ),
                  if (!youDidIt) CurrentActivity(boxLink: _boxLink),
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

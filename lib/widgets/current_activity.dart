import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:ididit/screens/edit_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';
import 'package:ididit/widgets/options_activity_box.dart';
import 'package:provider/provider.dart';

final activityTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: ThemeColors.upperBackground,
);

class CurrentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return StreamBuilder<ActivitiesState>(
      stream: activitiesBloc.stateStream,
      initialData: activitiesBloc.state,
      builder: (context, snapshot) {
        final state = snapshot.data;

        // Show "loading" placeholder.
        if (state == ActivitiesState.loading)
          return _ActivityColumn(
            box: ActivityBox(color: ActivityColors.accentGreen),
            text: Text('Loading...', style: activityTextStyle),
          );

        // Show "no activities" placeholder.
        if (state == ActivitiesState.no_activities)
          return _ActivityColumn(
            box: ClickableActivityBox(
              color: ActivityColors.accentGreen,
              child: Center(child: Icon(Icons.flaky_rounded, size: 180)),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => EditScreen()));
              },
            ),
            text: Text('No activities', style: activityTextStyle),
          );

        /// Handles swipes.
        Future<bool> confirmDismiss(DismissDirection direction) {
          final activity = activitiesBloc.currentActivity;
          final targetState = ActivityState.fromDirection(direction);
          activitiesBloc.swipe(activity, targetState);
          return Future.value(false);
        }

        // Show current activity.
        return _ActivityColumn(
          box: Dismissible(
            key: UniqueKey(),
            child: Dismissible(
              key: UniqueKey(),
              child: StreamBuilder<Activity>(
                stream: activitiesBloc.currentActivityStream,
                initialData: activitiesBloc.currentActivity,
                builder: (context, snapshot) {
                  final activity = snapshot.data;
                  if (activity == null) return Container();
                  return OptionsActivityBox(activity: activity);
                },
              ),
              background: ActivityBox(color: ThemeColors.almostColor),
              secondaryBackground: ActivityBox(color: ThemeColors.skipColor),
              confirmDismiss: confirmDismiss,
            ),
            direction: DismissDirection.vertical,
            background: ActivityBox(color: ThemeColors.noColor),
            secondaryBackground: ActivityBox(color: ThemeColors.yesColor),
            confirmDismiss: confirmDismiss,
          ),
          text: StreamBuilder<Activity>(
            stream: activitiesBloc.currentActivityStream,
            initialData: activitiesBloc.currentActivity,
            builder: (context, snapshot) {
              final activity = snapshot.data;
              if (activity == null) return Container();
              return ModelProvider<Activity>(
                value: activity,
                builder: (context, _, child) {
                  return Text(
                    """${activity.name}""", // Multiline hack.
                    style: activityTextStyle,
                    textAlign: TextAlign.center,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ActivityColumn extends StatelessWidget {
  final Widget box;
  final Widget text;

  const _ActivityColumn({Key key, this.box, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        box,
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          child: text,
        ),
      ],
    );
  }
}

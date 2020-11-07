import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:provider/provider.dart';

import 'activity_box.dart';

final activityTextStyle = TextStyle(
  fontSize: 36,
  fontWeight: FontWeight.w600,
  color: ThemeColors.lightGrey,
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
            box: ActivityBox(
              color: ActivityColors.accentGreen,
              child: Center(child: Icon(Icons.flaky_rounded, size: 180)),
            ),
            text: Text('No activities', style: activityTextStyle),
          );

        /// Handles swipes.
        Future<bool> confirmDismiss(DismissDirection direction) {
          final activity = activitiesBloc.currentActivity;
          final hadState = activity.logEntry != null;

          // Mark the activity in the database unless user chose "skip".
          if (direction != DismissDirection.endToStart) {
            final targetState = ActivityState.fromDirection(direction);
            activitiesBloc.setState(activity, targetState);
          }

          // Go to next activity only if in "normal flow" (i.e., not if user selected
          // some already-marked activity). Or always if "skip" was chosen.
          if (!hadState || direction == DismissDirection.endToStart)
            activitiesBloc.selectNext();

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
                  return StatefulActivityBox(activity: activity);
                },
              ),
              background: ActivityBox(color: ThemeColors.pastelYellow),
              secondaryBackground: ActivityBox(color: ThemeColors.pastelGrey),
              confirmDismiss: confirmDismiss,
            ),
            direction: DismissDirection.vertical,
            background: ActivityBox(color: ThemeColors.pastelRed),
            secondaryBackground: ActivityBox(color: ThemeColors.pastelGreen),
            confirmDismiss: confirmDismiss,
          ),
          text: StreamBuilder<Activity>(
            stream: activitiesBloc.currentActivityStream,
            initialData: activitiesBloc.currentActivity,
            builder: (context, snapshot) {
              final activity = snapshot.data;
              return ModelProvider<Activity>(
                value: activity,
                builder: (context, _, child) {
                  return Text(activity.name, style: activityTextStyle);
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
      children: [
        box,
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 18,
          ),
          child: text,
        ),
      ],
    );
  }
}

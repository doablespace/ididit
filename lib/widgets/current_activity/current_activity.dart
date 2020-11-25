import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';
import 'package:ididit/widgets/current_activity/options_activity_box.dart';
import 'package:provider/provider.dart';

import '../edit_screen/edit_form.dart';
import 'direction_help.dart';

final activityTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: ThemeColors.upperBackground,
);

const double activityBoxSize = 280;

class CurrentActivity extends StatelessWidget {
  final LayerLink boxLink;

  const CurrentActivity({Key key, this.boxLink}) : super(key: key);

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
            box: SizedBox(width: activityBoxSize, height: activityBoxSize),
            text: Text('Loading...', style: activityTextStyle),
          );

        // Show "no activities" placeholder.
        if (state == ActivitiesState.no_activities)
          return _ActivityColumn(
            box: SizedBox(
              width: activityBoxSize,
              height: activityBoxSize,
              child: Image.asset('assets/logo.png'),
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
              background: ActivityBox(
                color: ThemeColors.almostColor,
                child: DirectionHelp(
                  ThemeColors.lowerBackground,
                  'almost',
                  Icons.arrow_forward_ios_rounded,
                  MainAxisAlignment.end,
                  CrossAxisAlignment.start,
                  Axis.vertical,
                ),
              ),
              secondaryBackground: ActivityBox(
                color: ThemeColors.skipColor,
                child: DirectionHelp(
                  ThemeColors.lowerBackground,
                  'skip',
                  Icons.arrow_back_ios_rounded,
                  MainAxisAlignment.end,
                  CrossAxisAlignment.end,
                  Axis.vertical,
                ),
              ),
              confirmDismiss: confirmDismiss,
            ),
            direction: DismissDirection.vertical,
            background: ActivityBox(
              color: ThemeColors.noColor,
              child: DirectionHelp(
                ThemeColors.upperBackground,
                'no',
                Icons.close_rounded,
                MainAxisAlignment.center,
                CrossAxisAlignment.start,
                Axis.horizontal,
              ),
            ),
            secondaryBackground: ActivityBox(
              color: ThemeColors.yesColor,
              child: DirectionHelp(
                ThemeColors.lowerBackground,
                'yes',
                Icons.check_rounded,
                MainAxisAlignment.center,
                CrossAxisAlignment.end,
                Axis.horizontal,
              ),
            ),
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
          streak: StreamBuilder<DateTime>(
              stream: activitiesBloc.currentDayStream,
              initialData: activitiesBloc.currentDay,
              builder: (context, dateSnapshot) {
                return StreamBuilder<Activity>(
                  stream: activitiesBloc.currentActivityStream,
                  initialData: activitiesBloc.currentActivity,
                  builder: (context, activitySnapshot) {
                    final currentDay = dateSnapshot.data;
                    final activity = activitiesBloc.currentActivity;

                    if (activity == null) return Container();

                    return ModelProvider<Activity>(
                      value: activity,
                      builder: (context, _, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            for (var color in activity.logHistoryIterator(
                                currentDay, activitiesBloc.historyLength))
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: color,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0))),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "past 7 days",
                                style: CustomTextStyle(
                                    ThemeColors.upperBackground),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              }),
        );
      },
    );
  }
}

class _ActivityColumn extends StatelessWidget {
  final Widget box;
  final Widget text;
  final Widget streak;

  const _ActivityColumn({Key key, this.box, this.text, this.streak})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<CurrentActivity>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CompositedTransformTarget(
          link: parent.boxLink,
          child: box,
        ),
        Container(
          padding: const EdgeInsets.only(top: 16),
          width: activityBoxSize,
          child: streak,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ),
          child: text,
        ),
      ],
    );
  }
}

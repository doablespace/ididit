import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_log_entry.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:provider/provider.dart';

import 'activity_box.dart';

class CurrentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return StreamBuilder<Activity>(
      stream: activitiesBloc.currentActivityStream,
      initialData: activitiesBloc.currentActivity,
      builder: (context, snapshot) {
        final activity = snapshot.data;

        return ModelProvider<Activity>(
          value: activity,
          builder: (context, _, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActivitySwiper(activity: activity, bloc: activitiesBloc),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 18,
                ),
                child: Text(
                  activity == null ? 'No activities' : activity.name,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivitySwiper extends StatelessWidget {
  final ActivitiesBloc bloc;
  final Activity activity;

  const _ActivitySwiper({Key key, this.bloc, this.activity}) : super(key: key);

  Future<bool> confirmDismiss(DismissDirection direction) {
    // Mark the activity in the database unless user chose "skip".
    if (direction != DismissDirection.endToStart) {
      final targetState = ActivityState.fromDirection(direction);
      bloc.setState(activity, targetState);
    }
    bloc.selectNext();
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    if (activity == null)
      return ActivityBox(
        color: ActivityColors.accentGreen,
        child: Center(child: Icon(Icons.flaky_rounded, size: 180)),
      );
    return Dismissible(
      key: UniqueKey(),
      child: Dismissible(
        key: UniqueKey(),
        child: StatefulActivityBox(activity: activity),
        background: ActivityBox(color: ThemeColors.pastelYellow),
        secondaryBackground: ActivityBox(color: ThemeColors.pastelGrey),
        confirmDismiss: confirmDismiss,
      ),
      direction: DismissDirection.vertical,
      background: ActivityBox(color: ThemeColors.pastelRed),
      secondaryBackground: ActivityBox(color: ThemeColors.pastelGreen),
      confirmDismiss: confirmDismiss,
    );
  }
}

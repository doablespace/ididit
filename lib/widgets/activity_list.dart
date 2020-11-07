import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';
import 'package:provider/provider.dart';

class ActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return Container(
      height: 90,
      margin: EdgeInsets.all(6),
      child: StreamBuilder<List<Activity>>(
        stream: activitiesBloc.activityStream,
        initialData: activitiesBloc.activities,
        builder: (context, snapshot) {
          final activities = snapshot.data;

          Widget buildItem(int index) {
            if (index == 0)
              return ClickableActivityBox(
                  color: ThemeColors.lightGrey,
                  size: 90,
                  child: Icon(Icons.add),
                  onTap: () {
                    activitiesBloc.addActivity(Activity(
                      icon: DateTime.now().second,
                      color: DateTime.now().millisecond,
                      name: 'A',
                      created: DateTime.now(),
                    ));
                  });

            final activity = activities[index - 1];
            return StatefulActivityBox(
                activity: activity,
                size: 90,
                onTap: () {
                  if (activitiesBloc.currentActivity == activity)
                    activitiesBloc.deleteActivity(activity.id);
                  else
                    activitiesBloc.select(activity);
                });
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemExtent: 96, // 90 (size) + 6 (margin)
            itemCount: 1 + activities.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(6),
                child: buildItem(index),
              );
            },
          );
        },
      ),
    );
  }
}

class _ActivityButton extends StatelessWidget {
  final Activity activity;

  const _ActivityButton(this.activity);

  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return StreamBuilder<Activity>(
      stream: activitiesBloc.currentActivityStream,
      initialData: activitiesBloc.currentActivity,
      builder: (context, snapshot) {
        final currentActivity = snapshot.data;
        final selected = currentActivity != null && activity == currentActivity;

        return OutlinedButton.icon(
          icon: activity == null
              ? Icon(Icons.add)
              : SvgPicture.asset(
                  activity.iconAsset,
                  color: Colors.black,
                  width: 24,
                  height: 24,
                ),
          label: activity == null ? Text('Add') : Text(activity.name),
          onPressed: () async {
            if (activity == null)
              activitiesBloc.addActivity(Activity(
                icon: DateTime.now().second,
                color: DateTime.now().millisecond,
                name: 'A',
                created: DateTime.now(),
              ));
            else if (selected)
              activitiesBloc.deleteActivity(activity.id);
            else
              activitiesBloc.select(activity);
          },
          style: OutlinedButton.styleFrom(
              backgroundColor: selected ? Colors.blue : null),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/screens/edit_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
                child: Icon(
                  Icons.add_rounded,
                  size: 48,
                  color: ThemeColors.lightBlue,
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => EditScreen()));
                },
              );

            final activity = activities[index - 1];
            return StatefulActivityBox(
              activity: activity,
              size: 90,
              onTap: () => activitiesBloc.select(activity),
            );
          }

          final controller = ItemScrollController();
          final child = ScrollablePositionedList.builder(
            scrollDirection: Axis.horizontal,
            itemScrollController: controller,
            itemCount: 1 + activities.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.all(6),
                child: buildItem(index),
              );
            },
          );

          return StreamBuilder<Activity>(
            stream: activitiesBloc.currentActivityStream,
            initialData: activitiesBloc.currentActivity,
            builder: (context, snapshot) {
              final activity = snapshot.data;
              if (activity != null && controller.isAttached) {
                controller.scrollTo(
                  index: activities.indexOf(activity),
                  duration: Duration(milliseconds: 200),
                );
              }

              return child;
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/extensions.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/screens/edit_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return Container(
      height: 102, // 90 (item height) + 12 (item padding)
      margin: EdgeInsets.all(6),
      child: StreamBuilder<List<Activity>>(
        stream: activitiesBloc.activityStream,
        initialData: activitiesBloc.activities,
        builder: (context, snapshot) {
          final activities = snapshot.data;

          Widget buildItem(int index) {
            // Put the adding button first.
            if (index == 0) return _addButtonItem(context);

            final activity = activities[index - 1];
            return StatefulActivityBox(
              activity: activity,
              size: 90,
              icon: 0,
              onTap: () => activitiesBloc.select(activity),
            );
          }

          if (activities.length == 0) {
            return Row(
              children: [
                Container(
                  margin: EdgeInsets.all(6),
                  child: _addButtonItem(context),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'press the plus button to',
                        style: CustomTextStyle(
                          ThemeColors.upperBackground,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'add new activity',
                        style: CustomTextStyle(
                          ThemeColors.upperBackground,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
          }

          final controller = ItemScrollController();
          final listener = ItemPositionsListener.create();
          final child = ScrollablePositionedList.builder(
            scrollDirection: Axis.horizontal,
            itemScrollController: controller,
            itemPositionsListener: listener,
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
              if (activity != null) {
                if (controller.isAttached) {
                  controller.scrollTo(
                    index: 1 + activities.indexOf(activity),
                    duration: Duration(milliseconds: 200),
                  );
                } else {
                  listener.itemPositions.once(() {
                    controller.scrollTo(
                      index: 1 + activities.indexOf(activity),
                      duration: Duration(milliseconds: 200),
                    );
                  });
                }
              }

              return child;
            },
          );
        },
      ),
    );
  }
}

Widget _addButtonItem(BuildContext context) {
  return ClickableActivityBox(
    color: ThemeColors.upperBackground,
    size: 90,
    child: Icon(
      Icons.add_rounded,
      size: 48,
      color: ThemeColors.lowerBackground,
    ),
    onTap: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => EditScreen()));
    },
  );
}

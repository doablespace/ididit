import 'package:flutter/material.dart';
import 'package:ididit/data/database.dart';
import 'package:ididit/models/activity.dart';
import 'package:provider/provider.dart';

class ActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Consumer<Db>(builder: (context, db, child) {
        return FutureProvider<List<Activity>>(
          create: (_) async => db == null ? [] : db.activities,
          child: Consumer<List<Activity>>(
            builder: (context, activities, child) {
              return ListView.builder(
                itemCount: 1 + activities.length,
                itemBuilder: (context, index) {
                  if (index == 0)
                    return ActivityButton(icon: Icon(Icons.add_rounded));

                  return ActivityButton(
                      icon: Icon(Icons.accessibility_new_rounded));
                },
                scrollDirection: Axis.horizontal,
              );
            },
          ),
        );
      }),
    );
  }
}

class ActivityButton extends StatelessWidget {
  final Widget icon;

  const ActivityButton({Key key, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: icon,
      label: Text('Test'),
      onPressed: () {},
    );
  }
}

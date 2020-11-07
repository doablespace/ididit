import 'package:flutter/material.dart';
import 'package:ididit/data/database.dart';
import 'package:ididit/models/activity.dart';
import 'package:provider/provider.dart';

final activityListImpl = GlobalKey<_ActivityListImplState>();

class ActivityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Consumer<Db>(builder: (context, db, child) {
        return ActivityListImpl(db);
      }),
    );
  }
}

class ActivityListImpl extends StatefulWidget {
  final Db db;

  ActivityListImpl(this.db) : super(key: activityListImpl);

  @override
  _ActivityListImplState createState() => _ActivityListImplState();
}

class _ActivityListImplState extends State<ActivityListImpl> {
  List<Activity> activities = [];

  @override
  void initState() {
    super.initState();
    if (widget.db != null)
      widget.db.activities.then((list) {
        activities.addAll(list);
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1 + activities.length,
      itemBuilder: (context, index) {
        if (index == 0) return ActivityButton();

        final activity = activities[index - 1];
        return ActivityButton(activity: activity);
      },
      scrollDirection: Axis.horizontal,
    );
  }

  void addActivity(Activity activity) async {
    await widget.db.saveActivity(activity);
    setState(() {
      activities.add(activity);
    });
  }
}

class ActivityButton extends StatelessWidget {
  final Activity activity;

  const ActivityButton({Key key, this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: activity == null ? Icon(Icons.add) : Text(activity.icon.toString()),
      label: activity == null ? Text('Add') : Text(activity.name),
      onPressed: () async {
        if (activity == null)
          activityListImpl.currentState.addActivity(Activity(
            icon: 1,
            name: 'A',
            created: DateTime.now().millisecondsSinceEpoch,
          ));
      },
    );
  }
}

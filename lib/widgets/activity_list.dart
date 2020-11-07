import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  int currentIndex;

  @override
  void initState() {
    super.initState();
    if (widget.db != null)
      widget.db.activities.then((list) {
        setState(() {
          activities.addAll(list);
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1 + activities.length,
      itemBuilder: (context, index) {
        if (index == 0) return ActivityButton(selected: false);

        final activity = activities[index - 1];
        return ActivityButton(
            activity: activity, selected: currentIndex == index - 1);
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

  void deleteActivity(int id) async {
    await widget.db.deleteActivity(id);
    setState(() {
      activities.removeWhere((a) => a.id == id);
    });
  }

  void select(Activity activity) {
    setState(() {
      currentIndex = activities.indexOf(activity);
    });
  }
}

class ActivityButton extends StatelessWidget {
  final Activity activity;
  final bool selected;

  const ActivityButton({Key key, this.activity, @required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          activityListImpl.currentState.addActivity(Activity(
            icon: DateTime.now().second,
            name: 'A',
            created: DateTime.now(),
          ));
        else if (selected)
          activityListImpl.currentState.deleteActivity(activity.id);
        else
          activityListImpl.currentState.select(activity);
      },
      style: OutlinedButton.styleFrom(
          backgroundColor: selected ? Colors.blue : null),
    );
  }
}

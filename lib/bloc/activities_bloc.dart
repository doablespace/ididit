import 'dart:async';

import 'package:ididit/bloc/bloc_provider.dart';
import 'package:ididit/data/database.dart';
import 'package:ididit/models/activity.dart';

class ActivitiesBloc extends Bloc {
  final Db _db;
  final List<Activity> _activities = [];
  final _activityController = StreamController<List<Activity>>();
  final _currentController = StreamController<Activity>.broadcast();

  ActivitiesBloc(this._db) {
    _init();
  }

  Stream<List<Activity>> get activityStream => _activityController.stream;
  Stream<Activity> get currentActivityStream => _currentController.stream;

  void _init() async {
    _activities.addAll(await _db.activities);
    _activityController.sink.add(_activities);
  }

  void addActivity(Activity activity) async {
    await _db.saveActivity(activity);
    _activities.add(activity);
    _activityController.sink.add(_activities);
  }

  void deleteActivity(int id) async {
    await _db.deleteActivity(id);
    _activities.removeWhere((a) => a.id == id);
    _activityController.sink.add(_activities);
  }

  void select(Activity activity) {
    _currentController.sink.add(activity);
  }

  @override
  void dispose() {
    _activityController.close();
    _currentController.close();
  }
}

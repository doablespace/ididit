import 'dart:async';

import 'package:ididit/bloc/bloc_provider.dart';
import 'package:ididit/data/database.dart';
import 'package:ididit/models/activity.dart';

class ActivitiesBloc extends Bloc {
  final Db _db;
  final List<Activity> _activities = [];
  Activity _currentActivity;
  final _activityController = StreamController<List<Activity>>();
  final _currentController = StreamController<Activity>.broadcast();

  ActivitiesBloc(this._db) {
    _init();
  }

  Iterable<Activity> get activities => _activities;
  Stream<List<Activity>> get activityStream => _activityController.stream;
  Activity get currentActivity => _currentActivity;
  Stream<Activity> get currentActivityStream => _currentController.stream;

  void _init() async {
    _activities.addAll(await _db.activities);
    _activityController.sink.add(_activities);
  }

  void addActivity(Activity activity) async {
    await _db.saveActivity(activity);
    _activities.add(activity);
    _activityController.sink.add(_activities);

    // Select as current.
    _currentActivity = activity;
    _currentController.sink.add(activity);
  }

  void deleteActivity(int id) async {
    await _db.deleteActivity(id);
    _activities.removeWhere((a) => a.id == id);
    _activityController.sink.add(_activities);

    // Unset current activity if it was just deleted.
    if (_currentActivity != null && _currentActivity.id == id) {
      _currentActivity = null;
      _currentController.sink.add(null);
    }
  }

  void select(Activity activity) {
    if (_currentActivity != activity) {
      _currentActivity = activity;
      _currentController.sink.add(activity);
    }
  }

  void selectNext() {
    if (_activities.length > 1) {
      final index = _activities.indexOf(_currentActivity);
      _currentActivity = _activities[(index + 1) % _activities.length];
      _currentController.sink.add(_currentActivity);
    }
  }

  @override
  void dispose() {
    _activityController.close();
    _currentController.close();
  }
}

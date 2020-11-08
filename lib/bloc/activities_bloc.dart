import 'dart:async';

import 'package:ididit/bloc/bloc_provider.dart';
import 'package:ididit/data/database.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/day_progress.dart';

class ActivitiesBloc extends Bloc {
  final Db _db;
  ActivitiesState _state = ActivitiesState.loading;
  final List<Activity> _activities = [];
  Activity _currentActivity;
  final _stateController = StreamController<ActivitiesState>.broadcast();
  final _activityController = StreamController<List<Activity>>();
  final _currentController = StreamController<Activity>.broadcast();
  final progress = DayProgress();

  ActivitiesBloc(this._db) {
    _init();
  }

  ActivitiesState get state => _state;
  Stream<ActivitiesState> get stateStream => _stateController.stream;
  Iterable<Activity> get activities => _activities;
  Stream<List<Activity>> get activityStream => _activityController.stream;
  Activity get currentActivity => _currentActivity;
  Stream<Activity> get currentActivityStream => _currentController.stream;

  void _init() async {
    _activities.addAll(await _db.findActivities(DateTime.now()));
    _activityController.sink.add(_activities);

    // Select first activity.
    if (_activities.isNotEmpty) {
      _setCurrent(_activities.first);
      _setState(ActivitiesState.ready);
    } else {
      _setState(ActivitiesState.no_activities);
    }

    for (final activity in _activities) progress.add(activity.state);
  }

  void editActivity(Activity activity) async {
    await _db.saveActivity(activity);
    activity.notifyListeners();
  }

  void addActivity(Activity activity) async {
    await _db.saveActivity(activity);
    _activities.add(activity);
    _activityController.sink.add(_activities);

    // Select as current.
    _setCurrent(activity);

    if (_state == ActivitiesState.no_activities)
      _setState(ActivitiesState.ready);

    progress.add();
  }

  void deleteActivity(Activity activity) async {
    await _db.deleteActivity(activity.id);

    // Update current activity if it is the one being deleted.
    if (_currentActivity != null && _currentActivity == activity) {
      // If no other activity exists, unset current.
      if (_activities.length == 1) {
        _setCurrent(null);
      }

      // Otherwise, set next as current.
      final index = _activities.indexOf(_currentActivity);
      _setCurrent(index == _activities.length - 1
          ? _activities.first
          : _activities[index + 1]);
    }

    // Update state.
    if (_activities.length == 1) _setState(ActivitiesState.no_activities);

    _activities.remove(activity);
    _activityController.sink.add(_activities);

    progress.remove(activity.state);
  }

  void select(Activity activity) {
    if (_currentActivity != activity) {
      _setCurrent(activity);
    }
  }

  void swipe(Activity activity, ActivityState targetState) {
    final previousState = activity.state;

    // Mark the activity in the database unless user chose "skip".
    if (targetState != ActivityState.skip) {
      _setActivityState(activity, targetState);
    }

    // Go to next activity only if in "normal flow" (i.e., not if user selected
    // some already-marked activity). Or always if "skip" was chosen.
    if (previousState == ActivityState.skip ||
        targetState == ActivityState.skip) _selectNext();

    // Update progress.
    progress.update(previousState, targetState);
  }

  void _selectNext() {
    if (_activities.length > 1) {
      final index = _activities.indexOf(_currentActivity);
      _setCurrent(_activities[(index + 1) % _activities.length]);
    }
  }

  void _setActivityState(Activity activity, ActivityState state) async {
    await _db.markActivity(activity, DateTime.now(), state.value);
  }

  void _setCurrent(Activity activity) {
    _currentActivity = activity;
    _currentController.sink.add(activity);
  }

  void _setState(ActivitiesState state) {
    _state = state;
    _stateController.sink.add(state);
  }

  @override
  void dispose() {
    _stateController.close();
    _activityController.close();
    _currentController.close();
  }
}

enum ActivitiesState { loading, no_activities, ready }

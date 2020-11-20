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
  bool _youDidIt;
  DateTime _currentDay = DateTime.now().toUtc();
  double _loading = 0.0;
  final historyLength = 7; // How many past days results to display.
  final _stateController = StreamController<ActivitiesState>.broadcast();
  final _activityController = StreamController<List<Activity>>.broadcast();
  final _currentController = StreamController<Activity>.broadcast();
  final _youDidItController = StreamController<bool>.broadcast();
  final _currentDayController = StreamController<DateTime>.broadcast();
  final _loadingController = StreamController<double>.broadcast();
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
  bool get youDidIt => _youDidIt;
  Stream<bool> get youDidItStream => _youDidItController.stream;
  DateTime get currentDay => _currentDay;
  Stream<DateTime> get currentDayStream => _currentDayController.stream;
  double get loading => _loading;
  Stream<double> get loadingStream => _loadingController.stream;

  void _init() async {
    // Load all activities and their current state.
    final activities = await _db.findActivities(_currentDay, historyLength,
        progress: _progress);
    _setLoading(0);

    _activities.addAll(activities);
    _activityController.sink.add(_activities);

    // Update state.
    if (_activities.isNotEmpty) {
      _setState(ActivitiesState.ready);
    } else {
      _setState(ActivitiesState.no_activities);
    }

    // Update progress.
    progress.reset(_activities.map((a) => a.state));

    // All done?
    _updateYouDidIt();
    if (_activities.isNotEmpty && !_youDidIt) {
      _setCurrent(_activities.first);
    }
  }

  void changeDay(DateTime day) async {
    // Update current activity state of all activities.
    await _db.findActivityLogs(
      _activities,
      day,
      historyLength,
      progress: _progress,
    );
    _setLoading(0);

    _currentDay = day;
    _currentDayController.sink.add(day);

    progress.reset(_activities.map((a) => a.state));
    _updateYouDidIt();
    if (_activities.isNotEmpty && !_youDidIt && _currentActivity == null) {
      _setCurrent(_activities.first);
    }
  }

  void editActivity(Activity activity) async {
    await _db.saveActivity(activity);
    activity.saved();
  }

  void addActivity(Activity activity) async {
    await _db.saveActivity(activity);
    _activities.add(activity);
    _activityController.sink.add(_activities);

    // Select as current.
    _setCurrent(activity);

    // Update state.
    if (_state == ActivitiesState.no_activities)
      _setState(ActivitiesState.ready);

    _updateYouDidIt();

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

    _updateYouDidIt();

    progress.remove(activity.state);
  }

  void select(Activity activity) {
    if (_currentActivity != activity) {
      _setCurrent(activity);
    }
  }

  void unmark(Activity activity) {
    var log = activity.logEntry;
    if (log != null) {
      _db.deleteActivityLog(log.id);
      activity.logEntry = null;
      progress.remove(log.state);
      progress.add(ActivityState.skip);
    }
  }

  void swipe(Activity activity, ActivityState targetState) async {
    final previousState = activity.state;

    // Mark the activity in the database unless user chose "skip".
    if (targetState != ActivityState.skip) {
      await _setActivityState(activity, _currentDay, targetState);
      progress.update(previousState, targetState);
    }

    // Go to next activity only if in "normal flow" (i.e., not if user selected
    // some already-marked activity). Or always if "skip" was chosen.
    if (previousState == ActivityState.skip ||
        targetState == ActivityState.skip) _selectNext();
  }

  void _selectNext() {
    if (_activities.length > 1) {
      // Find first activity after this one that's unmarked.
      final index = _activities.indexOf(_currentActivity);
      for (int i = (index + 1) % _activities.length;
          i != index;
          i = (i + 1) % _activities.length) {
        final activity = _activities[i];
        if (activity.state == ActivityState.skip) {
          _setCurrent(activity);
          return;
        }
      }
    }

    // If current activity is the only one, stay at it.
    if (_currentActivity.state == ActivityState.skip) return;

    // If there is no such activity, we are done.
    _setCurrent(null);
  }

  Future<void> _setActivityState(
      Activity activity, DateTime day, ActivityState state) async {
    await _db.markActivity(activity, day, state.value);

    _updateYouDidIt();
  }

  void _setCurrent(Activity activity) {
    _currentActivity = activity;
    _currentController.sink.add(activity);
    _updateYouDidIt();
  }

  void _setState(ActivitiesState state) {
    _state = state;
    _stateController.sink.add(state);
  }

  void _progress(int loaded, int total) => _setLoading(loaded / total);

  void _setLoading(double value) {
    if (_loading != value) {
      _loading = value;
      _loadingController.sink.add(value);
    }
  }

  void _updateYouDidIt() {
    final value = _currentActivity == null &&
        _activities.isNotEmpty &&
        _activities.every((activity) => activity.state != ActivityState.skip);
    if (_youDidIt != value) {
      _youDidIt = value;
      _youDidItController.sink.add(value);
    }
  }

  @override
  void dispose() {
    _stateController.close();
    _activityController.close();
    _currentController.close();
    _youDidItController.close();
    _currentDayController.close();
    _loadingController.close();
  }
}

enum ActivitiesState { loading, no_activities, ready }

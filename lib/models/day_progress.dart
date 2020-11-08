import 'package:flutter/cupertino.dart';
import 'package:ididit/models/activity_states.dart';

class DayProgress extends ChangeNotifier {
  List<int> _numbers = List.filled(ActivityState.values.length, 0);

  int getProgress(ActivityState state) => _numbers[state.value];

  void update(ActivityState oldState, ActivityState newState) {
    if (oldState != null) _numbers[oldState.value]--;
    _numbers[newState.value]++;
    notifyListeners();
  }

  void add([ActivityState state]) {
    _numbers[(state ?? ActivityState.skip).value]++;
    notifyListeners();
  }

  void remove(ActivityState state) {
    _numbers[state.value]--;
    notifyListeners();
  }

  Iterable<int> get values => _numbers;
}

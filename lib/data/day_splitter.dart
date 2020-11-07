import 'package:flutter/material.dart';

class DaySplitter {
  final TimeOfDay threshold;

  DaySplitter(this.threshold);

  /// Gets threshold on the specified day.
  DateTime _getCurrentThreshold(DateTime time) {
    return DateTime(
        time.year, time.month, time.day, threshold.hour, threshold.minute);
  }

  DateTimeRange getRange(DateTime time) {
    time = time.toUtc();
    final currentThreshold = _getCurrentThreshold(time);
    if (time.isBefore(currentThreshold)) {
      return DateTimeRange(
        start: currentThreshold.subtract(const Duration(days: 1)),
        end: currentThreshold,
      );
    } else {
      return DateTimeRange(
        start: currentThreshold,
        end: currentThreshold.add(const Duration(days: 1)),
      );
    }
  }

  bool inSameDay(DateTime x, DateTime y) {
    final xThreshold = _getCurrentThreshold(x);
    final yThreshold = _getCurrentThreshold(y);
    return xThreshold == yThreshold &&
        x.isAfter(xThreshold) == y.isAfter(yThreshold);
  }
}

// TODO: This should be saved in user preferences.
final daySplitter = DaySplitter(TimeOfDay(hour: 4, minute: 0));

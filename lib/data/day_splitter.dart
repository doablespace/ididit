import 'package:flutter/material.dart';

class DaySplitter {
  final TimeOfDay threshold;

  DaySplitter(this.threshold);

  DateTimeRange getRange(DateTime time) {
    time = time.toUtc();

    // Get threshold on the specified `day`.
    final currentThreshold = DateTime(
        time.year, time.month, time.day, threshold.hour, threshold.minute);

    if (time.isAfter(currentThreshold)) {
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
}

// TODO: This should be saved in user preferences.
final daySplitter = DaySplitter(TimeOfDay(hour: 4, minute: 0));

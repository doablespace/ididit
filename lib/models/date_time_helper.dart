class DateTimeHelper {
  DateTimeHelper._();

  static final DateTime epoch =
      DateTime.fromMicrosecondsSinceEpoch(0, isUtc: true);

  static DateTime daysFromDatabase(int value) {
    if (value == null) return null;
    return epoch.add(Duration(days: value));
  }

  static int daysToDatabase(DateTime value) {
    if (value == null) return null;
    return value.toUtc().difference(epoch).inDays;
  }

  static DateTime fromRelative(DateTime base, int microseconds) {
    if (base == null) return null;
    return base.toUtc().add(Duration(microseconds: microseconds));
  }

  static int toRelative(DateTime base, DateTime value) {
    if (base == null || value == null) return null;
    return value.toUtc().difference(base.toUtc()).inMicroseconds;
  }
}

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
}

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/date_time_helper.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DaySelector extends StatefulWidget {
  @override
  _DaySelectorState createState() => _DaySelectorState();
}

class _DaySelectorState extends State<DaySelector> {
  int currentIndex = 0;
  DateTime currentDay;

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<ActivitiesBloc>(context, listen: false);
    if (currentDay == null) currentDay = activities.currentDay;

    return SizedBox(
      height:
          context.findAncestorWidgetOfExactType<AppBar>().preferredSize.height,
      child: Swiper(
        // HACK: We actually want infinite list; 3 is minimal number of items we
        // can fake left-right swipes with.
        itemCount: 3,
        itemBuilder: (context, index) {
          final diff = dayDifference(currentIndex, index);
          final targetDay = currentDay.add(Duration(days: diff));
          return Center(
            child: _Day(targetDay),
          );
        },
        onIndexChanged: (index) {
          final diff = dayDifference(currentIndex, index);
          final targetDay = currentDay.add(Duration(days: diff));
          activities.changeDay(targetDay);
          setState(() {
            currentDay = targetDay;
            currentIndex = index;
          });
        },
        control: SwiperControl(
          color: ThemeColors.inkColor,
          iconPrevious: Icons.chevron_left_rounded,
          iconNext: Icons.chevron_right_rounded,
        ),
      ),
    );
  }

  /// Returns `-1`, `0` or `1` dependening on whether [first] index is before,
  /// same or after [second], respectively.
  static int dayDifference(int first, int second) {
    if (first == second) return 0;
    if ((first + 1) % 3 == second) return 1;
    return -1;
  }
}

class _Day extends StatelessWidget {
  final DateTime day;

  _Day(this.day) : super(key: ValueKey(day));

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toUtc();
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));

    return Text.rich(TextSpan(children: [
      if (DateTimeHelper.areSameDay(today, day)) TextSpan(text: 'Today, '),
      if (DateTimeHelper.areSameDay(yesterday, day))
        TextSpan(text: 'Yesterday, '),
      if (DateTimeHelper.areSameDay(tomorrow, day))
        TextSpan(text: 'Tomorrow, '),
      TextSpan(
        text: DateFormat.yMEd().format(day),
        style: TextStyle(color: ThemeColors.inkColor.withOpacity(0.7)),
      ),
    ]));
  }
}

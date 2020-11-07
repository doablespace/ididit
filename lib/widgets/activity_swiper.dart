import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:provider/provider.dart';

class ActivitySwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    Future<bool> confirmDismiss(DismissDirection direction) {
      activitiesBloc.selectNext();
      return Future.value(false);
    }

    return Center(
      child: StreamBuilder<Activity>(
        stream: activitiesBloc.currentActivityStream,
        initialData: activitiesBloc.currentActivity,
        builder: (context, snapshot) {
          final activity = snapshot.data;

          return Dismissible(
            key: UniqueKey(),
            child: Dismissible(
              key: UniqueKey(),
              child: _ActivityBackground(
                color: activity == null
                    ? ActivityColors.accentGreen
                    : activity.accent,
                child: activity == null
                    ? Center(child: Icon(Icons.flaky_rounded, size: 180))
                    : InkWell(
                        onTap: () {},
                        child: Center(
                          child: SvgPicture.asset(
                            activity.iconAsset,
                            color: ThemeColors.darkBlue,
                            width: 180,
                            height: 180,
                          ),
                        ),
                      ),
              ),
              background: _ActivityBackground(color: ThemeColors.pastelYellow),
              secondaryBackground:
                  _ActivityBackground(color: ThemeColors.pastelGrey),
              confirmDismiss: confirmDismiss,
            ),
            direction: DismissDirection.vertical,
            background: _ActivityBackground(color: ThemeColors.pastelRed),
            secondaryBackground:
                _ActivityBackground(color: ThemeColors.pastelGreen),
            confirmDismiss: confirmDismiss,
          );
        },
      ),
    );
  }
}

class _ActivityBackground extends StatelessWidget {
  final Color color;
  final Widget child;

  const _ActivityBackground({Key key, this.color, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(50),
        child: child,
      ),
    );
  }
}

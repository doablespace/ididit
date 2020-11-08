import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:ididit/screens/edit_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';
import 'package:ididit/widgets/options_activity_box.dart';
import 'package:provider/provider.dart';

import 'edit_screen/edit_form.dart';

final activityTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.w600,
  color: ThemeColors.upperBackground,
);

class CurrentActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return StreamBuilder<ActivitiesState>(
      stream: activitiesBloc.stateStream,
      initialData: activitiesBloc.state,
      builder: (context, snapshot) {
        final state = snapshot.data;

        // Show "loading" placeholder.
        if (state == ActivitiesState.loading)
          return _ActivityColumn(
            box: ActivityBox(color: ActivityColors.accentGreen),
            text: Text('Loading...', style: activityTextStyle),
          );

        // Show "no activities" placeholder.
        if (state == ActivitiesState.no_activities)
          return _ActivityColumn(
            box: ClickableActivityBox(
              color: ActivityColors.accentGreen,
              child: Center(child: Icon(Icons.flaky_rounded, size: 180)),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => EditScreen()));
              },
            ),
            text: Text('No activities', style: activityTextStyle),
          );

        /// Handles swipes.
        Future<bool> confirmDismiss(DismissDirection direction) {
          final activity = activitiesBloc.currentActivity;
          final targetState = ActivityState.fromDirection(direction);
          activitiesBloc.swipe(activity, targetState);
          return Future.value(false);
        }

        // Show current activity.
        return _ActivityColumn(
          box: Dismissible(
            key: UniqueKey(),
            child: Dismissible(
              key: UniqueKey(),
              child: StreamBuilder<Activity>(
                stream: activitiesBloc.currentActivityStream,
                initialData: activitiesBloc.currentActivity,
                builder: (context, snapshot) {
                  final activity = snapshot.data;
                  if (activity == null) return Container();
                  return OptionsActivityBox(activity: activity);
                },
              ),
              background: ActivityBox(
                color: ThemeColors.almostColor,
                child: DirectionHelp(
                  ThemeColors.lowerBackground,
                  'almost',
                  Icons.arrow_forward_ios_rounded,
                  MainAxisAlignment.end,
                  CrossAxisAlignment.start,
                  Axis.vertical,
                ),
              ),
              secondaryBackground: ActivityBox(
                color: ThemeColors.skipColor,
                child: DirectionHelp(
                  ThemeColors.lowerBackground,
                  'skip',
                  Icons.arrow_back_ios_rounded,
                  MainAxisAlignment.end,
                  CrossAxisAlignment.end,
                  Axis.vertical,
                ),
              ),
              confirmDismiss: confirmDismiss,
            ),
            direction: DismissDirection.vertical,
            background: ActivityBox(
              color: ThemeColors.noColor,
              child: DirectionHelp(
                ThemeColors.upperBackground,
                'no',
                Icons.close_rounded,
                MainAxisAlignment.center,
                CrossAxisAlignment.start,
                Axis.horizontal,
              ),
            ),
            secondaryBackground: ActivityBox(
              color: ThemeColors.yesColor,
              child: DirectionHelp(
                ThemeColors.lowerBackground,
                'yes',
                Icons.check_rounded,
                MainAxisAlignment.center,
                CrossAxisAlignment.end,
                Axis.horizontal,
              ),
            ),
            confirmDismiss: confirmDismiss,
          ),
          text: StreamBuilder<Activity>(
            stream: activitiesBloc.currentActivityStream,
            initialData: activitiesBloc.currentActivity,
            builder: (context, snapshot) {
              final activity = snapshot.data;
              if (activity == null) return Container();
              return ModelProvider<Activity>(
                value: activity,
                builder: (context, _, child) {
                  return Text(
                    """${activity.name}""", // Multiline hack.
                    style: activityTextStyle,
                    textAlign: TextAlign.center,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class _ActivityColumn extends StatelessWidget {
  final Widget box;
  final Widget text;

  const _ActivityColumn({Key key, this.box, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        box,
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 12,
          ),
          child: text,
        ),
      ],
    );
  }
}

class DirectionHelp extends StatelessWidget {
  final Color _color;
  final String _text;
  final IconData _iconData;
  final MainAxisAlignment _colAlign;
  final CrossAxisAlignment _rowAlign;
  final Axis _axis;

  const DirectionHelp(this._color, this._text, this._iconData, this._colAlign,
      this._rowAlign, this._axis,
      {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: _axis == Axis.vertical ? 32 : 16, horizontal: 16),
      child: Flex(
        direction: _axis,
        mainAxisAlignment: _colAlign,
        crossAxisAlignment: _rowAlign,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              _text,
              style: CustomTextStyle(
                _color,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ),
          Icon(
            _iconData,
            size: 40,
            color: _color,
          )
        ],
      ),
    );
  }
}

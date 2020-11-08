import 'package:flutter/material.dart';
import 'package:ididit/bloc/activities_bloc.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/screens/edit_screen.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';
import 'package:ididit/widgets/rounded_button.dart';
import 'package:provider/provider.dart';

/// [StatefulActivityBox] with options on click.
class OptionsActivityBox extends StatelessWidget {
  final Activity activity;
  final double size;
  final LayerLink _layerLink = LayerLink();

  OptionsActivityBox({Key key, this.activity, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    final options = Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final state in ActivityState.values)
              RoundedButton(
                borderColor: state.color,
                textColor: state.color,
                buttonWidth: 36,
                icon: Icon(state.iconData, color: state.color),
                onPressed: () {
                  activitiesBloc.swipe(activity, state);
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
        RoundedButton(
          borderColor: ThemeColors.lightGrey,
          textColor: ThemeColors.lightGrey,
          label: 'Delete',
          buttonWidth: 240,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Are you sure?'),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: [
                        Text(
                            'Activity ${activity.name} will be permanently deleted.'),
                        Text('Do you want to continue?'),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Delete',
                          style: TextStyle(color: ThemeColors.pastelRed)),
                      onPressed: () {
                        activitiesBloc.deleteActivity(activity.id);
                        Navigator.of(context)..pop()..pop();
                      },
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        RoundedButton(
          borderColor: ThemeColors.lightGrey,
          backgroundColor: ThemeColors.lightGrey,
          textColor: ThemeColors.lightBlue,
          label: 'Edit',
          buttonWidth: 240,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => EditScreen(
                  activityChange: ActivityChange.edit,
                ),
              ),
            );
          },
        ),
      ],
    );

    return CompositedTransformTarget(
      link: _layerLink,
      child: StatefulActivityBox(
        activity: activity,
        size: size,
        onTap: () => Navigator.of(context).push(_Options(
          _layerLink,
          child: options,
        )),
      ),
    );
  }
}

class _Options extends PopupRoute {
  final LayerLink layerLink;
  final Widget child;

  _Options(this.layerLink, {this.child});

  @override
  Color get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Stack(
      children: [
        CompositedTransformFollower(
          link: layerLink,
          child: Container(
            decoration: BoxDecoration(
              color: ThemeColors.darkBlue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(50),
            ),
            width: 280,
            height: 280,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  Duration get transitionDuration => Duration.zero;
}

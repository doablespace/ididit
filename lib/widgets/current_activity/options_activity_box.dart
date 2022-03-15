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
        // Unmark button.
        RoundedButton(
          borderColor: ThemeColors.upperBackground,
          textColor: ThemeColors.upperBackground,
          label: 'Unmark',
          iconLabel: Icons.autorenew_rounded,
          buttonWidth: 230,
          onPressed: () {
            activitiesBloc.unmark(activity);
            Navigator.pop(context);
          },
        ),
        // Move buttons.
        _MoveAction(activity),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Delete button.
            RoundedButton(
              borderColor: ThemeColors.upperBackground,
              textColor: ThemeColors.upperBackground,
              label: 'Delete',
              iconLabel: Icons.delete_forever_rounded,
              buttonWidth: 110,
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
                          child: Text('Delete'.toUpperCase(),
                              style: TextStyle(color: ThemeColors.noColor)),
                          onPressed: () {
                            activitiesBloc.deleteActivity(activity);
                            Navigator.of(context)..pop()..pop();
                          },
                        ),
                        TextButton(
                          child: Text('Cancel'.toUpperCase()),
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
            SizedBox(width: 10),
            // Edit button.
            RoundedButton(
              borderColor: ThemeColors.upperBackground,
              textColor: ThemeColors.upperBackground,
              label: 'Edit',
              iconLabel: Icons.create_rounded,
              buttonWidth: 110,
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
              color: ThemeColors.inkColor.withOpacity(0.8),
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

class _MoveAction extends StatefulWidget {
  final Activity activity;

  const _MoveAction(this.activity, {Key key}) : super(key: key);

  @override
  State<_MoveAction> createState() => _MoveActionState();
}

class _MoveActionState extends State<_MoveAction> {
  bool moving = false;

  @override
  Widget build(BuildContext context) {
    if (moving) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _moveButton(
            icon: Icons.first_page_rounded,
            handler: (activitiesBloc) {
              if (widget.activity.customOrder != activitiesBloc.minOrder) {
                widget.activity.customOrder = activitiesBloc.minOrder - 1;
                activitiesBloc.moved(widget.activity);
              }
              setState(() {
                moving = false;
              });
            },
          ),
          _moveButton(
            icon: Icons.keyboard_arrow_left_rounded,
            handler: _swapActivities(-1),
          ),
          _moveButton(
            icon: Icons.keyboard_arrow_right_rounded,
            handler: _swapActivities(1),
          ),
          _moveButton(
            icon: Icons.last_page_rounded,
            handler: (activitiesBloc) {
              if (widget.activity.customOrder != activitiesBloc.maxOrder) {
                widget.activity.customOrder = activitiesBloc.maxOrder + 1;
                activitiesBloc.moved(widget.activity);
              }
              setState(() {
                moving = false;
              });
            },
          ),
        ],
      );
    }
    return RoundedButton(
      borderColor: ThemeColors.upperBackground,
      textColor: ThemeColors.upperBackground,
      label: 'Move',
      iconLabel: Icons.swap_horiz_rounded,
      buttonWidth: 230,
      onPressed: () {
        setState(() {
          moving = true;
        });
      },
    );
  }

  Widget _moveButton({IconData icon, void Function(ActivitiesBloc) handler}) {
    final activitiesBloc = Provider.of<ActivitiesBloc>(context, listen: false);

    return RoundedButton(
      borderColor: ThemeColors.upperBackground,
      textColor: ThemeColors.upperBackground,
      buttonWidth: 36,
      icon: Icon(icon, color: ThemeColors.upperBackground),
      onPressed: () {
        handler(activitiesBloc);
        activitiesBloc.sort();
      },
    );
  }

  _swapActivities(int delta) {
    return (ActivitiesBloc activitiesBloc) {
      var newOrder = widget.activity.customOrder + delta;
      var oldActivity = activitiesBloc.activities.firstWhere(
        (a) => a.customOrder == newOrder && a != widget.activity,
        orElse: () => null,
      );
      var oldOrder = widget.activity.customOrder;
      widget.activity.customOrder = newOrder;
      activitiesBloc.moved(widget.activity);
      if (oldActivity != null) {
        oldActivity.customOrder = oldOrder;
        activitiesBloc.moved(oldActivity);
      }
    };
  }
}

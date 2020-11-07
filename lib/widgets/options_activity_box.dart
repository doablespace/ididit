import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_box.dart';

/// [StatefulActivityBox] with options on click.
class OptionsActivityBox extends StatelessWidget {
  final Activity activity;
  final double size;
  final LayerLink _layerLink = LayerLink();

  OptionsActivityBox({Key key, this.activity, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: StatefulActivityBox(
        activity: activity,
        size: size,
        onTap: () {
          Navigator.of(context).push(_Options(_layerLink));
        },
      ),
    );
  }
}

class _Options extends PopupRoute {
  final LayerLink layerLink;

  _Options(this.layerLink);

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
          ),
        ),
      ],
    );
  }

  @override
  Duration get transitionDuration => Duration.zero;
}

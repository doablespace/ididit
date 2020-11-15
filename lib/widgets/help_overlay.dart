import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ididit/models/activity_states.dart';
import 'package:ididit/ui/color_theme.dart';

class NavigationHelp extends PopupRoute {
  final LayerLink _boxLink;

  NavigationHelp(this._boxLink);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SafeArea(
      child: Container(
        color: ThemeColors.inkColor.withOpacity(0.4),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0, // Transparency.
            automaticallyImplyLeading: false, // Remove back button.
            actions: [
              IconButton(
                icon: Icon(
                  Icons.close_rounded,
                  color: ThemeColors.upperBackground,
                ),
                tooltip: 'Close help',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              CompositedTransformFollower(
                link: _boxLink,
                offset: Offset(0, -24),
                child: Container(
                  width: 280,
                  child: _ActivityStateHelp(state: ActivityState.yes),
                ),
              ),
              CompositedTransformFollower(
                link: _boxLink,
                offset: Offset(0, 256), // 280 - 24
                child: Container(
                  width: 280,
                  child: _ActivityStateHelp(state: ActivityState.no),
                ),
              ),
              CompositedTransformFollower(
                link: _boxLink,
                offset: Offset(220, 0), // 280 - 120/2
                child: Container(
                  height: 280,
                  child: _ActivityStateHelp(
                    state: ActivityState.almost,
                    axis: Axis.vertical,
                  ),
                ),
              ),
              CompositedTransformFollower(
                link: _boxLink,
                offset: Offset(-60, 0), // 120/2
                child: Container(
                  height: 280,
                  child: _ActivityStateHelp(
                    state: ActivityState.skip,
                    axis: Axis.vertical,
                  ),
                ),
              ),
              CompositedTransformFollower(
                link: _boxLink,
                child: Container(
                  width: 280,
                  height: 280,
                  child: _DirectionHelp(
                    color: ThemeColors.upperBackground,
                    icon: Icons.touch_app_rounded,
                    textIntro: 'touch for ',
                    textMain: 'menu',
                    axis: Axis.vertical,
                  ),
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
            height: 102,
            alignment: Alignment.centerLeft,
            child: _DirectionHelp(
              icon: Icons.first_page_rounded,
              color: ThemeColors.upperBackground,
              textIntro: 'scroll left to ',
              textMain: 'add new',
              alignment: MainAxisAlignment.start,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Color get barrierColor => ThemeColors.inkColor.withOpacity(0.8);

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Duration get transitionDuration => Duration.zero;
}

class _ActivityStateHelp extends StatelessWidget {
  final ActivityState state;
  final Axis axis;

  const _ActivityStateHelp({
    Key key,
    this.state,
    this.axis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _DirectionHelp(
      icon: state.swipeIconData,
      color: state.color,
      textIntro: 'swipe ${state.swipeDirection} to mark ',
      textMain: state.text,
      axis: axis,
    );
  }
}

class _DirectionHelp extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String textIntro;
  final String textMain;
  final Axis axis;
  final MainAxisAlignment alignment;

  const _DirectionHelp({
    Key key,
    this.icon,
    this.color,
    this.textIntro,
    this.textMain,
    this.axis,
    this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis ?? Axis.horizontal,
      mainAxisAlignment: alignment ?? MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 6, height: 6),
        Icon(
          icon,
          color: color,
          size: 48,
        ),
        SizedBox(width: 6, height: 6),
        SizedBox(
          width: 120,
          height: 48,
          child: AutoSizeText.rich(
            TextSpan(
              children: [
                TextSpan(text: textIntro),
                TextSpan(
                  text: textMain,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            textAlign: axis == Axis.vertical ? TextAlign.center : null,
            style: TextStyle(
              fontSize: 18,
              color: color,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        SizedBox(width: 6, height: 6),
      ],
    );
  }
}

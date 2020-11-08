import 'package:flutter/material.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

class NavigationHelp extends PopupRoute {
  final LayerLink _activityLink;
  NavigationHelp(this._activityLink);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        width: 400,
        color: ThemeColors.darkBlue.withOpacity(0.7),
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
                    color: ThemeColors.lightGrey,
                  ),
                  tooltip: 'Close help',
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CompositedTransformFollower(
                link: _activityLink,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DirectionIcon(
                        ThemeColors.pastelGreen,
                        Icons.arrow_upward_rounded,
                      ),
                      DirectionText(
                        ThemeColors.pastelGreen,
                        'up to mark',
                        'yes',
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DirectionText(
                        ThemeColors.pastelGrey,
                        'left to',
                        'skip',
                      ),
                      DirectionIcon(
                        ThemeColors.pastelGrey,
                        Icons.arrow_back_ios_rounded,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DirectionText(
                        ThemeColors.pastelYellow,
                        'right to mark',
                        'almost',
                        alignRight: true,
                      ),
                      DirectionIcon(
                        ThemeColors.pastelYellow,
                        Icons.arrow_forward_ios_rounded,
                      ),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DirectionIcon(
                    ThemeColors.lightGrey,
                    Icons.touch_app_rounded,
                  ),
                  Text(
                    'touch for ',
                    style: CustomTextStyle(
                      ThemeColors.lightGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'menu',
                    style: CustomTextStyle(
                      ThemeColors.lightGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DirectionIcon(
                      ThemeColors.pastelRed,
                      Icons.arrow_downward_rounded,
                    ),
                    DirectionText(
                      ThemeColors.pastelRed,
                      'down to mark',
                      'no',
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            height: 90,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DirectionIcon(
                  ThemeColors.lightGrey,
                  Icons.first_page_rounded,
                ),
                Container(
                  height: 56,
                  padding: EdgeInsets.only(top: 8),
                  child: DirectionText(
                    ThemeColors.lightGrey,
                    'scroll left to',
                    'add new',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Color get barrierColor => ThemeColors.darkBlue.withOpacity(0.8);

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => null;

  @override
  Duration get transitionDuration => Duration.zero;
}

class DirectionText extends StatelessWidget {
  final Color color;
  final String direction;
  final String action;
  final bool alignRight;

  DirectionText(this.color, this.direction, this.action,
      {this.alignRight = false});

  @override
  Widget build(BuildContext context) {
    final double fontSize = 18;
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          'swipe $direction',
          style: CustomTextStyle(
            color,
            fontSize: fontSize,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          '$action',
          style: CustomTextStyle(
            color,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class DirectionIcon extends StatelessWidget {
  final Color color;
  final IconData icon;

  DirectionIcon(this.color, this.icon);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8, top: 8),
      child: Icon(
        icon,
        color: color,
        size: 48,
      ),
    );
  }
}

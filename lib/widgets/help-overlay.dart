import 'package:flutter/material.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/edit_screen/edit_form.dart';

class NavigationHelp extends StatelessWidget {
  // Help is opened as overlay, to close it we need to remove it from `OverlayState`.
  final OverlayEntry _overlayEntry;
  NavigationHelp(this._overlayEntry);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        width: 400,
        color: ThemeColors.darkBlue.withOpacity(0.8),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actionsIconTheme: IconThemeData(color: ThemeColors.lightGrey),
            actions: [
              IconButton(
                  icon: Icon(Icons.close_rounded),
                  tooltip: 'Close help',
                  onPressed: () {
                    _overlayEntry.remove();
                  }),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
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
                    'touch to ',
                    style: CustomTextStyle(
                      ThemeColors.lightGrey,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'edit',
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
                      'up to mark',
                      'no',
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DirectionIcon(
                ThemeColors.lightGrey,
                Icons.first_page_rounded,
              ),
              Container(
                height: 48,
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
    );
  }
}

class DirectionText extends StatelessWidget {
  final Color color;
  final String direction;
  final String action;

  DirectionText(this.color, this.direction, this.action);
  @override
  Widget build(BuildContext context) {
    final double fontSize = 18;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

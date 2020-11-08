import 'package:flutter/material.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_list.dart';
import 'package:ididit/widgets/current_activity.dart';
import 'package:ididit/widgets/help-overlay.dart';

class SwipingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BackgroundDecoration(3.0, 0.45),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actionsIconTheme: IconThemeData(color: ThemeColors.lightBlue),
            actions: [
              IconButton(
                  icon: Icon(Icons.more_vert_rounded),
                  tooltip: 'Show help',
                  onPressed: () {
                    _overlayHelp(context);
                  }),
            ],
          ),
          backgroundColor: Colors.transparent,
          body: Center(child: CurrentActivity()),
          bottomNavigationBar: ActivityList(),
        ),
      ),
    );
  }

  _overlayHelp(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry navigationHelp = OverlayEntry(
      builder: (context) => NavigationHelp(),
    );
    overlayState.insert(navigationHelp);
  }
}

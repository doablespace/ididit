import 'package:flutter/material.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_list.dart';
import 'package:ididit/widgets/current_activity.dart';
import 'package:ididit/widgets/help_overlay.dart';
import 'package:ididit/widgets/progress_bars.dart';

class SwipingScreen extends StatelessWidget {
  // Link between main activity position and overlayed help.
  final LayerLink _helpLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BackgroundDecoration(3.0, 0.45),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.fromLTRB(32, 22, 72, 0),
                // Needed for normal text style in child.
                child: Material(
                  type: MaterialType.transparency,
                  child: ProgressBars(),
                ),
              ),
            ),
            Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0, // For actual transparency.
                actions: [
                  IconButton(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
                    icon: Icon(
                      Icons.help,
                      color: ThemeColors.lightBlue,
                    ),
                    tooltip: 'Show help',
                    onPressed: () {
                      Navigator.of(context).push(NavigationHelp(_helpLink));
                    },
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
              body: CompositedTransformTarget(
                link: _helpLink,
                child: Center(
                  child: CurrentActivity(),
                ),
              ),
              bottomNavigationBar: ActivityList(),
            ),
          ],
        ),
      ),
    );
  }
}

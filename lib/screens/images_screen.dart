import 'package:flutter/material.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/ui/activity_icons.dart';
import 'package:ididit/ui/color_theme.dart';
import 'package:ididit/widgets/activity_icon.dart';

class ImagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: GridView.count(
            // Put images into two columns.
            crossAxisCount: 2,
            children: List.generate(ActivityIcons.values.length, (i) {
              return TextButton(
                onPressed: () {
                  Navigator.pop(context, i);
                },
                child: Center(
                  child: ActivityIcon(
                    Activity.indexIcon(i),
                    color: ThemeColors.inkColor,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/icon_names.dart';
import 'package:ididit/ui/color_theme.dart';

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
            children: List.generate(iconNames.length, (i) {
              return Center(
                child: SvgPicture.asset(
                  Activity.indexIcon(i),
                  color: ThemeColors.darkBlue,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

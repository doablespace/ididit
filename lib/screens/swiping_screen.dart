import 'package:flutter/material.dart';
import 'package:ididit/ui/background_decoration.dart';
import 'package:ididit/widgets/activity_list.dart';

class SwipingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BackgroundDecoration(3.0, 0.45),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Text('body'),
          bottomNavigationBar: ActivityList(),
        ),
      ),
    );
  }
}

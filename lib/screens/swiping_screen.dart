import 'package:flutter/material.dart';
import 'package:ididit/widgets/activity_list.dart';

class SwipingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('body'),
      bottomNavigationBar: ActivityList(),
    );
  }
}

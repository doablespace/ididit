import 'package:flutter/material.dart';

class ActivityBox extends StatelessWidget {
  final Color color;
  final Widget child;

  const ActivityBox({Key key, this.color, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(50),
        child: child,
      ),
    );
  }
}

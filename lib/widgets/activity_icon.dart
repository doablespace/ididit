import 'package:flutter/material.dart';

class ActivityIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double size;

  const ActivityIcon(this.iconData, {Key key, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      return _SizedActivityIcon(iconData, color: color, size: size);
    }

    return LayoutBuilder(builder: (context, constraints) {
      return _SizedActivityIcon(
        iconData,
        color: color,
        size: constraints.biggest.shortestSide,
      );
    });
  }
}

class _SizedActivityIcon extends StatelessWidget {
  final IconData iconData;
  final Color color;
  final double size;

  const _SizedActivityIcon(
    this.iconData, {
    Key key,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: size * 0.2),
      child: Icon(
        iconData,
        color: color,
        size: size * 0.7,
      ),
    );
  }
}

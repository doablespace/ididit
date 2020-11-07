import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActivityIcon extends StatelessWidget {
  final String asset;
  final Color color;
  final double size;

  const ActivityIcon({Key key, this.asset, this.color, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      asset,
      color: color,
      width: size,
      height: size,
    );
  }
}

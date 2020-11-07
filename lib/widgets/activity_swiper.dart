import 'package:flutter/material.dart';
import 'package:ididit/ui/color_theme.dart';

class ActivitySwiper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Dismissible(
          key: UniqueKey(),
          child: Dismissible(
            key: UniqueKey(),
            child: InkWell(
              onTap: () {},
              child: _ActivityBackground(
                color: ActivityColors.accentGreen,
                child: Center(child: Text('body')),
              ),
            ),
            background: _ActivityBackground(color: ThemeColors.pastelYellow),
            secondaryBackground:
                _ActivityBackground(color: ThemeColors.pastelGrey),
          ),
          direction: DismissDirection.vertical,
          background: _ActivityBackground(color: ThemeColors.pastelRed),
          secondaryBackground:
              _ActivityBackground(color: ThemeColors.pastelGreen),
        ),
      ),
    );
  }
}

class _ActivityBackground extends StatelessWidget {
  final Color color;
  final Widget child;

  const _ActivityBackground({Key key, this.color, this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(50),
      ),
      width: 280,
      height: 280,
      child: child,
    );
  }
}

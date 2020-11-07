import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ididit/models/activity.dart';
import 'package:ididit/models/activity_log_entry.dart';
import 'package:ididit/models/model_provider.dart';
import 'package:ididit/ui/color_theme.dart';

class _Sizes {
  final double box;
  final double radius;
  final double shadow;
  final double padding;
  final double icon;
  final double stateIcon;
  final double stateFontSize;

  _Sizes._(this.box, this.radius, this.shadow, this.padding, this.icon,
      this.stateIcon, this.stateFontSize);

  factory _Sizes(double box) {
    box ??= 280;
    final radius = box / 5.6; // 50
    final shadow = box / 70; // 4
    final padding = box / 35; // 8
    final icon = box - 2 * radius; // 180
    final stateIcon = radius - padding; // 42
    final stateFontSize = stateIcon / 2; // 24
    return _Sizes._(
        box, radius, shadow, padding, icon, stateIcon, stateFontSize);
  }
}

class ActivityBox extends StatelessWidget {
  final Color color;
  final Widget child;
  final _Sizes _sizes;

  ActivityBox({Key key, this.color, this.child, double size})
      : _sizes = _Sizes(size),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _sizes.box,
      height: _sizes.box,
      child: Material(
        color: color,
        borderRadius: BorderRadius.circular(_sizes.radius),
        child: child,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_sizes.radius),
        boxShadow: [
          BoxShadow(
            color: ThemeColors.darkBlue.withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: _sizes.shadow,
            offset: Offset(0, _sizes.shadow), // changes position of shadow
          ),
        ],
      ),
    );
  }
}

/// [ActivityBox] + Icon + State indicator.
class StatefulActivityBox extends StatelessWidget {
  final Activity activity;
  final _Sizes _sizes;

  StatefulActivityBox({Key key, this.activity, double size})
      : _sizes = _Sizes(size),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ModelProvider<ActivityLogEntry>(
      value: activity.logEntry,
      builder: (context, logEntry, child) {
        final state = logEntry?.state;
        return ActivityBox(
          color: activity.accent,
          child: InkWell(
            borderRadius: BorderRadius.circular(_sizes.radius),
            onTap: () {},
            child: Stack(
              children: [
                // Activity icon
                Center(
                  child: SvgPicture.asset(
                    activity.iconAsset,
                    color: ThemeColors.darkBlue,
                    width: _sizes.icon,
                    height: _sizes.icon,
                  ),
                ),

                // Status indicator
                if (state != null)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: state.color,
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(_sizes.radius)),
                      ),
                      height: _sizes.radius,
                      width: _sizes.box,
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: _sizes.radius),
                      child: Row(
                        children: [
                          Icon(state.iconData, size: _sizes.stateIcon),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: _sizes.padding),
                            child: Text(
                              state.text,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: _sizes.stateFontSize,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

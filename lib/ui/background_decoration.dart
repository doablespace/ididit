import 'package:flutter/material.dart';
import 'color_theme.dart';

/// Applies the titled split background to a screen.
/// Wrap in a `Container` widget and set as its decoration property.
/// The `Container`'s child should be a `Scaffold` with transparent `backgroundColor`.
///
/// Params:
/// - direction: {-1 (left lower) / 1 (right lower)}
/// Experimentally set parameters:
/// - Swiping screen: 3.0, 0.45
class BackgroundDecoration extends BoxDecoration {
  BackgroundDecoration(double verticalProlongation, double midPoint,
      {int direction: 1})
      : super(
            gradient: LinearGradient(
                colors: [
                  ThemeColors.lightGrey,
                  ThemeColors.lightGrey,
                  ThemeColors.lightBlue,
                  ThemeColors.lightBlue,
                ],
                begin: Alignment(direction * 1.0, -verticalProlongation),
                end: Alignment(direction * -1.0, verticalProlongation),
                tileMode: TileMode.clamp,
                stops: [0, midPoint, midPoint, 1]));
}

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
/// - Edit screen: 4.0, 0.43
class BackgroundDecoration extends BoxDecoration {
  BackgroundDecoration(double verticalProlongation, double midPoint,
      {int direction: 1})
      : super(
            gradient: LinearGradient(
                colors: [
                  ThemeColors.upperBackground,
                  ThemeColors.upperBackground,
                  ThemeColors.lowerBackground,
                  ThemeColors.lowerBackground,
                ],
                begin: Alignment(direction * 1.0, -verticalProlongation),
                end: Alignment(direction * -1.0, verticalProlongation),
                tileMode: TileMode.clamp,
                stops: [0, midPoint, midPoint, 1]));
}

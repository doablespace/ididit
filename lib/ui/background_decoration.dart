import 'package:flutter/material.dart';

import 'color-theme.dart';

/// Applies the titled split background to a screen.
/// Wrap in a `Container` widget and set as its decoration property.
/// The `Container`'s child should be a `Scaffold` with transparent `backgroundColor`.
///
/// Experimentally set parameters:
/// - Activity screen: 3, 0.45
class BackgroundDecoration extends BoxDecoration {
  BackgroundDecoration(verticalProlongation, midPoint)
      : super(
            gradient: LinearGradient(
                colors: [
                  ThemeColors.lightGrey,
                  ThemeColors.lightGrey,
                  ThemeColors.lightBlue,
                  ThemeColors.lightBlue,
                ],
                begin: Alignment(-1, -verticalProlongation),
                end: Alignment(1, verticalProlongation),
                tileMode: TileMode.clamp,
                stops: [0, midPoint, midPoint, 1]));
}

import 'dart:ui';

class ThemeColors {
  // General app theme.
  static var inkColor = Color(0xff27363F);
  static var lowerBackground = Color(0xff27363F);
  static var upperBackground = Color(0xffffffff);

  // Swiping colors.
  static var yesColor = Color(0xff87EFB1);
  static var noColor = Color(0xffEF8787);
  static var almostColor = Color(0xffE2F08C);
  static var skipColor = Color(0xffE5E5E5);
}

class ActivityColors {
  // Ink is background. Accent are details.
  static var inkRed = Color(0xffF9D5D2);
  static var accentRed = Color(0xffEF968E);

  static var inkBlue = Color(0xffD2ECF9);
  static var accentBlue = Color(0xff8FCFEF);

  static var inkGreen = Color(0xffD2F9F9);
  static var accentGreen = Color(0xff8FEFEF);

  static var inkPurple = Color(0xffD2D2F9);
  static var accentPurple = Color(0xff8F8FEF);

  static var inkOrange = Color(0xffF9E9D2);
  static var accentOrange = Color(0xffEFC78F);

  static var inkYellow = Color(0xffF9F9D2);
  static var accentYellow = Color(0xffEFEF8F);

  static var inkPink = Color(0xffF9D2F9);
  static var accentPink = Color(0xffEF8FEF);

  static var colors = [
    {'ink': inkRed, 'accent': accentRed},
    {'ink': inkBlue, 'accent': accentBlue},
    {'ink': inkGreen, 'accent': accentGreen},
    {'ink': inkPurple, 'accent': accentPurple},
    {'ink': inkOrange, 'accent': accentOrange},
    {'ink': inkYellow, 'accent': accentYellow},
    {'ink': inkPink, 'accent': accentPink}
  ];
}

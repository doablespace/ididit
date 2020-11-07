import 'dart:ui';

class ThemeColors {
  // General app theme.
  static var darkBlue = Color(0xff27363F);
  static var lightBlue = Color(0xff4A6572);
  static var lightGrey = Color(0xffC4C4C4);

  // Swiping colors.
  static var pastelGreen = Color(0xff87EFB1);
  static var pastelRed = Color(0xffEF8787);
  static var pastelYellow = Color(0xffE2F08C);
  static var pastelGrey = Color(0xffE5E5E5);
}

class ActivityColors {
  // Ink is background. Accent are details.
  static var inkRed = Color(0xffF9D5D2);
  static var accentRed = Color(0xffEF968E);
  static var red = {'ink': inkRed, 'accent': accentRed};

  static var inkBlue = Color(0xffD2ECF9);
  static var accentBlue = Color(0xff8FCFEF);
  static var blue = {'ink': inkBlue, 'accent': accentBlue};

  static var inkGreen = Color(0xffD2F9F9);
  static var accentGreen = Color(0xff8FEFEF);
  static var green = {'ink': inkGreen, 'accent': accentGreen};

  static var inkPurple = Color(0xffD2D2F9);
  static var accentPurple = Color(0xff8F8FEF);
  static var purple = {'ink': inkPurple, 'accent': accentPurple};

  static var inkOrange = Color(0xffF9E9D2);
  static var accentOrange = Color(0xffEFC78F);
  static var orange = {'ink': inkOrange, 'accent': accentOrange};

  static var inkYellow = Color(0xffF9F9D2);
  static var accentYellow = Color(0xffEFEF8F);
  static var yellow = {'ink': inkYellow, 'accent': accentYellow};

  static var inkPink = Color(0xffF9D2F9);
  static var accentPink = Color(0xffEF8FEF);
  static var pink = {'ink': inkPink, 'accent': accentPink};
}

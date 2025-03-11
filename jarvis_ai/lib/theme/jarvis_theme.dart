import 'package:flutter/material.dart';

class JarvisTheme {
  final ThemeData themeData;

  JarvisTheme._(this.themeData);

  static JarvisTheme of(BuildContext context) {
    return JarvisTheme._(Theme.of(context));
  }

  Color get primary => themeData.primaryColor;
  Color get secondary => Color(0xFF06D5CD);
  Color get primaryText => Color(0xFF101518);
  Color get alternate => Color(0xFFE0E3E7);
  Color get primaryBackground => Color(0xFFF1F4F8);
  Color get secondaryText => Color(0xFF757575);
  Color get secondaryBackground => Color(0xFFFFFFFF);
  Color get info => Color(0xFFFFFFFF);
  Color get accent1 => Color(0x4C4B39EF);
  TextStyle get displaySmall =>
      _overrideStyle(themeData.textTheme.headlineSmall);
  TextStyle get headlineSmall =>
      _overrideStyle(themeData.textTheme.headlineSmall);
  TextStyle get bodyMedium => _overrideStyle(themeData.textTheme.bodyMedium);
  TextStyle get bodyLarge => themeData.textTheme.bodyLarge ?? TextStyle();
  TextStyle get bodySmall => themeData.textTheme.bodySmall ?? TextStyle();
  TextStyle get labelMedium => themeData.textTheme.labelMedium ?? TextStyle();
  TextStyle get labelLarge => themeData.textTheme.labelLarge ?? TextStyle();
  TextStyle get titleSmall => themeData.textTheme.titleSmall ?? TextStyle();
  TextStyle get labelSmall => themeData.textTheme.labelSmall ?? TextStyle();

  TextStyle _overrideStyle(
    TextStyle? baseStyle, {
    String? fontFamily,
    Color? color,
    double? letterSpacing,
    FontWeight? fontWeight,
    List<Shadow>? shadows,
  }) {
    return (baseStyle ?? TextStyle()).copyWith(
      fontFamily: fontFamily ?? baseStyle?.fontFamily,
      color: color ?? baseStyle?.color,
      letterSpacing: letterSpacing ?? baseStyle?.letterSpacing,
      fontWeight: fontWeight ?? baseStyle?.fontWeight,
      shadows: shadows ?? baseStyle?.shadows,
    );
  }
}

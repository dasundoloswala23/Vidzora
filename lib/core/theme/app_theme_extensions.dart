import 'package:flutter/material.dart';

extension ThemeContextX on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textStyles => Theme.of(this).textTheme;
  Color get dividerColor => Theme.of(this).dividerColor;
  Color get cardColor => Theme.of(this).cardColor;
}

import 'package:flutter/material.dart';

class GeminiTheme {
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bg(BuildContext c) =>
      Theme.of(c).colorScheme.surface;

  static Color card(BuildContext c) =>
      Theme.of(c).colorScheme.surfaceVariant;

  static Color text(BuildContext c) =>
      Theme.of(c).colorScheme.onSurface;

  static Color hint(BuildContext c) =>
      Theme.of(c).hintColor;

  static Color accent(BuildContext c) =>
      Theme.of(c).colorScheme.primary;
}

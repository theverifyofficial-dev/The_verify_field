import 'package:flutter/material.dart';

class AppCardTheme {
  /// Main fitness & dashboard card gradient
  static LinearGradient mainGradient(bool isDark) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: isDark
          ? [
        Colors.grey.shade900,
        Colors.black87,
        Colors.grey.shade900,
      ]
          : [
        Colors.white,
        Colors.white,
      ],
    );
  }

  /// Shadow used across the whole app
  static BoxShadow mainShadow(bool isDark) {
    return BoxShadow(
      color: Colors.black.withOpacity(isDark ? 0.40 : 0.15),
      blurRadius: 25,
      spreadRadius: 1,
      offset: const Offset(0, 12),
    );
  }

  /// Light radial glow in top-right corner
  static Widget glow(bool isDark) {
    return Positioned(
      top: -25,
      right: -25,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              (isDark
                  ? Colors.blueAccent.withOpacity(0.12)
                  : Colors.blueAccent.withOpacity(0.06)),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  /// Applies same decoration across all big cards
  static BoxDecoration cardDecoration(bool isDark) {
    return BoxDecoration(
      gradient: mainGradient(isDark),
      borderRadius: BorderRadius.circular(24),
      boxShadow: [mainShadow(isDark)],
    );
  }

  /// For inner small items inside the main card (optional)
  static BoxDecoration innerItem(bool isDark) {
    return BoxDecoration(
      color: isDark ? Colors.black.withOpacity(0.20) : Colors.white.withOpacity(0.6),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade300,
      ),
    );
  }
}

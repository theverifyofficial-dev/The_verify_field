import 'package:flutter/foundation.dart';

class AppLogger {
  AppLogger._();

  /// 🔥 ye values main.dart se set hongi
  static bool enableDebugLogs = true;
  static bool enableReleaseLogs = false;

  static bool get _shouldLog {
    if (kDebugMode) return enableDebugLogs;
    return enableReleaseLogs;
  }

  static void log(String message, {String tag = 'APP'}) {
    if (_shouldLog) debugPrint('[$tag] $message');
  }

  static void api(String message) {
    if (_shouldLog) debugPrint('[API] $message');
  }

  static void error(String message,
      {Object? error, StackTrace? stackTrace}) {
    if (_shouldLog) {
      debugPrint('[ERROR] $message');
      if (error != null) debugPrint('$error');
      if (stackTrace != null) debugPrint('$stackTrace');
    }
  }

  static void warn(String message) {
    if (_shouldLog) debugPrint('[WARN] $message');
  }

  static void info(String message, {required Object err}) {
    if (_shouldLog) debugPrint('[INFO] $message');
  }
}
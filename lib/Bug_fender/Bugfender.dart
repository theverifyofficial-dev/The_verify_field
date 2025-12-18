import 'dart:convert';
import 'dart:ui';
import 'package:flutter_bugfender/flutter_bugfender.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BugLogger {
  static const String _backendApi =
      "https://verifyserve.social/Second%20PHP%20FILE/bug_founder/bug_founder.php";

  /// 🔥 CALL ONLY ONCE (main.dart)
  static Future<void> init() async {
    await FlutterBugfender.init(
      "YOUR_BUGFENDER_APP_KEY",
      enableAndroidLogcatLogging: true,
      printToConsole: kDebugMode,
    );
  }

  /// 🔹 Normal logs (optional)
  static void log(String message, {String screen = "UNKNOWN"}) {
    FlutterBugfender.log("[SCREEN: $screen] $message");
  }

  /// 🔹 Error log (Bugfender + Backend)
  static Future<void> logError({
    required String screen,
    required String error,
    String? api,
    int? statusCode,
  }) async {
    // 🟢 1. Bugfender
    FlutterBugfender.error(
      "❌ SCREEN: $screen\n"
          "API: ${api ?? '-'}\n"
          "STATUS: ${statusCode ?? '-'}\n"
          "ERROR: $error",
    );

    // 🔴 2. Backend (avoid infinite loop)
    if (api != null && api.contains("bug_founder.php")) return;

    try {
      final now = DateTime.now();

      await http.post(
        Uri.parse(_backendApi),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "API_link": api ?? screen,
          "error": error,
          "status_code": statusCode?.toString() ?? "500",
          "date":
          "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
          "time":
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}",
        }),
      );
    } catch (_) {
      // ❌ backend failure ko dobara log nahi karna
    }
  }
}
Future<dynamic> apiGet(String url, {String screen = "API"}) async {
  try {
    BugLogger.log("API CALL → $url", screen: screen);

    final response = await http.get(Uri.parse(url));

    BugLogger.log(
      "API RESPONSE → ${response.statusCode}",
      screen: screen,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      await BugLogger.logError(
        screen: screen,
        api: url,
        statusCode: response.statusCode,
        error: response.body,
      );
    }
  } catch (e) {
    await BugLogger.logError(
      screen: screen,
      api: url,
      error: e.toString(),
    );
  }
}

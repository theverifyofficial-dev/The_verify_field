import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class BugLogger {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // 🔹 INTERNAL SENDER (never crashes app)
  static Future<void> _send({
    required String apiLink,
    required String error,
    int statusCode = 0,
  }) async {
    try {
      final now = DateTime.now();

      final formData = FormData.fromMap({
        "API_link": apiLink,
        "error": error.length > 3000 ? error.substring(0, 3000) : error,
        "status_code": statusCode.toString(),
        "date": DateFormat('yyyy-MM-dd').format(now),
        "time": DateFormat('HH:mm:ss').format(now),
      });

      print("🐞 BUG LOGGER CALLED");
      print("API: $apiLink");
      print("ERROR: $error");
      print("STATUS: $statusCode");
      print("Time: ${DateFormat('HH:mm:ss').format(now)}");

      await _dio.post(
        "https://verifyserve.social/Second%20PHP%20FILE/bug_founder/bug_founder.php",
        data: formData,
      );
    } catch (_) {
      // ❌ Silent fail (never crash app)
    }
  }

  // ✅ API / BACKEND ERROR
  static Future<void> log({
    required String apiLink,
    required String error,
    required int statusCode,
  }) async {
    await _send(
      apiLink: apiLink,
      error: error,
      statusCode: statusCode,
    );
  }

  // ✅ NETWORK / DIO / TIMEOUT ERROR
  static Future<void> logException(
      String api, Object exception) async {
    if (exception is DioException) {
      await _send(
        apiLink: api,
        error: exception.message ?? 'Dio error',
        statusCode: exception.response?.statusCode ?? 0,
      );
    } else if (exception is SocketException) {
      await _send(
        apiLink: api,
        error: 'No Internet Connection',
        statusCode: 0,
      );
    } else if (exception is TimeoutException) {
      await _send(
        apiLink: api,
        error: 'Request Timeout',
        statusCode: 0,
      );
    } else {
      await _send(
        apiLink: api,
        error: exception.toString(),
        statusCode: 0,
      );
    }
  }

  // ✅ FLUTTER UI ERROR
  static Future<void> logFlutterError(
      FlutterErrorDetails details) async {
    await _send(
      apiLink: 'FLUTTER_UI',
      error: details.exceptionAsString() +
          '\n\n' +
          (details.stack?.toString() ?? ''),
    );
  }

  // ✅ ASYNC / ISOLATE ERROR
  static Future<void> logDartError(
      Object error, StackTrace stack) async {
    await _send(
      apiLink: 'DART_ASYNC',
      error: error.toString() + '\n\n$stack',
    );
  }
}

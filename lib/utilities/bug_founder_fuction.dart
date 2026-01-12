import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class BugLogger {
  static final Dio _dio = Dio();

  static Future<void> log({
    required String apiLink,
    required String error,
    required int statusCode,
  }) async {
    try {
      final now = DateTime.now();

      final formData = FormData.fromMap({
        "API_link": apiLink,
        "error": error,
        "status_code": statusCode.toString(),
        "date": DateFormat('yyyy-MM-dd').format(now),
        "time": DateFormat('HH:mm:ss').format(now),
      });
      print(DateFormat('HH:mm:ss').format(now),);
      await _dio.post(
        "https://verifyserve.social/Second%20PHP%20FILE/bug_founder/bug_founder.php",
        data: formData,
      );
    } catch (_) {
      // ❌ DO NOTHING
      // Bug logger should NEVER crash your app
    }
  }
}

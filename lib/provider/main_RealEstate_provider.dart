import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class PropertyProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Dio _dio = Dio();

  Future<bool> submitProperty(Map<String, dynamic> data, {File? imageFile}) async {
    const String apiUrl = "https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php";

    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> payload = data.map((key, value) => MapEntry(key, value?.toString() ?? ''));

      if (imageFile != null) {
        payload['property_photo'] = await MultipartFile.fromFile(imageFile.path, filename: 'photo.jpg');
      }

      final formData = FormData.fromMap(payload);

      final response = await _dio.post(
        apiUrl,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          headers: {
            'User-Agent': 'Mozilla/5.0',
            'Accept': '*/*',
            'Referer': 'https://verifyserve.social/',
          },
        ),
      );

      _isLoading = false;
      notifyListeners();

      print('✅ Status: ${response.statusCode}');
      print('✅ Body: ${response.data}');

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final responseData = response.data;
        return responseData['success'] == true || responseData['status'] == 1;
      } else {
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("❌ Dio error: $e");
      return false;
    }
  }
}
